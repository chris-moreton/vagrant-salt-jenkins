include:
  - ruby
  - dashing
  - jenkins.dashboard.apache
  - node
  - jenkins.dashboard.supervisor
  
create_dashboard_project:
  cmd.run:
    - unless: ls /srv/dashboard
    - name: dashing new dashboard
    - cwd: /srv
    - require:
      - gem: dashing
      
bundle_dashboard:
  cmd.run:
    - name: bundle
    - cwd: /srv/dashboard
    - require:
      - cmd: create_dashboard_project
      - pkg: bundler
