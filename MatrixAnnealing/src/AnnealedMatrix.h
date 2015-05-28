#include <vector>

class AnnealedMatrix
{
public:
	AnnealedMatrix(std::vector<std::vector<int>> xInputMatrix);

	int ComputeProposedEnergy(int iRowOne, int iRowTwo) const;
	void Update(int iRowOne,int iRowTwo, int iProposedEnergy); // swap rows One and Two, and set the energy to the proposed energy
private:

	int ComputeEnergy() const;

	std::vector<std::vector<int>> m_xMatrix;
	int m_iEnergy;
	int m_iSize;

};


