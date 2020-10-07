#!/bin/bash
###############################################################################
# Execution Script.
###############################################################################
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"

make docs_registry
MAKE_STATUS=$?

exit ${MAKE_STATUS}
