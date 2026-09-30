# FORschool-MYSQLclinicDB PLAESE READ ME

THIS IS FOR THE PHASE 3 (BACK UP AND RECOVERY)

Option 1: MySQL Workbench GUI (Export Wizard)
Since you are using MySQL Workbench, you can perform the backup visually without using the command line:

In MySQL Workbench, go to the Navigator sidebar on the left.

Under the Management tab, click Data Export.

Under Tables to Export, select clinic_db.

Check both patients and appointments.

Under Export Options, select Export to Self-Contained File and choose your save path (e.g., clinic_db_backup.sql).

Click Start Export at the bottom right.

Option 2: MySQL SELECT ... INTO OUTFILE (SQL Query Method)
You can export table data directly to CSV or text files using pure SQL inside MySQL Workbench:

SQL
USE clinic_db;

-- Export patients table
SELECT * FROM patients 
INTO OUTFILE '/var/lib/mysql-files/patients_backup.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Export appointments table
SELECT * FROM appointments 
INTO OUTFILE '/var/lib/mysql-files/appointments_backup.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
> Note: MySQL restricts INTO OUTFILE writes to a specific secure folder defined by the server variable secure_file_priv.

Option 3: Command Line Variations of mysqldump
If you still want to use the command line but need a different setup:

A. Export directly to a compressed .sql.gz file (Saves disk space)
Bash
mysqldump -u root -p clinic_db | gzip > clinic_db_backup.sql.gz
B. Export schema (table structures) and data separately
Bash
# Export schema only (CREATE TABLE statements)
mysqldump -u root -p --no-data clinic_db > clinic_schema.sql

# Export data only (INSERT statements)
mysqldump -u root -p --no-create-info clinic_db > clinic_data.sql
