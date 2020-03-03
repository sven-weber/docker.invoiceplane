#!/bin/sh
set -e

timestamp() {
  date +"%T"
}

time=$(timestamp)
echo "Application starting $time"

#Configure the Target Address for InvoicePlane
echo "Setting ${INVOICEPLANE_URL} as InvoicePlane Url".
sed -i "s|^IP_URL=.*|IP_URL=${INVOICEPLANE_URL}|" ${INVOICEPLANE_CONF}

#Start InvoicePlane
echo "Starting server"
exec php -S 0.0.0.0:80 index.php