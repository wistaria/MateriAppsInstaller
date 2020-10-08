import requests
from bs4 import BeautifulSoup
import re
import time
import h5py

def get_retry(url, retry_times, errs):
    for t in range(retry_times + 1):
        r = requests.get(url)
        if t < retry_times:
            if r.status_code in errs:
                time.sleep(2)
                continue
        return r

url_list = []
url_list.append("https://ma.issp.u-tokyo.ac.jp/app/#gsc.tab=0")#
#for idx in list(range(0,27)):
for idx in range(27):
    url_list.append("https://ma.issp.u-tokyo.ac.jp/app/page/{}#gsc.tab=0".format(idx+2))

print(url_list)
    
# name, summary, official_url, license
select_str_dict = {"name": "#top > header > div.inner.app-header__inner > div > h2", 
                   "summary":"#top > header > div.inner.app-header__inner > div.app-header__content > div > p",
                   "official_url": "#top > div > section > section:nth-child(2) > div > p > a",
                   "license": "#top > div > section > section:nth-child(3) > div > p",
                   "avalability": "#top > div > section > section:nth-child(4) > table > tbody > tr:nth-child(1) > td > p",
                   "core developers": "#top > div > section > section:nth-child(4) > table > tbody > tr:nth-child(2) > td > p"}

with h5py.File("materiapps_info_ja.h5", "a") as fw:
    for idx, url in enumerate(url_list):
        print("Read {}".format(idx))
        res = requests.get(url)
        soup = BeautifulSoup(res.text, "html.parser")
        #Get App's URL
        elems = soup.find_all(href=re.compile("/app/[0-9]+"), text=re.compile("アプリ詳細へ"))
        pickup_links = [elem.attrs["href"] for elem in elems]
        print(pickup_links)
        for pickup_link in pickup_links:
            print(pickup_link)
            #pickup_res = requests.get(pickup_link)
            pickup_res = get_retry(pickup_link, 3, [35, 60])
            pickup_soup = BeautifulSoup(pickup_res.text, "html.parser")
            info_dict = {"url_to_ma": pickup_link}
            for key, select_str in select_str_dict.items():   
                info = pickup_soup.select(select_str)
                if len(info) == 0:
                    info_dict[key] = ""
                else:
                    if len(info[0].contents) == 0:
                        info_dict[key] = ""
                    else:
                        info_dict[key]=str(info[0].contents[0])
            
            #print name
            app_name = info_dict["name"]
            print(info_dict)
            if app_name in fw:
                del fw[app_name]
            fw.create_group(app_name)
            for key, value in info_dict.items():
                fw[app_name].create_dataset(key, data=value)
        fw.flush()
