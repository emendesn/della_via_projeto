/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DV_CC631  �Autor  �Microsiga           � Data �  04/14/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �REGRAS PARA CONTABILIZACAO DE JUROS/DESCONTO                ���
���          �SIGALOJA EXECUTADO PELO LANCAMENTO PADRAO 631               ���
�������������������������������������������������������������������������͹��
���Uso       �ESPECIFICO DELLA VIA                                        ���
�������������������������������������������������������������������������ͼ��
�� CENTRO DE CUSTO DA RECEITA DE VENDAS DA DELLA VIA - CONTAS A RECEBER    ��   
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DV_CC500()
Local c_Custo	:= ''
Local a_area	:= GetArea()
Local a_areaSF2	:= SF2->(GetArea())
Local a_areaSD2	:= SD2->(GetArea())
Local a_areaSC5	:= SC5->(GetArea())
Local a_areaSZ1	:= SZ1->(GetArea())
Local a_areaSA3	:= SE1->(GetArea())


DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(SE1->(E1_MSFIL+E1_PEDIDO))


DbSelectArea("SZ1")
DbSetOrder(1)
DbSeek(XFILIAL("SZ1")+SM0->M0_CODIGO+SM0->M0_CODFIL)

IF SC5->C5_TPVEND == 'T'
	c_Custo	:= SZ1->Z1_CCTRUC
elseif SC5->C5_TPVEND == 'A'
	c_Custo	:= SZ1->Z1_CCATAC
elseif SC5->C5_TPVEND == 'V'
	c_Custo	:= SZ1->Z1_CCVARE
elseif SC5->C5_TPVEND == 'F'
	c_Custo	:= SZ1->Z1_CCFROT
Endif


RestArea(a_areaSZ1)
RestArea(a_areaSD2)
RestArea(a_areaSC5)
RestArea(a_areaSF2)
//RestArea(a_areaSA3)
RestArea(a_area)

Return(c_Custo)
