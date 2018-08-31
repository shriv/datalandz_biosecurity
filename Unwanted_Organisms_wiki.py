# Download wikipedia, python -m pip install wikipedia first!
import wikipedia, json

with open(r'C:\Users\mark.johnston\Projects\DatalandNZ 2018.08\UOR.json','r') as f:
    uor = json.load(f)

i = 0

for x in uor:
    i += 1
    try:
        wiki = wikipedia.WikipediaPage(title = x['name_sci'])
    except wikipedia.exceptions.PageError:
        print('Page not found for:'+x['name_sci']+' trying '+x['name_con'])
        if(x['name_con'][0] == '-'):
            print('name_con is just a hyphen')
            continue
        try:
            wiki = wikipedia.WikipediaPage(title = x['name_con'])
        except wikipedia.exceptions.PageError:
            print('Page not found for:'+x['name_con'])
            continue

    print(wiki.summary)
    if i > 6:
        break


## add lists of patterns (glossy, speckled, spotted, stripy, stripey)
## lists of colours (black, blue, brown, pink)
## Regex to find sizes (\d)

## Get a unique list of families etc, and give a common English name, e.g. Lepidoptera = butterfly
