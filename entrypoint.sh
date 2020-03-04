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
#Create user.ini
(
  echo "default_charset = 'UTF-8'"
  echo "output_buffering = off"
  echo "date.timezone = ${INVOICEPLANE_TIMEZONE}"
) > ${INVOICEPLANE_DIR}/.user.ini

#Start InvoicePlane
PARSED_PORT="$(echo ${INVOICEPLANE_URL} | sed -nr 's,.*(:[0-9]+).*,\1,p')"
command="php -S 0.0.0.0$PARSED_PORT index.php"
echo "Starting server, $command"
exec $command