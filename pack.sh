#!/bin/bash

PACK="/home/jprats/upload/puppetmoduls.$(date +%Y%m%d%H%M).tgz"

if [[ "$1" == "esp" ]];
then
	FILTRE="cat"
else
	FILTRE="grep -v eyp-bitban"
fi

tar czf $PACK $(for i in $(find /home/jprats/git/puppet-things -type d -name pkg | $FILTRE); do echo -C $i $(ls -rt $i/*.tar.gz | grep -v latest | tail -n1 | awk -F/ '{print $NF }'); done)

echo $PACK

echo ... skipping scp ...
