ukff:
  group:
    - present
  user:
    - present
    - shell: /bin/bash
    - fullname: UK Football Finder
    - createhome: True
    - groups:
      - ukff
    - require:
      - group: ukff
  ssh_auth:
    - present
    - user: ukff
    - names: 
      - {{ pillar['ukff']['deploy_key_public'] }}
    - require:
      - user: ukff
      
/home/jenkins/.ssh/id_rsa:
  file.managed:
    - contents_pillar: ukff:deploy_key
    - user: {{ pillar['netsensia']['jenkins_username'] }}
    - group: {{ pillar['netsensia']['jenkins_groupname'] }}
    - mode: 600
    - require:
      - file: jenkins_ssh_directory
      
