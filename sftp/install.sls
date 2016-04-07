# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "sftp/map.jinja" import sftp with context %}

sftp-pkg:
  pkg.installed:
    - name: {{ sftp.pkg }}
