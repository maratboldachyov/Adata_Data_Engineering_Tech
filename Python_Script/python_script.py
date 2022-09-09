import requests
import re
from bs4 import BeautifulSoup
import time
import pandas as pd
import json
from openpyxl.workbook import Workbook

URL = "https://www.goszakup.gov.kz/ru/registry/rqc?count_record=2000&page=1 "
page = requests.get(URL, verify=False)
file = 'final.xlsx'

soup = BeautifulSoup(page.content, "html.parser")
sup_elements = soup.find_all("td")

# print(len(sup_elements))

sup_details_dict = {}
final = []

cnt = 0
for i in sup_elements:

    sup_URL = i.find("a")
    if sup_URL is None:
        continue
    else:
        sup_URL = sup_URL["href"]
        # print(sup_URL)
    a = True
    while a:
        try:
            page_sup = requests.get(sup_URL, verify=False)
            a = False
        except:
            time.sleep(10)

    sup_soup = BeautifulSoup(page_sup.content, "html.parser")
    sup_details_elements = sup_soup.find_all("table", class_="table table-striped")
    try:
        sup_details_table_1 = sup_details_elements[0]
        sup_details_table_2 = sup_details_elements[2]
        sup_details_table_3 = sup_details_elements[3]
    except:
        continue

    for j in sup_details_table_1:
        sup_key = str(j.find("th")).removeprefix("<th>").removesuffix("</th>")
        sup_value = str(j.find("td")).removeprefix("<td>").removesuffix("</td>")
        if 'БИН участника' in sup_key or 'Наименование на рус. языке' in sup_key:
            sup_details_dict[sup_key] = sup_value
    for j in sup_details_table_2:
        sup_key = str(j.find("th")).removeprefix("<th>").removesuffix("</th>").removeprefix('<th class="col-sm-4">')
        sup_value = str(j.find("td")).removeprefix("<td>").removesuffix("</td>").removeprefix('<th class="col-sm-4">')
        if 'ИИН' in sup_key or 'ФИО' in sup_key:
            sup_details_dict[sup_key] = sup_value

    sup_elements_table_3 = sup_soup.find(text='Полный адрес(рус)')
    sup_key = sup_soup.find(text='Полный адрес(рус)')
    value = sup_elements_table_3.find_next('td')

    for k in range(2):
        sup_value = value.find_next('td')
        if k > 0:
            sup_value = str(sup_value.find_next('td')).removeprefix("<td>").removesuffix("</td>")
    sup_value = sup_value.strip()
    sup_details_dict[sup_key] = sup_value

    final.append(sup_details_dict)
    cnt += 1
    if cnt % 5 == 0:
        time.sleep(4)
    sup_details_dict = {}
    print(cnt)

print(final)
with open('python_script.json', 'w') as final_json:
    json.dump(final, final_json)
df_json = pd.read_json('python_script.json')
df_json.drop_duplicates(inplace=True)
df_json.to_excel('final.xlsx', index=False)


