admin_user:
  group:
    - present
    - name: {{ pillar['netsensia']['admin_groupname'] }}
    - gid: {{ pillar['netsensia']['admin_gid'] }}
  user:
    - present
    - name: {{ pillar['netsensia']['admin_username'] }}
    - uid: {{ pillar['netsensia']['admin_uid'] }}
    - gid: {{ pillar['netsensia']['admin_gid'] }}
    - shell: /bin/bash
    - fullname: Netsensia Admin
    - home: /home/{{ pillar['netsensia']['admin_username'] }}
    - createhome: True
    - groups:
      - {{ pillar['netsensia']['admin_groupname'] }}
    - require:
      - group: {{ pillar['netsensia']['admin_groupname'] }}
      
admin_login_key:
  file:
    - managed
    - name: /home/{{ pillar['netsensia']['admin_username'] }}/.ssh/authorized_keys
    - contents_pillar: netsensia:admin_key
    - user: {{ pillar['netsensia']['admin_username'] }}
    - group: {{ pillar['netsensia']['admin_groupname'] }}
    - mode: 400
    - require:
      - file: admin_ssh_directory
    
admin_ssh_directory:
  file.directory:
    - name: /home/{{ pillar['netsensia']['admin_username'] }}/.ssh
    - user: {{ pillar['netsensia']['admin_username'] }}
    - group: {{ pillar['netsensia']['admin_groupname'] }}
    - mode: 755
    - makedirs: True

Europe/London:
  timezone.system:
    - utc: True
  cmd.run:
    - name: ntpdate pool.ntp.org
    - require:
      - timezone: Europe/London
      

    