#!/bin/bash
#set -x

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').rpm
# Install MySQL Community Edition 8.0
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-$(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/')-1.noarch.rpm
yum install -y mysql-shell-${mysql_version}
mkdir ~${user}/.mysqlsh
cp /usr/share/mysqlsh/prompt/prompt_256pl+aw.json ~${user}/.mysqlsh/prompt.json
echo '{
    "history.autoSave": "true",
    "history.maxSize": "5000"
}' > ~${user}/.mysqlsh/options.json
chown -R ${user} ~${user}/.mysqlsh

echo "MySQL Shell successfully installed !"

if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
then
  dnf -y module enable php:remi-7.4
  dnf -y install httpd php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json php-bcmath php-intl php-xmlrpc php-soap php-opcache
elif [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el9" ]]
then
  dnf -y install httpd php php-cli php-mysqlnd php-zip php-gd php-mbstring php-xml php-json php-bcmath php-intl php-soap php-opcache php-sodium php-pear php-devel
  pecl config-set preferred_state beta
  pecl install xmlrpc
  echo "extension=xmlrpc.so" > /etc/php.d/50-xmlrpc.ini
  pecl config-set preferred_state stable
else	
  yum-config-manager --enable remi-php74
  yum -y install httpd php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json php-bcmath php-intl php-xmlrpc php-soap php-opcache
fi

echo "MySQL Shell & PHP successfully installed !"

yum -y install certbot mod_ssl

echo "Certbot has been installed !"
