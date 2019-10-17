#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKBARLA  �Autor  � Marcelo Gaspar     � Data �  23/10/02   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para criacao de Botoes especificos no ToolBar       ���
���          � Lateral da tela de Atendimento do Call Center.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Observacao� Ponto de Entrada executado na montagem da tela de          ���
���          � Atendimento do Call Center.                                ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � CallCenter --> TeleVendas                                  ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���Mansano   �10/06/05�      �Aproveitamento da Rotina no projeto da   	  ���
���          �        �      �Della Via Pneus.                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TMKBARLA()
Local aRet := {}

// Array com os botoes onde: 
// 1 Coluna: Nome do BITMAP para desenho do botao (String)
// 2 Coluna: Nome da funcao que sera executada (Execblock)
// 3 Coluna: Texto para exibicao do Hint (Texto descritivo do botao)
Aadd(aRet,{"S4WB005N",&("{|| P_DELC003A() }"),"Consulta Estoque"})
//Aadd(aRet,{"GRAF3D"  ,&("{|| P_DELA018B() }"),"Margem M�dia do Pedido"})
Aadd(aRet,{"S4WB005N",&("{|| U_ConsEst() }"),"Consult Produto por Produto"})
Return(aRet)