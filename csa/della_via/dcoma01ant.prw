#INCLUDE "RWMAKE.CH"

User Function DCOMA01


aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
{ "Alteração","u_mod3f1()", 0 , 4, 20 }}

SET FILTER TO SF1->F1_TIPO ==  "B" .OR. SD1->D1_TIPO == "B"

mBrowse(6,1,22,75,"SF1")

SET FILTER TO
Return


User function mod3f1

aCopia := Aclone(aRotina)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DBSELECTaREA("SF1")

cOpcao:="VISUALIZAR"
Do Case
	Case cOpcao=="INCLUIR"; nOpcE:=3 ; nOpcG:=3
	Case cOpcao=="ALTERAR"; nOpcE:=2 ; nOpcG:=3
	Case cOpcao=="VISUALIZAR"; nOpcE:=2 ; nOpcG:=2
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("SF1",(cOpcao=="INCLUIR"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado:=0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SD1")
aHeader:={}
While !Eof().And.(x3_arquivo=="SD1")
	If X3USO(x3_usado) .AND. (Alltrim(X3_CAMPO) == "D1_ITEM"    .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_SERVICO" .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_SERIEPN" .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_NUMFOGO" .OR. ;
                         	  Alltrim(X3_CAMPO) == "D1_MARCAPN" .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_CARCACA" .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_X_DESEN" .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_TOTAL"   .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_VUNIT"   .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_COD"     .OR. ;
                                  Alltrim(X3_CAMPO) == "D1_IDENTB6")
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,"AllwaysTrue()",;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	dbSkip()
End

If cOpcao=="INCLUIR"
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
Else
	aCols:={}
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial()+M->F1_DOC+M->F1_SERIE+M->F1_FORNECE+M->F1_LOJA)
	
	While !eof().and.SD1->D1_DOC==M->F1_DOC .AND. XFILIAL("SD1") == SD1->D1_FILIAL ;
		.AND. SD1->D1_FORNECE == M->F1_FORNECE .AND. M->F1_LOJA == SD1->D1_LOJA ;
		.AND. M->F1_SERIE == SD1->D1_SERIE
		AADD(aCols,Array(nUsado+1))		 
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
Endif
If Len(aCols)>0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Modelo 3                                           ³
	cTitulo:="Nota Fiscal de Entrada"
	cAliasEnchoice:="SF1"
	cAliasGetD:="SD1"
	cLinOk:="AllwaysTrue()"
	cTudOk:="AllwaysTrue()"
	cFieldOk:="AllwaysTrue()"
	aCpoEnchoice:={"F1_DOC","F1_SERIE"}
	
	//_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.F.,LEN(ACOLS))
	_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.F.,LEN(ACOLS))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executar processamento                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lRet
	
		For i:=1 to Len(acols)
			// Regrava somente os ativos
			If !( aCols[i,Len(aCols[i])] )
				_cdoc	:= M->F1_DOC
				_cSerie	:= M->F1_SERIE
				_cFornec:= M->F1_FORNECE
				_cLoja   	:= M->F1_LOJA
				_cCod  	:= aCols[ i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))=="D1_COD"}) ]
				_cItem   	:= aCols[ i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))=="D1_ITEM"}) ]
				cItemB6  :=  aCols[ i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))=="D1_IDENTB6"}) ]
				
				dbSelectArea("SD1")
				dbSetOrder(1)
				If dbSeek(xFilial("SD1")+_cdoc+_cSerie+_cFornec+_cLoja+_cCod+_cItem)	
					dbSelectArea("SX3")
					dbSetOrder(1)
					dbSeek("SD1")
					nTotal := 0
					WHILE !EOF() .AND. SX3->X3_ARQUIVO == "SD1"
						IF SX3->X3_CONTEXT <> "V"
							IF aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)}) > 0
								dbSelectArea("SD1")
								Reclock("SD1",.F.)
									&(SX3->X3_CAMPO) := aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]							
								Msunlock()
								IF Alltrim(SX3->X3_CAMPO) == "D1_TOTAL"
									nTotal += aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]
								EndIF
								dbSelectArea("SC2")
								SC2->( dbSetOrder(1) )
								IF SC2->( dbSeek (xFilial("SC2") + _cdoc +Substr(_cItem,3,2) + '001' ) )
									IF Alltrim(SX3->X3_CAMPO) $ "D1_SERIEPN/D1_NUMFOGO/D1_X_DESEN/D1_CARCACA/D1_SERVICO'
										RecLock("SC2")
											IF Alltrim(SX3->X3_CAMPO) == "D1_SERIEPN"
												SC2->C2_SERIEPN     :=  aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]	
											ElseIF	Alltrim(SX3->X3_CAMPO) == "D1_NUMFOGO"
												SC2->C2_NUMFOGO :=  aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]	
											ElseIF	Alltrim(SX3->X3_CAMPO) == "D1_X_DESEN"	
												SC2->C2_X_DESEN   := aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]	
											ElseIF	Alltrim(SX3->X3_CAMPO) == "D1_CARCACA"		
												SC2->C2_CARCACA := aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]	
											ElseIF Alltrim(SX3->X3_CAMPO) == "D1_SERVICO"
												SC2->C2_SERVPCP  := aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]	
											EndIF	
										MsUnlock()
									Endif		
									EndIF
								dbSelectArea("SB6")	
								SB6->( dbSetOrder(1) )
								IF SB6->( dbSeek (xFilial("SB6") + _cCod +_cFornec+_cLoja + cItemB6 )  )
									RecLock("SB6")
										IF Alltrim(SX3->X3_CAMPO) $ "D1_VUNIT'
											SB6->B6_PRUNIT := aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]	
										ElseIF Alltrim(SX3->X3_CAMPO) $  'D1_QUANT'
											SB6->B6_QUANT := aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]	
										EndIF
									MsUnlock()
								EndIF								
							EndIF
						Endif
						
						dbSelectArea("SX3")
						dbSkip()
						
					EndDo
					SF3->( dbSetOrder(6) )
					IF SF3->( dbSeek(xFilial("SF3") + _cdoc+_cSerie ) )
						RecLock("SF3")
							SF3->F3_VALCONT := nTotal
						MsUnlock()
					SF1->( dbSetOrder(1) )
					IF SF1->( dbSeek(xFilial("SF1") + _cdoc+_cSerie+_cFornec+_cLoja ) )
						RecLock("SF1")
							SF1->F1_VALMERC := nTotal
							SF1->F1_VALBRUT  := nTotal
						MsUnlock()
					EndIF
					
					EndIF
				Endif
			Endif
		Next i
	
	Endif
Endif

Return
