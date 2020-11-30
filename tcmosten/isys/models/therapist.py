from django.db import models
import datetime

class Therapist(models.Model):

    # ol properties
    FirstName = models.CharField(max_length=30)
    LastName = models.CharField(max_length=30)
    Birthday = models.DateField(default=datetime.date(4501,1,1))
    Gender = models.CharField(max_length=30,choices=(("1","weiblich"),("2","männlich")),default='1')
    Email1Address = models.CharField(max_length=30)
    MailingAddressCity = models.CharField(max_length=30)
    MailingAddressCountry = models.CharField(max_length=30)
    MailingAddressPostalCode = models.CharField(max_length=30)
    MailingAddressStreet = models.CharField(max_length=30)
    GovernmentIDNumber = models.CharField(max_length=30)
    Account = models.CharField(max_length=30)
    MobileTelephoneNumber = models.CharField(max_length=30, default="NA")

    # user properties
    syncstate = models.CharField(max_length=30, default="created")
    lastsync = models.DateTimeField(default=datetime.datetime(4501,1,1,0,0,0))   

    # sql properties
    CreationTime = models.DateTimeField(auto_now_add = True)
    LastModificationTime = models.DateTimeField(auto_now = True) 