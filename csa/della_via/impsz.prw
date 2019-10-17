#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPSZ     ºAutor  ³Microsiga           º Data ³  08/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importacao do cadastro de agregados, categoria de DBF/TOP   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Dellavia                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ImpSZ()        

Local _aArea := GetArea()
Local _cArq  := GetMV("MV_ARQREC")


IF Alltrim(UPPER(_cArq)) == "GRUPO"
	_cEntid := "Cadastro de grupo"
	_cSZ    := "B"
ElseIF Alltrim(UPPER(_cArq)) == "GRUPOXCATEG"
	_cEntid := "Cadastro de categoria"
	_cSZ    := "C"
ElseIF Alltrim(UPPER(_cArq)) == "ESPECIE"
	_cEntid := "Cadastro de especie"
	_cSZ    := "A"
EndIF

dbUseArea(.T.,"DBFCDX",_cArq,"TRB",.F.,.F.)

ProcRegua(1000)
	
nProc  := 0
nProc2 := 0

While !Eof()
	IncProc("Importando "+Alltrim(Str(nProc2))+" registros do "+_cEntid)
	nProc ++
	nProc2 ++
	If nProc > 1000
		ProcRegua(1000)
		nProc := 0
	Endif
	IF _cSZ == "A"       //Especie
		_cCod:=TRB->COD
		dbSelectArea("SZ7")
		dbSetOrder(1)
		IF !dbSeek(xFilial()+_cCod)
			Reclock("SZ7",.T.)
				SZ7->Z7_COD   := TRB->COD
				SZ7->Z7_DESC  := TRB->DESC
			MsUnlock()
		EndIF
	ElseIF _cSZ == "B" //GRUPO
		_cCod:=TRB->COD
		dbSelectArea("SBM")
		dbSetOrder(1)
		IF !dbSeek(xFilial()+_cCod)		
			Reclock("SZ5",.T.)
				SBM->BM_GRUPO   := _cCod
				SBM->BM_DESC    := TRB->DESC
			MsUnlock()
		EndIF
	Else //GRUPO X CATEGORIA
		_cCod:=TRB->GRUPO
		_cCodCat:=TRB->CAT
		dbSelectArea("SZ3")
		dbSetOrder(1)
		IF !dbSeek(xFilial()+_cCod+_cCodCat)
			Reclock("SZ3",.T.)
				SZ3->Z3_CODGRU   := _cCod
				SZ3->Z3_CODCAT   := _cCodCat
			MsUnlock()
		EndIF			
	EndIF	
	dbSelectArea("TRB")
	dbSkip()
EndDo
RestArea(_aArea)
Return 