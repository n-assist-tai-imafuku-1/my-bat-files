@echo off
echo ==============================================
echo   WIM �C���[�W�쐬�o�b�`�J�n�i���ׂ�P�����ECapture��Append�j
echo ==============================================

:: ===== �ۑ���h���C�u�ƃt�@�C��������� =====
set /p CAPTURE_DRIVE=�ۑ���h���C�u����͂��Ă������� (��: D): 
set /p CAPTURE_NAME=�ۑ�����WIM�t�@�C��������͂��Ă������� (��: MasterPC.wim): 
set CAPTURE_PATH=%CAPTURE_DRIVE%:\Images\%CAPTURE_NAME%

:: �ۑ���t�H���_�����݂��Ȃ���΍쐬
for %%F in ("%CAPTURE_PATH%") do (
    if not exist "%%~dpF" mkdir "%%~dpF"
)

echo �ۑ��� WIM: %CAPTURE_PATH%
echo.

:: ===== �p�[�e�B�V����1(EFI) �L���v�`�� =====
echo --- �p�[�e�B�V����1 (EFI) ---
(
echo select disk 0
echo select partition 1
echo assign letter=P
) | diskpart

dism /Capture-Image /ImageFile:%CAPTURE_PATH% /CaptureDir:P:\ /Name:"Partition-1" /Compress:maximum /EA

(
echo select disk 0
echo select partition 1
echo remove letter=P
) | diskpart

:: ===== �p�[�e�B�V����3(C) �L���v�`�� =====
echo --- �p�[�e�B�V����3 (C�h���C�u) ---
(
echo select disk 0
echo select partition 3
echo assign letter=P
) | diskpart

dism /Append-Image /ImageFile:%CAPTURE_PATH% /CaptureDir:P:\ /Name:"Partition-2" /EA

(
echo select disk 0
echo select partition 3
echo remove letter=P
) | diskpart

:: ===== �p�[�e�B�V����4(D) �L���v�`�� =====
echo --- �p�[�e�B�V����4 (D�h���C�u) ---
(
echo select disk 0
echo select partition 4
echo assign letter=P
) | diskpart

dism /Append-Image /ImageFile:%CAPTURE_PATH% /CaptureDir:P:\ /Name:"Partition-3" /EA

(
echo select disk 0
echo select partition 4
echo remove letter=P
) | diskpart

:: ===== �p�[�e�B�V����5(��) �L���v�`�� =====
echo --- �p�[�e�B�V����5 (�񕜃p�[�e�B�V����) ---
(
echo select disk 0
echo select partition 5
echo assign letter=P
) | diskpart

dism /Append-Image /ImageFile:%CAPTURE_PATH% /CaptureDir:P:\ /Name:"Partition-4" /EA

(
echo select disk 0
echo select partition 5
echo remove letter=P
) | diskpart

echo.
echo ==============================================
echo   WIM �C���[�W�쐬�����i���ׂ�P�����j
echo ==============================================
pause
