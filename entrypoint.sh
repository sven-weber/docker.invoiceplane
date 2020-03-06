#!/bin/ash
set -e

timestamp() {
  date +"%T"
}

time=$(timestamp)
echo "Application starting $time"

#Configure the Target Address for InvoicePlane
echo "Setting ${INVOICEPLANE_URL} as InvoicePlane Url".
sed -i "s|^IP_URL=.*|IP_URL=http://${INVOICEPLANE_URL}|" ${INVOICEPLANE_CONF}

echo "creating user.ini file"
echo "configured timezone: ${INVOICEPLANE_TIMEZONE}"
#Create php.ini
(
  echo "date.timezone = ${INVOICEPLANE_TIMEZONE}"
) > /etc/php7/php.ini

#Chown directories
#exec chown -R :apache ${INVOICEPLANE_UPLOADS}
#exec chown -R :apache ${INVOICEPLANE_VIEWS}

#Start InvoicePlane
PARSED_PORT="$(echo ${INVOICEPLANE_URL} | sed -nr 's,.*(:[0-9]+).*,\1,p')"
command="/usr/sbin/httpd -DFOREGROUND"
echo "Starting server, $command"
exec $command