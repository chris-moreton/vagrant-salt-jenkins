include:
  - apache2
 
{% for hostname in ['ukfootballfinder', 'dexysden', 'ukffteams'] %}
 
/etc/apache2/sites-available/{{ hostname }}.conf:
  file:
    - managed
    - source: salt://files/ukff/apache/{{ hostname }}.conf
    - template: jinja
    - require:
      - pkg: apache2
    - watch_in:
      - module: apache2-restart
      
{{ hostname }}_vhost_enabled:
  cmd.run:
    - name: a2ensite {{ hostname }}.conf
    - unless: test -f /etc/apache2/sites-enabled/{{ hostname }}.conf
    - require:
      - file: /etc/apache2/sites-available/{{ hostname }}.conf
    - watch_in:
      - module: apache2-restart
      
{% endfor %}
