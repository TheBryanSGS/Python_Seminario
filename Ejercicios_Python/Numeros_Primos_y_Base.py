def Binario (numero, convertir):
    print ('El numero en', convertir, 'es', bin(numero)[2:],'\n')
############################################################################################
def Octal (numero, convertir):
    print ('El numero en', convertir, 'es', oct(numero)[2:],'\n')
############################################################################################
def Hexa (numero, convertir):
    print ('El numero en', convertir, 'es', hex(numero)[2:],'\n')
############################################################################################
def NumeroPrimo(numero):
    ##
    a = 2
    while a <= numero//2:
        ##
        if numero % a == 0: return 'El numero ' + str(numero) + ' no es primo\n'
        a = a + 1
        ##
    return 'El numero ' + str(numero) + ' es primo\n'
    ##
############################################################################################
opcion    = ''
convertir = {'1': 'binario', '2': 'octal', '3': 'hexadecimal'}
##
while opcion != '5':
    ##
    print('Menu de opciones',
          '1. Convertir a binario',
          '2. Convertir a octal',
          '3. Convertir a hexadecimal',
          '4. Determinar si un numero es primo',
          '5. Salir'
          ,sep = '\n')
    opcion = input().strip()
    ##
    try:
        ##
        if opcion in ['1', '2', '3']:
            ##
            print('Ingrese el numero para convertirlo a', convertir[opcion])
            numero = int(input())
            if   (opcion == '1'): Binario(numero, convertir[opcion])
            elif (opcion == '2'): Octal  (numero, convertir[opcion])
            else:                 Hexa   (numero, convertir[opcion])                
            ##
        ##
        elif opcion == '4':
            ##
            print('Ingrese un numero para determinar si este es primo')
            numero = int(input())
            print(NumeroPrimo(numero))
            ##
        elif opcion == '5':
            ##
            print('Gracias por usar la aplicación, buen día.')
            break
            ##
        else: print("Opción invalida, se mostrara el menú nuevamente.\n")
    except:print('formato de numero invalido')
    ##
##
