from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('nav', views.nav, name='nav'),
    path('calendar', views.calendar, name='calendar'),
<<<<<<< HEAD
    path('http_test', views.http_test, name='http_test'),
=======
>>>>>>> c936bcad8848899f9239427733dbc63ac2c0d488
]