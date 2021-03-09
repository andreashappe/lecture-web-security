---
author: Andreas Happe
title: Web Security
--- 

# Second-Factor

## TOTP

* Time-based One-Time Passwords
* RFC 6238
* Zusammenspiel von Applikation und Authenticator (meist Mobiltelefon)
* Gemeinsames Secret wird vom Server zum Authenticator übertragen

## TOTP: Einfacher Aufbau

![Image](0x04_totp.png){.stretch}

## FIDO2/WebAuthn

* Grundsätzliche Funktion
  * Authenticator wird als Gerät des Benutzers registriert
  * public/secret key pair wird “quasi” ausgetauscht
  * verpflichtend biometrisch oder mittels physischer Interaktion gesichert
* bei dem Authentication-Vorgang wird Public-Key Encryption verwendet

## FIDO2: Genereller Aufbau

![Picture](0x04_fido2.png){.stretch}

## FIDO2: Registration

JS: Authenticator.authenticatorMakeCredential()

![Image](0x04_webauthn_registration.png){.stretch}

## FIDO2: Login

![Image](0x04_webauthn_login.png){.stretch}

## Vergleich FIDO2/TOTP

* Use-Cases
* FIDO2: Hardware zwingend erforderlich
* FIDO2: Netzwerkkommunikation notwendig
* FIDO2: Hardware-Binding möglich
* TOTP: genaue Systemzeit notwendig
* TOTP: kein Hardware-Binding möglich

# FIN
