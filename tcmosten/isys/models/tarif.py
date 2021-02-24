from django.db import models
from ..models.habenkonto import Habenkonto





class Tarif(models.Model):

    tarifnum = models.CharField(max_length=20)
    ziffernum = models.CharField(max_length=20)
    kategorie = models.CharField(max_length=20)
    bezeichnung = models.CharField(max_length=250)
    einheit = models.CharField(max_length=25,choices=(("Stk.","Stk."),("Min.","Min.")))
    menge = models.DecimalField(max_digits=6,decimal_places=2)
    ansatz = models.DecimalField(max_digits=6,decimal_places=2)
    mwst = models.DecimalField(max_digits=3,decimal_places=1)
    habenkonto = models.ForeignKey(Habenkonto,on_delete=models.RESTRICT)
    @classmethod
    def create(cls,tarifnum="590",ziffernum="1004",kategorie="Methode",bezeichnung="Akupunktur, pro 5 Minuten",einheit='Stk.',menge=1.0,ansatz=10.0,mwst=0.0,habenkonto_nr="3400",**kwargs):
        habenkonto=Habenkonto.objects.get(kontonr=habenkonto_nr)
        tarif = cls(tarifnum=tarifnum,ziffernum=ziffernum,kategorie=kategorie,bezeichnung=bezeichnung,einheit=einheit,menge=menge,ansatz=ansatz,mwst=mwst,habenkonto=habenkonto)
        tarif.save()
        return tarif    
