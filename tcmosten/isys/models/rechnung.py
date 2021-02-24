from django.db import models
import datetime
from ..models.patient import Patient
from ..models.meeting import Meeting
from ..models.bankkonto import Bankkonto
from ..models.versicherung import Versicherung
from ..models.mahnung import Mahnung




class Rechnung(models.Model):

    # fields definition



    rechnungsnr = models.CharField(max_length=50,default = "init") 
    zahlungsart = models.CharField(max_length=15,choices=(("Rechnung","Rechnung"),("Bar","Bar")))
    art = models.CharField(max_length=10,choices=(("VVG","VVG"),("UVG","UVG"),("IV","IV"),("SZ","SZ")))  # bill or bar
    rechnungsstand = models.CharField(max_length=50,choices=(("Rechnung","Rechnung"),("Quittung","Quittung"),("Zahlungserinnerung","Zahlungserinnerung"),("1.Mahnung","1.Mahnung"),("2.Mahnung","2.Mahnung"),("3.Mahnung","3.Mahnung"),("Inkasso","Inkasso"))) 
    betrag = models.DecimalField(max_digits=10,decimal_places=2,default=0.0)
    totalbetrag = models.DecimalField(max_digits=10,decimal_places=2,default=0.0)
    meetings = models.ManyToManyField(Meeting,blank=True)
    mahnungen = models.ManyToManyField(Mahnung,blank=True)




    versicherung = models.ForeignKey(Versicherung,on_delete=models.RESTRICT)
    versicherungsnr = models.CharField(max_length=50)
    


    eingangsdatum = models.DateField()
    
    Creation = models.DateTimeField(auto_now_add = True)
    LastModified = models.DateTimeField(auto_now = True)

    @classmethod
    def create(cls,meeting_ids,zahlungsart="Rechnung",art="VVG",rechnungsstand="Rechnung",versicherungsnr="NA",eingangsdatum=datetime.date(4501,1,1),versicherung_id=1,**kwargs):
        if not bool(meeting_ids):
            return None
        else:
            versicherung=Versicherung.objects.get(id=versicherung_id)
            rechnung = cls(zahlungsart=zahlungsart,art=art,rechnungsstand=rechnungsstand,versicherung=versicherung,versicherungsnr=versicherungsnr,eingangsdatum=eingangsdatum)
            if rechnung.zahlungsart == "Bar":
                rechnung.art="SZ"
                rechnung.rechnungsstand="Quittung"
            rechnung.save(init=True)
            rechnung.rechnungsnr = str(datetime.datetime.today().year) + "-" + str(rechnung.id).zfill(6)
            rechnung.save()

            betrag=0.0
            for id in meeting_ids:
                meeting=Meeting.objects.get(id=id)
                meeting.billstate="billed"
                meeting.lastbill=datetime.datetime.now()
                meeting.save()
                betrag=betrag+float(meeting.betrag)
                rechnung.meetings.add(meeting)
            rechnung.betrag = betrag
            rechnung.totalbetrag=betrag
            rechnung.save()


            return rechnung    

    def save(self, init=False, *args, **kwargs):
        if not init:
            len_mahnungen=len(self.mahnungen.all())
            print("mahnungen: ",len_mahnungen)
            mahnbetrag=0.0
            if len_mahnungen > 0:
                for mahnung in self.mahnungen.all():
                    mahnbetrag=mahnung.mahngebuehren+mahnbetrag
                self.totalbetrag = mahnbetrag+self.betrag
            
            if self.eingangsdatum.year != 4501:
                for meeting in self.meetings.all():
                    meeting.billstate = "paid"
        super().save(*args, **kwargs)

    def set_mahnung(self):
        pass

    def set_meeting(self):
        pass

    def update_betrag(self):
        pass