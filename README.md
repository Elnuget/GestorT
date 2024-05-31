Nombre del proyecto: 
Gestor de tareas usando Python, Flask y MySQL

Descripción: 
Un gestor de tareas en donde el usuario podrá ordenar sus tareas tanto de forma individual como en forma grupal, con la capacidad de gestión de grupos, cambios de foto de perfil, asignación de usuarios, y chat en vivo.

Instalación: 
DEBE ASEGURARSE QUE TENGA INSTALADO PYTHON 3
Primero: Descargar Python 3 en la web oficial.
Segundo: Instalar la base de datos local ubicada en BasesDeDatos en el gestor de bases de datos de MySQL.

Pasos para la instalación del ambiente virtual:
- Abrir una terminal.
- Colocar: pip install virtualenv
- Colocar: python -m venv EntornoV
- Colocar: EntornoV\Scripts\activate
- Colocar: pip install Flask
- Colocar: pip install Flask Flask-MySQL-Connector
- Colocar: pip install Flask Flask-MySQLdb
- Colocar: pip install flask-socketio

No olvidar el "Aceptar" el ambiente virtual para su uso en el proyecto.
Para cerrar el ambiente virtual, usar el comando: deactivate.

Uso:
Abrir app.py y darle a iniciar el proyecto en el botón en la esquina superior derecha.


Partes importantes del código en app.py: 
Linea 39: VARIABLES DE SESIÓN
Linea 105: RUTAS PARA LA OBTENCIÓN DE TAREAS DE FORMA INDIVIDUAL
Linea 249: RUTAS PARA LA OBTENCIÓN DE TAREAS DE FORMA GRUPAL
Linea 589: RUTAS PARA LA OBTENCIÓN DEL CHAt GRUPAL
Linea 613: RUTAS PARA LA OBTENCIÓN DE LAS NOTIFICACIONES DEL GRUPAL
Linea 650: RUTAS PARA LA OBTENCIÓN DE LAS IMAGENES DE PERFIL DEL USUARIO