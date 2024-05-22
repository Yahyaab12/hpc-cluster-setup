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

### Disabling SELINUXTYPE
```plaintext
You don't necessarily have to disable SELinuxType to use OpenHPC, but there might be compatibility challenges. OpenHPC applications might require access to system resources or use system calls in a way that conflicts with SELinux's default security policies. These conflicts can manifest as permission errors or unexpected behavior when running OpenHPC workloads.
```
![Description](images/2.png)