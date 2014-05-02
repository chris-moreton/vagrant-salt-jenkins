python-setuptools:
  pkg.installed
 
jinja2:
  cmd.run:
    - name: easy_install Jinja2
    - require:
      - pkg: python-setuptools
