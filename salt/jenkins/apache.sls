include:
  - apache2
  - jenkins
  
/etc/apache2/sites-available/jenkins.conf:
  file:
    - managed
    - source: salt://files/jenkins/apache/jenkins.conf
    - template: jinja
    - require:
      - pkg: apache2
    - watch_in:
      - module: apache2-restart
      
jenkins_vhost_enabled:
  cmd.run:
    - name: a2ensite jenkins.conf
    - unless: test -f /etc/apache2/sites-enabled/jenkins.conf
    - require:
      - file: /etc/apache2/sites-available/jenkins.conf
      - file: /var/lib/jenkins/.htpasswd
    - watch_in:
      - module: apache2-restart
      
/var/lib/jenkins/.htpasswd:
  file:
    - managed
    - source: salt://files/jenkins/htpasswd
    - mode: {{ pillar['jenkins']['htpasswd']['mode'] }}
    - require:
      - pkg: jenkins
      
a2enmod proxy:
  cmd.run:
    - unless: ls /etc/apache2/mods-enabled/proxy.load
    - order: 225
    - require:
      - pkg: apache2
    - watch_in:
      - module: apache2-restart
      
a2enmod proxy_http:
  cmd.run:
    - unless: ls /etc/apache2/mods-enabled/proxy_http.load
    - order: 225
    - require:
      - pkg: apache2
    - watch_in:
      - module: apache2-restart