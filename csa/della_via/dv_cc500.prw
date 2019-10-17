/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DV_CC631  ºAutor  ³Microsiga           º Data ³  04/14/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³REGRAS PARA CONTABILIZACAO DE JUROS/DESCONTO                º±±
±±º          ³SIGALOJA EXECUTADO PELO LANCAMENTO PADRAO 631               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESPECIFICO DELLA VIA                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± CENTRO DE CUSTO DA RECEITA DE VENDAS DA DELLA VIA - CONTAS A RECEBER    ±±   
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DV_CC500()
Local c_Custo	:= ''  
Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
/*Local a_area	:= GetArea()
Local a_areaSF2	:= SF2->(GetArea())
Local a_areaSD2	:= SD2->(GetArea())
Local a_areaSC5	:= SC5->(GetArea())
Local a_areaSZ1	:= SZ1->(GetArea())
Local a_areaSA3	:= SE1->(GetArea())*/
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC5","SZ1","SE1"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //

DbSelectArea("SC5")
DbSetOrder(1)
MsSeek(SE1->(E1_MSFIL+E1_PEDIDO))

DbSelectArea("SZ1")
DbSetOrder(1)
MsSeek(XFILIAL("SZ1")+SM0->M0_CODIGO+SE1->(E1_MSFIL))

DO CASE
CASE SC5->C5_TPVEND == 'T'
	c_Custo	:= SZ1->Z1_CCTRUC
CASE SC5->C5_TPVEND == 'V'
	c_Custo	:= SZ1->Z1_CCVARE
CASE SC5->C5_TPVEND == 'F'
	c_Custo	:= SZ1->Z1_CCFROT   
CASE SL1->L1_TIPOVND == 'R'
	c_Custo	:= SZ1->Z1_CCRODA
CASE SL1->L1_TIPOVND == 'D'
	c_Custo	:= SZ1->Z1_CCDIRE	
OTHERWISE		///SC5->C5_TPVEND == 'A'
	c_Custo	:= If(Empty(SZ1->Z1_CCATAC),SZ1->Z1_CCVARE,SZ1->Z1_CCATAC)
ENDCASE



/*RestArea(a_areaSZ1)
RestArea(a_areaSD2)
RestArea(a_areaSC5)
RestArea(a_areaSF2)
//RestArea(a_areaSA3)
RestArea(a_area)*/
// Restaura Areas
     For _nX1 := 1 To Len(_aAlias1)
         dbSelectArea(_aAlias1[_nX1,1])
         dbSetOrder(_aAlias1[_nX1,2])
         dbGoTo(_aAlias1[_nX1,3])
     Next
     RestArea(_aArea1)
     //

Return(c_Custo)
