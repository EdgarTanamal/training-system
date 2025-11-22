
## 🚀 Fitur Sistem
### 1. Manajemen Peserta
- Menambah peserta baru  
- Menampilkan seluruh peserta  
- Menampilkan detail peserta  
- Mengubah data peserta  
- Menghapus peserta

### 2. Manajemen Kelas
- Menambah kelas baru  
- Menampilkan seluruh kelas  
- Detail kelas  
- Edit kelas  
- Hapus kelas

### 3. Pendaftaran Peserta ke Kelas
- Mendaftarkan satu peserta ke satu atau beberapa kelas  
- Menampilkan daftar kelas yang diikuti peserta  
- Menampilkan daftar peserta dalam kelas  
- Membatalkan pendaftaran

---

## 🔧 Teknologi yang Digunakan
| Layer | Teknologi |
|------|------------|
| Frontend | Flutter Web |
| Backend | FastAPI |
| Database | MySQL |
| API Client | HTTP package Flutter |
| ORM | SQLAlchemy |
| Debugging | Flutter DevTools, FastAPI Logging |

---

## ▶️ Cara Menjalankan Backend

```bash
cd api_backend
uvicorn main:app --reload
▶️ Cara Menjalankan Flutter Web
bash
Copy code
cd flutter_web
flutter run -d chrome
