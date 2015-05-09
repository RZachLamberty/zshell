#!/bin/bash

# receive the venv name from command line
VENVNAME=$1

. $VENVNAME/bin/activate
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
deactivate

exit $?
