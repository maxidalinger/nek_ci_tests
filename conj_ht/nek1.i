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

Pe    = 1000.0         # Pecklet number
q     =    1.0         # Heat source of each plate
k     =   10.0         # Solid conductivity / Fluid conductivity
HP_H  =    0.5         # Solid plate height / Fluid height
c1    = ${fparse -Pe * q / k}
c2    = ${fparse -Pe * q * HP_H}
c3    = ${fparse 2.0 * q * HP_H}
c4    = ${fparse -c2 * 17/70}

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
[]

TOL_U = 3.00E-09
TOL_T = 1.00E-05
TOL   = 1.00E-11

[Functions]
  [uexact]
    type = ParsedFunction
    expression = 'if(y<0, 0, if(y>1, 0, 6 * y * (1 - y)))'
  []
  [t_solid_superior]
    type = ParsedFunction
    expression = '${c1} * (y^2/2 - y*(1+${HP_H}) + (0.5+${HP_H})) + ${c4} + ${c3} * x'
  []
  [t_solid_inferior]
    type = ParsedFunction
    expression = '${c1} * (y^2/2 + y*${HP_H}) + ${c4} + ${c3} * x'
  []
  [t_fluid]
    type = ParsedFunction
    expression = '${c2} * (y^4 - 2*y^3 + y) + ${c4} + ${c3} * x'
  []
  [texact]
    type = ParsedFunction
    expression = 'if(y>1.0, t_solid_superior, if(y<0.0, t_solid_inferior, t_fluid))'
    symbol_names  = 't_solid_superior t_solid_inferior t_fluid'
    symbol_values = 't_solid_superior t_solid_inferior t_fluid'
  []
[]

[Postprocessors]
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
    function = texact
    execute_on = final
  []
  
  # Check if all tests passed
  [pass]
    type = ParsedPostprocessor
    expression = 'if((uxerrl2 < ${TOL_U} | uxerrl2 < ${TOL}) &
                     ( terrl2 < ${TOL_T} |  terrl2 < ${TOL}), 1, 0)'
    pp_names = 'uxerrl2 terrl2'
    execute_on = final
  []
[]
