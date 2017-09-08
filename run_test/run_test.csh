#!/bin/csh -f

# Setting up the environment
setenv GF_PATH ./GFS
setenv GMT_BIN "None"
setenv RDSEED  "None"

# Run inversion
${WPHASE_HOME}/bin/RUNA3_lite.csh

# Check results
set result=`diff WCMTSOLUTION results/WCMTSOLUTION | wc -l`
if ( $result == 0 ) then
    exit(0)
else
    exit(1)
endif
