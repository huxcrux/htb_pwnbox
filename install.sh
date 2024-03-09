#!/bin/bash
#This script is executed every time your instance is spawned.

if [ -z "$USERNAME" ]; then
    USERNAME=realhux
fi
if [ -z "$GITUSER" ]; then
    GITUSER=huxcrux
fi

## SSH Keys
mkdir /home/$USERNAME/.ssh
curl https://github.com/$GITUSER.keys >> /home/$USERNAME/.ssh/authorized_keys

## bash history
sed -i_org 's/HISTSIZE=1000/HISTSIZE=100000/' /home/$USERNAME/.bashrc
sed -i_org 's/HISTFILESIZE=2000/HISTFILESIZE=200000/' /home/$USERNAME/.bashrc

########
######## Download and install common tools
########

TOOLDIR=/home/$USERNAME/tools/
INITDIR=/tmp/init-scripts
mkdir $TOOLDIR

#------tools-in-repo----#
cp -a $INITDIR/tools $TOOLDIR

#--------linpeas--------#
curl -o $TOOLDIR/linpeas.sh https://github.com/carlospolop/PEASS-ng/releases/download/20230731-452f0c44/linpeas.sh
chmod +x $TOOLDIR/linpeas.sh

#--------linenum--------#
curl -o $TOOLDIR/linenum.sh https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
chmod +x $TOOLDIR/linenum.sh 

#--------DockerGraber--------#
# https://github.com/Syzik/DockerRegistryGrabber
#curl -o $TOOLDIR/DockerGraber.py https://raw.githubusercontent.com/Syzik/DockerRegistryGrabber/main/DockerGraber.py
# Skipped for now since own script with JWT support is deployed

#------procyon-decompiler------#
# Decompile java files
# Example: mkdir out && for i in $(find WEB-INF -name \*.class); do java -jar procyon-decompiler-0.6.0.jar $i > out/$(basename -s .class $i).java; done
curl -o $TOOLDIR/procyon-decompiler-0.6.0.jar https://github.com/mstrobel/procyon/releases/download/v0.6.0/procyon-decompiler-0.6.0.jar


#--------GitTools------#
git clone https://github.com/internetwache/GitTools.git $TOOLDIR/GitTools

#--------Updog--------#

sudo pip3 install updog

# updog is an alternative to Python HTTP server

# Host files on port 80:
# $ updog -p 80

#--------pwncat--------#

sudo pip3 install git+https://github.com/calebstewart/pwncat.git

# pwncat gives you better reverse shell

# Start a listener:
# $ pwncat :443

# SSH connection:
# $ pwncat <username>@<remote_ip>

#-----xpra-----#

DEBIAN_FRONTEND=noninteractive sudo apt-get -yq install xpra
