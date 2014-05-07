include:
  - netsensia
{% if 'vagrant' not in grains['id'] and 'jenkins' not in grains['id'] %}
  - jenkins-user
{% endif %}
  
apache2:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: apache2

apache2-reload:
  module:
    - wait
    - name: service.reload
    - m_name: apache2

apache2-restart:
  module:
    - wait
    - name: service.restart
    - m_name: apache2
          
a2enmod rewrite:
  cmd.run:
    - unless: ls /etc/apache2/mods-enabled/rewrite.load
    - order: 225
    - require:
      - pkg: apache2
    - watch_in:
      - module: apache2-restart
      
/etc/apache2/apache2.conf:
  file.append:
    - text: ServerName 127.0.0.1
    - require:
      - pkg: apache2
    - watch_in:
      - module: apache2-restart

/etc/apache2/conf-available/nogit.conf:
  file.managed:
    - source: salt://files/apache2/nogit.conf
    - require:
      - pkg: apache2

a2enconf nogit:
  cmd.run:
    - unless: ls /etc/apache2/conf-enabled/nogit.conf
    - require:
      - file: /etc/apache2/conf-available/nogit.conf
    - watch_in:
      - module: apache2-restart
      
{% if 'vagrant' not in grains['id'] and 'jenkins' not in grains['id'] %}
/var/www:
  file.directory:
    - mode: 775
    - user: {{ pillar['netsensia']['jenkins_username'] }}
    - group: www-data
    - require:
      - user: jenkins_user
      - pkg: apache2
{% endif %}