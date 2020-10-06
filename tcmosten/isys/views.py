import os
from django.shortcuts import render
from django.http import HttpResponse


from .models.dummy import Dummy,Dummyform
from .models.http_test import http_test,http_testform


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
    

def http_test(request):
    print("here is http test!")
    print(request.GET)
    print(os.getcwd())



    if request.method=='GET':
        form=http_testform()
        return render(request, 'isys/http_test.html', {'form': form})

    elif request.method=='POST':
        form=http_testform(request.POST)
        print(form.is_valid())
        print(request.POST)
        return HttpResponse('yes!')
