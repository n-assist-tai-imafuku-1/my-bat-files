@echo off
echo ===============================
echo INF�t�H���_���̑S�h���C�o���C���|�[�g
echo ===============================

set /p INF_DIR=INF�t�@�C���̂���t�H���_����͂��Ă��������i��: C:\Drivers�j: 

if not exist "%INF_DIR%" (
    echo [�G���[] �t�H���_�����݂��܂���B
    pause
    exit /b
)

echo INF�t�H���_���̂��ׂĂ�INF���������܂�...

for %%f in ("%INF_DIR%\*.inf") do (
    echo �C���|�[�g��: %%f
    pnputil /add-driver "%%f" /install
)

echo.
echo ===============================
echo ���ׂĂ�INF���C���|�[�g����
echo ===============================
pause
