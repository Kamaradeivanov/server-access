#!/bin/bash

#===================================================================================================================
# Pour installer les clefs sur un serveur voici la commande à saisir :
#   git archive --remote=ssh://git@github.com/kamaradeivanov/server-access.git HEAD sshKey.sh | tar -xO sshKey.sh |sudo bash
#===================================================================================================================

function fatal { echo "$*"; exit 1; }
[ "$(whoami)" != 'root' ] && fatal "Must be root to setup keys"

echo "Ensure sudo is present..."
dpkg -l | awk '{print $2}'| grep sudo > /dev/null || apt-get install sudo -y

echo "Enable ssh agent-forwarding..."
sed -i 's/.*ForwardAgent.*/ ForwardAgent yes/' /etc/ssh/ssh_config

for i in ivanov
do
        echo "Ensure $i has access..."
        grep $i /etc/passwd >/dev/null || useradd -m -s /bin/bash $i
        mkdir -p /home/$i/.ssh
        chown -R $i:$i /home/$i/.ssh
        chmod -R 700 /home/$i/.ssh
        touch /home/$i/.ssh/authorized_keys

        T="$i ALL=(ALL) NOPASSWD: ALL"
        grep "$T" /etc/sudoers > /dev/null || echo "$T" >> /etc/sudoers
done

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMJm3oUb900PQDuHKuKxA1CJaBM8r0xxL8InjN7al/TcFg92hkx5voFYIrRe3PZj+JQ4g5N06XxLVmyZdXPaHJc1YrQVGC9dMm3IKCc7S4oFeCzSnG6S+Hp0opDd4Gf7eoPmQYCwv659NboM14Kc9K476Xtu9AsZGQySB3Lar5fZzcMuwCmjC/TmYuVDLp5XlUsOlGsBPct8XvtNfkKo4R+cWdVUrONKCD9vm5SHwmOj1I10+8wVrvXHvkOKlQVKTdw4Bq4vCP73yvD9MFuWRkkbfenuMrX0q/UH3v9Q3ruzRS+rHYO2omcyW4unflHmgpFu04XKbJDM588oFJJDdgsCIp9JRXVcogk18B4rhEI+u9M+1qa6mnSdAppt3w0HkVzbb43l28GKGKRS62Co3GZFukW8GSe8Hxvv4K2R1dGZejvOxLspOiR3SrabmcxjKpuHQnlUu0YX0fFEGaPOPF0j/mNueE5acF7cII7OP2lVPbxfoj7Nxt5Hc6MJpEVw44RftPtW0FD5pwCnifIsXsDX4JJb4kUD+PF4/fLUEgPKPUpnWdz3kmf4MUwHEppmRIC5jf/+afKWuM7mzaw+Z8w3Y0Bxvkl0cRg9wP4LzqQWL6u2M4o1FWGmez+oLboEslVsUvzrP0b/m8bJhvWLlQxqBnxlaqpecql41w/G6r6w== ivanov@stoileserveur.com" > /home/ivanov/.ssh/authorized_keys
