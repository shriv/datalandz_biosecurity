# Download wikipedia, python -m pip install wikipedia first!
import wikipedia, json, re

with open(r'../data/UOR.json','rb') as f:
    uor = f.read().decode('utf-8', 'ignore').encode('utf-8')

uor = json.loads(uor)

target = [org for org in uor if org['name_con'] == 'brown-marmorated stink bug' or org['name_sci'] == 'Austropuccinia psidii']

print(target)

i = 0

## lists of colours (black, blue, brown, pink)
colours = ['blue','green','black','gr[ae]y','orange','white','purple','red','yellow','brown'
,'ochre','khaki','mauve','olive','pink'
]

## Create regex match with word-boundary or dash
boundary = r'[ -]'
colours_bounded = '|'.join(['{0}{1}{0}'.format(boundary,c) for c in colours])


rxs = re.compile(colours_bounded,re.MULTILINE)

# Loop through the organisms
for x in target:
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

    text = wiki.summary
    try:
        text += wiki.section('Description')
    except:
        pass

    for match in rxs.finditer(text):
        col = match.groups()
        print(col)


    if i > 6:
        break


## add lists of patterns (glossy, speckled, spotted, stripy, stripey)
patterns = ['glossy','speckled','spotted','stripe?y','mottled','marbled']

## Characteristics
chars = ['feathers?','scal[ey]s?','talons?','claws?']

## Regex to find sizes (\d)
sizereg = r'(\d+(\.\d{1,2})?)\s?(-|to)?\s?(\d+(\.\d{1,2})?)?\s?(((c(enti)?)?|(m(illi)?m)?)?m(et(re|er)(s)?)?|in(ches)?|f(ee)?t|y(ar)?d(s)?)'

