# hpc-cluster-setup

# Setting Up an HPC Cluster Using OpenHPC

This document outlines the steps to set up a High-Performance Computing (HPC) cluster using OpenHPC, Slurm for scheduling, and OnDemand for the API.

This document involves deploying an OpenHPC-ready Virtualbox VM using Vagrant.
the Vagrant deployment should allow for the same results on any other hypervisor of your preference (for example,
VMware).
- **pre-installed packages**
tmux & screen
vim
git
- **input.local (from OpenHPC) with custom edits which do not need to be replicated**
- **setenv.c** The setenv.c file contains predefined variables that will be used to configure the Master node. 
![Description](images/setenv.png)

## Architecture
![Description](images/env.png)

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
![Description](images/18.png)

### Save chroot location for compute image
![Description](images/19.png)

### Build initial chroot image
![Description](images/20.png)

### Adding openHPC Component
#### First, we need to enable the necessary package repositories for use inside the CHROOT.
![Description](images/21.png)

#### Next, we need to copy the local package repositories inside the CHROOT.
![Description](images/22.png)

#### Now we need to install the base compute packages on the CHROOT.
![Description](images/23.png)
![Description](images/24.png)

#### Add NFS client mount of /home and /opt/ohpc.pub to base image.
![Description](images/25.png)

#### Export  /home and OpenHPC public packages from master server.
![Description](images/26.png)

#### Enable ssh control via resource manager.
![Description](images/27.png)

## Add NHC

### Install NHC on master and compute node.
![Description](images/28.png)

### Register as SLURM’s health check program.
![Description](images/29.png)

## Identify files for synchronization xCAT
#### The xCAT system includes functionality to synchronize files located on the SMS server for distribution to
#### managed hosts. This is one way to distribute user credentials to compute nodes (alternatively, you may
#### prefer to use a central authentication service like LDAP). To import local file-based credentials, issue the following to enable the synclist feature and register user credential files

### Define path for xCAT synclist file. 
![Description](images/30.png)

### Add desired credential files to synclist
![Description](images/31.png)
#### Similarly, to import the global Slurm configuration file and the cryptographic key that is required by the
#### munge authentication library to be available on every host in the resource management pool, issue the following
![Description](images/32.png)

## Finalizing provisioning configuration
![Description](images/33.png)

## Add Compute Nodes into xCAT Database
#### Next, we add compute nodes and define their properties as objects in xCAT database. These hosts are grouped logically into a group named compute to facilitate group-level commands used later in the recipe. Note the use of variable names for the desired compute hostnames, node IPs, MAC addresses, and BMC login credentials, which should be modified to accommodate local settings and hardware. To enable serial console access via xCAT, serialport and serialspeed properties are also defined.

### Define nodes as object on xCAT database.
![Description](images/34.png)

#### With the desired compute nodes and domain identified, the remaining steps in the provisioning configuration process are to define the provisioning mode and image for the compute group and use xCAT commands to complete configuration for network services like DNS and DHCP. These tasks are accomplished as follows:
![Description](images/35.png)
![Description](images/36.png)

### Associate desired provisioning image for computes.
![Description](images/37.png)

### Starting the compute node
![Description](images/38.png)

#### Now the compute00 is up
![Description](images/39.png)

## Resource Manager Startup
#### Services in preparation for running user jobs. Generally, this is a two-step process that requires starting up the controller daemons on the master host and the client daemons on each of the compute hosts. Note that Slurm leverages the use of the munge library to provide authentication services and this daemon also needs to be running on all hosts within the resource management pool. The following commands can be used to startup the necessary services to support resource management under Slurm.

### Start munge and slurm on the master host 
![Description](images/40.png)

### Start slurm clients on compute hosts
![Description](images/41.png)