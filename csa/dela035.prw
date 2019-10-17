#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ DELA035  ºAutor  ³ Ernani Forastieri  º Data ³  30/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao generica para ser colocoda no X3_VLDUSER para       º±±
±±º          ³ permitir a Inclusao/Alteracao baseado no PAK               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	ApMsgStop( 'Usuário sem permissão para este campo', 'ATENÇÃO' )
EndIf

RestArea( aArea )
Return lRet


/////////////////////////////////////////////////////////////////////////////