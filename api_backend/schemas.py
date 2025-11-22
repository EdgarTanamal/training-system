from pydantic import BaseModel
from datetime import date


# ---------- PARTICIPANT ----------

class ParticipantBase(BaseModel):
    name: str
    email: str | None = None
    phone: str | None = None


class ParticipantCreate(ParticipantBase):
    pass


class ParticipantUpdate(BaseModel):
    name: str | None = None
    email: str | None = None
    phone: str | None = None


class ParticipantOut(ParticipantBase):
    id: int

    class Config:
        orm_mode = True


# ---------- CLASS ----------

class ClassBase(BaseModel):
    code: str
    title: str
    description: str | None = None
    start_date: date | None = None
    end_date: date | None = None


class ClassCreate(ClassBase):
    pass


class ClassUpdate(BaseModel):
    code: str | None = None
    title: str | None = None
    description: str | None = None
    start_date: date | None = None
    end_date: date | None = None


class ClassOut(ClassBase):
    id: int

    class Config:
        orm_mode = True


# ---------- REGISTRATION ----------

class RegistrationCreate(BaseModel):
    participant_id: int
    class_id: int


class ParticipantClassView(BaseModel):
    registration_id: int
    class_id: int
    code: str
    title: str
    description: str | None = None
    start_date: date | None = None
    end_date: date | None = None

    class Config:
        orm_mode = True


class ClassParticipantView(BaseModel):
    registration_id: int
    participant_id: int
    name: str
    email: str | None = None
    phone: str | None = None

    class Config:
        orm_mode = True
