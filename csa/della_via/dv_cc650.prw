/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DV_CC650  ºAutor  ³Microsiga           º Data ³  04/14/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³REGRAS PARA CONTABILIZACAO DAS NOTAS FISCAIS DE SAIDA       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESPECIFICO DELLA VIA                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± CENTRO DE CUSTO DA RECEITA DE VENDAS DA DELLA VIA                       ±±   
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DV_CC650()
Local c_Custo	:= ''
Local a_area	:= GetArea()
Local a_areaSF2	:= SF2->(GetArea())
Local a_areaSC5	:= SC5->(GetArea())
Local a_areaSE4	:= SZ1->(GetArea())

DbSelectArea("SF2")
DbSetorder(1)
DbSeek(xFilial()+SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA))

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial()+SD2->D2_PEDIDO)

// PARA APURAR O CENTRO DE CUSTO DA RECEITA
DbSelectArea("SZ1")
DbSetOrder(1)
DbSeek(xFilial()+IIF(!EMPTY(SC5->C5_CODFIL),SC5->C5_CODFIL,SC5->C5_FILIAL))

IF SC5->C5_TPVEND == 'T'
	c_Custo	:= SZ1->Z1_CCTRUC
elseif SC5->C5_TPVEND == 'A'
	c_Custo	:= SZ1->Z1_CCATAC
elseif SC5->C5_TPVEND == 'V'
	c_Custo	:= SZ1->Z1_CCVARE
elseif SC5->C5_TPVEND == 'F'
	c_Custo	:= SZ1->Z1_CCFROT
Endif

//RestArea(a_areaSZ1)
RestArea(a_areaSF2)
RestArea(a_areaSC5)
RestArea(a_area)

Return(c_Custo)
