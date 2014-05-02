phpmyadmin:
  pkg:
    - installed
    
/etc/apache2/sites-available/phpmyadmin.conf:
  file:
    - managed
    - source: salt://files/phpmyadmin.conf
    - template: jinja
    - require:
      - pkg: apache2
      - pkg: phpmyadmin