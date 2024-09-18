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
  execute_on = final
  hide = 'drag area'
[]

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
    expression = 'abs(utau - 4.58794e-2) / 4.58794e-2'
    pp_names = 'utau'
  []
  [pass]
    type = ParsedPostprocessor
    expression = 'if (rel_err < 4e-3, 1, 0)'
    pp_names = 'rel_err'
  []
[]
