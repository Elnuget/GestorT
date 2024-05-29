@echo off
cd /d "%~dp0"

echo Activando entorno virtual...
call EntornoV\Scripts\activate

echo Iniciando la aplicacion Flask...
start /b python app.py

echo Abriendo Visual Studio Code en la carpeta actual...
start code .

echo Abriendo el navegador...
timeout /t 5 /nobreak > NUL
start http://localhost:5000


echo Listo.