FROM php:7.2-alpine

#ENV vars
ENV DOWNLOAD=https://github.com/InvoicePlane/InvoicePlane/releases/download/v1.5.9/v1.5.9.zip
ENV INVOICEPLANE_DIR=/InvoicePlane
ENV INVOICEPLANE_URL=http://127.0.0.1:80
ENV INVOICEPLANE_CONF=ipconfig.php

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
    mv ip ${INVOICEPLANE_DIR}
RUN apk del wget unzip

#Configuration
RUN cd ${INVOICEPLANE_DIR} && \
    mv ${INVOICEPLANE_CONF}.example ${INVOICEPLANE_CONF}

#Volumes
VOLUME [ "/InvoicePlane/uploads" ]

#Startup scripts
COPY entrypoint.sh entrypoint.sh
RUN chmod 755 entrypoint.sh

#Startup
WORKDIR ${INVOICEPLANE_DIR}
ENTRYPOINT [ "/entrypoint.sh" ]