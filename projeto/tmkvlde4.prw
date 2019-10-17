#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKVLDE4 ºAutor  ³Anderson Kurtinaitisº Data ³  10/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ Fab.Tradicional  ³Contato ³ andkurt@microsiga.com.br       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada que estara verificando se a condicao de   º±±
±±º          ³ Pagamento informada via Botao de Pagamento pode ser usada  º±±
±±º          ³ e eh compativel com o Tipo de Venda informando.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Verificar se Tipo de Venda e Condicao de Pagto. estao OK   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKVLDE4(nOpc,cCodPagto)
Local aArea     := GetArea()
Local aAreaSE4  := SE4->(GetArea())
Local _lRetorno	:= .T.

If nOpc == 3 .or. nOPc == 4
	
	If Empty(M->UA_TIPOVND)
		
		If !lTk271Auto
			MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso")
		EndIf
		_lRetorno	:= .F.
		
	Else
		
		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + cCodPagto)
			
			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			IF !(Alltrim(M->UA_TIPOVND) $ Alltrim(SE4->E4_TIPOVND))
				
				If !lTk271Auto
					MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO se enquadra no Tipo de Venda informado, verifique !"), "Aviso")
				EndIf
				_lRetorno	:= .F.
				
			EndIf
			
		Else // Nao achou condicao digitada
			
			If !lTk271Auto
				MsgAlert(OemtoAnsi("A Condição de pagamento informada NÃO existe, verifique !"), "Aviso")
			EndIf
			_lRetorno	:= .F.
			
		EndIf
		
	EndIf
	
EndIf

RestArea(aAreaSE4)
RestArea(aArea)

Return(_lRetorno)
