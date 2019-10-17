#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII±±
±±ºPrograma  ³VALIDCC ºAutor  ³Microsiga           º Data ³  05/09/05   			º	±±
±±IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII±±
±±ºDesc.     ³VALID PARA O CAMPO SE5->E5_NATUREZA                         º			±±
±±º          ³VERIFICA SE O CENTRO DE CUSTO E A CONTA CONTABIL            º		±±
±±º          ³FORAM INFORMADOS CORRETAMENTE                                  º				±±
±±IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII±±
±±ºUso       ³ESPECIFICO DELLA VIA                                         º							±±
±±IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

