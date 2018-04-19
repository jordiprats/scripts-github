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

	DESCRIPCIO_REPO=$(cat puppet-things/$REPONAME/metadata.json | grep summary | cut -f2 -d: | sed 's/^.//' | sed 's/.$//')

	if [ "$DESCRIPCIO_REPO" == "null" ];
	then
		echo $REPONAME: SKIPPED
	else
		cat <<EOF | curl -H 'Content-Type: application/json' -X PATCH -d @- -u jordiprats:${PAT_JORDIPRATS} https://api.github.com/repos/${REPOUSER}/${REPONAME}
{
  "name": "${REPONAME}",
  "description": $DESCRIPCIO_REPO
}
EOF
	fi


done
