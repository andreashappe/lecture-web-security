---
author: Andreas Happe
title: Web Application Security
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

Formaliserte Herangehensweise an Sicherheitsbetrachtung

## Grundlegende Fragen

* Was muss geschützt werden?
* Vor wem/was habe ich Angst?
* Auf welche Bereiche kann ich Einfluss nehmen?
* Welche Schwachstellen können auftreten?
* Was wären potentielle Gegenmassnahmen?

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

* Welche Systeme sind in-scope?
* Welche Systeme sind out-of-scope?
* Grundlegende Sicherheitsannahmen


## Welche Schwachstellen können auftreten?

* Architektur- oder Datenfluss-Diagramme
* Brainstormen (Erfahrung) oder Kataloge
* STRIDE

## Was kann ich grundsätzlich machen?

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

# Fin
