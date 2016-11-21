runit:
  pkg.installed

runsvdir:
  service.running:
    - enable: True
    - reload: True

/var/service/web2py:
  file.recurse:
    - source: salt://runit/web2py
    - makedirs: True
    - include_empty: True
    - user: root
    - group: nobody
    - file_mode: 755
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode
