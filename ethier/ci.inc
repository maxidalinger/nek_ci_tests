#include <cstdlib>
#include <math.h>
#include <limits>
#include <vector>
#include <numeric>
#include <array>
#include <fstream>
#include <random>

#include "pointInterpolation.hpp"
#include "randomVector.hpp"
#include "LVector.hpp"

int numCVODERHS = 0;
int numCVODELI  = 0;

static int ciMode = 0;

#define EPS 1e-1

void ciSetup(MPI_Comm comm, setupAide &options)
{
  options.setArgs("POLYNOMIAL DEGREE", std::string("9"));
  options.setArgs("SOLUTION OUTPUT INTERVAL", std::string("0.1"));
  options.setArgs("VISCOSITY", std::string("0.01"));
  options.setArgs("DENSITY", std::string("1"));
  options.setArgs("NUMBER OF SCALARS", std::string("2"));
  options.setArgs("SCALAR00 DIFFUSIVITY", std::string("0.01"));
  options.setArgs("SCALAR00 DENSITY", std::string("1"));
  options.setArgs("SCALAR01 DIFFUSIVITY", std::string("0.01"));
  options.setArgs("SCALAR01 DENSITY", std::string("1"));
  options.setArgs("END TIME", std::string("0.06"));
  options.setArgs("DT", std::string("2e-3"));
  options.setArgs("SUBCYCLING STEPS", std::string("0"));
  options.setArgs("PRESSURE INITIAL GUESS", "PREVIOUS");

  options.setArgs("VELOCITY BLOCK SOLVER", "FALSE");
  options.setArgs("SCALAR INITIAL GUESS", "PREVIOUS");
  options.setArgs("VELOCITY INITIAL GUESS", "PREVIOUS");
  options.setArgs("ADVECTION TYPE", "CONVECTIVE+CUBATURE");

  options.setArgs("SCALAR00 SOLVER", "PCG+COMBINED");
  options.setArgs("SCALAR01 SOLVER", "PCG");

  if (ciMode == 2 || ciMode == 19) {
    options.setArgs("VELOCITY BLOCK SOLVER", "TRUE");
    options.setArgs("SUBCYCLING STEPS", std::string("1"));
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
  }
  if (ciMode == 3) {
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
    options.setArgs("VELOCITY INITIAL GUESS", "PROJECTION-ACONJ");
  }
  if (ciMode == 4) {
    options.setArgs("END TIME", std::string("0.2"));
    options.setArgs("VELOCITY BLOCK SOLVER", "TRUE");
    options.setArgs("SUBCYCLING STEPS", std::string("1"));
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
    options.setArgs("VELOCITY INITIAL GUESS", "PROJECTION-ACONJ");
  }
  if (ciMode == 5) {
    options.setArgs("END TIME", std::string("0.2"));
    options.setArgs("VELOCITY BLOCK SOLVER", "TRUE");
    options.setArgs("SUBCYCLING STEPS", std::string("0"));
    std::string casename = platform->options.getArgs("CASENAME");
    nrsCheck(casename != "mv_ethier",
             platform->comm.mpiComm,
             EXIT_FAILURE,
             "Unexpected input file for CI mode %d\n",
             ciMode);
  }
  if (ciMode == 6) {
    options.setArgs("END TIME", std::string("0.2"));
    options.setArgs("VELOCITY BLOCK SOLVER", "TRUE");
    options.setArgs("SUBCYCLING STEPS", std::string("1"));
    std::string casename = platform->options.getArgs("CASENAME");
    nrsCheck(casename != "mv_ethier",
             platform->comm.mpiComm,
             EXIT_FAILURE,
             "Unexpected input file for CI mode %d\n",
             ciMode);
  }
  if (ciMode == 7) {
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
    options.setArgs("VELOCITY INITIAL GUESS", "PROJECTION-ACONJ");
    options.setArgs("PRESSURE MAXIMUM ITERATIONS", std::string("1000"));
    options.setArgs("PRESSURE PRECONDITIONER", "JACOBI");
    options.setArgs("END TIME", std::string("0.012"));
  }
  if (ciMode == 8) {
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
    options.setArgs("VELOCITY INITIAL GUESS", "PROJECTION-ACONJ");
    options.setArgs("END TIME", std::string("0.2"));
    options.setArgs("VARIABLE DT", "TRUE");
    options.setArgs("TARGET CFL", std::string("0.5"));
  }
  if (ciMode == 9) {
    options.setArgs("ADVECTION TYPE", "CONVECTIVE");
    options.setArgs("VELOCITY BLOCK SOLVER", "TRUE");
    options.setArgs("SUBCYCLING STEPS", std::string("1"));
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
  }
  if (ciMode == 10) {
    options.setArgs("ADVECTION TYPE", "CONVECTIVE");
    options.setArgs("VELOCITY BLOCK SOLVER", "TRUE");
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
  }
  if (ciMode == 11) {
    options.setArgs("PRESSURE MULTIGRID SMOOTHER", "DAMPEDJACOBI,CHEBYSHEV");
    options.setArgs("PRESSURE MULTIGRID CHEBYSHEV MIN EIGENVALUE BOUND FACTOR", std::string("0.1"));
    options.setArgs("VELOCITY BLOCK SOLVER", "TRUE");
    options.setArgs("SUBCYCLING STEPS", std::string("1"));
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
  }
  if (ciMode == 12) {
    options.setArgs("SCALAR00 SOLVER", "NONE");
  }
  if (ciMode == 13) {
    options.setArgs("SCALAR00 SOLVER", "NONE");
    options.setArgs("VELOCITY SOLVER", "NONE");

    std::string casename = platform->options.getArgs("CASENAME");
    nrsCheck(casename != "ethierScalar",
             platform->comm.mpiComm,
             EXIT_FAILURE,
             "Unexpected input file for CI mode %d\n",
             ciMode);
  }
  if (ciMode == 14) {
    options.setArgs("PRESSURE MULTIGRID SMOOTHER", "ASM");
    options.setArgs("PRESSURE MGSOLVER CYCLE", "VCYCLE+ADDITIVE+OVERLAPCRS");
    options.setArgs("VELOCITY BLOCK SOLVER", "TRUE");
    options.setArgs("SUBCYCLING STEPS", std::string("1"));
    options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ");
  }

  // CVODE, both scalars
  if (ciMode == 16) {

    options.setArgs("CVODE", "TRUE");
    options.setArgs("SCALAR00 CVODE ABSOLUTE TOLERANCE", std::string("1e-10"));
    options.setArgs("SCALAR01 CVODE ABSOLUTE TOLERANCE", std::string("1e-10"));
    options.setArgs("CVODE RELATIVE TOLERANCE", std::string("1e-10"));

    options.setArgs("CVODE GMRES BASIS VECTORS", std::string("20"));

    options.setArgs("SCALAR00 SOLVER", "CVODE");
    options.setArgs("SCALAR01 SOLVER", "CVODE");
  }

  // CVODE, just for S01
  if (ciMode == 17) {

    options.setArgs("CVODE", "TRUE");

    options.setArgs("SCALAR00 CVODE ABSOLUTE TOLERANCE", std::string("1e-10"));
    options.setArgs("SCALAR01 CVODE ABSOLUTE TOLERANCE", std::string("1e-10"));

    options.setArgs("CVODE RELATIVE TOLERANCE", std::string("1e-10"));
    options.setArgs("CVODE GMRES BASIS VECTORS", std::string("20"));

    options.setArgs("SCALAR01 SOLVER", "CVODE");
    options.setArgs("SUBCYCLING STEPS", std::string("1"));
  }

  // CVODE, both scalars, no dealiasing
  if (ciMode == 18) {

    options.setArgs("CVODE", "TRUE");

    options.setArgs("SCALAR00 CVODE ABSOLUTE TOLERANCE", std::string("1e-10"));
    options.setArgs("SCALAR01 CVODE ABSOLUTE TOLERANCE", std::string("1e-10"));

    options.setArgs("ADVECTION TYPE", "CONVECTIVE");
    options.setArgs("CVODE ADVECTION TYPE", "CONVECTIVE");

    options.setArgs("SCALAR00 REGULARIZATION METHOD", "HPFRT");
    options.setArgs("SCALAR01 REGULARIZATION METHOD", "HPFRT");
    options.setArgs("SCALAR00 HPFRT MODES", std::string("1"));
    options.setArgs("SCALAR01 HPFRT MODES", std::string("1"));
    options.setArgs("SCALAR00 HPFRT STRENGTH", std::string("10.0"));
    options.setArgs("SCALAR01 HPFRT STRENGTH", std::string("10.0"));

    options.setArgs("CVODE RELATIVE TOLERANCE", std::string("1e-10"));
    options.setArgs("CVODE GMRES BASIS VECTORS", std::string("20"));

    options.setArgs("SCALAR00 SOLVER", "CVODE");
    options.setArgs("SCALAR01 SOLVER", "CVODE");
    options.setArgs("SUBCYCLING STEPS", std::string("1"));
  }

  options.setArgs("BDF ORDER", std::string("3"));
  options.setArgs("VELOCITY SOLVER TOLERANCE", std::string("1e-12"));
  const auto pTol = (sizeof(dfloat) == sizeof(double)) 
                    ? std::string("1e-10") : std::string("1e-05"); 
  options.setArgs("PRESSURE SOLVER TOLERANCE", pTol);
  options.setArgs("SCALAR00 SOLVER TOLERANCE", std::string("1e-12"));
  options.setArgs("SCALAR01 SOLVER TOLERANCE", std::string("1e-12"));
  options.setArgs("VARIABLEPROPERTIES", "FALSE");
}

