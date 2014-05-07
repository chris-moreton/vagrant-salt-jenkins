{% set repo = 'ukfootballfinder' %}

{% if 'jenkins' in grains['id'] %}

{% set sourceCodeRoot = '/var/lib/jenkins/jobs/' + repo + '/workspace' %}

{% else %}

include:
  - ukff.source
  
{% set sourceCodeRoot = '/var/www/' + repo %}

{% endif %}

{{ sourceCodeRoot}}/application.php:
  file:
    - managed
    - source: file://{{ sourceCodeRoot}}/application.php.jinja
    - template: jinja
{% if 'jenkins' not in grains['id'] %}
    - require:
      - git: clone_{{ repo }}
{% endif %}
      
{{ sourceCodeRoot}}/installedit.php:
  file:
    - managed
    - source: file://{{ sourceCodeRoot}}/installedit.php.jinja
    - template: jinja
{% if 'jenkins' not in grains['id'] %}
    - require:
      - git: clone_{{ repo }}
{% endif %}

{{pillar['ukff']['selenium-test-root']}}/{{pillar['ukff']['selenium-test-suite']}}:
  file.managed:
    - source: file://{{ sourceCodeRoot }}/tests/suite.html.jinja
    - template: jinja
{% if 'jenkins' not in grains['id'] %}
    - require:
      - git: clone_ukfootballfinder
{% endif %}

{% for testCase in pillar['ukff']['selenium-test-cases'] %}

{{pillar['ukff']['selenium-test-root']}}/{{ testCase }}.html:
  file.managed:
    - source: file://{{ sourceCodeRoot }}/tests/{{ testCase }}.html.jinja
    - template: jinja
{% if 'jenkins' not in grains['id'] %}
    - require:
      - git: clone_ukfootballfinder
{% endif %}
      
{% endfor %}
    
{{pillar['ukff']['selenium-test-root']}}//{{pillar['ukff']['selenium-test-runner']}}:
  file.managed:
    - source: file://{{ sourceCodeRoot }}/tests/run-selenium-suite.sh.jinja
    - template: jinja
    - mode: 777
{% if 'jenkins' not in grains['id'] %}
    - require:
      - git: clone_ukfootballfinder
{% endif %}
