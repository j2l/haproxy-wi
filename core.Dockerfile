FROM      ubuntu:22.04

ENV       DEBIAN_FRONTEND="noninteractive" \
          TERM="xterm-256color" \
          LC_ALL=C.UTF-8

RUN       apt-get update -qq && apt-get upgrade -y --with-new-pkgs && \
	  apt-get install -y --no-install-recommends apt-utils apt-transport-https ca-certificates
	  
RUN	  apt-get install -y --no-install-recommends gnupg curl wget bash nano net-tools dnsutils git apache2 python3 python3-pip \
	  python3-ldap rsync ansible python3-requests python3-networkx python3-matplotlib python3-bottle python3-future python3-jinja2 \
	  python3-peewee python3-distro python3-pymysql python3-psutil python3-paramiko netcat-traditional nmap net-tools lshw dos2unix \
	  libapache2-mod-wsgi-py3 openssl sshpass fail2ban haproxy
      
RUN       apt-get clean autoclean -y && apt-get autoremove -y && \
	  rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/* \
	  /var/tmp/* /usr/share/doc/ /usr/share/man/ /usr/share/locale/ \
	  /root/.cache /root/.local /root/.gnupg /root/.config /tmp/*          
