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
    VX_Linf = np.array([2.0947E-03, 5.5431E-06, 9.5909E-09, 8.7320E-11])
    VY_Linf = np.array([8.5677E-03, 4.5143E-05, 2.3012E-07, 6.3808E-10])

    VX_L2 = np.array([8.2159E-04, 1.5761E-06, 2.0435E-09, 2.5657E-12])
    VY_L2 = np.array([1.8438E-03, 1.3058E-05, 4.0328E-08, 5.4523E-11])
    
    N = np.array([3,5,7,9])

    lbs = ['VX','VY']
    lstyles = ['-','-']
    mrks = ['.','.']
    
    x = [N,N]
    
    y = [VX_Linf,VY_Linf]
    plotnow('Linf','N','$\|e\|_{L_\infty}$',x,y,lbs,lstyles,mrks,ptype='semilogy')

    y = [VX_L2,VY_L2]
    plotnow('L2','N','$\|e\|_{L_2}$',x,y,lbs,lstyles,mrks,ptype='semilogy')

    return


if __name__=="__main__":
    starttime = time.time()
    main()
    print('--- Code ran in %s seconds ---'%(time.time()-starttime))
