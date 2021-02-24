from django.db import models



class Versicherung(models.Model):
    name = models.CharField(max_length=50)
    
