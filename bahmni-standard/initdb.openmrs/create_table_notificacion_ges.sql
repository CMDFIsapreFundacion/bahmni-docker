CREATE USER 'notificacion'@'%' IDENTIFIED BY 'Admin.123';
GRANT SELECT ON openmrs.* TO 'notificacion'@'%';
FLUSH PRIVILEGES;
