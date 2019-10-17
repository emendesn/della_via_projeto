/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFINA12  ³ Autor ³ Rogerio Leite         ³ Data ³ 02/12/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Filtro e Markbrowse da Baixa Automatica Ctas a Receber     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Invocado por RFINm01                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Conibra                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salvando Integridade                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cAlias  := Alias()
_cOrder  := IndexOrd()
_aRotAnt := aRotina
aRotina  := {}
_lProc   := .F.
nLastKey := 0
*
*
cCliDe     := CriaVar("E1_CLIENTE")
cCliAte    := CriaVar("E1_CLIENTE");cCliAte:=Replicate("Z",Len(cCliAte))
cLojDe     := CriaVar("E1_LOJA")
cLojAte    := CriaVar("E1_LOJA");cLojAte:=Replicate("Z",Len(cLojAte))
cPrefDe    := CriaVar("E1_PREFIXO")
cPrefAte   := CriaVar("E1_PREFIXO");cPrefAte:=Replicate("Z",Len(cPrefAte))
cNatDe     := CriaVar("E1_NATUREZ")
cNatAte    := CriaVar("E1_NATUREZ");cNatAte:=Replicate("Z",Len(cNatAte))
cTipo      := CriaVar("E1_TIPO")
dDtVencDe  := CriaVar("E1_VENCREA")
dDtVencAte := CriaVar("E1_VENCREA")
dDtEmisDe  := CriaVar("E1_EMISSAO")//fabio
dDtEmisAte := CriaVar("E1_EMISSAO")//fabio
cBanco     := CriaVar("A6_COD")
cAgencia   := CriaVar("A6_AGENCIA")
cConta     := CriaVar("A6_NUMCON")
cHist070   := CriaVar("E5_HISTOR")
cMotbx     := CriaVar("E5_MOTBX");cMotbx:="NOR" //rodrigo
nAtual     := 0
nProximo   := 0
cTitulo    := "Baixa Automatica a Receber"
cDigita    := Space(1)
cAglut     := Space(1)
nC         := 0
nValor     := 0
nTotal     := 0

aRotina := { { "Pequisar"  , "AxPesqui" , 0 , 1} ,;
{ "Visualizar", "AxVisual" , 0 , 2}}
//{ "Visualizar", "AxVisual" , 0 , 2},;
//{ "Baixar Titulos", 'ExecBlock("RFINA13",.F.,.F.,2)' , 0 , 2}}

