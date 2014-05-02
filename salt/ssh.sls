ssh:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://files/sshd_config.jinja
    - template: jinja
    