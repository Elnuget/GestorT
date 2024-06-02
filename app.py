# Importaciones necesarias de Flask y otras bibliotecas

from flask import Flask, render_template, request, session, redirect, url_for  # Importa funciones esenciales de Flask
import config  # Importa configuraciones desde un archivo externo llamado config.py
from flask_mysqldb import MySQL  # Importa la extensión Flask-MySQLdb para la conexión con MySQL
from datetime import datetime  # Importa la clase datetime para manejar fechas y horas
from flask import flash  # Importa la función flash para mostrar mensajes flash en las plantillas
from flask_socketio import SocketIO  # Importa SocketIO para manejo de WebSockets
from flask import jsonify  # Importa la función jsonify para convertir datos a formato JSON
import subprocess  # Importa el módulo subprocess para ejecutar comandos del sistema
import os  # Importa el módulo os para interactuar con el sistema operativo
from werkzeug.utils import secure_filename  # Importa secure_filename para asegurar nombres de archivos
from MySQLdb import ProgrammingError  # Importa una clase de error específica de MySQLdb
from flask import Flask, jsonify, session
from mysql.connector import connect, cursor  # Importa funciones para conectar y manejar cursor con MySQL
from flask import send_from_directory  # Importa la función send_from_directory para enviar archivos desde un directorio
import uuid  # Importa uuid para generar identificadores únicos
from flask_mysqldb import MySQL, MySQLdb
from flask_mail import Mail, Message
import config  # Importa configuraciones desde un archivo externo llamado config.py


# Inicializar la aplicación Flask
app = Flask(__name__)
socketio = SocketIO(app) # Inicializa SocketIO con la aplicación Flask
app.config['UPLOAD_FOLDER'] = config.UPLOAD_FOLDER # Configura la carpeta de subida de archivos


# Configuración de la clave secreta y la conexión a MySQL usando datos de "config.py"
app.config['SECRET_KEY'] = config.HEX_SEC_KEY  # Configura la clave secreta para la sesión
app.config['MYSQL_HOST'] = config.MYSQL_HOST  # Configura el host de MySQL
app.config['MYSQL_USER'] = config.MYSQL_USER  # Configura el usuario de MySQL
app.config['MYSQL_PASSWORD'] = config.MYSQL_PASSWORD  # Configura la contraseña de MySQL
app.config['MYSQL_DB'] = config.MYSQL_DB  # Configura la base de datos de MySQL


# Creación de una instancia de la clase MySQL para interactuar con la base de datos
mysql = MySQL(app)

###########################################
#VARIABLES DE SESIÓN A PARTIR DE ESTA PARTE
###########################################
 
# Definir la ruta para la página principal
@app.route('/')
def home():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión
    return render_template('home.html', title='Inicio | Task Manager')  # Muestra la página principal


# Ruta para el inicio de sesión
@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']  # Obtiene el correo electrónico del formulario
    password = request.form['password']  # Obtiene la contraseña del formulario

    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT * FROM users WHERE email = %s AND password = %s", (email, password))  # Verifica las credenciales del usuario
    user = cur.fetchone()  # Recupera el usuario si existe
    cur.close()  # Cierra el cursor

    if user is not None:
        session['email'] = email  # Almacena el correo electrónico en la sesión
        session['name'] = user[1]  # Almacena el nombre en la sesión
        session['surnames'] = user[2]  # Almacena los apellidos en la sesión
        return redirect(url_for('tasks'))  # Redirige a la página de tareas
    else:
        return render_template('index.html', message="Las credenciales no son correctas")  # Muestra un mensaje de error


# Ruta para cerrar sesión
@app.route('/logout')
def logout():
    session.clear()  # Limpia todos los datos de la sesión
    return redirect(url_for('home'))  # Redirige a la página principal


# Definir la ruta para el registro de usuarios
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']  # Obtiene el nombre del formulario
        surnames = request.form['surnames']  # Obtiene los apellidos del formulario
        email = request.form['email']  # Obtiene el correo electrónico del formulario
        password = request.form['password']  # Obtiene la contraseña del formulario

        if not name or not surnames or not email or not password:
            flash('Todos los campos son obligatorios', 'danger')  # Muestra un mensaje de error si faltan campos
            return redirect(url_for('register'))  # Redirige a la página de registro

        if name and surnames and email and password:
            cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
            sql = "INSERT INTO users (name, surnames, email, password) VALUES (%s, %s, %s, %s)"  # Inserta un nuevo usuario en la base de datos
            data = (name, surnames, email, password)  # Datos del nuevo usuario
            cur.execute(sql, data)  # Ejecuta la consulta
            mysql.connection.commit()  # Confirma los cambios en la base de datos
            #notify_users({'message': 'Nueva tarea creada'})  # Notifica a los usuarios sobre la nueva tarea

            flash('Usuario registrado correctamente', 'success')  # Muestra un mensaje de éxito
            return redirect(url_for('home'))  # Redirige a la página principal

    return render_template('register.html')  # Renderiza el formulario de registro si el método es GET o si hay errores en el formulario

