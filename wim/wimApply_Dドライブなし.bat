@echo off
echo ==============================================
echo   WIM イメージ復元バッチ開始
echo ==============================================

:: ===== ユーザー確認 =====
set /p CONFIRM="警告: この操作を実行するとディスクの内容がすべて消去されます。本当に続行しますか？ (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo 操作を中止しました。
    pause
    exit /b
)

:: ===== ディスク初期化 =====
echo.
echo --- DiskPart: ディスク初期化・パーティション作成 ---
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

:: Cドライブ (Windows 464GB)
echo create partition primary size=475873
echo format fs=ntfs quick label="Windows"
echo assign letter=C


:: 回復パーティション (WinRE_DRV)
echo create partition primary 
echo format fs=ntfs quick label="WinRE_DRV"
echo set id=de94bba4-06d1-4d40-a16a-bfd50179d6ac
echo assign letter=R
) > diskpart_script.txt

diskpart /s diskpart_script.txt
del diskpart_script.txt

:: ===== ユーザーに WIMファイル名を入力させる =====
set /p WIMFILE=使用するWIMファイル名を入力してください（例：MyBackup.wim）: 

echo.
echo --- images フォルダ内の %WIMFILE% を検索中 ---

set "WIMPATH="

for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\images\%WIMFILE%" (
        set "WIMPATH=%%d:\images\%WIMFILE%"
        goto :found
    )
)

:found
if defined WIMPATH (
    echo 検出された WIMファイル: %WIMPATH%
) else (
    echo WIMファイル「%WIMFILE%」は images フォルダ内に見つかりませんでした。
)


:: ===== WIM展開 =====
echo.
echo --- DISM: WIM イメージ展開 ---
dism /apply-image /imagefile:%WIMPATH% /index:1 /applydir:Z:\
dism /apply-image /imagefile:%WIMPATH% /index:2 /applydir:C:\
dism /apply-image /imagefile:%WIMPATH% /index:3 /applydir:R:\

:: ===== ブート構成作成 =====
echo.
echo --- BCDboot: ブート構成作成 ---
bcdboot C:\Windows /s Z: /f UEFI

echo.
echo ==============================================
echo   復元完了！PCを再起動してください
echo ==============================================
pause
