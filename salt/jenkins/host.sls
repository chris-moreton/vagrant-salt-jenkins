/var/www/directorzone/.htpasswd:
  file:
    - managed
    - source: salt://files/directorzone/htpasswd
    - mode: {{ pillar['directorzone']['htpasswd']['mode'] }}
    - require:
      - git: clone_directorzone
    - watch_in:
      - module: apache2-restart