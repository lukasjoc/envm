# envm

> my (now **pluggabe**) hacky environment manager

Why is it now pluggable?:
---
- it's cool
- it's more powerful too
- it's fun

What to write in?
---
- shell/POSIX
- python
- binary
- any script-ish thing really that has a valid shabang
  ``eg. #!/usr/bin/node`` or similar would also work

Guidelines for writing a compatible plugin:
---
- put your plugin into this directory `$XDG_CONFIG_HOME/envm/plugs`
- can be a shell script with functions but these will not be sourced
  so the script must to the work if neccessary
- plugin needs a valid shabang line that points to the interpreter
- can be any ``ELF, Mach-O`` etc. executable
- make it executable by using ``chmod u+x``
- See some exampels under ``./examples``

