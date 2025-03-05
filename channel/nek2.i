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
[]

P_U0 = 1.0
P_PI = 4.0*atan(1.0)
P_PHX = ${P_PI}/2.0
P_PHY = ${P_PI}/2.0
P_ROT = ${P_PI}/4.0
P_EPS = 0.1


[Functions]
  [uexact]
    type = ParsedFunction
    expression = '${P_U0} * cos(${P_PI}*xrot + ${P_PHX}) * sin(2.0*${P_PI}*yrot + ${P_PHY})'
    symbol_names = 'xrot yrot'
    symbol_values = 'xrot yrot'
  []
  [vexact]
    type = ParsedFunction
    expression = '-0.5 * ${P_U0} * sin(${P_PI}*xrot + ${P_PHX}) * cos(2.0*${P_PI}*yrot + ${P_PHY})'
    symbol_names = 'xrot yrot'
    symbol_values = 'xrot yrot'
  []
  [xrot]
    type = ParsedFunction
    expression = 'x * cos(${P_ROT}) + y * sin(${P_ROT})'
  []
  [yrot]
    type = ParsedFunction
    expression = '-x * sin(${P_ROT}) + y * cos(${P_ROT})'
  []
  [ur]
    type = ParsedFunction
    expression = 'uexact * cos(${P_ROT}) - vexact * sin(${P_ROT})'
    symbol_names = 'uexact vexact'
    symbol_values = 'uexact vexact'
  []
  [vr]
    type = ParsedFunction
    expression = 'uexact * sin(${P_ROT}) + vexact * cos(${P_ROT})'
    symbol_names = 'uexact vexact'
    symbol_values = 'uexact vexact'
  []
[]

[Postprocessors]
  [uerrl2]
    type = NekVolumeNorm
    field = velocity_x
    function = ur
    execute_on = final
  []
  [verrl2]
    type = NekVolumeNorm
    field = velocity_y
    function = vr
    execute_on = final
  []
  [urelerr]
    type = ParsedPostprocessor
    expression = 'abs((uerrl2 - 1.66e-9)/uerrl2)'
    pp_names = 'uerrl2'
    execute_on = final
  []
  [vrelerr]
    type = ParsedPostprocessor
    expression = 'abs((verrl2 - 1.66e-9)/verrl2)'
    pp_names = 'verrl2'
    execute_on = final
  []
  [pass]
    type = ParsedPostprocessor
    expression = 'if(urelerr < ${P_EPS} &
                     vrelerr < ${P_EPS}, 1, 0)'
    pp_names = 'urelerr vrelerr'
    execute_on = final
  []
[]
