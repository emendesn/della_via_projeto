#INCLUDE "PROTHEUS.CH"

/*/
��������������������������������������������������������������
��������������������������������������������������������������
��IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII��
���Programa  �VALIDCC �Autor  �Microsiga           � Data �  05/09/05   			�	��
��IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII��
���Desc.     �VALID PARA O CAMPO SE5->E5_NATUREZA                         �			��
���          �VERIFICA SE O CENTRO DE CUSTO E A CONTA CONTABIL            �		��
���          �FORAM INFORMADOS CORRETAMENTE                                  �				��
��IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII��
���Uso       �ESPECIFICO DELLA VIA                                         �							��
��IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII��
��������������������������������������������������������������
�����������������������������������������������������������������������
/*/

User Function Validcc2()

local _Lret := .T.   
local cRecPag := "P"

//   If cRecPag=="P"  // contas a pagar

      If empty(M->E2_debito)   
         MsgStop("Falta conta contabil debito.!")  
         _cret := .F.
      ElseIf subs(m->e2_debito,1,1)<>"3"
       If !empty(m->e2_ccd)
          MsgStop("conta nao pode ter centro de custo debito.!")
          _cret := .F. 
       End
      ElseIf subs(m->e2_debito,1,1)=="3"
       If empty(m->e2_ccd)
          MsgStop("falta centro de custo debito.!")
          _cret := .F. 
       End
      End

//   End

If  !_Lret
 m->e2_naturez := space(10) 
End                                

Return(_Lret)

