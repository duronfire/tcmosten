import os
from django.shortcuts import render
from django.http import HttpResponse,HttpResponseNotFound
from django.views import View
from ..models.therapist import Therapist

class GetServerUpdate(View):

    def get(self,request):
        print(request.GET)
        if not bool(request.GET):
            print(request.GET)
            return HttpResponse('connected')  
        elif "get_server_update" in request.GET:
            
            # TODO query tp
            try:
                new_tp = Therapist.objects.filter(LastName__iregex="[a-zA-Z]*").order_by("-id") # return a list, whereby "-"" for decending order 
                print("wtf")
                if not bool(new_tp): # query result must not be empty!!!!
                    return HttpResponse("",status=204)

                
                print("origin queryset",new_tp.values())
                print("len queryset",len(new_tp))

                if len(new_tp) > 0:
                    response_text=""
                    i = 0
                    for tp in new_tp.values():
                        if i == len(new_tp)-1:
                            response_text = response_text + str(tp).replace("{","").replace("}","")
                        else:
                            response_text = response_text + str(tp).replace("{","").replace("}","") + "\n"
                        i += 1


                # example : {'id': 3, 'surname': 'Umlaute_Signs', 'givenname': 'ÄÜÖß`?=)(/&%$§"*+\'#,.-<>', 'birthday': datetime.date(2020, 11, 14), 'syncstate': 'created'}{'id': 2, 'surname': 'TPSURNAME', 'givenname': 'TPGIVENNAME', 'birthday': datetime.date(2020, 11, 1), 'syncstate': 'created'}{'id': 1, 'surname': 'Chu', 'givenname': 'Jianping', 'birthday': datetime.date(1956, 7, 14), 'syncstate': 'created'}

                # TODO query bill
                
                #response_body = ""
                return HttpResponse(response_text)

            except:
                return HttpResponseNotFound("")
        else:

            return HttpResponseNotFound("")
 



