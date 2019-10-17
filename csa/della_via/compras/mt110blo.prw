/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110BLO �Autor  �Alexandre Martim    � Data �  21/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada na aprovacao da solicitacao.             ���
���          �  Caso o Centro de custo esteja amarrado ao usuario em      ���
���          �questao libera-se a mesma, caso contrario recusa.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110BLO()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1    
     Local _lRet := .t.
     //
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC1","SZZ","SB1"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //
     If cEmpAnt $ "01/03"  // DellaVia e Durapol
        //
        DbSelectArea("SZZ")
        DbSetOrder(1)
        If DbSeek(xFilial("SZZ")+SC1->C1_CC,.F.)
           //
           If !SZZ->ZZ_APROV == RetCodUsr()
              Aviso("Alerta","Usuario "+Alltrim(substr(cUsuario,7,15))+" nao possui direito de aprovacao para o centro de custo ["+SC1->C1_CC+"]",{"OK"},1,"")
              _lRet := .f.
           Endif
           //
        Else
           //
           Aviso("Alerta","o Centro de custo ["+SC1->C1_CC+"] nao existe para o Usuario ["+Alltrim(substr(cUsuario,7,15))+"], verifique tabela de C.Custo x Gerente",{"OK"},1,"")
           _lRet := .f.
           //
        Endif 
        //  
     Endif
     //
	 // Restaura Areas
     For _nX1 := 1 To Len(_aAlias1)
         dbSelectArea(_aAlias1[_nX1,1])
         dbSetOrder(_aAlias1[_nX1,2])
         dbGoTo(_aAlias1[_nX1,3])
     Next
     RestArea(_aArea1)
     //
Return _lRet

