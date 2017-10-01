# use `travis` for the CLI via this container & alias
alias travis='docker run --rm -v $PWD:/repo -v ~/.travis:/travis andredumas/travis-ci-cli'