requirements:
  pkg.installed:
    - pkgs:
      - openjdk-7-jre-headless
      - curl

elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.deb
    - require:
      - pkg: requirements
  service:
    - running
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/security/limits.conf

/etc/default/elasticsearch:
  file:
    - sed
    - before: '#ES_HEAP_SIZE=2g'
    - after: ES_HEAP_SIZE={{ (grains['mem_total']/2)|round|int }}m
    - require:
      - pkg: elasticsearch

/etc/elasticsearch/elasticsearch.yml:
  file:
    - unless: grep "ElasticSearch Configuration Example" /etc/elasticsearch/elasticsearch.yml
    - managed
    - source: salt://files/elasticsearch.yml
    - template: jinja
    - require:
      - pkg: elasticsearch

/etc/pam.d/su:
  file:
    - sed
    - before: '# session    required   pam_limits.so'
    - after: 'session    required   pam_limits.so'

/etc/security/limits.conf:
  file:
    - append
    - text:
      - elasticsearch soft nofile 60000
      - elasticsearch hard nofile 60000