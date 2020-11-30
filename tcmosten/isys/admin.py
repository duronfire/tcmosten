from django.contrib import admin

# Register your models here.

from .models import *

admin.site.register([Dummy,Therapist,Patient,Meeting,Invoice])
