mysql:
  pkg:
    - installed
    - pkgs:
      - mysql-server
      - mysql-client
      
/etc/mysql/my.cnf:
  file:
    - uncomment
    - char: #
    - regex: bind-address
    - require:
      - pkg: mysql
      
mysql-restart:
  module:
    - wait
    - name: service.restart
    - m_name: mysql
    