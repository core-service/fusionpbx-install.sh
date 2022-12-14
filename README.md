DIYPBX Changes
--------------------------------------
The configrtaion remains the same as the Fusionpbx Git except for some changes to match our tutorials

Made sure NFTables is Uninstalled and IPTables is installed
Pointed the fusionpbx clone location to the core-service git server
Added our own filewall script

FusionPBX Install
--------------------------------------
A quick install guide & scripts for installing FusionPBX. It is recommended to start with a minimal install of the operating system. Notes on further tweaking your configuration are at end of the file.

## Operating Systems
### Debian
Debian is the preferred operating system by the FreeSWITCH developers. It supports the latest video dependencies and should be used if you want to do video mixing. Download Debian at https://cdimage.debian.org/cdimage/release/current/

```sh
wget -O - https://raw.githubusercontent.com/core-service/fusionpbx-install.sh/master/debian/pre-install.sh | sh;
cd /usr/src/fusionpbx-install.sh/debian && ./install.sh
```

## Security Considerations
Fail2ban is installed and pre-configured for all operating systems this repository works on besides Windows, but the default settings may not be ideal depending on your needs. Please take a look at the jail file (/etc/fail2ban/jail.local on Debian) to configure it to suit your application and security model!


