@echo off
echo ===============================
echo INFフォルダ内の全ドライバをインポート
echo ===============================

set /p INF_DIR=INFファイルのあるフォルダを入力してください（例: C:\Drivers）: 

if not exist "%INF_DIR%" (
    echo [エラー] フォルダが存在しません。
    pause
    exit /b
)

echo INFフォルダ内のすべてのINFを処理します...

for %%f in ("%INF_DIR%\*.inf") do (
    echo インポート中: %%f
    pnputil /add-driver "%%f" /install
)

echo.
echo ===============================
echo すべてのINFをインポート完了
echo ===============================
pause
