{% set repo = 'dexysden' %}

{% if 'jenkins' in grains['id'] %}

{% set sourceCodeRoot = '/var/lib/jenkins/jobs/' + repo + '/workspace' %}

{% else %}

include:
  - ukff.source
 
{% if 'jenkins' in grains['id'] %}
{% set sourceCodeRoot = '/var/lib/jenkins/jobs/' + repo + '/workspace' %}
{% else %}
{% set sourceCodeRoot = '/var/www/' + repo %}
{% endif %}

{{ sourceCodeRoot }}/wp-config.php:
  file:
    - managed
    - source: file://{{ sourceCodeRoot }}/wp-config.php.jinja
    - template: jinja
    - require:
      - git: clone_{{ repo }}