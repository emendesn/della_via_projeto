#INCLUDE "PROTHEUS.CH" 
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �TmkActive �Autor  �Norbert Waage Junior   � Data �  12/09/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Ponto de entrada no activate da tela do televendas, utilizado  ���
���          �para criacao de variaveis.                                     ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �PE acionado na abertura do televendas                          ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function TMKACTIVE

//������������������������������������������������������Ŀ
//�A variavel  _Dela030Cond armazena a ultima condicao de�
//�pagamento utilizada                                   �
//��������������������������������������������������������
Public _DelA030Cond	:= ""

If nFolder == 2
	_DelA030Cond	:= M->UA_CONDPG
EndIf

Return .F.