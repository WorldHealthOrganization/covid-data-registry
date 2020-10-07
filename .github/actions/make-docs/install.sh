#!/bin/bash
###############################################################################
# Install base container dependencies.
###############################################################################
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
execOrExit make -C "${GITHUB_WORKSPACE}/scripts/make-docs" pip_install
python --version
exit $?
