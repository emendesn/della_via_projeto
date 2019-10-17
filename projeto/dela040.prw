#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA040   � Autor �Norbert Waage Junior� Data �  08/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Cadastro de motivos de liberacao/bloqueio do credito no CRD.���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo menu do sigaloja especifico do cliente. ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DelA040

dbSelectArea("PAM")
dbSetOrder(1)

AxCadastro("PAM","Motivos de Bloqueio do CRD","P_DelA040a()",".T.")

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA040A  �Autor  �Norbert Waage Junior� Data �  08/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a exclusao de um motivo de bloqueio/liberacao, veri- ���
���          �cando se este ja foi utilizado.                             ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DelA040a()

Local aArea		:=	GetArea()
Local aAreaMA7	:=	MA7->(GetArea())
Local cArq		:=	""
Local lRet		:=	.T.

//����������������������Ŀ
//�Cria indice temporario�
//������������������������
cArq := CriaTrab(Nil,.F.)
DbSelectArea("MA7")	
IndRegua("MA7",cArq,"MA7_MOTIVO")

//��������������������������������������Ŀ
//�Retorna .F. se o motivo estiver em uso�
//����������������������������������������
If lRet := !(DbSeek(PAM->PAM_COD))
	ApMsgAlert("O motivo n�o pode ser exclu�do pois foi utilizado.","Integridade")
EndIf

//����������������������������������Ŀ
//�Restaura areas e apaga temporarios�
//������������������������������������    
RetIndex("MA7")
DbSetorder(1)
Ferase(cArq+OrdBagExt())
RestArea(aAreaMA7)
RestArea(aArea)

Return lRet                  	