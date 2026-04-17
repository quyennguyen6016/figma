param(
    [string]$DumpPath = "C:\Users\LAPTOP MSI\Downloads\figma.sql",
    [string]$DbName = "figma",
    [string]$DbUser = "postgres",
    [string]$DbHost = "localhost",
    [string]$DbPort = "5432",
    [string]$PgBin = "C:\Program Files\PostgreSQL\18\bin"
)

$pgRestore = Join-Path $PgBin "pg_restore.exe"
$psql = Join-Path $PgBin "psql.exe"
$createdb = Join-Path $PgBin "createdb.exe"
$dropdb = Join-Path $PgBin "dropdb.exe"

if (!(Test-Path $DumpPath)) {
    throw "Khong tim thay file dump: $DumpPath"
}

foreach ($tool in @($pgRestore, $psql, $createdb, $dropdb)) {
    if (!(Test-Path $tool)) {
        throw "Khong tim thay cong cu PostgreSQL: $tool"
    }
}

if (-not $env:PGPASSWORD) {
    Write-Host "PGPASSWORD chua duoc set. Neu PostgreSQL yeu cau mat khau, hay chay:"
    Write-Host '$env:PGPASSWORD="your_password"'
}

& $dropdb --if-exists --host $DbHost --port $DbPort --username $DbUser $DbName
if ($LASTEXITCODE -ne 0) {
    throw "Khong the xoa database cu $DbName"
}

& $createdb --host $DbHost --port $DbPort --username $DbUser --encoding UTF8 $DbName
if ($LASTEXITCODE -ne 0) {
    throw "Khong the tao database $DbName"
}

& $pgRestore --clean --if-exists --no-owner --host $DbHost --port $DbPort --username $DbUser --dbname $DbName $DumpPath
if ($LASTEXITCODE -ne 0) {
    throw "Khong the restore dump vao database $DbName"
}

Write-Host "Restore database thanh cong vao $DbName"
