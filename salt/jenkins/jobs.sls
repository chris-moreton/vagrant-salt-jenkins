include:
  - jenkins
  
/tmp/directorzone_config.xml:
  file.managed:
    - source: salt://files/jenkins/jobs/directorzone.xml
    
jenkins.job.directorzone:
  cmd.run:
    - unless: ls /var/lib/jenkins/jobs/Directorzone
    - name: sleep 15 && java -jar /usr/bin/jenkins-cli.jar -s http://localhost:8080 create-job Directorzone < /tmp/directorzone_config.xml
    - require:
      - pkg: jenkins
      - file: /tmp/directorzone_config.xml
      - file: /usr/bin/jenkins-cli.jar
    - watch_in:
      - module: jenkins-restart
