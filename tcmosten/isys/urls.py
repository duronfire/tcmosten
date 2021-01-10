from django.urls import path
from .views.get_update import *
from .views.post_update import *
from .views.view import *
from .views.createdummy import *


urlpatterns = [
    path('', index, name='index'),
    path('nav', nav, name='nav'),
    path('calendar', calendar, name='calendar'),
    path('http_test', http_test_view, name='http_test'),
    path('get_sync', get_sync.as_view(), name='get_sync'),
    path('get_update', GetUpdate.as_view(), name='get_update'),
    path('post_update', PostUpdate.as_view(), name='post_update'),
    path('createdummy', CreateDummy.as_view(), name='createdummy'),
]