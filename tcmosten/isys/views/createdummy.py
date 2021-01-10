import os,ast,datetime
from django.shortcuts import render
from django.http import HttpResponse, HttpResponseNotFound
from django.views import View
from ..models import *
from ..forms import SyncPostForm

class CreateDummy(View):

    def get(self,request):
        print(request.GET)

        #try:
            
        dummy_fp = Uploadfilepath.objects.all().order_by("-id")
        dummy_vs = Versicherung.objects.all().order_by("-id")
        dummy_loc = Location.objects.all().order_by("-id")
        dummy_tp = Staff.objects.filter(Role__exact="therapist", FirstName__exact="DummyTherapist").order_by("-id") # return a list, whereby "-"" for decending order
        dummy_ad = Staff.objects.filter(Role__exact="administrator", FirstName__exact="DummyAdmin").order_by("-id") # return a list, whereby "-"" for decending order
        
        dummy_hk = Habenkonto.objects.all().order_by("-id") 
        dummy_sk = Sollkonto.objects.all().order_by("-id") 
        dummy_bk = Bankkonto.objects.all().order_by("-id") 
        dummy_bh = Buchung.objects.all().order_by("-id") 
        dummy_tf = Tarif.objects.all().order_by("-id") 
        dummy_md = Method.objects.all().order_by("-id")   
        dummy_pt = Patient.objects.all().order_by("-id")  
        dummy_mt = Meeting.objects.all().order_by("-id") 
        dummy_rn = Rechnung.objects.all().order_by("-id") 

        if not bool(dummy_fp): # query result must not be empty!!!!
            dummy_fp = Uploadfilepath(path = "c:\Dummy.Dummy", name = "DummyfileName", extname = ".Dummy")
            dummy_fp.save()
            print("dummy_fp")
        if not bool(dummy_vs): # query result must not be empty!!!!
            dummy_vs = Versicherung(name = "DummyVersicherung")
            dummy_vs.save()
            print("dummy_vs")
        if not bool(dummy_loc): # query result must not be empty!!!!
            dummy_loc = Location(city="DummyCity",country="DummyCountry",postalcode="DummyPostalcode",street="DummyStreet",email="DummyEmail",telephone="DummyTelephone",mobile="DummyMobile")
            dummy_loc.save()
            print("dummy_loc")
        if not bool(dummy_tp): # query result must not be empty!!!!
            dummy_tp = Staff(FirstName="DummyTherapist",LastName="DummyTherapist",Email1Address="DummyEmail",MailingAddressCity="DummyCity",MailingAddressCountry="DummyCountry",MailingAddressPostalCode="DummyPostalcode",MailingAddressStreet="DummyStreet",GovernmentIDNumber="DummyGID",Account="DummyAccount",MobileTelephoneNumber="DummyMobile")
            dummy_tp.save()
            print("dummy_tp")
        if not bool(dummy_ad): # query result must not be empty!!!!
            dummy_ad = Staff(FirstName="DummyAdmin",LastName="DummyAdmin",Email1Address="DummyEmail",MailingAddressCity="DummyCity",MailingAddressCountry="DummyCountry",MailingAddressPostalCode="DummyPostalcode",MailingAddressStreet="DummyStreet",GovernmentIDNumber="DummyGID",Account="DummyAccount",MobileTelephoneNumber="DummyMobile",Role="administrator")
            dummy_ad.save()
            print("dummy_ad")
        if not bool(dummy_hk): # query result must not be empty!!!!
            dummy_hk = Habenkonto(kontonr="3400",bezeichnung = "Bruttoertrag Dienstleistungen A")
            dummy_hk.save()
            print("dummy_hk")
        if not bool(dummy_sk): # query result must not be empty!!!!
            dummy_sk = Sollkonto(kontonr="1010",bezeichnung = "Postcheck")
            dummy_sk.save()
            print("dummy_sk")
        if not bool(dummy_bh): # query result must not be empty!!!!
            dummy_bh = Buchung.create(buchungstext = "DummyText")
            print("dummy_bh")
        if not bool(dummy_tf): # query result must not be empty!!!!
            dummy_tf = Tarif.create()
            print("dummy_tf")
        if not bool(dummy_md): # query result must not be empty!!!!
            dummy_md = Method.create()
            print("dummy_md")
        if not bool(dummy_pt): # query result must not be empty!!!!
            dummy_pt = Patient.create(EntryID="DummyEntryID",FirstName="DummyFirstName",LastName="DummyLastName",Birthday=datetime.date(1900,1,1),Gender="0",Email1Address="dummy@dummy.dummy",Account="00000000",
                        CreationTime=datetime.datetime(2020,12,28,0,0,0),LastModificationTime=datetime.datetime(2020,12,28,1,0,0),patientstate="NA",lastsync=datetime.datetime(4501,1,1,0,0,0),location_id=1)
            print("dummy_pt")
        if not bool(dummy_bk): # query result must not be empty!!!!
            dummy_bk = Bankkonto.create(patient_id = 1,kontonr="00000000")
            print("dummy_bk")
        if not bool(dummy_mt): # query result must not be empty!!!!
            dummy_mt = Meeting.create(EntryID="DummyEntryID",Start=datetime.datetime(2020,12,28,8,0,0),End=datetime.datetime(2020,12,28,9,0,0),CreationTime=datetime.datetime(2020,12,28,7,0,0),LastModificationTime=datetime.datetime(2020,12,28,7,1,0),
                        staffpid=1,pentryid="DummyEntryID")

            print("dummy_mt")
        if not bool(dummy_rn): # query result must not be empty!!!!
            dummy_rn = Rechnung.create(meeting_ids=[1])

            print("dummy_rn")
        return HttpResponse("yes")
        #except:
            #return HttpResponseNotFound("Error by Dummy Creation!")
