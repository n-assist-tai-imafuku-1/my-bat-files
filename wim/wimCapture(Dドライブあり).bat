@echo off
echo ==============================================
echo   WIM イメージ作成バッチ開始（すべてP割当・Capture→Append）
echo ==============================================

:: ===== 保存先ドライブとファイル名を入力 =====
set /p CAPTURE_DRIVE=保存先ドライブを入力してください (例: D): 
set /p CAPTURE_NAME=保存するWIMファイル名を入力してください (例: MasterPC.wim): 
set CAPTURE_PATH=%CAPTURE_DRIVE%:\Images\%CAPTURE_NAME%

:: 保存先フォルダが存在しなければ作成
for %%F in ("%CAPTURE_PATH%") do (
    if not exist "%%~dpF" mkdir "%%~dpF"
)

echo 保存先 WIM: %CAPTURE_PATH%
echo.

:: ===== パーティション1(EFI) キャプチャ =====
echo --- パーティション1 (EFI) ---
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

:: ===== パーティション3(C) キャプチャ =====
echo --- パーティション3 (Cドライブ) ---
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

:: ===== パーティション4(D) キャプチャ =====
echo --- パーティション4 (Dドライブ) ---
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

:: ===== パーティション5(回復) キャプチャ =====
echo --- パーティション5 (回復パーティション) ---
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
echo   WIM イメージ作成完了（すべてP割当）
echo ==============================================
pause
