from django.db import models


class Uploadfilepath(models.Model):
    path = models.CharField(max_length=1000)
    name = models.CharField(max_length=255)
    extname = models.CharField(max_length=10)