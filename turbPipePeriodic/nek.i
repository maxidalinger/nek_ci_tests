[Mesh]
  type = NekRSMesh
  volume = true
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'turbPipe'
[]

[Executioner]
  type = Transient

  [TimeStepper]
    type = NekTimeStepper
  []
[]

[Outputs]
  csv = true
  execute_on = final
  show = 'pass'
  console = false
  file_base = 'nek_out'
[]

P_utauRef = 5.7901316173625254E-02 #https://www.lstm.tf.fau.de/database/simulation-database/
P_EPS = 2e-2

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
  [rel_err]
    type = ParsedPostprocessor
    expression = 'abs(utau - ${P_utauRef}) / ${P_utauRef}'
    pp_names = 'utau'
  []
  [pass]
    type = ParsedPostprocessor
    expression = 'if (rel_err < ${P_EPS}, 1, 0)'
    pp_names = 'rel_err'
  []
[]
