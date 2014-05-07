include:
  - apache2
  - mysql
  
phpmyadmin:
  pkg:
    - installed
  
phpmyadmin_apache_config:
  file.append:
    - name: /etc/apache2/apache2.conf
    - text: "Include /etc/phpmyadmin/apache.conf"
    - require:
      - pkg: phpmyadmin
      - pkg: apache2
      
phpmyadmin_directorzone_database_privs:
  cmd.run:
    - name: mysql -uroot -e "grant all on *.* to {{ pillar['phpmyadmin']['databaseUser'] }}@localhost identified by '{{ pillar['phpmyadmin']['databasePass'] }}'"
    - watch_in:
      - module: mysql-restart
    - require:
      - pkg: mysql
      
phpmyadmin_directorzone_flush_database_privs:
  cmd.wait:
    - name: mysql -uroot -e "flush privileges"
    - watch:
      - cmd: phpmyadmin_directorzone_database_privs
      
/etc/phpmyadmin/htpasswd.setup:
  file.managed:
    - source: salt://files/phpmyadmin/htpasswd.setup
      