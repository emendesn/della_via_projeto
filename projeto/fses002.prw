#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � FSES002  �Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na Rotina de Sincronia ao final da        ���
���          � importacao de pacote                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FSES002()
Local aArea     := GetArea()

// Recalculo do Saldo de Estoques
MATA300(.T.)

RestArea( aArea )
Return .T.