##########################################################
#RUTAS PARA LA OBTENCIÓN DE TAREAS DE FORMA INDIVIDUAL
##########################################################

# Ruta para mostrar las tareas del usuario
@app.route('/tasks', methods=['GET'])
def tasks():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión

    email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT * FROM tasks WHERE email = %s", [email])  # Selecciona las tareas del usuario
    tasks = cur.fetchall()  # Recupera todas las tareas del usuario
    
    # Procesamiento de los resultados de la consulta para facilitar su uso en la plantilla
    insertObject = []
    columnNames = [column[0] for column in cur.description]  # Obtiene los nombres de las columnas de la consulta
    for record in tasks:
        insertObject.append(dict(zip(columnNames, record)))  # Convierte cada fila de resultados en un diccionario
    cur.close()  # Cierra el cursor
    title = 'Tareas | Task Manager'
    return render_template('tasks.html', tasks=insertObject, title=title)  # Renderiza la plantilla de tareas con los datos obtenidos


# Ruta para agregar una nueva tarea
@app.route('/new-task', methods=['POST'])
def newTask():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión

    # Obtención de datos del formulario de nueva tarea
    title = request.form['title']
    description = request.form['description']
    email = session['email']
    d = datetime.now()
    dateTask = d.strftime("%Y-%m-%d")
    
    # Verificación de la existencia de datos y almacenamiento en la base de datos
    if title and description and email:
        cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
        sql = "INSERT INTO tasks (email, title, description, date_task) VALUES (%s, %s, %s, %s)"  # Consulta SQL para insertar una nueva tarea
        data = (email, title, description, dateTask)
        cur.execute(sql, data)  # Ejecuta la consulta con los datos proporcionados
        mysql.connection.commit()  # Confirma los cambios en la base de datos
        cur.close()  # Cierra el cursor

        # notify_users({'message': 'Nueva tarea creada'})  # Notificar a los usuarios (comentado)
    return redirect(url_for('tasks'))  # Redirige a la página de tareas


# Ruta para agregar o actualizar el estado de una tarea
@app.route('/update-task-status/<int:task_id>', methods=['POST'])
def updateTaskStatus(task_id):
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return redirect(url_for('index'))  # Redirige a la página de inicio de sesión

    # Obtener el estado seleccionado desde el formulario
    status = request.form['status']

    # Actualizar el estado de la tarea en la base de datos
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("UPDATE tasks SET status = %s WHERE id = %s", (status, task_id))  # Actualiza el estado de la tarea
    mysql.connection.commit()  # Confirma los cambios en la base de datos
    cur.close()  # Cierra el cursor

    flash('Estado de tarea actualizado exitosamente', 'success')  # Muestra un mensaje de éxito
    return redirect(url_for('tasks'))  # Redirige a la página de tareas


# Ruta para eliminar una tarea
@app.route("/delete-task", methods=["POST"])
def deleteTask():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión

    # Obtención del ID de la tarea a eliminar y ejecución de la consulta DELETE
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    id = request.form['id']  # Obtiene el ID de la tarea del formulario
    sql = "DELETE FROM tasks WHERE id = %s"  # Consulta SQL para eliminar la tarea
    data = (id,)  # Datos a eliminar
    cur.execute(sql, data)  # Ejecuta la consulta
    mysql.connection.commit()  # Confirma los cambios en la base de datos
    cur.close()  # Cierra el cursor

    # notify_users({'message': 'Nueva tarea creada'})  # Notificar a los usuarios (comentado)
    return redirect(url_for('tasks'))  # Redirige a la página de tareas


 # Definir la ruta para obtener datos de tareas
@app.route('/get-tasks-data')
def get_tasks_data():
    if 'email' not in session: # Verifica si el usuario no está autenticado
        return jsonify({'error': 'Usuario no autenticado'}), 403  # Devuelve un error JSON si no está autenticado

    user_email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    query = """
    SELECT gt.* FROM group_tasks gt
    JOIN `groups` g ON gt.group_id = g.id
    WHERE g.group_members LIKE %s
    """  # Consulta SQL para obtener las tareas de los grupos a los que pertenece el usuario
    cur.execute(query, [f'%{user_email}%'])  # Ejecuta la consulta con el correo del usuario
    tasks = cur.fetchall()  # Recupera todas las filas resultantes de la consulta
    cur.close()  # Cierra el cursor
    return jsonify(tasks)  # Devuelve las tareas en formato JSON


