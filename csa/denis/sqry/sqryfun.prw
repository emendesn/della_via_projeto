/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SQryFun   ºAutor  ³Evaldo V. Batista   º Data ³  03/03/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fonte de funcoes especificas para a rotina de consulta     º±±
±±º          ³ pessoal automatica                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7.10 / Ferramentas                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
=============================================================================
=============================================================================
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConvText  ºAutor  ³Evaldo V. Batista   º Data ³  03/03/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para converter valores de qualquer tipo em texto    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ConvText( xValor )
Local cRet 		:= '' //Retorno em formato texto
Local cArray 	:= ''

If ValType( xValor ) == 'C'
	cRet := '"'+xValor+'"'
ElseIf ValType( xValor ) == 'N'
	cRet := AllTrim(Str( xValor ))
ElseIf ValType( xValor ) == 'D'
	cRet := 'CtoD("' + DtoC( xValor ) + '")'
ElseIf ValType( xValor ) == 'L'
	cRet := If( xValor, '.T.','.F.')
ElseIf ValType( xValor ) == 'A'
	cRet := '{' 
	aEval( xValor, {|x| cArray += U_ConvText(x) + ', ' } )
	cArray := Substr( cArray, 1, Len( cArray ) - 2 )
	cRet += cArray + '}'
ElseIf ValType( xValor ) == 'U'
	cRet := ''
ElseIf ValType( xValor ) == 'O'
	cRet := ''
ElseIf ValType( xValor ) == 'B'
	cRet := ''
EndIf

