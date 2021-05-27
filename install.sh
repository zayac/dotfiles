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

usage() {
  echo "./install [options] [roles...]"
  echo "Supported options:"
  echo "  -h/--help"
  echo "  -v/--verbose (repeat for more verbosity)"
  echo "Other options (passed through to Ansible):"
  echo "Supported roles:"
  for ROLE in $(ls roles); do
    echo "  $ROLE"
    echo "    $(cat roles/$ROLE/description)"
  done
}

while [ $# -gt 0 ]; do
  if [ "$1" = '--verbose' -o "$1" = '-v' ]; then
    VERBOSE=$((VERBOSE + 1))
  elif [ "$1" = '--help' -o "$1" = '-h' -o "$1" = 'help' ]; then
    usage
    exit
  elif [ -n "$1" ]; then
    if [ -d "roles/$1" ]; then
      if [ -z "$ROLES" ]; then
        ROLES="--tags $1"
      else
        ROLES="$ROLES,$1"
      fi
    else
      echo "Unrecognized argument(s): $*"
      usage
      exit 1
    fi
  fi
  shift
done

if [[ $VERBOSE ]]; then
  DEV_NULL=/dev/stdout
  if [ $VERBOSE -gt 1 ]; then
    echo 'Enabling extremely verbose output'
    set -x
  fi
else
  trap 'echo "Exiting: run with -v/--verbose for more info"' EXIT
  DEV_NULL=/dev/null
fi

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

source $ANSIBLE_ENV_SETUP &> $DEV_NULL

HOST_OS=$(uname)

if [ "$HOST_OS" = 'Darwin' ]; then
  ansible-playbook --ask-become-pass -i inventory ${VERBOSE+-v} ${ROLES} darwin.yml
else
  echo "Unknown host OS: $HOST_OS"
  exit 1
fi

trap - EXIT