void ciTestErrors(nrs_t *nrs,
                  double time,
                  int tstep,
                  lpm_t *particles,
                  occa::kernel exactUVWPKernel,
                  occa::kernel RKKernel)
{

  const int rank = platform->comm.mpiRank;
  if (tstep == 1 && ciMode != 7 && ciMode != 13) {
    int NiterP = nrs->pSolver->Niter;

    int expectedNiterP = 7;
    
    // mode 11 uses Chebyshev+Jacobi smoothing
    if (ciMode == 11) {
      expectedNiterP = 11;
    }

    // mode 14 uses additive multigrid with Schwarz
    if (ciMode == 14) {
      expectedNiterP = 25;
    }

    const int pIterErr = abs(NiterP - expectedNiterP);
    if (pIterErr >= 2) {
      if (rank == 0) {
        printf("Expected %d P iteration in first step, but got %d!\n", expectedNiterP, NiterP);
      }
      CIFAIL;
#if 0
      nrsFinalize(nrs);
      exit(platform->exitValue);
#endif
    }
  }

  if(nrs->cds->cvode){
    numCVODERHS += nrs->cds->cvode->numRHSEvals();
    numCVODERHS += nrs->cds->cvode->numLinIters();
    numCVODELI  += nrs->cds->cvode->numLinIters();
  }

  if (!nrs->lastStep) {
    return;
  }

  nek::ocopyToNek(time, tstep);
  nek::userchk();
  
  double *err = (double *)nek::scPtr(1);

  double vxErr, prErr;
  double s1Err, s2Err;

  int pIterErr;
  int velIterErr;

  int NiterU;

  if (platform->options.compareArgs("VELOCITY BLOCK SOLVER", "TRUE")) {
    NiterU = nrs->uvwSolver->Niter;
  } else if (nrs->uSolver) {
    NiterU = nrs->uSolver->Niter;
  } else {
    NiterU = -1;
  }

  int NiterP = nrs->pSolver ? nrs->pSolver->Niter : -1;

  int NiterS01 = -1;
  if (nrs->cds->solver[0]) {
    NiterS01 = nrs->cds->solver[0]->Niter;
  }
  int NiterS02 = -1;
  if (nrs->cds->solver[1]) {
    NiterS02 = nrs->cds->solver[1]->Niter;
  }
  int s01IterErr, s02IterErr;

  if (ciMode == 16 || ciMode == 17 || ciMode == 18) {
    if (platform->options.compareArgs("SCALAR00 SOLVER", "CVODE")) {
        NiterS01 = numCVODERHS / tstep; // average number of RHS + linIters per step
    }
    if (platform->options.compareArgs("SCALAR01 SOLVER", "CVODE")) {
        NiterS02 = numCVODERHS / tstep;
    }
    std::cout << "numCVODERHS: " << numCVODERHS << std::endl;
    std::cout << "numCVODELI : " << numCVODELI  << std::endl;
    std::cout << "NiterS01   : " << NiterS01    << std::endl;
    std::cout << "NiterS02   : " << NiterS02    << std::endl;
  }

  s01IterErr = abs(NiterS01 - 2);
  s02IterErr = abs(NiterS02 - 2);

  switch (ciMode) {
  case 2:
  case 11:
    velIterErr = abs(NiterU - 10);
    s1Err = abs((err[2] - 6.67E-12) / err[2]);
    s2Err = abs((err[3] - 7.49E-12) / err[3]);
    pIterErr = abs(NiterP - 4);
    vxErr = abs((err[0] - 2.77E-10) / err[0]);
    prErr = abs((err[1] - 6.98E-10) / err[1]);
    break;
  case 3:
    velIterErr = abs(NiterU - 4);
    s1Err = abs((err[2] - 5.25E-12) / err[2]);
    s2Err = abs((err[3] - 6.09E-12) / err[3]);
    pIterErr = abs(NiterP - 2);
    vxErr = abs((err[0] - 2.78E-10) / err[0]);
    prErr = abs((err[1] - 7.11E-10) / err[1]);
    break;
  case 4:
    velIterErr = abs(NiterU - 1);
    s1Err = abs((err[2] - 1.71E-11) / err[2]);
    s2Err = abs((err[3] - 2.00E-11) / err[3]);
    pIterErr = abs(NiterP - 1);
    vxErr = abs((err[0] - 3.65E-10) / err[0]);
    prErr = abs((err[1] - 6.71E-10) / err[1]);
    break;
  case 5:
    velIterErr = abs(NiterU - 12);
    s1Err = abs((err[2] - 1.53E-06) / err[2]);
    s2Err = abs((err[3] - 1.73E-06) / err[3]);
    pIterErr = abs(NiterP - 11);
    vxErr = abs((err[0] - 2.57E-07) / err[0]);
    prErr = abs((err[1] - 2.16E-06) / err[1]);
    s01IterErr = abs(NiterS01 - 5);
    s02IterErr = abs(NiterS02 - 5);
    break;
  case 6:
    velIterErr = abs(NiterU - 12);
    s1Err = abs((err[2] - 1.27E-06) / err[2]);
    s2Err = abs((err[3] - 1.41E-06) / err[3]);
    pIterErr = abs(NiterP - 11);
    vxErr = abs((err[0] - 2.43E-07) / err[0]);
    prErr = abs((err[1] - 2.89E-06) / err[1]);
    s01IterErr = abs(NiterS01 - 5);
    s02IterErr = abs(NiterS02 - 5);
    break;
  case 7:
    velIterErr = abs(NiterU - 5);
    s1Err = abs((err[2] - 2E-13) / err[2]);
    s2Err = abs((err[3] - 2E-13) / err[3]);

    // just check for convergence
    pIterErr = (NiterP < 999) ? 0 : 1000;

    vxErr = abs((err[0] - 1.4E-10) / err[0]);
    prErr = abs((err[1] - 8.7E-9) / err[1]);
    break;
  case 8:
    velIterErr = abs(NiterU - 10);
    s1Err = abs((err[2] - 1.53E-11) / err[2]);
    s2Err = abs((err[3] - 1.77E-11) / err[3]);
    pIterErr = abs(NiterP - 2);
    vxErr = abs((err[0] - 3.35E-10) / err[0]);
    prErr = abs((err[1] - 1.63E-09) / err[1]);
    break;
  case 9:
    velIterErr = abs(NiterU - 10);
    s1Err = abs((err[2] - 1.03E-11) / err[2]);
    s2Err = abs((err[3] - 1.34E-11) / err[3]);
    pIterErr = abs(NiterP - 1);
    vxErr = abs((err[0] - 2.78E-10) / err[0]);
    prErr = abs((err[1] - 6.98E-10) / err[1]);
    break;
  case 10:
    velIterErr = abs(NiterU - 10);
    s1Err = abs((err[2] - 1.03E-11) / err[2]);
    s2Err = abs((err[3] - 1.34E-11) / err[3]);
    pIterErr = abs(NiterP - 1);
    vxErr = abs((err[0] - 2.78E-10) / err[0]);
    prErr = abs((err[1] - 6.98E-10) / err[1]);
    break;
  case 12:
    velIterErr = abs(NiterU - 10);
    s1Err = abs((err[2] - 2.506E-3) / err[2]);
    s2Err = abs((err[3] - 1.34E-11) / err[3]);
    pIterErr = abs(NiterP - 4);
    vxErr = abs((err[0] - 2.78E-10) / err[0]);
    prErr = abs((err[1] - 6.98E-10) / err[1]);
    s01IterErr = abs(NiterS01 + 1);
    break;
  case 13:
    velIterErr = abs(NiterU + 1);
    s1Err = abs((err[2] - 2.506E-3) / err[2]);
    s2Err = abs((err[3] - 1.52E-5) / err[3]);
    pIterErr = abs(NiterP + 1);
    vxErr = abs((err[0] - 2.5E-3) / err[0]);
    prErr = abs((err[1] - 2.364E-2) / err[1]);
    s01IterErr = abs(NiterS01 + 1);
    break;
  case 14:
    velIterErr = abs(NiterU - 10);
    s1Err = abs((err[2] - 6.67E-12) / err[2]);
    s2Err = abs((err[3] - 7.50E-12) / err[3]);
    pIterErr = abs(NiterP - 7);
    vxErr = abs((err[0] - 2.78E-10) / err[0]);
    prErr = abs((err[1] - 7E-010) / err[1]);
    s01IterErr = abs(NiterS01 - 2);
    s02IterErr = abs(NiterS02 - 2);
    break;
  case 16:
  case 18:
    velIterErr = abs(NiterU - 10);
    s1Err = abs((err[2] - 2.31E-08) / err[2]);
    s2Err = abs((err[3] - 2.51E-08) / err[3]);
    pIterErr = abs(NiterP - 4);
    vxErr = abs((err[0] - 2.78E-10) / err[0]);
    prErr = abs((err[1] - 7.11E-10) / err[1]);
    s01IterErr = abs(NiterS01 - 3.5); // nsteps
    s02IterErr = abs(NiterS02 - 3.5); // nli
    break;
  case 17:
    velIterErr = abs(NiterU - 10);
    s1Err = abs((err[2] - 6.11E-12) / err[2]);
    s2Err = abs((err[3] - 4.92E-08) / err[3]);
    pIterErr = abs(NiterP - 4);
    vxErr = abs((err[0] - 2.78E-10) / err[0]);
    prErr = abs((err[1] - 7.11E-10) / err[1]);
    s01IterErr = abs(NiterS01 - 1.67); // nsteps
    s02IterErr = abs(NiterS02 - 1.67); // nli
    break;
  }
  
  // on ci modes 12, 13, confirm that the correct solvers are present
  if (ciMode == 12) {
    bool correct = true;
    correct &= (nrs->pSolver != nullptr);
    correct &= (nrs->uSolver != nullptr || nrs->uvwSolver != nullptr);
    correct &= (nrs->cds->solver[0] == nullptr);
    correct &= (nrs->cds->solver[1] != nullptr);
    nrsCheck(!correct,
             platform->comm.mpiComm,
             EXIT_FAILURE,
             "Unexpected solver configuration for CI mode %d\n",
             ciMode);
  }
  if (ciMode == 13) {
    bool correct = true;
    correct &= (nrs->pSolver == nullptr);
    correct &= (nrs->uSolver == nullptr && nrs->uvwSolver == nullptr);
    correct &= (nrs->cds->solver[0] == nullptr);
    correct &= (nrs->cds->solver[1] != nullptr);
    nrsCheck(!correct,
             platform->comm.mpiComm,
             EXIT_FAILURE,
             "Unexpected solver configuration for CI mode %d\n",
             ciMode);
    nrsCheck(nrs->flow, platform->comm.mpiComm, EXIT_FAILURE, "nrs->flow == true for CI mode %d\n", ciMode);
  }
  
  if (ciMode == 4) {
    dfloat memoryUsage = platform->device.occaDevice().memoryAllocated() / 1e9;
    const dfloat expectedMemoryUsage = 0.0555274;
    if (memoryUsage > 1.01 * expectedMemoryUsage && platform->comm.mpiCommSize == 2) {
      if (platform->comm.mpiRank == 0) {
        printf("Expected memory usage exceeded!\n"
               "Expected : %g GB\n"
               "Actual   : %g GB\n",
               expectedMemoryUsage,
               memoryUsage);
        fflush(stdout);
      }
      CIFAIL;
      nrsFinalize(nrs);
      exit(platform->exitValue);
    }

    // check flop count
    const double expectedOperations = 125188214670; // from nvprof
    const auto accuracy = 0.035;                    // observed 3% error in result
    const auto operations = platform->flopCounter->get(platform->comm.mpiComm);
    if (operations >= (1 + accuracy) * expectedOperations ||
        operations <= (1 - accuracy) * expectedOperations) {
      if (platform->comm.mpiRank == 0) {
        printf("Expected operation count differs!\n"
               "Expected : %g\n"
               "Actual   : %g\n",
               expectedOperations,
               operations);
        fflush(stdout);
      }
      CIFAIL;
      nrsFinalize(nrs);
      exit(platform->exitValue);
    }
  }
  if (ciMode == 8) {
    const int expectedSteps = 56;
    const int errSteps = abs(expectedSteps - tstep);
    if (rank == 0) {
      printf("nSteps err variable dt:  %d\n", errSteps);
    }
    if (errSteps > 2) {
      CIFAIL;
    }
    nrsFinalize(nrs);
    exit(platform->exitValue);
  }

  if (ciMode == 5 || ciMode == 6) {
    if (platform->options.compareArgs("MOVING MESH", "FALSE")) {
      if (rank == 0) {
        printf("Unable to test moving mesh in ethier. Please re-run the case with mv_ethier!\n");
      }
      (CIFAIL);
      nrsFinalize(nrs);
      exit(platform->exitValue);
    }
  }

  if (rank == 0) {
    printf("relative error to target: vx=%g pr=%g s1=%g s2=%g velIter=%d pIter=%d s01Iter=%d s02Iter=%d\n",
           vxErr,
           prErr,
           s1Err,
           s2Err,
           velIterErr,
           pIterErr,
           s01IterErr,
           s02IterErr);
  }

  std::vector<double> relErrors = {vxErr, prErr, s1Err, s2Err};
  std::vector<double> absErrors = {abs(err[0]), abs(err[1]), abs(err[2]), abs(err[3])};
  bool passTest = true;
  const double absTol = 5e-11; // values below this threshold are ignored
  for (size_t i = 0; i < relErrors.size(); ++i) {

    const double absError = absErrors[i];
    const double relError = relErrors[i];
    if (absError > absTol) {
      passTest &= relError < EPS;
    }
  }

  passTest &= velIterErr <= 1;
  passTest &= pIterErr <= 2;
  passTest &= s01IterErr <= 1;
  passTest &= s02IterErr <= 1;

  passTest ? (CIPASS) : (CIFAIL);
}
