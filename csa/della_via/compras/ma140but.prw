#include "rwmake.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    � MA140BUT   � Autor � Geraldo S.Ferreira    � Data � 30/08/04 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Cria Botao para ITEM PC (DELLA VIA NA OPCAO ORIGINAL COM PROBLEMAS). NAO PODE APLICAR PATCH ATUAL)
北�          �                                                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACOM                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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


