#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F460COL  ºAutor  ³ Jader              º Data ³  02/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na tela de liquidacao de titulo do contas º±±
±±º          ³ a receber, para alteracao do header e acols (FINA460)      º±±
±±º          ³ Utilizado para gravar dados do cheque e cartao             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DURAPOL                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
        
User Function A460COL()
                
// acrescenta funcao na validacao do campo numero
aHeader[6,6] := "U_UA460COL() .And. " + aHeader[6,6]

// acrescenta funcao na validacao do campo valor
aHeader[9,6] := "U_UA460COL() .And. " + aHeader[9,6] 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UA460COL ºAutor  ³ Jader              º Data ³  02/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava dados no acols da liquidacao conforme o tipo         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UA460COL()
       
Local _aArea := GetArea()
Local _nX
Local _nTam3 := Len(aCols[1,3])
Local _nTam4 := Len(aCols[1,4])
Local _nTam5 := Len(aCols[1,5])
Local _nTam8 := Len(aCols[1,8])

dbSelectArea("SA1")    
dbSetOrder(1)
dbSeek(xFilial("SA1")+cCliente)

For _nX := 1 To Len(aCols)

	If aCols[_nX,2] == "CH "

		aCols[_nX,8] := Substr(SA1->A1_NREDUZ + Space(_nTam8),1,_nTam8)  // emitente

	ElseIf aCols[_nX,2] == "CD " .Or. aCols[_nX,2] == "CC "

		dbSelectArea("SAE")
		dbSetOrder(1)
		dbSeek(xFilial("SAE")+Substr(SA1->A1_COD,1,3))
		
		aCols[_nX,3]  := Substr("-"+Space(_nTam3),1,_nTam3)  // banco
		aCols[_nX,4]  := Substr("-"+Space(_nTam4),1,_nTam4)  // agencia
		aCols[_nX,5]  := Substr("-"+Space(_nTam5),1,_nTam5)  // conta
		aCols[_nX,8]  := Substr(SA1->A1_NREDUZ + Space(_nTam8),1,_nTam8)  // emitente
		aCols[_nX,11] := Round(aCols[_nX,9] * SAE->AE_TAXA / 100 , 2)  // decrescimo
		aCols[_nX,12] := aCols[_nX,9] + aCols[_nX,10] - aCols[_nX,11]
	
	Endif

Next

oGet:ForceRefresh()
    
RestArea(_aArea)

dbSelectArea("SE1")

Return(.T.)

