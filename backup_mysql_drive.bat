@echo off
REM ============================================
REM Backup MySQL diário e envio para Google Drive
REM ============================================

REM Configurações
set MYSQL_USER=root
set MYSQL_PASSWORD=
set MYSQL_DATABASE=marketplace
set BACKUP_PATH=X:\DBDUMPERTESTE\Backups
set RCLONE_REMOTE=gdrive:BackupsMySQL
set RCLONE_PATH= X:\DBDUMPERTESTE\rclone-v1.71.0-windows-amd64\rclone.exe

REM Criar pasta de backup se não existir
if not exist "%BACKUP_PATH%" mkdir "%BACKUP_PATH%"

REM Nome do arquivo de backup com data
set DATE=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%
set BACKUP_FILE=%BACKUP_PATH%\%MYSQL_DATABASE%_%DATE%.sql

REM ====== DEFINIR AUTENTICAÇÃO MySQL ======
if "%MYSQL_PASSWORD%"=="" (
    set MYSQL_AUTH=-u %MYSQL_USER%
) else (
    set MYSQL_AUTH=-u %MYSQL_USER% -p%MYSQL_PASSWORD%
)

REM Fazer dump do MySQL
"C:\wamp64\mysql\bin\mysqldump.exe" -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% > "%BACKUP_FILE%"

REM Checar se o backup foi criado
if exist "%BACKUP_FILE%" (
    echo Backup criado com sucesso: %BACKUP_FILE%
) else (
    echo Erro ao criar backup!
    exit /b 1
)

REM Enviar para Google Drive
%RCLONE_PATH% copy "%BACKUP_FILE%" %RCLONE_REMOTE% --progress

REM Opcional: apagar backups locais com mais de 7 dias
forfiles /p "%BACKUP_PATH%" /s /m *.sql /d -7 /c "cmd /c del @path"
