#INCLUDE "GPER340.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER001  ³ Autor ³ R.H. - Marcos Stiefano³ Data ³ 15.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Cargos e Salarios                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER340(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                     ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Mauro      ³12/01/01³------³ Nao estava Filtrando categoria na Impress³±±
±±³ Silvia     ³04/03/02³------³ Ajustes na Picture para Localizacoes    .³±±
±±³ Natie      ³05/09/02³------³ Acerto devido mudanca C.custo c/tam 20   ³±±
±±³ Emerson    ³16/10/02³------³ Somente quebrar C.C. se nao quebrou Fil. ³±±
±±³ Mauro      ³13/11/02³060517³ Saltar Pagina a cada Quebra de Filial    ³±±
±±³ Silvia     ³11/09/03³065152³ Inclusao de Query                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GPER001()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString := "SRA"        // alias do arquivo principal (Base)
Local aOrd    := {STR0001,STR0002,OemtoAnsi(STR0003)}    //"C.Custo + Matricula "###"C.Custo + Nome"###"C.Custo + Fun‡„o"###"Nome"###"Matricula"###"Fun‡„o"
Local cDesc1  := STR0004		//"Rela‡„o de Cargos e Salario."
Local cDesc2  := STR0005		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0006		//"usuario."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0007,1,STR0008,2,2,1,"",1 }	//"Zebrado"###"Administra‡„o"
Private NomeProg := "GPER001"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    := "GPER01"
aRegs := {}
Aadd(aRegs,{cPerg,"01","Filial De  ?","","","mv_cha","C",002,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Filial ate ?","","","mv_chb","C",002,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","C.Custo De  ?","","","mv_chc","C",009,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","C.Custo De ?","","","mv_chd","C",009,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Matricula De  ?","","","mv_che","C",006,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Matricula ate ?","","","mv_chf","C",006,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Nome De  ?","","","mv_chg","C",030,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Nome ate ?","","","mv_chh","C",030,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Funcao de  ?","","","mv_chi","C",005,0,0,"G","","mv_par09","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Funcao ate ?","","","mv_chj","C",005,0,0,"G","","mv_par10","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Situacoes     "," " ," ","mv_chk","C",5,0,0,"G","fSituacao","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Categorias     "," " ," ","mv_chl","C",12,0,0,"G","fCategoria","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"13","C.C. outra Pag. ?","","","mv_chm","N",001,0,0,"C","","mv_par13","Sim","","","","","Nao","","","","","","","","",""})
Aadd(aRegs,{cPerg,"14","Imprimir Salario ?","","","mv_chn","N",001,0,0,"C","","mv_par14","Sim","","","","","Nao","","","","","","","","",""})

ValidPerg(aRegs,cPerg)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo   := STR0009		//"RELA€O DE CARGOS E SALARIOS"
Private AT_PRG   := "GPER001"
Private Wcabec0  := 2
Private Wcabec1  := "FI  MATRIC NOME                           ADMISSAO   FUNCAO                         SALARIO   "
Private Wcabec2  := "                                                                                    NOMINAL  "
Private CONTFL   := 1
Private LI		  := 0
Private nTamanho := "M"
Private cPict1	:=	If (MsDecimais(1)==2,"@E 999,999,999,999.99",TM(999999999999,18,MsDecimais(1)))  // "@E 999,999,999,999.99
Private cPict2	:=	If (MsDecimais(1)==2,"@E 999,999,999.99",TM(999999999,14,MsDecimais(1)))  // "@E 999,999,999.99

//FI C.CUSTO	MATRIC NOME             				  ADMISSAO FUNCAO 						 MAO DE		  SALARIO	PERC.   PERC.	 PERC."
// 																												 OBRA 		  NOMINAL  C.CUSTO  FILIAL  EMPRESA"
//01 123456789 123456 123456789012345678901234567890 01/01/01 1234 12345678901234567890  IND   99.999.999,99	999,99  999,99   999,99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER001"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| GP340Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GP340IMP ³ Autor ³ R.H.                  ³ Data ³ 15.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ImpressÆo da Relacao de Cargos e Salarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GP340IMP(lEnd,WnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GP340IMP(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSalario   := nSalMes := nSalDia := nSalHora := 0
Local aTFIL 	 := {}
Local aTCC       := {}
Local aTFILF	 := {}
Local aTCCF 	 := {}
Local TOTCC      := 0 //Alterado o Tipo de Array para Numerico
Local TOTCCF     := 0 //Alterado o Tipo de Array para Numerico
Local TOTFIL     := 0 //Alterado o Tipo de Array para Numerico
Local TOTFILF    := 0 //Alterado o Tipo de Array para Numerico
Local cAcessaSRA := &("{ || " + ChkRH("U_GPER01","SRA","2") + "}")
Local aStruSRA                                          
Local cAliasSRA := "SRA" 	//Alias da Query
Local nS
Local nX
Local X
Local W

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aInfo     := {}
Private aCodFol   := {}
Private aRoteiro  := {}
Private lQuery

Pergunte("GPER01",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem	    := aReturn[8]
cFilDe	    := mv_par01									//  Filial De
cFilAte	    := mv_par02									//  Filial Ate
cCcDe 	    := mv_par03									//  Centro de Custo De
cCcAte	    := mv_par04									//  Centro de Custo Ate
cMatDe	    := mv_par05									//  Matricula De
cMatAte	    := mv_par06									//  Matricula Ate
cNomeDe	    := mv_par07									//  Nome De
cNomeAte    := mv_par08									//  Nome Ate
cFuncDe	    := mv_par09									//  Funcao De
cFuncAte    := mv_par10									//  Funcao Ate
cSituacao   := mv_par11									//  Situacao Funcionario
cCategoria  := mv_par12									//  Categoria Funcionario
lSalta	    := If( mv_par13 == 1 , .T. , .F. )		//  Salta Pagina Quebra C.Custo
nQualSal    := 1 									//  Sobre Salario Mes ou Hora
nBase       := mv_par14                                                                      //  Sobre Salario Composto Base
lImpTFilEmp := .T. //  Imprime Total Filial/Empresa

//-- Modifica variaveis para a Query
cSitQuery := ""
For nS:=1 to Len(cSituacao)
	cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
	If ( nS+1) <= Len(cSituacao)
		cSitQuery += "," 
	Endif
Next nS
cCatQuery := ""
For nS:=1 to Len(cCategoria)
	cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
	If ( nS+1) <= Len(cCategoria)
		cCatQuery += "," 
	Endif
Next nS
Titulo := STR0012			//"RELACAO DE CARGOS E SALARIOS "
If nOrdem==1
	Titulo += STR0013		//"(C.CUSTO + MATRICULA)"
ElseIf nOrdem==2
	Titulo +=STR0014		//"(C.CUSTO + NOME)"
ElseIf nOrdem==3 
	Titulo +=STR0015		//"(C.CUSTO + FUNCAO)"
EndIf		

aCampos := {}
AADD(aCampos,{"FILIAL"   ,"C",02,0})
AADD(aCampos,{"MAT"      ,"C",06,0})
AADD(aCampos,{"CC"       ,"C",10,0})
AADD(aCampos,{"SALMES"   ,"N",12,2})
AADD(aCampos,{"SALHORA"  ,"N",12,2})
AADD(aCampos,{"CODFUNC"  ,"C",05,0})
AADD(aCampos,{"NOME"     ,"C",30,0})
AADD(aCampos,{"ADMISSA"  ,"D",08,0})

cNomArqA:=CriaTrab(aCampos)
dbUseArea( .T., __cRDDNTTS, cNomArqA, "TRA", if(.F. .Or. .F., !.F., NIL), .F. )
// Sempre na ordem de Centro de Custo + Matricula para totalizar
dbSelectArea( "SRA" )
lQuery	:=	.F.

#IFDEF TOP
	If TcSrvType() != "AS/400"
		lQuery	:=.T.
	Endif
#ENDIF	

If lQuery
	cQuery := "SELECT RA_FILIAL,RA_MAT,RA_CC,RA_SALARIO,RA_CODFUNC,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_TIPOPGT,RA_HRSMES,RA_CATFUNC,RA_SITFOLH,RA_SINDICA "
	cQuery += " FROM "+	RetSqlName("SRA")
	cQuery += " WHERE "
	cQuery += " RA_FILIAL  between '" + cFilDe  + "' AND '" + cFilAte + "' AND"
	cQuery += " RA_MAT     between '" + cMatDe  + "' AND '" + cMatAte + "' AND"
	cQuery += " RA_NOME    between '" + cNomeDe + "' AND '" + cNomeAte+ "' AND"
	cQuery += " RA_CC      between '" + cCcDe   + "' AND '" + cCcate  + "' AND"
	cQuery+=  " RA_CODFUNC between '" + cFuncDe + "' AND '" + cFuncAte+ "' AND"
	cQuery += " RA_CATFUNC IN (" + Upper(cCatQuery) + ") AND" 
	cQuery += " RA_SITFOLH IN (" + Upper(cSitQuery) + ") AND" 
	cQuery += " D_E_L_E_T_ <> '*' "		
	cQuery   += " ORDER BY RA_FILIAL, RA_CC, RA_MAT"

	aStruSRA := SRA->(dbStruct())
	SRA->( dbCloseArea() )
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SRA', .F., .T.)
	For nX := 1 To Len(aStruSRA)
		If ( aStruSRA[nX][2] <> "C" )
			TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
		EndIf
	Next nX
Else
	dbSetOrder(2)					
	dbGoTop()
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(SRA->(RecCount()))

cFilialAnt := "!!" 
cFANT 	  := "!!"
cCANT 	  := Space(20)

TPAGINA	 := TEMPRESA := TFILIAL := TCCTO := FL1 := 0
TEMPRESAF := TFILIALF := TCCTOF	:= 0

While !Eof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Quebra de Filial 											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRA->RA_FILIAL # cFilialAnt
		If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL) 			 .Or.;
			!fInfo(@aInfo,SRA->RA_FILIAL)
			dbSelectArea("SRA")
			dbSkip()
			If Eof()
				Exit
			Endif	
			Loop
		Endif
		dbSelectArea( "SRA" )
		cFilialAnt := SRA->RA_FILIAL
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		dbSkip()
		Loop
	EndIf

	nSalario   := 0
	nSalMes	  := 0
	nSalDia	  := 0
	nSalHora   := 0

	If nBase = 1		                                        // 1 composto
  	   nSalmes := SRA->RA_SALARIO
    Else
	Endif
	
	dbSelectArea( "SRA" )
	RecLock("TRA",.T.)
  	Replace FILIAL    With SRA->RA_FILIAL
	Replace MAT       With SRA->RA_MAT  
	Replace CC        With SRA->RA_CC 
	Replace CODFUNC   With SRA->RA_CODFUNC
	Replace ADMISSA   With SRA->RA_ADMISSA
	Replace NOME      With SRA->RA_NOME
	Replace SALMES    With nSalMes         
	MsUnLock()
	dbSelectArea( "SRA" )
	dbSkip()
EndDo

If lQuery
	dbSelectArea("SRA")
	dbCloseArea()
Endif	
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EMISSAO DO RELATORIO   								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("TRA")
	dbGotop()
	cArqNtx := CriaTrab(Nil,.F.)

	If nOrdem == 1
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->MAT"
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	ElseIf nOrdem == 2
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->NOME"
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cCcDe + cNomeDe,.T.)
   ElseIf nOrdem == 3
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->CODFUNC"
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cCcDe,.T.)
   EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Regua Processamento											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())

	cFANT := TRA->FILIAL
	cCANT := substr(TRA->CC+space(20),1,20)
	nTSalCC := nTSalFl := nTSalEmp := 0
	nTFunCC := nTFunFl := nTFunEmp := 0
	While !Eof()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta Regua Processamento										  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncRegua()
	
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		EndIf

		IF substr(TRA->CC+space(20),1,20) # cCANT .Or. TRA->FILIAL # cFANT
					IMPR(Repli("-",132),"C")
							DET := "Total C. Custo " + Substr(cCANT+Space(10),1,10)+"-"+Subs(Posicione("CTT",1,xFilial("CTT")+cCAnt,"CTT_DESC01"),1,35)+" "+STR0018+Transform(nTFunCc,"@E 999,999")+" "+Transform(nTSalCc,cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
					IMPR(DET,"C")
					IMPR(Repli("-",132),"C")
					nTSalCC := 	nTFunCC :=  0
					If lSalta .And. (TRA->FILIAL == cFANT)
						IMPR(" ","P")
					EndIf
		EndIf
		
		If Eof() .Or. TRA->FILIAL # cFANT
				IMPR(Repli("-",132),"C")
				IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
					cNomeFilial:=Space(15)
					If fInfo(@aInfo,cFANT)
						cNomeFilial:=aInfo[1]
					Endif
					DET := STR0019+cFANT+" - " + cNomeFilial+"  "+STR0020+Transform(nTFunFl,"@E 999,999")+"        "+Transform(nTSalFl,cPict1)	//"TOTAL DA FILIAL "###"                        QTDE......:"
				EndIF
				nTFunFl := nTSalFl := 0
				IMPR(DET,"C")
				IMPR(Repli("-",132),"C")
				IMPR(" ","P")
		EndIf
      
      nTFunCc ++
      nTFunFl ++
      nTFunEmp ++

		DET :=""	
		DET := TRA->FILIAL+"  "+TRA->MAT + " "
		DET += SubStr(TRA->NOME,1,30)+" "+PadR(DTOC(TRA->ADMISSA),10)
		DET += " "+TRA->CODFUNC+"-"+Posicione("SRJ",1,xFilial("SRJ")+TRA->CODFUNC,"RJ_DESCCMP")+" "
		DET += " "+Transform( TRA->SALMES,"@E 9,999,999.99")+"  "
		TPAGINA +=  TRA->SALMES
		IMPR(DET,"C")

		nTSalCC  += TRA->SALMES
		nTSalFl  += TRA->SALMES
		nTSalEmp +=TRA->SALMES
		
		cFANT := TRA->FILIAL
		cCANT := substr(TRA->CC+space(20),1,20) 
		
				
		dbSelectArea( "TRA" )
		dbSkip()
	EndDo

	IMPR(Repli("-",132),"C")			
	cNomeFilial:=Space(15)
	If fInfo(@aInfo,cFANT)
		cNomeFilial:=ainfo[1]
	EndIf
	IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
		DET := STR0019+ cFANT + " - " + cNomeFilial+Space(29)+STR0020+Transform(nTFunFl,"@E 999,999")+" "+Transform(nTSalFl,cPict1)	//"TOTAL DA FILIAL "###"QTDE.:"
		IMPR(DET,"C")
		IMPR(Repli("-",132),"C")
		IMPR(Repli("-",132),"C")
		DET := STR0025+" - " + Left(SM0->M0_NOMECOM,39) +Space(5)+ STR0026+Transform(nTFunEmp , "@E 999,999")+" "+;	//"TOTAL DA EMPRESA  "###"QTDE.:"
		Transform(nTSalEmp,cPict1)
		IMPR(DET,"C")
		IMPR(Repli("-",132),"C")
    EndIF
    IMPR(" ","F")	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio													  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SRA")
dbSetOrder(1)
Set Filter To

dbSelectArea("TRA")
dbCloseArea()
fErase( cArqNtx + OrdBagExt() )

If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
Endif
MS_FLUSH()
