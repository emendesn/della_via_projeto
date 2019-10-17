User Function DV_LP650()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DV_LP650  ºAutor  ³Microsiga           º Data ³  04/14/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³REGRAS PARA CONTABILIZACAO DAS NOTAS FISCAIS DE SAIDA       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESPECIFICO DELLA VIA                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± CONTA CONTABIL A DEBITO DAS VENDAS DA DELLA VIA                         ±±    
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Local c_Conta
Local a_area	:= GetArea()
Local a_areaSF4	:= SF4->(GetArea())
Local a_areaSF2	:= SF2->(GetArea())
Local a_areaSC5	:= SC5->(GetArea())
Local a_areaSE4	:= SE4->(GetArea())

DbSelectArea("SF2")
DbSetorder(1)
DbSeek(xFilial()+SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA))

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial()+SD2->D2_PEDIDO)

// PARA APURAR O CENTRO DE CUSTO DA RECEITA
DbSelectArea("SZ1")
DbSetOrder(1)
DbSeek(xFilial()+SC5->C5_CODFIL)

// TRATA-SE DE OPERACOES QUE NAO GERAM FINANCEIRO E DEVEM SER CONTABILIZADOS PELO TES
If SF2->F2_COND='999'                                                             
 
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial()+SD2->D2_TES)
	c_Conta	:= SF4->F4_CONTA
 
Else
   	  
        DbSelectArea("SE4")
        DbSetOrder(1)
        DbSeek(xFilial()+SF2->F2_COND)
        c_Conta	:= SE4->E4_CONTA
    
Endif
RestArea(a_areaSF4)
RestArea(a_areaSF2)
RestArea(a_areaSC5)
RestArea(a_areaSE4)
RestArea(a_area)
Return(c_Conta)
