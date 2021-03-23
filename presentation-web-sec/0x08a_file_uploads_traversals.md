---
author: Andreas Happe
title: Web Security
--- 

# File Uploads

## Umfeld

* Benutzer kann Dateien hochladen
* Benutzer kann Dateien wieder herunterladen bzw. auf Dateien zugreifen
* (Dateien werden server-seitig gelesen)

## Das Upload-Verzeichnis

* in diesem Verzeichnis werden Dateien abgelegt

| Server-Pfad | URL |
| ----------- | --- |
| /var/www    | http://snikt.net/ |
| /var/www/index.html | http://snikt.net/index.html |
| /var/www/upload | http://snikt.net/upload |
| /var/www/upload/1.jpg | http://snikt.net/upload/1.jpg |
| /var/www/upload/1.html | http://snikt.net/upload/1.html |

## Minimale Absicherungen

* Dateitypen begrenzen (keine HTML-Files)
* Bei impliziten Routing: exekutierbare Dateiendungen nicht erlauben
* Niemals Dateinamen durch User bestimmen lassen
* Kein Overwrite von Dateien erlauben

## Bessere Lösung

* Downloads von Applikation trennen
  * Download-Verzeichnis ausserhalb des Webroots
  * oder BLOBs in der Datenbank
* Eigene Download-Operation
  * Mit Random-Id
  * Mit Authentication/Authorization
  * z.B. download.php?id=123

## Upload von malicious files

* Backdoors, z. B. als PHP Dateien
* Integration von Virenscanner?
  * Auf Filesystem-Ebene problematisch für Applikation

## Upload von HTML Files

* Wenn ein HTML-File hochgeladen und danach betrachtet wird
  * inkludierter JavaScript Code ist same-origin
  * Zugriff auf Cookies, etc.

~~~
Content-Disposition: attachment
X-Content-Type-Options: nosniff
~~~

## Architecure: Sandboxing

* Wenn man unbedingt user-supplied Daten bearbeiten muss, z. B. Bildbearbeitung
* Least Privilege: Bearbeitung in eigener Komponente
* Diese Komponente läuft gesandboxed oder auf einer eigenen VM
* Microservices?


## Recap

* Dateitypen begrenzen
* Getrenntes Upload-Verzeichnis, ausserhalb vom Webroot
* Don’t use user-supplied filenames
* Overwrite nicht erlauben
* Verwendung eines Malware/Viren-Scanners
* Bei download Zugriffsberechtigungen beachten!

# Path Traversals

## Path Traversals: Grundsituation

* Annahme Operation: /var/www/GetImage.jsp
* https://opfer.local/GetImage.jsp?file=diagram.jpg
* Zugriff auf Datei /var/www/diagram.jpg


## Trying to get out of WebRoot

```
Parameter: ./../../../../etc/passwd
/var/www/./../../../../etc/passwd
-> /etc/passwd
```

## Path Traversals: Gegenmaßnahmen

* Nicht benutzer-übergebene Dateinamen beim Zugriff verwenden
* immer den kanonischen Pfad berechnen und verwenden
* whitelisten von Download-Verzeichnis (Achtung bei NULL-Characters, etc.)
* Einsatz von Sandboxes und Chroots

# FIN
