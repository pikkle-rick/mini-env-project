# mini-env-project
Contains the code used while establishing the mini environment project.

## Setup Users
Created two helper scripts to perform the repeatbale actions `copyFiles.sh` and `userSetup.sh`

`copyFiles.sh`: Copies the public key file and the userSetup.sh script to the remote hosts listed in the `hosts` file and runs the `userSetup.sh` script on the remote host.
    Usage: <ssh_user> <hosts_file> <path_to_public_key>

`userSetup.sh`: Creates the `expensify` user, adds sudo and sets the authorized_keys file.

`hosts`: Text file containing a list of IPs seperated by newlines.

## Install Nagios
Installed Nagios on 34.220.36.87
Used documentation from [Nagios](https://support.nagios.com/kb/article/nagios-core-installing-nagios-core-from-source-96.html#Ubuntu)
 - User created nagiosadmin:nagiosadmin
 - Access via http://34.220.36.87/nagios


## Notes
 - In email Ubuntu version referenced was 20.04, actual version was 24.X


## References
https://support.nagios.com/kb/article/nagios-core-installing-nagios-core-from-source-96.html#Ubuntu
