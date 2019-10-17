#include "protheus.ch"

User Function DESTA20 ()
	Local aArea := GetArea()  
	Local lret  := .t.

	If AllTrim(FunName()) = "MATA380" .AND. SM0->M0_CODIGO == "03"
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek("  "+M->D3_X_PROD)
		If Found() 
			If SB1->B1_GRUPO = "BAND"
				If AllTrim(SB1->B1_XDESENH) <> Alltrim(SC2->C2_X_DESEN)
					MsgAlert("Des OP:" + AllTrim(SC2->C2_X_DESEN) + "Dif Lanç:" + AllTrim(SB1->B1_XDESENH) , "BANDA")
					lret := .f.
				Else
					If SB1->B1_GRUPO <> "MANC"
						MsgAlert("Grupo Não é MANC","CONSERTO")
						lret := .f.
					Endif
					lret := .t.
				Endif         
			Endif
		Else
			MsgAlert("Produto Não Cadastrado","Material")
			lret := .f.
		Endif
	EndIf

	RestArea(aArea) 
Return lret