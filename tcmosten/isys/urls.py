from django.urls import path
from .views.get_server_update import *
from .views.view import *

urlpatterns = [
    path('', index, name='index'),
    path('nav', nav, name='nav'),
    path('calendar', calendar, name='calendar'),
    path('http_test', http_test_view, name='http_test'),
    path('get_sync', get_sync.as_view(), name='get_sync'),
    path('get_server_update', GetServerUpdate.as_view(), name='get_server_update'),
]