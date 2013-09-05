require! {
    fs
    request
    async
    iconv.Iconv
}
nuts = <[ CZ0100 CZ0201 CZ0202 CZ0203 CZ0204 CZ0205 CZ0206 CZ0207 CZ0208 CZ0209 CZ020A CZ020B CZ020C CZ0311 CZ0312 CZ0313 CZ0314 CZ0315 CZ0316 CZ0317 CZ0321 CZ0322 CZ0323 CZ0324 CZ0325 CZ0326 CZ0327 CZ0411 CZ0412 CZ0413 CZ0421 CZ0422 CZ0423 CZ0424 CZ0425 CZ0426 CZ0427 CZ0511 CZ0512 CZ0513 CZ0514 CZ0521 CZ0522 CZ0523 CZ0524 CZ0525 CZ0531 CZ0532 CZ0533 CZ0534 CZ0631 CZ0632 CZ0633 CZ0634 CZ0635 CZ0641 CZ0642 CZ0643 CZ0644 CZ0645 CZ0646 CZ0647 CZ0711 CZ0712 CZ0713 CZ0714 CZ0715 CZ0721 CZ0722 CZ0723 CZ0724 CZ0801 CZ0802 CZ0803 CZ0804 CZ0805 CZ0806 ]>
#    ..length = 1
iconv = new Iconv \iso8859-2 \utf-8
cntr = 0
len = nuts.length
year = 2010
<~ async.eachSeries nuts, (nut, cb) ->
    (err, response, body) <~ request do
        uri: "http://www.volby.cz/pls/ps#year/vysledky_okres?nuts=#nut"
        encoding: null
    body = iconv.convert body
    console.log "Loaded #nut - #{++cntr} / #len"
    cb!
    fs.writeFile "../data/vysledky_#year_nuts/#nut.xml", body
    console.log "Saved #nut"

# krajska mesta - praha, brno, ostrava, plzen
(err, response, body) <~ request do
    uri: "http://www.volby.cz/pls/ps#year/vysledky_krajmesta"
    encoding: null
body = iconv.convert body
fs.writeFile "../data/vysledky_#year_nuts/krajmesta.xml", body
