#!/bin/bash

. token.sh

#https://developer.github.com/v3/repos/#edit


#PATCH /repos/:owner/:repo

# {
#   "name": "Hello-World",
#   "description": "This is your first repository",
# }

REPOUSER=${1-jordiprats}

if [ -z "$2" ];
then
	LOOP=$(find /home/jprats/git/puppet-things -maxdepth 1 -mindepth 0 -type d -iname eyp\*)
else
	LOOP=$2
fi

for i in $LOOP;
do
	REPONAME=$(basename $i)
	echo == $REPONAME ==

	ID_TO_BE_DELETED=$(curl -u jordiprats:${PAT_JORDIPRATS} https://api.github.com/repos/${REPOUSER}/${REPONAME}/releases 2>/dev/null | grep '"tag_name": "latest",' -B1 | grep '"id"' | awk '{ print $NF }' | cut -f1 -d,)

	if [ ! -z "${ID_TO_BE_DELETED}" ];
	then
		curl -u jordiprats:${PAT_JORDIPRATS} -X DELETE https://api.github.com/repos/${REPOUSER}/${REPONAME}/releases/${ID_TO_BE_DELETED}
	fi

done
