from django.db import models


from django.forms import ModelForm


class http_test(models.Model):
    vorname = models.CharField(max_length=30,default="defaultname")
    nachname = models.CharField(max_length=30,default="defaultname")


class http_testform(ModelForm):
    class Meta:
        model = http_test
        fields = '__all__'