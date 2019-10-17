#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � DELA035  �Autor  � Ernani Forastieri  � Data �  30/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao generica para ser colocoda no X3_VLDUSER para       ���
���          � permitir a Inclusao/Alteracao baseado no PAK               ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA035( cCodUsu, cVarAtual, lInclui, lAltera, lExibeTela )
Local lRet    := .F.
Local aArea   := GetArea()

Default lExibeTela := .T.
Default cCodUsu    := __cUserId
Default cVarAtual  := PadR( StrTRan( ReadVar(), 'M->', ''), 10 )
Default lInclui    := INCLUI
Default lAltera    := ALTERA

If PAK->( dbSeek( xFilial( 'PAK' ) + cCodUsu + cVarAtual ) )
	If  ( PAK->PAK_PERMIS == 'I' .AND. lInclui ) .OR. ;
		( PAK->PAK_PERMIS == 'A' .AND. lAltera ) .OR. ;
		PAK->PAK_PERMIS == 'B'
		lRet    := .T.
	EndIf
	
EndIf

If !lRet .AND. lExibeTela
	ApMsgStop( 'Usu�rio sem permiss�o para este campo', 'ATEN��O' )
EndIf

RestArea( aArea )
Return lRet


/////////////////////////////////////////////////////////////////////////////