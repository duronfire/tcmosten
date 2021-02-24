from django.contrib import admin

# Register your models here.

from .models import *

admin.site.register([Bankkonto,Buchung,Habenkonto,Location,Mahnung,Meeting,Method,Patient,Rechnung,Sollkonto,Staff,Tarif,Uploadfilepath,Versicherung])
