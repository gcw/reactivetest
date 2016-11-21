web2py:
  user.present:
    - shell: /sbin/nologin

/usr/local/web2py:
  file.recurse:
    - source: salt://web2py/base/web2py
    - makedirs: True
    - include_empty: True
    - user: web2py
    - group: nobody
    - file_mode: 700
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode
    
