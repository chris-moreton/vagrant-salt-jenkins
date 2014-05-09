include:
  - jenkins.jobs
  - jenkins.keys
  - jenkins.plugins
  - jenkins.hosts
  - jenkins.apache
  - jenkins.dashboard
    
jenkins:
  pkgrepo.managed:
    - humanname: Jenkins Debian
    - name: deb http://pkg.jenkins-ci.org/debian binary/
    - key_url: http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key  
  pkg.latest:
    - refresh: True
    - require:
      - pkgrepo: jenkins
  service.running:
    - enable: True
    - watch:
      - pkg: jenkins
      
/usr/bin/jenkins-cli.jar:
  file.managed:
    - source: salt://files/bin/jenkins-cli.jar
    - refresh: True
    - mode: 755
    - require:
      - pkgrepo: jenkins
      - pkg: jenkins
     
jenkins-restart:
  module:
    - wait
    - name: service.restart
    - m_name: jenkins
    - require:
      - pkg: jenkins

/etc/sudoers:
  file.managed:
    - source: salt://files/jenkins/sudoers
    



