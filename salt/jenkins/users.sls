include:
  - jenkins
  
/var/lib/jenkins/config.xml:
  file.managed:
    - source: salt://files/jenkins/config.xml
    - require:
      - pkg: jenkins
    - watch_in:
      - module: jenkins-restart
      
/var/lib/jenkins/users:
  file.directory:
    - makeDirs: true
    - user: jenkins
    - group: jenkins
    - mode: 755
    - require:
      - pkg: jenkins
      
/var/lib/jenkins/users/{{ pillar.jenkins.users.admin.username }}:
  file.directory:
    - makeDirs: true
    - user: jenkins
    - group: jenkins
    - mode: 755
    - require:
      - file: /var/lib/jenkins/users

/var/lib/jenkins/users/{{ pillar.jenkins.users.admin.username }}/config.xml:
  file.managed:
    - source: salt://files/jenkins/users/{{ pillar.jenkins.users.admin.username }}/config.xml.jinja
    - template: jinja
    - require:
      - file: /var/lib/jenkins/users/{{ pillar.jenkins.users.admin.username }}