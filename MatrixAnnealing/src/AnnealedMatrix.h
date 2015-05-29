#include <vector>

class AnnealedMatrix
{
public:
	AnnealedMatrix(std::vector<std::vector<int>> xInputMatrix);

	int getEnergy() const {return m_iEnergy;}
	void setEnergy(int iEnergy) {m_iEnergy = iEnergy;}

	void Swap(int iRowOne,int iRowTwo); // swap rows One and Two
	int ComputeProposedEnergy(int iRowOne, int iRowTwo) const;

private:

	int ComputeEnergy() const;

	std::vector<std::vector<int>> m_xMatrix;
	int m_iEnergy;
	int m_iSize;

};


