# Test Plan

1. Test SSH (verifies 6.1, 6.2 and 6.3):
   1. From your host attempt to:
      1. `ssh user@34.210.75.57` : expect a failure
      2. `ssh user@34.220.22.168` : expect a failure
      3. `ssh user@54.212.120.113` : expect a failure
      4. `ssh user@34.220.36.87` : expect success
   2. From the monitoring host attempt to:
      1. `ssh user@34.210.75.57` : expect success
      2. `ssh user@34.220.22.168` : expect success
      3. `ssh user@54.212.120.113` : expect success
2. Verify `expensify` user (verifies 5.1, 5.2 and 5.3)
   1. Log into monitoring host: `ssh expensify@34.220.36.87`
   2. Confirm passwordless sudo: `sudo ls`
   3. Repeat steps 1 and 2 for remaining hosts. (5.1, 5.2, 5.3)
3. Load Balancer (verifies requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, and 3.7)
   1. Verify Load Balancer is routing traffic to web-servers <http://54.212.120.113:60015>
      1. Run the `load-balance-failover` test: `ansible-playbook -i hosts.ini tests/load-balance-failover.yml`
         1. Note since we are not using cookies as the stickiness setting it might appear that traffic is being routed round robin in the return statements but that just has to do with the hasing HAProxy does. See the challenges section for more details. You can optionally just use your web browser and refresh the page to verify you are staying on one back end host.
4. Verify Nagios (verifies 4.1, 4.2, 4.3, 4.4, and 4.5)
   1. Verify is running and accessible: <http://34.220.36.87/nagios> (4.1)
      1. Login with credentials: nagiosadmin/nagiosadmin (4.1)
      2. Navigate to Hosts, verify all hosts are displayed (4.2)
      3. Navigate to Services, verify all services are displayed (4.3 - 4.5)
         1. Verify "Backend Server Check is displayed"
         2. Run the ansible playbook below and then force a Nagios schedule of the custom check.
            - `ansible-playbook -i hosts.ini tests/nagios-custom-script-check.yml`
