#!/bin/bash

. $(dirname $0)/token.sh

REPOUSER=${1-jordiprats}

for i in $(find /home/jprats/git/puppet-things -maxdepth 1 -mindepth 0 -type d -iname eyp\*);
do
	REPONAME=$(basename $i)
	echo == $REPONAME ==

	curl -u jordiprats:${PAT_JORDIPRATS} https://api.github.com/repos/${REPOUSER}/$REPONAME/pulls
done


