[Mesh]
  type = NekRSMesh
  volume = true
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'lowMach'
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
  #  time_step_interval = 300
  #[]
[]

P_DELTA = 0.2

TOL_V  = 1.74E-04
TOL_P  = 1.53E-02
TOL_T  = 1.58E-17
TOL    = 1.00E-11

[Functions]
  [uexact]
    type = ParsedFunction
    expression = '0.5 * (3.0 + tanh(xd))'
    symbol_names = 'xd'
    symbol_values = 'xd'
  []
  [xd]
    type = ParsedFunction
    expression = 'x / ${P_DELTA}'
  []
  [aa]
    type = ParsedFunction
    expression = '3./2. - (tanh(1.0) - tanh(-1.0))/3.0'
  []
  [qtle]
    type = ParsedFunction
    expression = '0.5/${P_DELTA} * (1.0 - (tanh(xd) * tanh(xd)))'
    symbol_names = 'xd'
    symbol_values = 'xd'
  []
  [pexact]
    type = ParsedFunction
    expression = '4./3.0 * qtle - uexact + aa'
    symbol_names = 'qtle uexact aa'
    symbol_values = 'qtle uexact aa'
  []
  [unitFunction]
    type = ParsedFunction
    expression = '1.0'
  []
  [pexactScaled]
    type = ParsedFunction
    expression = 'pexact + pscale'
    symbol_names = 'pexact pscale'
    symbol_values = 'pexact pscale'
  []
[]

[Postprocessors]
  # Calculate parameters for exact solution
  [volume]
    type = NekVolumeIntegral
    field = unity
    function = unitFunction
    execute_on = final
  []
  [pbar]
    type = NekVolumeIntegral
    field = pressure
    execute_on = final
  []
  [pbre]
    type = NekVolumeIntegral
    field = unity
    function = pexact
    execute_on = final
  []
  [pscale]
    type = ParsedPostprocessor
    expression = '(pbar - pbre)/volume'
    pp_names = 'pbar pbre volume'
    execute_on = final
  []
  
  # Calculate L2 errors
  [uxerrl2]
    type = NekVolumeNorm
    field = velocity_x
    function = uexact
    execute_on = final
  []
  [terrl2]
    type = NekVolumeNorm
    field = temperature
    function = uexact
    execute_on = final
  []
  [perrl2]
    type = NekVolumeNorm
    field = pressure
    function = pexactScaled
    execute_on = final
  []
  
  # Check if all test passed
  [pass]
    type = ParsedPostprocessor
    expression = 'if((uxerrl2 < ${TOL_V} | uxerrl2 < ${TOL}) &
                     ( terrl2 < ${TOL_T} |  terrl2 < ${TOL}) &
                     ( perrl2 < ${TOL_P} |  perrl2 < ${TOL}), 1, 0)'
    pp_names = 'uxerrl2 terrl2 perrl2'
    execute_on = final
  []
[]
