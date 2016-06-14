The following shows Redis data structures for a simple transient unixy log agreggation tool.

This application allows to register a user, give the user a passsword and an account type, maintain a list of pages, with each page containing N lines.

A user is represented by the following structures:

```
SETNX uid:ORGNAME EMAILADDR
SET pwd:ORGNAME PASSWORD
SET accttype:ORGNAME lite
```

A user has N dashboards. A dashboard looks like:

```
RPUSH pages:ORGNAME PAGENAME
```

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

*Rate limiting*

On a rate limited request, first check whether we have exceeded the rate:

```
GET ratelimit:ORGNAME
```

If it doesnt exist, set:

```
SET ratelimit:ORGNAME 1 EX 60
```

If it does exist, increment it:

```
INCR ratelimit:ORGNAME 1
```
