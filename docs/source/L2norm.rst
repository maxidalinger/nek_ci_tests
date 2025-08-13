:math:`L_2`-norm calculation
============================

.. _L2-norm calculation:

In general, CI tests are evaluated by computing the :math:`L_2`-norm of the error in solution fields. 

.. math::

  \epsilon_\phi = \|\phi_{exact} - \phi\|_{L_2}

.. math::

  \epsilon_\phi < \epsilon_{\phi_{ref}}

where :math:`\epsilon_{\phi_{ref}}` is the reference error used to evaluate the solver's performance.
The variables selected in the solution field :math:`\phi` for comparison with the exact solution can include the velocity components :math:`\{u,v,w\}`, the pressure :math:`p`, or passive scalars :math:`\{s0,s1\}`.
Passive scalar :math:`s0` is usually refered to as the temperature.
Reference errors were obtained in the HPC Sawtooth, while tests are performed using a polynomial order higher than the one selected for the reference error.

The :math:`L_2`-norm is calculated as

.. math::

  \|\phi\|_{L_2} = \sqrt{\sum_{i} \phi_i^2}

where :math:`\phi_i` is the value of :math:`\phi` evaluated at point :math:`i`.