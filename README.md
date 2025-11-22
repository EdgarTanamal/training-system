
## Fitur Sistem
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
python -m venv venv
source venv/Scripts/activate
uvicorn main:app --reload

---

## ▶️ Cara Menjalankan Flutter Web
cd flutter_web
flutter run -d chrome

---
### Jenis Testing
Jenis Test	Fokus	File Contoh
Unit Test	Model dan parsing JSON	models/*.dart
Widget Test	UI dan interaksi	widgets/*.dart
Contoh Perilaku yang Diuji
Model (Unit Test)

Parsing JSON ke model

Validasi field wajib (id, code, title, name)

Konversi kembali ke JSON

## Widget (Widget Test)

Menampilkan data dari service

Menampilkan pesan jika tidak ada data

Tampilan awal widget harus sesuai desain

FloatingActionButton tersedia

Tidak terjadi error saat build

## Cara Menjalankan Test
flutter test
