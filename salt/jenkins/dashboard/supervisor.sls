supervisor:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: supervisor
      
/etc/supervisor/conf.d/dashing.conf:
  file.managed:
    - source: salt://files/jenkins/supervisor/dashing.conf
    - require:
      - pkg: supervisor
      
supervisor-restart:
  module:
    - wait
    - name: service.restart
    - m_name: supervisor
    - require:
      - pkg: supervisor