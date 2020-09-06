from django.shortcuts import render
from django.http import HttpResponse


from .models.dummy import Dummy

from django.template import loader
# Create your views here.
def index(request):
    all=Dummy.objects.all()
    name0=[i.vorname for i in all]
    template = loader.get_template('isys/index.html')
    context={'testvar':name0}
    return HttpResponse(template.render(context, request))