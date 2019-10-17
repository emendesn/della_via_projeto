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
User Function AcertaSb0()

Local aSay		:=	{}
Local aButton	:=	{}
Local lOk		:=	.F.
                           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Texto explicativo da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSay, "Esta rotina tem por objetivo efetuar a manutenção na tabela de preços, iniciali-" )
aAdd( aSay, "zando os preços dos produtos ainda não cadastrados nesta tabela.                " )
aAdd( aSay, "Dependendo da quantidade de produtos cadastrados, a execução desta rotina pode  " )
aAdd( aSay, "demorar alguns minutos.                                                         " )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Botoes da tela principal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Confirma
aAdd( aButton, { 1,.T.,	{|| (lOk := .T.,FechaBatch())}} )
//Cancela
aAdd( aButton, { 2,.T.,	{|| FechaBatch()}} )

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre a tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
FormBatch( "Atualização de preços", aSay, aButton )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acao executada caso o usuario confirme a tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOk
	Processa({|lEnd| ProcSb0(@lEnd)},"Atualizando do SB0 - Aguarde","Atualizando preços...",.T.)
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcSb0   ºAutor  ³Microsiga           º Data ³  05/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Execucao da rotina                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DellaVia Pneus                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcSb0(lEnd)

Local _aArea := GetArea()

dbSelectArea("SB0")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

ProcRegua(RecCount())
dbGotop()

nProc  := 0
nProc2 := 0

While !SB1->(Eof())
	
	If lEnd .And. (lEnd := ApMsgNoYes("Confirma o cancelamento da rotina?","Botão Cancela"))
		Return Nil
	EndIf

	IncProc("Processando produto " + SB1->B1_COD )

	nProc ++
	nProc2 ++

	IF SB0->(dbSeek(xFilial("SB0")+SB1->B1_COD)) //+SB1->B1_LOJA) marcelo
		RecLock("SB0",.F.)
			SB0->B0_COD    := SB1->B1_COD
			If SB1->B1_GRUPO== "0081" //Gprupo dos produtos de Saida Rapida - Marcelo
				SB0->B0_PRV1   := 0.00	
			else
				SB0->B0_PRV1   := 0.01	
			endif
	Else		
		RecLock("SB0",.T.)
			SB0->B0_FILIAL := xFilial("SB1")
			SB0->B0_COD    := SB1->B1_COD
			If SB1->B1_GRUPO== "0081" //Gprupo dos produtos de Saida Rapida - Marcelo
				SB0->B0_PRV1   := 0.00	
			else
				SB0->B0_PRV1   := 0.01	
			endif
	EndIF
	
	MsUnlock()

	SB1->(dbSkip())
	
EndDo	

RestArea(_aArea)    

ApMsgInfo("Atualização concluída","Atualização SB0")

Return 