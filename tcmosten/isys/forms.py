from django import forms


class SyncForm(forms.Form):

    def __init__(self, form_count_list=[0,0,0,0], *args, **kwargs):
        super().__init__(*args, **kwargs)

        num_new_ap = form_count_list[0]
        print("new ap count is: ",num_new_ap)


        for new_ap in range(num_new_ap):
            new_ap_key = "newap" + str(new_ap)
            self.fields[new_ap_key]=forms.CharField(label=str(new_ap))
            self.fields[new_ap_key]=forms.CharField(label=str(new_ap))

class SyncPostForm(forms.Form):
    post_str = forms.CharField(label='post_str')
