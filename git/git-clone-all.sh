#!/bin/bash

# Repo names
repos='jenkins-terraform eks-terraform'
# Repo base address
account='git@github.com:wyntuition/'

for repo in $repos;
do
	git clone $account$repo.git
done
