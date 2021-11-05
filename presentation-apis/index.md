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

## Basics

- Client-Server basiertes Protokoll
  - Client ist zumeist ein Browser
  - Requests gehen vom Client aus
- Ursprünglich zeilen-basiert (http/1.1)
  - seit HTTP/2: eher key-value

## HTTP - Geschichte

|Jahr|Version|Bemerkung|
|----|-------|---------|
|1989| -     | CERN    |
|1991| HTTP/0.9 |      |
|1997| HTTP/1.1 |      |
|2015| HTTP/2 | SPDY, semi-TLSv1.3, ~66% |
|2018| HTTP/3 | HTTP-over-QUIC, UDP |

## HTTP Request

- wenige Pflicht-Elemente
- Header sind großteils optional

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

## Why HEAD?

~~~ http
HTTP/1.1 200
x-amz-delete-marker: DeleteMarker
accept-ranges: AcceptRanges
x-amz-expiration: Expiration
x-amz-restore: Restore
x-amz-archive-status: ArchiveStatus
Last-Modified: LastModified
Content-Length: ContentLength
ETag: ETag
x-amz-missing-meta: MissingMeta
x-amz-version-id: VersionId
Cache-Control: CacheControl
Content-Disposition: ContentDisposition
Content-Encoding: ContentEncoding
Content-Language: ContentLanguage
Content-Type: ContentType
Expires: Expires
x-amz-website-redirect-location: WebsiteRedirectLocation
x-amz-server-side-encryption: ServerSideEncryption
x-amz-server-side-encryption-customer-algorithm: SSECustomerAlgorithm
x-amz-server-side-encryption-customer-key-MD5: SSECustomerKeyMD5
x-amz-server-side-encryption-aws-kms-key-id: SSEKMSKeyId
x-amz-server-side-encryption-bucket-key-enabled: BucketKeyEnabled
x-amz-storage-class: StorageClass
x-amz-request-charged: RequestCharged
x-amz-replication-status: ReplicationStatus
x-amz-mp-parts-count: PartsCount
x-amz-object-lock-mode: ObjectLockMode
x-amz-object-lock-retain-until-date: ObjectLockRetainUntilDate
x-amz-object-lock-legal-hold: ObjectLockLegalHoldStatus
~~~

## HTTP Response

- Antwort vom Server zum Client

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

## Typische Antwortcodes (1/2)

|Statuscode|Verwendung|
|---|-------|
| 200 | OK, Antwort im Body |
| 201 | Created, Antwort im Body, URL als Location-Header |
| 204 | No Content (aber Header) |
| 301 | Moved Permanently |
| 302 | Found (temporäre neue URL) |
| 303 | See Other, e.g., für Status-Page nach POST |

## Typische Antwortcodes (1/2)

|Statuscode|Verwendung|
|---|-------|
| 400 | Bad Request (ungültige Syntax) |
| 401 | Unauthorized (Authentication notwendig) |
| 403 | Forbidden (Authorization notwendig) |
| 404 | Not found |
| 405 | Method nod allowed |
| 429 | Too Many Requests (Rate-Limit) |
| 500 | Internal Server Error |
| 501 | Not Implemented (Method) |
| 502/504 | Bad Gateway |
| 503 | Service Unavailable |

# Javascript: SOP/CORS

## Same-Origin Policy

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
GET /some-operation HTTP/1.1
Origin: web.snikt.net
```

## Simple Case: Response

Das Antwortdokument des Services beinhaltet einen zusätzlichen Header der anzeigt, wer diese Operation aufrufen darf:

``` http
HTTP/1.1 200 OK
..
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
Access-Control-Allow-Methods: POST, PUT, DELETE
```

* Danach sendet der Browser erst den Daten-verändernden Request

## Zusammengefasst

![Picture](0x09_cors.png){.stretch}

# CRUD und REST

## CRUD - Operationen

- Typische Operationen die man für die Verwaltung von Resourcen benötigt
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
  - kebab-case für Pfade (alles Kleinbuchstaben)
	- snake_case für Parameter

## Kein Actions in der URL

- nicht "POST /users/login" sondern "POST /sessions/"
- URL sollten "verb-free" sein

## Datenformate

- use JSON
  - Standardisierte Zeitformate, etc.
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

## Problem: Key-for-Signing is constant

- offline-cracking

# FIN
