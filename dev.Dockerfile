FROM      yanik39/haproxy-wi:core

ENV	  DEBIAN_FRONTEND="noninteractive" \
          TERM="xterm-256color" \
	  LC_ALL=C.UTF-8
	  
COPY 	  root/ /

RUN	  git clone https://github.com/hap-wi/roxy-wi.git /var/www/haproxy-wi && chown -R www-data:www-data /var/www/haproxy-wi && \
	  cp /var/www/haproxy-wi/config_other/httpd/roxy-wi_deb.conf /etc/apache2/sites-available/roxy-wi.conf && \
	  a2ensite roxy-wi.conf && a2enmod cgid ssl proxy_http rewrite && pip3 install -r /var/www/haproxy-wi/config_other/requirements_deb.txt && \
	  pip3 install paramiko-ng supervisor && chmod +x /var/www/haproxy-wi/app/*.py && cp /var/www/haproxy-wi/config_other/logrotate/* /etc/logrotate.d/ && \
	  mkdir /var/www/.ansible /var/www/.ssh /var/lib/roxy-wi/ /var/lib/roxy-wi/keys/ /var/lib/roxy-wi/configs/ /var/lib/roxy-wi/configs/hap_config/ \
          /var/lib/roxy-wi/configs/kp_config/ /var/lib/roxy-wi/configs/nginx_config/ /var/lib/roxy-wi/configs/apache_config/ /var/log/roxy-wi/ \
          /etc/roxy-wi/ && rm /var/www/haproxy-wi/app/certs/* && touch /var/www/.ansible_galaxy && openssl req -newkey rsa:4096 -nodes \
          -keyout /var/www/haproxy-wi/app/certs/haproxy-wi.key -x509 -days 10365 -out /var/www/haproxy-wi/app/certs/haproxy-wi.crt \
	  -subj "/C=US/ST=Almaty/L=Springfield/O=Roxy-WI/OU=IT/CN=*.example.com/emailAddress=haproxy-wi@example.com" && \
          mv /var/www/haproxy-wi/roxy-wi.cfg /etc/roxy-wi && /var/www/haproxy-wi/app/create_db.py && mkdir /help && \
          chown -R www-data:www-data /var/www/haproxy-wi/ /var/lib/roxy-wi/ /var/log/roxy-wi/ /etc/roxy-wi/ /var/www/.* && \
	  echo "www-data          ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers && chmod +x /help/*.sh /HAProxy-WI && \
	  cp /var/www/haproxy-wi/config_other/fail2ban/filter.d/* /etc/fail2ban/filter.d/ && \
	  cp /var/www/haproxy-wi/config_other/fail2ban/jail.d/* /etc/fail2ban/jail.d/
          
EXPOSE 	  443

VOLUME    /var/www/haproxy-wi/

ENTRYPOINT ["/HAProxy-WI"]
