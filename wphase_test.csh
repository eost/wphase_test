#!/bin/csh -f
# Simple wphase test

# Setting up the environment
setenv GF_PATH ./GFS
setenv GMT_BIN "None"
setenv RDSEED  "None"

# Get data
# wget http://wphase.unistra.fr/run_test.tgz
tar xzf run_test.tgz
cd run_test

# Run inversion
echo "-- Testing RUNA3_lite --"
${WPHASE_HOME}/bin/RUNA3_lite.csh

# Check RUNA3 results
set result=`diff WCMTSOLUTION results/WCMTSOLUTION | wc -l`
if ( $result != 0 ) then
    exit(1)
endif

# Run grid-search
echo "-- Testing grid-search --"
python ${WPHASE_HOME}/bin/wp_grid_search.py

# Check grid-search results
set result=`diff xy_WCMTSOLUTION results/xy_WCMTSOLUTION | wc -l`
if ( $result != 0 ) then
    exit(1)
endif

