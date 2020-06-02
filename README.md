# envm

> env M anager keeps track of cool functions and aliases to increase your productivity and FOCUS.. Try it.

```
                   __  __
  ___ _ ____   __ |  \/  |   __ _ _ __   __ _  __ _  ___ _ __
 / _ \ '_ \ \ / / | |\/| |  / _` | '_ \ / _` |/ _` |/ _ \ '__|
|  __/ | | \ V /  | |  | | | (_| | | | | (_| | (_| |  __/ | _ _ _
 \___|_| |_|\_/   |_|  |_|  \__,_|_| |_|\__,_|\__, |\___|_|(_|_|_)
                                              |___/

 _   _      _ _            _            _                     _       
| | | | ___| | | ___      (_) ___   ___| |__   __ _ _ __ ___ | |_   _ 
| |_| |/ _ \ | |/ _ \     | |/ _ \ / __| '_ \ / _` | '_ ` _ \| | | | |
|  _  |  __/ | | (_) |    | | (_) | (__| | | | (_| | | | | | | | |_| |
|_| |_|\___|_|_|\___( )  _/ |\___/ \___|_| |_|\__,_|_| |_| |_|_|\__,_|
                    |/  |__/                                          
                    'c.          jochamlu@kaizen.fritz.box 
                 ,xNMM.          ------------------------- 
               .OMMMMo           OS: macOS Catalina 10.15.4 19E287 x86_64 
               OMMM0,            Host: MacBookPro14,3 
     .;loddo:' loolloddol;.      Kernel: 19.4.0 
   cKMMMMMMMMMMNWMMMMMMMMMM0:    Uptime: 13 days, 21 hours, 2 mins 
 .KMMMMMMMMMMMMMMMMMMMMMMMWd.    Shell: bash 5.0.17 
 XMMMMMMMMMMMMMMMMMMMMMMMX.      Terminal: Apple_Terminal 
;MMMMMMMMMMMMMMMMMMMMMMMM:       Terminal Font: Monaco 
:MMMMMMMMMMMMMMMMMMMMMMMM:       CPU: Intel i7-7700HQ (8) @ 2.80GHz 
.MMMMMMMMMMMMMMMMMMMMMMMMX.      GPU: Intel HD Graphics 630, Radeon Pro 555 
 kMMMMMMMMMMMMMMMMMMMMMMMMWd.    Memory: 7437MiB / 16384MiB 
 .XMMMMMMMMMMMMMMMMMMMMMMMMMMk   GPU Driver: macOS Default Graphics Driver 
  .XMMMMMMMMMMMMMMMMMMMMMMMMK.   CPU Usage: 6% 
    kMMMMMMMMMMMMMMMMMMMMMMd     Disk (/): 10G / 233G (6%) 
     ;KMMMMMMMWXXWMMMMMMMk.      Battery: 100% 
       .cooc,.    .,coo:.        Local IP: 192.168.178.26 
                                 Public IP: 2001:a61:1242:d401:285d:9e2d:8003:b69d 

                                                         
                                                         
Bing's Rule:
	Don't try to stem the tide -- move the beach.
```

## SYNOPSIS:
- ``$envm`` => Path of the envm repository on your system only in ``~/.envm``
- ``$envm_wdir`` => Path to your working dir. The place where the magic happens
- ``$envm_auto_update_days`` => if >= 1 update is enabled

## Setup/Installation:
- Clone: ``git@github.com:lukasjoc/envm.git ~/.envm``
- ``./setup.sh`` to get /usr/local/bin/envm utility
- Restart terminal or refresh $SHELL with ``exec $SHELL -l``
- For example bash-files, vim setup and more visit [lukasjoc/dotfiles](https://github.com/lukasjoc/dotfiles)
- also check if you have setup the ```$EDITOR``` variable

[lukasjoc](https://lukasjoc.com), 2020
