# bt_cuoi_ky

Flutter app + Django backend cho dự án MedCall.

## Flutter

```powershell
flutter pub get
flutter run
```

## Backend

Project backend dùng Django + PostgreSQL.

### 1. Cài dependency Python

```powershell
cd backend
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 2. Cấu hình môi trường

Sao chép `backend/.env.example` thành `backend/.env` và sửa lại giá trị nếu cần:

```env
DB_NAME=figma
DB_USER=postgres
DB_PASSWORD=123456
DB_HOST=localhost
DB_PORT=5432
```

### 3. Restore cơ sở dữ liệu từ file dump

File `C:\Users\LAPTOP MSI\Downloads\figma.sql` là PostgreSQL custom dump, nên phải dùng `pg_restore`, không dùng `psql < figma.sql`.

Nếu PostgreSQL đã cài ở `C:\Program Files\PostgreSQL\18\bin`, chạy:

```powershell
cd backend
$env:PGPASSWORD="123456"
.\scripts\restore_db.ps1
```

Nếu PostgreSQL của bạn nằm ở thư mục khác:

```powershell
.\scripts\restore_db.ps1 -PgBin "C:\Program Files\PostgreSQL\17\bin"
```

### 4. Chạy backend

```powershell
cd backend
.venv\Scripts\Activate.ps1
python manage.py migrate
python manage.py runserver
```

Backend mặc định chạy ở `http://127.0.0.1:8000`.
