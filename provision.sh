#!/bin/bash

# Provisioning script for Vagrant
# Set environment variables
. /vagrant/setenv.c
sudo -s 
# Update /etc/hosts
echo "${sms_ip} ${sms_name}" >> /etc/hosts

# Disable and stop firewalld
systemctl disable firewalld
systemctl stop firewalld
yum -y install ntp
echo "server ${ntp_server}" >> /etc/ntp.conf

# Install OpenHPC and EPEL release
yum -y install http://build.openhpc.community/OpenHPC:/1.3/CentOS_7/x86_64/ohpc-release-1.3-1.el7.x86_64.rpm
yum -y install epel-release
yum -y install ohpc-base
yum -y install yum-utils

# Download and configure xCAT repository files
wget -P /etc/yum.repos.d http://xcat.org/files/xcat/repos/yum/latest/xcat-core/xcat-core.repo
wget -P /etc/yum.repos.d http://xcat.org/files/xcat/repos/yum/xcat-dep/rh7/x86_64/xcat-dep.repo

# Install xCAT
yum -y install xCAT
. /etc/profile.d/xcat.sh

# Configure network interface
ifconfig ${sms_eth_internal} ${sms_ip} netmask ${internal_netmask} up

# Set DHCP interfaces for xCAT
chdef -t site dhcpinterfaces="xcatmn|${sms_eth_internal}"

# Install Slurm
yum -y install ohpc-slurm-server

# Configure Slurm
perl -pi -e "s/ControlMachine=\S+/ControlMachine=${sms_name}/" /etc/slurm/slurm.conf

cd /vagrant

copycds CentOS-7-x86_64-DVD-1908.iso

export CHROOT=/install/netboot/centos7.7/x86_64/compute/rootimg

genimage centos7.7-x86_64-netboot-compute

yum-config-manager --installroot=$CHROOT --enable base

cp /etc/yum.repos.d/OpenHPC.repo $CHROOT/etc/yum.repos.d

cp /etc/yum.repos.d/epel.repo $CHROOT/etc/yum.repos.d

yum -y --installroot=$CHROOT install ohpc-base-compute

yum -y --installroot=$CHROOT install ohpc-slurm-client

yum -y --installroot=$CHROOT install kernel

echo "${sms_ip}:/home /home nfs nfsver=3, nodev, nosuid 00" >> $CHROOT/etc/fstab

echo "/home *(rw,no_subtree_check, fsid=10,no_root_squash)" >> /etc/exports

echo "/opt/ohpc/pub *(ro, no_subtree_check, fsid=11)" >>/etc/exports

exportfs -a

systemctl restart nfs-server

systemctl enable nfs-server

echo "account required pam_slurm.so" >> $CHROOT/etc/pam.d/sshd

tail $CHROOT/etc/pam.d/sshd

yum -y install nhc-ohpc

yum -y --installroot=$CHROOT install nhc-ohpc

echo "HealthCheckProgram=/usr/sbin/nhc" >>/etc/slurm/slurm.conf

echo "HealthCheckInterval=300" >>/etc/slurm/slurm.conf

mkdir -p /install/custom/netboot

chdef -t osimage -o centos7.7-x86_64-netboot-compute synclists="/install/custom/netboot/compute.synclist"

echo "/etc/passwd -> /etc/passwd" > /install/custom/netboot/compute.synclist

echo "/etc/group -> /etc/group" >> /install/custom/netboot/compute.synclist

echo "/etc/shadow -> /etc/shadow" >> /install/custom/netboot/compute.synclist

echo "/etc/slurm/slurm.conf -> /etc/slurm/slurm.conf">> /install/custom/netboot/compute.synclist

echo "/etc/munge/munge.key -> /etc/munge/munge.key" >> /install/custom/netboot/compute.synclist

packimage centos7.7-x86_64-netboot-compute

