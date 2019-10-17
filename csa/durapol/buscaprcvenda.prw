#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BUSCAPRCVENDA�Autor  �Microsiga        � Data �  23/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa a busca do preco de venda com relacao a tabela de   ���
���          �preco e cadastro de produtos                                ���
�������������������������������������������������������������������������͹��
���Uso       � Durapol                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
         if eof()                                    //Servi�o sem pre�o na tabela b�sica=001                  
            _nValor := 0                             //Retornando 0 para servi�o sem regras v�lidas
         else
            _nValor := DA1->DA1_PRCVEN               //Retornando valor a tabela b�sica=001 de pre�o
         endif
      else
         _nValor := ACP_PRCVEN                       //Retornando valor do item da Regra de Desconto da loja do cliente
      endif
   else
      _nValor := ACP_PRCVEN                          //Retornando valor do item da Regra de Desconto geral do cliente loja ="  "               endif
   endif
else
   _nValor = 0                                       //Codigo do Servi�o n�o informado
endif
		
if _nValor == 0
   MsgInfo("Nao existe tabela de preco para este cliente,"+_cServ+" esta sem o preco de venda!","Aten��o")
endif

RestArea(_aArea)

Return(_nValor)
