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

User Function Validcc()

local _Lret := .T.
local cRecPag := "R"

//If m->e1_moeda<>"VL"  // vales do caixinha

   If cRecPag=="R"  // contas a receber

      If empty(M->E1_credit)   
         MsgStop("Falta conta contabil credito.!")  
         _Lret := .F.
      ElseIf subs(m->e1_credit,1,1)<>"3"
       If !empty(m->e1_ccc)
          MsgStop("conta nao pode ter centro de custo credito.!")
          _Lret := .F. 
       End
      ElseIf subs(m->e1_credit,1,1)=="3"
       If empty(m->e1_ccc)   	
          MsgStop("falta centro de custo credito.!")
          _Lret := .F. 
       End
      End

   End


//End

If  !_Lret
 m->e1_naturez := space(10) 
End                                

Return(_Lret)

