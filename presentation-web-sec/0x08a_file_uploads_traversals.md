---
author: Andreas Happe
title: Web Security
--- 

# File Uploads

## Umfeld

* Benutzer kann Dateien hochladen
* Benutzer kann Dateien wieder herunterladen bzw. auf Dateien zugreifen
* (Dateien werden server-seitig gelesen)

## Das upload-Verzeichnis: public

* in diesem Verzeichnis werden Dateien abgelegt
* schlechtes Beispiel: /var/www/upload
* Problem: web-server vs app-server (authentication/authorization)
* Problem: Uploads werden dadurch Teil der Applikation
* Dateitypen begrenzen (keine HTML-Files)
* Niemals Dateinamen durch User bestimmen lassen

## Bessere Lösung

* Lösung: getrenntes Download-Verzeichnis (oder BLOBS)
* Ausserhalb des Webroots
* Download-Operation download.php?id=123 mit auth

## Upload von malicious files

* Backdoors, z. B. als PHP Dateien
* Integration von Virenscanner? Auf Filesystem-Ebene problematisch für Applikation

## Upload von HTML Files

* Wenn ein HTML-File hochgeladen und danach betrachtet wird, hat inkludierter JavaScript Code Zugriff auf Cookies, etc.
* Content-Disposition (download-only)
* X-Content-Type-Options Header

## Best Practises

* Dateitypen begrenzen
* Getrenntes Upload-Verzeichnis, ausserhalb vom Webroot
* Don’t use user-supplied filenames
* Overwrite nicht erlauben
* Verwendung eines Malware/Viren-Scanners
* Bei download Zugriffsberechtigungen beachten!

## Architecure: Sandboxing

* Wenn man unbedingt user-supplied Daten bearbeiten muss, z. B. Bildbearbeitung
* Separation of Duties: Bearbeitung in eigener Komponente
* Diese Komponente läuft gesandboxed oder auf einer eigenen VM
* Microservices?

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

