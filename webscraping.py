#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr 13 17:51:12 2019

@author: wangyeyang
"""

#!/usr/bin/env python
# -*- coding: utf-8 -*-
import urllib.request
import re
import schedule
import time
import smtplib
from datetime import datetime

def jobemail():
    # product 1 "UN65NU6900"
    from selenium import webdriver
    chrome_path = r"/Users/wangyeyang/Desktop/Portfolio/chromedriver"
    driver = webdriver.Chrome(chrome_path)
    
    
    driver.get("https://www.meijer.com/shop/en/departments/video-games-consoles/nintendo/nintendo-consoles/nintendo-switch-with-neon-blue-and-neon-red-joy-con/p/4549659009")
    post1 = driver.find_element_by_class_name("display-price")
    price_up = str(post1.text)
 
    server = smtplib.SMTP('smtp.office365.com', 587)
    server.starttls()
    server.login("wang4105@purdue.edu", "XXX")

    # type subject
    SUBJECT = "Price updates " + str(datetime.now())[0:19]

    # type message
    msg1 = "Price updates\n"
    msg2 = "Current time " + str(datetime.now())[0:19] +"\n"
    msg3 = str("Price of Switch: " + price_up)
    TEXT = msg1 + msg2 + msg3

    msg = 'Subject: {}\n\n{}'.format(SUBJECT, TEXT)

    # send email (sender, receiver, message with subject)
    server.sendmail("wang4105@purdue.edu", "mayday10191995@gmail.com", msg)
    server.quit()

schedule.every().day.at("18:04").do(jobemail)

while 1:
    schedule.run_pending()
    time.sleep(1)
