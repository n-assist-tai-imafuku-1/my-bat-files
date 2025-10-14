@echo off
setlocal enabledelayedexpansion
title ��D���ݒ胁�j���[

:: ���O�t�H���_�ƃt�@�C���ݒ�ioutput\�R���s���[�^���t�H���_���j
set "LOGDIR=%~dp0output\%COMPUTERNAME%"
set "LOGFILE=%LOGDIR%\%~n0.log"

:: ���O�t�H���_���Ȃ���΍쐬
if not exist "%LOGDIR%\" (
    mkdir "%LOGDIR%"
)

:: �Ǘ��Ҍ����`�F�b�N
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo �Ǘ��Ҍ������K�v�ł��B
    echo Enter�L�[�������ƏI�����܂��B
    pause >nul
    exit /b
)

:menu
cls
echo.
echo ===============================
echo           �� �s ���j���[
echo ===============================
echo.

call :show_status 1 "���C�Z���X�F��"          "    "
if not exist "%~dp0Bitlocker�ݒ�Ȃ�.txt" (
    call :show_status 2 "Bitlocker�ݒ�"       "     "
)
call :show_status 3 "iECT�C���X�g�[��"        "    "
call :show_status 4 "X-Assist setting"        "    "
call :show_status 5 "X-Assist checktool"      "    "

echo.
echo       E. �I�� (Exit)
echo.
echo ===============================
echo.

set /p select="���s����ԍ���I�����Ă�������: "

if /i "%select%"=="1" (
    if not exist "%~dp0���C�Z���X�F��.bat" (
        call :log "���C�Z���X�F�� �̃t�@�C����������܂���ł���"
        echo ���C�Z���X�F�؂�������܂���ł����B
        pause >nul
        goto menu
    )

    set "okfile=%LOGDIR%\���C�Z���X�F��.OK"
    set "ngfile=%LOGDIR%\���C�Z���X�F��.NG"

    if exist "%okfile%" (
        call :log "�I�� 1: ���C�Z���X�F��: ���łɎ��{�ς݂ł��B"
        echo ���C�Z���X�F�؂͂��łɎ��s�ς݂ł��B
        pause >nul
        goto menu
    )

    call :log "�I�� 1: ���C�Z���X�F�� ���s"
    call "%~dp0���C�Z���X�F��.bat"

    if exist "%okfile%" (
        call :log "���C�Z���X�F��: ����"
    ) else if exist "%ngfile%" (
        call :log "���C�Z���X�F��: ���s"
    ) else (
        call :log "���C�Z���X�F��: ���ʃt�@�C���Ȃ�"
    )
    goto menu

) else if /i "%select%"=="2" (
    if exist "%~dp0Bitlocker�ݒ�Ȃ�.txt" (
        call :log "Bitlocker�ݒ�X�L�b�v�i�ݒ�Ȃ��t�@�C�����o�j"
        echo.
        echo Bitlocker�ݒ�̓X�L�b�v����܂����B�i�ݒ�Ȃ��t�@�C������j
        pause >nul
        goto menu
    )

    if not exist "%~dp0Bitlocker�ݒ�.bat" (
        call :log "Bitlocker�ݒ� �̃t�@�C����������܂���ł���"
        echo Bitlocker�ݒ肪������܂���ł����B
        pause >nul
        goto menu
    )

    set "okfile=%LOGDIR%\Bitlocker�ݒ�.OK"
    set "ngfile=%LOGDIR%\Bitlocker�ݒ�.NG"

    if exist "%okfile%" (
        call :log "�I�� 2: Bitlocker�ݒ�: ���łɎ��s�ς݂ł��B"
        echo Bitlocker�ݒ�͂��łɎ��s�ς݂ł��B
        pause >nul
        goto menu
    )

    call :log "�I�� 2: Bitlocker�ݒ� ���s"
    call "%~dp0Bitlocker�ݒ�.bat"

    if exist "%okfile%" (
        call :log "Bitlocker�ݒ�: ����"
    ) else if exist "%ngfile%" (
        call :log "Bitlocker�ݒ�: ���s"
    ) else (
        call :log "Bitlocker�ݒ�: ���ʃt�@�C���Ȃ�"
    )
    goto menu

) else if /i "%select%"=="3" (
    if not exist "%~dp0iECT\AgentInstaller_Win.exe" (
        call :log "iECT �̎��s�t�@�C����������܂���ł���"
        echo iECT�̎��s�t�@�C����������܂���ł����B
        pause >nul
        goto menu
    )
    call :log "�I�� 3: iECT ���s"
    "%~dp0iECT\AgentInstaller_Win.exe"
    goto menu

) else if /i "%select%"=="4" (
    if not exist "%~dp0X-Assist_setting\" (
        call :log "X-Assist setting �̃t�H���_��������܂���ł���"
        echo X-Assist setting��������܂���ł����B
        pause >nul
        goto menu
    )
    call :log "�I�� 4: X Assist setting ���s"
    "%~dp0X-Assist_setting\KittingTool.exe"

    :: ���O�t�@�C���ړ�����
    set "SETTING_LOG_SRC=%~dp0X-Assist_setting\log"
    set "SETTING_LOG_DEST=%LOGDIR%\setting_log"

    if not exist "!SETTING_LOG_DEST!\NUL" (
        echo �]����t�H���_�����݂��Ȃ����ߍ쐬...
        mkdir "!SETTING_LOG_DEST!"
    )

    echo �t�@�C���]����...
    move /Y "!SETTING_LOG_SRC!\*.*" "!SETTING_LOG_DEST!"

    echo �]���������܂����B
    call :log "SETTING_���O�t�@�C���]������"
    pause
    goto menu

) else if /i "%select%"=="5" (
    if not exist "%~dp0X-Assist_checktool\" (
        call :log "X-Assist checktool �̃t�H���_��������܂���ł���"
        echo X-Assist checktool��������܂���ł����B
        pause >nul
        goto menu
    )
    call :log "�I�� 5: X Assist checktool ���s"
    "%~dp0X-Assist_checktool\SettingCheck.exe"

    :: ���O�t�@�C���ړ�����
    set "CHECK_LOG_SRC=%~dp0X-Assist_checktool\%COMPUTERNAME%"
    set "CHECK_LOG_DEST=%LOGDIR%\check_log"
    

    if not exist "!CHECK_LOG_DEST!\NUL" (
        echo �]����t�H���_�����݂��Ȃ����ߍ쐬...
        mkdir "!CHECK_LOG_DEST!"
    )

    echo �f�B���N�g���]����...
    robocopy "!CHECK_LOG_SRC!" "!CHECK_LOG_DEST!" /E /NFL /NDL /NJH /NJS /NP /R:0 /W:0

    echo �]���������܂����B
    call :log "CHECK_���O�t�@�C���]������"
    pause
    goto menu

) else if /i "%select%"=="E" (
    call :log "�I�� E: �I��"
    goto :eof

) else (
    call :log "��������: %select%"
    echo.
    echo �����ȓ��͂ł��B�ēx�I�����Ă��������B
    pause >nul
    goto menu
)

:: ���O�L�^����
:log
setlocal
set "msg=%~1"
for /f "tokens=1-2 delims= " %%a in ('date /t') do set "d=%%a"
for /f "tokens=1-2 delims= " %%x in ('time /t') do set "t=%%x"
>> "%LOGFILE%" echo [%d% %t%] %COMPUTERNAME%: %msg%
endlocal
goto :eof

:: �X�e�[�^�X�\������
:show_status
set status=�����{
set id=%1
set name=%~2
set padding=%~3

:: �ꕔ�X�e�[�^�X��\���Ώ�
if /i "%name%"=="iECT�C���X�g�[��" (
    echo      %id%. %name%%padding%
    goto :eof
)
if /i "%name%"=="X-Assist setting" (
    echo      %id%. %name%%padding%
    goto :eof
)
if /i "%name%"=="X-Assist checktool" (
    echo      %id%. %name%%padding%
    goto :eof
)

set result_dir=%~dp0output\%COMPUTERNAME%
if exist "%result_dir%\" (
    if exist "%result_dir%\%name%.OK" (
        set status=����
    )
    if exist "%result_dir%\%name%.NG" (
        set status=���s
    )
)
echo      %id%. %name%%padding%%status%
goto :eof
