from django.db import models
import datetime
from ..models.location import Location
from ..models.staff import Staff
# Create your models here.

class Patient(models.Model):

    # fields definition
    EntryID = models.CharField(max_length=50)
    FirstName = models.CharField(max_length=30)
    LastName = models.CharField(max_length=30)
    Birthday = models.DateField()
    Gender = models.CharField(max_length=30,choices=(("0","k.A."),("1","weiblich"),("2","männlich"),("3","divers")))
    CompanyName = models.CharField(max_length=30)
    Title = models.CharField(max_length=30,blank=True)
    JobTitle = models.CharField(max_length=30)
    ReferredBy = models.CharField(max_length=30)
    Email1Address = models.CharField(max_length=50)
    MailingAddressCity = models.CharField(max_length=30)
    MailingAddressCountry = models.CharField(max_length=30)
    MailingAddressPostalCode = models.CharField(max_length=30)
    MailingAddressStreet = models.CharField(max_length=50)
    GovernmentIDNumber = models.CharField(max_length=30)
    Account = models.CharField(max_length=50)
    MobileTelephoneNumber = models.CharField(max_length=30)
    HomeTelephoneNumber = models.CharField(max_length=30)
    BusinessTelephoneNumber = models.CharField(max_length=30)
    CreationTime = models.DateTimeField() 
    LastModificationTime = models.DateTimeField() 
    
    # user properties
    patientstate = models.CharField(max_length=30,choices=(("created","created"),("new","new"),("old","old"),("oldnew","oldnew")))
    lastsync = models.DateTimeField()  

    # sql properties
    LastModified = models.DateTimeField(auto_now = True)
    location = models.ForeignKey(Location, on_delete=models.RESTRICT)     
    # model functions

    @classmethod
    def create(cls,EntryID="NA",FirstName="NA",LastName="NA",Birthday=datetime.date(4501,1,1),Gender="0",CompanyName="NA",Title="",JobTitle="NA",ReferredBy="NA",Email1Address="NA",
                MailingAddressCity="NA",MailingAddressCountry="NA",MailingAddressPostalCode="NA",MailingAddressStreet="NA",GovernmentIDNumber="NA",Account="NA",MobileTelephoneNumber="NA",HomeTelephoneNumber="NA",
                BusinessTelephoneNumber="NA",CreationTime=datetime.datetime(4501,1,1,0,0,0),LastModificationTime=datetime.datetime(4501,1,1,0,0,0),patientstate="created",lastsync=datetime.datetime(4501,1,1,0,0,0),location_id=1,**kwargs):
        
        
        location = Location.objects.get(id=location_id)

        patient=cls(EntryID=EntryID,FirstName=FirstName,LastName=LastName,Birthday=Birthday,Gender=Gender,CompanyName=CompanyName,Title=Title,JobTitle=JobTitle,ReferredBy=ReferredBy,Email1Address=Email1Address,
    MailingAddressCity=MailingAddressCity,MailingAddressCountry=MailingAddressCountry,MailingAddressPostalCode=MailingAddressPostalCode,MailingAddressStreet=MailingAddressStreet,GovernmentIDNumber=GovernmentIDNumber,Account=Account,MobileTelephoneNumber=MobileTelephoneNumber,HomeTelephoneNumber=HomeTelephoneNumber,
    BusinessTelephoneNumber=BusinessTelephoneNumber,CreationTime=CreationTime,LastModificationTime=LastModificationTime,patientstate=patientstate,lastsync=lastsync,location=location)
        
        patient.save()
        return patient


    def sync(self,**kwargs):
        fields = "FirstName,LastName,Birthday,Gender,CompanyName,Title,JobTitle,ReferredBy,Email1Address,MailingAddressCity,MailingAddressCountry,MailingAddressPostalCode,"\
            "MailingAddressStreet,GovernmentIDNumber,Account,MobileTelephoneNumber,HomeTelephoneNumber,BusinessTelephoneNumber,LastModificationTime,patientstate,lastsync"
        fields = fields.split(",")
        for field in fields:
            field = field.strip()
            self.__setattr__(field,kwargs[field])

        self.save()


    def __str__(self):
        return self.LastName+'_'+self.FirstName
    