#!/bin/bash

# 1. Sets up a local Python environment via virtualenv
# 2. Installs Ansible prerequisites
# 3. Hands off to Ansible to complete actual installation of dotfiles etc.

set -e

PIP_CMD=pip3
VIRTUALENV_TARGET_DIR=python
PYTHON_PKGS="PyYAML Jinja2"
VIRTUALENV_ACTIVATE=$VIRTUALENV_TARGET_DIR/bin/activate
ANSIBLE_ENV_SETUP=vendor/ansible/hacking/env-setup

if ! command -v virtualenv &> /dev/null
then
  $PIP_CMD install --user virtualenv
  export PATH="$(python3 -m site --user-base)/bin:${PATH}"
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
    echo "Failed: $PIP_CMD install $PYTHON_PKGS"
    exit 1
  fi
  set -e
fi

source $ANSIBLE_ENV_SETUP

HOST_OS=$(uname)

if [ "$HOST_OS" = 'Darwin' ]; then
  ansible-playbook --ask-become-pass -i inventory darwin.yml
else
  echo "Unknown host OS: $HOST_OS"
  exit 1
fi

trap - EXIT
