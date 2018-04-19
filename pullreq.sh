#!/bin/bash

. $(dirname $0)/token.sh

if [ -z "$1" ] || [ -z "$2" ];
then
	echo $0 <REPOFROM> <REPOTO> [REPONAME]
	echo example:
	echo "	$0 userfrom userto eyp-tomcat"
	exit 1
fi

REPOTO=$1
REPOFROM=$2

echo TO: $REPOTO
echo FROM: $REPOFROM

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

	#curl -u jordiprats:${PAT_JORDIPRATS} https://api.github.com/repos/jordiprats/$REPONAME/pulls

	# POST /repos/:owner/:repo/pulls
	# {
	#   "title": "Amazing new feature",
	#   "body": "Please pull this in!",
	#   "head": "octocat:new-feature",
	#   "base": "master"
	# }

	TMPPULL=$(mktemp /tmp/pullrequest.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)

	cat <<EOF | tee -a debug.log | curl -d @- -u jordiprats:${PAT_JORDIPRATS} https://api.github.com/repos/${REPOTO}/${REPONAME}/pulls 2>/dev/null | grep -E '"number"|"sha"' > $TMPPULL
{
  "title": "sync repo ${REPOFROM}",
  "body": "automatic sync",
  "head": "${REPOFROM}:master",
  "base": "master"
}
EOF
	
	#be nice with github
	sleep 5 

	PULLNUMBER=$(grep number $TMPPULL | awk '{ print $NF }' | grep -Eo '[0-9]+')
	
	SHAHEAD=$(grep sha $TMPPULL | awk '{ print $NF }' | grep -Eo '[0-9a-z]+' | head -n1)

	cat <<EOF | tee -a debug.log | curl -H 'Content-Type: application/json' -X PUT -d @- -u jordiprats:${PAT_JORDIPRATS} https://api.github.com/repos/${REPOTO}/${REPONAME}/pulls/${PULLNUMBER}/merge
{
  "sha": "${SHAHEAD}",
  "commit_message": "sync repo ${REPOFROM}"
}
EOF
	
	rm -fr $TMPPULL

	if [ -z "$2" ];
	then
		#be even more nice with github
		sleep 1m
	fi


done


if [ "$1" == "jordiprats" ];
then

./masspull.sh

fi

