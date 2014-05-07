include:
  - apache2
  - cron
  - bower
  - mysql
  - elasticsearch
  - tools

unzip_directorzone_db:
  archive:
    - extracted
    - name: /tmp/dz_db
    - source: https://dl.dropboxusercontent.com/u/63777076/VM/db_create.zip
    - source_hash: sha256=a93840c1da6aecb45d983a561f2a3ca2aa7eefb0bbc020acfce59841f8071d16
    - archive_format: zip

import_directorzone_database_privs:
  cmd.run:
    - name: mysql -uroot -e "grant all on *.* to {{ pillar['directorzone']['DB_USERNAME'] }}@localhost identified by '{{ pillar['directorzone']['DB_PASSWORD'] }}'"
    - watch_in:
      - module: mysql-restart
    - require:
      - pkg: mysql

/etc/apache2/sites-available/directorzone.conf:
  file:
    - managed
    - source: salt://files/directorzone/apache/directorzone.conf.jinja
    - template: jinja
    - require:
      - pkg: apache2

directorzone_vhost_enabled:
  cmd.run:
    - name: a2ensite directorzone.conf
    - unless: test -f /etc/apache2/sites-enabled/directorzone.conf
    - require:
      - file: /etc/apache2/sites-available/directorzone.conf
    - watch_in:
      - module: apache2-restart

directorzone_user:
  group:
    - present
    - name: {{ pillar['directorzone']['linux_groupname'] }}
    - gid: {{ pillar['directorzone']['linux_gid'] }}
  user:
    - present
    - name: {{ pillar['directorzone']['linux_username'] }}
    - uid: {{ pillar['directorzone']['linux_uid'] }}
    - gid: {{ pillar['directorzone']['linux_gid'] }}
    - fullname: Directorzone User
    - home: /home/{{ pillar['directorzone']['linux_username'] }}
    - createhome: True
    - groups:
      - {{ pillar['directorzone']['linux_groupname'] }}
    - require:
      - group: {{ pillar['directorzone']['linux_groupname'] }}

/var/www/directorzone:
  file.directory:
    - user: www-data
    - group: www-data
    - makedirs: True
    - require:
      - pkg: apache2
      - user: directorzone_user
  composer.installed:
    - no_dev: true
    - require:
      - cmd: install-composer
