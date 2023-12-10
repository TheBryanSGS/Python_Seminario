from django.urls import path #definir rutas o urls
from .views import index, login, opciones # desde views trae la funcion index

urlpatterns =[
    path('', index),
    path('login',login),
    path('opciones',opciones)
]