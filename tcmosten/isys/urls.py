from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('nav', views.nav, name='nav'),
    path('calendar', views.calendar, name='calendar'),
    path('http_test/<state>', views.http_test_view, name='http_test'),
]