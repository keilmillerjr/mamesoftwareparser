# MAME Software Parser

by Keil Miller Jr

[http://keilmillerjr.com](http://keilmillerjr.com)

## DESCRIPTION:

MAME Software Parser is a ruby script to help you set up a MAME machine dedicated to a particular driver. You can use it to copy roms or extra files that match a particular driver from your full romset and extras to your new dedicated machine.

## Software List:

MAME Software Parser requires a software list file to be generated from the MAME binary.

    mame -listsoftware drivername >drivername.xml
  
## Usage

    mamesoftwareparser.rb SOFTWARELIST.XML [OPTIONS]
        -s, --source SOURCE              Source Folder
        -d, --destination DESTINATION    Destination Folder
        -n, --noclones                   No Clones
        -h, --help                       Displays Help

Passing SOFTWARELIST.XML without any options will print a list of drivers and roms from the xml file.

Passing the -s option will run an audit on the source folder, printing matching and missing files.

Passing -s and -d will copy files with the same base name as the drivers and roms from the source folder to the destination folder.

Pass the -n option will not include clones when running an audit or copying files.

## Contribute

Feel free to fork this repo and create a pull request.
