from django.db import models
import datetime
from .patient import Patient
from .therapist import Therapist
from .invoice import Invoice


class Meeting(models.Model):

    # fields definition
    patient = models.ForeignKey(Patient, on_delete=models.RESTRICT) #test foreignkey
    tp = models.ForeignKey(Therapist, on_delete=models.RESTRICT) #test foreignkey
    invoice = models.ForeignKey(Invoice, on_delete=models.RESTRICT) #test foreignkey
    start = models.DateTimeField(default = datetime.datetime.now())
    lastbill = models.DateTimeField(default = datetime.datetime.now()) #get the value from invoice