LoteCont( "FIN" )
dbSelectArea("SE1")
dbSetOrder(1)
nOpcDsd := 0
//@ 0,0   To 345,380 DIALOG oDlg  TITLE cTitulo
@ 0,0   To 385,380 DIALOG oDlg  TITLE cTitulo       //fabio
@ 010, 014 SAY "Cliente De"           SIZE 30, 7
@ 020, 014 SAY "Cliente Ate"          SIZE 30, 7
@ 030, 014 SAY "Loja De"              SIZE 20, 7
@ 040, 014 SAY "Loja Ate"             SIZE 20, 7
@ 050, 014 SAY "Prefixo De"           SIZE 20, 7
@ 060, 014 SAY "Prefixo Ate"          SIZE 20, 7
@ 070, 014 SAY "Tipo"                 SIZE 20, 7
@ 080, 014 SAY "Natureza De"          SIZE 40, 7
@ 090, 014 SAY "Natureza Ate"         SIZE 40, 7
@ 100, 014 SAY "Dt. Vencto. De"       SIZE 90, 7
@ 110, 014 SAY "Dt. Vencto. Ate"      SIZE 90, 7     
@ 120, 014 SAY "Dt. Emissao. De"      SIZE 90, 7//FABIO
@ 130, 014 SAY "Dt. Emissao. Ate"     SIZE 90, 7//FABIO
@ 140, 014 SAY "Motivo Baixa"         SIZE 20, 7 //rodrigo
@ 150, 014 SAY "Banco"                SIZE 30, 7
@ 160, 014 SAY "Agencia"              SIZE 30, 7
@ 170, 014 SAY "Conta"                SIZE 30, 7
@ 180, 014 SAY "His.Baixa"            SIZE 30, 7
//@ 140, 014 SAY "Mostra L.Contabil"    SIZE 10, 7
//@ 150, 014 SAY "Aglutina L.Contabil"  SIZE 10, 7
*
@ 010, 64 GET cCLiDe    F3 "CLI"      SIZE 16, 08
@ 020, 64 GET cCliAte   F3 "CLI"      SIZE 16, 08
@ 030, 64 GET cLojDe                  SIZE 10, 08
@ 040, 64 GET cLojAte                 SIZE 10, 08
@ 050, 64 GET cPrefDe   Picture "!!!" SIZE 15, 08
@ 060, 64 GET cPrefAte  Picture "!!!" SIZE 15, 08
@ 070, 64 GET cTipo                   SIZE 15, 08
@ 080, 64 GET cNatDe    F3 "SED"      SIZE 30, 08
@ 090, 64 GET cNatAte   F3 "SED"      SIZE 30, 08
@ 100, 64 GET dDtVencDe   Valid !Empty(dDtVencDe)                        SIZE 28,08
@ 110, 64 GET dDtVencAte  Valid dDtVencAte >= dDtVencDe                  SIZE 28,08
@ 120, 64 GET dDtEmisDe   Valid !Empty(dDtEmisDe)                        SIZE 28,08//fabio
@ 130, 64 GET dDtEmisAte  Valid dDtEmisAte >= dDtEmisDe                  SIZE 28,08//fabio
@ 140, 64 GET cMotbx      Valid !Empty(cMotbx)                           SIZE 15,08 //rodrigo
@ 150, 64 GET cBanco    F3 "SA6" Valid CarregaSa6(@cBanco,,,.T.)         SIZE 10,08
@ 160, 64 GET cAgencia  Valid CarregaSa6(@cBanco,@cAgencia,,.T.)         SIZE 35,08
@ 170, 64 GET cConta    Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.T.)  SIZE 35,08
@ 180, 64 GET cHist070                                                   SIZE 70,08

//@ 160, 64 GET cDigita                 SIZE 08, 08
//@ 170, 64 GET cAglut                  SIZE 08, 08
//@ 004,007 TO 162, 145 OF oDlg PIXEL
@ 07,150 BMPBUTTON TYPE 1 ACTION Execute(Baixa_Rec)
@ 23,150 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

aRotina :=_aRotAnt

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FUNCFIM  ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 20/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Videolar                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FuncFim

dbSelectArea("SE1")
RetIndex("SE1")
dbSetOrder(1)
dbGotop()

dbSelectArea(_cAlias)
dbSetOrder(_cOrder)
aRotina := _aRotAnt
SetCursor(0)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CHKOPC   ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 11/05/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa a Exclusao do Bordero.                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function ChkOpc

Close(oDlg1)
nOpca:=1

Return



Function Baixa_Rec

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria indice condicional sem filial                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If      cMotbx  $ "DAC/DNI"
        cBanco  :=" "
        cAgencia:=" "
        cConta  :=" "
EndIf