# Ruta para modificar una tarea de un usuario individual
@app.route('/edit-task/<int:task_id>', methods=['GET', 'POST'])
def edit_task(task_id):
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión

    # Obtén la tarea desde la base de datos usando task_id
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT * FROM tasks WHERE id = %s", [task_id])  # Consulta para obtener la tarea
    task = cur.fetchone()  # Obtiene el resultado de la consulta
    cur.close()  # Cierra el cursor
    title = 'Editar Tarea | Task Manager'  # Título de la página

    if request.method == 'POST':  # Verifica si la solicitud es POST
        # Si el formulario se envió, actualiza los datos de la tarea en la base de datos
        new_title = request.form['title']  # Obtiene el nuevo título de la tarea del formulario
        new_description = request.form['description']  # Obtiene la nueva descripción de la tarea del formulario

        cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
        cur.execute("UPDATE tasks SET title = %s, description = %s WHERE id = %s", (new_title, new_description, task_id))  # Consulta para actualizar la tarea
        mysql.connection.commit()  # Confirma los cambios en la base de datos
        # notify_users({'message': 'Nueva tarea creada'})  # Notificar a los usuarios (comentado)
        cur.close()  # Cierra el cursor

        flash('Tarea actualizada correctamente', 'success')  # Muestra un mensaje de éxito
        return redirect(url_for('tasks'))  # Redirige a la página de tareas

    # Renderiza la página de edición con los detalles de la tarea
    return render_template('edit_task.html', task=task, title=title)  # Renderiza la plantilla con los datos obtenidos


###################################################
#RUTAS PARA LA OBTENCIÓN DE TAREAS DE FORMA GRUPAL
###################################################

# Ruta para crear un grupo
@app.route('/create-group', methods=['GET', 'POST'])
def create_group():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión

    group_id = None  # Inicializa group_id por si acaso no se entra al bloque if

    if request.method == 'POST':  # Verifica si la solicitud es POST
        # Obtener los datos del formulario de creación de grupo
        group_name = request.form['group_name']  # Obtiene el nombre del grupo
        group_members = request.form['group_members']  # Obtiene los miembros del grupo
        creator_email = session['email']  # Obtiene el correo electrónico del creador desde la sesión

        # Validar y agregar el nuevo grupo a la base de datos
        if group_name and group_members:  # Verifica que todos los campos están llenos
            cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
            sql = "INSERT INTO `groups` (group_name, group_members, created_by) VALUES (%s, %s, %s)"  # Consulta SQL para insertar un nuevo grupo
            data = (group_name, group_members, creator_email)  # Datos a insertar
            cur.execute(sql, data)  # Ejecuta la consulta
            group_id = cur.lastrowid  # Obtiene el ID del último grupo insertado
            mysql.connection.commit()  # Confirma los cambios en la base de datos
            cur.close()  # Cierra el cursor

            # notify_users('user_added_to_group', {'group_id': group_id, 'user_email': session['email']})  # Notificar a los usuarios (comentado)
            flash('Grupo creado correctamente', 'success')  # Muestra un mensaje de éxito
            return redirect(url_for('tasks'))  # Redirige a la página de tareas

    title = 'Crear Grupo | Task Manager'
    
    # Si group_id no es None, significa que el grupo fue creado y podemos usar el group_id
    if group_id:
        notify_users('user_added_to_group', {'group_id': group_id, 'user_email': session['email']})  # Notificar a los usuarios

    # Renderizar el formulario de creación de grupo si la solicitud es GET o si hay errores en el formulario
    return render_template('create_group.html', title=title)


# Ruta para abandonar un grupo
@app.route('/leave-group/<int:group_id>', methods=['POST'])
def leave_group(group_id):
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return redirect(url_for('index'))  # Redirige a la página de inicio de sesión

    email = session['email']  # Obtiene el correo del usuario desde la sesión
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT group_members FROM `groups` WHERE id = %s", [group_id])  # Selecciona los miembros del grupo
    group = cur.fetchone()  # Recupera los miembros del grupo

    if group:
        members = group[0].split(',')  # Divide los miembros por comas
        members = [member.strip() for member in members]  # Elimina espacios en blanco alrededor de los correos
        if email in members:
            members.remove(email)  # Elimina el correo del usuario de los miembros
            new_members = ','.join(members)  # Une los miembros restantes en una cadena
            cur.execute("UPDATE `groups` SET group_members = %s WHERE id = %s", (new_members, group_id))  # Actualiza la base de datos con los nuevos miembros
            mysql.connection.commit()  # Confirma los cambios en la base de datos
            flash('Has abandonado el grupo correctamente', 'success')  # Muestra un mensaje de éxito
        else:
            flash('No eres miembro de este grupo', 'danger')  # Muestra un mensaje de error
    else:
        flash('El grupo no existe', 'danger')  # Muestra un mensaje de error si el grupo no existe

    cur.close()  # Cierra el cursor
    return redirect(url_for('groups'))  # Redirige a la página de grupos


