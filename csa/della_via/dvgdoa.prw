#include "rwmake.ch"
#include "topconn.ch"

/*
Função de gatilho utilizada no campo UB_OPER / 004
Denis Tofoli
*/

User Function DVGDOA()
	Local aSaveArea := {}
	Local nCpoOper  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_OPER"})
	Local nCpoPrcV  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VRUNIT"})
	Local nCpoPrcT  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRCTAB"})
	Local nCpoQtde  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"})
	Local nCpoVItem := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"})
	Local nCpoCod   := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
	Local nCpoLocal := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_LOCAL"})
	Local nCpoPDesc := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESC"})
	Local nCpoVDesc := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VALDESC"})
	Local nCpoPAcre := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_ACRE"})
	Local nCpoVAcre := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VALACRE"})

	aSaveArea := GetArea()

	aValores[1] := 0  // Mercadoria
	aValores[2] := 0  // Descontos
	aValores[3] := 0  // Acrescimos
	aValores[6] := 0  // Total
	For k = 1 To Len(aCols)
		if aCols[k,nCpoOper] = AllTrim(GetMv("FS_DEL038")) .and. !aCols[k,Len(aCols[k])]
			if M->UA_TABELA = AllTrim(GetMv("FS_DEL048"))
				dbSelectArea("SB2")
				dbSetOrder(1)
				dbGotop()
				dbSeek(xFilial("SB2")+aCols[k,nCpoCod]+aCols[k,nCpoLocal])
				If found()
					aCols[k,nCpoPrcV]  := SB2->B2_CM1
					aCols[k,nCpoPrcT]  := SB2->B2_CM1
					aCols[k,nCpoVItem] := aCols[k,nCpoQtde] * SB2->B2_CM1
					aCols[k,nCpoPDesc] := 0
					aCols[k,nCpoVDesc] := 0
					aCols[k,nCpoPAcre] := 0
					aCols[k,nCpoVAcre] := 0
				Endif
			Else
				msgbox("Para utilizar o tipo de operação "+AllTrim(GetMv("FS_DEL038"));
				      +" de Doações, primeiro voce deve selecionar a tabela de doação ";
				      +AllTrim(GetMv("FS_DEL048")),"Doações","STOP")

				aCols[k,nCpoOper] := Space(2)
				aCols[k,nCpoCod]  := Space(15)
			Endif
		Endif

		if !aCols[k,Len(aCols[k])]
			aValores[1] += aCols[k,nCpoQtde] * aCols[k,nCpoPrcV]
			aValores[2] += aCols[k,nCpoVDesc]
			aValores[3] += aCols[k,nCpoVAcre]
			aValores[6] += aCols[k,nCpoQtde] * aCols[k,nCpoPrcV]
		Endif
	Next k

	Tk273TlvImp()

	RestArea(aSaveArea)
Return aCols[n,nCpoPrcV]