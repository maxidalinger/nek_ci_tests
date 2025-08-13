shlChannel
==========

.. _shlChannel:

NekRS can model the traction boundary condition, specifying a non-zero traction in the tangent and bitangent directions.
This boundary type requires the full-stress formulation for the Navier-Stokes equations.
The test *shlChannel*, which utilizes this boundary type, is presented.

A simple 2D square geometry is used for the test.
The solution to the problem is the following,

.. math::
  
  u(y) = 1.5 * (1.0 - y^2)

where :math:`u` is the velocity in the :math:`x`-direction, and :math:`y` is the spatial coordinate. 

The CI mode 1 performs the tests with the original geometry, and CI mode 2 rotates the geometry 45 degrees.
The solution fields are :math:`\phi=\{u,v\}`, corresponding to each component of the velocity vector.
To pass the test, the :math:`L_2`-norm between the NekRS solution and the exact solution must be below a specified tolerance.