# Cargar grupos del usuario
@app.context_processor
def inject_user_groups():
    if 'email' in session:  # Verifica si el usuario ha iniciado sesión
        email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
        cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
        cur.execute("SELECT * FROM `groups` WHERE group_members LIKE %s", ['%' + email + '%'])  # Selecciona los grupos a los que pertenece el usuario
        user_groupsg = cur.fetchall()  # Recupera todos los grupos que coinciden con el correo del usuario
        columnNames = [column[0] for column in cur.description]  # Obtiene los nombres de las columnas de la consulta
        insertObject = [dict(zip(columnNames, record)) for record in user_groupsg]  # Convierte los resultados en una lista de diccionarios
        cur.close()  # Cierra el cursor
        return {'user_groupsg': insertObject}  # Devuelve los grupos del usuario para ser inyectados en el contexto de las plantillas
    return {}  # Si el usuario no ha iniciado sesión, devuelve un diccionario vacío


# Ruta para obtener datos adicionales
@app.route('/ruta-para-obtener-datos')
def obtener_datos():
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT MAX(id) FROM group_tasks")  # Obtiene el ID máximo de las tareas de grupo
    max_group_task_id = cur.fetchone()[0]

    cur.execute("SELECT MAX(id) FROM tasks")  # Obtiene el ID máximo de las tareas
    max_task_id = cur.fetchone()[0]

    cur.close()  # Cierra el cursor
    return jsonify({'max_group_task_id': max_group_task_id, 'max_task_id': max_task_id})  # Devuelve los datos en formato JSON


# Ruta para agregar un nuevo usuario
@app.route('/new-user', methods=['POST'])
def newUser():
    # Obtención de datos del formulario de nuevo usuario
    name = request.form['name']  # Obtiene el nombre del formulario
    surnames = request.form['surnames']  # Obtiene los apellidos del formulario
    email = request.form['email']  # Obtiene el correo electrónico del formulario
    password = request.form['password']  # Obtiene la contraseña del formulario

    # Verificación de la existencia de datos y almacenamiento en la base de datos
    if name and surnames and email and password:  # Verifica que todos los campos están llenos
        cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
        sql = "INSERT INTO users (name, surnames, email, password) VALUES (%s, %s, %s, %s)"  # Consulta SQL para insertar un nuevo usuario
        data = (name, surnames, email, password)  # Datos a insertar
        cur.execute(sql, data)  # Ejecuta la consulta
        mysql.connection.commit()  # Confirma los cambios en la base de datos
        cur.close()  # Cierra el cursor

        # notify_users({'message': 'Nueva tarea creada'})  # Notificar a los usuarios (comentado)
    return redirect(url_for('tasks'))  # Redirige a la página de tareas


# Ruta para ver la lista de grupos
@app.route('/groups', methods=['GET'])
def groups():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión

    email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT * FROM `groups` WHERE created_by = %s", [email])  # Selecciona los grupos creados por el usuario
    user_groups = cur.fetchall()  # Recupera todos los grupos del usuario
    columnNames = [column[0] for column in cur.description]  # Obtiene los nombres de las columnas de la consulta
    insertObject = [dict(zip(columnNames, record)) for record in user_groups]  # Convierte los resultados en una lista de diccionarios
    cur.close()  # Cierra el cursor

    title = 'Grupos | Task Manager'
    return render_template('groups.html', user_groups=insertObject, title=title)  # Renderiza la plantilla de grupos con los datos obtenidos


# Ruta para eliminar un grupo
@app.route('/delete-group/<int:group_id>', methods=['POST'])
def delete_group(group_id):
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return redirect(url_for('index'))  # Redirige a la página de inicio de sesión

    email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL

    try:
        
        # Primero, elimina todas las tareas relacionadas con el grupo
        cur.execute("DELETE FROM group_tasks WHERE group_id = %s", (group_id,))
        mysql.connection.commit()

        # Luego, elimina el grupo
        cur.execute("DELETE FROM `groups` WHERE id = %s AND created_by = %s", (group_id, email))
        mysql.connection.commit()

        flash('Grupo y tareas relacionadas eliminados correctamente', 'success')  # Muestra un mensaje de éxito
    except ProgrammingError as e:
        flash(f'Error al eliminar el grupo: {e}', 'danger')  # Muestra un mensaje de error en caso de fallo
    finally:
        cur.close()  # Cierra el cursor

    return redirect(url_for('groups'))  # Redirige a la página de grupos


