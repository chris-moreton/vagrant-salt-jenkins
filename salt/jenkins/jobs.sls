include:
  - jenkins
  
/usr/bin/jenkins_job:
  file.managed:
    - source: salt://files/jenkins/jenkins_job
    - mode: 755
    
{% for jobName in ['directorzone', 'ukfootballfinder', 'dexysden', 'ukffteams'] %}

/tmp/{{ jobName }}_config.xml:
  file.managed:
    - source: salt://files/jenkins/jobs/{{ jobName }}.xml
    
jenkins.job.{{ jobName }}:
  cmd.run:
    - name: /usr/bin/jenkins_job {{ jobName }}
    - require:
      - pkg: jenkins
      - file: /tmp/{{ jobName }}_config.xml
      - file: /usr/bin/jenkins-cli.jar
      - file: /usr/bin/jenkins_job
    - watch_in:
      - module: jenkins-restart
      
{% endfor %}
