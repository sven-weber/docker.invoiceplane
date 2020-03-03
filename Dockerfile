from php:7.2-alpine

#ENV vars
ENV DOWNLOAD=https://github.com/InvoicePlane/InvoicePlane/releases/download/v1.5.9/v1.5.9.zip
ENV DIR=/InvoicePlane

#Updates
RUN apk update && apk upgrade

#Install PHP extensions
#Using a script that simplifies the installation by managing the dependencies
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions gd hash json mbstring mcrypt mysqli openssl recode xmlrpc zlib

#Download and unzip files
RUN apk add wget unzip
RUN cd / && \
    wget -O files.zip ${DOWNLOAD} && \
    unzip files.zip -d / && \
    rm -f files.zip && \
    mv ip ${DIR}
RUN apk del wget unzip

#Setup App
RUN cd ${DIR} && \
    mv ipconfig.php.example ipconfig.php && \
    sed -i 's IP_URL= IP_URL=http://0.0.0.0:80 ' ipconfig.php

#Volumes
VOLUME [ "/InvoicePlane/uploads" ]

WORKDIR ${DIR}
expose 80
ENTRYPOINT [ "php", "-S", "0.0.0.0:80", "index.php" ]