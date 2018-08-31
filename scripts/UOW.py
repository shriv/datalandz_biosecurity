# Download wikipedia, python -m pip install wikipedia first!
import wikipedia, json, re

with open(r'../data/UOR.json','rb') as f:
    uor = f.read().decode('utf-8', 'ignore').encode('utf-8')

uor = json.loads(uor)

target = ['Halyomorpha halys','myrtle rust','Bruchus pisorum','Bactrocera tryoni',u'Aleurotrachelus camelliae', u'Aphis cardui', u'Aulacaspis yasumatsui', u'Bruchus emarginatus', u'Cercospora hayi', u'Cladosporium vignae', u'Crocidolomia binotalis', u'Dialeurodes musae', u'Edwardsiana ishidae', u'Eudocima salaminia', u'Geococcus coffeae', u'Heterobasidion annosum (anamorph Spiniger meineckellum)', u'Koebelia californica', u'Lumpy skin disease virus', u'Melolontha melolontha', u'Napomyza carotae', u'Operophtera fagata', u'Paria lefevrei', u'Phoma wasabiae', u'Pityophthorus nitidulus', u'Pseudomonas syringae pv. avellanae', u'Rhamnus alaternus', u'Selenaspidus articulatus', u'Stethopachys formosa', u'Thyas juno', u'Virachola livia']

print(target)

i = 0

## lists of colours (black, blue, brown, pink)
colours = ['blue','green','black','gr[ae]y'
,'orange','white','purple','red'
,'yellow','brown','ochre','khaki'
,'mauve','olive','pink'
]
## add lists of patterns (glossy, speckled, spotted, stripy, stripey)
patterns = ['glossy','speckled','spotted','stripe?y','mottled','marbled']

## Characteristics
chars = ['feathers?','scal[ey]s?','talons?','claws?','powdery?']

## Create regex match with word-boundary or dash
def bound_regex(cat,lst):
    boundary = r'[ -]'
    colours_bounded = '|'.join(['{0}{1}{0}'.format(boundary,c) for c in lst])
    colours_bounded = '{0}{1}{2}'.format('(',colours_bounded,')')
    return {'cat':cat,'regex':re.compile(colours_bounded,re.MULTILINE)}

rxs = []
rxs.append(bound_regex('colours',colours))
rxs.append(bound_regex('patterns',patterns))
rxs.append(bound_regex('chars',chars))


## Regex to find sizes (\d)
sizereg = r'(\d+(\.\d{1,2})?)\s?(-|to)?\s?(\d+(\.\d{1,2})?)?\s?(((c(enti)?)?|(m(illi)?m)?)?m(et(re|er)(s)?)?|in(ches)?|f(ee)?t|y(ar)?d(s)?)'
rxs.append({'cat':'sizes','regex':re.compile(sizereg,re.MULTILINE)})


uor_count = len(target)
# Loop through the organisms
newlst = []
for x in target:
    i += 1
    try:
        wiki = wikipedia.WikipediaPage(title = x)
    except wikipedia.exceptions.PageError:
        print('Page not found for:'+x)
        continue

    text = wiki.summary
    try:
        text += wiki.section('Description')
    except:
        pass

    d = {}
    for rx in rxs:
        m=[]
        for match in rx['regex'].finditer(text):
            col = match.groups()
            if rx['cat'] == 'sizes':
                m.append(col[0])
                m.append(col[1])
                m.append(col[5])
            else:
                m.append(col)
        d[rx['cat']] = list(set(m))

    d['text']=text
    d['sci_name']=x
    
    newlst.append(d)
    print('UOR '+str(i)+' of '+str(uor_count)+' queried')

with open('../data/UOR_enrich.json','w') as f:
    json.dump(newlst,f)
