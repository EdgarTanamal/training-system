from sqlalchemy import Column, Integer, String, Date, TIMESTAMP, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base


class Participant(Base):
    __tablename__ = "participants"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    email = Column(String(100), nullable=True)
    phone = Column(String(20), nullable=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())
    is_active = Column(Integer, default=1)

    registrations = relationship("Registration", back_populates="participant")


class Class(Base):
    __tablename__ = "classes"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String(50), nullable=False)
    title = Column(String(100), nullable=False)
    description = Column(String(250), nullable=True)
    start_date = Column(Date, nullable=True)
    end_date = Column(Date, nullable=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())
    is_active = Column(Integer, default=1)

    registrations = relationship("Registration", back_populates="course_class")


class Registration(Base):
    __tablename__ = "registrations"

    id = Column(Integer, primary_key=True, index=True)
    participant_id = Column(Integer, ForeignKey("participants.id"), nullable=False)
    class_id = Column(Integer, ForeignKey("classes.id"), nullable=False)
    registered_at = Column(TIMESTAMP, server_default=func.now())
    status = Column(String(20), default="active")  # active / canceled

    participant = relationship("Participant", back_populates="registrations")
    course_class = relationship("Class", back_populates="registrations")
