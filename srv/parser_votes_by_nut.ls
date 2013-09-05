require! {
    fs
    xml: xml2js
    async
}
nuts = <[CZ0100 CZ0201 CZ0202 CZ0203 CZ0204 CZ0205 CZ0206 CZ0207 CZ0208 CZ0209 CZ020A CZ020B CZ020C CZ0311 CZ0312 CZ0313 CZ0314 CZ0315 CZ0316 CZ0317 CZ0321 CZ0322 CZ0323 CZ0324 CZ0325 CZ0326 CZ0327 CZ0411 CZ0412 CZ0413 CZ0421 CZ0422 CZ0423 CZ0424 CZ0425 CZ0426 CZ0427 CZ0511 CZ0512 CZ0513 CZ0514 CZ0521 CZ0522 CZ0523 CZ0524 CZ0525 CZ0531 CZ0532 CZ0533 CZ0534 CZ0631 CZ0632 CZ0633 CZ0634 CZ0635 CZ0641 CZ0642 CZ0643 CZ0644 CZ0645 CZ0646 CZ0647 CZ0711 CZ0712 CZ0713 CZ0714 CZ0715 CZ0721 CZ0722 CZ0723 CZ0724 CZ0801 CZ0802 CZ0803 CZ0804 CZ0805 CZ0806 ]>
obce = {}
<~ async.eachLimit nuts, 10, (nut, cb) ->
    (err, data) <~ fs.readFile "../data/vysledky_2010_nuts/#nut.xml"
    data .= toString!
    (err, result) <~ xml.parseString data
    result.VYSLEDKY_OKRES.OBEC?.forEach (obec) ->
        id = obec.$.CIS_OBEC
        strany = []
        obec.HLASY_STRANA.forEach (strana) ->
            id = parseInt strana.$.KSTRANA, 10
            strany[id] = Math.round strana.$.PROC_HLASU
        obce[id] = strany
    cb!

json = JSON.stringify obce .replace /null/g "0"
fs.writeFile "../data/2010_obce.json", json