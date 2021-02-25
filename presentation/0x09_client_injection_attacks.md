---
author: Andreas Happe
title: Web Application Security
--- 

# Client-Side Attacks

## Angriffe gegen den Browser

* häufig als Teil von Social Engingeering
* Water-Hole Attacks

## Grundsätzlich: Gegenmassnahme

* Server teilen dem Browser erwartetes Verhalten mit
* HTTP-Header wie Cookie-Header oder HSTS
* HTML-Directives

## Redux: Cookie Header

``` http
Set-Cookies: cookie=wert; Path=/app; Secure; HttpOnly; SameSite=Lax;
```

* Secure, HttpOnly und SameSite=Lax verwenden
* Path verwenden, vor allem wenn mehrere Applikationen am Server

* Ohne Expires/Max-Age: Session-Cookie wird beim Schließen des Browsers gelöscht
* Ohne Domain: nur aktuelle Domain gültig, wird mit Domain= eine Domain angegeben werden subdomains automatisch inkludiert

# Javascript-Injectons (XSS)

## Grundproblem

* Angreifer findet einen Weg um Javascript innerhalb der Webseite zu platzieren
* Angriff wird im Browser des Opfers durchgeführt, wenn dieser die Webseite betrachtet
* Drei grobe Arten: reflected, persistend, DOM-based XSS

## Reflected XSS

![Picture](0x08_reflexted_xss.png){.stretch}

* Javascript wird vom Webserver zurückreflektiert
* non-persistent
* meistens ist eine soziale Komponente notwendig
* http://opfer.xyz/operation?parameter=alert(1);

## Stored/Persistent XSS

Javascript wird am Server gespeichert

Z.b. folgendes als Chat-Nachricht:
``` html
<script>alert(1);</script>
```

## DOM-based XSS

* DOM-based
* Durch Modifikation/Injecten des Schadcodes im DOM
* Server ist nicht direkt involviert

## Beispiel

http://www.some.site/page.html?default=French

``` html
<select><script>
document.write("<OPTION value=1>"+document.location.href.substring(document.location.href.indexOf("default=")+8)+"</OPTION>");
document.write("<OPTION value=2>English</OPTION>");
</script></select>
```

``` url
http://www.some.site/page.html?default=<script>alert(document.cookie)</script>
```

## uXSS

Angriffe gegen den Browser..

## mXSS

Browser modifizieren übertragenen Code und "erzeugen" auf diese Weise XSS-verseuchte Webseiten

* z.B. bei Verwendung von X-XSS-Protection

## XSS kann an vielen Stellen auftreten

```html
<script>alert(1);</script>
<SCRIPT SRC=http://xss.rocks/xss.js></SCRIPT>

<IMG SRC=JaVaScRiPt:alert('XSS')>
<IMG SRC=`javascript:alert("RSnake says, 'XSS'")`>

<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>

<IMG SRC= onmouseover="alert('xxs')">
<IMG SRC="jav    ascript:alert('XSS');">
<BGSOUND SRC="javascript:alert('XSS');">
<IMG STYLE="xss:expr/*XSS*/ession(alert('XSS'))">
```

## Payloads

* Session Stealing
* Virtual Defacement
* Crypto-Mining
* DoS-Angriffe

## Gegenmaßnahme: Input Filtering/Sanitation

* werden Daten eingegeben, müssen diese auf Schadmuster hin überprüft werden
* Ist nur sinnvoll mit gemaintainten Bibliotheken durchführbar
* Hardening: Web Application Firewalls (Problem: False-Positives)

## Gegenmaßnahme: Quoting

* werden user-generierte Daten ausgegeben, müssen diese encoded werden
* “nicht so einfach..”: verschiedene scopes
* [XSS Prevention Cheat Sheet](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.md)

## DOM-based XSS

* Context ist wichtig, folgendes Code-Fragment am Server
* taintedVar muss sowohl js- als auch html-encoded sein

``` html
<script>
 var x = '<%= taintedVar %>';
 var d = document.createElement('div');
   d.innerHTML = x;
   document.body.appendChild(d);
</script>
```

## Gegenmassnahme Quoting

* HTML-Renderer vermeiden
  * element.write
  * element.writeln
  + innerHTML
  * outerHTML