Return( cRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ArrayToTxtºAutor  ³Evaldo V. Batista   º Data ³  03/03/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para converter valores de qualquer tipo em texto    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ArrayToTxt(cNomVar)
Local cRet 		:= ''
Local cElemen	:= ''
Local aArray 	:= &( cNomVar ) 
LocaL xVal		:= &( cNomVar ) 


If ValType( aArray ) == 'A'
	If Len( aArray ) > 0
		aEval( aArray, {|x| cElemen := '', cRet += 'Aadd( ' + cNomVar + ', {',;
									aEval( x, {|y| cElemen += U_ConvText(y) + ', ' } ),; 
									cElemen := Substr( cElemen, 1, Len( cElemen ) - 2 ),;
									cRet += cElemen + '} ) ' + Chr(13) + Chr(10) } )
	Else
		cRet := cNomVar + ' := {}' + Chr(13) + Chr(10)
	EndIf
Else
	cRet += cNomVar + ' := ' + U_ConvText( xVal ) + Chr(13) + Chr(10)
EndIf
/*
If cNomVar == 'cQryExec'
	cRet := '\\ ' + cRet
EndIf
*/
Return( cRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TxtToArrayºAutor  ³Evaldo V. Batista   º Data ³  03/03/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para converter valores de qualquer tipo em texto    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TxtToArray( cArq )
Local nLineSize	:= 254
Local cMemo 		:= ""
Local nLines 		:= 0
Local cLine			:= ''
Local nPos			:= ''
If !File( cArq )
	If File( StrTran( cDirPad + '\'+ cArq, '\\', '\' ) )
		cArq := StrTran( cDirPad + '\'+ cArq, '\\', '\' )
	EndIf
EndIf

If File( cArq )
	cMemo := MemoRead( cArq )
Else
	For nPos := Len( cArq ) To 1 Step -1 
		If Substr( cArq, nPos, 1 ) == '\'
			nPos+=1
			Exit
		EndIF
	Next nPos
	If File( Substr( cArq, nPos ) )
		cMemo := MemoRead( Substr( cArq, nPos ) )
	EndIf
EndIf

nLines := MLCOUNT(cMemo, nLineSize)
For nCurrLine := 1 To nLines
	cLine := AllTrim( MEMOLINE(cMemo, nLineSize, nCurrLine ) )
	If nCurrLine > 760 
		MsgAlert( nCurrLine )
	EndIf
	If Substr( cLine, 1, 2 ) <> '\\'
	   &( cLine )
	EndIf
Next nCurrLine
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WzPesqListºAutor  ³Evaldo V. Batista   º Data ³  02/26/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa pelo texto cPesq no objeto oList                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function WzPesqList(oList,cPesq)
Local lRet 		:= .T.
Local nPos 		:= 0
Local nPosIni 	:= 1
Local nList		:= oList:nAt
Local aList 	:= oList:aItems
Local nTamTxt	:= Len( cPesq )
If nList > 0
	If AllTrim( cPesq ) $ aList[nList]
		If nList + 1 < Len( aList )
			nPosIni := nList + 1
		EndIf
	EndIf
EndIf
If Len( AllTrim( cPesq ) ) > 0 
	cPesq := Upper( AllTrim( cPesq ) ) 
	If Len( cPesq ) == 3
		nPos := aScan( aList, {|x| cPesq == Upper( Substr(x,2,3) ) }, nPosini )
	Else
		nPos := aScan( aList, {|x| cPesq $ Upper( x ) }, nPosIni )
	EndIf
	If nPos > 0
		oList:nAt := nPos
	EndIf
	cPesq := PadR( cPesq, nTamTxt )
EndIf

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AddSel    ºAutor  ³Evaldo V. Batista   º Data ³  02/26/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adiciona o Item Selecionado no ListBox2                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ListToList(oListOri, aArrayOri, oListDes, aArrayDest, nPosOri, bBlocOri, bBlocDes, cAdd, lTudo)
Local nTam		:= 0
Local aTmpOri	:= {}
Local aTmpDes	:= {}
Local cValOri	:= ""

Private aVar	:= {}



If Empty( nPosOri )
	nPosOri 	:= oListOri:nAt
EndIf

If !Empty( nPosOri )
	cValOri	:= oListOri:aItems[nPosOri]

	If !lTudo .and. nPosOri > 0 
		Aadd( aArrayDest, aClone( aArrayOri[nPosOri] ) )
		aDel( aArrayOri, nPosOri )
		nTam := len( aArrayOri ) - 1
		aSize( aArrayOri, nTam )
	ElseIf lTudo
		For _nA := 1 To len( aArrayOri )
			Aadd( aArrayDest, aClone( aArrayOri[_nA] ) )
		Next _nA
		aArrayOri := {}
	EndIf
	
	If !Empty( bBlocOri )
		aArrayOri := aSort( aArrayOri,,,bBlocOri )
	EndIf
	
	If !Empty( bBlocDes )
		aArrayDest := aSort( aArrayDest,,,bBlocDes )
	EndIf
	
	aEval( aArrayOri, 	{|x| aVar:=x, Aadd( aTmpOri, &(cAdd) )} )
	aEval( aArrayDest, 	{|z| aVar:=z, Aadd( aTmpDes, &(cAdd) )} )
	
	oListOri:aItems := aTmpOri
	oListDes:aItems := aTmpDes
	
	oListOri:nAt := If( Len(aTmpOri)<nPosOri, Len( aTmpOri ), nPosOri ) 
	oListDes:nAt := aScan( aTmpDes, cValOri )
	
	oListOri:Refresh()
	oListDes:Refresh()
EndIf	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WzConvQry ºAutor  ³Evaldo V. Batista   º Data ³  03/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera a Query da consulta                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function WzConvQry()
Local aCpoRel1	:= {}
Local aCpoRel2 := {}
Local cQuery 	:= ''
Local cCampos	:= 'SELECT '
Local cFrom		:= ' FROM '
Local cWhere	:= ' WHERE '
Local cGroupBy	:= ' GROUP BY '
Local cOrderBy	:= ' ORDER BY '
Local cAlias	:= 'CQRY'
Local cValor	:= ''
Local lCont		:= .T.

If U_WzMntPerg()
	// Campos do Select
	For _nA := 1 To Len( aQryFields )
		If (aQryFields[_nA, 9])
			cCampos += 'SUM( '
		EndIF
		cCampos += AllTrim( aQryFields[ _nA, 1 ] ) + '.' + AllTrim( aQryFields[ _nA, 3 ] )
	
		//GROUP BY
		If (aQryFields[_nA, 10]) .and. aQryFields[_nA, 4] <> 'N'
			cGroupBy += AllTrim( aQryFields[ _nA, 1 ] ) + '.' + AllTrim( aQryFields[ _nA, 3 ] ) + ", "
		EndIF
	
		If aQryFields[_nA, 4] <> 'N'
			cOrderBy += AllTrim( aQryFields[ _nA, 1 ] ) + '.' + AllTrim( aQryFields[ _nA, 3 ] ) + ", "
		EndIF
	
		If (aQryFields[_nA, 9])
			cCampos += ') AS '+AllTrim( aQryFields[ _nA, 3 ] )+', '
		Else
			cCampos += ', '
		EndIF
	Next _nA
	cCampos := Substr( cCampos, 1, Len( cCampos ) - 2 ) + Space(1) + Chr(13)
	cGroupBy := Substr( cGroupBy, 1, Len( cGroupBy ) - 2 ) + Space(1) + Chr(13)
	cOrderBy := Substr( cOrderBy, 1, Len( cOrderBy ) - 2 ) + Space(1) + Chr(13)
	
	nPosPri := aScan( aQryTabSel, {|x| x[5] } )
	If nPosPri > 0 
		cFrom += RetSqlName(AllTrim( aQryTabSel[ nPosPri, 1 ] )) + Space( 1 ) + AllTrim( aQryTabSel[ nPosPri, 1 ] ) + Space( 1 )  //+ ' WITH (NOLOCK)' 
		cWhere += AllTrim( aQryTabSel[ nPosPri, 1 ] ) + ".D_E_L_E_T_ <> '*' " + Chr(13)
	EndIf
	
	For _nA := 1 To Len( aQryPergs ) 
		If aQryPergs[_nA, 6] == 'C'
			cValor := "'"+&(aQryPergs[_nA, 10])+"'"
		ElseIf aQryPergs[_nA, 6] == 'N'
			cValor := AllTrim(Str( &(aQryPergs[_nA, 10]) ))
		ElseIf aQryPergs[_nA, 6] == 'D'
			cValor := "'" + DtoS( &(aQryPergs[_nA, 10]) ) + "'"
		EndIf
		cOperador := AllTrim( aQryPergs[_nA, 3] )
		If cOperador $ '=/<>/>/</>=/<='
			cWhere += ' 		AND ' + aQryPergs[_nA, 11 ] + '.' + aQryPergs[_nA, 1] + cOperador + cValor + Chr(13)
		ElseIf cOperador == '$'
			cValor := StrTran( cValor, "'", "" )
			cWhere += ' 		AND ' + aQryPergs[_nA, 11 ] + '.' + aQryPergs[_nA, 1] + " LIKE '%" + AllTrim( cValor ) + "%'" + Chr(13)
		ElseIf cOperador == '&'
			cValor := StrTran( cValor, ",", "','" )
			cWhere += ' 		AND ' + aQryPergs[_nA, 11 ] + '.' + aQryPergs[_nA, 1] + " IN  ('" + AllTrim( cValor ) + "')" + Chr(13)
		EndIf	
	Next _nA
	
	For _nA := 1 To len( aQryTabSel )
		If !aQryTabSel[_nA, 5]
			
			nPos := aScan( aQryTabRel, {|x| x[1] == aQryTabSel[_nA, 1]} )
			cFilInner := aQryTabSel[ aScan( aQryTabSel, {|x| x[1] == aQryTabRel[nPos, 2]} ), 4]

			cCpoRel1 := "'" + StrTran( aQryTabRel[nPos, 3], '+', "','" ) + "'" 
			cCpoRel2 := "'" + StrTran( aQryTabRel[nPos, 4], '+', "','" ) + "'" 
			aCpoRel1 := &( '{' + cCpoRel1 + '}' )
			aCpoRel2 := &( '{' + cCpoRel2 + '}' )
			
			If !( Len( aCpoRel1 ) == Len( aCpoRel2 ) ) 
				MsgAlert( 'Quantidade de Campos no relacionamento incompatíveis ', 'Numeros de campos incompatíveis ' ) 
			EndIf 

			//Controlar filial quando as tabelas relacionadas forem do mesmo tipo
			If nPos > 0
				cFrom += ' INNER JOIN ' + RetSqlName( AllTrim( aQryTabSel[ _nA, 1 ] ) )+ Space( 1 ) + AllTrim( aQryTabSel[ _nA, 1 ] ) //+ ' WITH (NOLOCK)' + Space( 1 )
				cFrom += ' ON ' // + aQryTabRel[nPos, 3] + ' = ' + aQryTabRel[nPos, 4] + Chr(13)

				For _nR := 1 To Len( aCpoRel1 ) 
					If _nR == 1
						cFrom += AllTrim( aQryTabRel[nPos, 1 ] ) + "." + AllTrim( aCpoRel1[_nR] ) + ' = ' + AllTrim( aQryTabRel[nPos, 2 ] ) + "." + AllTrim( aCpoRel2[_nR] ) 
					Else 
						cFrom += ' AND ' + AllTrim( aQryTabRel[nPos, 1 ] ) + "." + AllTrim( aCpoRel1[_nR] ) + ' = ' + AllTrim( aQryTabRel[nPos, 2 ] ) + "." + AllTrim( aCpoRel2[_nR] ) 
					EndIf
				Next _nR
				
				If cFilInner == aQryTabSel[_nA, 4]
					cFrom += " 		AND "+AllTrim( aQryTabRel[nPos, 1 ] )+"."+IF(Substr(AllTrim( aQryTabRel[nPos, 1 ] ),1,1)=="S",Substr(AllTrim( aQryTabRel[nPos, 1 ] ),2,2), AllTrim( aQryTabRel[nPos, 1 ] ) )+"_FILIAL = "
					cFrom += AllTrim( aQryTabRel[nPos, 2 ] )+"."+IF(Substr(AllTrim( aQryTabRel[nPos, 2 ] ),1,1)=="S",Substr(AllTrim( aQryTabRel[nPos, 2 ] ),2,2), AllTrim( aQryTabRel[nPos, 2 ] ) )+"_FILIAL " + Chr(13)
				EndIf
				cFrom += " 		AND " + AllTrim( aQryTabRel[nPos, 2 ] ) + ".D_E_L_E_T_ <> '*' " + Chr(13)
				cFrom += " 		AND " + AllTrim( aQryTabSel[ _nA, 1 ] ) + ".D_E_L_E_T_ <> '*' " + Chr(13)
			EndIf
	   EndIf
	Next _nA
	cQuery := cCampos + cFrom + cWhere + If( Len( cGroupBy ) > 10, cGroupBy, '' ) + If( Len( cOrderBy ) > 10, cOrderBy, '' )
	cQryExec := ChangeQuery( cQuery ) //+ ';' (Compilacao para Oracle)
	
	ErrorBlock({|e| lCont := .F., MsgAlert(e:description)})
	MsgRun( 'Executando a Consulta...', 'Aguarde...',{|| dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .T.) } )
	If lCont; AjusteCpo( cAlias ); EndIf
	If lCont; U_WzView(cAlias); EndIf
	If lCont; (cAlias)->( dbCloseArea() ); EndIf
	
EndIf
Return( lCont )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WzMntPerg ºAutor  ³Evaldo V. Batista   º Data ³  28/02/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava as perguntas no acols de selecao                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7.10                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function WzMntPerg()
Local aDbfStru := SX1->( dbStruct() ) 
Local cExpInd	:= SX1->( IndexKey() ) 
Local cArqTmp	:= CriaTrab( aDbfStru, .T. ) 
Local cIndTmp	:= CriaTrab( NIL, .F.)
Local lRet		:= .T.
Local lCont 	:= .T. 
ErrorBlock({|e| MsgAlert(e:description), lCont := .F.})

If Len( aQryPergs ) > 0
	SX1->( dbCloseArea() ) 
	dbUseArea( .T.,'DBFCDX', cArqTmp, 'SX1', .T., .F. )
	IndRegua("SX1",cIndTmp,cExpInd,,,'Preparando as perguntas, aquarde') 
	
	for _nA := 1 To Len( aQryPergs ) 
		RecLock( 'SX1', .T. )
		SX1->X1_GRUPO 		:= 'PERGUT'
		SX1->X1_ORDEM 		:= aQryPergs[_nA, 2]
		SX1->X1_PERGUNT 	:= aQryPergs[_nA, 4]
		SX1->X1_PERSPA	 	:= aQryPergs[_nA, 4]
		SX1->X1_PERENG	 	:= aQryPergs[_nA, 4]
		SX1->X1_VARIAVL		:= aQryPergs[_nA, 5]
		SX1->X1_TIPO		:= aQryPergs[_nA, 6]
		SX1->X1_TAMANHO		:= aQryPergs[_nA, 7]
		SX1->X1_DECIMAL		:= aQryPergs[_nA, 8]
		SX1->X1_GSC			:= aQryPergs[_nA, 9]
		SX1->X1_PRESEL		:= 0
		SX1->X1_VAR01		:= aQryPergs[_nA, 10]
		If Empty( aQryPergs[_nA, 12] )
			If aQryPergs[_nA, 6] == 'D'
				SX1->X1_CNT01 := "'  /  /  '"
			EndIf
		Else
			SX1->X1_CNT01 := aQryPergs[_nA, 12]
		EndIf
	   	SX1->( MsUnLock() ) 
	Next _nA
	
	lRet := Pergunte( 'PERGUT', .T. )
	For _nU := 1 To Len( aQryPergs )
		If aQryPergs[_nU, 6] == 'C'
			aQryPergs[ _nU, 12 ] := &( aQryPergs[_nU, 10] )
		ElseIf aQryPergs[_nU, 6] == 'D'
			aQryPergs[ _nU, 12 ] := "'" + DtoC( &( aQryPergs[_nU, 10] ) ) + "'" 
		ElseIf aQryPergs[_nU, 6] == 'N'
			aQryPergs[ _nU, 12 ] := Str( &( aQryPergs[_nU, 10] ) )
		ElseIf  aQryPergs[_nU, 6] == 'L'
			aQryPergs[ _nU, 12 ] := If(&( aQryPergs[_nU, 10] ), '.T.', '.F.' )
		EndIf
	Next _nU
	
	SX1->( dbCloseArea() ) 
	fErase( cArqTmp+'.DBF' )
	fErase( cIndTmp+OrdBagExt() )

/*	dbUseArea(.T.,"DBFCDX","SX1"+SM0->M0_CODIGO+"0","SX1", .F., .F. )
	dbSelectArea("SX1")
	Set Index To &("SX1"+SM0->M0_CODIGO+"0")*/

//	X31OpenSx( 'SX1' )
EndIf
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustCpo  ºAutor  ³Evaldo V. Batista   º Data ³  13/01/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta os Tipos de dados formados pela quary (somente tipos º±±
±±º          ³ Data e Numerica)                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7.10 / CtbProjet                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjusteCpo( cAlias ) 
Local aStru := (cAlias)->( dbStruct() ) 
SX3->( dbSetOrder( 2 ) ) 
For _nX := 1 To Len( aStru ) 
	If SX3->( dbSeek( aStru[_nX, 1] ) ) 
		If SX3->X3_TIPO <> 'C'
			TcSetField( cAlias, aStru[_nX, 1], SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL )
		EndIf
   EndIf
Next _nX
Return
