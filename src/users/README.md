An ORGNAME can be either a random hex code, or a proper name.

Redis Data Structures:

A user is represented by:

```
SETNX uid:ORGNAME EMAILADDR
SET pwd:ORGNAME PASSWORD
SET accttype:ORGNAME 
```

A user has N dashboards. A dashboard looks like:

RPUSH pages:ORGNAME PAGENAME

Pages have N log entries, which look like:

```
RPUSH log:ORGNAME:PAGENAME LOG LINE 1
RPUSH log:ORGNAME:PAGENAME LOG LINE 2
```

The size of a log list is controlled, and will be rotated when full.

```
RPUSH log:ORGNAME:PAGENAME LOG LINE 3
RPOP log:ORGNAME:PAGENAME
```

rate limiting

GET ratelimit:ORGNAME

if it doesnt exist, set:

SET ratelimit:ORGNAME 1 EX 60

if it does exist

INCR ratelimit:ORGNAME 1

if the INCR returns more than N, then indicate an error
