turbPipePeriodic
================

.. _turbPipePeriodic:

The *turbPipePeriodic* case comprises LES in a pipe of non-dimensional diameter of unity and bulk Reynolds number equal to 19000, defined as,

.. math::

  Re_b = \frac{U_b D}{\nu}

where, :math:`U_b` is the bulk viscosity and :math:`\nu` is the kinematic viscosity. 
The corresponding friction Reynolds number is :math:`Re_\tau \approx 550`.
For sub-grid modelling, the simulation employs the high-pass filtering approach from Stolz et al [Stolz2005]_ with a cut-off wave number of :math:`N-1` used for constructing the low pass filter and filter strength of 10.
The simulation results are verified by obtaining the time-averaged velocity fields and subsequently evaluating the friction velocity. Thus,

.. math::

  u_\tau = \sqrt{\frac{\tau_w}{\rho}}; \,\, \tau_w = 2 \mu \left| \underline{S} \cdot \vec{n} \right|_w; \,\, \underline{S} = \frac{1}{2} \left(\nabla \overline{\vec{v}} + \nabla \overline{\vec{v}}^T \right)

where, :math:`\overline{\vec{v}}` is the time averaged velocity vector.
The computed friction velocity is benchmarked against the DNS data from El Khoury et al [Khoury2013]_, i.e.,

.. math::

  err = |u_\tau - u_{\tau_{DNS}}|; \,\, u_{\tau_{DNS}} = 5.79E-02
