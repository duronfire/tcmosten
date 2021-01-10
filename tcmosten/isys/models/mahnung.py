from django.db import models
import datetime




class Mahnung(models.Model):


    mahndatum = models.DateField(default=datetime.date(4501,1,1))
    mahnungstyp = models.CharField(max_length=30,choices=(("Zahlungserinnerung","Zahlungserinnerung"),("1.Mahnung","1.Mahnung"),("2.Mahnung","2.Mahnung"),("3.Mahnung","3.Mahnung"),("Inkasso","Inkasso")),default = "Zahlungserinnerung")
    mahngebuehren = models.DecimalField(max_digits=8,decimal_places=2,default=0.0)
    Creation = models.DateTimeField(auto_now_add = True)
    LastModified = models.DateTimeField(auto_now = True)

