include:
  - node
  
npm install -g bower:
  cmd.run:
    - cwd: /var/www/directorzone/public
    - require:
      - sls: node
