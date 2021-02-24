from django.db import models
import datetime



class Location(models.Model):

    # fields definition


    city = models.CharField(max_length=30,default="St.Gallen")
    country = models.CharField(max_length=30, default = "Schweiz")
    postalcode = models.CharField(max_length=30,default="9000")
    street = models.CharField(max_length=50,default="Bahnhofpl. 1")

    email = models.CharField(max_length=30,default="st.gallen@tcm-osten.ch")
    telephone = models.CharField(max_length=30,default="071 223 8383")
    mobile = models.CharField(max_length=30,default="076 627 0346")

    Creation = models.DateTimeField(auto_now_add = True)
    LastModified = models.DateTimeField(auto_now = True)