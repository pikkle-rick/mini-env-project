# mini-env-project
Contains the code used while establishing the mini environment project.

## Design Decisions
 - Repeatability isn't in the requirements and this is a small task. Leaning not to use Ansible because it wouldn't be worth the additional time based on requirements.
 - Using Apache for the webservers, extremely popular, free, and already is used for Nagios.


## Setup Users
1. Created two helper scripts to automate some of the actions `copyFiles.sh` and `userSetup.sh`.

`copyFiles.sh`: Copies the public key file and the userSetup.sh script to the remote hosts listed in the `hosts` file and runs the `userSetup.sh` script on the remote host.  
  - Usage: <ssh_user> <hosts_file> <path_to_public_key>

`userSetup.sh`: Creates the `expensify` user, adds sudo and sets the authorized_keys file.

`hosts`: Text file containing a list of IPs seperated by newlines.

2. Created an ssh key for the `ubuntu` user on the load balancer node.
3. Distributed the newly created key to remaining hosts allowing ssh access from the load balancer.

## Install Nagios
Installed Nagios on 34.220.36.87
Used documentation from [Nagios](https://support.nagios.com/kb/article/nagios-core-installing-nagios-core-from-source-96.html#Ubuntu)
 - User created nagiosadmin:nagiosadmin
 - Access via http://34.220.36.87/nagios

## Setup Web Server
1. Installed Apache `apt install apache2`


## Notes
 - Updated authorized_keys for `ubuntu` to use a different computer. Original SSH key was on for my desktop.
 - In email Ubuntu version referenced was 20.04, actual version was 24.X
 - I chose the load balancer host based on the IP address. The 54.X.X.X is on a completely different network than the other 3 hosts. The other 3 hosts choices were random for the webservers and monitoring host.

## Challenges
- Nagios installation instructions were giving errors when installing packages. I was using the instructions for Ubuntu 20.X.
  - Verified host OS version using `lsb_release -a`, used the correct instructions for current OS 24.X
- I couldn't reach nagios so I thought something was wrong with the install, really I just couldn't read lol.
  - Verified port 80 was open/listening with netstat
  - Realized I was trying to access nagios on the wrong host

## Test Plan

## References
https://support.nagios.com/kb/article/nagios-core-installing-nagios-core-from-source-96.html#Ubuntu
