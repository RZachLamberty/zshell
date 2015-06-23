#!/bin/bash

# update this list of there are venvs saved in a different directory
VENVDIRS=(~/venv ~/venvs ~/.virtualenvs)

# pass package name at command line -- no name --> all packages will be included
PYPACK=$1

OUTPUT="VENV_LOCATION PACKAGE VERSION"
OUTPUT="${OUTPUT}\n------------- ------- -------"
for D in ${VENVDIRS[*]}; do
    if [ -d ${D} ]; then
        for VENVACT in $(find ${D}/*/bin/activate); do
            VENVNAME=$(dirname $(dirname ${VENVACT}))

            . ${VENVACT}

            for FREEZEMATCH in $(pip freeze | grep "${PYPACK}==" -); do
                OLDIFS=$IFS
                IFS="=="
                read -a LIBVERS <<< ${FREEZEMATCH}
                IFS=${OLDIFS}
                OUTPUT="${OUTPUT}\n${VENVNAME} ${LIBVERS}"
            done

            deactivate
        done
    fi
done

echo ""
echo -e ${OUTPUT} | column -t
echo ""
