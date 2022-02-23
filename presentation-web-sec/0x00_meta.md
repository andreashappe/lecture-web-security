---
author: Andreas Happe
title: Web Security
--- 

# Meta-Stuff

# Der Vortragende: Andreas Happe

## Andreas Happe: How To?

* per-Du, per-Sie?
* Erinnerung falls ich zu leise werde
* "If you meet the Buddha on the road, kill him" -- Buddhist monks
* Feedback/Fragen so früh wie möglich: [andreashappe@snikt.net](mailto:andreashappe@snikt.net)

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
|2013-2022|CoreTec|Pen-Tester Web/Android/Whatever|
|since 2021| offensive.one | App-Sec |
|since 2019|FH/Technikum Wien|Lektor WebSec, SecOps (nicht mehr)|
|since 2020|FH/Technikum Wien|Lektor WebAppSec |
|since 2022|PhD/TU Wien | Machine Learning and Security |

## Other Fun Security Stuff

|Jahr|Was|Skills|
|--|--|--|
|2016|Offensive Security|OSCP|
|2017-2020|ÖNORM|A77.00 Sichere Webapplikationen|
|2018|OWASP|Top Contributer MSTG|
|2019|NATO Locked Shields|Teamlead Linux + Teamlead Web|
|2019|We Are Developers|Sounding Board Security|
|since 2019|OWASP|Leader Vienna Chapter|
|since 2020|NIS-Richtlinie|Auditor Kritische Infrastruktur|

# But Why?

## Status Quo

- bad, but gets better
- häufig "eher einfachere" Fehler
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

- generell: top-down approach
- builder vs *breaker* vs defender
- Breaker  -> Defender
- Builder ist dann WebAppSec

## Bereiche der Vorlesung

"Kein Plan überlebt den Feindkontakt."

|Einheit|Thema|
|--|--|--|
|1 | Allgemein | Security Principles |
|2 | Allgemein | Web-Applikationen: Komponenten und Architektur |
|3-4 | High-Level | Authentication und Authorization |
|4-6 | Low-Level | Injection Attacks and Hardening|
|7-8 | Unknown | Buffer |

## Skript

- Skript unter [https://snikt.net/websec](https://snikt.net/websec)
- Knapp 200 Seiten, nicht 100% Deckungsgleich zur Vorlesung
- Papierversion via Amazon falls wer sowas will

# Benotung

## Seminararbeit (90%)

- Umfang der Seminiararbeit 20-25 Seiten
- "Penetration-Test" einer Web-Applikation

## Ziel/Target des Penetration-Tests

1. Berufsbegleitend: gibt es eine Homepage des Arbeitgebers?
2. Bug-Bounty Programme (z. B. Stadt Wien über Hacker One)
3. Ich habe im Freundeskreis auch einige "Opfer" ausgemacht
4. Vulnerable Webseiten VMs (ungern)

## Typische Kapitel

- [Template](https://github.com/andreashappe/lecture-web-security/tree/release/report-template)

- TLS/HTTPS Security (Verbindungssicherheit)
- Verwendete HTTP-Header
- Verwendete Sessionkonfiguration
- Login/Logout Funktion
- Authentication/Authorization
- Injection-Angriffe

## Other Stuff

- Permission-to-Attack (PtA) wurde von der CoreTec bereitgestellt
- Optional: Open-Source Intelligence, darf das andere nicht ersetzen
- Achtung! Social-Engineering ist verboten

## Art des Tests

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

- Startwert die Punkteanzahl für Note ist ein knapper 2er
- Abzugpunkte für unterlassene Punkte
- Bonuspunkte für besonders gute Ausarbeitungen
- Bei verspäteter Abgabe (bis zu 2 Wochen): Referenzpunkt wandert pro Woche um eine Note

## Erfahrungswerte

- Bereits während der Vorlesung Gedanken machen
- Vorgeschlagene Kapitel der Penetration-Tests
- Fragen/Feedback immer möglich (fair-use)

## Review (10%)

- Review einer anderen Studentenarbeit
- Dient dazu, dass der Pen-Test mehr Feedback bekommt
- die 10% sind für das Review, nicht die gereviewte Arbeit

## Zeitplan

- Termin für initiale Abgabe (per moodle)
- Termin für Abgabe des Reviews (1-2 Wochen später)
- Überarbeiten der Seminararbeit und finale Abgabe (eine Woche später)
- nicht zu knapp vor Semesterende, damit ich auch noch Feedback geben kann
- Vorschläge bis nächste Woche, sonst werden die Termine relativ random von mir bestimmt

## Next-Steps

- bis nächste Woche klären ob Bedarf an Testseiten vorhanden ist
- Vorschläge für einen Zeitplan

## Weitere Informationen

- [Skriptum](https://snikt.net/websec)
- [PortSwigger Academy](https://portswigger.net/web-security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP OTGv4](https://www.owasp.org/images/1/19/OTGv4.pdf)

# Fin
