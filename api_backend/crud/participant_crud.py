from sqlalchemy.orm import Session
from models.participant_model import Participant
from schemas.participant_schema import ParticipantCreate, ParticipantUpdate

def get_participants(db: Session):
    return db.query(Participant).filter(Participant.is_active == True).all()

def get_participant(db: Session, participant_id: int):
    return db.query(Participant).filter(
        Participant.id == participant_id,
        Participant.is_active == True
    ).first()

def create_participant(db: Session, data: ParticipantCreate):
    obj = Participant(
        name=data.name,
        email=data.email,
        phone=data.phone,
    )
    db.add(obj)
    db.commit()
    db.refresh(obj)
    return obj

def update_participant(db: Session, participant_id: int, data: ParticipantUpdate):
    obj = get_participant(db, participant_id)
    if not obj:
        return None
    obj.name = data.name
    obj.email = data.email
    obj.phone = data.phone
    db.commit()
    db.refresh(obj)
    return obj

def delete_participant(db: Session, participant_id: int):
    obj = get_participant(db, participant_id)
    if not obj:
        return None
    obj.is_active = False
    db.commit()
    return obj
