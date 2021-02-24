---
author: Andreas Happe
title: Web Application Security
--- 

# Principles

## Minimalprinzip

> Die Applikation sollte nur die Operationen und Funktionen beinhalten, die für die Erfüllung des Kundenwunsches notwendig sind

## Minimalprinzip

* High-Level: welche Daten werden gespeichert?
* Mid-Level: welche Komponenten/Frameworks sind notwendig?
* Low-Level: welche Features können deaktiviert werden?

## Least Priviledge

> Funktionen haben nur die Privilegien und Rechte die zwingend benötigt werden

## Separation of Duties

## Defense in Depth

> Zwiebelkonzept der Sicherheit: mehrere unabhängige Schichten garantieren die Sicherheit des Gesamtsystems

## Fail-Secure vs. Fail-Safe

> Verhalten im Fehlerfall

## No-Go: Security by Obscurity

> Sicherheit eines Systems darf niemals von dessen Intransparenz abhängen

## No-Go: Security by Obscurity

Häufig im Bereich Crypto:

- Backdoors in Crypto-Algorithmen
- Clipper-Chips

## KISS (Keep it Simple, Stupid)

> Complexity is the enemy of security

## But my problems are so complex!!!1

![Picture](0x02_blackbird.jpg){.stretch}

## Trennung von Daten und Programmlogik

* Injections sind eine Data/Logic-Confusion
* Harvard vs. Von-Neumann Architektur

## Security-by-Design / Security-by-Default

* GDPR
* California

# The World is grey

## Cost of SEcurity

* Accepting a Risk
* Beispiel: DDoS-Angriffe

## Security vs. Usability

## Ethical Web Development

* Impact upon Lifes and Society
* Grindr-Verkauf
* "...the street finds its own uses for things" -- William Gibson, Burning Chrome
* Ethical Guidelines, z. B. [EDRi](https://edri.org/files/ethical_web_dev_web.pdf)

## Ethical Web Development

* process as much data as possible on the individual's device
* use encryption (e2e, storage, homomorphic)
* use data minimization methods
* prefer first-party resources (and check otherwise)

# Fin
