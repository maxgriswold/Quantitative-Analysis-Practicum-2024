Python 3.12.2 (tags/v3.12.2:6abddd9, Feb  6 2024, 21:26:36) [MSC v.1937 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license()" for more information.
import requests
from bs4 import BeautifulSoup
import csv
import time
import string

def make_printable(text):
    printable = set(string.printable)
    return ''.join(filter(lambda x: x in printable, text))

def make_list_from_table(table):
    result = []
    all_rows = table.findAll('tr')
    for row in all_rows:
        result.append([])
        all_cols = row.findAll('td')
        for col in all_cols:
            the_strings = [make_printable(s.text) for s in col.findAll(string=True)]
            the_text = ''.join(the_strings)
            result[-1].append(the_text)
    return result

def get_data(url):
    response = requests.get(url)
    result = []

...     if response.status_code == 200:
...         soup = BeautifulSoup(response.text, 'html.parser')
...         rows = soup.find_all("tr")
...         result = []
...         current_entry = []
...         question_and_answer = {}
... 
...         for row in rows:
...             cells = row.find_all('td')
... 
...             for cell in cells:
...                 classes = cell.get('class', [])
...                 if 'SubHeader' in classes:
...                     result.append(current_entry)
...                     current_entry = [cell.text]
... 
...                 if 'I3' in classes:
...                     question_and_answer = {"question": make_printable(cell.text)}
... 
...                 if 'I5' in classes:
...                     if cell.find('table'):
...                         question_and_answer['response'] = make_list_from_table(cell.find("table"))
...                     else:
...                         question_and_answer["response"] = cell.text
...                     current_entry.append(question_and_answer)
... 
...         result = result[1:]
... 
...     else:
...         print('Failed to fetch the webpage:', response.status_code)
... 
... def main():
...     fileName = "Professional_and_Occupational_Licenses_in_Colorado_20240208.csv"
... 
...     with open(fileName, mode ='r') as file:
...         csvFile = csv.reader(file)
...         csvValues = next(file)[:-1].split(",")
...         print(csvValues)
        queryValue = csvValues.index("linkToViewHealthcareProfile")
        for lines in csvFile:
            url = lines[queryValue]
            if url:
                print(url)
                data = get_data(url)
                time.sleep(1)
            else:
                print("none")
            time.sleep(0)

if __name__ == "__main__":
