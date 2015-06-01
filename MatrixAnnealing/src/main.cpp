#include <iostream>
#include <ctime>
#include <random>
#include <cmath>
#include "AnnealedMatrix.h"
using namespace std;


int main()
{
	// read in the input variables
	std::vector<std::vector<int>> xInputMatrix = {{0,1,1,1},{1,0,0,0},{1,0,0,0},{1,0,0,0}};
	double dInitialTemp = 10;
	double dFinalTemp = 0.1;
	int iRunsAtEachTemp = 1000;
	int iImprovementCountThreshold = 1000;

	// initialise the random number generator
	std::mt19937 xEngine(std::time(NULL));
	std::uniform_int_distribution<int> xProposalDistribution(0,xInputMatrix.size()-1); // the generator to give row swap proposals, NOTE 0 INDEXED
	std::uniform_real_distribution<double> xAcceptanceDistribution(0,1); // the generator to give the random numbers for accept/reject.

	// construct the matrix we will work with
	AnnealedMatrix xMatrix(xInputMatrix);

	// simulated Annealing
	double dT(dInitialTemp);
	while(dT>=dFinalTemp)
	{
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
		static int iTempCount(0);
		iTempCount++;
		if(iTempCount>=iRunsAtEachTemp)
		{
			dT *= 0.99;
			iTempCount = 0;
		}
		// number of timesteps with no improvement found, break early if exceeded
		static int iNoImprovementCount(0);
		if(iEnergy <= iProposedEnergy)
		{
			iNoImprovementCount++;
			if(iNoImprovementCount >= iImprovementCountThreshold)
			{
				break;
			}
		}
		else
		{
			iNoImprovementCount = 0;
		}
	}
	// output the matrix

	for(int i=0; i<= xMatrix.getSize()-1; i++)
	{
		for(int j=0;j<= xMatrix.getSize()-1;j++)
		{
			std::cout << xMatrix.getMatrixelement(i,j) << "\t";
		}
		std::cout << std::endl;
	}
	return 0;
}

