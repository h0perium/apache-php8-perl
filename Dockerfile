FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade -y

COPY debconf.selections /tmp/
RUN debconf-set-selections /tmp/debconf.selections

ENV TZ=Asia/Tehran
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt-get install -y zip unzip
RUN apt-get update -y && apt-get install -y \
	php8.1 \
	php8.1-bz2 \
	php8.1-cgi \
	php8.1-cli \
	php8.1-common \
	php8.1-curl \
	php8.1-dev \
	php8.1-enchant \
	php8.1-fpm \
	php8.1-gd \
	php8.1-gmp \
	php8.1-imap \
	php8.1-interbase \
	php8.1-intl \
	php8.1-ldap \
	php8.1-mbstring \
	php8.1-mysql \
	php8.1-odbc \
	php8.1-opcache \
	php8.1-pgsql \
	php8.1-phpdbg \
	php8.1-pspell \
	php8.1-readline \
	php8.1-sqlite3 \
	php8.1-sybase \
	php8.1-tidy \
	php8.1-xsl \
	php8.1-zip

#RUN apt-get update -y
 
RUN apt-get update -y && apt-get install -y \
	perl \
	make \
	gcc \
	wget \
	aria2 \
	libcgi-pm-perl \
	mariadb-client \
	libmysqlclient-dev \
	imagemagick


RUN wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp

RUN cpan CGI DBI HTML::Escape DBD::mysql YAML XML::RPC File::Copy File::Path CGI::Carp LWP::Simple LWP::UserAgent Digest::SHA1  Digest::SHA  Digest::MD5  MIME::Lite Thread::Semaphore Net::Server::Multiplex Try::Tiny Encode JSON::Parse List::Util IO::Multiplex Module::Metadata Mail::Sendmail

RUN apt-get install apache2 libapache2-mod-php8.1 -y
RUN apt-get update
RUN apt-get install git nano tree vim curl ftp -y

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb

COPY index.php /var/www/html/
COPY run-lamp.sh /usr/sbin/

RUN a2enmod rewrite
RUN a2enmod cgid
RUN a2enmod headers

RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN chmod +x /usr/sbin/run-lamp.sh
RUN chown -R www-data:www-data /var/www/html

#VOLUME /var/www/html
VOLUME /var/log/httpd
#VOLUME /var/lib/mysql
#VOLUME /var/log/mysql
#VOLUME /etc/apache2

CMD ["/usr/sbin/run-lamp.sh"]

