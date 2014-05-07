include:
  - mysql

get_ukff_backup_file:
  cmd.run:
    - name: s3get --access-key {{ pillar['ukff']['s3_access_key'] }} --secret-key {{ pillar['ukff']['s3_secret_access_key'] }} ukfootballfinder/ukff.sql.zip > /tmp/ukff.sql.zip
    
unzip_ukff_db:
  archive:
    - extracted
    - name: /tmp/ukff_db
    - source: file:///tmp/ukff.sql.zip
    - source_hash: sha256=9c82262a3dca58a418d0d47fb26ef0ea884bd0328ff06e9ae3f5e8c560d6bb01
    - archive_format: zip 
    - require:
      - cmd: get_ukff_backup_file
      
import_ukff_database:
  cmd.run:
    - name: mysql -uroot < /tmp/ukff_db/mysqlback.footballfinder.sql
    - require:
      - archive: unzip_ukff_db
      
import_dexysden_database:
  cmd.run:
    - name: mysql -uroot < /tmp/ukff_db/mysqlback.ukffblog.sql
    - require:
      - archive: unzip_ukff_db
   
import_ukff_database_privs:
  cmd.run:
    - name: mysql -uroot -e "grant all on *.* to {{ pillar['ukff']['databaseUser'] }}@localhost identified by '{{ pillar['ukff']['databasePass'] }}'"
    - watch_in:
      - module: mysql-restart
    - require:
      - pkg: mysql
      
import_dexysden_database_privs:
  cmd.run:
    - name: mysql -uroot -e "grant all on *.* to {{ pillar['dexysden']['databaseUser'] }}@localhost identified by '{{ pillar['dexysden']['databasePass'] }}'"
    - watch_in:
      - module: mysql-restart
    - require:
      - pkg: mysql