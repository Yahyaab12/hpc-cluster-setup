# hpc-cluster-setup

# Setting Up an HPC Cluster Using OpenHPC

This documentation outlines the steps to set up a High-Performance Computing (HPC) cluster using OpenHPC, Slurm for scheduling, and OnDemand for the API.

## Architecture

- **Login Nodes:** One or two nodes used by users for accessing the cluster.
- **Master Nodes:** One or two nodes used by administrators for installing packages and managing the cluster.
- **Compute Nodes:** Nodes used to run calculations.

## SMS Configuration

### Hostname and IP Configuration
```plaintext
Hostname: sms-host
IP (private/internal): 10.10.10.10/24
IP (public): NAT
``` 
## Prepare SMS Host Parameters

### Add sms hostname and ip to /etc/hosts 
![Description](images/1.png)

### Disabling Firewall
![Description](images/3.png)

## Enable OpenHPC Components

### Installing the ohpc repository
![Description](images/4.png)
### Installing the epel repository
![Description](images/5.png)
### Installing the xCAT repository
![Description](images/7.png)
![Description](images/8.png)
### Installing base package for ohpc
![Description](images/6.png)
### Installing xCAT provisioning system
![Description](images/9.png)