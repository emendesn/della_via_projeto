#include "RWMAKE.CH"  
/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � FINA410    � Autor � Geraldo Sabino Ferreira Data � 26.01.07 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de 3 Pontos de Entrada para gravacao da data da   ���
���            ultima compra. (Se for E1_TIPO="CHD" nao deve atualizar.     ���
���������������������������������������������������������������������������Ĵ��
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFIN                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
