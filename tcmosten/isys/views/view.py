import os
from django.shortcuts import render
from django.http import HttpResponse
from django.views import View

from ..models.dummy import Dummy,Dummyform
from ..models.http_test import http_test,http_testform
from ..forms import SyncForm


class get_sync(View):

    def get(self,request):

        num_new_ap = int(request.GET["newap"]) # The first HTTP GET in order to get crsf key and cookie
        #num_new_ct = request.GET["newct"]
        #num_changed_ap = request.GET["changedap"]
        #num_changed_ct = request.GET["changed_ct"]
        form = SyncForm(form_count_list=[num_new_ap,0,0,0])
        return render(request, 'isys/get_sync.html', {'form': form})

    def post(self,request):

        num_new_ap = int(request.GET["newap"]) # this request.GET is a new instance of view by HTTP POST actually, it has no thing to do with last HTTPGET. But QueryDict will be saved as request.GET by HTTPPOST and Post Body will be saved in request.POST
        form = SyncForm(form_count_list=[num_new_ap,0,0,0],data=request.POST)

        if not form.is_valid():
            print("request not valid!")
            print(request.POST)     

            for new_ap in range(num_new_ap):
                new_ap_key = "newap" + str(new_ap)
                new_ap_values = request.POST[new_ap_key].split(";")
                new_ap_values_list = new_ap_values
            
            
            return HttpResponse("no")
        else:
            print("request is valid!")
            print(request.POST)
            return HttpResponse("yes")


# Create your views here.
def index(request):
    all=Dummy.objects.all()
    name0=[i.vorname for i in all]

    if request.method=='GET':
        form=Dummyform()
        return render(request, 'isys/index.html', {'testvar':name0, 'form': form})

    elif request.method=='POST':
        form=Dummyform(request.POST)
        return HttpResponse('yes!')



def nav(request):
    return render(request, 'isys/nav.html', {})

        
def calendar(request):
    return render(request, 'isys/calendar.html', {})
    

def http_test_view(request):

    if request.method=='GET':
        form=http_testform()
        print(request.GET["name"])
        return render(request, 'isys/http_test.html', {'form': form})

    elif request.method=='POST':
        print(request.POST)
        form=http_testform(request.POST)
        if not form.is_valid():
            return HttpResponse("Fatal Error:form is not valid, wenden Sie sich umgehend an Wentao Zhu!")
        else:
            name = request.POST["name"].split(".")
            anrede = name[0]
            if not anrede.upper() in ["HR","FR"]:
                return HttpResponse("Bitte geben Sie die Anrede (Fr. / Hr.) in Eingabefeld ein!")
            nachname = name[1].strip().split(" ")[0]
            vorname = name[1].strip().split(" ")[1]
            print(name, anrede, nachname, vorname)


            if  "select" not in state:
                # response code: 0 match, 1 non-match -> add patient or retry, 2 input incomplete -> choose, 3 duplicate name -> choose by birthday 
                
                matched_name = Dummy.objects.filter(nachname__iregex=nachname).filter(vorname__iregex=vorname).order_by("-id")

                for i in range(2): 
                    if len(matched_name) == 1: # matched sucessfully 
                        obj=matched_name[0]
                        return HttpResponse("0" + "&" + matched_name[0].nachname + "&"  + matched_name[0].vorname)
                    elif len(matched_name) < 1:
                        if i == 0:
                            return HttpResponse("1")
                        else:
                            anredes=[]
                            nachnames=[]
                            vornames=[]
                            geburtstags=[]
                            for j in matched_name_all:
                                anredes.append(j.anrede)
                                nachnames.append(j.nachname)
                                vornames.append(j.vorname)
                                geburtstags.append(j.geburtstag)
                            return HttpResponse("2" + "&" + str(anredes) + "&" + str(nachnames) + "&" + str(vornames) + "&" + str(geburtstags))
                    elif len(matched_name) > 1:
                        if i == 0:
                            matched_name_all=matched_name
                            print("ordered: " , matched_name_all.ordered)
                            matched_name = Dummy.objects.filter(nachname__iregex="^"+nachname+"$").filter(vorname__iregex="^"+vorname+"$")
                        else:
                            return HttpResponse("3")
            
            else:
                sel_index = int(request.POST["state"].replace("select",""))
                obj=matched_name_all[sel_index]
            
            

            if request.POST["state"] == "add":
                form.save()
                return HttpResponse(request.POST["state"])