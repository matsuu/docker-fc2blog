FROM ubuntu

RUN apt-get update
#RUN apt-get upgrade
RUN apt-get install -y libapache2-mod-php5 php5-gd php5-mysql git

WORKDIR /var/www
RUN git clone https://github.com/fc2blog/blog.git && \
  chown www-data:www-data blog/app/temp blog/public/uploads && \
  sed \
    -e "s/'localhost'/getenv('MYSQL_PORT_3306_TCP_ADDR')/" \
    -e "s/your user name/@DB_USER@/" \
    -e "s/your password/@DB_PASSWORD@/" \
    -e "s/your database name/@DB_DATABASE@/" \
    -e "s/domain/@DOMAIN@/" \
    -e "s/0123456789abcdef/@PASSWORD_SALT@/" \
    blog/public/config.php.sample > blog/public/config.php && \
  ( \
    echo "<VirtualHost *:80>" && \
    echo "  ServerName @DOMAIN@" && \
    echo "  DocumentRoot /var/www/blog/public" && \
    echo "  <Directory /var/www/blog/public>" && \
    echo "    AllowOverride All" && \
    echo "    Order allow,deny" && \
    echo "    Allow from all" && \
    echo "  </Directory>" && \
    echo "</VirtualHost>" \
  ) > /etc/apache2/sites-available/fc2blog && \
  a2ensite fc2blog && \
  a2dissite default && \
  a2enmod rewrite

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

WORKDIR /etc/apache2
EXPOSE 80
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
#CMD ["-D", "FOREGROUND"]
#ENTRYPOINT ["/usr/sbin/apache2"]
