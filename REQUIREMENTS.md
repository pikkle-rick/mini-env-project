# Miniature Infrastructure Environment

This project sets up a self-contained miniature infrastructure environment consisting of four Ubuntu servers with distinct roles. It demonstrates load balancing, service monitoring, secure access, and configuration management. This README outlines the numbered requirements and design objectives.

## 1. Documentation & Process

1.1. Maintain detailed documentation throughout the project.  
1.2. Record all design decisions, implementation steps, and problem-solving strategies.  
1.3. Include explanations for all issues encountered and how they were resolved.

## 2. Web Servers

2.1. Deploy two web servers.  
2.2. Web Server A must serve `index.html` with content `a`.  
2.3. Web Server B must serve `index.html` with content `b`.

## 3. Load Balancer

3.1. Deploy a third server as a load balancer.  
3.2. Load balancer must distribute traffic between Web Server A and Web Server B.  
3.3. Implement session stickiness based on client IP address.  
3.4. Session stickiness must persist unless the original server goes down.  
3.5. Do **not** revert to the original server once it recovers.  
3.6. Forward the original client IP address to backend servers.  
3.7. Forward all ports in the range `60000–65000` to backend servers' port `80`.

## 4. Monitoring (Nagios)

4.1. Deploy a fourth server running Nagios.  
4.2. Configure Nagios to monitor Web Server A, Web Server B, and the Load Balancer.  
4.3. Create a custom Nagios check plugin in Python.  
4.4. Plugin must read a list of backend servers from a file.  
4.5. Plugin must return:

- `WARNING` if one server is offline.
- `CRITICAL` if both servers are offline.

## 5. User Configuration

5.1. Create a user named `testUser` on all servers.  
5.2. Grant `testUser` passwordless sudo access.  
5.3. Install the provided public SSH key in `~/.ssh/authorized_keys`.

## 6. Network Security

6.1. Only one server should have public SSH access.  
6.2. That SSH-accessible server must be able to SSH into the other three servers.  
6.3. Block all unnecessary ports on all servers.
