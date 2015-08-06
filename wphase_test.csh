#!/bin/csh -f
# Simple wphase test

# Setting up the environment
setenv GF_PATH ./GFS
setenv RDSEED  ../bin/rdseed
setenv GMT_BIN "None"
setenv OMP_NUM_THREADS 4

# Get data
tar xzf run_test.tgz
cd run_test

# Run inversion
echo "-- Testing RUNA3 --"
${WPHASE_HOME}/bin/RUNA3.csh

# Check RUNA3 results
set result=`diff WCMTSOLUTION results/WCMTSOLUTION | wc -l`
if ( $result != 0 ) then
    echo "WCMTSOLUTION and results/WCMTSOLUTION are different"
    exit(1)
endif

# Run grid-search
echo "-- Testing grid-search --"
python ${WPHASE_HOME}/bin/wp_grid_search.py

# Check grid-search results
set result=`diff xy_WCMTSOLUTION results/xy_WCMTSOLUTION | wc -l`
if ( $result != 0 ) then
    echo "xy_WCMTSOLUTION and results/xy_WCMTSOLUTION are different"
    exit(1)
endif

# Run traces
echo "-- Testing traces.py --"
${WPHASE_HOME}/bin/traces.py
if ( ! -e wp_pages.pdf ) then
     echo "ERROR using traces.py"
     exit(1)
endif
