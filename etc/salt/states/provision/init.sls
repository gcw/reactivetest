py27-pip:
  pkg.installed

wempy:
  pip.installed:
    - require:
      - pkg: py27-pip

py27-sqlite3:
  pkg.installed
