FROM centos:7

#version defined
ENV SWOOLE_VERSION 4.4.12
ENV PHP_VERSION php74
ENV EASYSWOOLE_VERSION 3.x-dev

RUN rpm -ivh --force --nodeps http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-12.noarch.rpm
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

RUN rpm -ivh --force --nodeps  http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi

# wget
RUN yum install -y wget

# use aliyun centos
RUN yum clean all
RUN yum makecache

# install libs
RUN yum install deltarpm -y
RUN yum install -y curl
RUN yum install -y zip
RUN yum install -y unzip
RUN yum install -y openssl-devel
RUN yum install -y gcc-c++
RUN yum install -y make
RUN yum install -y libtool
RUN yum install -y autoconf
RUN yum install -y automake

# install tools
RUN yum install -y git
RUN yum install -y svn
RUN yum install -y net-tools
RUN yum install -y telnet-server
#RUN yum install -y httping
RUN yum install -y redis
RUN yum install -y memcached
RUN yum install -y libmemcached
RUN mkdir -p /usr/lib/x86_64-linux-gnu/include/libmemcached \
&& ln -s /usr/include/libmemcached/memcached.h /usr/lib/x86_64-linux-gnu/include/libmemcached/memcached.h
RUN yum install -y telnet-server.x86_64
RUN yum install -y telnet.x86_64
RUN yum install -y xinetd.x86_64
RUN yum install -y pcre-devel
RUN yum install -y pcre pcre-devel
RUN yum install -y zlib zlib-devel
RUN yum install -y psmisc
RUN yum install -y ImageMagick-devel

# 安装SSH
RUN yum install -y openssh-server sudo;
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config;
RUN echo root:phpserver|chpasswd;
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key;
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key;
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

#install php
RUN yum install --enablerepo=remi-${PHP_VERSION} -y php php-fpm php-gd php-mbstring php-mcrypt php-mysqlnd php-cli php-devel php-common composer

# composer
#RUN curl -sS https://getcomposer.org/installer | php \
#    && mv composer.phar /usr/bin/composer
# use aliyun composer
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# swoole ext
RUN wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && ( \
    cd swoole \
    && phpize \
    && ./configure --enable-openssl \
    && make \
    && make install \
    ) \
    && sed -i "2i extension=swoole.so" /etc/php.ini \
    && rm -r swoole

# redis ext
RUN wget http://pecl.php.net/get/redis-5.2.2.tgz -O redis.tar.gz \
    && mkdir -p redis \
    && tar zxvf redis.tar.gz -C redis --strip-components=1 \
    && rm redis.tar.gz \
    && ( \
    cd redis \
    && phpize \
    && ./configure --enable-redis \
    && make \
    && make install \
    ) \
    && echo 'extension=redis.so' > /etc/php.d/20-redis.ini \
    && rm -r redis

# imagick ext
RUN wget http://pecl.php.net/get/imagick-3.4.4.tgz -O imagick.tar.gz \
    && mkdir -p imagick \
    && tar zxvf imagick.tar.gz -C imagick --strip-components=1 \
    && rm imagick.tar.gz \
    && ( \
    cd imagick \
    && phpize \
    && ./configure  \
    && make \
    && make install \
    ) \
    && echo 'extension=imagick.so' > /etc/php.d/20-imagick.ini \
    && rm -r imagick

# inotify
RUN wget http://pecl.php.net/get/inotify-2.0.0.tgz -O inotify.tar.gz \
    && mkdir -p inotify \
    && tar zxvf inotify.tar.gz -C inotify --strip-components=1 \
    && rm inotify.tar.gz \
    && ( \
    cd inotify \
    && phpize \
    && ./configure  \
    && make \
    && make install \
    ) \
    && echo 'extension=inotify.so' > /etc/php.d/20-inotify.ini \
    && rm -r inotify

# fswatch ext
RUN wget https://github.com/emcrisostomo/fswatch/releases/download/1.11.0/fswatch-1.11.0.tar.gz -O fswatch.tar.gz \
    && mkdir -p fswatch \
    && tar zxvf fswatch.tar.gz -C fswatch --strip-components=1 \
    && rm fswatch.tar.gz \
    && ( \
    cd fswatch \
    && ./configure  \
    && make \
    && make install  \
    ) \
    && rm -r fswatch

## Dir
#WORKDIR /easyswoole
## install easyswoole
#RUN cd /easyswoole \
#    && composer require easyswoole/easyswoole=${EASYSWOOLE_VERSION} \
#    && php vendor/bin/easyswoole install
#
#EXPOSE 9501