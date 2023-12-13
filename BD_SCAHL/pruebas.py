import psycopg2
import bcrypt
from passlib.hash import bcrypt
from datetime import datetime

class ConextionDB:
    #--
    def __init__(self):
        #--
        try:
            #--
            self.__conextion = psycopg2.connect(
                database = 'DB_SCAHL',
                user = 'postgres',
                password = 'Santiago123.')
            self.__cursor = self.__conextion.cursor()
            #--
        except Exception as Ex: f"Ocurrio un ERROR: {Ex}"
        #--
    #--
    #Metodo que valida el inicio de sesion con usuario y contrasena
    #--
    def iniciar_Sesion(self, usuario, contrasena):
        #--
        try:
            #--
            sql = "SELECT contrasena "\
                    "FROM usuarios "\
                   "WHERE nombre = '" + str(usuario) + "'"
            self.__cursor.execute(sql)
            validar_contrasena = self.__cursor.fetchone()
            #--
            if validar_contrasena is not None:
                #--
                if bcrypt.verify(contrasena, validar_contrasena[0].encode()): 
                    return "Acceso exitoso"
                #--
            #--
            return "Usuario y/o contraseña invalidos"
            #--
        except Exception as Ex: return f"Ocurrio un ERROR: {Ex}"
    #--
    #Metodo que permite realizar el registro de un empleado que entro a las instalaciones
    #--
    def empleado_Ingresa(self, cedula, usuario):
        #--
        try:
            #--
            if self.validar_Existencia(cedula) is not None:
                #--
                #Si el empleado no esta en las instalaciones, insertelo
                #--
                if not self.validar_Asistencia(cedula):
                    #--
                    sql = "INSERT INTO Asistencia_Empleados ("\
                              "Cedula"\
                             ",Salida"\
                             ",Usua_Cre"\
                          ") VALUES ("\
                             + str(cedula)\
                           + ",NULL"\
                           + ",'" + usuario + "')"
                    #--
                    self.__cursor.execute(sql)
                    self.__conextion.commit()
                    return "Empleado registrado correctamente"
                    #--
                else: return f"El empleado con numero de cedula '{cedula}' ya ingreso a las instalaciones"
                #--
            else: return f"El empleado con numero de cedula '{cedula}' no existe"
            #--
        except Exception as Ex: f"Ocurrio un ERROR: {Ex}"
        #--
    #--
    #Metodo que permite realizar el registro de un empleado que sale de las instalaciones
    #--
    def empleado_Sale(self, cedula, usuario):
        #--
        try:
            #--
            if self.validar_Existencia(cedula) is not None:
                #--
                if self.validar_Asistencia(cedula):
                    #--
                    horas_Extra = self.Validar_Horas_Extra(cedula)
                    sql = "UPDATE Asistencia_Empleados "\
                             "SET horas_ex = " + str(horas_Extra) +\
                                ",Salida = CURRENT_TIMESTAMP"\
                                ",usua_mod = '" + usuario + "'"\
                          " WHERE Cedula = "+ str(cedula) +\
                            " AND Salida IS NULL"
                    #--
                    self.__cursor.execute(sql)
                    self.__conextion.commit()
                    #--
                    return "Empleado registrado correctamente"
                    #--
                else: return f"El empleado con numero de cedula '{cedula}' no ha ingresado"
                #--
            else: return f"El empleado con numero de cedula '{cedula}' no existe"
            #--
        except Exception as Ex: return f"Ocurrio un ERROR: {Ex}"
        #--
    #--
    #Metodo que permite generar la consulta de un reporte para exportarlo a un archivo csv
    #--
    def generar_Reporte(self, fecha_ini, fecha_fin):
        #--
        str_fecha_ini = fecha_ini.strftime("%Y-%m-%d")
        str_fecha_fin = fecha_fin.strftime("%Y-%m-%d")
        #--
        sql = "SELECT cedula, nombre_completo, cargo, area, TO_CHAR(ingreso, 'DD-MM-YYYY HH:MI AM'), TO_CHAR(salida, 'DD-MM-YYYY HH:MI AM'), horas_extra "\
                "FROM v_registro_asistencias "\
               "WHERE ingreso BETWEEN TO_DATE('" + str_fecha_ini + "', 'YYYY-MM-DD') AND TO_DATE('" + str_fecha_fin + "', 'YYYY-MM-DD')"\
                " AND salida  BETWEEN TO_DATE('" + str_fecha_ini + "', 'YYYY-MM-DD') AND TO_DATE('" + str_fecha_fin + "', 'YYYY-MM-DD')"
        self.__cursor.execute(sql)
        return self.__cursor.fetchall()
        #--
    #--
    #Metodo que valida la existencia de un empleado en la empresa por medio de su cedula
    #--
    def validar_Existencia(self, cedula):
        #--
        try:
            #--
            sql = 'SELECT 1 '\
                    'FROM Empleados '\
                   "WHERE Cedula = " + str(cedula)
            self.__cursor.execute(sql)
            exist = self.__cursor.fetchone()
            return exist
            #--
        except Exception as Ex: f"Ocurrio un ERROR: {Ex}"
        #--
    #--
    #Metodo que valida la asistencia de un empleado en la empresa por medio de su cedula
    #--
    def validar_Asistencia(self, cedula):
        #--
        try:
            #--
            sql = 'SELECT 1 '\
                    'FROM Asistencia_Empleados '\
                   'WHERE Cedula = ' + str(cedula) +\
                    ' AND Salida IS NULL'
            self.__cursor.execute(sql)
            exist = self.__cursor.fetchone()
            #--
            return True if exist is not None else False
            #--
        except Exception as Ex: f"Ocurrio un ERROR: {Ex}" 
        #--
    #--
    #Metodo que calcula el numero de horas extra del empleado
    #--
    def validar_Horas_Extra(self, cedula):
        #--
        #Esta consulta recupera el numero de horas diarias laborales de un empleado dependiendo
        #del dia en el cual se haya asistido, ya que los empleados pueden variar en sus horas
        #laborales en el transcurso de la semana
        #--
        dia_semana = datetime.now().weekday() + 1
        sql = "SELECT COALESCE(Horas_Diarias[" + str(dia_semana) + "], 0) "\
                "FROM Empleados "\
               "WHERE Cedula = " + str(cedula)
        self.__cursor.execute(sql)
        hora_laboral = self.__cursor.fetchone()[0]
        #--
        #Consulta la cual trae el calculo de las horas extra
        #--
        sql = "SELECT EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - Ingreso)) / 3600 "\
                "FROM Asistencia_Empleados "\
               "WHERE Cedula = " + str(cedula) +\
                " AND Salida IS NULL"
        self.__cursor.execute(sql)
        horas_realizadas = round(self.__cursor.fetchone()[0])
        #--
        #Si las horas realizadas son mayores a las horas laborales realizadas, retornar el numero de
        #horas extra
        return (horas_realizadas - hora_laboral) if horas_realizadas > hora_laboral else 0
        #--
    #--
    def __del__(self):
        #--
        self.__cursor.close()
        self.__conextion.close()
        #--
    #--
