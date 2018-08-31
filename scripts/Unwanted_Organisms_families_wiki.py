

# Download wikipedia, python -m pip install wikipedia first!
import wikipedia, json

with open(r'c:\temp\uor_fams.json','r') as f:
    uor = json.load(f)

i = 0

d={}

for x in uor:
    if x[0] == '-':
        continue
    i += 1
    print(x)
    try:
        wiki = wikipedia.WikipediaPage(title = x)
    except:
        print('Page not found for:'+x)
        continue

    d[x] = wiki.summary

with open(r'C:\temp\uor_fams_wiki.json','w') as f:
    json.dump(d,f)


