ktauChannel
===========

.. _ktauChannel:

The case comprises turbulent flow in an infinite half-channel at Reynolds number, :math:`Re=43500`, based on the bulk velocity, :math:`U_b`, and half-channel width, :math:`L`, as follows,

.. math::
  
  Re = \frac{U_b L}{\nu}

where, :math:`\nu` is the kinematic viscosity.
The simulation is performed using the standard :math:`k`-:math:`\tau` RANS model [Tombo2024]_, which is the default two-equation RANS model in NekRS.
The corresponding friction Reynolds number, based on the friction velocity :math:`u_\tau`, is approximately 2000,

.. math::

  Re_\tau = \frac{u_\tau L}{\nu}; \,\, u_\tau = \sqrt{\frac{\tau_w}{\rho}}

where :math:`\tau_w` is the computed wall shear stress.
The case is benchmarked by evaluating friction velocity against the widely accepted DNS data by Lee et al [Lee2015]_.
