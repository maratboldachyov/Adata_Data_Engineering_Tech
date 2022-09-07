import requests
import re
from bs4 import BeautifulSoup

sup_URL = 'https://www.goszakup.gov.kz/ru/registry/show_supplier/188404'
page_sup = requests.get(sup_URL, verify=False)
sup_soup = BeautifulSoup(page_sup.content, "html.parser")
sup_details_elements = sup_soup.find_all("table", class_="table table-striped")

try:
    sup_details_table_1 = sup_details_elements[0]
    sup_details_table_2 = sup_details_elements[2]
    sup_details_table_3 = sup_details_elements[3]
except:
    pass


for j in sup_details_table_1:
    sup_key = str(j.find("th")).removeprefix("<th>").removesuffix("</th>")
    sup_value = str(j.find("td")).removeprefix("<td>").removesuffix("</td>")
    if 'БИН участника' in sup_key or 'Наименование на рус. языке' in sup_key:
        print(sup_key, sup_value)
        # sup_details_dict[sup_key] = sup_value
for j in sup_details_table_2:
    sup_key = str(j.find("th")).removeprefix("<th>").removesuffix("</th>").removeprefix('<th class="col-sm-4">')
    sup_value = str(j.find("td")).removeprefix("<td>").removesuffix("</td>").removeprefix('<th class="col-sm-4">')
    if 'ИИН' in sup_key or 'ФИО' in sup_key:
        print(sup_key, sup_value)
        # sup_details_dict[sup_key] = sup_value
    sup_details_elements = sup_soup.find(text='Полный адрес(рус)').parent

sup_elements_table_3 = sup_soup.find(text='Полный адрес(рус)')
sup_key = sup_soup.find(text='Полный адрес(рус)')
value = sup_elements_table_3.find_next('td')

for k in range(2):
    sup_value = value.find_next('td')
    if k > 0:
        sup_value = str(sup_value.find_next('td')).removeprefix("<td>").removesuffix("</td>")
    # sup_value.strip()
sup_value = sup_value.strip()
print(sup_key, sup_value)
# m = 0
# for i in sup_value:
#     print(i, m)
#     m += 1


