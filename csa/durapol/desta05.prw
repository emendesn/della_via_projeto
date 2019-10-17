/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESTA05   ºAutor  ³Reinaldo Caldas     º Data ³  11/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Durapol                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DESTA05(nOpc)      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

nOpcx:=nOpc
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTitulo:="Apontamento Servico"

aC:={}
aR:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3->(dbSetOrder(1))
aHeader:={}
SX3->(dbSeek("SZF"))
do while SX3->(!eof() .and. X3_ARQUIVO = "SZF")
	if x3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. !AllTrim(SX3->X3_CAMPO)$"ZF_NUMOP"
		SX3->(aAdd(aHeader,{	AllTrim(X3_TITULO), X3_CAMPO, X3_PICTURE,;
								X3_TAMANHO, X3_DECIMAL,X3_VLDUSER,;
								X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } ))

	else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if AllTrim(SX3->X3_CAMPO)="ZF_NUMOP"
			cOP 	:= Space(13)
			aAdd(aC,{"cOP",{13,10},Alltrim(SX3->X3_TITULO),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_F3,.T.})
		endif

	endif
	SX3->(dbSkip())
enddo

nUsado := Len(aHeader)
aCols  := {}

IF nOpcX = 3
	Aadd(Acols,Array(nUsado+1))
	For nX := 1 To nUsado
		Acols[Len(Acols)][nX] := CriaVar(aHeader[nX,2],.T.)
	Next nX
	Acols[Len(Acols)][nUsado+1] := .F.	
Else
	cOP     := SZF->ZF_NUMOP
	_cQuery := "SELECT ZF_NUMOP, ZF_PRODSRV, ZF_QUANT, R_E_C_N_O_ REGISTRO "
	_cQuery += "FROM "+RetSqlName("SZF")+" WHERE ZF_FILIAL = '"+xFilial("SZF")+"' AND ZF_NUMOP = '"+cOP+"' AND D_E_L_E_T_= '' "

	if Select( "TRB" )>0
		dbSelectArea("TRB") 
		dbCloseArea()
	Endif
	
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"TRB", .F., .T.)
	dbSelectArea("TRB")
	dbGoTop()

	aCols := {}
	aRecno:= {}
	
	do while !eof()
	
		aAdd(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next 
		aCols[Len(aCols),nUsado+1]:=.F.
		aAdd(aRecno,REGISTRO)
		dbSkip()

	enddo

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com coordenadas da GetDados no modelo2                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCGD:={44,5,118,315}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLinhaOk:= "U_Fa13LOk()"
cTudoOk := "U_Fa13TOk()"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZF")

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

If lRetMod2
	
	IF nOpcx == 3
	
		for _i := 1 to Len(aCols)
			
			if !aCols[_i,Len(aHeader)+1]	// Considerar somente vetores nao excluidos
								
				RecLock("SZF",.T.)
					SZF->ZF_FILIAL	:= xFilial("SZF")
					SZF->ZF_NUMOP   := cOP
				  	For _k:=1 to Len(aHeader)
				    	FieldPut(FieldPos(aHeader[_k,2]),aCols[_i,_k])
					Next
				MsUnlock()
					
			endif
				
		next
		
	ElseIF nOpcX = 4	
	
		// Aproveitando os registros ja gravados
		for _i := 1 to Len(aRecno)
		
			dbGoTo(aRecno[_i])
			RecLock("SZF",.F.)
			
			if !aCols[_i,Len(aHeader)+1]	// Considerar somente vetores nao excluidos
			  	For _k := 1 to Len(aHeader)
			  		FieldPut(FieldPos(aHeader[_k,2]),aCols[_i,_k])
				Next
			else
				dbDelete()
			endif
			MsUnlock()
			
		next
		
		// No caso de terem sido incluidos novos registros
		for _i := Len(aRecno) + 1 to Len(aCols)
			
			if !aCols[_i,Len(aHeader)+1]	// Considerar somente vetores nao excluidos
				
				RecLock("SZF",.T.)
				SZF->ZF_FILIAL	:= xFilial("SZF")
				SZF->ZF_NUMOP   := cOP
			  	For _k := 1 to Len(aHeader)
				  	FieldPut(FieldPos(aHeader[_k,2]),aCols[_i,_k])
				Next
				MsUnlock()
			
			endif
		
		next
	
	ElseIF nOpcX = 5
	

		for _i := 1 to Len(aRecno)
			dbGoTo(aRecno[_i])
			RecLock("SZF",.F.)
			dbDelete()
			MsUnlock()
		next
	
	EndIF	
	
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DFata13LOk³ Autor ³                       ³ Data ³ 09/05/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Validacao da linha Ok                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa13LOk()

Local aArea     := GetArea()
Local lRetorno  := .T.
Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="ZF_PRODSRV"})
Local nPFaixa   := aScan(aHeader,{|x| AllTrim(x[2])=="ZF_QUANT"})
Local nUsado    := Len(aHeader)
Local nX        := 0
Local lExistCpo := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica os campos obrigatorios                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Acols[n][nUsado+1]
	Do Case
	Case Empty(Acols[n][nPProd]).Or. Empty(Acols[n][nPFaixa])
		lRetorno := .F.
		Help(" ",1,"OBRIGAT",,RetTitle("ZF_PRODSRV")+","+RetTitle("ZF_QUANT"),4)
	EndCase
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se nao ha valores duplicados                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno
		If !Empty(Acols[n][nPProd]) .And. !Empty(Acols[n][nPProd])
			For nX := 1 To Len(Acols)
				If nX <> N .And. !Acols[nX][nUsado+1]
					If ( Acols[nX][nPProd]==Acols[N][nPProd] )
						lRetorno := .F.
						Help(" ",1,"JAGRAVADO")
					EndIf
				EndIf
			Next nX
		EndIf
	EndIF	
EndIf
RestArea(aArea)
Return(lRetorno)

User Function Fa13TOk()
Local _lRet := .T.
if Empty(cOp) .or. Len(Alltrim(cOP)) < 11
	Help("",1,"OBRIGAT")
	_lRet := .F.
endif
Return(_lRet)

