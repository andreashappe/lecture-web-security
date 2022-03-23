---
author: Andreas Happe
title: Web Security
--- 

# Authentication & Authorization

## Basic Idea

* Überprüfung der Benutzerberechtigung
* Zugriffskontrolle = Authentication + Authorization

## Simple Facts

* muss vor der Operation ausgeführt werden
* muss immer serverseitig implementiert werden
* zum Zeitpunkt des Zugriffs

## Authentication / Authorization

* Fehlende Authentication ist problematischer als fehlende Authorization.
* kein Auditing / Log-Trail
* Verhalten im Angriffsfall?

# Problem: Fehlende serverseitige Überprüfung

## Grundproblem

* Zugriffsrechte werden nur am Client überprüft
* es wird davon ausgegangen, dass die dahinterliegenden Server-Operationen nicht auffindbar sind (Security by Obscurity)

## Beispiel: Rich-Client Apps im Browser

* häufig: Java Applets, Flash, Silverlight

![](./0x06_silverlight.png)

## Forceful Browsing

* Abhängig von der Userrolle werden unterschiedliche Bereiche angezeigt
* Operationen im Hintergrund überprüfen keine Authorization
* Beispiel: Direktzugriff auf /admin

## Beispiel: Direct-Object References

* links mit erratbaren Ids ohne Zugriffscheck
* z.B. /invoice/420 oder /user/1
* Aktuelles Bespiel: [Corona Schnelltests](https://www.heise.de/news/Corona-Selbsttests-bei-Aldi-Negativ-Zertifikate-von-Aesku-faktisch-wertlos-5987246.html)

Also immer Authentication und Authorization testen!

## Gegenbeispiel: Usability

* ÖBB Tickets
* Download des Tickets ohne Authentication
* Ticket-Id/Download-Id ist zufällig gewählt

# Problem: Fehlende Konsistenz

## Nicht-homogene Applikationen

* Authentication/Authorization ist häufig Teil des verwendeten Frameworks
* Problem bei gewachsenen Applikationen:
  * mehrere Programmiersprachen/Frameworks, teilweise auch Portale
  * Brennpunkt: Plattformübergreifende Integration der Authentication
* Hint: Session wird häufig als GET-Parameter übergeben

## Selbst-geschriebene Komponenten

* Applikation verwendet ein Framework, aber einzelne Komponenten wurden selbst geschrieben
* Betrifft häufig nachträgliche Erweiterungen
* Problem: Bei den selbst-geschriebenen Komponenten wird gerne die Authentication vergessen

## Beispiele:

Beispiel: Aktiendepot einer Bank

``` url
/piechart?user=username
```

Beispiel: Dokumenten-Export

```url
/documents/download/1
/documents/1.pdf
```

# Problem: Welche Felder werden überprüft?

## Beispiel: Update Operation

```http
POST /user/42/update HTTP 1/1

{ “id”: “42”, “name”: “happe”}
```

## Beispiel: Potentielle Probleme

* Zugriff auf /user/1/update?
* Austausch von ID im Datensatz?
* HTTP GET oder PATCH statt POST?
* Zusätzliches Feld “admin”: “1” im Datensatz?

# Problem: Mass Assignments

## Mass-Assignment als Automatisierung

Parameter werden automatisch zugeordnet

Request:

``` http
POST /user/1/update HTTP/1.1

user[name]=happe&user[email]=ah@mybloodtypeis.coffee
```

Source Code:

``` ruby
@user = User.find(params[:id])
@user.update(params[:user])
```

## Probleme bei Mass Assignments

Angreifer:

``` 
user[id]=1&user[name]=happe&user[role]=admin
```

## Mass Assignments: Lösung

Lösung: dezidiert zum Update erlaubte Felder definieren

``` ruby
@user.update(user_params)

def user_params
  params.require(:user).permit(:name)
end
```

# Nachtrag

## Seminararbeit

- Bitte alle die bis jetzt keine Seite haben und als bug-bounty die Stadt Wien testen wollen bis Montag einen hackerone-Account anlegen und mir mitteilen

## Story so far

- Login
- Session
- Authentication / Authorization

# Problem: CSRF-Angriffe

## CSRF-Angriffe

* Nutzen ein bestehendes Vertrauensverhältnis zwischen (Opfer) Web-Browser und einem Webserver aus
* Grundproblem: Browser verschickt automatisch Session-Cookies beim Zugriff auf entfernte Server
* Durch ein verstecktes Formular auf einer fremden Webseite wird eine Operation mit den Rechten des Opfers auf einer anderen Webseite ausgeführt

## Flow

![Picture](0x06_csrf.png){.stretch}

## Gegenmaßname: Synchronizer Token

* Server setzt (zufälliges) Token bei jedem Formular und vergleicht ob dieses mit dem serverseitigen Token übereinstimmt
* Token sollte regelmässig neu generiert werden
* Was passiert wenn kein CSRF-Token Feld mit übergeben wird?

## Gegenmaßnahme: SameSite-Flag

* Same-Site Flag bei Cookies
* Strict: Cookie wird nie Cross-Site übertragen
* Lax: Nur Cross-Site wenn Navigation
* Default ab Chrome 80

## Achtung: Site != Origin

* Site: eTld+1
* Origin: Schema + Domainname + Port

| | Origin | Site |
|-|--------|-------|
| https://a.snikt.net | https://a.snikt.net:443 | snikt.net |
| https://b.snikt.net | https://b.snikt.net:443 | snikt.net |
| https://a.tw.ac.at | https://a.tw.ac.at:443 | tw.ac.at |
| https://b.tw.ac.at | https://b.tw.ac.at:443 | tw.ac.at |
| a.github.io        | https://a.github.io:443 | a.github.io |

# Problem: Authorization in Alternate Channels

## Grundproblem

Die Zugriffsrechte müssen zwischen diesen gesamten Schnittstellen abgeglichen werden.

Beispiel:

* eine Webseite inkl. REST-API
* als WebServices für mobile Clients
* WebSocket-Schnittstelle

## WebSockets

- bidirektionale Kommunikationskanäle
- analog zu einem TCP-Socket
- werden durch den Browser geöffnet
- Bedienung über JavaScript

## Authentication bei WebSockets

* Immer das wss Protokoll verwenden
* Nicht Websockets zum Tunneln verwenden, sondern Message-Based Protokoll darüber aufspannen
* Authorization und Authentication pro Nachricht kontrollieren
* Implicit Authentication (Cookie oder HTTP BASIC) beim Öffnen des Socket

## Problem: Session?

- HTTP Header während Erstellung sind bekannt
- Logout?
- verzögertes Login?
- Rechte ändern sich nach Login?

## aktuelle Session-ID übertragen

- duplizierte Session-Datenbank am Server
- pro Nachricht?
- wo wird die Session-Id gespeichert (Cookies?)

## Am Besten an Frameworks auslagern

# FIN
