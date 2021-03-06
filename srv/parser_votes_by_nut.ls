require! {
    fs
    xml: xml2js
    async
}
obce = {}
year = 2006
if year >= 2010
    nuts = <[CZ0100 CZ0201 CZ0202 CZ0203 CZ0204 CZ0205 CZ0206 CZ0207 CZ0208 CZ0209 CZ020A CZ020B CZ020C CZ0311 CZ0312 CZ0313 CZ0314 CZ0315 CZ0316 CZ0317 CZ0321 CZ0322 CZ0323 CZ0324 CZ0325 CZ0326 CZ0327 CZ0411 CZ0412 CZ0413 CZ0421 CZ0422 CZ0423 CZ0424 CZ0425 CZ0426 CZ0427 CZ0511 CZ0512 CZ0513 CZ0514 CZ0521 CZ0522 CZ0523 CZ0524 CZ0525 CZ0531 CZ0532 CZ0533 CZ0534 CZ0631 CZ0632 CZ0633 CZ0634 CZ0635 CZ0641 CZ0642 CZ0643 CZ0644 CZ0645 CZ0646 CZ0647 CZ0711 CZ0712 CZ0713 CZ0714 CZ0715 CZ0721 CZ0722 CZ0723 CZ0724 CZ0801 CZ0802 CZ0803 CZ0804 CZ0805 CZ0806 ]>
else
    nuts = <[ CZ0101 CZ0102 CZ0103 CZ0104 CZ0105 CZ0106 CZ0107 CZ0108 CZ0109 CZ010A CZ010B CZ010C CZ010D CZ010E CZ010F CZ0201 CZ0202 CZ0203 CZ0204 CZ0205 CZ0206 CZ0207 CZ0208 CZ0209 CZ020A CZ020B CZ020C CZ0311 CZ0312 CZ0313 CZ0314 CZ0315 CZ0316 CZ0317 CZ0321 CZ0322 CZ0323 CZ0324 CZ0325 CZ0326 CZ0327 CZ0411 CZ0412 CZ0413 CZ0421 CZ0422 CZ0423 CZ0424 CZ0425 CZ0426 CZ0427 CZ0511 CZ0512 CZ0513 CZ0514 CZ0521 CZ0522 CZ0523 CZ0524 CZ0525 CZ0531 CZ0532 CZ0533 CZ0534 CZ0611 CZ0612 CZ0613 CZ0614 CZ0615 CZ0621 CZ0622 CZ0623 CZ0624 CZ0625 CZ0626 CZ0627 CZ0711 CZ0712 CZ0713 CZ0714 CZ0715 CZ0721 CZ0722 CZ0723 CZ0724 CZ0801 CZ0802 CZ0803 CZ0804 CZ0805 CZ0806 ]>
parseObec = (obec) ->
    id = obec.$.CIS_OBEC
    strany = []
    ucast = obec.UCAST.0.$
    nehlasovali = +ucast.ZAPSANI_VOLICI - +ucast.VYDANE_OBALKY
    strany[0] = nehlasovali
    obec.HLASY_STRANA.forEach (strana) ->
        id = parseInt strana.$.KSTRANA, 10
        strany[id] = parseInt strana.$.HLASY, 10
    obce[id] = strany
(err, data) <~ fs.readFile "#__dirname/../data/vysledky_#{year}_nuts/krajmesta.xml"
data .= toString!
(err, result) <~ xml.parseString data
result.VYSLEDKY_KRAJMESTA.KRAJ.forEach (kraj) ->
    kraj.OBEC?.forEach parseObec
<~ async.eachLimit nuts, 10, (nut, cb) ->
    (err, data) <~ fs.readFile "#__dirname/../data/vysledky_#{year}_nuts/#nut.xml"
    data .= toString!
    (err, result) <~ xml.parseString data
    result.VYSLEDKY_OKRES.OBEC?.forEach parseObec
    cb!
csv = ""
for obec, strany of obce
    csv += "#obec,#{strany.join ','}\n"
fs.writeFile "#__dirname/../data/#{year}_obce.csv", csv

json = JSON.stringify obce .replace /null/g "0"
fs.writeFile "#__dirname/../data/#{year}_obce.json", json
