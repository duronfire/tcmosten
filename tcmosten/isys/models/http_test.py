from django.db import models


from django.forms import ModelForm


class http_test(models.Model):
    state = models.CharField(max_length=10,default="state")
    pid = models.CharField(max_length=150,default="pid")
    name = models.CharField(max_length=30,default="defaultname")
    
    


class http_testform(ModelForm):
    class Meta:
        model = http_test
        fields = '__all__'