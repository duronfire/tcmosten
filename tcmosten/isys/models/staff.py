from django.db import models
import datetime
# Create your models here.

class Staff(models.Model):

    # ol properties
    FirstName = models.CharField(max_length=30)
    LastName = models.CharField(max_length=30)
    Birthday = models.DateField(default=datetime.date(4501,1,1))
    Gender = models.CharField(max_length=30,choices=(("0","k.A."),("1","weiblich"),("2","männlich"),("3","divers")),default='0')
    Email1Address = models.CharField(max_length=30)
    MailingAddressCity = models.CharField(max_length=30)
    MailingAddressCountry = models.CharField(max_length=30)
    MailingAddressPostalCode = models.CharField(max_length=30)
    MailingAddressStreet = models.CharField(max_length=30)
    GovernmentIDNumber = models.CharField(max_length=30,default="NA")
    Account = models.CharField(max_length=30,default="NA")
    MobileTelephoneNumber = models.CharField(max_length=30, default="NA")
    Role = models.CharField(max_length=30,choices=(("therapist","therapist"),("assistant","assistant"),("administrator","administrator"),("others","others")),default='therapist')

    # user properties
     

    # sql properties
    Creation = models.DateTimeField(auto_now_add = True)
    LastModified = models.DateTimeField(auto_now = True) 




    def __str__(self):
        return self.LastName+'_'+self.FirstName
    