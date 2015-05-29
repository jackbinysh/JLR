#include <iostream>
#include <ctime>
#include <random>
#include <cmath>
#include "AnnealedMatrix.h"
using namespace std;


int main() {

// read in the input variables
std::vector<std::vector<int>> xInputMatrix;
int iTimeMax = 100;
double dInitialTemp = 10;

// initialise the random number generator
std::mt19937 xEngine(std::time(NULL));
std::uniform_int_distribution<int> xProposalDistribution(0,xInputMatrix.size()-1); // the generator to give row swap proposals, NOTE 0 INDEXED
std::uniform_real_distribution<double> xAcceptanceDistribution(0,1); // the generator to give the random numbers for accept/reject.

// construct the matrix we will work with
AnnealedMatrix xMatrix(xInputMatrix);

// simulated Annealing
for(int iTime =0  ; iTime <= iTimeMax; iTime++ )
{
	static double dT = dInitialTemp;

	// propose a move
	int iRowOne(0), iRowTwo(0);
	do
	{
		iRowOne = xProposalDistribution(xEngine);
		iRowTwo = xProposalDistribution(xEngine);
	} while (iRowOne == iRowTwo);

	// compute the energy change
	int iEnergy = xMatrix.getEnergy();
	int iProposedEnergy = xMatrix.ComputeProposedEnergy(iRowOne,iRowTwo);
	double dE = static_cast<double>(iProposedEnergy -iEnergy);

	// accept or reject with boltzman probabilities
	if (xAcceptanceDistribution(xEngine) <= std::exp(-dE/dT))
	{
		xMatrix.Swap(iRowOne,iRowTwo);
		xMatrix.setEnergy(iProposedEnergy);
	};
	// decrease the temperature

}

	return 0;
}

