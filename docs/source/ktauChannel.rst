ktauChannel
===========

.. _ktauChannel:

The case comprises turbulent flow in an infinite half-channel at Reynolds number, :math:`Re=43500`, based on the bulk velocity, :math:`U_b`, and half-channel width, :math:`L`, as follows,

.. math::
  
  Re = \frac{U_b L}{\nu}

where :math:`\nu` is the kinematic viscosity.
The simulation is performed using the standard :math:`k`-:math:`\tau` RANS model [Tombo2024]_, which is the default two-equation RANS model in NekRS.
The corresponding friction Reynolds number :math:`Re_\tau`, based on the friction velocity :math:`u_\tau`, is approximately 2000, and calculated as follows,

.. math::

  Re_\tau = \frac{u_\tau L}{\nu}

.. math::
  
  u_\tau = \sqrt{\frac{\tau_w}{\rho}}

where :math:`\tau_w` is the computed wall shear stress, and :math:`\rho` is the density.
The case is benchmarked by evaluating friction velocity against the widely accepted DNS data by Lee et al. [Lee2015]_.
To pass the test, the absolute error must be

.. math::

  err = |u_\tau - u_{\tau_{DNS}}| < 5.53E-04

where

.. math::

  u_{\tau_{DNS}} = 4.58E-02

The reference error was obtained running the simulation in Sawtooth using a polynomial order of 3.
The test runs with a polynomial order of 5.