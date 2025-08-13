[Mesh]
  type = NekRSMesh
  volume = true
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'mv_cyl'
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

XLEN = 1.0
YLEN = 1.5
ZLEN = 0.1
P_GAMMA = 1.4
P_OMEGA = 3.141592653589793
P_AMP = 1.5707963267948966
P_ROT = 0.0
pex0   = 1.0

TOL_Volume  = 4.86E-04
TOL_p0th    = 2.99E-04
TOL_dp0thdt = 5.94E-05
TOL_tavg    = 1.14E-05
TOL_termV   = 3.47E-17
TOL_ypist   = 2.45E-04
TOL         = 1.00E-11

ITER_V = 3
ITER_P = 5
ITER_T = 4
ITER_delta = 2

# Exact solution from usr file
[Functions]
  [unitFunction]
    type = ParsedFunction
    expression = '1.0'
  []
  [areap]
    type = ParsedFunction
    expression = '${XLEN} * ${ZLEN}'
  []
  [volex0]
    type = ParsedFunction
    expression = 'areap * ${YLEN}'
    symbol_names = 'areap'
    symbol_values = 'areap'
  []
  [vpex]
    type = ParsedFunction
    expression = '${P_AMP} * sin(${P_OMEGA} * t)'
  []
  [volex]
    type = ParsedFunction
    expression = 'volex0 + areap * ${P_AMP} * (cos(${P_OMEGA} * t) - 1.0) / ${P_OMEGA}'
    symbol_names = 'volex0 areap'
    symbol_values = 'volex0 areap'
  []
  [pex]
    type = ParsedFunction
    expression = '${pex0} * (volex0 / volex)^${P_GAMMA}'
    symbol_names = 'volex0 volex'
    symbol_values = 'volex0 volex'
  []
  [dpdtex]
    type = ParsedFunction
    expression = '${P_GAMMA} * ${pex0} * volex0^${P_GAMMA} * areap * vpex / volex^(${P_GAMMA} + 1.0)'
    symbol_names = 'volex0 areap vpex volex'
    symbol_values = 'volex0 areap vpex volex'
  []
  [qtlex]
    type = ParsedFunction
    expression = '((${P_GAMMA} - 1.0) / ${P_GAMMA} - 1.0) * dpdtex / pex'
    symbol_names = 'dpdtex pex'
    symbol_values = 'dpdtex pex'
  []
  [ypex]
    type = ParsedFunction
    expression = '-0.5 * (1.0 + cos(${P_OMEGA} * t)) * cos(${P_ROT})'
  []
  [tex]
    type = ParsedFunction
    expression = 'pex^((${P_GAMMA} - 1.0) / ${P_GAMMA})'
    symbol_names = 'pex'
    symbol_values = 'pex'
  []
  [termVex]
    type = ParsedFunction
    expression = 'vpex * ${XLEN} * ${ZLEN}'
    symbol_names = 'vpex'
    symbol_values = 'vpex'
  []
[]

