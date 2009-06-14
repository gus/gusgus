---
layout: post
title: Installing the MySql gem on a Mac
summary: The command I always forget to type
---

Installing the mysql gem on my Mac today was not so easy; or obvious. Probably because I have Mysql installed as a port (currently on version 5.0.51).

Here's what I had to do:

    ARCHFLAGS="-arch i386" sudo gem install mysql -- --with-mysql-config=/opt/local/lib/mysql5/bin/mysql_config 

Barf!
