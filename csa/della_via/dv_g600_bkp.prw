/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DV_CC600  ºAutor  ³Microsiga           º Data ³  04/14/05   º±±
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

User Function DV_G600()
/*Local c_Custo	:= Space(Len(CTT->CTT_CUSTO))
Local a_area	:= GetArea()
Local a_areaSF2	:= SF2->(GetArea())
Local a_areaSD2	:= SD2->(GetArea())
Local a_areaSC5	:= SC5->(GetArea())
Local a_areaSZ1	:= SZ1->(GetArea())
Local a_areaSA3	:= SA3->(GetArea())    */


Local c_Custo	:= Space(Len(CTT->CTT_CUSTO))
Local a_area	:= GetArea()
Local a_areaSL1 := SL1->(GetArea())
Local a_areaSZ1	:= SZ1->(GetArea())

DbSelectArea("SZ1")
      DbSetOrder(1)
      MsSeek(XFILIAL("SZ1")+SM0->M0_CODIGO+SM0->M0_CODFIL)
If (SF2->F2_FILIAL == '10' .or. SF2->F2_FILIAL  == '29' .or. SF2->F2_FILIAL == '46' .or. SF2->F2_FILIAL == '21' .or. SF2->F2_FILIAL == '34' .or. SF2->F2_FILIAL == '33' .or. SF2->F2_FILIAL == '39' ).And. SL1->L1_TIPOVND == 'T'
    	c_Custo	:= SZ1->Z1_CCTRUC
Else
   dbSelectArea("SA3")
   dbSetOrder(1)
   If MsSeek(xFilial("SA3")+SF2->F2_VEND1) .And. !Empty(SA3->A3_CC)
      	c_Custo	:= SA3->A3_CC
   Else	
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
  Endif
Endif  
RestArea(a_areaSZ1)
RestArea(a_areaSL1)
RestArea(a_area)

Return(c_Custo)


/*If (SF2->F2_FILIAL == '10' .or. SF2->F2_FILIAL  == '29' .or. SF2->F2_FILIAL == '46' .or. SF2->F2_FILIAL == '21' .or. SF2->F2_FILIAL == '34' .or. SF2->F2_FILIAL == '33' .or. SF2->F2_FILIAL == '39' ).And. SC5->C5_TPVEND == 'T'
    	c_Custo	:= SZ1->Z1_CCTRUC
ENDIF
dbSelectArea("SA3")
dbSetOrder(1)
If MsSeek(xFilial("SA3")+SF2->F2_VEND1) .And. !Empty(SA3->A3_CC)
	c_Custo	:= SA3->A3_CC
Else
	dbSelectArea("SC5")
	dbSetOrder(1)
	If MsSeek(SD2->(xFilial("SC5")+D2_PEDIDO))
		
		dbSelectArea("SZ1")
		dbSetOrder(1)
		If MsSeek(XFILIAL("SZ1")+SM0->M0_CODIGO+SM0->M0_CODFIL)
			
			If SC5->C5_TPVEND == 'T'
				c_Custo	:= SZ1->Z1_CCTRUC
			elseif SC5->C5_TPVEND == 'A'
				c_Custo	:= SZ1->Z1_CCATAC
			elseif SC5->C5_TPVEND == 'V'
				c_Custo	:= SZ1->Z1_CCVARE
			elseif SC5->C5_TPVEND == 'F'
				c_Custo	:= SZ1->Z1_CCFROT    
			elseif SL1->L1_TIPOVND == 'R'
				c_Custo	:= SZ1->Z1_CCRODA
			elseif SL1->L1_TIPOVND == 'D'
				c_Custo	:= SZ1->Z1_CCDIRE				
			Endif
	
	
		EndIf
	EndIf
EndIf

RestArea(a_areaSZ1)
RestArea(a_areaSD2)
RestArea(a_areaSC5)
RestArea(a_areaSF2)
RestArea(a_areaSA3)
RestArea(a_area)*/

Return(c_Custo)