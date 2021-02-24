from django.urls import path
from .views.get_update import *
from .views.post_update import *
from .views import view
from .views.createdummy import *


urlpatterns = [
    path('', view.index, name='index'),
    path('nav', view.nav, name='nav'),
    path('rechnung', view.rechnung),
    path('calendar', view.calendar, name='calendar'),
    path('http_test', view.http_test_view, name='http_test'),
    path('get_update', GetUpdate.as_view(), name='get_update'),
    path('post_update', PostUpdate.as_view(), name='post_update'),
    path('createdummy', CreateDummy.as_view(), name='createdummy'),
]