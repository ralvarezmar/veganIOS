---
title: Gluon Glossary

tags: 
    - glossary
    - dictionary

search:
  boost: 4
---

Gluon Glossary shares the definition of acronyms and key terms to Software processes under Gluon Platform.  
Could not find a word? Just ask for it by [opening a request into Gluon Glossary Topic](https://github.com/orgs/santander-group-gluon/discussions/new?category=glossary-of-terms){:target="_blank"} of Gluon Community.

```python exec="on" idprefix="" updatetoc="yes"
import os
import csv
import json

def get_tags_json():

    tags_structure = '''{
        "api": "0000FF",
        "apm": "008000",
        "app360": "FF0000",
        "arsenal": "FFFF00",
        "capability": "800080",
        "darwin": "FFA500",
        "docs": "FFC0CB",
        "front": "007C80",
        "gluon": "00FFFF",
        "infrastructure": "00FF00",
        "insights": "FF00FF",
        "java": "4B0082",
        "javascript": "A52A2A",
        "microservice": "808080",
        "observability": "40E0D0",
        "qa": "FFD700",
        "release": "C0C0C0",
        "sdlc": "EE82EE",
        "security": "A52A2A",
        "support": "008000",
        "testing": "007FFF",
        "itsm": "FF4500",
        "devops": "DDA0DD",
        "tools": "DC143C",
        "alm": "808000",
        "bdd": "082567"
    }'''

    json_tags = json.loads(tags_structure)

    return json_tags

def print_tag_cloud():

    print('## Tag Cloud ')

    jtags=get_tags_json()
    tag_cloud=''
    for attribute in jtags:
        value = jtags[attribute]
        tag_cloud += ' ![Static Badge](https://img.shields.io/badge/' + attribute + '-' + value + ') '
    print(tag_cloud)

def pretty_tag(tag):
    jtags=get_tags_json()
    p_tag=' ![Static Badge](https://img.shields.io/badge/'+tag+'-'+jtags[tag]+') '
    return p_tag

print_tag_cloud()

print('## List of Terms ')

glossary_path = './docs/architecture/glossary/data/glossary.csv'

glossary_file = open(glossary_path, 'r', newline='', encoding="utf-8")
reader = csv.reader(glossary_file, delimiter=';')

next(reader)

for row in reader:
    if (row[0]) == 'YES':
        term_title = row[1]
        if row[2]:
            term_title = row[2]
            term_title += ' (' + row[1] + ' )'
        tags_str="    "
        if row[3]:
            tags_str += pretty_tag(row[3])
            if row[4]:
                tags_str +=  pretty_tag(row[4])
                if row[5]:
                    tags_str += pretty_tag(row[5])

        print('#### ' +term_title + '\n')
        print(':    ' + tags_str + '\n')
        print('     ' + row[6] + '\n')
        print('\n')

glossary_file.close()

```
