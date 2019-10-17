
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������                                 

�������������������������������������������������������������������������ͻ��
���Programa  �VALIDCX   �Autor  �Marcelo Alcantara   � Data �  06/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o Caixa na movimentacao bancaria, Banco nao pode ser ���
���          |na loja - Somente para o modulo de LOJA                     ���
�������������������������������������������������������������������������͹��
���Uso       �SIGALOJA                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
User Function ValidCx
if cModulo == "LOJ" .and. M->E5_BANCO <> SLF->LF_COD
   M->E5_BANCO  :=SLF->LF_COD
   M->E5_AGENCIA:= POSICIONE("SA6",1,XFILIAL("SLJ")+M->E5_BANCO,"A6_AGENCIA")
   M->E5_CONTA  := POSICIONE("SA6",1,XFILIAL("SLJ")+M->E5_BANCO+M->E5_AGENCIA,"A6_NUMCON")
   Aviso("ATENCAO","Numero do Banco nao pode ser alterado!!",{"Ok"},1,"Alteracao nao permitida para Loja")
   //MsgBox("Numero do Banco nao pode ser alterado!!")
   Return .F.
EndIf
Return .T.
