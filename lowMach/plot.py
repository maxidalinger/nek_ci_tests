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
    V_L2 = np.array([2.1160E-03,2.0473E-05,5.0289E-06])
    V_Linf = np.array([4.7896E-03,6.6190E-05,1.5999E-05])

    T_L2 = np.array([5.5042E-04,4.9927E-06,9.9020E-08])
    T_Linf = np.array([1.3040E-03,1.6969E-05,3.0758E-07])

    p_L2 = np.array([1.9256E-01,1.8239E-03,5.2077E-04])
    p_Linf = np.array([8.0489E-01,1.2920E-02,3.1963E-03])
    
    N = np.array([3,5,7])

    lbs = ['L2','Linf']
    lstyles = ['-','-']
    mrks = ['.','.']
    
    x = [N,N]
    
    y = [V_L2,V_Linf]
    plotnow('verr','N','err',x,y,lbs,lstyles,mrks,ptype='semilogy')

    y = [T_L2,T_Linf]
    plotnow('Terr','N','err',x,y,lbs,lstyles,mrks,ptype='semilogy')

    y = [p_L2,p_Linf]
    plotnow('perr','N','err',x,y,lbs,lstyles,mrks,ptype='semilogy')
    return


if __name__=="__main__":
    starttime = time.time()
    main()
    print('--- Code ran in %s seconds ---'%(time.time()-starttime))
