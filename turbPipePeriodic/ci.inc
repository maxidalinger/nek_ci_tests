#include <math.h>
#include <limits>

#include "constantFlowRate.hpp"
#include "postProcessing.hpp"

static int ciMode = 0;

#define EPS 1e-1

void ciSetup(MPI_Comm comm, setupAide &options)
{
  /* options.setArgs("POLYNOMIAL DEGREE", std::string("7")); */
  /* options.setArgs("CUBATURE POLYNOMIAL DEGREE", std::string("10")); */
  /* options.setArgs("CONSTANT FLOW RATE", "FALSE"); */
  /* options.setArgs("SOLUTION OUTPUT INTERVAL", "-1"); */
  /* options.setArgs("VISCOSITY", std::to_string(1.0 / 19000.0)); */
  /* options.setArgs("DENSITY", std::string("1.0")); */
  /* options.setArgs("NUMBER TIMESTEPS", std::string("200")); */
  /* options.setArgs("END TIME", std::string("-1")); */
  /* options.setArgs("BDF ORDER", "2"); */
  /* options.setArgs("ADVECTION TYPE", "CONVECTIVE+CUBATURE"); */
  /* options.setArgs("DT", std::string("6e-3")); */
  /* options.setArgs("SUBCYCLING STEPS", std::string("2")); */

  /* options.setArgs("PRESSURE KRYLOV SOLVER", "PGMRES+FLEXIBLE"); */
  /* options.setArgs("PRESSURE SOLVER TOLERANCE", std::string("1e-4")); */
  /* options.setArgs("PRESSURE PRECONDITIONER", "MULTIGRID"); */
  /* options.setArgs("PRESSURE MULTIGRID COARSE SOLVE", "TRUE"); */
  /* options.setArgs("PRESSURE MULTIGRID SMOOTHER", "FOURTHOPTCHEBYSHEV+ASM"); */
  /* options.setArgs("PRESSURE MULTIGRID CHEBYSHEV DEGREE", std::string("3")); */
  /* options.setArgs("PRESSURE MULTIGRID CHEBYSHEV MAX EIGENVALUE BOUND FACTOR", std::string("1.1")); */
  /* options.setArgs("PRESSURE INITIAL GUESS", "PROJECTION-ACONJ"); */
  /* options.setArgs("PRESSURE RESIDUAL PROJECTION VECTORS", std::string("8")); */

  /* options.setArgs("VELOCITY SOLVER TOLERANCE", std::string("1e-6")); */
  /* options.setArgs("VELOCITY BLOCK SOLVER", "TRUE"); */
  /* options.setArgs("VELOCITY INITIAL GUESS", "EXTRAPOLATION"); */

  /* options.setArgs("VELOCITY REGULARIZATION METHOD", "HPFRT"); */
  /* options.setArgs("VELOCITY HPFRT MODES", std::string("1")); */
  /* options.setArgs("VELOCITY HPFRT STRENGTH", std::string("10")); */

  /* options.setArgs("CONSTANT FLOW RATE", "FALSE"); */

  /* options.setArgs("DENSITY", std::string("1")); */

  Re_tau = 550;
  zLength = 6;
}

double getUtau(nrs_t *nrs, occa::memory &o_Uavg)
{
  mesh_t *mesh = nrs->meshV;

  std::vector<int> bidWall = {1};
  occa::memory o_bidWall = platform->device.malloc<int>(bidWall.size(), bidWall.data());

  auto o_Sij = platform->o_memPool.reserve<dfloat>(2 * nrs->NVfields * nrs->fieldOffset);

	postProcessing::strainRate(nrs, true, o_Uavg, o_Sij);

  const auto drag = postProcessing::viscousDrag(nrs, bidWall.size(), o_bidWall, o_Sij);
  o_Sij.free();

  auto o_tmp = platform->o_memPool.reserve<dfloat>(mesh->Nlocal);
  platform->linAlg->fill(mesh->Nlocal, 1.0, o_tmp);
  const auto areaWall = mesh->surfaceIntegral(bidWall.size(), o_bidWall, o_tmp);

	return sqrt(drag / areaWall.at(0));
}

void ciTestErrors(nrs_t *nrs, dfloat time, int tstep, occa::memory &o_Uavg)
{
  if (!nrs->lastStep) {
    return;
  }

	// https://www.lstm.tf.fau.de/database/simulation-database/
  const auto utauRef = 5.7901316173625254E-02;
  const auto utau = getUtau(nrs, o_Uavg);
	const double ff = 8.0 * utau * utau;
  const auto utauErr = std::abs((utau - utauRef) / utauRef);

  if (platform->comm.mpiRank == 0) {
    printf("tau: %g; relative error = %g; ff = %g\n", utau, utauErr, ff);
  }

  (fabs(utauErr) < EPS) ? (CIPASS) : (CIFAIL);
}
