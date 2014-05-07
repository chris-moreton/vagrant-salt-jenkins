include:
  - ssh

/root/clearcache_watch.sh:
  file.managed:
    - source: salt://files/clearcache_watch.sh
    