dbSelectArea ("SE1")
dbSetOrder(1)
cIndex := CriaTrab(nil,.f.)
cChave   := IndexKey()
cFiltro := 'E1_CLIENTE>="'+cCliDe+'".And.'
cFiltro := cFiltro + 'E1_CLIENTE<="'+cCliAte+'".And.'
cFiltro := cFiltro + 'E1_LOJA>="'+cLojDe+'".And.'
cFiltro := cFiltro + 'E1_LOJA<="'+cLojAte+'".And.'
cFiltro := cFiltro + 'E1_PREFIXO>="'+cPrefDe+'".And.'
cFiltro := cFiltro + 'E1_PREFIXO<="'+cPrefAte+'".And.'
cFiltro := cFiltro + 'E1_NATUREZ>="'+cNatDe+'".And.'
cFiltro := cFiltro + 'E1_NATUREZ<="'+cNatAte+'".And.'
cFiltro := cFiltro + 'E1_SALDO>0.And.'
cFiltro := cFiltro + 'DTOS(E1_VENCREA)>="'+Dtos(dDtVencDe)+'".And.'
cFiltro := cFiltro + 'DTOS(E1_VENCREA)<="'+Dtos(dDtVencAte)+'".And.'
cFiltro := cFiltro + 'DTOS(E1_EMISSAO)>="'+Dtos(dDtEmisDe)+'".And.' //fabio
cFiltro := cFiltro + 'DTOS(E1_EMISSAO)<="'+Dtos(dDtEmisAte)+'".And.'//fabio
cFiltro := cFiltro + 'E1_TIPO=="'+cTipo+'"'
IndRegua("SE1",cIndex,cChave,,cFiltro,"Selecionando Registros...")
nIndex := RetIndex("SE1")
dbSelectArea("SE1")
//#IFNDEF TOP
//   dbSetIndex(cIndex+OrdBagExt())
//#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()
If BOF() .and. EOF()
	Help(" ",1,"RECNO")
	Return
EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cMarca := GetMark()
dbSelectArea("SE1")
dbGoTop()
//MarkBrow("SE1","E1_OK","E1_SALDO==0",,.F.,@cMarca)
cUsado :=   "€€€€€€‚"
aCampos:={}
Aadd(aCampos,{"E1_OK"      ,""," "})
Aadd(aCampos,{"E1_PREFIXO" ,"","Prefixo"})
Aadd(aCampos,{"E1_NUM"     ,"","Titulo"})
Aadd(aCampos,{"E1_PARCELA" ,"","Parcela"})
Aadd(aCampos,{"E1_TIPO"    ,"","Tipo"})
Aadd(aCampos,{"E1_VALOR"   ,"","Valor"})
Aadd(aCampos,{"E1_EMISSAO" ,"","Emissao"})
Aadd(aCampos,{"E1_VENCREA" ,"","Vencto"})
Aadd(aCampos,{"E1_CLIENTE" ,"","Cliente"})
Aadd(aCampos,{"E1_LOJA"    ,"","Loja"})
Aadd(aCampos,{"E1_NATUREZA","","Natureza"})
cMsg := "Valor Total Selecionado:"
cMarcaE1 := GetMark()
lInverteE1 := .F.
//aCoordIn:={30,1,155,290}
//aCoordExt:={0,10,13,67}
nValTit := 0.00
aRegtoSE1 := {}
aStru := {}
AADD(aStru, { "REGTOSE1"    , "C", 10, 0 })  && Numero Registro
cArqTrab := CriaTrab(aStru, .T.)
If Select("TSE1") > 0
	dbSelectArea("TSE1")
	dbCloseArea("TSE1")
Endif
dbUseArea(.T.,,cArqTrab,"TSE1",.F.,.F.)
Index On REGTOSE1 TO &cArqTrab
dbSelectArea("SE1")
//nConfirmo:=RdSelect("SE1","E1_OK",,aCampos,cTitulo,cMsg,,cMarcaE1,lInverteE1,aCoordIn,aCoordExt,"TESTE")
CursorWait()
dbGoTop()
While SE1->(!Eof()) 
	ExecBlock("RFINASM",.F.,.F.)	
	SE1->(dbSkip()) 
End   
dbGoTop()
Cursorarrow()

nConfirmo:=RdSelect("SE1","E1_OK",,aCampos,cTitulo,cMsg,,cMarcaE1,lInverteE1,,,"RFINASM")
If nConfirmo == 1
	//ExecBlock("RFINA13",.F.,.F.)
	Processa({|| Execute(Baixa_Tit)} )
