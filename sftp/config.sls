# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "sftp/map.jinja" import sftp with context %}

# sftp-config:
#   file.managed:
#     - name: {{ sftp.config }}
#     - source: {{ salt['pillar.get']('sftp:config:sshd_config', 'salt://sftp/files/sshd_config') }}
#     - template: jinja
#     - mode: 644
#     - user: root
#     - group: root
#     - listen_in:
#       - service: sftp-service

sftp-config-replace:
  file.replace:
    - name: {{ sftp.config }}
    - pattern: "Subsystem sftp.*"
    - repl: "Subsystem sftp internal-sftp"

sftp-config-append:
  file.append:
    - name: {{ sftp.config }}
    - text: |
        Match Group filetransfer
            ChrootDirectory %h
            X11Forwarding no
            AllowTcpForwarding no
            ForceCommand internal-sftp

sftp-group:
  group.present:
    - name: filetransfer
    - system: True

{% if sftp.users is defined %}
{% for user, conf in sftp.users.iteritems() %}
sftp-{{ user }}-user:
  user.present:
    - name: {{ user }}
    - password: {{ conf.password }}
    - shell: /bin/false
    - home: /home/{{ user }}
    - groups:
      - filetransfer

sftp-{{ user }}-homedir:
  file.directory:
    - name: /home/{{ user }}
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode


{% if conf.dirs is defined %}
{% for dir in conf.dirs %}
sftp-{{ user }}-dir-{{ dir }}:
  file.directory:
    - name: /home/{{ user }}/{{ dir }}
    - user: {{ user }}
    - group: filetransfer
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
{% endfor %}
{% endif %}

{% endfor %}
{% endif %}
