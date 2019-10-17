/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DV_CC631  ºAutor  ³Microsiga           º Data ³  04/14/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³REGRAS PARA CONTABILIZACAO DAS NOTAS FISCAIS DE SAIDA       º±±
±±º          ³SIGALOJA EXECUTADO PELO LANCAMENTO PADRAO 631               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESPECIFICO DELLA VIA                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± CENTRO DE CUSTO DA RECEITA DE VENDAS DA DELLA VIA - SIGALOJA            ±±   
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DV_CC631()
Local c_Custo	:= ''
Local a_area	:= GetArea()
Local a_areaSL1 := SL1->(GetArea())
Local a_areaSZ1	:= SZ1->(GetArea())

DbSelectArea("SZ1")
DbSetOrder(1)
MsSeek(XFILIAL("SZ1")+SM0->M0_CODIGO+SM0->M0_CODFIL)

IF SL1->L1_TIPOVND == 'T'
	c_Custo	:= SZ1->Z1_CCTRUC
elseif SL1->L1_TIPOVND == 'A'
	c_Custo	:= SZ1->Z1_CCATAC
elseif SL1->L1_TIPOVND == 'V'
	c_Custo	:= SZ1->Z1_CCVARE
elseif SL1->L1_TIPOVND == 'F'
	c_Custo	:= SZ1->Z1_CCFROT
elseif SL1->L1_TIPOVND == 'R'
	c_Custo	:= SZ1->Z1_CCRODA
elseif SL1->L1_TIPOVND == 'D'
	c_Custo	:= SZ1->Z1_CCDIRE
Endif

RestArea(a_areaSZ1)
RestArea(a_areaSL1)
RestArea(a_area)

Return(c_Custo)
