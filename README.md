# chip_setup
scripts and files to easily set-up C.H.I.P.

instructions:
- flash the headless44.chp image to C.H.I.P.
- put the rest of the files (either downloading from github, using ftp or some other method) on the /home/chip directory
- become root (e.g. using su)
- make the script executable (chmod +x install_script.sh)
- run the script passing the local network's SSID and PASSWD as arguments (./install_scipt.sh SSID PASSWD)

the script will then install all the necessary files/tools, make all necessary changes, download the inhibition software bundle from github, compile it, and, finally, it will configure C.H.I.P. for automatically running a version of the software once booted. 

**Note that this is a highly experimental setup which might prove buggy and which makes many security compromises. This set-up is primarily meant to be useful in the context of workshops and is distributed as is, with no guarantee that it will be functional or useful in other contexts. 

