import psycopg2

try:
    #--
    conextion = psycopg2.connect(database = 'DB_SCAHL', user = 'postgres', password = 'Santiago123.')
    cursor = conextion.cursor()
    #--
    sql = 'SELECT SUM(Salario_Base), Area FROM Empleados GROUP BY Area'
    cursor.execute(sql)
    registros = cursor.fetchall()
    for fila in registros:
        for campo in fila:
            print(campo, end = ' - ')
        print()
    #--
    cursor.close()
    conextion.close()
except Exception as Ex:
    print(Ex)