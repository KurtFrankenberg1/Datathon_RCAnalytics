import pandas as pd
import re
from unidecode import unidecode
import csv
import mysql.connector

# Credenciales de la base de datos
db_host = "b0ccsqviazxzwkmkzomm-mysql.services.clever-cloud.com"
db_name = "b0ccsqviazxzwkmkzomm"
db_user = "uogyrhllhrne0biy"
db_password = "tpcKoaoPyafspPmvDxbt"
db_port = 3306

# Conectarse a la base de datos
connection = mysql.connector.connect(
    host=db_host,
    database=db_name,
    user=db_user,
    password=db_password,
    port=db_port
)

# Crear cursor
cursor = connection.cursor()
    
# Ruta del archivo CSV original y la ruta para el archivo CSV limpiado
ruta_csv_original = "C:/Users/kurt.frankenberg_rac/Documents/Datathon/HEY BANCO BDD.csv"
ruta_csv_limpiado = "C:/Users/kurt.frankenberg_rac/Documents/Datathon/HEY_BANCO_BDD_limpiado.csv"

# Leer el archivo CSV original
data = pd.read_csv(ruta_csv_original)

# Función para limpiar el texto
def limpiar_texto(texto):
    # Quitar acentos y caracteres no ASCII
    texto_limpio = ''.join((c for c in texto if ord(c) < 128))
    # Quitar iconos y emoticones
    texto_limpio = re.sub(r'[^\x00-\x7F]+', '', texto_limpio)
    # Eliminar emoticones, caritas y símbolos no deseados
    texto_limpio = re.sub(r'[:;=]-?[\(\)cC]+|[\(\)cC]+-?[:;=]|[{}\[\]/\\@#$%&¿¡!?]', '', texto_limpio)
    # Utilizar unidecode para quitar acentos y diacríticos
    texto_limpio = unidecode(texto_limpio)
    return texto_limpio

# Función para convertir el formato de fecha
def convertir_fecha(fecha):
    # Separar la fecha en día, mes y año
    dia, mes, anio = fecha.split('/')
    # Construir la fecha en el formato YYYY-MM-DD
    fecha_con_formato = f"{anio}-{mes}-{dia}"
    return fecha_con_formato

# Aplicar la función de limpieza a la columna 'tweet'
data['tweet'] = data['tweet'].apply(limpiar_texto)

# Eliminar la columna 'time'
data = data.drop(columns=['time'])

# Convertir el formato de la columna 'date'
data['date'] = data['date'].apply(convertir_fecha)

# Guardar el DataFrame resultante como un nuevo archivo CSV
data.to_csv(ruta_csv_limpiado, index=False)

# Ruta del archivo CSV limpiado
csv_file_path = ruta_csv_limpiado

# Abrir el archivo CSV y leer los datos
with open(csv_file_path, 'r', encoding='utf-8') as file:
    csv_reader = csv.reader(file)
    next(csv_reader)  # Saltar la primera fila si contiene encabezados
    for row in csv_reader:
        # Insertar datos en la tabla R_DB
        query = "INSERT INTO R__DB (fecha, tweet) VALUES (%s, %s)"
        cursor.execute(query, (row[0], row[1]))

# Confirmar los cambios y cerrar la conexión
connection.commit()
connection.close()

print("carga lista")





