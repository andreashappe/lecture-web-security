---
author: Andreas Happe
title: Web Security
--- 

# Other Stuff..

# Redux: Cookie Header

``` http
Set-Cookie: cookie=wert; Path=/app; Secure; HttpOnly; SameSite=Lax;
```

* Secure, HttpOnly und SameSite=Lax verwenden
* Path verwenden, vor allem wenn mehrere Applikationen am Server
* Ohne Domain: nur aktueller Origin gültig

# Unverified Redirects and Forwards

## Basics

* Redirect Target wird über eine Benutzereingabe kontrolliert
* http://example.com/example.php?url=http://malicious.com
* Besonders gefährlich, wenn die übergebene Seite mittels iframe eingebunden wird
* Gegenmaßnahme: Whitelist verwenden

# HTML-Directives

## IFrame-Option: sandbox

* all forms and scripts are disabled
* all links are not allowed to target other browser contexts
* all plugins are disabled
* all features that trigger automatically are disabled

## Subresource Integrity

* Dient um indirekte Angriffe z. B. über CDNs abzuwehren
* Hash-Summe wird bei script/css includes angegeben,
* Verwendung kann mittels CSP enforced werden

```html
<script src="https://example.com/example-framework.js"
      integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC"></script>
```

## SRI: Probleme

* nicht transitiv
* dynamische Inhalte wie Google Fonts
* keine "gratis" Updates von Libraries


# HTML5 Stuff

## WebStorage

* SessionStorage vs. LocalStorage
* Verwundbar gegenüber XSS (verglichen mit Cookies)
  * no-na-net
  * es gibt kein httpOnly
  * man kann es nicht auf sub-Pfade limitieren
* niemals sensitive Informationen speichern

## WebWorkers

* Achtung wenn User-Eingaben verwendet werden
* können XMLHttpRequests abschicken, aber getrennter Origin
* CPU DoS!

## WebAsm

* Potential für Bitcoin-Miners
* Potential für Obfuscation

## WebRTC

* Peer-to-Peer Communication
* Access to Camera/Mic through Browser Controls
* Eher Privacy Impact

## WebBluetooth

* Browser soll mit verbundenen Bluetooth LE devices Daten austauschen können.
* Webseite kann nicht nach devices suchen
* JS requested device, Browser übernimmt das Pairing
* Effektiv sehr vergleichbar mit Security Model mobiler Applikationen

## WebBluetooh: Privacy Impact

* Only possible from Secure Context (HTTPS)
* Eher Privacy Impact
* "rssi", "txPower"

# HTTPS/TLS

## HTTPS/TLS: Guidelines

* TLSv1.2 (oder TLSv1.3) mit AES-GCM
  * [RFC8996](https://datatracker.ietf.org/doc/rfc8996/?include_text=1)
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
* Debug Mode/Toolbars bei verwendeten Frameworks
* Stacktraces mit Detailinformationen
* phpinfo.php
* Beispielscode (/example Directory)

## Beispiel von Meta-Daten, die man nicht haben will:

* .git, .svn Verzeichnisse
* Backup files (.bak, .tmp)
* Private Schlüssel, etc. im Dateisystem
* Credentials im Dateisystem oder in Repositories
* Backups

## Configuration and Credential Management

- nicht hard-coded
- Alternativen:
  - .env Files
  - Framework-Features
  - Vault

## .env

- Im Sourcecode wird Konfiguration über Umgebungsvariablen mitgeteilt
- ENV wird vor dem Aufruf gesetzt (z. B. auch via openShift)
- Wird eine Umgebungsvariable nicht gefunden, wird in .env nachgesehen
- .env ist nicht eingecheckt

## Frameworks: Credential Storage

Frameworks bieten zumeist Möglichkeiten zum Speichern sensitiver Keys/Credentials/etc.

Ruby on Rails 5.2:

* credentials.yml.enc -- enthält secrets/credentials/etc
* config/master.key -- key, wird nicht eingecheckt
* Zugriff in der Application: Rails.credentials.key
* rails credentials:edit -- modifiziert das credentials

# Using Components with known Vulnerabilities

## Components with Vulnerabilities

* Komponenten müssen regelmäßig getestet werden
* ..und dann auch ausgebessert

## Wie kann dies automatisiert überprüft werden

* [OWASP dependency-check](https://owasp.org/www-project-dependency-check/), [retire.js](https://retirejs.github.io/retire.js/)
* [OWASP dependency-track](https://dependencytrack.org/)

## Supply-Chain Attacks

* Typo-Squatting
* Dependency-Confusion

# Logging / Monitoring

## Basics

* Kontroverse bei OWASP Top 10 2017
* Es sollte möglich sein automatisierte Angriffe zu erkennen
* Spätere Auswertung sollte möglich sein
* Betrifft im Webserver Umfeld vor allem Webserver- und Applikationslogs

##  Anforderungen

* Zentralisiert (weil mehrere app server, db server, etc.)
* Secure (Integrität, Vertraulichkeit, Verfügbarkeit)
* Auswertbar

# FIN
