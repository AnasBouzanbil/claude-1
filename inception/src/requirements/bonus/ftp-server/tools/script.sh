#!/bin/bash

mkdir -p /var/run/vsftpd/empty
# this step is to create a directory for vsftpd to store its pid file

# Give the user /home/ftp as its home directory

useradd -d /var/www/html/wordpress $FTP_USER

chown -R $FTP_USER:$FTP_USER /var/www/html/wordpress
# This is to change the owner of the home directory of the ftp user to the ftp user itself
# -R means recursive, which means to change the owner of all the files and directories in the home directory of the ftp user

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo $FTP_USER > /etc/vsftpd.userlist

vsftpd /etc/vsftpd.conf