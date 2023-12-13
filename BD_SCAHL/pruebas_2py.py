from pruebas import ConextionDB

conexion = ConextionDB()
v_cedula_form = int(input('Ingrese\n'))
print(conexion.validar_Existencia(v_cedula_form))
conexion.__del__()