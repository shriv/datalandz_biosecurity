$searchpage = 'https://apps.mpi.govt.nz/applications/nzpests-search?Page={0}'

# Get the max search page
$resp = Invoke-WebRequest $($searchpage -f 1000)
$pagerange = $($($resp.ParsedHTML.GetElementsByTagName('a') | ? { $_.className -eq 'dig_pager_button'}).innerText)

$phtml.getElementsByName(

$invalid = 'Object reference not set to an instance of an object'
1..1000 | % -Begin {$pests = @{}} -Process {
    $response = Invoke-WebRequest $("https://apps.mpi.govt.nz/applications/nzpests-view/Article/{0}" -f $_)
    Write-Host $_,$response.StatusCode
    $pHTML = $response.ParsedHtml
    
    $header1 = $($pHTML.getElementsByTagName('h1')).innerText
    $stat = $($pHTML.getElementById('statusFields')).innerText

    $stat -split [system.Environment]::NewLine | % -Begin {$ht = @{}} -Process {
    $fields = $($_ -split ' : ')
    $ht[$fields[0]] = $fields[1]
}


$pests

