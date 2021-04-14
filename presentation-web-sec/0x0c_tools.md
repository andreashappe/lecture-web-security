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

## Weitere Backgroundinfos

- [Skript](https://snikt.net/websec)
- [OWASP Web Security Testing Guide](https://github.com/OWASP/wstg/releases/download/v4.2/wstg-v4.2.pdf)

# Tooling

## HTTPS/TLS Konfiguration

- [Qualys SSLTest](https://www.ssllabs.com/ssltest/)
- [testssl.sh](https://testssl.sh/)

## HTTP Header

- [Security Headers](https://securityheaders.com/)
- [Mozilla Observatory](https://observatory.mozilla.org/)

## CSP Test

- [CSP Evaluator](https://csp-evaluator.withgoogle.com/)

## Allgemein: MitM-HTTP-Proxy

- Gut zum nachvollziehen der Kommunikation
- BURP / [ZAP](https://www.zaproxy.org/download/) / mitmproxy

## Database Injections

- [SQLMap.py](http://sqlmap.org/)

~~~ bash
$ sqlmap --level=5 url
$ sqlmap -r file-with-request.txt
~~~

## Port Enumeration

- nmap

~~~ shell
$ nmap -A -p- -oA output_text <url>
~~~

- [Erweiterungsscripts testen](https://github.com/vulnersCom/nmap-vulners)

## Brute-Forcers

- in ZAP und BURP integriert
- online: hydra
- offine: hashcat, john-the-ripper

## Verzeichnisse finden

- [gobuster](https://github.com/OJ/gobuster)
- [snallygaster](https://github.com/hannob/snallygaster)
- [wordlists](https://github.com/danielmiessler/SecLists)
- [fuff](https://github.com/ffuf/ffuf)

## Full Scans

- ZAP hat einen Active Scan
- [w3af](https://w3af.org/) und Nikto
- [Nuclei](https://nuclei.projectdiscovery.io/)
- Rapid7 Metasploit
- Kommerziell: Acunetix, NetSparker

## Feedback

# FIN
