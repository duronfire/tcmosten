from django.db import models
from ..models.patient import Patient


class Bankkonto(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.RESTRICT)
    kontoinhaber = models.CharField(max_length=50)
    kontonr = models.CharField(max_length=50)

    Creation = models.DateTimeField(auto_now_add = True)
    LastModified = models.DateTimeField(auto_now = True)

    @classmethod
    def create(cls,patient_id,kontoinhaber="NA",kontonr="NA",**kwargs):
        patient=Patient.objects.get(id=patient_id)
        bankkonto=cls(kontoinhaber=kontoinhaber,kontonr=kontonr,patient=patient)
        bankkonto.save()
        return bankkonto
        