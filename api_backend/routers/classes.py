from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Class
from schemas import ClassCreate, ClassOut, ClassUpdate

router = APIRouter(prefix="/classes", tags=["Classes"])


@router.post("/", response_model=ClassOut)
def create_class(data: ClassCreate, db: Session = Depends(get_db)):
    course_class = Class(**data.dict())
    db.add(course_class)
    db.commit()
    db.refresh(course_class)
    return course_class


@router.get("/", response_model=list[ClassOut])
def list_classes(db: Session = Depends(get_db)):
    return (
        db.query(Class)
        .filter(Class.is_active == 1)
        .order_by(Class.created_at.desc())
        .all()
    )


@router.get("/{class_id}", response_model=ClassOut)
def get_class(class_id: int, db: Session = Depends(get_db)):
    course_class = db.query(Class).filter(Class.id == class_id).first()
    if not course_class:
        raise HTTPException(status_code=404, detail="Class not found")
    return course_class


@router.put("/{class_id}", response_model=ClassOut)
def update_class(
    class_id: int,
    data: ClassUpdate,
    db: Session = Depends(get_db),
):
    course_class = db.query(Class).filter(Class.id == class_id).first()
    if not course_class:
        raise HTTPException(status_code=404, detail="Class not found")

    for key, value in data.dict(exclude_unset=True).items():
        setattr(course_class, key, value)

    db.commit()
    db.refresh(course_class)
    return course_class


@router.delete("/{class_id}")
def delete_class(class_id: int, db: Session = Depends(get_db)):
    course_class = db.query(Class).filter(Class.id == class_id).first()
    if not course_class:
        raise HTTPException(status_code=404, detail="Class not found")

    course_class.is_active = 0
    db.commit()
    return {"message": "Class deleted (soft delete)"}
