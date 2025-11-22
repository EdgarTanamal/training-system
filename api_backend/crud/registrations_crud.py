from sqlalchemy.orm import Session
from models.registration_model import Registration
from models.participant_model import Participant
from models.class_model import TrainingClass
from schemas.registration_schema import RegistrationCreate


def register_participant(db: Session, data: RegistrationCreate):
    """Daftarkan peserta ke kelas"""
    
    # Pastikan kelas & peserta aktif
    participant = db.query(Participant).filter(
        Participant.id == data.participant_id,
        Participant.is_active == True
    ).first()
    
    training_class = db.query(TrainingClass).filter(
        TrainingClass.id == data.class_id,
        TrainingClass.is_active == True
    ).first()
    
    if not participant or not training_class:
        return None  # Handle ini nanti di router

    obj = Registration(
        participant_id=data.participant_id,
        class_id=data.class_id
    )
    db.add(obj)
    db.commit()
    db.refresh(obj)
    return obj


def get_classes_by_participant(db: Session, participant_id: int):
    """List kelas yang diikuti peserta"""
    return db.query(Registration).filter(
        Registration.participant_id == participant_id,
        Registration.status == "active"
    ).all()


def get_participants_by_class(db: Session, class_id: int):
    """List peserta yang mendaftar ke kelas"""
    return db.query(Registration).filter(
        Registration.class_id == class_id,
        Registration.status == "active"
    ).all()


def cancel_registration(db: Session, registration_id: int):
    """Pembatalan (ubah status jadi canceled)"""
    obj = db.query(Registration).filter(
        Registration.id == registration_id
    ).first()

    if not obj:
        return None

    obj.status = "canceled"
    db.commit()
    return obj
