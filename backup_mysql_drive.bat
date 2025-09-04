@echo off
REM ============================================
REM Backup MySQL diário e envio para Google Drive
REM ============================================

REM Configurações
set MYSQL_USER=root
set MYSQL_PASSWORD=
set MYSQL_DATABASE=marketplace
set BACKUP_PATH=X:Backups\
set RCLONE_REMOTE=gdrive:BackupsMySQL

REM Criar pasta de backup se não existir
if not exist "%BACKUP_PATH%" mkdir "%BACKUP_PATH%"

REM Nome do arquivo de backup com data
set DATE=%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%
set BACKUP_FILE=%BACKUP_PATH%\%MYSQL_DATABASE%_%DATE%.sql

REM Fazer dump do MySQL
mysqldump -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% > "%BACKUP_FILE%"

REM Checar se o backup foi criado
if exist "%BACKUP_FILE%" (
    echo Backup criado com sucesso: %BACKUP_FILE%
) else (
    echo Erro ao criar backup!
    exit /b 1
)

REM Enviar para Google Drive
rclone copy "%BACKUP_FILE%" %RCLONE_REMOTE% --progress

REM Opcional: apagar backups locais com mais de 7 dias
forfiles /p "%BACKUP_PATH%" /s /m *.sql /d -7 /c "cmd /c del @path"

echo Backup concluído com sucesso!
pause
