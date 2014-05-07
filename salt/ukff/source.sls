include:
  - apache2
  - tools
  - jenkins-user
  - ukff.users
 
{% for repo in ['ukfootballfinder', 'dexysden', 'ukffteams', 'rhor7'] %}

/var/www/{{ repo }}:
  file.directory:
{% if 'vagrant' not in grains['id'] %}
    - user: ukff
    - group: {{ pillar['netsensia']['jenkins_groupname'] }}
{% endif %}
    - mode: 775

clone_{{ repo }}:
  git.latest:
    - name: git@bitbucket.org:Chrismo/{{ repo }}.git
    - rev: origin/master
    - user: {{ pillar['netsensia']['jenkins_username'] }}
    - target: /var/www/{{ repo }}
    - identity: /home/jenkins/.ssh/id_rsa
    - force: True
    - require:
      - pkg: apache2
      - pkg: tools
      - user: jenkins_user
      - user: ukff
{% if 'vagrant' not in grains['id'] %}
      - file: /var/www/{{ repo }}
{% endif %}
      
{% endfor %}
