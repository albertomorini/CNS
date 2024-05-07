#just gonna leave it there so you can use it any way you likeù
#struct_time in UTC >>to>> seconds since the epoch   #calendar.timegm()

	



import datetime
import time
import calendar

def main ():
    time_tuple = (2012, 4, 1, 0, 0, 0, 0, 0, 0)

    # convert time_tuple to seconds since epoch
    seconds = time.mktime(time_tuple) #my timezone
    print(seconds)

    seconds2 = calendar.timegm(time_tuple) #GMT timezone
    print("ush")
    print (seconds2)
    

main()