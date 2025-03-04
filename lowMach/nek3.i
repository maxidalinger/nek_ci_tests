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
[]

P_DELTA = 0.2
P_EPS = 0.1

[Functions]
  [uexact]
    type = ParsedFunction
    value = '0.5 * (3.0 + tanh(xd))'
    symbol_names = 'xd'
    symbol_values = 'xd'
  []
  [xd]
    type = ParsedFunction
    value = 'x / ${P_DELTA}'
  []
  [aa]
    type = ParsedFunction
    value = '3./2. - (tanh(1.0) - tanh(-1.0))/3.0'
  []
  [qtle]
    type = ParsedFunction
    value = '0.5/${P_DELTA} * (1.0 - (tanh(xd) * tanh(xd)))'
    symbol_names = 'xd'
    symbol_values = 'xd'
  []
  [pexact]
    type = ParsedFunction
    value = '4./3.0 * qtle - uexact + aa'
    symbol_names = 'qtle uexact aa'
    symbol_values = 'qtle uexact aa'
  []
  [unitFunction]
    type = ParsedFunction
    value = '1.0'
  []
  [pexactScaled]
    type = ParsedFunction
    expression = 'pexact + pscale'
    symbol_names = 'pexact pscale'
    symbol_values = 'pexact pscale'
  []
[]

[Postprocessors]
  [uxerrl2]
    type = NekVolumeNorm
    field = velocity_x
    function = uexact
    execute_on = final
  []
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
  [perrl2]
    type = NekVolumeNorm
    field = pressure
    function = pexactScaled
    execute_on = final
  []
  [uxrelerr]
    type = ParsedPostprocessor
    expression = 'abs((uxerrl2 - 7.55e-6)/uxerrl2)'
    pp_names = 'uxerrl2'
    execute_on = final
  []
  [prelerr]
    type = ParsedPostprocessor
    expression = 'abs((perrl2 - 7.35e-4)/perrl2)'
    pp_names = 'perrl2'
    execute_on = final
  []
  [pass]
    type = ParsedPostprocessor
    expression = 'if(uxrelerr < ${P_EPS} &
                      prelerr < ${P_EPS}, 1, 0)'
    pp_names = 'uxrelerr prelerr'
    execute_on = final
  []
[]
