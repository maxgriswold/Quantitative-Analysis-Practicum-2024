# -*- coding: utf-8 -*-
"""
Scrape neighborhood watch data
Created on Mon Jan 15 10:56:45 2024
@author: griswold
"""

import os

import numpy as np
import pandas as pd

import requests
from urllib3.exceptions import InsecureRequestWarning
from bs4 import BeautifulSoup as bs

# Suppress warning about certificate verification. 
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

filepath = "C:/Users/griswold/documents/GitHub/av_fellowship/data/neighborhood_watch/"
os.chdir(filepath)

# Connect to neighborhood watch by page, grab program information, then move to next page:
url = "https://nnw.org/find-a-watch-program?type=1&field_county_value=&field_address_locality=&field_address_postal_code=&field_address_administrative_area=&page="
url_list = ["{u}{page}".format(u = url, page = x) for x in 1 + np.arange(4328)]

def extract_page (url):
    
    response = requests.get(url, verify = False)
    content = bs(response.text, "html.parser")
    
    n = [x.text for x in content.select("span[class*=name]")] 
    e = [x.text for x in content.select("span[class=email]")]
    w = [x.text for x in content.select("span[class=website]")] 
    
    c = [x.text for x in content.select("span[class=county]")] 
    s = [x.text for x in content.select("span[class=street]")] 
    a = [x.text for x in content.select("span[class=address]")]
    
    res = pd.DataFrame({'name':n, 'email':e, 'website':w, 'county':c, 'street':s, 'address':a})

    return(res)

df = pd.DataFrame(columns=['name', 'email', 'website', 'county', 'street', 'address'])
df.to_csv('neighborhood_watch.csv', index = False)

# Processing this in batches since I'm constantly booted from VPN.
for b in np.arange(np.ceil(4328)/100):
    
    b = int(b) 
    
    results = [extract_page(x) for x in url_list[b*100:(b + 1)*100]]
    results = pd.concat(results)
    
    results.to_csv('neighborhood_watch.csv', mode = 'a', index = False, header = False)
    print('Finished batch {bat}\n'.format(bat = b))
    
    
    
    
