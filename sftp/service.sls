# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "sftp/map.jinja" import sftp with context %}

sftp-service:
  service.running:
    - name: {{ sftp.service.name }}
    - enable: True
