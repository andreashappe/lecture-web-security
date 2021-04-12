---
author: Andreas Happe
title: Web Security
--- 

# Allgemein

## HTTP-Header setzen

- bei der bugbounty durchlesen, ob man bestimmte HTTP Header immer setzen sollte
- diese HTTP Header setzen!

## Erwartungshaltung

- Hardening:
  - TLS, HTTP-Header, CSP falls vorhanden
- Zumindest 2-3 Injection Möglichkeiten getestet (XSS, SQLi, XEE)
- Authentication/Authorization
  - Login erstellen
  - Authentication testen
  - Session testen (fixation, cookie-flags, etc.)
  - Authorization testen

# Tooling

## HTTPS/TLS Konfiguration

- Testen der SSL-Konfiguration
- [Qualys SSLTest](https://www.ssllabs.com/ssltest/)
- [testssl.sh](https://testssl.sh/)

## HTTP Header

- [Security Headers](https://securityheaders.com/)
- [Mozilla Observatory](https://observatory.mozilla.org/)

## CSP Test

- [CSP Evaluator](https://csp-evaluator.withgoogle.com/)

## Allgemein: MitM-HTTP-Proxy

- BURP / ZAP / mitmproxy
- Gut zum nachvollziehen der Kommunikation
- [ZAP](https://www.zaproxy.org/download/)

## Database Injections

- [SQLMap.py](http://sqlmap.org/)

~~~ bash
$ sqlmap --level=5 url
$ sqlmap -r file-with-request.txt
~~~

## Verzeichnisse finden

- [gobuster](https://github.com/OJ/gobuster)
- [wordlists](https://github.com/danielmiessler/SecLists)

## Full Scans

- ZAP hat einen Active Scan
- [w3af](https://w3af.org/)
- [Nuclei](https://nuclei.projectdiscovery.io/)

## Feedback

# FIN
