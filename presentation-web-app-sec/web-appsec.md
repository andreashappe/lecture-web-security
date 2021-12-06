---
author: Andreas Happe
title: Web Application Security
---

# Meta

## Application Security

> Application security (short AppSec) includes all tasks that introduce a secure software development life cycle to development teams. Its final goal is to improve security practices and, through that, to find, fix and preferably prevent security issues within applications. It encompasses the whole application life cycle from requirements analysis, design, implementation, verification as well as maintenance. ([fake wikipedia](https://en.wikipedia.org/wiki/Application_security))

## Quasi

- das defensive Gegenstück zur (offensiven) Web-Security Lehrveranstaltung
- Left-Shifting Security

## Bereiche

- Requirements Analysis (Threat Model)
- Design
- Implementation
- Verification
- Maintenance

## Praxisbeispiel

Blog mit JavaScript/Express.js

- public/private area
- Berechtigungssystem
- Deployed auf einer public cloud (heroku)

## Roadmap

1. JavaScript
2. Simple Blog (memory-db)
3. Tooling (Testing, SAST, deployment)
4. Extend Blog (database)
5. Extend Blog (API + OAuth2)
6. Source Code Reviews

## Prüfungsmodus

- Seminararbeit
- Umfang: ca. 8 PT
  - 3.0 ECTS entsprechen 75h Aufwand, -12h Vorlesung
- Umfang: 20-40 Seiten

## Mögliche Themen

- Ähnliches Projekt wie während der Vorlesung
- Source Code Audit (z.B. unter Verwendung von SAST Tooling)
- offen für Vorschläge (können auch gerne mit der DA was zu tun haben)

Bitte initial mit mir abklären, damit es keine Überschneidungen gibt.

# Javascript

## Geschichte

| Datum | Event | Bemerkung |
| -- | -- | -- |
| 1995/1996 | Released als Teil von NS2 | mehr Scheme als Java |
| 1996 | JScript im IE | |
| 1997 | ECMAScript 1  | Versuch der Standardisierung |
| 2004 | IE mit 95% Marktanteil | MS: kein Interesse an Standardisieurng |
| 2009 | ECMAScript 5 | Warum? Chrome |

## Geschichte

| Datum | Event | Bemerkung |
| -- | -- | -- |
| 2015 | ECMAScript 6 | Module, Klassen, Arrow-Funktionen, Promises, .. |
| 2016 | ECMAScript 7 | async/await |
| ..   | ~ eine jährliche Release | |

## Historische Auswirkungen

- single-event loop

## Basics

- Gute Quelle: [javascript.info](https://javascript.info)
- Variablen, Schleifen, Ifs
- Functions
  - Funktionen als Parameter
  - stabby functions (anonyme Funktionen)
- Collections

## Strict Mode

- Seit ECMAScript 5
- [Mozilla Dokumentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
- "strict mode"; als erste Zeile einer Funktion/Modules/Textfiles
- Klassen verwenden automatisch strict mode

## klassen

- Klassen in ECMAScript6
- [Prototype inheritence](https://javascript.info/prototype-inheritance)
  - Attack: [Prototype Pollution](https://portswigger.net/daily-swig/prototype-pollution-the-dangerous-and-underrated-vulnerability-impacting-javascript-applications)

## module

Bibliothek, etc.:

~~~ javascript
// 📁 sayHi.js
export function sayHi(user) {
  alert(`Hello, ${user}!`);
}

function not_exported() {
    // do something
}
~~~

Aufrufer:

~~~ javascript
// 📁 main.js
import {sayHi} from './sayHi.js';
sayHi('John'); // Hello, John!
~~~

## async/await

- single event-loop:
  - highly efficient, but stalls when waiting
  
- callback-hell
   - event loops (maybe use javascript.info)
   - Promises
   - Promise.all([...])
   - async/await

## Future: typing?

- [Microsoft TypeScript](https://www.typescriptlang.org/docs/handbook/2/basic-types.html)

~~~ typescript
function greet(person: string, date: Date) {
  console.log(`Hello ${person}, today is ${date.toDateString()}!`);
}
~~~
 
# API Design? Restful

## Basic

- mostly based upon [Zalando API and Event Guidelines](https://opensource.zalando.com/restful-api-guidelines/)

## CRUD Functionality

- Typische Operationen die man für die Verwaltung von Resourcen benötigt
- Create, Read, Update, Delete

## RESTful Architectures

- [Maturity Levels](https://martinfowler.com/articles/richardsonMaturityModel.html#level2)
- Target: REST Maturity Level 2
  - Aufteilen auf Resourcen
  - Verwendung richtiger HTTP Verben
  - Verwendung richtiger HTTP Statuscodes
  - Keine Verben/Actions in der URL
  
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
| 429 | Too Many Requests (Rate-Limit) |
| 500 | Internal Server Error |
| 502/504 | Bad Gateway |
| 503 | Service Unavailable |

## Resourcen

- es gibt collection und singuläre Resourcen
  - Collection z.B. /users/123
  - Singular z.B. /current-user

## RESTful CRUD-Functionality (collection)

|URL|Method|Operation|
|---|------|---------|
|/notes/|GET|list notes|
|/notes/|POST|create note|
|/notes/123|GET|show note|
|/notes/123|DELETE|remove note|
|/notes/123|PUT|update note|

## RESTful CRUD-Functionality (singular)

|URL|Method|Operation|
|---|------|---------|
|/session|GET|return session/user|
|/session|POST|neue session anlegen|
|/session|PUT|session updaten|
|/session|PATCH|session partiell updaten|
|/session|DELETE|session schließen|

## Resourcen vs. Actions

- nicht "POST /users/login" sondern "POST /sessions/"
- URL sollten "verb-free" sein

## Naming-Conventions

- Identifier müssen ,,stable'' sein
  - z.B. /users/42 liefert immer den gleichen User
- Benamung
  - kebab-case für Pfade (alles Kleinbuchstaben)
  - snake_case für Parameter

## Real-World Problems for non-APIs

- Links can only be GET
- Forms can only submit GET/POST
- Rest: JavaScript oder workarounds
  - /users/1/delete
  - /users/1/update
  
# Routing bei unserem Prototypen

## Umfang der Applikation

- simples Blog
- Login für Admins
- Admins können neue Blog-Posts anlegen)
- Public Zugriff auf Blog-Posts

## Welche Resoucen?

- initial posts
- später sessions + admin

## Route-Vorschlag (inital)

| Method | URL | Action |
| -- | -- | -- |
| GET | / | redirect to /posts |
| GET | /posts | index |
| GET | /posts/:id  |show |

## Route-Vorschlag (session)

| Method | URL | Action |
| -- | -- | -- |
| GET | /session | login-dialog |
| POST | /session | login |
| DELETE | /session | logout |
| POST | /session/delete | logout |

## Route-Vorschlag (admin)

| Method | URL | Action |
| -- | -- | -- |
| GET | /admin | redirect to /admin/posts |
| GET | /admin/posts | index |
| GET | /admin/posts/:id | show |
| POST | /admin/posts | create |

# Tooling Basics
 
## git

- basics: commits, branches
  - main should always compile/work (oder auch "production")
  - new features in feature-branches
  - typically: when a feature branch gets merged into 'main', perform unit tests/code review 
- .gitignore für Dateien die nie eingecheckt werden sollten
 
## node.js

- Google V8 JavaScript-Engine
- Verwendung ausserhalb des Browsers
- "npm" als Paketmanager

## node.js Beispiel (mit http-Library)

~~~ javascript
// import http from "http";
const http = require('http')

const hostname = '127.0.0.1'
const port = 3000

const server = http.createServer((req, res) => {
  res.statusCode = 200
  res.setHeader('Content-Type', 'text/plain')
  res.end('Hello World\n')
})

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`)
})
~~~

## express.js

- baut auf node.js auf
- optimiert für Webapplikationen
- talk about opiniated (Ruby on Rails) vs unopiniated (express.js) frameworks

## express.js Beispiel

~~~ javascript
// import express from "express"
const express = require('express');

const app = express();

app.get('/', function(req, res) {
  res.send('Hello World!')
});

app.get('/ports/:id', (req, res) => {
    re.send("Another Resource " + req.params.id);
});

const port = 3000;
app.listen(port, function() {
  console.log(`Example app listening on port ${port}!`)
});
~~~

## express.js

- relativ minimales framework
- mit plugins erweiterbar
- middleware

~~~ javascript
const express = require('express');
const app = express();

// An example middleware function
let a_middleware_function = function(req, res, next) {
  // ... perform some operations
  next(); // Call next() so Express will call the next middleware function in the chain.
}

// Function added with use() for all routes and verbs
app.use(a_middleware_function);

// Function added with use() for a specific route
app.use('/someroute', a_middleware_function);

// A middleware function added for a specific HTTP verb and route
app.get('/', a_middleware_function);
...
app.listen(3000);
~~~

# Stage 1: start with simple blog posts

## TODOs

- create git repository
- setup npm
- initially:
  - alles im controller
  - move business logic into services
  - move storage into models
- storage in memory
- unit tests für storage
- npm audit, github itself

## Security-Review

- explicit routing (protection against file-upload attacks)
- protection against supply-chain attacks (npm audit, github dependabot)
- maybe talk about "npm audit" vs. [OWASP dependency-track](https://dependencytrack.org/)

# Stage 2: initial security integration

## TODO

- CI: gitlab-actions integrieren
- add SAST tooling (semgrep)
- dotenv in express.js
- add .gitignore
- CD: howto automatically deploy this? -> heroku

## Security-Review

- keine secrets/magic numbers im source code (externalized configuration)
- automated testing (business logic)
- automated SAST testing
- automated deployment (keine Schlampigkeitsfehler)

# Stage 3: Improve Rendering

## TODO 1/4

- add views + layouts (ejs)
- talk about encoding
- mention middleware

## Security-Review
   
- now we have our initial output escaping/quoting (at least for HTML)

## TODO 2/4

- add HTTP headers through helmet

## Security-Review

- we added some security-specific HTTP Headers

## TODO 3/4

- add integration tests
- Tests that work on the "final" application

## Security Review

- Testen der Verfügbarkeit

## TODO 4/4

- add bootstrap

## Security-Review

- used npm for this -> bootstrap version is included in "npm audit"

# stage 4: add authentication

## Preparation

- add users
- add units tests for users

## TODO

- add sessions (and session controller)
- add session regeneration
- create a sessions-controller
- add express.urlencoded();
- add system-wide authentication
     
## Security-Review

- use pdkdf
- set secure-ish session cookie flags
- regenerate session on login
- add system-wide authentication

## TODO

- add flash

## TODO

- add rate-limits

## Security-Review

- added rate-limits

# Stage 5: add admin area

## Add Admin read-only features

- add admin route

## Move Authentication checks and refactor

- remove authentication for /posts   
- cleanup: move controller logic into /controllers

## TODO: allow creation of posts

- add input validation
- add CSRF protection with csurf
- add a simple authentication test
- add logout..
   
## Security Review

- CSRF validation
- input validation
- test-cases / abuse-cases

# Stage 6: switch to relational database (Vorlesung 4)

## Preparation

- introduce DataManager

## TODO

- create a Sqlite DataManager
- create Testcases

## Notes

- test with nodejs
- refactor testcases

## Security-Review

- prepared statements
- test with sqlmap

# Stage 7: Switch to Passport

## Preparation before

- don't forget CSRF Absicherung

## TODO

- create new infrastructure
- show strategies

## Security Review

- removed some of our code (maintainability)

# Stage 8: Add JWT Support

## TODO

 - generate JWT
 - create a separate API protected by passport
 - talk about DTOs
 
## Security Review

- implemented API
- added DTO to prevent information disclosure

# Stage 9: Authorization

## TODO

- allow deletion of own posts

# Source Code Audits

## Arten von Tests

- Pen-Test / Red-Teaming
- Vulnerablity Assessment
- Source Code Audits

## Source Code Audits

- pricey
- Ansatz 1: jede Zeile Code lesen
- Ansatz 2: gezielt nach verwundbaren Stellen suchen und den Fluss dahin analysieren

## Hinweis

- ein Source Code Audit ohne Programmierskills wird.. spannend
- ich verwende zwei vulnerable Beispielprojekte
  - node.js: [diplomarbeit](https://github.com/martingratt/masterthesis_insecure)
  - java: [vulnerado](https://github.com/ScaleSec/vulnado)

## Tooling: pattern matching

- find, grep ([fd](https://github.com/sharkdp/fd), [ripgrep](https://github.com/BurntSushi/ripgrep))
- mögliche Inspiration: [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/index.html)

## Tooling: programming-language aware grep

- [semgrep](https://semgrep.dev/)

## Tooling: Spezialtools

- [spotbugs](https://spotbugs.github.io/) und [find-sec-bugs](https://find-sec-bugs.github.io/)
- semgrep mit Bibliotheken
- kommerzielle Angebote (SonarCube, etc.)
  - potentiell relativ teuer (Fortify, 4-6 stellig pro Jahr)

## Tooling: taint-flow analysis

- Flussanalyse
  - wie kann eine Usereingabe bis zu einer verwundbaren Operation fließen
- [semgrep](https://semgrep.dev/docs/writing-rules/data-flow/)

## Tooling: SCA

- "npm audit", github dependabot
- OWASP dependency-check
- OWASP dependency-track

## Hinweis

- ähnlich wie bei vollautomatisierten Web-Scannern:
  - ein Source Code Audit ohne Programmierskills wird.. spannend
- Source Code Audit ist nur ein Teil von App-Sec
  - Schulungen, CI, CD, SCM-Management, etc.

# Seminararbeit

## Zeitplan

- Vorschläge bitte bis 6.12. an mich
  - samt reviewer (anderer Student)
  - jeder Student sollte einmal als Reviewer vorkommen
- Arbeit an den Reviewer bis 10.01.2022
- Reviews bis 17.1.2022 (intern)
- Endabgabe bis 24.1.2022

## Themen-Vorschläge

- source code reviews von OSS/kommerzieller Software
  - angelehnt an die OWASP Top 10
- selber eine web-applikation secure bauen (blog, note-taking app, etc.)
  - angelehnt an die OWASP Top 10
  - siehe auch [Comparison of server-side web frameworks](https://en.wikipedia.org/wiki/Comparison_of_server-side_web_frameworks)

## Aufgaben des Reviewers

- Review sollte 1-2 Seiten haben
- Vorschläge, wie die Seminarabeit besser werden könnte
- Bereiche die gefehlt haben, Alternativen?
- ich gebe natürlich auch gerne vor dem 17.1. mein Feedback ab

## Benotung

- 90% die eigene Arbeit
- 10% das selbst-geschriebene Review


# Bonus: different Frameworks

- show sails.js
- [gutes Beispiel](https://medium.com/@josephdlawson21/intro-to-sails-js-99a2016bf37d)