[Postprocessors]
  # Calculation of NekRS solutions
  [tavg]
    type = NekVolumeAverage
    field = temperature
    execute_on = final
  []
  [volvm1]
    type = NekVolumeIntegral
    field = unity
    function = unitFunction
    execute_on = final
  []
  [p0th]
    type = NekInfoPostprocessor
    test_type = "p0th"
    execute_on = final
  []
  [dp0thdt]
    type = NekInfoPostprocessor
    test_type = "dp0thdt"
    execute_on = final
  []
  [termV_x]
    type = NekSideIntegral
    field = 'velocity_x'
    boundary = '1'
    execute_on = final
  []
  [termV_y]
    type = NekSideIntegral
    field = 'velocity_y'
    boundary = '1'
    execute_on = final
  []
  [termV]
    type = ParsedPostprocessor
    expression = '-termV_x * sin(${P_ROT}) + termV_y * cos(${P_ROT})'
    pp_names = 'termV_x termV_y'
    execute_on = final
  []
  [ypist]
    type = NekInfoPostprocessor
    test_type = "ymin"
    execute_on = final
  []
  
  # Calculation exact values
  [tavg_ex]
    type = FunctionValuePostprocessor
    function = tex
    execute_on = final
  []
  [volvm1_ex]
    type = FunctionValuePostprocessor
    function = volex
    execute_on = final
  []
  [pp_termVex]
    type = FunctionValuePostprocessor
    function = termVex
    execute_on = final
  []
  [pp_pex]
    type = FunctionValuePostprocessor
    function = pex
    execute_on = final
  []
  [pp_dpdtex]
    type = FunctionValuePostprocessor
    function = dpdtex
    execute_on = final
  []
  [pp_ypex]
    type = FunctionValuePostprocessor
    function = ypex
    execute_on = final
  []
  
  # Error calculations
  [temp_error]
    type = ParsedPostprocessor
    expression = 'abs(tavg - tavg_ex)'
    pp_names = 'tavg tavg_ex'
    execute_on = final
  []
  [vol_error]
    type = ParsedPostprocessor
    expression = 'abs(volvm1_ex - volvm1)'
    pp_names = 'volvm1_ex volvm1'
    execute_on = final
  []
  [p0th_error]
    type = ParsedPostprocessor
    expression = 'abs(pp_pex - p0th)'
    pp_names = 'pp_pex p0th'
    execute_on = final
  []
  [dp0thdt_error]
    type = ParsedPostprocessor
    expression = 'abs(pp_dpdtex - dp0thdt)'
    pp_names = 'pp_dpdtex dp0thdt'
    execute_on = final
  []
  [termV_error]
    type = ParsedPostprocessor
    expression = 'abs(pp_termVex - termV)'
    pp_names = 'pp_termVex termV'
    execute_on = final
  []
  [ypist_error]
    type = ParsedPostprocessor
    expression = 'abs(pp_ypex - ypist)'
    pp_names = 'pp_ypex ypist'
    execute_on = final
  []
  
  # Calculate number of iterations
  [v_iterations]
    type = NekInfoPostprocessor
    test_type = 'n_iter_velocity'
    execute_on = final
  []
  [p_iterations]
    type = NekInfoPostprocessor
    test_type = 'n_iter_pressure'
    execute_on = final
  []
  [t_iterations]
    type = NekInfoPostprocessor
    test_type = 'n_iter_temperature'
    execute_on = final
  []
  
  # Calculate difference of iterations
  [iter_v_diff]
    type = ParsedPostprocessor
    expression = 'abs(v_iterations - ${ITER_V})'
    pp_names = 'v_iterations'
    execute_on = final
  []
  [iter_p_diff]
    type = ParsedPostprocessor
    expression = 'abs(p_iterations - ${ITER_P})'
    pp_names = 'p_iterations'
    execute_on = final
  []
  [iter_t_diff]
    type = ParsedPostprocessor
    expression = 'abs(t_iterations - ${ITER_T})'
    pp_names = 't_iterations'
    execute_on = final
  []
  
  # Check if all test passed
  [pass]
    type = ParsedPostprocessor
    expression = 'if((temp_error < ${TOL_tavg}    |    temp_error < ${TOL}) &
                     (vol_error  < ${TOL_Volume}  |     vol_error < ${TOL}) &
                     (p0th_error < ${TOL_p0th}    |    p0th_error < ${TOL}) &
                  (dp0thdt_error < ${TOL_dp0thdt} | dp0thdt_error < ${TOL}) &
                    (termV_error < ${TOL_termV}   |   termV_error < ${TOL}) &
                    (ypist_error < ${TOL_ypist}   |   ypist_error < ${TOL}) &
                     iter_v_diff <= ${ITER_delta} &
                     iter_p_diff <= ${ITER_delta} &
                     iter_t_diff <= ${ITER_delta}, 1, 0)'
    pp_names = 'temp_error vol_error p0th_error dp0thdt_error termV_error ypist_error
                iter_v_diff iter_p_diff iter_t_diff'
    execute_on = final
  []
[]
