@echo off
setlocal enabledelayedexpansion
title 南船橋設定メニュー

:: ログフォルダとファイル設定（output\コンピュータ名フォルダ内）
set "LOGDIR=%~dp0output\%COMPUTERNAME%"
set "LOGFILE=%LOGDIR%\%~n0.log"

:: ログフォルダがなければ作成
if not exist "%LOGDIR%\" (
    mkdir "%LOGDIR%"
)

:: 管理者権限チェック
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo 管理者権限が必要です。
    echo Enterキーを押すと終了します。
    pause >nul
    exit /b
)

:menu
cls
echo.
echo ===============================
echo           実 行 メニュー
echo ===============================
echo.

call :show_status 1 "ライセンス認証"          "    "
if not exist "%~dp0Bitlocker設定なし.txt" (
    call :show_status 2 "Bitlocker設定"       "     "
)
call :show_status 3 "iECTインストール"        "    "
call :show_status 4 "X-Assist setting"        "    "
call :show_status 5 "X-Assist checktool"      "    "

echo.
echo       E. 終了 (Exit)
echo.
echo ===============================
echo.

set /p select="実行する番号を選択してください: "

if /i "%select%"=="1" (
    if not exist "%~dp0ライセンス認証.bat" (
        call :log "ライセンス認証 のファイルが見つかりませんでした"
        echo ライセンス認証が見つかりませんでした。
        pause >nul
        goto menu
    )

    set "okfile=%LOGDIR%\ライセンス認証.OK"
    set "ngfile=%LOGDIR%\ライセンス認証.NG"

    if exist "%okfile%" (
        call :log "選択 1: ライセンス認証: すでに実施済みです。"
        echo ライセンス認証はすでに実行済みです。
        pause >nul
        goto menu
    )

    call :log "選択 1: ライセンス認証 実行"
    call "%~dp0ライセンス認証.bat"

    if exist "%okfile%" (
        call :log "ライセンス認証: 成功"
    ) else if exist "%ngfile%" (
        call :log "ライセンス認証: 失敗"
    ) else (
        call :log "ライセンス認証: 結果ファイルなし"
    )
    goto menu

) else if /i "%select%"=="2" (
    if exist "%~dp0Bitlocker設定なし.txt" (
        call :log "Bitlocker設定スキップ（設定なしファイル検出）"
        echo.
        echo Bitlocker設定はスキップされました。（設定なしファイルあり）
        pause >nul
        goto menu
    )

    if not exist "%~dp0Bitlocker設定.bat" (
        call :log "Bitlocker設定 のファイルが見つかりませんでした"
        echo Bitlocker設定が見つかりませんでした。
        pause >nul
        goto menu
    )

    set "okfile=%LOGDIR%\Bitlocker設定.OK"
    set "ngfile=%LOGDIR%\Bitlocker設定.NG"

    if exist "%okfile%" (
        call :log "選択 2: Bitlocker設定: すでに実行済みです。"
        echo Bitlocker設定はすでに実行済みです。
        pause >nul
        goto menu
    )

    call :log "選択 2: Bitlocker設定 実行"
    call "%~dp0Bitlocker設定.bat"

    if exist "%okfile%" (
        call :log "Bitlocker設定: 成功"
    ) else if exist "%ngfile%" (
        call :log "Bitlocker設定: 失敗"
    ) else (
        call :log "Bitlocker設定: 結果ファイルなし"
    )
    goto menu

) else if /i "%select%"=="3" (
    if not exist "%~dp0iECT\AgentInstaller_Win.exe" (
        call :log "iECT の実行ファイルが見つかりませんでした"
        echo iECTの実行ファイルが見つかりませんでした。
        pause >nul
        goto menu
    )
    call :log "選択 3: iECT 実行"
    "%~dp0iECT\AgentInstaller_Win.exe"
    goto menu

) else if /i "%select%"=="4" (
    if not exist "%~dp0X-Assist_setting\" (
        call :log "X-Assist setting のフォルダが見つかりませんでした"
        echo X-Assist settingが見つかりませんでした。
        pause >nul
        goto menu
    )
    call :log "選択 4: X Assist setting 実行"
    "%~dp0X-Assist_setting\KittingTool.exe"

    :: ログファイル移動処理
    set "SETTING_LOG_SRC=%~dp0X-Assist_setting\log"
    set "SETTING_LOG_DEST=%LOGDIR%\setting_log"

    if not exist "!SETTING_LOG_DEST!\NUL" (
        echo 転送先フォルダが存在しないため作成...
        mkdir "!SETTING_LOG_DEST!"
    )

    echo ファイル転送中...
    move /Y "!SETTING_LOG_SRC!\*.*" "!SETTING_LOG_DEST!"

    echo 転送完了しました。
    call :log "SETTING_ログファイル転送完了"
    pause
    goto menu

) else if /i "%select%"=="5" (
    if not exist "%~dp0X-Assist_checktool\" (
        call :log "X-Assist checktool のフォルダが見つかりませんでした"
        echo X-Assist checktoolが見つかりませんでした。
        pause >nul
        goto menu
    )
    call :log "選択 5: X Assist checktool 実行"
    "%~dp0X-Assist_checktool\SettingCheck.exe"

    :: ログファイル移動処理
    set "CHECK_LOG_SRC=%~dp0X-Assist_checktool\%COMPUTERNAME%"
    set "CHECK_LOG_DEST=%LOGDIR%\check_log"
    

    if not exist "!CHECK_LOG_DEST!\NUL" (
        echo 転送先フォルダが存在しないため作成...
        mkdir "!CHECK_LOG_DEST!"
    )

    echo ディレクトリ転送中...
    robocopy "!CHECK_LOG_SRC!" "!CHECK_LOG_DEST!" /E /NFL /NDL /NJH /NJS /NP /R:0 /W:0

    echo 転送完了しました。
    call :log "CHECK_ログファイル転送完了"
    pause
    goto menu

) else if /i "%select%"=="E" (
    call :log "選択 E: 終了"
    goto :eof

) else (
    call :log "無効入力: %select%"
    echo.
    echo 無効な入力です。再度選択してください。
    pause >nul
    goto menu
)

:: ログ記録処理
:log
setlocal
set "msg=%~1"
for /f "tokens=1-2 delims= " %%a in ('date /t') do set "d=%%a"
for /f "tokens=1-2 delims= " %%x in ('time /t') do set "t=%%x"
>> "%LOGFILE%" echo [%d% %t%] %COMPUTERNAME%: %msg%
endlocal
goto :eof

:: ステータス表示処理
:show_status
set status=未実施
set id=%1
set name=%~2
set padding=%~3

:: 一部ステータス非表示対象
if /i "%name%"=="iECTインストール" (
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
        set status=成功
    )
    if exist "%result_dir%\%name%.NG" (
        set status=失敗
    )
)
echo      %id%. %name%%padding%%status%
goto :eof
