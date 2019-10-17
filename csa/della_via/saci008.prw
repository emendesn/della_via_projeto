#include "DellaVia.ch"

/*
Programa: SACI008 - PE que executa na confirmação da baixa dos titulos a receber.
Autor   : Denis Francisco Tofoli
Data    : 08/06/2006
*/

User Function SACI008
	Local aArea := GetArea()

	U_DVFINF01()

	RestArea(aArea)
Return nil