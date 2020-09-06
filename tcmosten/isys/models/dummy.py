from django.db import models

# Create your models here.

class Dummy(models.Model):
    vorname = models.CharField(max_length=30,default="defaultname")
#    nachname = models.CharField(max_length=30)
    ckanton=(('SG','St.Gallen'),('TG','Thurgau'),('AI','Appenzell Innerrhoden'),('AR','Appenzell Ausserrhoden'),('ZH','Zürich'),('BE','Bern'),('UR','Uri'),('SZ','Schwyz'),('OW','Obwalden'),('NW','Nidwalden'),('GL','Glarus'),('BL','Basel-Landschaft'),('BS','Basel-Stadt'),('SO','Solothurn'),('FR','Freiburg'),('ZG','Zug'),('SH','Schaffhausen'),('GR','Graubünden'),('AG','Aargau'),('JU','Jura'),('GE','Genf'),('NE','Neuenburg'),('VS','Wallis'),('VD','Waadt'),('TI','Tessin'))
    kanton = models.CharField(max_length=15,choices=ckanton,default='SG', null=True,blank=True)   # The default value is used when new model instances are created and a value isn’t provided for the field.