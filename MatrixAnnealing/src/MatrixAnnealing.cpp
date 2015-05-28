#include <iostream>
#include <ctime>
#include <random>
using namespace std;


int main() {

int iTimeMax = 100;
double dIntitialTemp = 10;


// initialise the random number generator
std::mt19937 xEngine(std::time(NULL));
//xProposalDistribution = std::uniform_real_distribution<int>(0, 1);std::mt19937


for(int iTime =0  ; iTime <= iTimeMax; iTime++ )
{
	// propose a move

	// accept or reject with boltzman probabilities
	// decrease the temperature

}

	return 0;
}

