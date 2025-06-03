#!/usr/bin/env python3

import sys
import subprocess

BACKENDS_FILE = '/usr/local/nagios/etc/hosts.txt'

def is_host_up(host):
    """
    Check if a given host is reachable by sending a single ping.

    Args:
        host (str): The hostname or IP address to ping.

    Returns:
        bool: True if the host responds to the ping, False if it does not.

    Raises:
        None: This function internally handles subprocess.CalledProcessError
              and does not propagate exceptions; it simply returns False
              if the ping fails.
    """
    try:
        subprocess.check_output(['ping', '-c', '1', '-W', '1', host], stderr=subprocess.STDOUT)
        return True
    except subprocess.CalledProcessError:
        return False

def main():
    """
    Main function to check the status of backend servers listed in a file.

    Reads the list of backend servers from BACKENDS_FILE and pings each one
    to determine if they are reachable. Based on the number of unreachable servers,
    it prints an appropriate Nagios-style status message and exits with a corresponding code.

    Inputs:
        None (but relies on the global BACKENDS_FILE variable and the is_host_up() function).

    Outputs:
        Prints status messages to stdout:
            - "OK" if all servers are up.
            - "WARNING" if one server is down.
            - "CRITICAL" if all servers are down.

    Exit Codes:
        0: OK (all servers online).
        1: WARNING (one server offline).
        2: CRITICAL (all servers offline).
        3: UNKNOWN (error reading the backend file).

    Raises:
        None: Exceptions (like file read errors) are caught and handled internally.
    """
    try:
        with open(BACKENDS_FILE, 'r') as f:
            servers = [line.strip() for line in f if line.strip()]
    except Exception as e:
        print(f"UNKNOWN: Could not read backend file: {e}")
        sys.exit(3)

    down_servers = [s for s in servers if not is_host_up(s)]

    if len(down_servers) == 0:
        print("OK: All backend servers are online.")
        sys.exit(0)
    elif len(down_servers) == 1:
        print(f"WARNING: One backend server offline: {down_servers[0]}")
        sys.exit(1)
    else:
        print(f"CRITICAL: All backend servers are offline: {', '.join(down_servers)}")
        sys.exit(2)

if __name__ == "__main__":
    main()
