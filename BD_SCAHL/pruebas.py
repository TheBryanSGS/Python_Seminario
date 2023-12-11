import psycopg2
import datetime

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
    def Empleado_Ingresa(self, cedula, usuario):
        #--
        try:
            #--
            if self.validar_Existencia(cedula) is not None:
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
    def Empleado_Sale(self, cedula, usuario):
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
                    return "Empleado registrado correctamente correctamente"
                    #--
                else: return f"El empleado con numero de cedula '{cedula}' no ha ingresado"
                #--
            else: return f"El empleado con numero de cedula '{cedula}' no existe"
            #--
        except Exception as Ex: return f"Ocurrio un ERROR: {Ex}"
        #--
    #--
    def generar_Reporte(self, ):

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
    def Validar_Horas_Extra(self, cedula):
        #--
        dia_semana = datetime.datetime.now().weekday() + 1
        sql = "SELECT COALESCE(Horas_Diarias[" + str(dia_semana) + "], 0) "\
                "FROM Empleados "\
               "WHERE Cedula = " + str(cedula)
        self.__cursor.execute(sql)
        hora_laboral = self.__cursor.fetchone()[0]
        #--
        sql = "SELECT EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - Ingreso)) / 3600 "\
                "FROM Asistencia_Empleados "\
               "WHERE Cedula = " + str(cedula) +\
                " AND Salida IS NULL"
        self.__cursor.execute(sql)
        horas_realizadas = round(self.__cursor.fetchone()[0])
        #--
        return (horas_realizadas - hora_laboral) if horas_realizadas > hora_laboral else 0
        #--
    #--
    def __del__(self):
        #--
        self.__cursor.close()
        self.__conextion.close()
        #--
    #--
#--

instanciaDB = ConextionDB()
USER = 'egforero'
try:
    cedula = int(input("Ingrese la cedula del empleado\n"))
    Ingresar = instanciaDB.Empleado_Sale(cedula, USER)
    print(Ingresar)
    instanciaDB.__del__()
except ValueError:      print('Formato de numero no valido')
except Exception as Ex: print(Ex)