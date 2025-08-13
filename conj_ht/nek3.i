[Mesh]
  type = NekRSMesh
  volume = true
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'conj_ht'
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
  #  time_step_interval = 100
  #[]
[]

P_EPS = 0.1

[Functions]
  [uexact]
    type = ParsedFunction
    expression = 'if(y<0.0, 0.0, if(y>1.0, 0, 4.0 * y * (1.0 - y)))'
  []
[]

[Postprocessors]
  [uxerrl2]
    type = NekVolumeNorm
    field = velocity_x
    function = uexact
    execute_on = final
  []
  [uxrelerr]
    type = ParsedPostprocessor
    expression = 'abs((uxerrl2 - 4.24e-07)/uxerrl2)'
    pp_names = 'uxerrl2'
    execute_on = final
  []
  [pass]
    type = ParsedPostprocessor
    expression = 'if(uxrelerr < ${P_EPS}, 1, 0)'
    pp_names = 'uxrelerr'
    execute_on = final
  []
[]
