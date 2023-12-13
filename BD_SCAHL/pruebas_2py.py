from pruebas import ConextionDB

instanciaDB = ConextionDB()
#--
try:
    #--
    USER = input("Ingrese el usuario\n")
    PSWD = input("Ingrese la contraseña\n").encode()
    acceso = instanciaDB.iniciar_Sesion(USER, PSWD)
    #--
    if acceso == "Acceso exitoso":
        #--
        print(acceso)
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
                print("Disque los botones:",
                      "1. El empleado va a ingresar.",
                      "2. El empleado va a salir.",
                      "3. Cancelar",
                      sep = "\n")
                opcion_1 = input()
                #--
                while opcion_1 not in ["1", "2", "3"]:
                    #--
                    opcion_1 = input("Ingrese segun el menu\n")
                    #--
                else:
                    #--
                    try:
                        #--
                        if opcion_1 == "1":
                            #--
                            cedula = int(input("Ingrese la cedula del empleado\n"))
                            print(instanciaDB.empleado_Ingresa(cedula, USER))
                            #--
                        elif opcion_1 == "2":
                            #--
                            cedula = int(input("Ingrese la cedula del empleado\n"))
                            print(instanciaDB.empleado_Sale(cedula, USER))
                            #--
                        else: print("Acaba de cancelar la operación")
                        #--
                    except ValueError: print("Formato de numero invalido")
                    #--
                #--
            elif opcion == "2":
                #--
                permisos = instanciaDB.validar_Permisos(USER)
                #--
                if permisos is not None and type(permisos) is tuple:
                    #--
                    while True:
                        #--
                        fecha_ini = input("Ingrese la fecha de inicio en formato YYYY-MM-DD")
                        fecha_fin = input("Ingrese la fecha de fin en formato YYYY-MM-DD")
                        #Verificar fechas
                        registro = instanciaDB.generar_Reporte(fecha_ini, fecha_fin)
                        #generar archivo csv
                        for linea in registro: print(linea)
                        break
                        #--
                elif permisos is None: print("Usted no tiene permisos para generar reportes")
                else: print(f"ERROR en validar_Permisos:\n{permisos}")
                #--
            elif opcion == "3":
                #--
                print("Gracias por usar la aplicación, buen dia")
                USER = None
                PSWD = None
                #--
            else: print("Escoja una opcion de la lista del menu por favor")
            #--
        #--
    else: print(acceso)
    #--
except Exception as Ex: print(f"Ocurrio un ERROR: {Ex}")
#--
instanciaDB.__del__()