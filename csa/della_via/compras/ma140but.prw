#include "rwmake.ch"

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � MA140BUT   � Autor � Geraldo S.Ferreira    � Data � 30/08/04 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Cria Botao para ITEM PC (DELLA VIA NA OPCAO ORIGINAL COM PROBLEMAS). NAO PODE APLICAR PATCH ATUAL)
���          �                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACOM                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Ma140But()

#DEFINE FRETE     	04  // Valor total do Frete
#DEFINE VALDESP   	05	// Valor total da despesa
#DEFINE SEGURO	    07	// Valor total do seguro

Local a140Desp   := {0,0,0,0,0,0,0,0}
Local lnfMedic      := .f.
Local lConsMedic := .f.
Local  aPedc       :={}

Local aBut := {}
AAdd( aBut, { "PRODUTO", { || A103ItemPC(.F.,aPedC,oGetDados, lNfMedic, lConsMedic,,,a140Desp )} ,"Item do Pedido de Compra" } )
Return( aBut )


