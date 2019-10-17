
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT010INC  ºAutor  ³Paulo Benedet       º Data ³  02/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chamar tela de veiculos apos inclusao                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de entrada da tela de produtos                       º±±
±±º          ³ Personalizado Della Via                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT010INC()
Local aAreaIni := GetArea()
Local aAreaSB0 := SB0->(GetArea())
Local aAreaSM0 := SM0->(GetArea())

// Adiciona SB0
SB0->(dbSetOrder(1)) // B0_FILIAL+B0_COD

dbSelectArea("SM0")
dbSetOrder(1) // M0_CODIGO+M0_CODFIL
dbSeek("01")  // DELLA VIA

While !EOF() .And. SM0->M0_CODIGO == "01"
	If !SB0->(dbSeek(SM0->M0_CODFIL + SB1->B1_COD))
		RecLock("SB0", .T.)
		B0_FILIAL  := SM0->M0_CODFIL
		B0_COD     := SB1->B1_COD
		B0_PRV1    := 0.01
		msUnlock()
	EndIf
	
	dbSelectArea("SM0")
	dbSkip()
End

RestArea(aAreaSB0)
RestArea(aAreaSM0)

//
// Funcao abaixo inserida por Adriano Luis Brandao (Microsiga) B.I. 11/07/05.
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Nao executa o bloco abaixo quando a inclusao de protutos ³
//³eh feita de forma atomatica                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !l010Auto

	MsgRun("Enviando e-mail de confirmacao de cadastro novo",,{ || U_RWF001("Produto",SB1->B1_COD,SB1->B1_DESC)}) // executa e-mail de solicitacao de cadastros.
	
	If cEmpAnt == "01"
	
		P_DELA003("SB1", SB1->(RecNo()), 9)
	
	EndIf

EndIf

RestArea(aAreaIni)

Return