# Ruta para mostrar el formulario de edición de grupo
@app.route('/edit-group/<int:group_id>', methods=['GET', 'POST'])
def edit_group(group_id):
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return redirect(url_for('index'))  # Redirige a la página de inicio de sesión

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)  # Crea un cursor para ejecutar comandos SQL y obtener resultados como diccionarios
    cur.execute("SELECT * FROM `groups` WHERE id = %s AND created_by = %s", (group_id, session['email']))  # Selecciona el grupo a editar
    group = cur.fetchone()  # Obtiene el grupo de la consulta

    if request.method == 'POST':  # Verifica si la solicitud es POST
        group_name = request.form['group_name']  # Obtiene el nuevo nombre del grupo del formulario
        group_members = request.form['group_members']  # Obtiene los nuevos miembros del grupo del formulario
        
        if group_name and group_members:  # Verifica que todos los campos están llenos
            cur.execute("""
                UPDATE `groups` 
                SET group_name = %s, group_members = %s 
                WHERE id = %s AND created_by = %s
            """, (group_name, group_members, group_id, session['email']))  # Actualiza el nombre y los miembros del grupo
            mysql.connection.commit()  # Confirma los cambios en la base de datos
            cur.close()  # Cierra el cursor
            flash('Grupo actualizado correctamente', 'success')  # Muestra un mensaje de éxito
            return redirect(url_for('groups'))  # Redirige a la página de grupos

    cur.close()  # Cierra el cursor
    return render_template('edit_group.html', group=group)  # Renderiza la plantilla de edición de grupo con los datos obtenidos


# Ruta para visualizar las tareas dentro de un grupo
@app.route('/group-tasks/<int:group_id>', methods=['GET', 'POST'])
def group_tasks(group_id):
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión
    
    if request.method == 'POST':  # Verifica si la solicitud es POST
        # Obtener datos del formulario de nueva tarea de grupo
        title = request.form['title']  # Obtiene el título de la tarea del formulario
        description = request.form['description']  # Obtiene la descripción de la tarea del formulario
        assigned_user_email = request.form['assigned_user_email'].strip()  # Obtiene y elimina espacios en blanco del correo del usuario asignado
        email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
        d = datetime.now()  # Obtiene la fecha y hora actual
        date_task = d.strftime("%Y-%m-%d %H:%M:%S")  # Formatea la fecha y hora actual

        # Verificación de la existencia de datos y almacenamiento en la base de datos
        if title and description and email and assigned_user_email:  # Verifica que todos los campos están llenos
            # Verificar si el assigned_user_email existe en la tabla users
            cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
            cur.execute("SELECT * FROM users WHERE email = %s", [assigned_user_email])  # Consulta para verificar la existencia del usuario asignado
            user_exists = cur.fetchone()  # Obtiene el resultado de la consulta
            cur.close()  # Cierra el cursor

            if user_exists:  # Si el usuario existe
                # El usuario existe, proceder con la inserción en group_tasks
                try:
                    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
                    sql = "INSERT INTO group_tasks (group_id, user_email, title, description, assigned_user_email, date_task) VALUES (%s, %s, %s, %s, %s, %s)"  # Consulta SQL para insertar una nueva tarea de grupo
                    data = (group_id, email, title, description, assigned_user_email, date_task)  # Datos a insertar
                    cur.execute(sql, data)  # Ejecuta la consulta
                    mysql.connection.commit()  # Confirma los cambios en la base de datos
                    notify_users({'message': 'Nueva tarea creada'})  # Notificar a los usuarios
                    flash('Tarea de grupo agregada correctamente', 'success')  # Muestra un mensaje de éxito
                except Exception as e:  # Maneja cualquier excepción que ocurra
                    flash(f'Error al agregar tarea de grupo: {str(e)}', 'danger')  # Muestra un mensaje de error
                finally:
                    cur.close()  # Cierra el cursor
                return redirect(url_for('group_tasks', group_id=group_id))  # Redirige a la página de tareas del grupo
            else:
                flash('Error: El usuario asignado no existe', 'danger')  # Muestra un mensaje de error si el usuario no existe
                return redirect(url_for('group_tasks', group_id=group_id))  # Redirige a la página de tareas del grupo

    # Obtener detalles del grupo y sus tareas
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT * FROM `groups` WHERE id = %s", [group_id])  # Consulta para obtener los detalles del grupo
    group = cur.fetchone()  # Obtiene el resultado de la consulta

    # Obtener tareas asociadas con el grupo
    cur.execute("SELECT * FROM group_tasks WHERE group_id = %s", [group_id])  # Consulta para obtener las tareas del grupo
    tasks = cur.fetchall()  # Obtiene todos los resultados de la consulta
    title = 'Tareas de Grupo | Task Manager'  # Título de la página

    # Procesamiento de los resultados de la consulta para facilitar su uso en la plantilla
    insertObject = []  # Lista para almacenar las tareas procesadas
    columnNames = [column[0] for column in cur.description]  # Obtiene los nombres de las columnas de la consulta
    for record in tasks:
        insertObject.append(dict(zip(columnNames, record)))  # Convierte los resultados en una lista de diccionarios
    cur.close()  # Cierra el cursor

    return render_template('group_tasks.html', group=group, tasks=insertObject, title=title)  # Renderiza la plantilla con los datos obtenidos


