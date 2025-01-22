from cycler import cycler
import math
import numpy as np
import os
import time
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
from scipy.optimize import fsolve

def plotnow(fname,xlabel,ylabel,x,y,labels,lstyles,mrks,ptype='line'):
    default_cycler = (cycler(color=['k','b','r','b','r','m'])*\
                      cycler(linestyle=['-'])*cycler(marker=['']))
    plt.rc('lines',linewidth=1)
    plt.rc('axes',prop_cycle=default_cycler)
    fig = plt.figure(figsize=(7,5))
    
    ax = fig.add_subplot(111)  

    ax.set_xlabel(xlabel,fontsize=15)
    ax.set_ylabel(ylabel,fontsize=15)
    ax.tick_params(axis='both',labelsize=12)

    for i in range(len(y)):
        if(ptype=='line'):
            ax.plot(x[i],y[i],label=labels[i],linestyle=lstyles[i],marker=mrks[i],linewidth = 1.5)
        elif(ptype=='semilogx'):
            ax.semilogx(x[i],y[i],label=labels[i],linestyle=lstyles[i],marker=mrks[i],linewidth=1.5)
        elif(ptype=='semilogy'):
            ax.semilogy(x[i],y[i],label=labels[i],linestyle=lstyles[i],marker=mrks[i])
        else:
            ax.loglog(x[i],y[i],label=labels[i],linestyle=lstyles[i],marker=mrks[i])

    ax.grid()
        
    ax.legend(loc='best',fontsize=12)
    fig.savefig(fname+'.png',\
                bbox_inches='tight',dpi=100)
    plt.close()
    return

def main():
    U_L2 = np.array([0.00176676, 1.19753e-05, 1.01547e-07, 7.77307e-10])
    U_Linf = np.array([0.0120542, 6.59977e-05, 3.97381e-07, 6.87492e-09])

    V_L2 = np.array([0.00317457, 2.20655e-05, 1.11008e-07, 1.51783e-09])
    V_Linf = np.array([0.0119663, 8.67333e-05, 4.24398e-07, 1.05003e-08])

    S_L2 = np.array([0.000833777, 1.07024e-05, 1.00503e-07, 6.22368e-10])
    S_Linf = np.array([0.00805548, 6.22582e-05, 4.01601e-07, 1.93221e-09])
    
    N = np.array([3,5,7,9])

    lbs = ['$U$','$V$','$s$']
    lstyles = ['-','-','-']
    mrks = ['.','o','^']
    
    x = [N,N,N]
    
    y = [U_L2,V_L2,S_L2]
    plotnow('L2','N','$\|e\|_{L2}$',x,y,lbs,lstyles,mrks,ptype='semilogy')

    y = [U_Linf,V_Linf,S_Linf]
    plotnow('Linf','N','$\|e\|_{L\infty}$',x,y,lbs,lstyles,mrks,ptype='semilogy')

    return


if __name__=="__main__":
    starttime = time.time()
    main()
    print('--- Code ran in %s seconds ---'%(time.time()-starttime))
