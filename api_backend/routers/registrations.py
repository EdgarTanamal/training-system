from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Registration, Participant, Class
from schemas import (
    RegistrationCreate,
    ParticipantClassView,
    ClassParticipantView,
)

router = APIRouter(prefix="/registrations", tags=["Registrations"])


@router.post("/")
def create_registration(data: RegistrationCreate, db: Session = Depends(get_db)):
    participant = db.query(Participant).filter(Participant.id == data.participant_id).first()
    if not participant:
        raise HTTPException(status_code=404, detail="Participant not found")

    course_class = db.query(Class).filter(Class.id == data.class_id).first()
    if not course_class:
        raise HTTPException(status_code=404, detail="Class not found")

    existing = (
        db.query(Registration)
        .filter(
            Registration.participant_id == data.participant_id,
            Registration.class_id == data.class_id,
            Registration.status == "active",
        )
        .first()
    )
    if existing:
        raise HTTPException(status_code=400, detail="Already registered")

    reg = Registration(participant_id=data.participant_id, class_id=data.class_id)
    db.add(reg)
    db.commit()
    db.refresh(reg)
    return {"message": "Registration created", "id": reg.id}


@router.get("/participant/{participant_id}/classes", response_model=list[ParticipantClassView])
def classes_for_participant(participant_id: int, db: Session = Depends(get_db)):
    rows = (
        db.query(
            Registration.id.label("registration_id"),
            Class.id.label("class_id"),
            Class.code,
            Class.title,
            Class.description,
            Class.start_date,
            Class.end_date,
        )
        .join(Class, Class.id == Registration.class_id)
        .filter(
            Registration.participant_id == participant_id,
            Registration.status == "active",
            Class.is_active == 1,
        )
        .all()
    )

    return [
        ParticipantClassView(
            registration_id=r.registration_id,
            class_id=r.class_id,
            code=r.code,
            title=r.title,
            description=r.description,
            start_date=r.start_date,
            end_date=r.end_date,
        )
        for r in rows
    ]


@router.get("/class/{class_id}/participants", response_model=list[ClassParticipantView])
def participants_for_class(class_id: int, db: Session = Depends(get_db)):
    rows = (
        db.query(
            Registration.id.label("registration_id"),
            Participant.id.label("participant_id"),
            Participant.name,
            Participant.email,
            Participant.phone,
        )
        .join(Participant, Participant.id == Registration.participant_id)
        .filter(
            Registration.class_id == class_id,
            Registration.status == "active",
            Participant.is_active == 1,
        )
        .all()
    )

    return [
        ClassParticipantView(
            registration_id=r.registration_id,
            participant_id=r.participant_id,
            name=r.name,
            email=r.email,
            phone=r.phone,
        )
        for r in rows
    ]


@router.delete("/{registration_id}")
def cancel_registration(registration_id: int, db: Session = Depends(get_db)):
    reg = db.query(Registration).filter(Registration.id == registration_id).first()
    if not reg:
        raise HTTPException(status_code=404, detail="Registration not found")
    reg.status = "canceled"
    db.commit()
    return {"message": "Registration canceled"}
