FROM alpine:3.9

#ENV vars
ENV DOWNLOAD=https://github.com/InvoicePlane/InvoicePlane/releases/download/v1.5.9/v1.5.9.zip
ENV INVOICEPLANE_DIR=/var/www/localhost/htdocs
ENV INVOICEPLANE_URL=127.0.0.1:80
ENV INVOICEPLANE_TIMEZONE=Europe/Berlin
ENV INVOICEPLANE_CONF=ipconfig.php
ENV INVOICEPLANE_UPLOADS=${INVOICEPLANE_DIR}/uploads
ENV INVOICEPLANE_VIEWS=${INVOICEPLANE_DIR}/application/views

#Install Updates and install apache 
RUN apk update \
    && apk add apache2 \
            php7 \
            php7-apache2 \
            php7-gd \
            php7-json \
            php7-mbstring \
            php7-mcrypt \
            php7-mysqli \
            php7-openssl \
            php7-recode \
            php7-recode \
            php7-xmlrpc \
            php7-zlib \
            php7-ctype \
            php7-session

#Download and unzip files
RUN apk add wget unzip
RUN cd / && \
    wget -O files.zip ${DOWNLOAD} && \
    unzip files.zip -d / && \
    rm -f files.zip && \
    mv -v ip/* ${INVOICEPLANE_DIR}
RUN apk del wget unzip

#InvoicePlane Configuration
RUN cd ${INVOICEPLANE_DIR} && \
    mv ${INVOICEPLANE_CONF}.example ${INVOICEPLANE_CONF}

#Configure Apache
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_module/LoadModule\ session_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_cookie_module/LoadModule\ session_cookie_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_crypto_module/LoadModule\ session_crypto_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" /etc/apache2/httpd.conf
RUN chown -R apache:apache ${INVOICEPLANE_DIR}

#Replace Router.php for php 7.3 fix
#See https://community.invoiceplane.com/t/topic/5348/12 for reference
COPY Router.php ${INVOICEPLANE_DIR}/application/third_party/MX/

#Volumes
VOLUME [ "/var/www/localhost/htdocs/uploads" ]
VOLUME [ "/var/www/localhost/htdocs/application/views/invoice_templates"]
VOLUME [ "/var/www/localhost/htdocs/application/views/quote_templates"]

#Startup
EXPOSE 80
COPY entrypoint.sh entrypoint.sh
RUN chmod 755 entrypoint.sh
WORKDIR ${INVOICEPLANE_DIR}
ENTRYPOINT [ "/entrypoint.sh" ]