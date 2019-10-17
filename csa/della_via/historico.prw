/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HISTORICO ºAutor  ³Microsiga           º Data ³  13/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³BUSCAR HISTÓRICO PADRÃO PARA CNAB                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESPECIFICO DELLA VIA                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HISTORICO()                          
Local Hist	:= ''
Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1 

// Salva Areas
_aArea1   := GetArea()
_aArqs1   := {"SE5","SE1"}
_aAlias1  := {}
For _nX1  := 1 To Len(_aArqs1)
    dbSelectArea(_aArqs1[_nX1])
    AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
Next                                      
//           
IF((Empty(SE5->E5_LOTE)).Or.(Empty(SE5->E5_ARQCNAB))) 
   Hist := SE1->("REC. TIT.EM "+DTOC(E1_BAIXA)) + " TIPO " + SE1->E1_TIPO
Else
   Hist := Hist + ("RECEBIMENTO LOTE "+SE5->E5_LOTE) 
Endif   

If(SE1->E1_CLIENTE $ '001   #002   #003   #004   #005   #006   ')
   Hist := Hist + (" CARTÃO ")
Endif                            

//RestArea(a_areaSE5) 
// Restaura Areas
For _nX1 := 1 To Len(_aAlias1)
   dbSelectArea(_aAlias1[_nX1,1])
   dbSetOrder(_aAlias1[_nX1,2])
   dbGoTo(_aAlias1[_nX1,3])
Next
//     RestArea(_aArea1)
Return(Hist)