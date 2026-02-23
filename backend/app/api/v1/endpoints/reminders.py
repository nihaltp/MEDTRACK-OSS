from datetime import datetime, timezone
from uuid import uuid4

from fastapi import APIRouter, HTTPException, Query

from app.schemas.reminder import Reminder, ReminderCreate, ReminderUpdate

router = APIRouter()

reminder_store: dict[str, Reminder] = {}


@router.get("/", response_model=list[Reminder])
async def list_reminders(status: str | None = Query(default=None)):
	reminders = list(reminder_store.values())
	if status:
		reminders = [item for item in reminders if item.status == status]
	return sorted(reminders, key=lambda item: item.remind_at)


@router.post("/", response_model=Reminder)
async def create_reminder(payload: ReminderCreate):
	now = datetime.now(timezone.utc)
	reminder = Reminder(
		id=str(uuid4()),
		created_at=now,
		updated_at=now,
		**payload.model_dump(),
	)
	reminder_store[reminder.id] = reminder
	return reminder


@router.get("/{reminder_id}", response_model=Reminder)
async def get_reminder(reminder_id: str):
	reminder = reminder_store.get(reminder_id)
	if not reminder:
		raise HTTPException(status_code=404, detail="Reminder not found")
	return reminder


@router.patch("/{reminder_id}", response_model=Reminder)
async def update_reminder(reminder_id: str, payload: ReminderUpdate):
	reminder = reminder_store.get(reminder_id)
	if not reminder:
		raise HTTPException(status_code=404, detail="Reminder not found")

	merged_payload = {
		**reminder.model_dump(),
		**payload.model_dump(exclude_unset=True),
		"updated_at": datetime.now(timezone.utc),
	}
	updated_reminder = Reminder.model_validate(merged_payload)
	reminder_store[reminder_id] = updated_reminder
	return updated_reminder


@router.delete("/{reminder_id}")
async def delete_reminder(reminder_id: str):
	if reminder_id not in reminder_store:
		raise HTTPException(status_code=404, detail="Reminder not found")
	del reminder_store[reminder_id]
	return {"message": "Reminder deleted", "id": reminder_id}
