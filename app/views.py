from django.shortcuts import render


def index(request):
    return render(request, 'index.html')
def login(request):
    return render(request, 'login.html')
def opciones(request):
    return render(request, 'opciones.html')
def registro (request):
    return render(request, 'registro.html')
def reporte (request):
    return render(request, 'reporte.html')
