## Put UOR file into C:\Temp
$data = $(Get-Content -Path "c:\temp\UOR.json" | ConvertFrom-Json)

function Get-WordCloud() {
    param(
    [System.Array]$InputData,
    [bool]$Debug,
    [string]$OutFile,
    [int]$CountMin,
    [int]$LengthMin,
    [float]$SizeMin,
    [float]$SizeScale
    )

$wordcloud_data = $InputData | ? { $_.Name.Length -ge $LengthMin -and $_.Count -ge $CountMin } 
$wordcloud_data
# Calculate how many squares are needed
$gridsize = $wordcloud_data.Count

# Calculate the grid dimensions
$x = [math]::Floor([math]::Pow($gridsize,0.5))
$y = [math]::Ceiling([math]::Pow($gridsize,0.5))

if ($x * $y -lt $gridsize) { $x += 1 }

$coords = New-Object System.Collections.ArrayList
1..$y | %{
    $yc = $_
    1..$x | %{
        $elem_ht = New-Object System.Collections.Hashtable
        $xc = $_
        $elem_ht.X = $xc
        $elem_ht.Y = $yc
        [void]$coords.Add($elem_ht)
    }
}

$coordmix = $coords | Sort-Object {Get-Random}

$i = 0

$cssdata = New-Object System.Collections.ArrayList
$wordcloud_data | %{
    $elem_ht = New-Object System.Collections.Hashtable
    if ($SizeMin -ne 0) {
        $elem_ht.Size = $SizeScale*$_.Count + $SizeMin
    }
    else{
        $elem_ht.Size = $_.Count
    }
    $elem_ht.Count = $_.Count
    $elem_ht.Word = $_.Name
    $elem_ht.Coord = $coordmix[$i]
    $elem_ht.Class = "wordcell$i"
    $elem_ht.Colour = "color-$(($i % 6) + 1)"
    [void]$cssdata.Add($elem_ht)
    $i += 1
}

$html = '<html><head><link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet"><style>'
$html += @'
.color-1 {color: #cfc716;}
.color-2 {color: #7e0707;}
.color-3 {color: #162daa;}
.color-4 {color: #9a16aa;}
.color-5 {color: #09dfc2;}
.color-6 {color: #4dca06;}
.tooltiptext {visibility: hidden;
font-size:12pt
}
div[class^="wordcell"]:hover .tooltiptext {visibility: visible}
.wrapper {
  font-family: 'Roboto', sans-serif;
  max-width: 600px;
  margin: auto;
  display: grid;
'@
$html += "grid-template-columns: repeat($x,1fr);
  grid-template-rows: repeat($y,1fr);

  justify-items: center;

  justify-content: center;
}"

#align-content: space-between;
#align-items: space-between;
#grid-column-gap: 10px;
#grid-row-gap: 10px;

# loop over cssdata
$cssdata | %{
    $html += ".$($_.Class) {"
    $html += "grid-column: $($_.Coord.X);"
    $html += "grid-row: $($_.Coord.Y);"
    $html += "display: flex;"
    $html += "font-size: $($_.Size)pt;"
    $html += "align-items: center;"
    $html += "justify-content: center;"
    $html += "}"
}
$html += '</style></head>'
$html += '<body><div class="wrapper">'
# loop over cssdata
$cssdata | %{
    $html += "<div class=" + '"' + $($_.Class) + ' ' + $($_.Colour) +'">'
    $html += $_.Word
    $html += '<span class="tooltiptext">'
    $html += "($($_.Count))"
    $html += '</span>'
    $html += "</div>"
}
$html += "</div>"
$html += '</body>'
$html += '</html>'

Set-Content -Value $html -Path $OutFile -Encoding UTF8

ii $OutFile
}



$wc_data = $($data | Group-Object sp_type_name)

# Opens in default browser, use Chrome instead if possible
Get-WordCloud $wc_data -OutFile "C:\temp\pestcloud.html" -SizeMin 5 -SizeScale .01
