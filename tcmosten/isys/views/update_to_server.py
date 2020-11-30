import os
from django.shortcuts import render
from django.http import HttpResponse
from django.views import View
from ..models.therapist import Therapist

class UpdateToServer(View):

    def get(self,request):

        if not bool(request.GET):

                    
            num_new_ap = int(request.GET["newap"]) # The first HTTP GET in order to get crsf key and cookie
            #num_new_ct = request.GET["newct"]
            #num_changed_ap = request.GET["changedap"]
            #num_changed_ct = request.GET["changed_ct"]
            form = SyncForm(form_count_list=[num_new_ap,0,0,0])
            return render(request, 'isys/get_sync.html', {'form': form})
        else:
            return HttpResponseNotFound("")

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

 
    def validate_get(request):

        '''
        request must include query string, i.e. "?newap=2"
        '''
        query_strs = ["newap","newct","changedap","chagnedct"]
        for qstr, count in request.items:
            if not qstr in query_strs:
                return False
            try:
                int(count)
            except:
                return False

    def validate_post(request):
        '''
        request must include post body, separated by ";" i.e. surname=abc;givenname=def;bday=01.09.1985"
        '''
        query_strs = ["newap","newct","changedap","chagnedct"]
        query_strs_newap = [""]
        query_strs_newct = [""]
        query_strs_changedap = [""]
        query_strs_changedct = [""]

        for type_count, entry in request.items:
            if not type_count.split("_")[0] in query_strs:
                return False
            try:
                int(type_count.split("_")[1])
            except:
                return False
            # check item in new exists in sql if true is a error.
            # check item in change in sql if false is a error. 
        