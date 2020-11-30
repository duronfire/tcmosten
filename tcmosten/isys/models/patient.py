from django.db import models
import datetime
# Create your models here.

class Patient(models.Model):

    # fields definition
    vorname = models.CharField(max_length=30)
    nachname = models.CharField(max_length=30)
    birthday = models.DateField(default=datetime.date.today())


    # model functions
    def __str__(self):
        return self.nachname+'_'+self.vorname
