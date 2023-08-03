
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High CPU usage on MongoDB host
---

This incident type involves the detection of high CPU usage on a MongoDB host, often triggered by an alert monitor. The incident may be indicated by anomalous CPU usage values that are more than two standard deviations above predicted values during a specific time period, such as the last 15 minutes. The incident can cause performance issues and may require investigation to identify the root cause and resolve the problem.

### Parameters
```shell
# Environment Variables

export HOSTNAME="PLACEHOLDER"

export MONGODB_PORT="PLACEHOLDER"

export PASSWORD="PLACEHOLDER"

export USERNAME="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

```

## Debug

### Check CPU usage on the MongoDB host
```shell
top
```

### Check MongoDB logs for any errors
```shell
tail -n 100 /var/log/mongodb/mongod.log
```

### Check MongoDB processes and memory usage
```shell
ps aux | grep mongod
```

### Check network connections to MongoDB
```shell
netstat -an | grep ${MONGODB_PORT}
```

### Check MongoDB disk usage and available space
```shell
df -h /var/lib/mongodb
```

### Check MongoDB configuration file for any issues
```shell
cat /etc/mongod.conf
```

### Check MongoDB version and compatibility with other components
```shell
mongod --version
```

### Check MongoDB performance metrics
```shell
mongostat --ssl --host ${HOSTNAME} --port ${PORT} --username ${USERNAME} --password ${PASSWORD}
```

### Check MongoDB database status and status of all databases
```shell
mongo --eval "db.runCommand({serverStatus: 1})" && mongo --eval "db.runCommand({listDatabases: 1})"
```

## Repair
### Optimize database queries and indexes to reduce the load on the database and improve CPU usage.
```shell
#!/bin/bash

# Set database connection parameters

DB_HOST=${HOSTNAME}

DB_PORT=${MONGODB_PORT}

DB_NAME=${DATABASE_NAME}

DB_USER=${USERNAME}

DB_PASS=${PASSWORD}

# Connect to the database

mongo --host $DB_HOST --port $DB_PORT -u $DB_USER -p $DB_PASS $DB_NAME

# Enable profiling to identify slow queries

db.setProfilingLevel(2, {slowms: 100});

# Analyze query performance

db.system.profile.find({millis: {$gt: 100}}).sort({ts: -1}).limit(10);

# Create indexes for frequently queried fields

db.collection.createIndex({field1: 1, field2: 1});

# Monitor index usage to identify any issues

db.collection.find().explain("executionStats");

# Optimize queries by removing unnecessary queries and improving existing queries

db.collection.aggregate([

  {$match: {field1: "value1"}},

  {$group: {_id: "$field2", count: {$sum: 1}}},

  {$sort: {count: -1}},

  {$limit: 10}

]);

# Verify improved query performance

db.collection.find({field1: "value1", field2: "value2"}).explain("executionStats");

# Disable profiling

db.setProfilingLevel(0);

```