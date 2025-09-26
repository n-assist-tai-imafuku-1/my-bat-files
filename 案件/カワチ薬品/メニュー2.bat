@echo off
title メニュー

:: メインメニューの表示と処理
:menu
cls
echo.
echo ===============================
echo 実行メニュー
echo ===============================
echo.

:: 各バッチのステータスを表示
:: call :show_status [番号] "[バッチ名]" "[スペース埋め文字列]"
call :show_status 1 "ドメイン参加" "        "
call :show_status 2 "データ移行" "          "
call :show_status 3 "Outlook移行" "         "
echo.
echo    E. 終了 (Exit)
echo.
echo ===============================
echo.

:: ユーザーに選択肢を入力させる
set /p select="実行する番号を選択してください: "

:: 選択された番号に応じて、対応するバッチを実行
if /i "%select%"=="1" (
    call "%~dp0ドメイン参加.bat"
    goto menu
) else if /i "%select%"=="2" (
    call "%~dp0データ移行.bat"
    goto menu
) else if /i "%select%"=="3" (
    call "%~dp0Outlook移行.bat"
    goto menu
) else if /i "%select%"=="E" (
    goto :eof
) else (
    echo.
    echo 無効な入力です。再度選択してください。
    pause >nul
    goto menu
)

:: show_status サブルーチン
:: 各バッチの実行結果（成功/失敗/未実施）を判定し表示
:show_status
set status=未実施
set id=%1
set name=%~2
set padding=%~3

:: コンピュータ名のディレクトリに移動
set result_dir=%~dp0%COMPUTERNAME%

:: コンピュータ名のディレクトリが存在するかチェック
if exist "%result_dir%\" (
    :: 成功ファイルが存在するかチェック
    if exist "%result_dir%\%name%.OK" (
        set status=成功
    )

    :: 失敗ファイルが存在するかチェック
    if exist "%result_dir%\%name%.NG" (
        set status=失敗
    )
)

:: メニュー項目とステータスを右揃えで表示
echo    %id%. %name%%padding%%status%

goto :eof