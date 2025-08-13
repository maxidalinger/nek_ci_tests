turbPipePeriodic
================

.. _turbPipePeriodic:

The *turbPipePeriodic* case comprises LES in a pipe of non-dimensional diameter :math:`D` of unity and bulk Reynolds number :math:`Re_b` equal to 19000, defined as,

.. math::

  Re_b = \frac{U_b D}{\nu}

where :math:`U_b` is the bulk viscosity and :math:`\nu` is the kinematic viscosity. 
The corresponding friction Reynolds number is :math:`Re_\tau \approx 550`.
For sub-grid modelling, the simulation employs the high-pass filtering approach from Stolz et al. [Stolz2005]_ with a cut-off wave number of :math:`N-1` used for constructing the low-pass filter and filter strength of 10.
The simulation results are verified by obtaining the time-averaged velocity fields and subsequently evaluating the friction velocity :math:`u_\tau`. Thus,

.. math::

  u_\tau = \sqrt{\frac{\tau_w}{\rho}}

.. math::

  \tau_w = 2 \mu \left| \underline{S} \cdot \vec{n} \right|_w

.. math::

  \underline{S} = \frac{1}{2} \left(\nabla \overline{\vec{v}} + \nabla \overline{\vec{v}}^T \right)

where :math:`\overline{\vec{v}}` is the time-averaged velocity vector, :math:`\tau_w` is the computed wall shear stress, :math:`\rho` is the density, 
:math:`\mu` is the dynamic viscosity, :math:`\underline{S}` is the rate-of-stress tensor, and :math:`\vec{n}` is the unit normal vector to the wall.
The computed friction velocity is benchmarked against the DNS data from El Khoury et al [Khoury2013]_, i.e.,

.. math::

  err = |u_\tau - u_{\tau_{DNS}}| < 1.00E-01

where

.. math::

  u_{\tau_{DNS}} = 5.79E-02
