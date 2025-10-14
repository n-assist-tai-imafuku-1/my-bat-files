@echo off
title 移行元作成メニュー

:: ログフォルダとファイル設定（output\コンピュータ名フォルダ内）
set "LOGDIR=%~dp0output\%COMPUTERNAME%"
set "LOGFILE=%LOGDIR%\%~n0.log"

:: 結果確認用フォルダ（output\コンピュータ名 フォルダ）
set "RESULTDIR=%~dp0output\%COMPUTERNAME%"

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
echo     実 行 メニュー
echo ===============================
echo.

call :show_status 1 移行元バックアップ作成 "   "
echo.
echo    E. 終了 (Exit)
echo.
echo ===============================
echo.

set /p select="実行する番号を選択してください: "

if /i "%select%"=="1" (
    :: もし既に OK ファイルがあれば「実行済み」扱い
    if exist "%RESULTDIR%\移行元バックアップ作成.OK" (
        call :log "移行元バックアップ作成：すでに実行済み"
        echo 移行元バックアップはすでに実行済みです。
        pause >nul
        goto menu
    )

    call :log "選択 1: 移行元バックアップ作成 実行"

    if not exist "%~dp0移行元バックアップ作成.bat" (
        call :log "移行元バックアップ作成.bat が見つかりません"
        echo バッチファイルが見つかりませんでした。
        pause >nul
        goto menu
    )

    call "%~dp0移行元バックアップ作成.bat"

    if exist "%RESULTDIR%\移行元バックアップ作成.OK" (
        call :log "移行元バックアップ作成：成功"
    ) else if exist "%RESULTDIR%\移行元バックアップ作成.NG" (
        call :log "移行元バックアップ作成：失敗"
    ) else (
        call :log "移行元バックアップ作成：結果ファイルなし"
    )
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

:: ログ書き込みサブルーチン
:log
setlocal
set "msg=%~1"
for /f "tokens=1-2 delims= " %%a in ('date /t') do set "d=%%a"
for /f "tokens=1-2 delims= " %%x in ('time /t') do set "t=%%x"
>> "%LOGFILE%" echo [%d% %t%] %COMPUTERNAME%: %msg%
endlocal
goto :eof

:: ステータス表示用サブルーチン
:show_status
setlocal
set status=未実施
set id=%1
set name=%~2
set padding=%~3

if exist "%RESULTDIR%\%name%.OK" (
    set status=成功
) else if exist "%RESULTDIR%\%name%.NG" (
    set status=失敗
)

:: 出力時に余計なクオートがないよう注意
echo    %id%. %name%%padding%%status%
endlocal
goto :eof
