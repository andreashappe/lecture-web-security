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
- automated testing (allerdings noch nicht für security)
- automated SAST testing
- secure code workflow (github)

# Vorlesungseinheit 2

- added github code-check
- renamed introduction.js to introduction_to_js.txt
   
# Stage 3: Improve Rendering

## TODO

- add views + layouts (ejs)
- talk about middleware
- add variables into the view
- add HTTP headers through helmet
- re-check security scan results

## Security Review
   
- now we have our initial output escaping/quoting (at least for HTML)
- we added some security-specific HTTP Headers

# stage 4: add authentication

## TODO

- add users (here might be some more unit testing)
- add sessions (and session controller)
- create a sessions-controller
- add express.urlencoded();
- add rate-limits
- add system-wide authentication
     
## Security-Review

- use pdkdf
- set secure-ish session cookie flags
- regenerate session on login
- show rate-limit on login
- add system-wide authentication

# Stage 5: add admin area and write some abuse cases

## TODO

- add admin routes
- remove authentication for /posts   
- add input validation through express-validator
- add a simple authentication test
   
## Security Review

- add input validation
- test-cases / abuse-cases
     
# The Future..
     
   TODO - implement logout

   - controller + router?
   - switch to database? (sqlite-async?)
     - test with sqlmap
   - authorization
     - write an abuser-case
 
 - eventuell switch to sequilize?
 
 - check API? Talk about DTOs
 - create a separate API?
   - OAuth2 (https://github.com/oauthjs/express-oauth-server/blob/master/examples/memory/model.js)
   - react oder angular.js?