Endi
//MarkBrow("SE1","E1_OK","E1_SALDO==0",,.F.,@cMarca)
Close(oDlg)
aRotina := _aRotAnt
dbSelectArea("TSE1")
dbCloseArea("TSE1")
aRotina := _aRotAnt
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
Set Filter to
RetIndex("SE1")
dbSetOrder( 1 )
dbSeek(xFilial())
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Baixa_Tit³ Autor ³ Rogerio Leite         ³ Data ³ 22/12/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa a Baixa dos Titulos a Receber                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Baixa_Tit
//  BEGIN TRANSACTION
dbSelectArea("SE1")
ProcRegua(RecCount())
dbGotop()
lContabil := .F.
While !Eof()
	IncProc()
	If SE1->E1_OK <> cMarcaE1
		dbSkip()
		Loop
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Cadastro de Naturezas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SED")
	dbSetOrder(1)
	dbSeek(xFilial("SED")+SE1->E1_NATUREZ)
	*
	nTotAbat  := 0
	nTotAbat  := SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDataBase)
	*
	dbSelectArea("SE1")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza a Baixa do Titulo               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("SE1",.F.)
	SE1->E1_VALLIQ    := SE1->E1_SALDO - nTotAbat
	SE1->E1_SALDO     := 0
	SE1->E1_BAIXA     := dDataBase
        SE1->E1_MOVIMEN   := dDataBase
        SE1->E1_STATUS    := Iif(E1_SALDO>0.01,"A","B")
	MsUnlock()
	*
	//nRegtoSE1 := SE1->(Recno())
	*
	cPrefixo := E1_PREFIXO
	cNum     := E1_NUM
	cParcela := E1_PARCELA
	cCliente := E1_CLIENTE+E1_LOJA
	*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Baixa Títulos de Abatimentos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If Select("__SE1") == 0
		SumAbatRec("","","",1,"")
	Endif
	dbSelectArea("__SE1")
	__SE1->(dbSetOrder(1))
	__SE1->(dbSeek(xFilial("SE1")+cPrefixo+cNum+cParcela))
	While !EOF() .And. E1_FILIAL==xFilial("SE1") .And. E1_PREFIXO=cPrefixo .And. ;
		E1_NUM==cNum .And. E1_PARCELA==cParcela .And. (E1_CLIENTE+E1_LOJA == cCliente)
		IF Substr(E1_TIPO,3,1) == "-"
			RecLock("__SE1",.F.)
			REPLACE E1_SALDO  WITH 0.00
			REPLACE E1_BAIXA  WITH dDataBase
			//  Replace E1_LOTE   With cLoteFin
			REPLACE E1_MOVIMEN WITH dDataBase
			REPLACE E1_STATUS  WITH "B"
		EndIF
		dbSkip()
	Enddo
	*
	dbSelectArea("SE1")
	//dbGoTo(nRegtoSE1)
	//dbSetOrder(nIndex+1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Para numerar as sequencias o sistema precisa procurar os   ³
	//³ registros com  tipodoc igual a VL, BA ou CP.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTipoSeq := {"CP","BA","VL","V2","LJ"}
	nSequencia := 0
	dbSelectArea("SE5")
	SE5->(dbSetOrder(2))
	For nX := 1 to len(aTipoSeq)
		SE5->(dbSeek(xFilial("SE5") + aTipoSeq[nX] + SE1->E1_PREFIXO + SE1->E1_NUM + ;
		SE1->E1_PARCELA + SE1->E1_TIPO) )
		While !SE5->(Eof()) .And. SE5->E5_FILIAL == xFilial("SE5")  .And. ;
			SE5->E5_TIPODOC == aTipoSeq[nX]    .And. ;
			SE5->E5_PREFIXO == SE1->E1_PREFIXO .And. ;
			SE5->E5_NUMERO == SE1->E1_NUM    .And. ;
			SE5->E5_PARCELA == SE1->E1_PARCELA .And. ;
			SE5->E5_TIPO   == SE1->E1_TIPO
			nSequencia := MAX(VAL(SE5->E5_SEQ),nSequencia)
			SE5->( dbSkip() )
		Enddo
	Next
	nSequencia := nSequencia + 1
	MsUnlock()
	*
	Reclock("SE5",.T.)
	SE5->E5_FILIAL    := xFilial("SE5")
	SE5->E5_PREFIXO   := SE1->E1_PREFIXO
	SE5->E5_NUMERO    := SE1->E1_NUM
	SE5->E5_PARCELA   := SE1->E1_PARCELA
	SE5->E5_CLIFOR    := SE1->E1_CLIENTE
	SE5->E5_LOJA      := SE1->E1_LOJA
	SE5->E5_BENEF     := SE1->E1_NOMCLI
	SE5->E5_VALOR     := SE1->E1_VALLIQ
	SE5->E5_SEQ       := StrZero(nSequencia,2,0)
	SE5->E5_DATA      := SE1->E1_BAIXA
	SE5->E5_HISTOR    := cHist070        //Cria?Var("E5_HIST")  "Valor recebido s /Titulo"
	SE5->E5_NATUREZ   := SE1->E1_NATUREZ
	SE5->E5_RECPAG    := "R"
	SE5->E5_TIPO      := SE1->E1_TIPO
	SE5->E5_DOCUMEN   := SE1->E1_NUMBOR
	SE5->E5_DTDIGIT   := dDataBase
	SE5->E5_TIPODOC   := "VL"
	SE5->E5_DTDIGIT   := dDataBase
        SE5->E5_MOTBX     := cMotbx //rodrigo
	SE5->E5_VLMOED2   := xMoeda(SE1->E1_VALLIQ,1,SE1->E1_MOEDA,SE1->E1_BAIXA)
	SE5->E5_DTDISPO   := E5_DATA
	SE5->E5_BANCO     := cBanco
	SE5->E5_AGENCIA   := cAgencia
	SE5->E5_CONTA     := cConta
	MsUnlock()
	If !(SE1->E1_SITUACA $ "27")
		AtuSalBco(cBanco,cAgencia,cConta,SE5->E5_DATA,SE5->E5_VALOR,"+")
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o Cadastro de CLIENTES     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1")
	If dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
		RecLock("SA1")
		If SE1->E1_SALDO >= SA1->A1_SALDUP
			nSalDup := 0
		Else
			nSalDup := SA1->A1_SALDUP - SE1->E1_SALDO
		Endif
		SA1->A1_SALDUP := nSalDup
		SA1->A1_SALDUPM := A1_SALDUPM -  xMoeda( SE1->E1_SALDO   ,;
		SE1->E1_MOEDA           ,;
		Val(GetMv("MV_MCUSTO")) ,;
		SE1->E1_EMISSAO      )
		MsUnlock()
	Endif
	
	If lContabil
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica qual o Lanc Padrao que sera utilizado    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		nC:=nC+1
		ABATIMENTO := 0
		VALOR := 0
		cPadrao := fA070Pad()
		lPadrao := VerPadrao( cPadrao )
		IF nC == 1 .And. lPadrao
			nHdlPrv:=HeadProva(cLote,"FINA070",Substr(cUsuario,7,6),@cArquivo)
		Endif
		IF lPadrao
			Reclock("SE5")
			nTotal      := nTotal + DetProva(nHdlPrv, cPadrao,"FINA070",cLote )
			If nTotal > 0
				SE5-> E5_LA := "S"+Substr(E5_LA,2,1)
			Endif
			MsUnlock()
		Endif
	Endif
	dbSelectArea("SE1")
	dbSkip()
Enddo
If lContabil
	If nC > 0 .and. lPadrao
		RodaProva(nHdlPrv,nTotal)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lan‡amento Cont bil, se gerado arquivo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lDigita:=IIF(!Empty(cDigita),.T.,.F.)
	lAglut :=IIF(!Empty(cAglut),.T.,.F.)
	IF nC > 0 .And. lPadrao
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
		FCLOSE(nHdlPrv)
	Endif
	//  END TRANSACTION
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
Set Filter to
RetIndex("SE1")
dbSetOrder( 1 )
dbSeek(xFilial())
Return


