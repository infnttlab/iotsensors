#!/bin/bash
cat /tmp/power >> /tmp/power-history
cat /tmp/power.temp > /tmp/power
curl -X POST -H "Content-Type: text/xml" -u readonly:readonly --anyauth --data-binary @/root/iotsensors/request.xml http://sbo-srv.cnaf.infn.it/EcoStruxure/DataExchange |  xmllint --format - | sed -n -e 's/.*<EWSv121:Value>\(.*\)<\/EWSv121:Value>.*/\1/p' > /tmp/power.temp

