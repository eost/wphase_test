
import sys
import numpy as np

def rcmtfile(cmtfil):
    '''
    Reads CMTSOLUTION file
    Args:
    * cmtfil: CMTSOLUTION filename
    '''
    L  = open(cmtfil).readlines()
    pdeline = L[0].strip('\n')
    evid  = L[1].strip().split(':')[1]
    ts    = float(L[2].strip().split(':')[1])
    hd    = float(L[3].strip().split(':')[1])
    lat   = float(L[4].strip().split(':')[1])
    lon   = float(L[5].strip().split(':')[1])
    dep   = float(L[6].strip().split(':')[1])
    MT = np.zeros((6,))
    for i in range(6):
        MT[i]=float(L[i+7].strip().split(':')[1])
    return ts,hd,lat,lon,dep,MT
            
def MTNorm(MT):
    M0 =  MT[0]*MT[0] + MT[1]*MT[1] + MT[2]*MT[2]
    M0 += 2*(MT[3]*MT[3] + MT[4]*MT[4] + MT[5]*MT[5])
    M0 = np.sqrt(M0)
    return M0

ts1,hd1,lat1,lon1,dep1,MT1 = rcmtfile(sys.argv[1])
ts2,hd2,lat2,lon2,dep2,MT2 = rcmtfile(sys.argv[2])

flag = 0

# Time/Location difference
if ts1 != ts2:
    print('Time-shift difference: %.f %f'%(ts1,ts2))
    flag += 1

if hd1 != hd2:
    print('Half-duration difference: %.f %f'%(hd1,hd2))
    flag += 1

if lon1 != lon2:
    print('Centroid longitude difference: %.f %f'%(lon1,lon2))
    flag += 1

if lat1 != lat2:
    print('Centroid latitude difference: %.f %f'%(lon1,lon2))
    flag += 1

# Moment ratio
MTN1 = MTNorm(MT1)
MTN2 = MTNorm(MT2)
if MTN1/MTN2 > 1.00001 or MTN2/MTN1 > 1.00001:
    print('Moment ratio different from one: %f'%(MTN1/MTN2))
    flag += 1
else:
    print('Moment ratio is: %f'%(MTN1/MTN2))


# Focal mechanism
MTn1 = MT1/MTN1
MTn2 = MT2/MTN2
DMT = MTn1 - MTn2
D = MTNorm(DMT)/(2*np.sqrt(2))
A = 2.*np.arcsin(D)*180./np.pi

if np.abs(A)>0.001:
    print('Focal mechanisms are significantly different. Angular distance: %f'%(A))
    flag += 1
else:
    print('Focal mechanism angular distance is: %f deg'%(A))

exit(flag)
