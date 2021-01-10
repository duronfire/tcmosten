import os
from django.shortcuts import render
from django.http import HttpResponse,HttpResponseNotFound
from django.views import View
from ..models.staff import Staff
from ..models.patient import Patient
from ..models.rechnung import Rechnung
from ..models.meeting import Meeting
from ..models.method import Method
