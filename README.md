# envm

> the hacky environment manager, I use to learn and improve my bashing skills ;) 

## Setup: ``git clone git@github.com:lukasjoc/envm.git ~/.envm``

## SYNOPSIS:
- ``$envm`` => Path of the envm repository on your system only in ``~/.envm``
- ``$envm_wdir`` => Path to your working dir. The place where the magic happens
- ``$envm_auto_update_days`` => if >= 1 update is enabled

# Folder Structure:
```
├── LICENSE # MIT License
├── README.md
├── bin
│   └── free # compiled software or other scripts
├── envm # entry point and loader script
└── scripts
    ├── aliases # inits aliases
    ├── build # defines some functions to build various stuff
    ├── envm-tools # nitty-gritty of envm
    ├── functions # helpfull function definitions
    ├── osx # osx only functions for brew and finder
    ├── prompt # define promt with git functionality
    └── today # todo procedure command without overhead

```

[lukasjoc](https://lukasjoc.com), 2020
