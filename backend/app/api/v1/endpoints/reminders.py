from datetime import datetime, timezone, timedelta
from uuid import uuid4

from fastapi import APIRouter, HTTPException, Query, Depends
from motor.motor_asyncio import AsyncIOMotorDatabase

from app.db.session import get_database
from app.schemas.reminder import Reminder, ReminderCreate, ReminderUpdate

router = APIRouter()

COLLECTION_NAME = "reminders"


@router.get("/", response_model=list[Reminder])
async def list_reminders(
	status: str | None = Query(default=None),
	db: AsyncIOMotorDatabase = Depends(get_database),
):
	query = {}
	if status:
		query["status"] = status
	
	cursor = db[COLLECTION_NAME].find(query).sort("remind_at", 1)
	reminders = await cursor.to_list(length=100)
	return reminders


@router.post("/", response_model=Reminder)
async def create_reminder(
	payload: ReminderCreate,
	db: AsyncIOMotorDatabase = Depends(get_database),
):
	now = datetime.now(timezone.utc)
	reminder_data = payload.model_dump()
	reminder_data.update({
		"id": str(uuid4()),
		"owner_id": "demo-user",
		"created_at": now,
		"updated_at": now,
		"snooze_count": 0,
		"last_snoozed_at": None
	})
	
	await db[COLLECTION_NAME].insert_one(reminder_data)
	return reminder_data


@router.get("/{reminder_id}", response_model=Reminder)
async def get_reminder(
	reminder_id: str,
	db: AsyncIOMotorDatabase = Depends(get_database),
):
	reminder = await db[COLLECTION_NAME].find_one({"id": reminder_id})
	if not reminder:
		raise HTTPException(status_code=404, detail="Reminder not found")
	return reminder


@router.patch("/{reminder_id}", response_model=Reminder)
async def update_reminder(
	reminder_id: str,
	payload: ReminderUpdate,
	db: AsyncIOMotorDatabase = Depends(get_database),
):
	reminder = await db[COLLECTION_NAME].find_one({"id": reminder_id})
	if not reminder:
		raise HTTPException(status_code=404, detail="Reminder not found")

	update_data = payload.model_dump(exclude_unset=True)
	update_data["updated_at"] = datetime.now(timezone.utc)
	
	await db[COLLECTION_NAME].update_one(
		{"id": reminder_id},
		{"$set": update_data}
	)
	
	updated_reminder = await db[COLLECTION_NAME].find_one({"id": reminder_id})
	return updated_reminder


@router.post("/{reminder_id}/snooze", response_model=Reminder)
async def snooze_reminder(
	reminder_id: str,
	db: AsyncIOMotorDatabase = Depends(get_database),
):
	reminder = await db[COLLECTION_NAME].find_one({"id": reminder_id})
	if not reminder:
		raise HTTPException(status_code=404, detail="Reminder not found")

	now = datetime.now(timezone.utc)
	new_remind_at = now + timedelta(minutes=10)
	
	update_data = {
		"remind_at": new_remind_at,
		"snooze_count": reminder.get("snooze_count", 0) + 1,
		"last_snoozed_at": now,
		"updated_at": now,
		"status": "pending"
	}
	
	await db[COLLECTION_NAME].update_one(
		{"id": reminder_id},
		{"$set": update_data}
	)
	
	updated_reminder = await db[COLLECTION_NAME].find_one({"id": reminder_id})
	return updated_reminder


@router.delete("/{reminder_id}")
async def delete_reminder(
	reminder_id: str,
	db: AsyncIOMotorDatabase = Depends(get_database),
):
	result = await db[COLLECTION_NAME].delete_one({"id": reminder_id})
	if result.deleted_count == 0:
		raise HTTPException(status_code=404, detail="Reminder not found")
	return {"message": "Reminder deleted", "id": reminder_id}