# Ruta para eliminar una tarea de grupo
@app.route("/delete-group-task", methods=["POST"])
def delete_group_task():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión

    # Obtención del ID de la tarea a eliminar y el group_id
    id = request.form['id']  # Obtiene el ID de la tarea del formulario
    group_id = request.form['group_id']  # Obtiene el ID del grupo del formulario

    # Ejecución de la consulta DELETE
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    sql = "DELETE FROM group_tasks WHERE id = %s"  # Consulta SQL para eliminar la tarea
    data = (id,)  # Datos a eliminar
    cur.execute(sql, data)  # Ejecuta la consulta
    mysql.connection.commit()  # Confirma los cambios en la base de datos
    cur.close()  # Cierra el cursor

    # notify_users({'message': 'Nueva tarea creada'})  # Notificar a los usuarios (comentado)
    flash('Tarea de grupo eliminada correctamente', 'success')  # Muestra un mensaje de éxito
    return redirect(url_for('group_tasks', group_id=group_id))  # Redirige a la página de tareas del grupo


# Ruta para editar las tareas de un grupo
@app.route('/edit-group-task/<int:group_id>/<int:task_id>', methods=['GET', 'POST'])
def edit_group_task(group_id, task_id):
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return render_template('index.html')  # Redirige a la página de inicio de sesión

    # Obtén la tarea desde la base de datos usando task_id y group_id
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT * FROM group_tasks WHERE id = %s AND group_id = %s", (task_id, group_id))  # Consulta para obtener la tarea del grupo
    task = cur.fetchone()  # Obtiene el resultado de la consulta
    cur.close()  # Cierra el cursor
    title = 'Editar Tarea | Task Manager'  # Título de la página

    if request.method == 'POST':  # Verifica si la solicitud es POST
        # Si el formulario se envió, actualiza los datos de la tarea en la base de datos
        new_title = request.form['title']  # Obtiene el nuevo título de la tarea del formulario
        new_description = request.form['description']  # Obtiene la nueva descripción de la tarea del formulario

        cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
        cur.execute("UPDATE group_tasks SET title = %s, description = %s WHERE id = %s", (new_title, new_description, task_id))  # Consulta para actualizar la tarea del grupo
        mysql.connection.commit()  # Confirma los cambios en la base de datos
        # notify_users({'message': 'Nueva tarea creada'})  # Notificar a los usuarios (comentado)
        cur.close()  # Cierra el cursor

        flash('Tarea de grupo actualizada correctamente', 'success')  # Muestra un mensaje de éxito
        return redirect(url_for('group_tasks', group_id=group_id))  # Redirige a la página de tareas del grupo

    # Renderiza la página de edición con los detalles de la tarea
    return render_template('edit_group_task.html', task=task, group_id=group_id, title=title)  # Renderiza la plantilla con los datos obtenidos

# Ruta para actualizar el estado de una tarea de grupo
@app.route('/update-group-task-status/<int:task_id>', methods=['POST'])
def update_group_task_status(task_id):
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        flash('Debes iniciar sesión primero', 'danger')  # Muestra un mensaje de error
        return redirect(url_for('home'))  # Redirige a la página de inicio

    # Obtener el estado seleccionado desde el formulario
    status = request.form['status']  # Obtiene el nuevo estado de la tarea del formulario

    # Actualizar el estado de la tarea de grupo en la base de datos
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("UPDATE group_tasks SET status = %s WHERE id = %s", (status, task_id))  # Consulta para actualizar el estado de la tarea
    mysql.connection.commit()  # Confirma los cambios en la base de datos
    cur.close()  # Cierra el cursor

    flash('Estado de tarea de grupo actualizado exitosamente', 'success')  # Muestra un mensaje de éxito
    return redirect(url_for('group_tasks', group_id=group_id))  # Redirige a la página de tareas del grupo


#########################################
#RUTAS PARA LA OBTENCIÓN DEL CHAt GRUPAL
#########################################

