@echo off
title �ڍs���쐬���j���[

:: ���O�t�H���_�ƃt�@�C���ݒ�ioutput\�R���s���[�^���t�H���_���j
set "LOGDIR=%~dp0output\%COMPUTERNAME%"
set "LOGFILE=%LOGDIR%\%~n0.log"

:: ���ʊm�F�p�t�H���_�ioutput\�R���s���[�^�� �t�H���_�j
set "RESULTDIR=%~dp0output\%COMPUTERNAME%"

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
echo     �� �s ���j���[
echo ===============================
echo.

call :show_status 1 �ڍs���o�b�N�A�b�v�쐬 "   "
echo.
echo    E. �I�� (Exit)
echo.
echo ===============================
echo.

set /p select="���s����ԍ���I�����Ă�������: "

if /i "%select%"=="1" (
    :: �������� OK �t�@�C��������΁u���s�ς݁v����
    if exist "%RESULTDIR%\�ڍs���o�b�N�A�b�v�쐬.OK" (
        call :log "�ڍs���o�b�N�A�b�v�쐬�F���łɎ��s�ς�"
        echo �ڍs���o�b�N�A�b�v�͂��łɎ��s�ς݂ł��B
        pause >nul
        goto menu
    )

    call :log "�I�� 1: �ڍs���o�b�N�A�b�v�쐬 ���s"

    if not exist "%~dp0�ڍs���o�b�N�A�b�v�쐬.bat" (
        call :log "�ڍs���o�b�N�A�b�v�쐬.bat ��������܂���"
        echo �o�b�`�t�@�C����������܂���ł����B
        pause >nul
        goto menu
    )

    call "%~dp0�ڍs���o�b�N�A�b�v�쐬.bat"

    if exist "%RESULTDIR%\�ڍs���o�b�N�A�b�v�쐬.OK" (
        call :log "�ڍs���o�b�N�A�b�v�쐬�F����"
    ) else if exist "%RESULTDIR%\�ڍs���o�b�N�A�b�v�쐬.NG" (
        call :log "�ڍs���o�b�N�A�b�v�쐬�F���s"
    ) else (
        call :log "�ڍs���o�b�N�A�b�v�쐬�F���ʃt�@�C���Ȃ�"
    )
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

:: ���O�������݃T�u���[�`��
:log
setlocal
set "msg=%~1"
for /f "tokens=1-2 delims= " %%a in ('date /t') do set "d=%%a"
for /f "tokens=1-2 delims= " %%x in ('time /t') do set "t=%%x"
>> "%LOGFILE%" echo [%d% %t%] %COMPUTERNAME%: %msg%
endlocal
goto :eof

:: �X�e�[�^�X�\���p�T�u���[�`��
:show_status
setlocal
set status=�����{
set id=%1
set name=%~2
set padding=%~3

if exist "%RESULTDIR%\%name%.OK" (
    set status=����
) else if exist "%RESULTDIR%\%name%.NG" (
    set status=���s
)

:: �o�͎��ɗ]�v�ȃN�I�[�g���Ȃ��悤����
echo    %id%. %name%%padding%%status%
endlocal
goto :eof
