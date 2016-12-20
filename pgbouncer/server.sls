{%- from "pgbouncer/map.jinja" import server with context %}
{%- if server.enabled %}

{%- if server.source.engine == "tar" %}

pgbouncer-pkgs-purged:
  pkg.purged:
    - pkgs:
      - pgbouncer

pgbouncer-pkgs:
  pkg.installed:
    - pkgs:
      - libevent-dev
      - gcc

pgbouncer-install:
  cmd.run:
    - name: |
        cd /tmp
        wget -c {{ server.source.address }}
        tar xzf pgbouncer-{{ server.version }}.tar.gz
        cd pgbouncer-{{ server.version }}
        ./configure --prefix=/usr/local --with-libevent=/usr/lib
        make
        make install
    - cwd: /tmp
    - shell: /bin/bash
    - timeout: 300
    - unless: test -d /tmp/pgbouncer-{{ server.version }}
    - require:
      - pkg: pgbouncer-pkgs
      - pkg: pgbouncer-pkgs-purged
{%- else %}
pgbouncer-pkgs:
  pkg.installed:
    - pkgs:
      - pgbouncer
      - python-psycopg2
{%- endif %}

pgbouncer_user:
  user.present:
  - name: pgbouncer
  - shell: /bin/bash
  - system: true

pgbouncer_dirs:
  file.directory:
  - names:
    - /var/run/pgbouncer/
    - /etc/pgbouncer/
    - /var/log/pgbouncer/
  - makedirs: true
  - group: pgbouncer
  - user: pgbouncer
  - require:
    - user: pgbouncer_user

/etc/pgbouncer/userlist.txt:
  file.managed:
    - source: salt://pgbouncer/files/userlist.txt
    - user: pgbouncer
    - group: pgbouncer
    - template: jinja
    - mode: 640
    - require:
      - pkg: pgbouncer-pkgs

/var/log/pgbouncer.log:
  file.managed:
    - user: pgbouncer
    - group: pgbouncer
    - mode: 640
    - require:
      - user: pgbouncer_user

/etc/pgbouncer/pgbouncer.ini:
  file.managed:
    - source: salt://pgbouncer/files/pgbouncer.conf
    - template: jinja
    - user: pgbouncer
    - group: pgbouncer
    - mode: 640
    - require:
      - user: pgbouncer_user

{%- endif %}
