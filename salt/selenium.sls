firefox:
  pkg.latest:
    - refresh: True
    - skip_verify: True

xvfb:
  pkg.latest
      
/usr/bin/selenium-server.jar:
  file.managed:
    - source: https://dl.dropboxusercontent.com/u/63777076/VM/selenium-server-standalone-2.41.0.jar
    - mode: 777
    - source_hash: sha256=dae2fb7fd26164e1675a316615c7e013aad118969fdc24091412d92e334594c1

openjdk-7-jre-headless:
  pkg:
    - installed
