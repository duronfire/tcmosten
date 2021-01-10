from django.db import models
from ..models.tarif import Tarif
import datetime




class Method(models.Model):

    tarif = models.ForeignKey(Tarif,on_delete=models.RESTRICT)
    anzahl = models.IntegerField()

    @classmethod
    def create(cls,anzahl=1,ziffernum="1004",**kwargs):
        tarif = Tarif.objects.get(ziffernum=ziffernum)
        method=cls(anzahl=anzahl,tarif=tarif)
        method.save()
        return method