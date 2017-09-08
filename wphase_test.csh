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
echo "-- Testing RUNA3_lite --"
${WPHASE_HOME}/bin/RUNA3_lite.csh
if ( $status ) then
    echo "ERROR using RUNA3_lite.csh"
    exit(1)
endif

# Check RUNA3 results
set result=`diff WCMTSOLUTION results/WCMTSOLUTION | wc -l`
if ( $result != 0 ) then
    echo "WCMTSOLUTION and results/WCMTSOLUTION are different"
    diff -wy WCMTSOLUTION results/WCMTSOLUTION
    python cmt_diff.py WCMTSOLUTION results/WCMTSOLUTION
    if ( $? != 0 ) then
        echo "Differences are significant"
       exit(1)
    else
        echo "Differences are not significant"
    endif
endif


# Run grid-search
echo "-- Testing grid-search --"
python ${WPHASE_HOME}/bin/wp_grid_search.py
if ( $status ) then
    echo "ERROR using wp_grid_search.py"
    exit(1)
endif

# Check grid-search results
set result=`diff xy_WCMTSOLUTION results/xy_WCMTSOLUTION | wc -l`
if ( $result != 0 ) then
    echo "xy_WCMTSOLUTION and results/xy_WCMTSOLUTION are different"
    diff -xy xy_WCMTSOLUTION results/xy_WCMTSOLUTION
    python cmt_diff.py xy_WCMTSOLUTION results/xy_WCMTSOLUTION
    if ( $? != 0 ) then
        echo "Differences are significant"
        exit(1)
    else
        echo  "Differences are not significant"
    endif        
endif

# Run traces
echo "-- Testing traces.py --"
if ( -e ${WPHASE_HOME}/bin/traces.py ) then
    ${WPHASE_HOME}/bin/traces.py
else
    ${WPHASE_HOME}/bin/traces_global.py
endif
if ( ( $status ) || ( ! -e wp_pages.pdf ) ) then
     echo "ERROR using traces.py"
     exit(1)
endif

# Test cmtascii
${WPHASE_HOME}/bin/cmtascii xy_WCMTSOLUTION
if ( $status )  then
     echo "ERROR using cmtascii"
     exit(1)
endif


# All done
echo "----"
echo "ALL TESTED HAVE PASSED"
