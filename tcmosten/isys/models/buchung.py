from django.db import models
from ..models.habenkonto import Habenkonto
from ..models.sollkonto import Sollkonto
import datetime




class Buchung(models.Model):
    belegnr = models.CharField(max_length=30,default="NA")
    belegdatum = models.DateField(default=datetime.date(4501,1,1))
    buchungstext = models.CharField(max_length=200)

    habenkonto = models.ForeignKey(Habenkonto,on_delete=models.RESTRICT)
    sollkonto = models.ForeignKey(Sollkonto,on_delete=models.RESTRICT)

    betrag = models.DecimalField(max_digits=12, decimal_places=2,default=0.0)

    mwst = models.CharField(max_length=10,choices=(("ohne","ohne"),("mit","mit")),default = "ohne")
    mwstsatz = models.DecimalField(max_digits=3, decimal_places=1,default=0.0)

    Creation = models.DateTimeField(auto_now_add = True)
    LastModified = models.DateTimeField(auto_now = True)

    @classmethod
    def create(cls,buchungstext="NA", habenkonto_nr="3400",sollkonto_nr="1010",**kwargs):
        habenkonto=Habenkonto.objects.get(kontonr=habenkonto_nr)
        sollkonto=Sollkonto.objects.get(kontonr=sollkonto_nr)

        buchung=cls(habenkonto=habenkonto,sollkonto=sollkonto)
        buchung.save()
        buchung.belegnr = str(datetime.datetime.today().year) + "-" + str(buchung.id).zfill(6)
        return buchung