# Ruta para obtener mensajes del chat de grupo
@app.route('/get-group-chat/<int:group_id>', methods=['GET'])
def get_group_chat(group_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)  # Crea un cursor para ejecutar comandos SQL con un dict cursor
    cursor.execute('SELECT * FROM group_chats WHERE group_id = %s ORDER BY created_at ASC', (group_id,))  # Consulta para obtener los mensajes del chat de grupo ordenados por fecha de creación
    chat_messages = cursor.fetchall()  # Obtiene todos los resultados de la consulta
    return jsonify(chat_messages)  # Retorna los mensajes como JSON

# Ruta para enviar un mensaje al chat de grupo
@app.route('/send-group-chat', methods=['POST'])
def send_group_chat():
    group_id = request.form['group_id']  # Obtiene el ID del grupo del formulario
    user_email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
    message = request.form['message']  # Obtiene el mensaje del formulario
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)  # Crea un cursor para ejecutar comandos SQL con un dict cursor
    cursor.execute('INSERT INTO group_chats (group_id, user_email, message) VALUES (%s, %s, %s)', (group_id, user_email, message))  # Consulta para insertar el mensaje en la base de datos
    mysql.connection.commit()  # Confirma los cambios en la base de datos
    return jsonify({'status': 'Message sent'})  # Retorna un mensaje de éxito como JSON


#########################################################
#RUTAS PARA LA OBTENCIÓN DE LAS NOTIFICACIONES DEL GRUPAL
#########################################################

# Ruta para cargar notificaciones
@app.route('/api/notifications', methods=['GET'])
def api_notifications():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        return jsonify({'error': 'Usuario no autenticado'}), 401  # Retorna un error JSON

    email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT * FROM `notifications` WHERE email = %s", [email])  # Consulta para obtener las notificaciones del usuario
    notifications = cur.fetchall()  # Obtiene todos los resultados de la consulta
    cur.close()  # Cierra el cursor

    notifications_list = [{'id': n[0], 'notification': n[2], 'status': n[3]} for n in notifications]  # Procesa los resultados en una lista de diccionarios
    return jsonify(notifications_list)  # Retorna las notificaciones como JSON

# Ruta para actualizar el estado de las notificaciones
@app.route('/api/update-notifications', methods=['POST'])
def update_notifications():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        return jsonify({'error': 'Usuario no autenticado'}), 401  # Retorna un error JSON

    email = session['email']  # Obtiene el correo electrónico del usuario desde la sesión
    try:
        conn = mysql.connection  # Obtiene la conexión a la base de datos
        cur = conn.cursor()  # Crea un cursor para ejecutar comandos SQL
        cur.execute("UPDATE notifications SET status = 'Inactiva' WHERE email = %s", [email])  # Consulta para actualizar el estado de las notificaciones
        conn.commit()  # Confirma los cambios en la base de datos
        cur.close()  # Cierra el cursor
        return jsonify({'message': 'Notificaciones actualizadas correctamente'}), 200  # Retorna un mensaje de éxito como JSON
    except Exception as e:  # Maneja cualquier excepción que ocurra
        return jsonify({'error': str(e)}), 500  # Retorna un error JSON


###############################################################
#RUTAS PARA LA OBTENCIÓN DE LAS IMAGENES DE PERFIL DEL USUARIO
###############################################################

# Extensiones de archivo permitidas para la subida de imágenes de perfil
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'webp'}

# Tamaño máximo de archivo permitido en MB
MAX_FILE_SIZE_MB = 2

