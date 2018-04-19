#!/bin/bash

cd puppet-things
for i in eyp-*;
do
	echo == $i ==
	cd $i
	git pull origin master
	cd ..
done
cd ..
