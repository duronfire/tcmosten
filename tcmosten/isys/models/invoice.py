from django.db import models
import datetime
from .patient import Patient
from .therapist import Therapist

class Invoice(models.Model):

    # fields definition
    patient = models.ForeignKey(Patient, on_delete=models.RESTRICT) #test foreignkey
    billstate = models.CharField(max_length=30)
    lastbill = models.DateTimeField(default = datetime.datetime.now()) 
    