# Función para verificar si un archivo tiene una extensión permitida
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Ruta para subir una imagen de perfil
@app.route('/upload-profile-image', methods=['POST'])
def upload_profile_image():
    if 'email' not in session:  # Verifica si el usuario no ha iniciado sesión
        return jsonify({'error': 'Debes iniciar sesión primero'}), 401  # Retorna un error JSON

    if 'file' not in request.files:  # Verifica si no se ha subido ningún archivo
        return jsonify({'error': 'No se ha seleccionado ningún archivo'}), 400  # Retorna un error JSON

    file = request.files['file']  # Obtiene el archivo subido

    if file.filename == '':  # Verifica si el nombre del archivo está vacío
        return jsonify({'error': 'No se ha seleccionado ningún archivo'}), 400  # Retorna un error JSON
    
    if not allowed_file(file.filename):  # Verifica si el archivo tiene una extensión permitida
        return jsonify({'error': 'Formato de archivo no permitido. Solo se permiten imágenes en formato PNG, JPG, JPEG, GIF o WEBP'}), 400  # Retorna un error JSON
    
    # Verificar el tamaño del archivo
    if 'file' in request.files:
        file_size_mb = request.cookies.get('file_size_mb')  # Obtiene el tamaño del archivo desde las cookies
        if file_size_mb and float(file_size_mb) > MAX_FILE_SIZE_MB:  # Verifica si el tamaño del archivo excede el máximo permitido
            return jsonify({'error': f'El tamaño máximo permitido del archivo es de {MAX_FILE_SIZE_MB} MB'}), 400  # Retorna un error JSON
    
    if request.method == 'POST':  # Verifica si la solicitud es POST
        file = request.files['file']  # Obtiene el archivo subido nuevamente
        cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
        cur.execute("SELECT profile_image FROM users WHERE email = %s", (session['email'],))  # Consulta para obtener la imagen de perfil anterior del usuario
        previous_profile_image = cur.fetchone()  # Obtiene el resultado de la consulta
        cur.close()  # Cierra el cursor

        if previous_profile_image:  # Verifica si hay una imagen de perfil anterior
            previous_filename = previous_profile_image[0]  # Obtiene el nombre del archivo de la imagen de perfil anterior
            if previous_filename:  # Verifica si el nombre del archivo anterior no es None
                try:
                    os.remove(os.path.join(app.config['UPLOAD_FOLDER'], previous_filename))  # Intenta eliminar la imagen de perfil anterior del sistema de archivos
                except FileNotFoundError:  # Maneja el caso en que el archivo no se encuentre
                    pass

        # Generar un nombre aleatorio único para el nuevo archivo
        filename = str(uuid.uuid4()) + secure_filename(file.filename)  # Genera un nombre único para el archivo
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))  # Guarda el archivo en el directorio de subida

        cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
        cur.execute("UPDATE users SET profile_image = %s WHERE email = %s", (filename, session['email']))  # Actualiza la imagen de perfil del usuario en la base de datos
        mysql.connection.commit()  # Confirma los cambios en la base de datos
        cur.close()  # Cierra el cursor

        return jsonify({'message': 'Imagen de perfil actualizada correctamente'}), 200  # Retorna un mensaje de éxito como JSON
    else:
        return jsonify({'error': 'Método no permitido'}), 405  # Retorna un error JSON indicando que el método no está permitido

# Ruta para servir una imagen de perfil subida
@app.route('/uploaded-profile-image/<filename>')
def uploaded_profile_image(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)  # Envía el archivo desde el directorio de subida

# Ruta para obtener el ID de usuario a partir del correo electrónico
def get_user_id_by_email(email):
    cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
    cur.execute("SELECT id FROM users WHERE email = %s", (email,))  # Consulta para obtener el ID del usuario
    user_id = cur.fetchone()  # Obtiene el resultado de la consulta
    cur.close()  # Cierra el cursor
    if user_id:
        return user_id[0]  # Retorna el ID del usuario
    else:
        return None  # Retorna None si no se encuentra el usuario

# Ruta para obtener la URL de la imagen de perfil del usuario autenticado
@app.route('/get-profile-image-url-master')
def get_profile_image_url_master():
    try:
        email = session.get('email')  # Obtiene el correo electrónico de la sesión
        if email:
            user_id = get_user_id_by_email(email)  # Obtiene el ID del usuario
            if user_id:
                cur = mysql.connection.cursor()  # Crea un cursor para ejecutar comandos SQL
                cur.execute("SELECT profile_image FROM users WHERE id = %s", (user_id,))  # Consulta para obtener la imagen de perfil del usuario
                profile_image = cur.fetchone()  # Obtiene el resultado de la consulta
                cur.close()  # Cierra el cursor
                profile_image_name = profile_image[0]  # Obtiene el nombre del archivo de la imagen de perfil
                if profile_image_name is None or not os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], profile_image_name)):
                    # Si no hay imagen de perfil o no existe el archivo, usa una imagen por defecto
                    profile_image_name = "perfil-por-defecto.png"
                    profile_image_url = f"/uploaded-profile-image/{profile_image_name}"
                    return jsonify({'profile_image_url': profile_image_url})  # Retorna la URL de la imagen por defecto
                else:
                    profile_image_url = f"/uploaded-profile-image/{profile_image_name}"
                    return jsonify({'profile_image_url': profile_image_url})  # Retorna la URL de la imagen de perfil del usuario
            return jsonify({'profile_image_url': '/static/Profile_image/default_profile.jpg'})  # Retorna la URL de una imagen por defecto si no se encuentra el usuario
        else:
            return jsonify({'error': 'Correo electrónico no encontrado en la sesión'})  # Retorna un error JSON si no hay correo electrónico en la sesión
    except Exception as e:
        return jsonify({'error': str(e)})  # Retorna un error JSON en caso de excepción

# Bloque principal de ejecución de la aplicación
if __name__ == '__main__':
    app.run(debug=True)  # Ejecuta la aplicación en modo debug
