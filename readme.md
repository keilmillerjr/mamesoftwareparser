# MAME Software Parser

*v.02*

by Keil Miller Jr

[http://keilmillerjr.com](http://keilmillerjr.com)

## DESCRIPTION:

MAME Software Parser is a ruby script to help you set up a MAME machine dedicated to a particular driver. You can use it to copy roms or extra files that match a particular driver from your full romset and extras to your new dedicated machine.

## Software List:

MAME Software Parser requires a software list file to be generated from the MAME binary.

    mame -listsoftware drivername >drivername.xml
  
## Usage

    mamesoftwareparser.rb SOFTWARELIST.XML [OPTIONS]
        -n, --noclones                   No Clones
        -s, --source SOURCE              Source Folder
        -d, --destination DESTINATION    Destination Folder
        -h, --help                       Displays Help

Passing -s and -d will make the script copy files with the same base name as the drivers and roms from source to destination. Otherwise, the romset will be displayed as a list in the terminal.

## Contribute

Feel free to fork this repo and create a pull request.
