cron:
  pkg:
    - installed
    - pkgs:
      - cron
  service:
    - running
    - require:
      - pkg: cron

cron-restart:
  module:
    - wait
    - name: service.restart
    - m_name: cron
