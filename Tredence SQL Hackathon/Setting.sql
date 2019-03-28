SELECT @@GLOBAL.sql_mode;
SET SESSION sql_mode = '';

select @@GLOBAL.secure_file_priv;

SET SQL_SAFE_UPDATES = 0;

SET GLOBAL innodb_lock_wait_timeout = 10000;
SET innodb_lock_wait_timeout = 10000; 
