{% set node = pillar.get('node', {}) -%}
{% set version = node.get('version', '0.10.26') -%}
{% set checksum = node.get('checksum', '2340ec2dce1794f1ca1c685b56840dd515a271b2') -%}
{% set make_jobs = node.get('make_jobs', '1') -%}
git_packages:
  pkg.installed:
    - names:
      - libssl-dev
      - git
      - pkg-config
      - build-essential
      - curl
      - gcc
      - g++
      - checkinstall

## Get Node
get-node:
  file.managed:
    - name: /usr/src/node-v{{ version }}.tar.gz
    - source: http://nodejs.org/dist/v{{ version }}/node-v{{ version }}.tar.gz
    - source_hash: sha1={{ checksum }}
    - require:
      - pkg: git_packages
  cmd.wait:
    - cwd: /usr/src
    - names:
      - tar -zxvf node-v{{ version }}.tar.gz
    - watch:
      - file: /usr/src/node-v{{ version }}.tar.gz

make-node:
  cmd.wait:
    - cwd: /usr/src/node-v{{ version }}
    - names:
      - ./configure
      - make --jobs={{ make_jobs }}
      - checkinstall --install=yes --pkgname=nodejs --pkgversion "{{ version }}" --default
    - watch:
      - cmd: get-node