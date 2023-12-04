def CovertirNumero(numero, base):
    #--
    conversiones = ['0', '1', '2', '3', '4', '5', '6', '7',
                    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
    convertido = ''
    while numero != 0:
        #--
        convertido = conversiones[numero % base] + convertido
        numero = numero//base
        #--
    return convertido
    #--
#--
#------------------------------------------------------------------------------------------------------------------------------
#--
opcion = ''
while opcion != '2':
    #--
    print('Menu de opciones',
          '1. Convertir numero decimal a base',
          '2. Salir',
          sep = '\n')
    opcion = input().strip()
    #--
    if opcion == '1':
        #--
        try:
            #--
            print('A continuación debera ingresar el numero en formato decimal',
                 'a convertir y la base entre 2 y 16\n',
                 'Ingrese el numero a convertir:',
                 sep = '\n')
            numero = int(input())
            base   = 1
            #--
            while (base < 2) | (base > 16):
                #--
                base = int(input('Ingrese la base:\n'))
                if (base < 2) | (base > 16): print('Ingresa una base entre 2 y 16')
                #--
            #--
            print('El numero', numero, 'en base', base, 'es', CovertirNumero(numero, base))
        except: print('formato de numero invalido')
        #--
    elif opcion == '2':
        #--
        print('Gracias por usar la aplicación, buen día.')
        break
        #--
    else: print("Opción invalida, se mostrara el menú nuevamente.\n")
    #--
#--