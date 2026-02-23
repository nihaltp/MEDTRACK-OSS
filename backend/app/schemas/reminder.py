from datetime import datetime
from typing import Literal, Optional

from pydantic import BaseModel, model_validator


class ReminderBase(BaseModel):
	title: str
	medication_id: str
	remind_at: datetime
	expires_at: Optional[datetime] = None
	channel: Literal["email", "sms", "push"] = "push"
	status: Literal["pending", "sent", "completed", "failed"] = "pending"
	notes: Optional[str] = None
	snooze_count: int = 0
	last_snoozed_at: Optional[datetime] = None

	@model_validator(mode="after")
	def validate_dates(self):
		if self.expires_at and self.expires_at <= self.remind_at:
			raise ValueError("expires_at must be later than remind_at")
		return self


class ReminderCreate(ReminderBase):
	pass


class ReminderUpdate(BaseModel):
	title: Optional[str] = None
	medication_id: Optional[str] = None
	remind_at: Optional[datetime] = None
	expires_at: Optional[datetime] = None
	channel: Optional[Literal["email", "sms", "push"]] = None
	status: Optional[Literal["pending", "sent", "completed", "failed"]] = None
	notes: Optional[str] = None
	snooze_count: Optional[int] = None
	last_snoozed_at: Optional[datetime] = None


class Reminder(ReminderBase):
	id: str
	owner_id: str = "demo-user"
	created_at: datetime
	updated_at: datetime
