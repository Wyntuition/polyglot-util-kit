chmod 700 *
./alias-repo-states.sh
./alias-travis-cli-docker.sh

export PATH=$PATH:$(pwd)

# Update shell 
source ~/.bash_profile