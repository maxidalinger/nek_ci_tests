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
    default_cycler = (cycler(color=['k','r','b','m','r','m'])*\
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
    V_L2 = np.array([1.3016024497835227E-003,8.3462813759914994E-006,4.7768079804765199E-008,2.7758729399331418E-010])

    p_L2 = np.array([1.4752238575401048E-003,1.6243785490603259E-005,1.0766100529072797E-007,6.9840694842882102E-010])

    T_L2 = np.array([1.6083734056314690E-005,1.5108504735978946E-007,9.4784106566589838E-010,6.6717269962170952E-012])

    S_L2 = np.array([1.8663036118758199E-005,1.6897400715209529E-007,1.0713501468344161E-009,7.4942469823921817E-012])
    
    N = np.array([3,5,7,9])

    lbs = ['$u$','$p$','$s_1$','$s_2$']
    lstyles = ['-','-','-','-']
    mrks = ['.','o','^','*']
    
    x = [N,N,N,N]
    
    y = [V_L2,p_L2,T_L2,S_L2]
    plotnow('err','N','$\|e\|_{L2}$',x,y,lbs,lstyles,mrks,ptype='semilogy')
    return


if __name__=="__main__":
    starttime = time.time()
    main()
    print('--- Code ran in %s seconds ---'%(time.time()-starttime))