'''
#--
#----------------------------------------------------------------------------------------
#main()
instanciaDB = ConextionDB()
#--
try:
    #--
    USER = input("Ingrese el usuario\n")
    PSWD = input("Ingrese la contraseña\n").encode()
    #--
    if instanciaDB.iniciar_Sesion(USER, PSWD) != "Acceso exitoso":
        #--
        print("Acceso exitoso")
        opcion = ""
        #--
        while opcion != "3":
            #--
            print("Disque los botones:",
                  "1. Ingresar empleado.",
                  "2. Generar reporte.",
                  "3. Salir",
                  sep = "\n")
            opcion = input()
            #--
            if opcion == "1":
                #--
                opcion_1 = ""
                print("Disque los botones:",
                      "1. El empleado va a ingresar.",
                      "2. El empleado va a salir.",
                      sep = "\n")
                #--
    instanciaDB.__del__()
except Exception as Ex: print(f"Ocurrio un ERROR: {Ex}")
'''
#Logica para obtener el csv NO BORRAR
'''
registro = []
try:
    for fila in instanciaDB.generar_Reporte(datetime(2023, 12, 9), datetime(2023, 12, 11)):
        celdas = ''
        for celda in fila:
            celdas += str(celda) + ';'
        registro.append(celdas[:-1])

    for fila in registro:
        print(fila)
    instanciaDB.__del__()
except ValueError:      print('Formato de numero no valido')
except Exception as Ex: print(Ex)
'''