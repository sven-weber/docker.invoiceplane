#!/bin/sh
set -e

timestamp() {
  date +"%T"
}

time=$(timestamp)
echo "Application starting $time"

#Configure the Target Address for InvoicePlane
echo "Setting ${INVOICEPLANE_URL} as InvoicePlane Url".
sed -i "s|^IP_URL=.*|IP_URL=http://${INVOICEPLANE_URL}|" ${INVOICEPLANE_CONF}

#Start InvoicePlane
command="php -S ${INVOICEPLANE_URL} index.php"
echo "Starting server, $command"
exec $command