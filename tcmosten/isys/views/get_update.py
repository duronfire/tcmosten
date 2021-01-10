import os,ast
from django.shortcuts import render
from django.http import HttpResponse,HttpResponseNotFound
from django.views import View
from ..models.staff import Staff
from ..models.meeting import Meeting

class GetUpdate(View):

    def get(self,request):
        print(request.GET)
        if not bool(request.GET):
            return HttpResponse('connected')  
        elif "query_dict" in request.GET:


            query_dict = ast.literal_eval(request.GET["query_dict"])


            updated_staff = Staff.objects.all().order_by("-id") # return a list, whereby "-"" for decending order 
            print("origin queryset",updated_staff.values())
            print("len queryset",len(updated_staff))

            if bool(updated_staff):
                response_text=""
                i = 0
                for staff in updated_staff.values():
                    if i == len(updated_staff)-1:
                        response_text = response_text + str(staff).replace("{","").replace("}","")
                    else:
                        response_text = response_text + str(staff).replace("{","").replace("}","") + "\n"
                    i += 1
                response_text = response_text + "}" + "\n" + "{"
            else:
                response_text = "}" + "\n" + "{"

            billed_ap = Meeting.objects.filter(synclabel__exact="toupdate",archivelabel = "live",patient__location__id__exact=query_dict['location_id']).order_by("-id")
            print("origin queryset",billed_ap.values())
            print("len queryset",len(billed_ap))

            if bool (billed_ap):

                i = 0
                for ap in billed_ap.values():
                    if i == len(billed_ap)-1:
                        response_text = response_text + str(ap).replace("{","").replace("}","")
                    else:
                        response_text = response_text + str(ap).replace("{","").replace("}","") + "\n"
                    i += 1

            # response_text example:
            #  'id': 3, 'surname': 'Umlaute_Signs', 'givenname': 'ÄÜÖß`?=)(/&%$§"*+\'#,.-<>', 'birthday': datetime.date(2020, 11, 14), 'syncstate': 'created'
            #  'id': 2, 'surname': 'TPSURNAME', 'givenname': 'TPGIVENNAME', 'birthday': datetime.date(2020, 11, 1), 'syncstate': 'created'
            #  'id': 1, 'surname': 'Chu', 'givenname': 'Jianping', 'birthday': datetime.date(1956, 7, 14), 'syncstate': 'created'

            
            #response_body = ""
            print("response_text: ", response_text)
            return HttpResponse(response_text)


        else:

            return HttpResponseNotFound("")
 



