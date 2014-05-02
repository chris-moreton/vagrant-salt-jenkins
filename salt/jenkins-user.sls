jenkins_user:
  group:
    - present
    - name: {{ pillar['netsensia']['jenkins_groupname'] }}
  user:
    - present
    - name: {{ pillar['netsensia']['jenkins_username'] }}
    - shell: /bin/bash
    - fullname: Jenkins
    - home: /home/{{ pillar['netsensia']['jenkins_username'] }}
    - createhome: True
    - groups:
      - {{ pillar['netsensia']['jenkins_groupname'] }}
    - require:
      - group: {{ pillar['netsensia']['jenkins_groupname'] }}
      
jenkins_login_key:
  file:
    - managed
    - name: /home/{{ pillar['netsensia']['jenkins_username'] }}/.ssh/authorized_keys
    - contents_pillar: netsensia:jenkins_key
    - user: {{ pillar['netsensia']['jenkins_username'] }}
    - group: {{ pillar['netsensia']['jenkins_groupname'] }}
    - mode: 400
    - require:
      - file: jenkins_ssh_directory
      
jenkins_ssh_directory:
  file.directory:
    - name: /home/{{ pillar['netsensia']['jenkins_username'] }}/.ssh
    - user: {{ pillar['netsensia']['jenkins_username'] }}
    - group: {{ pillar['netsensia']['jenkins_groupname'] }}
    - mode: 755
    - makedirs: True
    