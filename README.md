# Synology-Glacier-Email-Notification
To query the Synology Glacier SQLite DB and send the latest status as an email notification.

**Pre-requisite**
1) Assuming you have sqlite3 package install on your Synology NAS.
2) Assuming you are have configured Synology Email notification and can use ssmtp.

**How it works**
1) Synology Glacier stores the logs (ie. Task status) into SQLite DB found in /volume1/@GlacierBackup/etc/sysinfo.db.   
Note: you have have a different volume name.
2) The log table of the SQLite DB is sysinfo_tb.
3) Performs a SQL query on the DB to retrieve the latest 2 entries based on the column "Key".
4) Convert the Linux EPOCH timestamp into a human-readable timestamp.
5) Sends the result of the query via email to the recipent defined as "TO_EMAIL"

**To configure**
1) Setup a scheduled task in Synology NAS and run this script as a "user-defined script".
2) Ideally, the scheduled task should only be executed after the backup task has completed.  What I did was to estimate the time the backup task would complete and schedule this task to execute 30min after.

**To Do**
1) Instead of performing a scheduled task to run this script, the email notificaiton should be sent when the actual backup task completed.
2) One idea is to use SQLite DB trigger on insert.
