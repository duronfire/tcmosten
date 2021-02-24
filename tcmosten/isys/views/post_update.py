import os,ast
from django.shortcuts import render
from django.http import HttpResponse, HttpResponseNotFound
from django.views import View
from ..models.patient import Patient
from ..models.staff import Staff
from ..models.meeting import Meeting
from ..forms import SyncPostForm

class PostUpdate(View):

    def get(self,request):
        print(request.GET)
        if bool(request.GET):
            print(request.GET)
            query_dict = ast.literal_eval(request.GET["query_dict"])
            if self.validate_get(query_dict):
                form = SyncPostForm()
                return render(request, 'isys/post_update.html', {'form': form})

        print("Fatal Error in PostUpdate.get!")
        return HttpResponseNotFound("")

    def post(self,request):
        print(request.GET)
        if bool(request.GET):
            form = SyncPostForm(request.POST)
            query_dict = ast.literal_eval(request.GET["query_dict"])
            if  form.is_valid():
                
                print("request is valid!")
                print(request.POST)
                
                query_strs = ["newpts","changedpts","newaps","changedaps"]
                funcs = {"newpts":self.add_newpt,"changedpts":self.update_changedpt,"newaps":self.add_newap,"changedaps":self.update_changedap}
                location_id = query_dict["location_id"]
                list_pt_response_text = []
                list_ap_response_text = []
                for query_str in query_strs:

                    num_item_get = int(query_dict[query_str]) # this request.GET is a new instance of view by HTTP POST actually, it has no thing to do with last HTTPGET. But QueryDict will be saved as request.GET by HTTPPOST and Post Body will be saved in request.POST
                
                    items = ast.literal_eval(form.cleaned_data["post_str"])[query_str]
                    print(query_str+"     ", items)

                    if num_item_get == len(ast.literal_eval(form.cleaned_data["post_str"])[query_str]):
                        for index, item_dict in items.items():
                            
                            print(query_str+" dict: ", item_dict)
                            item = funcs[query_str](item_dict,location_id)
                            if item is None:
                                print("Fatal Error in PostUpdate.post! funcs[query_str](item_dict,location_id) is None!")
                                return HttpResponseNotFound("")
                            elif query_str=="newpts":
                                pt_response_text = "'pid': " + str(item.id) + ", 'EntryID': '" + item.EntryID + "'"
                                list_pt_response_text.append(pt_response_text)
                            elif query_str=="newaps":
                                ap_response_text = "'pid': " + str(item.id) + ", 'EntryID': '" + item.EntryID + "'"
                                list_ap_response_text.append(ap_response_text)

                    else:
                        print("Fatal Error in PostUpdate.post! num_item_get != len(ast.literal_eval(form.cleaned_data['post_str'])[query_str])")
                        return HttpResponseNotFound("")


            # response_text example set_pid:
            #  'id': '2', 'EntryID: 'ABDFDSSDFSDEDFDSFSDFSDF1011010101010'
            #  'id': '1', 'EntryID: 'ABDFDSSDFSDEDFDSFSDFSDF1011010101010'}
            #  {'id': '2', 'EntryID': 'ABDFDSSDFSDEDFDSFSDFSDF1011010101010'
            #  'id':'1', ''EntryID': 'ABDFDSSDFSDEDFDSFSDFSDF1011010101010'

                if bool(list_pt_response_text):
                    response_text=""
                    i = 0
                    for response in list_pt_response_text:
                        if i == len(list_pt_response_text)-1:
                            response_text = response_text + response
                        else:
                            response_text = response_text + response + "\n"
                        i += 1
                    response_text = response_text + "}" + "\n" + "{"
                else:
                    response_text = "}" + "\n" + "{"


                if bool (list_ap_response_text):
                    i = 0
                    for response in list_ap_response_text:
                        if i == len(list_ap_response_text)-1:
                            response_text = response_text + response
                        else:
                            response_text = response_text + response + "\n"
                        i += 1
                

                print("response_text: ", response_text)
                return HttpResponse(response_text)

                

        print("Fatal Error in PostUpdate.post! bool(request.GET)")    
        return HttpResponseNotFound("")

 
    def add_newpt(self,item_dict,location_id):
        item=None
        count = self.get_item_count(item_dict,location_id) 
        if count == 0:
            item_dict['location_id']=location_id
            item=Patient.create(**item_dict)
        elif count == 1:
            item=Patient.objects.get(EntryID=item_dict["EntryID"])
        return item

    def update_changedpt(self,item_dict,location_id):

        item=Patient.objects.get(id=int(item_dict["pid"]))
        item.sync(**item_dict)
        return item




    def add_newap(self,item_dict,location_id):
        item=None
        count = self.get_item_count(item_dict,location_id) 
        if count == 0:
            item_dict['location_id']=location_id
            item=Meeting.create(**item_dict)
        elif count == 1:
            item=Meeting.objects.get(EntryID=item_dict["EntryID"])
        return item

    def update_changedap(self,item_dict,location_id):

        item=Meeting.objects.get(id=int(item_dict["pid"]))
        item.sync(**item_dict)
        return item



    def validate_get(self,query_dict):

        '''
        request must include query string, i.e. "?newap=2"
        '''
        query_strs = ["newpts","changedpts","newaps","changedaps"]
        for qstr, count in query_dict.items():
            if qstr in query_strs:
                try:
                    int(count) 
                except:
                    return False
        return True
    
    def get_item_count(self,item_dict,location_id):

        entryid = item_dict["EntryID"]
        try:
            isAPITEM=item_dict["aplabel"]
            isAPITEM=True
        except:
            isAPITEM = False

        if not isAPITEM:
            dup=Patient.objects.filter(location__id__exact=location_id,EntryID__exact=entryid)
        if isAPITEM:
            dup=Meeting.objects.filter(patient__location__id__exact=location_id,archivelabel__exact ="live",EntryID__exact=entryid)


        return len(dup)


        