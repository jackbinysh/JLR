/*
 * AnnealedMatrix.cpp
 *
 *  Created on: 28 May 2015
 *      Author: jackbinysh
 */

#include "AnnealedMatrix.h"

AnnealedMatrix::AnnealedMatrix(std::vector<std::vector<int>> xInputMatrix)
{
	m_xMatrix = xInputMatrix;
	m_iEnergy = ComputeEnergy();
	m_iSize = xInputMatrix.size();
}

void AnnealedMatrix::Update(int iRowOne,int iRowTwo, int iProposedEnergy)
{
	m_iEnergy = iProposedEnergy;

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
	return 0;
}


