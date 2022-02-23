---
author: Andreas Happe
title: Web Security
--- 

# Security im Kontext

## Security steht nie alleine

* Immer Security von "irgendwas"
* Nicht-funktionales Requirement

## Problem: Security häufig als after-thought

## Beispiel

* Projektdesign: Wasserfallmodel
* Zeitraum: über mehrere Jahre hinweg
* Sicherheit wurde eingeplant, einen Monat vor Abschluss Pen-Test
* Natürlich ist das Projekt verspätet
* Natürlich wurden nicht-funktionale Dinge nach hinten verschoben
* Pen-Test kann erst nach erfolgter Implementierung stattfinden
* Im letzten Moment wird der Pen-Test gestartet
* Beim Pen-Test werden Mängel gefunden
* Launch kann nicht mehr verschoben werden (Werbung)

## meh.

# Strukturierter Ansatz wäre vorteilhaft

## Strukturierter Ansatz wäre vorteilhaft

Suboptimal:

> Zwar keine Ahnung wohin, aber Hauptsache schnell!!!1

## Wann sollte etwas unternommen werden?

* Während des gesamten SDLC

## Wann sollte etwas unternommen werden?

* Training
* Requirementsanalyse
* Architektur/Design
* Implementierung und Testing
* Maintenance (Supply-Chain Attacks)

# Threat Model

## Threat Model

Strukturierte Herangehensweise an Sicherheitsbetrachtung

- am besten ab der Design-Phase

## Vorgehensweise

- Schaffen einer "Gesprächsbasis"
- Dekonstruieren der Applikation
- Erkennen von Gefährdungen
- Reihung der Gefährdungen
- Selektion von Gegenmaßnahmen

## Gesprächsbasis

* Was muss geschützt werden?
* Vor wem/was habe ich Angst?
* Auf welche Bereiche kann ich Einfluss nehmen?

## Was sollte geschützt werden?

* Schützenswertes Gut
* CIA-Triade
  * Confidenciality, Integrity, Availabilty
  * Non-Repudiation, Auditing
* Aber schlußendlich immer Kundenspezifisch

## Vor wem habe ich Angst?

* Threat-Actors
* Wichtig zur Einschätzung der Möglichkeiten, Hartnäckigkeit, Skills
* Beispiele:
  * Hacktivists
  * Script-Kiddies
  * Staaten
  * organisiertes Verbrechen

## Was ist mein Scope?

* Harte Business-Requirements/Deadlines
* Welche Systeme sind in-scope?
* Welche Systeme sind out-of-scope?
* Grundlegende Sicherheitsannahmen

## Welche Schwachstellen können auftreten?

* Architektur- oder Datenfluss-Diagramme
* Brainstormen (Erfahrung), Kataloge oder "Kartenspiele"
* STRIDE

## Threat Model Diagram

![](./0x01_threat_model.png)

## Wie gehe ich mit Gefährdungen um?

* Entfernen des Risikos
* Mitigieren
* Versichern/Delegieren
* Akzeptieren
* (Ignorieren)

## ..und in welcher Reihenfolge?

* Sortieren (z. B. mittels DREAD)
* Kataloge mit Absicherungsmassnahmen

## Hoffnung

Auf diese Weise sollten die Schwachstellen überhaupt nicht im Softwareprodukt "aufschlagen".

## Buchempfehlung

- [Loren Kohnfelder: Designing Secure Software](https://amzn.to/3p5nvKf)

# Fin
