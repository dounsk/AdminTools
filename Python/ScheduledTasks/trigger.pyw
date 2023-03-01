import time

localtime = time.localtime(time.time())
hh = localtime.tm_hour

if hh == 16:
    print ("1")
elif hh == 2:
    result = '2'
elif hh == 3:
    result = '3'
elif hh == 4:
    result = '4'
elif hh == 5:
    result = '5'
else:
    result = '6'

