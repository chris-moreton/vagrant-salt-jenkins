include:
  - jenkins
  - jenkins.plugins
  
jenkins_ssh_directory:
  file.directory:
    - name: {{ pillar['jenkins']['private_key_dir'] }}
    - user: {{ pillar['netsensia']['jenkins_username'] }}
    - group: {{ pillar['netsensia']['jenkins_groupname'] }}
    - mode: 700
    - makedirs: True
    
{{ pillar['jenkins']['private_key_dir'] }}/directorzone_rsa:
  file:
    - managed
    - contents_pillar: directorzone:deploy_key
    - user: {{ pillar['netsensia']['jenkins_username'] }}
    - group: {{ pillar['netsensia']['jenkins_groupname'] }}
    - mode: 600
    - require:
      - pkg: jenkins
      - file: jenkins_ssh_directory
      
{{ pillar['jenkins']['private_key_dir'] }}/id_rsa:
  file:
    - managed
    - contents_pillar: jenkins:private_key
    - user: {{ pillar['netsensia']['jenkins_username'] }}
    - group: {{ pillar['netsensia']['jenkins_groupname'] }}
    - mode: 600
    - require:
      - pkg: jenkins
      - file: jenkins_ssh_directory

/var/lib/jenkins/credentials.xml:
  file:
    - managed
    - source: salt://files/jenkins/credentials.xml
    - require:
      - pkg: jenkins
      
/var/lib/jenkins/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml:
  file:
    - managed
    - source: salt://files/jenkins/plugins/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml.jinja
    - template: jinja
    - require:
      - pkg: jenkins
      - cmd: jenkins.plugin.publish-over-ssh
    - watch_in:
      - module: jenkins-restart