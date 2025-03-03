[Mesh]
  type = NekRSMesh
  volume = true
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'ethier'
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
[]

P_U0 = 0.5
P_V0 = 0.1
P_W0 = 0.2
P_A0 = 0.025
P_D0 = 0.5
P_EPS = 0.1
a = ${fparse pi * P_A0}
nu = ${fparse 1/100}
d = ${fparse pi * P_D0}

[Functions]
  [unitFunction]
    type = ParsedFunction
    value = '1.0'
  []
  [uexact]
    type = ParsedFunction
    value = '-${a} * (ex * syz + ez * cxy) * e2t + ${P_U0}'
    symbol_names = 'ex syz ez cxy e2t'
    symbol_values = 'ex syz ez cxy e2t'
  []
  [pexact]
    type = ParsedFunction
    value = '-0.5 * ${a} * ${a} * e2t * e2t * (ex * ex + 2.0 * sxy * czx * eyz
                                              +ey * ey + 2.0 * syz * cxy * ezx
                                              +ez * ez + 2.0 * szx * cyz * exy)'
    symbol_names = 'e2t ex ey ez sxy syz szx cxy cyz czx exy eyz ezx'
    symbol_values = 'e2t ex ey ez sxy syz szx cxy cyz czx exy eyz ezx'
  []
  [pexactScaled]
    type = ParsedFunction
    expression = 'pexact + pscale'
    symbol_names = 'pexact pscale'
    symbol_values = 'pexact pscale'
  []

  # we create some intermediate functions to make the formulas above a bit more
  # human-readable (and to match the intermediate variables used in the original
  # NekRS test)
  [xx]
    type = ParsedFunction
    value = 'x - ${P_U0} * t'
  []
  [yy]
    type = ParsedFunction
    value = 'y - ${P_V0} * t'
  []
  [zz]
    type = ParsedFunction
    value = 'z - ${P_W0} * t'
  []
  [ex]
    type = ParsedFunction
    value = 'exp(${a} * xx)'
    symbol_names = 'xx'
    symbol_values = 'xx'
  []
  [ey]
    type = ParsedFunction
    value = 'exp(${a} * yy)'
    symbol_names = 'yy'
    symbol_values = 'yy'
  []
  [ez]
    type = ParsedFunction
    value = 'exp(${a} * zz)'
    symbol_names = 'zz'
    symbol_values = 'zz'
  []
  [exy]
    type = ParsedFunction
    value = 'exp(${a} * (xx + yy))'
    symbol_names = 'xx yy'
    symbol_values = 'xx yy'
  []
  [eyz]
    type = ParsedFunction
    value = 'exp(${a} * (yy + zz))'
    symbol_names = 'yy zz'
    symbol_values = 'yy zz'
  []
  [ezx]
    type = ParsedFunction
    value = 'exp(${a} * (zz + xx))'
    symbol_names = 'zz xx'
    symbol_values = 'zz xx'
  []
  [e2t]
    type = ParsedFunction
    value = 'exp(-${nu} * ${d} * ${d} * t)'
  []
  [sxy]
    type = ParsedFunction
    value = 'sin(${a} * xx + ${d} * yy )'
    symbol_names = 'xx yy'
    symbol_values = 'xx yy'
  []
  [syz]
    type = ParsedFunction
    value = 'sin(${a} * yy + ${d} * zz )'
    symbol_names = 'zz yy'
    symbol_values = 'zz yy'
  []
  [szx]
    type = ParsedFunction
    value = 'sin(${a} * zz + ${d} * xx )'
    symbol_names = 'xx zz'
    symbol_values = 'xx zz'
  []
  [cxy]
    type = ParsedFunction
    value = 'cos(${a} * xx + ${d} * yy )'
    symbol_names = 'xx yy'
    symbol_values = 'xx yy'
  []
  [cyz]
    type = ParsedFunction
    value = 'cos(${a} * yy + ${d} * zz )'
    symbol_names = 'zz yy'
    symbol_values = 'zz yy'
  []
  [czx]
    type = ParsedFunction
    value = 'cos(${a} * zz + ${d} * xx )'
    symbol_names = 'xx zz'
    symbol_values = 'xx zz'
  []
[]

[Postprocessors]
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
  [serrl2]
    type = NekVolumeNorm
    field = scalar01
    function = uexact
    execute_on = final
  []
  [perrl2]
    type = NekVolumeNorm
    field = pressure
    function = pexactScaled
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
    pp_names = 'pbre pbar volume'
    execute_on = final
  []
  [uxrelerr]
    type = ParsedPostprocessor
    expression = 'abs((uxerrl2 - 2.77e-10)/uxerrl2)'
    pp_names = 'uxerrl2'
    execute_on = final
  []
  [trelerr]
    type = ParsedPostprocessor
    expression = 'abs((terrl2 - 5.42e-12)/terrl2)'
    pp_names = 'terrl2'
    execute_on = final
  []
  [srelerr]
    type = ParsedPostprocessor
    expression = 'abs((serrl2 - 6.30e-12)/serrl2)'
    pp_names = 'serrl2'
    execute_on = final
  []
  [prelerr]
    type = ParsedPostprocessor
    expression = 'abs((perrl2 - 6.98e-12)/perrl2)'
    pp_names = 'perrl2'
    execute_on = final
  []
  [pass]
    type = ParsedPostprocessor
    expression = 'if(uxrelerr < ${P_EPS} & 
                      srelerr < ${P_EPS} &
                      trelerr < ${P_EPS}, 1, 0)'
    pp_names = 'uxrelerr srelerr trelerr prelerr'
    execute_on = final
  []
[]
