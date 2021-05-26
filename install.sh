#!/bin/bash

# 1. Sets up a local Python environment via virtualenv
# 2. Installs Ansible prerequisites
# 3. Hands off to Ansible to complete actual installation of dotfiles etc.
#
# On a new machine, the following commands may be required:
#   brew install python

set -e

PIP_CMD=pip3
VIRTUALENV_TARGET_DIR=python
PYTHON_PKGS="PyYAML Jinja2"
VIRTUALENV_ACTIVATE=$VIRTUALENV_TARGET_DIR/bin/activate
ANSIBLE_ENV_SETUP=vendor/ansible/hacking/env-setup

if ! command -v virtualenv &> /dev/null
then
  $PIP_CMD install virtualenv
fi

if [[ ! -e $VIRTUALENV_ACTIVATE ]]; then
  virtualenv $VIRTUALENV_TARGET_DIR
#   pipx ensurepath
else
  echo "Skipping virtualenv install (already exists)"
fi
source $VIRTUALENV_ACTIVATE

if [[ -z $(pip show $PYTHON_PKGS) ]]; then
  set +e
  $PIP_CMD install $PYTHON_PKGS
  if [ $? -ne 0 ]; then
    echo "Failed: pip install"
    exit 1
  fi
  set -e
fi

source $ANSIBLE_ENV_SETUP

trap - EXIT
