from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api_backend.routers import classes_router, participants_router
from database import Base, engine
from routers import registrations

# Buat tabel di DB kalau belum ada
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Training Management API")

origins = [
    "http://localhost:3000",
    "http://localhost:5273",
    "http://localhost:5274",
    "http://127.0.0.1:8000",
    "http://localhost",
    "*",  # sementara boleh, nanti bisa dipersempit
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(participants_router.router)
app.include_router(classes_router.router)
app.include_router(registrations.router)
