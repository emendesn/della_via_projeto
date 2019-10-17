/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDNATU �Autor  �Microsiga           � Data �  05/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �VALID PARA O CAMPO SE5->E5_NATUREZA                         ���
���          �VERIFICA SE O CENTRO DE CUSTO E A CONTA CONTABIL            ���
���          �FORAM INFORMADOS CORRETAMENTE                               ���
�������������������������������������������������������������������������͹��
���Uso       �ESPECIFICO DELLA VIA                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Validnatu()

local _cret := .T.

If m->e5_moeda<>"VL"  // vales do caixinha

   If cRecPag=="R"  // contas a receber

      If empty(M->E5_credito)   
         MsgStop("Falta conta contabil credito.!")  
         _cret := .F.
      ElseIf subs(m->e5_credito,1,1)<>"3"
       If !empty(m->e5_ccc)
          MsgStop("conta nao pode ter centro de custo credito.!")
          _cret := .F. 
       End
      ElseIf subs(m->e5_credito,1,1)=="3"
       If empty(m->e5_ccc)
          MsgStop("falta centro de custo credito.!")
          _cret := .F. 
       End
      End

   End

   If cRecPag=="P"  // contas a pagar

      If empty(M->E5_debito)   
         MsgStop("Falta conta contabil debito.!")  
         _cret := .F.
      ElseIf subs(m->e5_debito,1,1)<>"3"
       If !empty(m->e5_ccd)
          MsgStop("conta nao pode ter centro de custo debito.!")
          _cret := .F. 
       End
      ElseIf subs(m->e5_debito,1,1)=="3"
       If empty(m->e5_ccd)
          MsgStop("falta centro de custo debito.!")
          _cret := .F. 
       End
      End

   End

End

If  !_cret
 m->e5_naturez 	:= space(10) 
End

Return(_cret)

