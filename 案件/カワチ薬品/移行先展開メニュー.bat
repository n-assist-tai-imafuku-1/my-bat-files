@echo off
title �ڍs�惁�j���[

:: ���O�E���ʃt�H���_�ݒ�ioutput\�R���s���[�^��\�j
set "LOGDIR=%~dp0output\%COMPUTERNAME%"
set "LOGFILE=%LOGDIR%\%~n0.log"
set "RESULTDIR=%~dp0output\%COMPUTERNAME%"

:: ���O�t�H���_�쐬
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
echo      �� �s ���j���[
echo ===============================
echo.

call :show_status 1 �h���C���Q��           "                 "
call :show_status 2 �h���C���Q���m�F       "             "
call :show_status 3 �ڍs��o�b�N�A�b�v�W�J "       "

echo.
echo    E. �I�� (Exit)
echo.
echo ===============================
echo.

set /p select="���s����ԍ���I�����Ă�������: "

if /i "%select%"=="1" (
    call :run_task "�h���C���Q��"
    goto menu

) else if /i "%select%"=="2" (
    call :run_task "�h���C���Q���m�F"
    goto menu

) else if /i "%select%"=="3" (
    call :run_task "�ڍs��o�b�N�A�b�v�W�J"
    goto menu

) else if /i "%select%"=="E" (
    call :log "�I�� E: �I��"
    exit /b

) else (
    call :log "��������: %select%"
    echo.
    echo �����ȓ��͂ł��B�ēx�I�����Ă��������B
    pause >nul
    goto menu
)

::------------------------------------------
:: �T�u���[�`���F�����̎��s
:run_task
setlocal
set "name=%~1"
set "batfile=%~dp0%name%.bat"

if exist "%RESULTDIR%\%name%.OK" (
    call :log "%name%�F���łɎ��s�ς�"
    echo %name% �͂��łɎ��s�ς݂ł��B
    pause >nul
    endlocal
    goto :eof
)

call :log "�I��: %name% ���s"

if not exist "%batfile%" (
    call :log "%name%.bat ��������܂���ł���"
    echo %name%.bat ��������܂���ł����B
    pause >nul
    endlocal
    goto :eof
)

call "%batfile%"

if exist "%RESULTDIR%\%name%.OK" (
    call :log "%name%�F����"
) else if exist "%RESULTDIR%\%name%.NG" (
    call :log "%name%�F���s"
) else (
    call :log "%name%�F���ʃt�@�C���Ȃ�"
)

endlocal
goto :eof

::------------------------------------------
:: �T�u���[�`���F���O��������
:log
setlocal
set "msg=%~1"
for /f "tokens=1-2 delims= " %%a in ('date /t') do set "d=%%a"
for /f "tokens=1 delims= " %%x in ('time /t') do set "t=%%x"
>> "%LOGFILE%" echo [%d% %t%] %COMPUTERNAME%: %msg%
endlocal
goto :eof

::------------------------------------------
:: �T�u���[�`���F�X�e�[�^�X�\��
:show_status
setlocal
set "id=%~1"
set "name=%~2"
set "padding=%~3"
set "status=�����{"

if exist "%RESULTDIR%\%name%.OK" (
    set "status=����"
) else if exist "%RESULTDIR%\%name%.NG" (
    set "status=���s"
)

echo    %id%. %name%%padding%%status%
endlocal
goto :eof
