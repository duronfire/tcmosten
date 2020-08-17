import win32com.client,win32ui
import datetime,os



outlook=win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")
accounts=win32com.client.Dispatch("Outlook.Application").Session.Accounts
inbox=outlook.GetDefaultFolder(6)
calendar = outlook.GetDefaultFolder(9) # olFolderCalendar = 9, olFOlderInbox = 6 


#os.startfile("outlook") #start outlook if login is needed

today = datetime.datetime.now().replace(hour=0,minute=0,second=0,microsecond=0)
print(today)

monday = today - datetime.timedelta(days=today.weekday())
print(monday,"monday") #0:00 = 12:00 AM, 12:00 = 12:00 PM


sunday = (monday + datetime.timedelta(6)).replace(hour=23,minute=59,second=59,microsecond=0)
print(sunday,"sunday")

time_format='%#d/%#m/%y %#I:%M %p'

start_time=monday.strftime(time_format)
end_time=sunday.strftime(time_format)
print("start",start_time)
print("end",end_time)

print(calendar.Items(9).Start)

sFilter="[Start] > '" + start_time  + "'" + " AND [Start] < '" + end_time  + "'" # d/m/y 02/1/2003 or 25/12/2003 no zero for month. Day/Month/Year order must be same as system! For German d/m/y, for English m/d/y 
print(sFilter)

week_appointments=calendar.Items.Restrict(sFilter)

print("total appointments items", calendar.Items.Count)
print("found appointments items this week", week_appointments.Count)

week_appointments=sorted(week_appointments,key=lambda x:x.Start) #sort week_appointments by start time
print(week_appointments)

appointment_starttimes=[x.Start for x in week_appointments]
print(appointment_starttimes)

for i in week_appointments:
    print("Subject:", i.Subject)



    recipients_count=i.Recipients.Count
    print("Recipients:",recipients_count)
    if recipients_count is 2:
        print("Recipients:", i.Recipients.Item(2))
    elif recipients_count > 2:
        print("Error: Too much recipients at one appointment!")
    elif recipients_count is 1:
        print("Error: No recipients!")
    else:
        print("Error: Check OUTLOOK, No organizer!") 



    print("Start:", i.Start)
    print("End:",i.End)



                                    
#messages = inbox.Items
#message = messages.GetLast()
#body_content = message.body
#print(body_content)

