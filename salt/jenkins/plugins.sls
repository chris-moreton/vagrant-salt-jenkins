include:
  - jenkins
  - tools

update.jenkins.update.centre:
  cmd.run:
    - name: "sleep 15 && curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack"
    - require:
      - pkg: tools
      - service: jenkins
      
{% for pluginName in ['git', 'postbuild-task', 'greenballs', 'publish-over-ssh'] %}

jenkins.plugin.{{ pluginName }}:
  cmd.run:
    - name: java -jar /usr/bin/jenkins-cli.jar -s http://localhost:8080 install-plugin {{ pluginName }}
    - watch_in:
      - module: jenkins-restart
    - require:
      - pkg: jenkins
      - file: /usr/bin/jenkins-cli.jar
      - cmd: update.jenkins.update.centre

{% endfor %}
