/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BaixaCob  �Autor  �Marcelo Alcantara   � Data �  19/10/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para execultar baixas automaticas dos titulos no    ���
���          � Telecobranca via Schedule                                  ���
�������������������������������������������������������������������������͹��
���Parametros�  aParms[1] 	= Empresa que sera roda a funcao              ���
���          �  aParms[2]	= que sera roda a funcao                      ���
�������������������������������������������������������������������������͹��
���Retorno   �  Nao se aplica                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � Schedule                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                          	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "TBICONN.CH" 

User Function BaixaCob(aParms) 

//��������������������������������������������������������������Ŀ
//| Abertura do ambiente                                         |
//����������������������������������������������������������������
ConOut(Repl("-",80))
ConOut("Baixando Titulos da cobranca",80)
PREPARE ENVIRONMENT EMPRESA aParms[1] FILIAL aParms[2] MODULO "TMK" TABLES "SE1", "SK1", "ACF", "ACG", "SU4", "SU6", "SE5"

//��������������������������������������������������������������Ŀ
//| Execulta Funcao para Selecao de titulos(SK1) 
//����������������������������������������������������������������
ConOut("Inicializando Baixa do Titulo de Cobranca Data: "+dToc(date())+"  Hora: " +Time())
If Tk290Atu()
	ConOut("Baixado com sucesso! ")
Else
	ConOut("Erro na Baixa Automatica!")
EndIf

ConOut("Termino da Baixa de Cobranca : Data: "+dToc(date())+"  Hora: " +Time())
ConOut(Repl("-",80))

RESET ENVIRONMENT
Return(.T.)
