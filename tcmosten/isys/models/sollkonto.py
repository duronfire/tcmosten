from django.db import models





class Sollkonto(models.Model):

    kontonr = models.CharField(max_length=10,default="NA")
    bezeichnung = models.CharField(max_length=100,default="NA")
    bereich = models.CharField(max_length=30,default="NA")
    klasse = models.CharField(max_length=30,default="NA")
    hauptgruppe = models.CharField(max_length=30,default="NA")
    gruppe = models.CharField(max_length=30,default="NA")
    mwst = models.CharField(max_length=10,choices=(("ohne","ohne"),("mit","mit")),default = "ohne")
    mwstsatz = models.DecimalField(max_digits=3, decimal_places=1,default=0.0)
    saldo = models.DecimalField(max_digits=12, decimal_places=2,default=0.0)