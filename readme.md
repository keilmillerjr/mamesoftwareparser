# MAME Software Parser

*v.01*

by Keil Miller Jr

[http://keilmillerjr.com](http://keilmillerjr.com)

## DESCRIPTION:

MAME Software Parser is a ruby script to help you set up a MAME machine dedicated to a particular driver. You can use it to copy roms or extra files that match a particular driver from your full romset and extras to your new dedicated machine.

## Software List:

MAME Software Parser requires a software list file to be generated from the MAME binary.

    mame -listsoftware drivername >drivername.xml
  
## Usage

### Help

    ruby mamesoftwareparser.rb --help

### Drivers

Print driver list in terminal window.

    ruby mamesoftwareparser.rb drivers [drivername.xml]

### Roms

Print rom list in terminal window.

    ruby mamesoftwareparser.rb roms [drivername.xml]

### Export

Copy files with same base name as drivers and roms from source to destination.

    ruby mamesoftwareparser.rb export [drivername.xml] [source] [destination]

*Shorthand commands for help (nil), drivers (d), roms (r), and export (e) may be used.*

## Contribute

Feel free to fork this repo and create a pull request.
