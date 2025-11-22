from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Participant
from schemas import ParticipantCreate, ParticipantOut, ParticipantUpdate

router = APIRouter(prefix="/participants", tags=["Participants"])


@router.post("/", response_model=ParticipantOut)
def create_participant(data: ParticipantCreate, db: Session = Depends(get_db)):
    participant = Participant(**data.dict())
    db.add(participant)
    db.commit()
    db.refresh(participant)
    return participant


@router.get("/", response_model=list[ParticipantOut])
def list_participants(db: Session = Depends(get_db)):
    return (
        db.query(Participant)
        .filter(Participant.is_active == 1)
        .order_by(Participant.created_at.desc())
        .all()
    )


@router.get("/{participant_id}", response_model=ParticipantOut)
def get_participant(participant_id: int, db: Session = Depends(get_db)):
    participant = db.query(Participant).filter(Participant.id == participant_id).first()
    if not participant:
        raise HTTPException(status_code=404, detail="Participant not found")
    return participant


@router.put("/{participant_id}", response_model=ParticipantOut)
def update_participant(
    participant_id: int,
    data: ParticipantUpdate,
    db: Session = Depends(get_db),
):
    participant = db.query(Participant).filter(Participant.id == participant_id).first()
    if not participant:
        raise HTTPException(status_code=404, detail="Participant not found")

    for key, value in data.dict(exclude_unset=True).items():
        setattr(participant, key, value)

    db.commit()
    db.refresh(participant)
    return participant


@router.delete("/{participant_id}")
def delete_participant(participant_id: int, db: Session = Depends(get_db)):
    participant = db.query(Participant).filter(Participant.id == participant_id).first()
    if not participant:
        raise HTTPException(status_code=404, detail="Participant not found")

    participant.is_active = 0
    db.commit()
    return {"message": "Participant deleted (soft delete)"}
