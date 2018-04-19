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

		EYPMERGEHOOK=$(curl -H 'Content-Type: application/json' -u jordiprats:${PAT_JORDIPRATS} https://api.github.com/repos/${REPOUSER}/${REPONAME}/hooks 2>/dev/null| python -mjson.tool | grep eypmergehook | wc -l)
		if [ "${EYPMERGEHOOK}" -eq 0 ];
		then
			cat <<EOF | curl -H 'Content-Type: application/json' -d @- -u jordiprats:${PAT_JORDIPRATS} https://api.github.com/repos/${REPOUSER}/${REPONAME}/hooks
{
  "name": "web",
  "active": true,
  "events": [ "push" ],
  "config": {
    "url": "${WEBHOOK_URL}",
    "secret": "${WEBHOOK_SECRET}",
    "content_type": "json"
  }
}
EOF
		elif [ "${EYPMERGEHOOK}" -gt 1 ];
		then
			echo "${REPOUSER}/${REPONAME}: ${EYPMERGEHOOK}"
		fi
done
