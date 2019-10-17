User Function DV_LP631J()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DV_LP631J �Autor  �Microsiga           � Data �  04/14/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �REGRAS PARA CONTABILIZACAO DO CUPOM FISCAL DA               ���
���          �DELLA VIA                                                    ���
�������������������������������������������������������������������������͹��
���Uso       �ESPECIFICO DELLA VIA                                        ���
�������������������������������������������������������������������������ͼ��
�� JUROS DO CARTAO E FINANCEIRA                                            ��    
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Local a_titulo
Local n_Valor    := 0
Local a_area	 := GetArea()
Local a_areaSL4  := SL4->(GetArea())
Local a_areaSE1	 := SE1->(GetArea())

DbSelectArea("SE1")
DbSetorder(1) 
IF !EMPTY(SL1->L1_PDV)
   DbSeek(xfilial()+SL1->L1_SERIE+SL1->L1_DOC)
   a_titulo := xfilial()+SL1->L1_SERIE+SL1->L1_DOC
ELSE 
  DbSeek(xfilial()+"U"+SL1->L1_FILIAL+SL1->L1_DOC)
  a_titulo := xfilial()+"U"+SL1->L1_FILIAL+SL1->L1_DOC
ENDIF    

While !eof() .and. a_titulo==e1_filial+e1_prefixo+e1_num
 If e1_tipo==subs(sl4->l4_forma,1,3) .and. sl4->l4_valor==e1_vlrreal
   n_Valor := e1_vlrreal - e1_valor  // valor dos juros
 end
 DbSkip()
End

RestArea(a_areaSL4)
RestArea(a_areaSE1)
RestArea(a_area)
Return(n_Valor)

