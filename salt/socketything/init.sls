{% set app = pillar['socketything'] %}

/opt/apps/socketything/current:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true

/opt/apps/socketything/current/socketything:
  file.managed:
    - source: {{ app['release_url'] }}
    - source_hash: {{ app['release_url'] }}.sha256
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - file: /opt/apps/socketything/current

/etc/socketything.env:
  file.managed:
    - contents: |
        {{ app['environment'] | trim | indent(8) }}
        SECRET_KEY_BASE={{ app['key_base'] | trim }}
    - user: root
    - group: root
    - mode: '0600'
    - show_changes: false

/etc/systemd/system/socketything.service:
  file.managed:
    - source: salt://socketything/files/socketything.service
    - user: root
    - group: root
    - mode: '0644'

reload-systemd-for-socketything:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/socketything.service

/etc/caddy/apps/socketything.caddy:
  file.managed:
    - source: salt://socketything/files/socketything.caddy
    - user: root
    - group: root
    - mode: '0644'

caddy.service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: /etc/caddy/apps/socketything.caddy

socketything.service:
  service.running:
    - enable: true
    - watch:
      - file: /opt/apps/socketything/current/socketything
      - file: /etc/socketything.env
      - file: /etc/systemd/system/socketything.service
    - require:
      - cmd: reload-systemd-for-socketything

verify-socketything-health:
  cmd.run:
    - name: curl --fail --silent --show-error --retry 10 --retry-delay 1 http://127.0.0.1:4000/
    - onchanges:
      - file: /opt/apps/socketything/current/socketything
      - file: /etc/socketything.env
      - file: /etc/systemd/system/socketything.service
    - require:
      - service: socketything.service
