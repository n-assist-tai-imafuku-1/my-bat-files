@echo off
title �������c�[�����j���[

:: ���C�����j���[�̕\���Ə���
:menu
cls
echo.
echo ===============================
echo        ���s���j���[
echo ===============================
echo.

:: �e�o�b�`�̃X�e�[�^�X��\��
:: call :show_status [�ԍ�] "[�o�b�`��]" "[�X�y�[�X���ߕ�����]"
call :show_status 1 "Bitlocker�ݒ�" "               "
call :show_status 2 "�h���C���Q��" "                "
call :show_status 3 "���C�Z���X�F��" "              "
echo.
echo    E. �I�� (Exit)
echo.
echo ===============================
echo.

:: ���[�U�[�ɑI��������͂�����
set /p select="���s����ԍ���I�����Ă�������: "

:: �I�����ꂽ�ԍ��ɉ����āA�Ή�����o�b�`�����s
if /i "%select%"=="1" (
    call "%~dp0Bitlocker�ݒ�.bat"
    goto menu
) else if /i "%select%"=="2" (
    call "%~dp0�h���C���Q��.bat"
    goto menu
) else if /i "%select%"=="3" (
    call "%~dp0���C�Z���X�F��.bat"
    goto menu
) else if /i "%select%"=="E" (
    goto :eof
) else (
    echo.
    echo �����ȓ��͂ł��B�ēx�I�����Ă��������B
    pause >nul
    goto menu
)

:: show_status �T�u���[�`��
:: �e�o�b�`�̎��s���ʁi����/���s/�����{�j�𔻒肵�\��
:show_status
set status=�����{
set id=%1
set name=%~2
set padding=%~3

:: �R���s���[�^���̃f�B���N�g���Ɉړ�
set result_dir=%~dp0%COMPUTERNAME%

:: �R���s���[�^���̃f�B���N�g�������݂��邩�`�F�b�N
if exist "%result_dir%\" (
    :: �����t�@�C�������݂��邩�`�F�b�N
    if exist "%result_dir%\%name%.OK" (
        set status=����
    )

    :: ���s�t�@�C�������݂��邩�`�F�b�N
    if exist "%result_dir%\%name%.NG" (
        set status=���s
    )
)

:: ���j���[���ڂƃX�e�[�^�X���E�����ŕ\��
echo    %id%. %name%%padding%%status%

goto :eof