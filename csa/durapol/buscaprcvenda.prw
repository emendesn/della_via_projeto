#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSCAPRCVENDAºAutor  ³Microsiga        º Data ³  23/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa a busca do preco de venda com relacao a tabela de   º±±
±±º          ³preco e cadastro de produtos                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BuscaPrcVenda(_cServ,_cCliente,_cLoja)

Local _aArea := GetArea()
Local _nValor:= 0

IF !Empty(_cServ)
	
   dbSelectArea("SA1")
   dbSetOrder(1)
   dbSeek(xFilial("SA1")+_cCliente+_cLoja)
   	
   dbSelectArea("ACP")
   dbSetOrder(4)
   dbSeek(xFilial("ACP")+_cCliente+_cLoja+_cServ) 
   if eof() 
                                                     //Cliente nao tem regra de desconto especifica, loja#"  "
      dbSeek(xFilial("ACP")+_cCliente+"  "+_cServ)
      if eof()
                                             //Cliente nao tem regra de desconto geral     , loja="  " 
         dbSelectArea("DA1")
         dbSetOrder(1)                              
         dbSeek(xFilial("DA1")+"001"+_cServ)
         if eof()                                    //Serviço sem preço na tabela básica=001                  
            _nValor := 0                             //Retornando 0 para serviço sem regras válidas
         else
            _nValor := DA1->DA1_PRCVEN               //Retornando valor a tabela básica=001 de preço
         endif
      else
         _nValor := ACP_PRCVEN                       //Retornando valor do item da Regra de Desconto da loja do cliente
      endif
   else
      _nValor := ACP_PRCVEN                          //Retornando valor do item da Regra de Desconto geral do cliente loja ="  "               endif
   endif
else
   _nValor = 0                                       //Codigo do Serviço não informado
endif
		
if _nValor == 0
   MsgInfo("Nao existe tabela de preco para este cliente,"+_cServ+" esta sem o preco de venda!","Atenção")
endif

RestArea(_aArea)

Return(_nValor)
