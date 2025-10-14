@echo off
echo ==============================================
echo   WIM �C���[�W�����o�b�`�J�n
echo ==============================================

:: ===== ���[�U�[�m�F =====
set /p CONFIRM="�x��: ���̑�������s����ƃf�B�X�N�̓��e�����ׂď�������܂��B�{���ɑ��s���܂����H (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo ����𒆎~���܂����B
    pause
    exit /b
)

:: ===== �f�B�X�N������ =====
echo.
echo --- DiskPart: �f�B�X�N�������E�p�[�e�B�V�����쐬 ---
(
echo select disk 0
echo clean
echo convert gpt

:: EFI
echo create partition efi size=260
echo format fs=fat32 quick label="System"
echo assign letter=Z

:: MSR
echo create partition msr size=16

:: C�h���C�u (Windows 464GB)
echo create partition primary size=475873
echo format fs=ntfs quick label="Windows"
echo assign letter=C


:: �񕜃p�[�e�B�V���� (WinRE_DRV)
echo create partition primary 
echo format fs=ntfs quick label="WinRE_DRV"
echo set id=de94bba4-06d1-4d40-a16a-bfd50179d6ac
echo assign letter=R
) > diskpart_script.txt

diskpart /s diskpart_script.txt
del diskpart_script.txt

:: ===== ���[�U�[�� WIM�t�@�C��������͂����� =====
set /p WIMFILE=�g�p����WIM�t�@�C��������͂��Ă��������i��FMyBackup.wim�j: 

echo.
echo --- images �t�H���_���� %WIMFILE% �������� ---

set "WIMPATH="

for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\images\%WIMFILE%" (
        set "WIMPATH=%%d:\images\%WIMFILE%"
        goto :found
    )
)

:found
if defined WIMPATH (
    echo ���o���ꂽ WIM�t�@�C��: %WIMPATH%
) else (
    echo WIM�t�@�C���u%WIMFILE%�v�� images �t�H���_���Ɍ�����܂���ł����B
)


:: ===== WIM�W�J =====
echo.
echo --- DISM: WIM �C���[�W�W�J ---
dism /apply-image /imagefile:%WIMPATH% /index:1 /applydir:Z:\
dism /apply-image /imagefile:%WIMPATH% /index:2 /applydir:C:\
dism /apply-image /imagefile:%WIMPATH% /index:3 /applydir:R:\

:: ===== �u�[�g�\���쐬 =====
echo.
echo --- BCDboot: �u�[�g�\���쐬 ---
bcdboot C:\Windows /s Z: /f UEFI

echo.
echo ==============================================
echo   ���������IPC���ċN�����Ă�������
echo ==============================================
pause
