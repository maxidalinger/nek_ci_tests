[Mesh]
  type = NekRSMesh
  volume = true
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'channel'
[]

[Executioner]
  type = Transient

  [TimeStepper]
    type = NekTimeStepper
  []
[]

[Outputs]
  csv = true
  show = 'pass'
  execute_on = final
  console = false
  file_base = 'nek_out'
  #[console]
  #  type = Console
  #  time_step_interval = 1000
  #[]
  #[csv]
  #  type = CSV
  #  time_step_interval = 1
  #[]
[]

# Reference value from:
# https://turbulence.oden.utexas.edu/channel2015/data/LM_Channel_2000_mean_prof.dat
utau_ref = 4.58794E-02
P_EPS = 5.53E-03

[Postprocessors]
  [drag]
    type = NekViscousSurfaceForce
    boundary = '1'
    mesh = fluid
  []
  [area]
    type = NekSideIntegral
    field = unity
    boundary = '1'
  []
  [utau]
    type = ParsedPostprocessor
    expression = 'sqrt(drag/area)'
    pp_names = 'drag area'
  []
  [err]
    type = ParsedPostprocessor
    expression = 'abs(utau - ${utau_ref})'
    pp_names = 'utau'
  []
  [pass]
    type = ParsedPostprocessor
    expression = 'if (err < ${P_EPS}, 1, 0)'
    pp_names = 'err'
  []
[]
