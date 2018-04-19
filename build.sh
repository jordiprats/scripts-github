#!/bin/bash

cd /home/jprats/git/puppet-things

find /home/jprats/git/puppet-things -iname \*~ -delete

if [ -z "$1" ];
then

for i in $(find /home/jprats/git/puppet-things -type d -name pkg);
do
	MODULE=$(basename $(dirname $i))

	puppet module build $MODULE
	
	puppet module uninstall --force $MODULE
	
	puppet module install $(ls -rt $i/*.tar.gz | tail -n1)
	
	#unlink $i/pkg/latest.tar.gz > /dev/null 2>&1	
	#ln -s $(ls -rt $i/pkg/*.tar.gz | grep -v latest | tail -n1) $i/latest.tar.gz
	#unlink $i/latest > /dev/null 2>&1
	#ln -s $(ls -rt $i/*.tar.gz | grep -v latest | tail -n1 | sed 's/.tar.gz//') $i/latest
	
done
puppet module list

else

if [ ! -f $1/metadata.json ];
then
	echo talking to me?
	exit 1
fi

puppet module build $1
	
puppet module uninstall --force $1

puppet module install --ignore-dependencies $(ls -rt $(find /home/jprats/git/puppet-things/ -maxdepth 1 -iname $1 | head -n1)/pkg/*.tar.gz | tail -n1)

#unlink $1/pkg/latest > /dev/null 2>&1
#ln -s $(ls -rt $1/pkg/*.tar.gz | grep -v latest | tail -n1 | sed 's/.tar.gz//') $1/pkg/latest

#unlink $1/pkg/latest.tar.gz > /dev/null 2>&1
#ln -s $(ls -rt $1/pkg/*.tar.gz | grep -v latest | tail -n1) $1/pkg/latest.tar.gz


echo -e '\n versio instalada\n'
puppet module list | grep $1


fi

cd - >/dev/null 2>&1

