#!/bin/bash -xle

# boiler: every script must have these three lines
export SCRIPTROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
export CIME_MACHINE=titan
source $SCRIPTROOT/util/setup_common.sh

/bin/rm -rf ~/acme_scratch/cli115/*

cd ACME
git checkout next
git fetch
git reset --hard origin/next
git submodule update --init

set +e

echo "=============================================="
echo "STARTING PROD"
echo "=============================================="
$RUNSCRIPT --scratch-root=$PROJWORK/cli115/$USER -j 4 -t e3sm_prod -O master --baseline-compare=yes

echo "=============================================="
echo "STARTING HI RES"
echo "=============================================="
$RUNSCRIPT --scratch-root=$PROJWORK/cli115/$USER -j 4 -t e3sm_hi_res

echo "=============================================="
echo "STARTING HI DEVELOPER"
echo "=============================================="
$RUNSCRIPT --scratch-root=$PROJWORK/cli115/$USER -j 4

chmod a+rX -R $PROJWORK/cli115/$USER
