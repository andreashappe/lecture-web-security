---
author: Andreas Happe
title: Wohlgeformte APIs
--- 

## Agenda

- Review HTTP
- JavaScript: SOP/CORS
- CRUD und REST
- OAuth2
- JWT

# HTTP

## HTTP - Geschichte

|Jahr|Version|Bemerkung|
|----|-------|---------|
|1989| -     | CERN    |
|1991| HTTP/0.9 |      |
|1997| HTTP/1.1 |      |
|2015| HTTP/2 | SPDY, semi-TLSv1.3, ~66% |
|2018| HTTP/3 | HTTP-over-QUIC, UDP |

## HTTP Request

```
GET / HTTP/1.1
Host: www.example.com
User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
```

## HTTP Verben

|Verb|Verwendung|Safe|Idempotent|
|---|-------|----|------|
|GET|Abfrage von Informationen | x | x |
|HEAD| Abfrage von Meta-Informationen | x | x |
|OPTIONS | Abfrage von Meta-Informationen | x | x |
|PUT | Neues Objekt hochladen | | x |
|DELETE | Löschen eines Objektes | | x |
|POST | Erstellen von Objekten | | |
|PATCH| Updaten eines Objektes | | |

## HTTP Response

```http
HTTP/1.1 200 OK
Date: Mon, 23 May 2005 22:38:34 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 138
Last-Modified: Wed, 08 Jan 2003 23:11:55 GMT
Server: Apache/1.3.3.7 (Unix) (Red-Hat/Linux)
ETag: "3f80f-1b6-3e1cb03b"
Accept-Ranges: bytes
Connection: close

<html>
 <head><title>Wohoo!</title></head>
 <body><p>Hello World!!!1</p></body>
</html>
```

## HTTP Statuscode

|Statuscode|Verwendung|
|---|-------|
| 1xx | Information (continue, protocol switch) |
| 2xx | Erfolgreich |
| 3xx | Umleitungen |
| 4xx | Client-Fehler (inkl.Authentication) |
| 5xx | Server-Fehler |

# Javascript: SOP/CORS

## SOP

- Same-Origin Policy für Javascript
- Origin: Schema+FQDN+Port
- Javascript darf nur auf Resourcen mit der gleichen Origin zugreifen (wie die Origin, in welcher das JavaScript aufgerufen wurde)

## Cross-Origin Resource Sharing (CORS)

Aufweichen der SOP

Beispiel: Browser lädt eine Webseite (web.snikt.net), diese will mittels Javascript auf service.snikt.net zugreifen

## Simple Case: Read-Request

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

# CRUD und REST

## CRUD - Operationen

- Typische Operationen die man für die Verwaltung für Resourcen benötigt
- Create, Read, Update, Delete

## REST

- Representational State Transfer
- Alles sind Resourcen
- Zugriff über Standard-HTTP Methoden auf Resourcen
- [REST Maturity Levels](https://martinfowler.com/articles/richardsonMaturityModel.html#level2), Ziel: Level 2

## RESTful CRUD-Functionality

|URL|Method|Operation|
|---|------|---------|
|/notes/|GET|list notes|
|/notes/|POST|create note|
|/notes/123|GET|show note|
|/notes/123|DELETE|remove note|
|/notes/123|PUT|update note|

## Zalando API Guidelines

- [Zalando API-Guidelines](https://opensource.zalando.com/restful-api-guidelines/)

## API First

- Zuerst das API definieren
- Danach erst implementieren

## Grundlegend

- Bei REST geht um Resourcen
- Verwendung der korrekten HTTP Verben und Status-Codes
- OpenAPI/Swagger-Definitionen bereitstellen

## Typen von Resourcen

- es gibt collection und singuläre Resourcen
  - Collection z.B. /users/123
  - Singular z.B. /current-user

## URLs

- Identifier müssen ,,stable'' sein
  - z.B. /users/42 liefert immer den gleichen User
- Benamung
  - ebab-case für Pfade (alles Kleinbuchstaben)
	- snake_case für Parameter

## Kein Actions in der URL

- nicht "POST /users/login" sondern "POST /sessions/"
- URL sollten "verb-free" sein

## Datenformate

- use JSON
- im Fehlerfall: [problem JSON](https://opensource.zalando.com/restful-api-guidelines/#176)

# OAuth2

## Beteiligte Parteien

|Partei|Rolle|
|------|-----|
| Resource Owner | kann Berechtigungen authorisieren |
| Resource Server | speichert Daten im Auftrag eines Resource Owners |
| Client  | will auf die Daten eines Resource Owners am Server zugreifen |
| Authorization Server | erstellt die Zugriffsberichtigung |

## OAuth2: Authorization Grant Request

* Scope der Authorization
  * read/write
  * github: include private repositories
  * dropbox: grants auf folder Ebene

## OAuth2: token-basiertes Zugriffssystem

* User-Identität ist eigentlich egal..
* Keine dezidierte Logout Operation

## OAuth2: verschiedene Flows

![Picture](0x07_oauth2.png){.stretch}

## OpenID-Connect

* Implementierung einer Authentication auf Basis von OAUTH2
* Verschiedene Flows
* Typischerweise sind zwei Endpunkte definiert (Token, User-Daten)

# JSON Web Tokens

## Grundsätzlich

* Token Format, RFC 7519
* Dienen zur Übertragung von Permissions
* Übertragung per
  * HTTP Parameter: please don’t
  * Cookie: sameSite, httpOnly, Secure-Flags setzen
  * HTTP Header als bearer token

## Grundaufbau

![Picture](0x07_jwt.jpeg){.stretch}

## Grundaufbau

![Picture](0x07_jwt_token.png){.stretch}

## JSON Web Tokens

* Header
  * alg: Verwendeter Algorithmus
  * typ: “JWT”

* Beispiele für Content
  * iss: issuer
  * sub: subject
  * aud: audience
  * exp und nbf, iat: Laufzeiten
  * jti: json token id

## Problem: Header

* Header nicht Integritätsgesichert
* Beispiel: NULL alg
* Beispiel: HS vs RS confusion

## MAC/PubKey Confusion

Entwickler verwendet eine Bibliothek, mit folgender Überprüfungsfunktion:

```
validate(token, key)

# validate checkt den token-alg
# und verwendet entweder MAC oder Signature
# key: public-key bei Signature
# key: shared-secret-key bei MAC
```

Entwickler geht davon aus, dass fix eine Siganture verwendet wird:

```
validate(token, public-key)
```

## MAC/PubKey Confusion

Der Angreifer nimmt den public key und verwendet ihn um einen MAC-based token zu erstellen, setzt den Algorithmus auf MAC

```
token(alg: mac, content, mac(public-key, content))
```

der Anwendungscode am Server erwartet eigentlich public-keys und ruft folgendes auf:

```
  validate(mac-token, public-key)
```

## Resultat

die Bibliothek glaubt aufgrund des Tokens (alg) dass ein MAC gebaut werden sollte und berechnet mac(public-key, content).. und akzeptiert deswegen das übergebene Token!

Immer Algorithmus am Server prüfen und fixieren

## Problem: Key-for-Signing is constant

- offline-cracking