* Bei gewissen Funktionen double-quoting verwenden
* Achtung bei on* Handlern und Quoting
* [Weiterführende Hints](https://www.owasp.org/images/0/07/Xenotix_XSS_Protection_CheatSheet_For_Developers.pdf)

## Hardening: CSP

Good:

```
script-src 'self' cdnjs.cloudflare.com;
```

Bad:

```
script-src 'self' 'unsafe-inline' 'unsafe-eval'
```

## Polyglot Files

* Dateien die gleichzeitig zwei Dateitypen erfüllen
* Können CSP aushebeln

## Zusammenfassung

![Zusammenfassung](0x08_xss_summary.png){.stretch}

## Zum Abschluss

![Picture](0x04_owasp_top_10.png){.stretch}

# Unverified Redirects and Forwards

## Basics

* Redirect Target wird über eine Benutzereingabe kontrolliert
* http://example.com/example.php?url=http://malicious.com
* Besonders gefährlich, wenn die übergebene Seite mittels iframe eingebunden wird
* Gegenmaßnahme: Whitelist verwenden

# Reverse Tab-Nabbing

## GrundIdee

Wird ein externer Link in einem neuen Browserfenster/tab aufgemacht, kann die aufgemachte Seite die Location der aufmachenden Seite ändern.

## Aufmachende Seite

``` html
<html>
 <body>
   <li><a href="bad-website.com" target="_blank">Vulnerable target using html link to open the new page</a></li>
     <button onclick="window.open('https://bad-website.com')">Vulnerable target using javascript to open the new page</button>
  </body>
</html>
```

## Angriff: aufgemachte Seite

``` html
<html>
 <body>
   <script>
      if (window.opener) {
            window.opener.location = 'https://phish.example.com';
      }
   </script>
 </body>
</html>
```

## Gegenmaßnahmen

* keine externen Webseiten verlinken
* rel=”noopener noreferrer” bei Link verwenden

``` html
<a href="bad-website.com" rel="noopener noreferrer" target="_blank">Vulnerable target using html link to open the new page</a>
</html>
```

* Referrer-Policy setzen (no-referrer)

## Referrer-Policy

* Kontrolliert den Referer-Header des Browsers
* Referer vs Referrer

## Mögliche Einstellungen

| Wert | Beschreibung |
|------|--------------|
| no-referrer| Referer Header wird nie gesetzt | 
| no-referrer-when-downgrade | default, no https->http |
| origin| nur origin wird gesendet |
| origin-when-cross-origin | |
| same-origin | referrer nur wenn same-origin |
| strict-origin | only set origin, no https->http |
| strict-origin-when-cross-origin | |
| unsafe-url | Referrer immer gesetzt |

# Clickjacking

## Angriff

![Picture](0x09_clickjacking.jpg){.stretch}

## Gegenmassnahme: X-Frame-Options

* Mögliche Werte:
  * DENY
  * SAMEORIGIN
  * ALLOW-FROM $origin
  * ALLOWALL (non-standard)

## Not-Perfect

* Probleme bei double-framing
* Mehrere Origins können nicht angegeben werden
* Handhabung wenn X-Frame-Options Header [mehrfach vorkommt](https://blog.qualys.com/securitylabs/2015/10/20/clickjacking-a-common-implementation-mistake-that-can-put-your-websites-in-danger)
* CSP verbessert den Schutz

# Reflected-XSS Schutz

## Reflected-XSS Schutz (X-XSS-Protection)

* Aktiviert die XSS Protection des Browsers
* Werte:
  * 0: disabled
  * 1: enabled, input wird sanitized
  * 1; mode=block: enabled, die page wird nicht gerendert
* Anti-XSS Heuristic wird nur noch von IE unterstützt..

# SOP/CORS

## Cross-Origin Resource Sharing (CORS)

Aufweichen der SOP

Beispiel: Browser lädt eine Webseite (web.snikt.net), diese will mittels Javascript auf service.snikt.net zugreifen

## Simple Case: Request

* Browser befindet sich auf web.snikt.net
* Will auf service.snikt.net zugreifen
* Setzt dafür den Origin Header beim JS-Zugriff auf service.snikt.net

``` http
Origin: web.snikt.net
```

## Simple Case: Response

Das Antwortdokument des Services beinhaltet einen zusätzlichen Header der anzeigt, wer diese Operation aufrufen darf:

``` http
Access-Control-Allow-Origin: https://web.snikt.net
```

* Browser weiss nun, dass er diese Daten verarbeiten darf
* Da dies eine "safe" Operation ist, kann am service-Service nichts geschehen
* Bitte nicht: Access-Control-Allow-Origin: *

## Was bei Daten-Verändernden Operationen?

* Preflight-Authorisation
* Browser sendet HTTP OPTIONS zum Service
* Origin-Header wird wieder auf web.snikt.net gesetzt
* Beispielsantwort

``` http
Access-Control-Allow-Origin: https://web.snikt.net
Access-Control-Allow-Methods: PUT, DELETE
```

* Danach sendet der Browser erst den Daten-verändernden Request

## Zusammengefasst

![Picture](0x09_cors.png){.stretch}

# Content-Security-Policy

## Historische Entwicklung

* SOP schützt nicht vor bösartigem JavaScript-Code auf dem eigenen Server
* CSP: limitiert wo JavaScript-Code vorkommen darf
* Mittlerweile umfasst CSP weitaus mehr als nur XSS-Protection
* Wird weiterentwicklet, Problem [Verfügbarkeit](https://caniuse.com/#search=csp)

## Allgemein

* Content Security Policy
* Sehr mächtiges Framework um Browsern Policies zu übermitteln
* Entweder als HTML-Tag oder HTTP-Header
* Grundidee: Trennung von JavaScript und HTML

## Trennung von JavaScript und HTML

Nach Aktivierung von CSP ist JavaScript nur in getrennten JavaScript-Dateien erlaubt:

``` html
<script src="externalfile.js"></script>
```

Wie können Events gebunden werden:

``` javascript
$(document).ready(function()  {
  document.getElementById("btn").addEventListener('click', doSomething);     
});
```

## CSP: Feature Creep

## CSP: Was darf eingebunden werden?

| Direktive | Einsatzbereich |
|-----------|------------------|
| script-src| wo darf Javascript vorkommen?|
| object-src| von wo dürfen plugins geladen werden?|
| img-src, media-src, font-src, style-src|
| frame-src, frame-ancestor, child-src| von wo aus darf eine Seite als iframe inkludiert werden?|
| connect-src| JSONP, WebSockets, etc.|
| default-src| default policy für die meisten Elemente|

## CSP: Beispiel script-src <source>

| Direktive | Einsatzbereich |
|-----------|------------------|
| host| z.b. snikt.net|
| scheme-source| z.B.: https://|
| ‘self’| eigene Webseite|
| ‘none’||
| ‘unsafe-inline’| just don't |
| ‘unsafe-eval’| erlaut Eval, für z.B. setTimeout notwendig|
| ‘nonce’-base64(nonce)||
| 'hash-alg-base64(hash)' | Berechnung eines Hashes über alle JS|
| 'strict-dynamic' | hash-alg und nonce dürfen weiter Scripts laden|


## CSP: Steuerung vom Browser

| Direktive | Einsatzbereich |
|-----------|------------------|
| form-action| welche URIs dürfen als Ziel eines formulars dienen|
| sandbox| kontrolliert embedded iframes|
| plugin-types| welche plugins werden erlaubt|
| reflected-xss| entspricht X-XSS-Protection|
| referrer| ähnlich wie Referrer-Policy|
| report-uri| report Browser Violations to server|
| block-all-mixed-content| disallow mixed content |
| upgrade-insecure-requests| convert http into https requests |

## CSP: Beispiele

``` http
Content-Security-Policy: script-src 'self' www.google-analytics.com ajax.googleapis.com;
```

``` http
Content-Security-Policy: script-src 'self'; style-src *
```

``` http
Content-Security-Policy: default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self';
```

## CSP: Beispiel Nonce

``` http
Content-Security-Policy: script-src 'nonce-2726c7f26c'
``` 

``` html
<script nonce="2726c7f26c">
  var inline = 1;
</script>
``` 

## Hinweise zu nonce:

* nonce muss natürlich dynamisch generiert werden!
* Angreifer darf keine Eingabemöglichkeit in die Skript-Tags besitzen
* Einsatz wird von Google empfohlen

# HTML-Directives

## IFrame-Option: sandbox

* all forms and scripts are disabled
* all links are not allowed to target other browser contexts
* all plugins are disabled
* all features that trigger automatically are disabled

## Subresource Integrity

* Dient um indirekte Angriffe z. B. über CDNs abzuwehren
* Hash-Summe wird bei script/css includes angegeben,
* Verwendung kann mittels CSP enforced werden

```html
<script src="https://example.com/example-framework.js"
      integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC"></script>
```

## SRI: Probleme

* nicht transitiv
* dynamische Inhalte wie Google Fonts
* keine "gratis" Updates von Libraries


# HTML5 Stuff

## WebStorage

* niemals sensitive Informationen speichern
* SessionStorage vs. LocalStorage
* Verwundbar gegenüber XSS (verglichen mit Cookies)
  * es gibt kein httpOnly
  * man kann es nicht auf sub-Pfade limitieren

## WebWorkers

* Achtung wenn User-Eingaben verwendet werden
* können XMLHttpRequests abschicken, aber getrennter Origin
* CPU DoS!

## WebAsm

* Potential für Bitcoin-Miners
* Potential für Obfuscation

## WebRTC

* Peer-to-Peer Communication
* Access to Camera/Mic through Browser Controls
* Eher Privacy Impact

## WebBluetooth

* Browser soll mit verbundenen Bluetooth LE devices Daten austauschen können.
* Webseite kann nicht nach devices suchen
* JS requested device, Browser übernimmt das Pairing
* Effektiv sehr vergleichbar mit Security Model mobiler Applikationen

## WebBluetooh: Privacy Impact

* Only possible from Secure Context (HTTPS)
* Eher Privacy Impact
  * "rssi", "txPower"

# FIN
