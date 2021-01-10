from django.db import models
import datetime
from ..models.patient import Patient
from ..models.staff import Staff
from ..models.location import Location
from ..models.method import Method
from ..models.tarif import Tarif
from ..models.uploadfilepath import Uploadfilepath


class Meeting(models.Model):

    # fields definition
    # ol props
    EntryID = models.CharField(max_length=50)
    Start = models.DateTimeField() 
    End = models.DateTimeField() 


    CreationTime = models.DateTimeField() 
    LastModificationTime = models.DateTimeField() 

    # sql/ol uprops
    billstate = models.CharField(max_length=10,choices=(("nobill","nobill"),("billed","billed"),("paid","paid"))) 
    lastbill = models.DateTimeField() 
    # ol uprops
    lastsync = models.DateTimeField()  
    apcategory = models.CharField(max_length=20,choices=(('behandelt', 'behandelt'), ('abwesend', 'abwesend'), ('abgesagt', 'abgesagt'), ('unbehandelt', 'unbehandelt'), ("krank","krank")))
    aplabel = models.CharField(max_length=20,choices=(("kickoffnew","kickoffnew"),("kickoffold","kickoffold"),("followup","followup")))
    archivelabel = models.CharField(max_length=20,choices=(("live","live"),("archived","archived"),("error","error")))


    # sql only fields
    meetingnr = models.CharField(max_length=50,default="init") 


    uploadfiles = models.ManyToManyField(Uploadfilepath,blank=True)
    staff = models.ForeignKey(Staff, on_delete=models.RESTRICT) #test foreignkey
    patient = models.ForeignKey(Patient, on_delete=models.RESTRICT) #test foreignkey  

    methods = models.ManyToManyField(Method,blank=True)
    betrag = models.DecimalField(max_digits=10,decimal_places=2)


    treatmenttype = models.CharField(max_length=30,choices=(("Einzeltherapie","Einzeltherapie"),("Gruppentherapie","Gruppentherapie")))
    treatmentreason = models.CharField(max_length=30,choices=(("Krankheit","Krankheit"),("Beschwerde","Beschwerde"),("Geburtsvorbereitung","Geburtsvorbereitung"),("Suchtentwöhnung","Suchtentwöhnung"),("Schwangerschaft","Schwangerschaft"),("Prävention","Prävention"),("Unfall","Unfall"),("Mutterschaft","Mutterschaft"),("Geburtsgebrechen","Geburtsgebrechen")))
    diagose = models.CharField(max_length=30)
    role = models.CharField(max_length=50)
    comment = models.CharField(max_length=500)
    notice = models.CharField(max_length=10000)

    LastModified = models.DateTimeField(auto_now = True)
    synclabel = models.CharField(max_length=10,choices=(("toupdate","toupdate"),("sync","sync")), default = "sync")
    @classmethod
    def create(cls,EntryID="NA",Start=datetime.datetime(4501,1,1,0,0,0),End=datetime.datetime(4501,1,1,0,0,0),CreationTime=datetime.datetime(4501,1,1,0,0,0),LastModificationTime=datetime.datetime(4501,1,1,0,0,0),billstate="nobill",
                lastbill=datetime.datetime(4501,1,1,0,0,0),lastsync=datetime.datetime(4501,1,1,0,0,0),apcategory="behandelt",aplabel="kickoffnew",archivelabel="live",
                staffpid=1,pentryid="DummyEntryID",betrag=0.0,treatmenttype="Einzeltherapie",treatmentreason="Krankheit",diagose="NA",role="Komplementärmedizin",comment="NA",notice="NA",location_id=1,**kwargs):


        staff=Staff.objects.get(id=staffpid)
        patient=Patient.objects.filter(EntryID__exact=pentryid,location__id__exact=location_id).get()

        meeting = cls(EntryID=EntryID,Start=Start,End=End,CreationTime=CreationTime,LastModificationTime=LastModificationTime,billstate=billstate,lastbill=lastbill,lastsync=lastsync,apcategory=apcategory,aplabel=aplabel,archivelabel=archivelabel,
                staff=staff,patient=patient,betrag=betrag,treatmenttype=treatmenttype,treatmentreason=treatmentreason,diagose=diagose,role=role,comment=comment,notice=notice)
        
        meeting.save(init=True)
        meeting.meetingnr = str(datetime.datetime.today().year) + "-" + str(meeting.id).zfill(6)
        meeting.save()
        return meeting    

    def save(self, init=False, *args, **kwargs):
        if not init:
            print("lastbill",self.lastbill)
            print("LastModified",self.LastModified)
            print("lastsync",self.lastsync)
            if self.lastbill != datetime.datetime(4501,1,1,0,0,0):
                if self.lastsync == datetime.datetime(4501,1,1,0,0,0):
                    self.synclabel = "toupdate"

                elif (self.lastbill-self.lastsync).total_seconds > 5: 
                    self.synclabel = "toupdate"
        super().save(*args, **kwargs)

    def sync(self,**kwargs):
        fields = "Start,End,LastModificationTime,lastsync,apcategory,aplabel,archivelabel"
        fields = fields.split(",")
        for field in fields:
            field = field.strip()
            self.__setattr__(field,kwargs[field])
            
        self.save()

    def set_method(self,methods_dict={"1004":1},**kwargs):
        for ziffernum,num in methods_dict.items():
            method=Method.objects.filter(tarif__ziffernum__exact=ziffernum).filter(anzahl__exact=num)
            if len(method)==1:
                method = method.get()
            elif len(method) == 0:
                method = Method.create(anzahl=num,ziffernum=ziffernum)
                method.save()
            elif len(method)>1:
                method = method[0].get()
            ansatz=Tarif.objects.get(ziffernum__exact=ziffernum).ansatz
            betrag=betrag+float(num)*float(ansatz)
            meeting.methods.add(method)

        meeting.betrag=betrag
        meeting.save()

    def update_betrag(self):
        pass