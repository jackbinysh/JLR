/*
 * AnnealedMatrix.cpp
 *
 *  Created on: 28 May 2015
 *      Author: jackbinysh
 */
#include <cmath>
#include "AnnealedMatrix.h"

AnnealedMatrix::AnnealedMatrix(std::vector<std::vector<int>> xInputMatrix)
{
	m_xMatrix = xInputMatrix;
	m_iEnergy = ComputeEnergy();
	m_iSize = xInputMatrix.size();
}

void AnnealedMatrix::Swap(int iRowOne,int iRowTwo)
{
	// swap rows
	for(int j = 0; j<= m_iSize-1;j++)
	{
		int temp = m_xMatrix[iRowOne][j];
		m_xMatrix[iRowOne][j] = m_xMatrix[iRowTwo][j];
		m_xMatrix[iRowTwo][j] = temp;
	}
	// swap columns
	for(int i = 0; i<= m_iSize-1;i++)
	{
		int temp = m_xMatrix[i][iRowOne];
		m_xMatrix[i][iRowOne] = m_xMatrix[i][iRowTwo];
		m_xMatrix[i][iRowTwo] = temp;
	}
}

int AnnealedMatrix::ComputeEnergy() const
{
	int iEnergy(0);
	for(int i=0; i<= m_iSize-1; i++)
	{
		int iRowEnergy(0);
		for (int j=0; j<=m_iSize-1 ; j++)
		{
			if(m_xMatrix[i][j])
			{
				iRowEnergy += std::abs(i-j); //almost certainly wrong
			}
		}
		iEnergy +=iRowEnergy;
	}
	return iEnergy/2;
}

int AnnealedMatrix::ComputeProposedEnergy(int iRowOne, int iRowTwo) const
{
	int iNodeOneEnergy(0),iNodeTwoEnergy(0), iNodeTwoatNodeoneEnergy(0), iNodeOneatNodeTwoEnergy(0);
	for (int j=0; j<=m_iSize-1 ; j++)
	{
		if(m_xMatrix[iRowOne][j] && j !=iRowTwo)
		{
			iNodeOneEnergy += std::abs(iRowOne-j);
			iNodeTwoatNodeoneEnergy += std::abs(iRowTwo-j);
		}
		if(m_xMatrix[iRowTwo][j] && j !=iRowOne)
		{
			iNodeTwoEnergy += std::abs(iRowTwo-j);
			iNodeOneatNodeTwoEnergy += std::abs(iRowOne-j);
		}
	}
	return ( m_iEnergy - iNodeOneEnergy - iNodeTwoEnergy + iNodeTwoatNodeoneEnergy + iNodeOneatNodeTwoEnergy ) ;
}

