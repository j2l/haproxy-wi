FROM      ubuntu:22.04

ENV	      DEBIAN_FRONTEND="noninteractive" \
          TERM="xterm-256color" \
	        LC_ALL=C.UTF-8
    
RUN       apt-get update -qq && apt-get upgrade -y --with-new-pkgs -qq \
	        && apt-get install -y --no-install-recommends --no-install-suggests --qq apt-utils apt-transport-https ca-certificates \
          gnupg curl wget bash nano net-tools dnsutils git apache2 python3 python3-pip python3-ldap rsync ansible python3-requests \
          python3-networkx python3-matplotlib python3-bottle python3-future python3-jinja2 python3-peewee python3-distro python3-pymysql \
          python3-psutil python3-paramiko netcat-traditional nmap net-tools lshw dos2unix libapache2-mod-wsgi-py3 openssl sshpass      
      
RUN       apt-get clean autoclean -y && \
    	    apt-get autoremove -y && \
    	    rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/* \
		      /var/tmp/* /usr/share/doc/ /usr/share/man/ /usr/share/locale/ \
		      /root/.cache /root/.local /root/.gnupg /root/.config /tmp/*

WORKDIR   cd /var/www/
          git clone https://github.com/hap-wi/roxy-wi.git /var/www/haproxy-wi

RUN       chown -R www-data:www-data haproxy-wi/
          cp haproxy-wi/config_other/httpd/roxy-wi_deb.conf /etc/apache2/sites-available/roxy-wi.conf
          a2ensite roxy-wi.conf
          a2enmod cgid ssl proxy_http rewrite
          pip3 install -r haproxy-wi/config_other/requirements_deb.txt
          systemctl restart apache2
          
CMD       /usr/sbin/apache2ctl -DFOREGROUND
