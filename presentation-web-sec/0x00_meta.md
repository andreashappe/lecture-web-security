---
author: Andreas Happe
title: Web Security
--- 

# Meta-Stuff

# Der Vortragende: Andreas Happe

## Andreas Happe: How To?

* per-Du, per-Sie?
* Erinnerung, falls ich zu leise werde
* Don't trust me, be sceptical
* Gerne auch direkt fragen
* Feedback so früh wie möglich: [andreashappe@snikt.net](mailto:andreashappe@snikt.net)

## When in doubt, ask or tell

> I think there should be more than one voice in a healthy society.

Li Wenliang

12.10.1986-7.2.2020

## Education and Work

|Jahr|Was|Skills|
|--|--|--|
|1996-2001|HTL Villach|Für EDV und Organisation|
|2001-2002|Zivildienst|Access Programmieren..|
|2002-2009|TU Wien|Software Engineering|
|2008-2009|BlackWhale|CTO, RoR|
|2006-2018|AIT|Software Engineering, C, Scala, Java, Kotlin|
|since 2013|CoreTec|Pen-Tester Web/Android/Whatever|
|2016?|Offensive Security|OSCP|
|since 2019|FH/Technikum Wien|Lektor WebSec, SecOps (nicht mehr)|
|since 2020|FH/Technikum Wien|Lektor WebAppSec |

## Other Fun Security Stuff

|Jahr|Was|Skills|
|--|--|--|
|since 2017|ÖNORM|A77.00 Sichere Webapplikationen|
|since 2019|OWASP|Leader Vienna Chapter|
|2018|OWASP|Top Contributer MSTG|
|2019|NATO Locked Shields|Teamlead Linux + Teamlead Web|
|2019|We Are Developers|Sounding Board Security|
|2020|NIS-Richtlinie|Auditor Kritische Infrastruktur|

# But Why?

## Status Quo

- eher mau
- häufig eher einfachere Fehler
- fehlendes Bewusstsein der Grundprobleme
- teilweise peinliches Schweigen bei Besprechungen

## Meine Ziele der Vorlesung

- Awareness schaffen
  - Sicherheitslücken und Gegenmaßnahmen
  - Fähigkeit einen Pen-Test Bericht zu lesen
- Grundlegende/Zeitlose Konzepte
  - Anwendbarkeit für eigene Web-Applikationen

## Why are we doing this?

- The money feels good
- Fehler sind immer etwas peinlich
- Auswirkungen werden katastrophaler

# Die Vorlesung

## Scope der Vorlesung

- builder vs *breaker* vs defender
- Attack first, Defense later
- generell: top-down approach

## Bereiche der Vorlesung

|Einheit|Thema|
|--|--|--|
|1 | Allgemein | Security Principles |
|2 | Allgemein | Web-Applikationen: Komponenten und Architektur |
|3-4 | High-Level | Authentication und Authorization |
|4-6 | Low-Level | Injection Attacks and Hardening|
|7-8 | Unknown | Buffer, CTFs, Praxis |

## Skript

- Skript unter [https://snikt.net/websec](https://snikt.net/websec)
- Knapp 200 Seiten, nicht 100% Deckungsgleich zur Vorlesung
- Papierversion via Amazon falls wer sowas will

# Benotung

## Seminararbeit

- Umfang 15-20 Seiten
- "Penetration-Test" einer Web-Applikation

## Ziel des Penetration-Tests

1. Berufsbegleitend: gibt es eine Homepage des Arbeitgebers?
2. Bug-Bounty Programme (z. B. Stadt Wien über Hacker One)
3. Ich habe im Freundeskreis auch einige "Opfer" ausgemacht
4. Access Points / Router im eigenen Besitz

## Typische Kapitel

- TLS/HTTPS Security (Verbindungssicherheit)
- Verwendete HTTP-Header
- Verwendete Sessionkonfiguration
- Login/Logout Funktion
- Authentication/Authorization
- Injection-Angriffe

## Other Stuff

- Optional: Open-Source Intelligence, darf das andere nicht ersetzen
- Achtung! Social-Engineering ist verboten

## Tooling: Art des Tests

- passiv: wenn keine Permission-to-Attack vorhanden ist
- aktiv: wenn z.B. eine Testinstanz vorhanden ist (bug-bounty)


## Tooling das verwendet werden kann (passiv)

- HTTPS/TLS Checks wie z. B. [Qualys SSLTest](https://www.ssllabs.com/ssltest/)
- HTTP Header checks wie [Observatory](https://observatory.mozilla.org/) oder [SecurityHeaders.io](https://securityheaders.com/)
- passiv Bewertung mittels HTTP Proxy (z. B. Burp, Fiddler, ZAP)
  - "read-only" Analyse der Session (Cookie-Flags)
  - Login/Logout-Verhalen
  - Authentcation-Checks

## Tooling das verwendet werden kann (aktiv)

- Achtung: immer nur nach Bestätigung durch das Opfer (PtA)
- Scanner wie w3af, nikto, etc.
- SQLMap für Datenbank-Injections
- NMAP für Portscans

## Benotung

- Startwert die Punkteanzahl für Note zwischen 2 und 3
- Abzugpunkte für unterlassene Punkte
- Bonuspunkte für besonders gute Ausarbeitungen
- Bei verspäteter Abgabe (bis zu 2 Wochen): Referenzpunkt wandert pro Woche um eine Note

## Vorschläge

- Bereits während der Vorlesung Gedanken machen
- Vorgeschlagene Kapitel der Penetration-Tests
- Fragen/Feedback immer möglich (fair-use)

## Next-Step

- bis nächste Woche klären ob Bedarf an Testseiten vorhanden ist

## Weitere Informationen

- [Skriptum](https://snikt.net/websec)
- [OWASP Top 10](https://owasp.org/www-pdf-archive/OWASP_Top_10-2017_%28en%29.pdf.pdf)
- [OWASP OTGv4](https://www.owasp.org/images/1/19/OTGv4.pdf)
- [Pentester Lab](https://pentesterlab.com/)
  - [Web for Pentester 1](https://pentesterlab.com/exercises/web_for_pentester/course)
  - [Web for Pentester 2](https://pentesterlab.com/exercises/web_for_pentester_II/course)

# Fin
