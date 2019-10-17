/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GERASK1   �Autor  �Marcelo Alcantara   � Data �  13/10/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para execultar sele��o de Titulos no SK1 automatico ���
���          � no chamado no Schedule                                     ���
�������������������������������������������������������������������������͹��
���Parametros�  aParms[1] = Empresa que sera roda a funcao                ���
���          �  aParms[2] = que sera roda a funcao                        ���
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

User Function GeraSK1(aParms) 
//��������������������������������������������������������������Ŀ
//| Abertura do ambiente                                         |
//����������������������������������������������������������������
ConOut(Repl("-",80))
ConOut(PadC("Geracao de titulos no SK1",80))
PREPARE ENVIRONMENT EMPRESA aParms[1] FILIAL aParms[2] MODULO "TMK" TABLES "SE1", "SK1"

//��������������������������������������������������������������Ŀ
//| Execulta Funcao para Selecao de titulos(SK1) 
//����������������������������������������������������������������
ConOut("Inicializando Geracao do Titulo (SK1) Data: "+dToc(date())+"  Hora: " +Time())
If Tk180Atu()
	ConOut("Selecao de Titulos Gerado com sucesso! ")
Else
	ConOut("Erro na gera��o de Selecao de Titulos!")
EndIf

ConOut("Termino da Geracao de Titulos (SK1) : Data: "+dToc(date())+"  Hora: " +Time())
ConOut(Repl("-",80))

RESET ENVIRONMENT
Return(.T.)
