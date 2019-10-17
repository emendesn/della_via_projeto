
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSC1110D �Autor  �Alexandre Martim    � Data �  23/11/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Ponto de entrada na exclusao de solicitacao de compra.   ���
���          � Caso o usuario tente excluir uma solicitacao que nao seja  ���
���          � da filial corrente, o sistema aborta e emite uma mensagem  ���
���          � de aviso.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MSC1110D()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1, _lRet:=.t.
     //
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC7","SM0","SC1"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //
     If cFilant <> SC1->C1_FILENT
        //
        DbSelectArea("SM0")
        If Dbseek(cEmpant+SC1->C1_FILENT,.f.)
           Aviso("Alerta","Esta solicitacao devera sera cancelada pela filial ["+SM0->M0_NOME+"]",{"OK"},1,"")
        Endif
        _lRet := .f.
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
