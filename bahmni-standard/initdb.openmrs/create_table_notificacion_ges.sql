CREATE USER 'notificacion'@'%' IDENTIFIED BY 'notificacion';
GRANT SELECT ON openmrs.* TO 'notificacion'@'%';
FLUSH PRIVILEGES;
