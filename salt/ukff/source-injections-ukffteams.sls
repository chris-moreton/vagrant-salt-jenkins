{% set repo = 'ukffteams' %}

{% if 'jenkins' in grains['id'] %}

{% set sourceCodeRoot = '/var/lib/jenkins/jobs/' + repo + '/workspace' %}

{% else %}

include:
  - ukff.source

{% if 'jenkins' in grains['id'] %}
{% set sourceCodeRoot = '/var/lib/jenkins/jobs/' + repo + '/dexysden/workspace' %}
{% else %}
{% set sourceCodeRoot = '/var/www/' + repo %}
{% endif %}

{{ sourceCodeRoot}}/application.php:
  file:
    - managed
    - source: file://{{ sourceCodeRoot}}/application.php.jinja
    - template: jinja
    - require:
      - git: clone_{{ repo }}
      
{{ sourceCodeRoot}}/installedit.php:
  file:
    - managed
    - source: file://{{ sourceCodeRoot}}/installedit.php.jinja
    - template: jinja
    - require:
      - git: clone_{{ repo }}
