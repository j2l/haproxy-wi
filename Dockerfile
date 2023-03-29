FROM      ubuntu:22.04

ENV	  DEBIAN_FRONTEND="noninteractive" \
          TERM="xterm-256color" \
	  LC_ALL=C.UTF-8
    
RUN       apt-get update -qq && apt-get upgrade -y --with-new-pkgs && \
	  apt-get install -y --no-install-recommends apt-utils apt-transport-https ca-certificates
	  
RUN	  apt-get install -y --no-install-recommends gnupg curl wget bash nano net-tools dnsutils git systemd \
	  apache2 python3 python3-pip python3-ldap rsync ansible python3-requests python3-networkx python3-matplotlib python3-bottle \
	  python3-future python3-jinja2 python3-peewee python3-distro python3-pymysql python3-psutil python3-paramiko netcat-traditional \
	  nmap net-tools lshw dos2unix libapache2-mod-wsgi-py3 openssl sshpass
      
RUN       apt-get clean autoclean -y && \
    	  apt-get autoremove -y && \
    	  rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/* \
	  /var/tmp/* /usr/share/doc/ /usr/share/man/ /usr/share/locale/ \
	  /root/.cache /root/.local /root/.gnupg /root/.config /tmp/*   

RUN       git clone https://github.com/hap-wi/roxy-wi.git /var/www/haproxy-wi && \
	  chown -R www-data:www-data /var/www/haproxy-wi && \
          cp /var/www/haproxy-wi/config_other/httpd/roxy-wi_deb.conf /etc/apache2/sites-available/roxy-wi.conf && \
          a2ensite roxy-wi.conf && \
          a2enmod cgid ssl proxy_http rewrite && \
          pip3 install -r /var/www/haproxy-wi/config_other/requirements_deb.txt && \
	  pip3 install paramiko-ng && \
	  chmod +x haproxy-wi/app/*.py && \
	  cp haproxy-wi/config_other/logrotate/* /etc/logrotate.d/ && \
	  mkdir /var/lib/roxy-wi/ /var/lib/roxy-wi/keys/ /var/lib/roxy-wi/configs/ /var/lib/roxy-wi/configs/hap_config/	\
	  /var/lib/roxy-wi/configs/kp_config/ /var/lib/roxy-wi/configs/nginx_config/ \
	  /var/lib/roxy-wi/configs/apache_config//var/log/roxy-wi/ /etc/roxy-wi/ && \
	  mv haproxy-wi/roxy-wi.cfg /etc/roxy-wi && \
	  openssl req -newkey rsa:4096 -nodes -keyout /var/www/haproxy-wi/app/certs/haproxy-wi.key -x509 -days 10365 -out /var/www/haproxy-wi/app/certs/haproxy-wi.crt -subj "/C=US/ST=Almaty/L=Springfield/O=Roxy-WI/OU=IT/CN=*.roxy-wi.org/emailAddress=aidaho@roxy-wii.org" && \
	  chown -R apache:apache /var/www/haproxy-wi/ && \
	  chown -R apache:apache /var/lib/roxy-wi/ && \
	  chown -R apache:apache /var/log/roxy-wi/ && \
	  chown -R apache:apache /etc/roxy-wi/
          
CMD       /usr/sbin/apache2ctl -DFOREGROUND
