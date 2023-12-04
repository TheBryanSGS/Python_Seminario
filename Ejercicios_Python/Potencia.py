def Potencia(base, exponente):
    #--
    if (base == 0) & (exponente <= 0): 
        print('ERROR: no se puede elevar 0 a un numero menor o igual que 0')
        return None
    return base ** exponente
    #--
#--
#------------------------------------------------------------------------------------------------------------------------------
#--
opcion           = ''
numeroPotenciado = None
base             = 1
exponente        = 1

while opcion != '3':
    #--
    print('Menu de opciones',
          '1. Potenciar un numero.',
          '2. Imprimir numero potenciado.',
          '3. Salir.',
          sep = '\n')
    opcion = input().strip()
    #--
    if opcion == '1':
        #--
        try:
            #--
            base             = int(input('Ingrese el para potenciar\n'))
            exponente        = int(input('Ingrese el exponente\n'))
            numeroPotenciado = Potencia(base, exponente)
            #--
        except:
            #--
            print('formato de numero invalido')
            numeroPotenciado = None
            #--
        #--
    elif opcion == '2':
        #--
        if numeroPotenciado is not None: print(f'El numero {base} potenciado al numero {exponente} ({base}^{exponente}) es {numeroPotenciado}')
        else: print('El numero no esta definido, por favor, ingrese datos en la primera opción del menú')
        #--
    elif opcion == '3':
        #--
        print('Gracias por usar la aplicación, buen día.')
        break
        #--
    else: print("Opción invalida, se mostrara el menú nuevamente.\n")
    #--
#--