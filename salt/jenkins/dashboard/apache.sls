include:
  - jenkins.apache
  
/etc/apache2/sites-available/dashboard.conf:
  file:
    - managed
    - source: salt://files/jenkins/apache/dashboard.conf
    - template: jinja
    - require:
      - pkg: apache2
      - file: /var/lib/jenkins/.htpasswd
    - watch_in:
      - module: apache2-restart
      
dashboard_vhost_enabled:
  cmd.run:
    - name: a2ensite dashboard.conf
    - unless: test -f /etc/apache2/sites-enabled/dashboard.conf
    - require:
      - file: /etc/apache2/sites-available/dashboard.conf
      - file: /var/lib/jenkins/.htpasswd
    - watch_in:
      - module: apache2-restart
      