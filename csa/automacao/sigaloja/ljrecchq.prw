#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJRECCHQ  �Autor  �Marcio Domingos     � Data �  19/01/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na rotina de recebimento de titulos apos  ���
���          � gravacao do SEF.                                           ���       
�������������������������������������������������������������������������͹��
���Parametros�  Nao se aplica                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � Usado para atualizar campo EF_EMISSAO com a data de rece-  ���
���          � bimento do cheque.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                          	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LJRECCHQ()

RecLock("SEF",.F.)
SEF->EF_EMISSAO := dDatabase
MsUnlock()

Return .T.