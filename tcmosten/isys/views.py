from django.shortcuts import render
from django.http import HttpResponse


from .models.dummy import Dummy,Dummyform


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

        

    