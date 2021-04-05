---
author: Andreas Happe
title: Web Security
--- 

# Other Stuff..

## Redux: Cookie Header

``` http
Set-Cookies: cookie=wert; Path=/app; Secure; HttpOnly; SameSite=Lax;
```

* Secure, HttpOnly und SameSite=Lax verwenden
* Path verwenden, vor allem wenn mehrere Applikationen am Server

* Ohne Expires/Max-Age: Session-Cookie wird beim Schließen des Browsers gelöscht
* Ohne Domain: nur aktueller Origin gültig


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
- Alternativen:
  - .env Files
  - Framework-Features
- Spezialfall: Credential-Managmenet

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

# FIN
