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

User Function DV_CCD650()
Local c_Custo	:= Space(Len(CTT->CTT_CUSTO))
Local a_area	:= GetArea()
Local a_areaSF2	:= SF2->(GetArea())
Local a_areaSD2	:= SD2->(GetArea())
Local a_areaSD1	:= SD1->(GetArea())
Local a_areaSC5	:= SC5->(GetArea())
Local a_areaSZ1	:= SZ1->(GetArea())
Local a_areaSA3	:= SA3->(GetArea())

dbSelectArea("SD2")
dbSetorder(3)
IF MsSeek(SD1->(xFilial("SD2")+SD1->D1_NFORI))
   IF EMPTY(SD2->D2_ORIGLAN)
	  dbSelectArea("SC5")
	  dbSetOrder(1)
      If MsSeek(SD2->(xFilial("SC5")+SD2->D2_PEDIDO))
		
	      DbSelectArea("SZ1")
		  DbSetOrder(1)
		  If MsSeek(XFILIAL("SZ1")+SM0->M0_CODIGO+SM0->M0_CODFIL)
			
		    	If SC5->C5_TPVEND == 'T'
			    	c_Custo	:= SZ1->Z1_CCTRUC
    			elseif SC5->C5_TPVEND == 'A'
	    			c_Custo	:= SZ1->Z1_CCATAC
		    	elseif SC5->C5_TPVEND == 'V'
			    	c_Custo	:= SZ1->Z1_CCVARE
    			elseif SC5->C5_TPVEND == 'F'
	    			c_Custo	:= SZ1->Z1_CCFROT
		    	elseif SC5->C5_TPVEND == 'R'
			    	c_Custo	:= SZ1->Z1_CCRODA
    			elseif SC5->C5_TPVEND == 'D'
	    			c_Custo	:= SZ1->Z1_CCDIRE				
		    	Endif
	
		 /*	dbSelectArea("SA3")
			dbSetOrder(1)
			If MsSeek(xFilial("SA3")+SF2->F2_VEND1) .And. SA3->A3_TIPVEND=="4"
				c_Custo	:= SZ1->Z1_CUSTO // Vendedor 555 - Sergio - Atacado da Matriz
			EndIf*/
		  Endif
      EndIf
   ELSE   
   //POSICIONAR NO L1
	  dbSelectArea("SL1")
	  dbSetOrder(2)
      If MsSeek(SD2->(xFilial("SL1")+SD2->D2_SERIE+SD2->D2_DOC))   
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
EndIf

RestArea(a_areaSZ1)
RestArea(a_areaSD2)
RestArea(a_areaSD1)
RestArea(a_areaSC5)
RestArea(a_areaSF2)
RestArea(a_areaSA3)
RestArea(a_area)

Return(c_Custo)