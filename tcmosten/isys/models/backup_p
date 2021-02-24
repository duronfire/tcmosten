from django.db import models

# Create your models here.

class Patient(models.Model):

    # fields definition
    vorname = models.CharField(max_length=30)
    nachname = models.CharField(max_length=30)

    adresse = models.CharField(max_length=100)
    postfach = models.IntegerField(null=True,blank=True)
    ort = models.CharField(max_length=100)
    plz = models.IntegerField(null=True,blank=True)
    ckanton=(('SG','St.Gallen'),('TG','Thurgau'),('AI','Appenzell Innerrhoden'),('AR','Appenzell Ausserrhoden'),('ZH','Zürich'),('BE','Bern'),('UR','Uri'),('SZ','Schwyz'),('OW','Obwalden'),('NW','Nidwalden'),('GL','Glarus'),('BL','Basel-Landschaft'),('BS','Basel-Stadt'),('SO','Solothurn'),('FR','Freiburg'),('ZG','Zug'),('SH','Schaffhausen'),('GR','Graubünden'),('AG','Aargau'),('JU','Jura'),('GE','Genf'),('NE','Neuenburg'),('VS','Wallis'),('VD','Waadt'),('TI','Tessin'))
    kanton = models.CharField(max_length=15,choices=ckanton,default='SG', null=True,blank=True)
    cland=(('CH','Schweiz'),('AT','Österreich'),('DE','Deutschland'))
    land = models.CharField(max_length=10,choices=cland,default='CH', null=True,blank=True)

    cgeschlecht=(('m','männlich'),('f','weiblich'))
    geschlecht = models.CharField(max_length=5,choices=cgeschlecht)
    ctitle = (('dr','Dr. '),('prof','Prof. '))
    title = models.CharField(max_length=5,choices=ctitle,null=True,blank=True)

    geburtsdatum = models.DateField(null=True,blank=True)
    age = models.IntegerField(null=True,blank=True)

    verwandte = models.CharField(max_length=100,null=True,blank=True)
    arztueberweisung = models.CharField(max_length=100,null=True,blank=True)
    ctherapeut = (('cj','Chu Jianping'),('pj','Pan Jianqian'))
    therapeut = models.CharField(max_length=30,choices=ctherapeut,default='cj')
    cpraxis=(('sg','St.Gallen'))
    therapeut = models.CharField(max_length=20,choices=cpraxis,default='sg')

    email1 = models.CharField(max_length=100,null=True,blank=True)
    telefon = models.CharField(max_length=100,null=True,blank=True)

    erstellt = models.DateTimeField()
    modifiziert = models.DateTimeField()



    freifeld1 = models.CharField(max_length=100,null=True,blank=True)
    freifeld2 = models.CharField(max_length=100,null=True,blank=True)
    freifeld3 = models.CharField(max_length=100,null=True,blank=True)

    # model functions
    def __str__(self):
        return self.nachname+'_'+self.vorname
