User Function DV_LP600()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DV_LP600  �Autor  �Microsiga           � Data �  04/14/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �REGRAS PARA CONTABILIZACAO DAS NOTAS FISCAIS DE SAIDA       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �ESPECIFICO DELLA VIA                                        ���
�������������������������������������������������������������������������ͼ��
�� CONTA CONTABIL A DEBITO DAS VENDAS DA DELLA VIA                         ��    
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Local c_Conta
Local a_area	:= GetArea()
Local a_areaSF4	:= SF4->(GetArea())
Local a_areaSF2	:= SF2->(GetArea())
Local a_areaSE4	:= SE4->(GetArea())

DbSelectArea("SF2")
DbSetorder(1)
DbSeek(SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA))

// TRATA-SE DE OPERACOES QUE NAO GERAM FINANCEIRO E DEVEM SER CONTABILIZADOS PELO TES
If SF2->F2_COND='999'                                                             
 
   DbSelectArea("SF4")
   DbSetOrder(1)
   DbSeek(xFilial("SD2")+SD2->D2_TES)
   c_Conta	:= SF4->F4_CONTA
 
Else
   	  
    DbSelectArea("SE4")
    DbSetOrder(1)
    DbSeek(xFilial("SE4")+SF2->F2_COND)
    c_Conta	:= SE4->E4_CONTA
    
Endif
RestArea(a_areaSF4)
RestArea(a_areaSF2)
RestArea(a_areaSE4)
RestArea(a_area)
Return(c_Conta)
