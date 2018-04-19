#!/bin/bash

for i in $(find /home/jprats/git/puppet-things -maxdepth 1 -mindepth 0 -type d -iname eyp\*);
do
	REPONAME=$(basename $i)
	DESCRIPCIO_REPO=$(cat puppet-things/$REPONAME/metadata.json | grep summary | cut -f2 -d: | sed 's/^.//' | sed 's/.$//')

	if [ "$DESCRIPCIO_REPO" == "null" ];
	then
		echo $REPONAME: NO SUMMARY, NO PARTY
	fi

done
