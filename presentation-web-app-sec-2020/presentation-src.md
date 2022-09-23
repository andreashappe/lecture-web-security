---
author: Andreas Happe
title: Web Application Security
date: November 11, 2020
output:
  revealjs::revealjs_presentation:
    css: styles.css
---

# Introduction

## Welcome Back!

* Wieder mal eine neue Vorlesung..
* Modus anders verglichen zum letzten Jahr
* closing the circle: attack -> build -> teach

## Some Terminology

* [FUBAR](https://en.wikipedia.org/wiki/List_of_military_slang_terms#FUBAR) : fscked up beyond all repair
* [SNAFU](https://en.wikipedia.org/wiki/List_of_military_slang_terms#SNAFU): situation normal: all fscked up

## Course: Three Parts

- Hacking (you are here)
  - Hilfe zur Selbsthilfe
  - Black-Box Pen-Testing
  - White-Box Pen-Testing
- Secure Coding
- CTF

## Homework / Seminar Thesis

| Name             | Description | Staring After | Expected. Time | Impact |
| :---             | :--         |:--            | :--            | :-- |
| Hacking          | Testing Pen-Test Sites | 1  | 2-3h           | 12% |
| Sec. Coding      | How's your framework doing? | 3    | 2-3h    | 13% |
| Sec. Coding 2    | Describe Vulnerability Remediation |  4    | 1-2PT           | 75 % |

## Homework / Seminar Thesis

* Suited for Devs and Non-Devs 
* Please use different targets (Homework.xslx)

## Questions and Feedback?

# Hilfe zur Selbsthilfe

## Idea

* Hacking kann nicht theoretisch gelehrt werden, sondern nur ausprobiert
* Es gibt viele Seiten die so ein Testbett anbieten

## Online Anbieter

| Name                 | free | commercial | online | VPN | VM | Documentation |
| :---                 | :--  | :--        | :----  | :-- | :- | :----         |
| Web Security Academy | x    |            | x      |     |    | Description and Walkthrough |
| Vulnhub              | x    |            |        |     | x  | Walkthroughs |
| Pentester Labs       | x    | x          | x      |     | x  | Walkthroughs |
| Hack the Box         | x    | x          | ~      | x   |    | Walkthroughs (commercial) |
| OffSec AWAE          |      | x          |        | x   |    | More akin to certification |

## Good Examples

* [Web Security Academy](https://portswigger.net/web-security)
  - [DOM-based XSS](https://portswigger.net/web-security/cross-site-scripting/dom-based)
  - [XEE](https://portswigger.net/web-security/xxe)
* [Vulnhub](https://www.vulnhub.com/): DC-9, HackingOS1
* [Pentester Labs](https://pentesterlab.com/exercises): SQL-to-Shell 1-3
* [Hack-the-Box](https://www.hackthebox.eu/)
  - magic
  - book
  - cache
  - forward-slash

## Homework

* create an account or download a VM
* do excercises for 1-2 hours
* write a small report (2-3 pages)
  * how was the setup?
  * how was the usability?
  * what did you learn/what VMs did you try?
* submit until Monday, November 23rd 2020

## Homework

> when action grows unprofitable, gather information;\
> when information grows unprofitable, sleep

(Ursula K. Le Guin, The Left Hand of Darkness)

# Blackbox Penetration-Test Examples

## Blackbox Text: vulnhub DC-9

* [walkhtrough](https://www.programmersought.com/article/58664367669/)


## Blackbox Test: HTB cache

1. nmap
2. dirbuster
3. jslogin
4. hosts
5. [authenticate](https://www.open-emr.org/wiki/images/1/11/Openemr_insecurity.pdf)
6. auth/sqli
7. john
8. php shell upload

Note: I do have a openEMR VM set up..

## Blackbox Test: HTB forwardslash

1. gobuster
2. create user
3. create profile
4. LFI/RFI
5. gobuster
6. SSH key finden

# White-Box Penetration Testing

## Black-, Grey-, White-Box Pen-Tests

## Unterschied zu Black-Box

* source code kann gelesen werden
* weniger "Detektivarbeit"
* keine "Verdachtsmomente"
* Standards/Normen wie z. B. ÖNORM A77.00
* Zeitaufwand weitaus höher

## Typische Tools: Old-School

* grep
* vim (or other editor)
* increase logging in virtual machine

## Typische Tools Next-Generation

* [semgrep](https://semgrep.dev)
* Visual Studio Code (for debugging)
* Automated Scanning / SAST (corporate)

## Example

* [ERPnext](https://www.erpnext.com)
* [Open Source ERP](https://github.com/frappe/erpnext)
* based upon [Frappe Framework](https://github.com/frappe/frappe)
* uses [bench for orchestration](https://github.com/frappe/bench)

## Grund-Setup

* VM mit Source Code
* quasi eine Kopie der Software
* nicht mit Echtdaten (aber korrektem Schema)
* db logging ist aktiviert (`/etc/mysql/my.cnf`)

## MVC

![Model-View-Controller](mvc.jpg)

## Metadata-based Programming

## Quick Look through the Application Structure

## First read through the code

* search for MVC-Patterns
* how is authorization handled?

## Find vulnerable Operations

* what would make for a vulnerable function?

## Deja-Vu: UNION Based Select

~~~ sql
select name, email from users
union
select 1, password from othertable;
~~~

* Kommentar in MySQL: #
* Version in Mysql: @@version

## Got SQLi, what now?

* what can I do with what I found?
* collation

## Got SQLi, Hashes seem to be secure

find another way..

## What now?

* template injection to RCE..
* what are templates?
* what do I want to execute?

## Jinja2 Templates?

``` html
{% for item in navigation %}
	<li><a href="{{ item.href }}">{{ item.caption }}</a></li>
{% endfor %}

{# title(striptags(name)) #}
{{ name|striptags|title }}

```

* [More Information for Template Language](https://jinja.palletsprojects.com/en/2.11.x/templates/)

## Python: Inheritance

![Python Class Hierarchy](python_classes_2.jpeg)

## Python: Inheritance

```python
"fubar".__class__.mro()[1].__subclasses__()[40]("abc").some_method()
```

| Method/Attribute | Description |
| :--              | :--         |
| `__class__`      | instance object's class |
| `mro()`          | All parent classes of a class |
| `__subclasses__` | All currently known subclasses of a class |
| `class("abc")`   | Create instance of class with Parameter abc | 

## Python: Illegal Template?

[List of bypasses](https://www.onsecurity.io/blog/server-side-template-injection-with-jinja2/)

## Exploit

## Comparision to Black-Box Testing (IMHO)?

* zielgerichteter, weniger raten.
* tooling: OSS lacking, expensive
* more expensive?

## Feedback and Questions?

# Secure Coding

## Why a coding session?

- Defensive counter-part to offensive attacking (WebSec)
- Show that secure coding is not more expensive
- A security student should have seen JavaScript..

## The App: Simple TODO Web-Site

- Features:
  - create a todo
  - list all todos
  - show a single todo
  - delete a single todo

- initially: single-user, in-memory
- later: multi-user, SQL-Database (still in memory)
- bonus: OAuth2, XML/XEE?

## What are we gonna use?

- server-side JavaScript through [node.js](https://en.wikipedia.org/wiki/Node.js)
- dependency management with [npm](https://en.wikipedia.org/wiki/Npm_(software))
- web framework: [express.js](https://en.wikipedia.org/wiki/Express.js)

# JavaScript

## A bit of History

- JavaScript ursprünglich für NetScape 
- Hat mit Java nichts zu tun..
- Initial ein hack
- Became a "real" programming language (ECMAScript)

## Milestones:

- Klassen (2015)
- Async/Await (2017)
- Modules with "import" (2020)

Future: more static typing, e.g., [TypeScript](https://en.wikipedia.org/wiki/TypeScript) or [flow](https://flow.org/)

## Basic Features

- variables
- functions, functions as parameters
- Arrays, Maps, control structures and loops
- classes

## The Event-Loop

- single event loop
- blocking kills
- howto write performant code?

## The Event-Loop

![The Event Loop](event_loop.png)

## How would that look within code?

- [callback hell](http://callbackhell.com/)
- async/await and promises

# Coding..

##

> Below the surface of the machine, the program
> moves. Without effort, it expands and contracts.
> In great harmony, electrons scatter and regroup.
> The forms on the monitor are but ripples on the
> water. The essence stays invisibly below.
> — Master Yuan-Ma, The Book of Programming

## Basic Steps

- node.js
- npm and express.js
- simple version
- something about MVC
- add some testing
- switch to sql database
- http header

## What OWASP Top 10s have handled so far?

- Components with known vulnerabilities
- XSS
- Injection Attacks (SQL)
- Insecure Configuration (forgotten files, HTTP-Header)
- (Insecure Data Exposure)

## Next Steps 

- Session Handling
- Authentication and Authorization
- Configuration Management, Logs, Rate-Limits
- Serialization (separate app)
- Using JWTs (OAuth2)
- Run through Web-Scanner
- Review OWASP Top 10

## Review and Test with Netsparker..

[OWASP Top 10](https://owasp.org/www-project-top-ten/)

# The final Session

> Exploits are the closest thing to "magic spells" we experience in the real world: Construct the right incantation, gain remote control over device. @halvarflake

## MVC, MVP, MVVC: where's the difference

## TypeScript

* [JavaScript + Typesystem](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes.html), compiles into JavaScript
* [TypeScript Handbook](https://orf.at/corona/daten/oesterreich)

## TypeScript

- Generics
- Type-Information
- Interfaces and Classes
- more compile-time checks

## TypeScript: Example

``` typescript
interface Person {
  title: string;
  name: string;
}

function greeting(salutation: string, person: Person) {
  return `${salutation}, ${person.title} ${person.name}`;
}

let user = { title: "Dr.", name: "Jane User" };

console.log(greeting("Hi", user));
```

## Finale Seminarbeit: Teaching

- Beschreibung von zwei Gegenmassnahmen
- Vorschlag im [OWASP Juice Shop](https://github.com/bkimminich/juice-shop)
  - Alternativ auch andere Software-Projekte
- Zwischenabgabe:
  - check ob Umfang passt (1-3 Gegenmassnahmen)

## Dokuemtationstemplate (Markdown)

``` markdown
# challenge: Name of Challenge

2-3 sentences describing the challenge

## The Vulnerability

What is the vulnerability?

## Where to find in the Code?

File:line

# Fixing the Vulnerability

## Potential fixes

Describe how this could be fixed, i.e., if different solutions exist, how to chose a potential fix

## The chosen Fix

Show in the source code how this was fixed.

## How to verify that the fix worked?

Example how do test for the vulnerability and check that it is not there anymore.

## How to spot vulnerabilities like this?

grep-patterns, how to find similar vulnerabilities?

# Related Work/Links

- links to web-pages, articles, etc. that you used while writing this

```

## Hints for JuiceShop

- [Codebase 101](https://pwning.owasp-juice.shop/part3/codebase.html)
- Frontend: Angular + Typescript
- Backend: node.js, express.js und sequel
- (components -> servcies) -> (routes -> sequel)

##  Alternativen für 1-2 Gegenmassnahmen

- [Write new Hacking Scripts](https://pwning.owasp-juice.shop/part3/tutorials.html)
- Add another Hacking Challenge
  - DOM-based XSS
  - Type-Juggling
  - eventuell SSTI

## Google Cloud Platform Credits

- [$50 Credits](https://google.secure.force.com/GCPEDU?cid=WpZBdhYZRdCMx9eAJqr%2Flyz7xpRqgucc9lSTOpJlYN0t9DeSUp9CpSyZfW30u20x)
 
# CTF

## Setup

- Zweier-Teams sind erlaubt
- [Game-Server](http://35.246.229.182:8888): Teams, Chat, Hints, Leaderboard
- [WebApp-Server](http://35.233.12.181/balancer): Container mit verwundbarer Web-App

## gl hf

![](image.png)

