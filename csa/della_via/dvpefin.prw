#include "RWMAKE.CH"  
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � FINA410    � Autor � Geraldo Sabino Ferreira Data � 26.01.07 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Utilizacao de 3 Pontos de Entrada para gravacao da data da   潮�
北�            ultima compra. (Se for E1_TIPO="CHD" nao deve atualizar.     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�                                                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGAFIN                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static dUltCom

user Function FA040INC()

aAreaSA1:=GetArea()

dBselectarea("SA1")
dbsetorder(1)
IF dbseek(xFilial("SA1")+M->E1_CLIENTE+M->E1_LOJA)
   dUltCom := SA1->A1_ULTCOM
ENDIF
                        
RestArea(aAreaSA1)
 
Return .T.



User Function FA040GRV()

if dUltCom  <> Nil // .and. SE1->E1_TIPO = 'CHD'
   SA1->(Reclock('SA1'))
   SA1->A1_ULTCOM := dUltCom
   SA1->(MsUnlock())
Endif
Return

            
User Function FA040FIN
dUltCom := Nil
Return
