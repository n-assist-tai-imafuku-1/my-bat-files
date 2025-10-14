@echo off
title 移行先メニュー

:: ログ・結果フォルダ設定（output\コンピュータ名\）
set "LOGDIR=%~dp0output\%COMPUTERNAME%"
set "LOGFILE=%LOGDIR%\%~n0.log"
set "RESULTDIR=%~dp0output\%COMPUTERNAME%"

:: ログフォルダ作成
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
echo      実 行 メニュー
echo ===============================
echo.

call :show_status 1 ドメイン参加           "                 "
call :show_status 2 ドメイン参加確認       "             "
call :show_status 3 移行先バックアップ展開 "       "

echo.
echo    E. 終了 (Exit)
echo.
echo ===============================
echo.

set /p select="実行する番号を選択してください: "

if /i "%select%"=="1" (
    call :run_task "ドメイン参加"
    goto menu

) else if /i "%select%"=="2" (
    call :run_task "ドメイン参加確認"
    goto menu

) else if /i "%select%"=="3" (
    call :run_task "移行先バックアップ展開"
    goto menu

) else if /i "%select%"=="E" (
    call :log "選択 E: 終了"
    exit /b

) else (
    call :log "無効入力: %select%"
    echo.
    echo 無効な入力です。再度選択してください。
    pause >nul
    goto menu
)

::------------------------------------------
:: サブルーチン：処理の実行
:run_task
setlocal
set "name=%~1"
set "batfile=%~dp0%name%.bat"

if exist "%RESULTDIR%\%name%.OK" (
    call :log "%name%：すでに実行済み"
    echo %name% はすでに実行済みです。
    pause >nul
    endlocal
    goto :eof
)

call :log "選択: %name% 実行"

if not exist "%batfile%" (
    call :log "%name%.bat が見つかりませんでした"
    echo %name%.bat が見つかりませんでした。
    pause >nul
    endlocal
    goto :eof
)

call "%batfile%"

if exist "%RESULTDIR%\%name%.OK" (
    call :log "%name%：成功"
) else if exist "%RESULTDIR%\%name%.NG" (
    call :log "%name%：失敗"
) else (
    call :log "%name%：結果ファイルなし"
)

endlocal
goto :eof

::------------------------------------------
:: サブルーチン：ログ書き込み
:log
setlocal
set "msg=%~1"
for /f "tokens=1-2 delims= " %%a in ('date /t') do set "d=%%a"
for /f "tokens=1 delims= " %%x in ('time /t') do set "t=%%x"
>> "%LOGFILE%" echo [%d% %t%] %COMPUTERNAME%: %msg%
endlocal
goto :eof

::------------------------------------------
:: サブルーチン：ステータス表示
:show_status
setlocal
set "id=%~1"
set "name=%~2"
set "padding=%~3"
set "status=未実施"

if exist "%RESULTDIR%\%name%.OK" (
    set "status=成功"
) else if exist "%RESULTDIR%\%name%.NG" (
    set "status=失敗"
)

echo    %id%. %name%%padding%%status%
endlocal
goto :eof
