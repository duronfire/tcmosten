import win32com.client,win32ui
import datetime,os,json,re,time
 
 
UPROP_LASTSYNC = "lastsync"
UPROP_STARTSYNC = "startsync"
UPROP_BILLSTATE = "billstate"  #nobill, open, settled,  ap only prop
UPROP_BILLPID = "billpid"  #-1 = nopid, 1 to xxxxx bill pid in sql,  ap only prop
UPROP_LASTBILL = "lastbill"  #last timestamp of open bill,  ap only prop
UPROP_ARCHIEVRUN = "archievrun"  #idle, run, error for permission archiev ap,  ap only prop
UPROP_SYNCRUN = "syncrun"  #idle, run, error,  for permission save changes
UPROP_TPPID = "tppid"  # therapeut has own table, ap only prop
#ol sql interact:
UPROP_ITEMSTATE = "itemstate"  #created, changed, changed_aft_timeout, changed_aft_error, onserver for identify change states, interact with start/last sync stamp
UPROP_PTLABEL = "ptlabel"  #patient,therapeut, ct only prop, patient label from ol and therapeut label from sql
 #sql read only:
UPROP_PATIENTSTATE = "patientstate"  #created,new,old,oldnew, ct only prop
UPROP_APLABEL = "aplabel"  #kickoffnew,kickoffold,followup,  ap only prop
UPROP_PEID = "pentryid"  # ap only prop
UPROP_TPFULLNAME = "tpfullname"  # ap only prop
UPROP_APCATEGORY = "apcategory"  #present, absent, canceled, notreatment according to category value, ap only prop
 
OUTLOOK=win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")
APFOLDER = OUTLOOK.GetDefaultFolder(9) # olFolderCalendar = 9, olFOlderInbox = 6 
CTFOLDER = OUTLOOK.GetDefaultFolder(10)
 
 
def check_syncrun(TIMEOUT=10):
    syncrun = True
 
    check_start = time.perf_conter()
    while syncrun and time_count < TIMEOUT:  
        num_running_apitems = APFOLDER.Items.Restrict("[" + UPROP_ITEMSTATE + "]= 'run'").Count
        num_running_ctitems = CTFOLDER.Items.Restrict("[" + UPROP_ITEMSTATE + "]= 'run'").Count
        if num_running_apitems > 0 or num_running_ctitems > 0:
           syncrun = False
        check_now = time.perf_count()
        time_count = check_now - check_start
    return syncrun
 
 
def run_sync(TIMEOUT=10):
    # frozen outlook by using userfrom without botton
 
    # GET request SQL for check SQL RunState
 
    #

