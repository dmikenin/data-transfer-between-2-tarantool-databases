# Data transfer between 2 tarantool databases
This script make transfer from old DB in Tarantool with 
huge tables in mew DB in Tarantool with small 
and optimized tables.


### Description
We have db in production, which saved info 
about telegram channels for ICQ channels. 
We have old DB with 3 tables(spaces) and 
i must get info with old db and add new DB. 
One telegram channel maybe have many ICQ channels. 



### Requirements
* tarantool==0.6.6 - driver for work with Tarantool


### Launch script
```
1) Activate venv
2) Install requirements
3) Write in scripts.py login/password/name_db for connection to tarantool
4) Write command: python script.py
```
*In my case i add seed data, for testing code 
before launch script in production DB*


### Schema projects
* init.lua - schema db in lua script
* script.py - launch script
* transfer_data.py - class for process and transfer data
* seed_data.py - test data, analog production data