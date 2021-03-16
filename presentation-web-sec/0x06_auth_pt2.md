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

## Zusätzliche Probleme bei fehlender Authentication

* kein Auditing / Log-Trail
* kein Login-Zwang
* große Gefährdung durch Crawler, etc.
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

## Scoping von Daten

Innerhalb der Applikation läuft die Applikationslogik immer im Auftrag eines Benutzers

Die bearbeitenden Daten sollten so früh wie möglich auf den aktuellen Benutzer gebunden werden

## Scoping von Daten

```
GET /invoices/42
```

Negativ:
``` ruby
Invoices.all.find(id)
# select * from invoices where id = :id;
```

Positiv:

``` ruby
current_user.invoices.find(id)
# select * from invoices where user_id = :current_user.id and id = :id
```

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

## Gegenmaßnahme: sameSite-Flag

* Same-Site Flag bei Cookies
* Strict: Cookie wird nie Cross-Site übertragen
* Lax: Nur Cross-Site wenn Navigation
* Default ab Chrome 80
* Achtung: Site != Origin

# Problem: Authorization in Alternate Channels

## Grundproblem

Die Zugriffsrechte müssen zwischen diesen gesamten Schnittstellen abgeglichen werden.

Beispiel:

* eine Webseite
* als WebServices für mobile Clients
* eine REST-API
* WebSocket-Schnittstelle

## Authentication bei WebSockets

* Immer das wss Protokoll verwenden
* Nicht Websockets zum Tunneln verwenden, sondern Message-Based Protokoll darüber aufspannen
* Implicit Authentication (Cookie oder HTTP BASIC) beim Öffnen des Socket
* Authorization und Authentication pro Nachricht kontrollieren

## Problem: Was ist, wenn der Login erst später passiert?

* Duplicate Authentication
* quasi: duplizierte Session-Struktur
* Logout beachten

# FIN
