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
#### The file setenv.c contains the variables for the env 

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
### Enabling xcat tools for use in current shell
![Description](images/10.png)
### Enabling support for local provisioning using a private interface and register this network interface with xCAT
![Description](images/11.png)
![Description](images/12.png)

## Add resource management services on master node

### Installing SLURM server meta-package
![Description](images/13.png)
### Identify resource manager hostname on master host
![Description](images/14.png)

## Resource Management Slurm

### nano /etc/slurm/slurm.conf
![Description](images/15.png)
#### The line defines a set of compute nodes that will be managed by Slurm, the workload manager.
#### NodeName=c[1-4]: This specifies the names of the compute nodes that this entry applies to. The c[1-4] part uses a wildcard pattern to match nodes named c1, c2, c3, and c4.
#### Sockets=2: This indicates that each compute node has 2 CPU sockets.
#### CoresPerSocket=8: This indicates that each CPU socket on the compute nodes has 8 cores.
#### ThreadsPerCore=2: This defines the number of hardware threads per CPU core on the nodes. In this case, it's set to 2, which means hyper-threading is enabled.
#### State=UNKNOWN:  This shows the current state of the compute nodes as reported by Slurm. In this case, "UNKNOWN" suggests that Slurm hasn't been able to communicate with the nodes or determine their status yet.

#### In this virtual lab, there are only two compute nodes that will be used. The names of the compute nodes are compute00 and compute01. Each compute node has 1 socket, 2 cores per socket, and 1 thread per core.
![Description](images/16.png)

## Define compute image for provisioning

#### copycds is used to copy the contents of Distribution CDs/DVDs or Service Pack CDs/DVDs to a specific directory on the xCAT cluster's head node.
![Description](images/17.png)