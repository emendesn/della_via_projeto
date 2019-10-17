#Include "Dellavia.ch"

//Exame Final

User Function DESTA13()
	Private aCores      := {}
	Private cCadastro	:= "Producao"
	Private cIndex      := ""
	Private cChave      := ""
	Private cFiltro     := ""
	Private cUserLog    := ""
	Private aRotina     := {}

//  Usuario responsavel para realizar a exame
	cUserLog := Upper(Trim(SuperGetMv("MV_USERINS",.F.,"")))

	aAdd(aRotina,{"Pesquisar"     ,"AxPesqui"  ,0,1})
	aAdd(aRotina,{"Autoclave"     ,"U_DESTA02" ,0,4})
	aAdd(aRotina,{"Visualizar"    ,"U_DESTA13A",0,2})
	aAdd(aRotina,{"Libera/Rejeita","U_DESTA13B",0,4})
//	aAdd(aRotina,{"Empenhos"      ,"U_DESTA13D",0,4})
	aAdd(aRotina,{"Legenda"       ,"U_DESTA13C",0,2})

	aAdd(aCores,{"C2_X_STATU == '9'"                           ,"BR_PRETO"   }) // Rejeitado
	aAdd(aCores,{"C2_X_STATU == '6'"                           ,"BR_VERMELHO"}) // Producao
	aAdd(aCores,{"C2_X_STATU $ '1'"                            ,"BR_VERDE"   }) // Inspecao
	aAdd(aCores,{"C2_X_STATU $ ' 2345' .and. C2_XNUMROD = '  '","BR_AZUL"    }) // Montagem
	aAdd(aCores,{"C2_X_STATU $ ' 2345' .and. C2_XNUMROD # '  '","BR_AMARELO" }) // Autoclave
	aAdd(aCores,{".T."                                         ,"BR_BRANCO"  }) // Outros

	dbSelectArea("SC2")
	dbSetOrder(1)
	MBrowse(,,,,"SC2",,,,,,aCores)
Return Nil

User Function DESTA13A( cAlias, nReg, nOpcx )
	//-- Controle de dimensoes de objetos
	Local aSize    := {}
	Local aObjects := {}
	Local aInfo    := {}
	Local aPosObj  := {}

	//-- EnchoiceBar
	Local aButtons := {}
	Local nOpca    := 0

	//-- Enchoice
	Local aVisual := {}
	Local aAltera := {}

	//-- Controles Gerais
	Local nA       := 0
	Local cCpoShow := "D3_TM|D3_COD|D3_UM|D3_QUANT|D3_LOCAL|D3_EMISSAO"
	Local lApont   := .F.
	Private l240   := .T.
    aSaveArea:=getarea()
	//-- Enchoice
	Private aTela[0][0]
	Private aGets[0]
	Private oEnch

	//-- GetDados
	Private aHeader := {}
	Private aCols   := {}
	Private oGetD

	//-- Define os campos que irao aparecer na tela.
	Aadd( aVisual, "C2_NUM"    )
	Aadd( aVisual, "C2_DATPRF" )
	Aadd( aVisual, "C2_PRODUTO")
	Aadd( aVisual, "C2_QUANT"  )
	Aadd( aVisual, "C2_DATPRI" )
	Aadd( aVisual, "C2_OBS"    )
	Aadd( aVisual, "C2_EMISSAO")
	Aadd( aVisual, "C2_TPOP"   )
	Aadd( aVisual, "C2_SERIEPN")
	Aadd( aVisual, "C2_PRODUTO")
	Aadd( aVisual, "C2_NUMFOGO")
	Aadd( aVisual, "C2_MARCAPN")
	Aadd( aVisual, "C2_CARCACA")
	Aadd( aVisual, "C2_X_DESEN")
	Aadd( aVisual, "C2_UM"     )

	RegToMemory(cAlias,.F.)

	SX3->( dbSetOrder( 2 ) )
	SX3->( MsSeek( "D3_QUANT" ) )

	aAdd(aHeader,{"Tipo"      ,"D3_TM"     	,"@!"                      ,20                     ,0                    ,".T.",SX3->X3_USADO,"C","SD3",SX3->X3_CONTEXT})
	aAdd(aHeader,{"Produto"   ,"D3_COD"    	,"@!"                      ,TamSX3("D3_COD")[1]    ,0                    ,".T.",SX3->X3_USADO,"N","SD3",SX3->X3_CONTEXT})
	aAdd(aHeader,{"Descricao" ,"D3_XDESC"  	,"@!"                      ,TamSX3("D3_XDESC")[1]  ,0                    ,".T.",SX3->X3_USADO,"C","SD3",SX3->X3_CONTEXT})
	aAdd(aHeader,{"Quantidade","D3_QUANT"  	,PesqPict("SD3","D3_QUANT"),TamSX3("D3_QUANT")[1]  ,TamSX3("D3_QUANT")[2],".T.",SX3->X3_USADO,"C","SD3",SX3->X3_CONTEXT})
	aAdd(aHeader,{"Usuario"   ,"D3_USUARIO"	,"@!"                      ,TamSX3("D3_USUARIO")[1],0                    ,".T.",SX3->X3_USADO,"C","SD3",SX3->X3_CONTEXT})
	aAdd(aHeader,{"Data"      ,"D3_EMISSAO"	,"@!"                      ,TamSX3("D3_EMISSAO")[1],0                    ,".T.",SX3->X3_USADO,"D","SD3",SX3->X3_CONTEXT})
	aAdd(aHeader,{"Hora"      ,"D3_HORA"	,"@!"                      ,TamSX3("D3_HORA")[1],0                    ,".T.",SX3->X3_USADO,"D","SD3",SX3->X3_CONTEXT})

	//-- Apenas para inibir o inicializador do campo.
	M->D3_COD := ""

	SD3->(dbSetOrder(13))
	SD3->(MsSeek(xFilial("SD3")+M->(C2_NUM+C2_ITEM)))

	Do While SD3->(!Eof() .And. D3_FILIAL+Left(D3_OP,8) = xFilial("SD3")+M->C2_NUM+M->C2_ITEM)
		//-- Desconsidero os apontamentos de Producao.
		If SD3->D3_CF <> "RE0"
			SD3->(dbSkip())
			Loop
		EndIf

		lApont := .T.

/*		//-- Considero somente os produtos do grupo SC/CI - JC 20/08/05
		SB1->(dbSetOrder(1))
		SB1->(MsSeek(xFilial("SB1")+SD3->D3_X_PROD)) //Reinaldo SD3->D3_COD

		IF !(Alltrim(SB1->B1_GRUPO) $ Alltrim(GetMv("MV_X_GRPRO")))
			SD3->(dbSkip())
			Loop
		EndIf */

		aAdd(aCols,Array(Len(aHeader)+1))

		aCols[Len(aCols),1] := SD3->D3_TM + " - " + AllTrim(Posicione("SF5",1,xFilial("SF5")+SD3->D3_TM,"F5_TEXTO"))
		aCols[Len(aCols),2] := SD3->D3_COD
		aCols[Len(aCols),3] := SD3->D3_XDESC
		aCols[Len(aCols),4] := SD3->D3_QUANT
		aCols[Len(aCols),5] := SD3->D3_USUARIO
		aCols[Len(aCols),6] := SD3->D3_EMISSAO
        aCols[Len(aCols),7] := SD3->D3_HORA

		aCols[Len( aCols ),Len( aHeader ) + 1] := .F.

		SD3->( dbSkip() )
	EndDo

	IF !lApont	
		SZF->(dbSetOrder(1))
		SZF->(MsSeek(xFilial("SZF")+M->(C2_NUM+C2_ITEM+"001")))

		Do While SZF->(!Eof() .And. SZF->ZF_FILIAL+Left(SZF->ZF_NUMOP,8) = xFilial("SZF")+M->C2_NUM+M->C2_ITEM)
			//-- Considero somente os produtos do grupo SC/CI - JC 20/08/05
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+SZF->ZF_PRODSRV))

			IF !Empty(SB1->B1_PRODUTO)
				SZF->(dbSkip())
				Loop
			EndIf

			Aadd( aCols, Array( Len( aHeader ) + 1 ) )

			aCols[Len( aCols ), 1 ] := "MAN" + " - " + "SERV.TERCEIRO"
			aCols[Len( aCols ), 2 ] := SZF->ZF_PRODSRV
			aCols[Len( aCols ), 3 ] := SZF->ZF_DESCRI
			aCols[Len( aCols ), 4 ] := SZF->ZF_QUANT	
			aCols[Len( aCols ), 5 ] := SZF->ZF_USUARIO
			aCols[Len( aCols ), 6 ] := SZF->ZF_DATA
            aCols[Len( aCols ), 7 ] := SZF->ZF_HORA

			aCols[Len( aCols ),Len( aHeader ) + 1] := .F.

			SZF->(dbSkip())
		EndDo
	EndIF	

	If Empty(aCols)
		Aadd(aCols,Array(Len(aHeader)+1))
		For nA := 1 To Len(aHeader)
			aCols[1,nA] := CriaVar(aHeader[nA,2])
		Next nA
		aCols[1,Len(aHeader)+1] := .F.
	EndIf

	//-- Calcula as dimensoes dos objetos
	aSize := MsAdvSize(.T.)

	AAdd(aObjects,{100,40,.T.,.T.})
	AAdd(aObjects,{100,60,.T.,.T.})

	aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],0,0}
	aPosObj := MsObjSize(aInfo,aObjects,.T.)

	_aPos := {}
	AAdd(_aPos,aPosObj[1,1]-12)
	AAdd(_aPos,aPosObj[1,2])
	AAdd(_aPos,aPosObj[1,3]-1)
	AAdd(_aPos,aPosObj[1,4]-22.5)

	DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7]+20,00 TO aSize[6]-20,aSize[5]-50 PIXEL
		oEnch := MsMGet():New(cAlias,nReg,2,,,,aVisual,_aPos,aAltera,3,,,,,,.T.)
		//oEnch := MsMGet():New(cAlias,nReg,2,,,,aVisual,_aPos,aAltera,3,,,,,,.T.,,,,,aCampos)
		oGetD := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-40,aPosObj[2,4]-23,2,"AllWaysTrue","AllWaysTrue",,.T.)
	ACTIVATE MSDIALOG oDlgEsp
Return Nil

User Function DESTA13B()
	Private lMsErroAuto := .F.
	Private aHeader := {}
	Private aAlter  := {}
	Private aCols   := {}
    Private aRotina := {}
	Private cPerg   := "DEST13"
	Private aRegs   := {}
    Private aCampos := {}
	aSaveArea:=getarea()
    aAdd(aRegs,{cPerg,"01","Data Auto Clave ?"," "," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"02","Número da Rodada?"," "," ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    
 	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.T.)  
	
	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5}) 


	aAdd(aHeader,{"LVR"      ,"STATUS" ,"@!",01,0,"M->STATUS $ ' LRV' .AND. U_DST13VWM()",,"C",,})
	aAdd(aHeader,{"Cod.Rej." ,"MOTREJE",""  ,02,0,"U_FMotReje(acols[n,1],M->MOTREJE)"    ,,"C",,})
	aAdd(aHeader,{"Num OP"   ,"NUM"    ,""  ,06,0,                                       ,,"C",,})
	aAdd(aHeader,{"Item"     ,"ITEM"   ,""  ,02,0,                                       ,,"C",,})
	aAdd(aHeader,{"Emissao"  ,"XDTCLAV",""  ,08,0,                                       ,,"D",,})
	aAdd(aHeader,{"Rodada"   ,"XNUMROD",""  ,02,0,                                       ,,"C",,})
	aAdd(aHeader,{"AClave"   ,"XACLAVE",""  ,02,0,                                       ,,"C",,})
	aAdd(aHeader,{"Bico"     ,"XBICO"  ,""  ,02,0,                                       ,,"C",,})
	aAdd(aHeader,{"Status"   ,"X_STATU",""  ,01,0,                                       ,,"C",,})
	aAdd(aHeader,{"Filial"   ,"FILIAL" ,""  ,02,0,                                       ,,"C",,})
	aAdd(aHeader,{"Entrega"  ,"ENTREGA",""  ,08,0,                                       ,,"D",,})
	aAdd(aHeader,{"Medida"   ,"MEDIDA" ,""  ,15,0,                                       ,,"C",,})
	aAdd(aHeader,{"Desenho"  ,"Desenho",""  ,15,0,                                       ,,"C",,})
	aAdd(aHeader,{"Serie"    ,"SERIE"  ,""  ,15,0,                                       ,,"C",,})
	aAdd(aHeader,{"Num. Fogo","FOGO"   ,""  ,06,0,                                       ,,"C",,})
	aAdd(aHeader,{"Cliente"  ,"CLIENTE",""  ,06,0,                                       ,,"C",,})
	aAdd(aHeader,{"Loja"     ,"LOJA"   ,""  ,02,0,                                       ,,"C",,})
	aAdd(aHeader,{"Nome"     ,"NOME"   ,""  ,40,0,                                       ,,"C",,})

	// Campos que podem ser alterados                     
	aAdd(aAlter,"STATUS" )
	aAdd(aAlter,"MOTREJE")

	cSql := "SELECT C2_STATUS  AS STATUS"
 	cSql += " ,     C2_XMREPRD AS MOTREJE"
	cSql += " ,     C2_NUM     AS NUM"
	cSql += " ,     C2_ITEM    AS ITEM"
	cSql += " ,     C2_XDTCLAV AS XDTCLAV"
	cSql += " ,     C2_XNUMROD AS XNUMROD"
	cSql += " ,     C2_XACLAVE AS XACLAVE"
	cSql += " ,     C2_XBICO   AS XBICO"
	cSql += " ,     C2_X_STATU AS X_STATU"
	cSql += " ,     C2_FILIAL  AS FILIAL"
	cSql += " ,     C2_DATPRF  AS ENTREGA"
	cSql += " ,     C2_PRODUTO AS MEDIDA"
	cSql += " ,     C2_X_DESEN AS DESENHO"
	cSql += " ,     C2_SERIEPN AS SERIE"
	cSql += " ,     C2_NUMFOGO AS FOGO"
	cSql += " ,     C2_FORNECE AS CLIENTE"
	cSql += " ,     C2_LOJA    AS LOJA"
	cSql += " ,     A1_NREDUZ  AS NOME"
	cSql += " FROM " + RetSqlName("SC2") + " SC2"

	cSql += " JOIN " + RetSqlName("SA1") + " SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND  A1_COD = C2_FORNECE"
	cSql += " AND  A1_LOJA = C2_LOJA"

	cSql += " WHERE SC2.D_E_L_E_T_ = ''"
	cSql += " AND   C2_FILIAL = '"+xFilial("SC2")+"'"   
	
	if empty(mv_par01)
		cSql += " AND   C2_X_STATU = 'T' "
		cSql += " ORDER BY C2_FILIAL,C2_EMISSAO,C2_NUM,C2_ITEM "
	else
		cSql += " AND   C2_XDTCLAV = '" + DTOS(mv_par01) + "' "
		cSql += " AND   C2_XNUMROD = '" + mv_par02       + "' "
		cSql += " AND   C2_X_STATU in(' ','1','2','3','4','5','7','T') "  
		cSql += " AND   C2_XACLAVE <> '' "
		cSql += " AND   C2_XBICO   <> '' "
		cSql += " ORDER BY C2_FILIAL,C2_XDTCLAV,C2_XNUMROD,C2_XACLAVE,C2_XBICO,C2_NUM,C2_ITEM"
	endif

	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","XDTCLAV","D",08,0)
	TcSetField("ARQ_SQL","ENTREGA","D",08,0)
	dbSelectArea("ARQ_SQL")
                              
	// Loop para carregar aCols
	aCols := {}
	Do while !eof()     
		aAdd(aCols,{STATUS,MOTREJE,NUM,ITEM,XDTCLAV,XNUMROD,XACLAVE,XBICO,X_STATU,FILIAL,ENTREGA,MEDIDA,DESENHO,SERIE,FOGO,CLIENTE,LOJA,NOME,.F.})
		dbSkip()
	Enddo

		@ 000,000 TO 340,750 DIALOG oDlg TITLE "OK Final ... Libera/Rejeita"
		oGetDados := MSGetDados():New(000,000,150,375,4,"U_DST13LOK()",,,.F.,aAlter,,,Len(aCols),,,,,oDlg)
		@ 155,315 BMPBUTTON TYPE 1 ACTION CAutoClave() OBJECT oBtnLibRej
		@ 155,345 BMPBUTTON TYPE 2 ACTION Close(oDlg)  OBJECT oBtnSair
	ACTIVATE DIALOG oDlg CENTER

	dbSelectArea("ARQ_SQL")
	dbCloseArea()
Return nil

User Function DST13VWM()
	Local aArea     := GetArea()
	Local cSql      := ""
	Local cAliasSql := ""


	If !Empty(M->STATUS)
		cSql := "SELECT C2_FILIAL,C2_SERIED1,C2_NUMD1"
		cSql += " FROM "+RetSqlName("SC2")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   C2_FILIAL = '"+xFilial("SC2")+"'"
		cSql += " AND   C2_NUM = '"+aCols[n,3]+"'"
		cSql += " AND   C2_ITEM = '"+aCols[n,4]+"'"

		cAliasSql := GetNextAlias()
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),cAliasSql, .T., .T.)

		U_DESTV02((cAliasSql)->C2_FILIAL,(cAliasSql)->C2_SERIED1,(cAliasSql)->C2_NUMD1,"ZZ7_FINAL = 'S'")

		dbSelectArea(cAliasSql)
		dbCloseArea()

		RestArea(aArea)
	Endif
Return .T.



User Function DST13LOK()
	Local lRet      := .T.
	
	Do Case
	   Case aCols[n,1] == "R" .and. Empty(aCols[n,2])
		  lRet := .F.              
	   Case aCols[n,1] == "L" .and. !Empty(aCols[n,2]) .and. upper(aCols[n,2]) != "SG"
	      lRet := .F.     
	EndCase
Return lRet

static function CAutoClave
	For Linha = 1 to len(acols)
		dbSelectArea("SC2")
		dbSetOrder(1)
		if acols[Linha,1] # " "                                                        
			dbSeek(xFilial("SC2")+acols[Linha,3]+acols[Linha,4]+"001")
			Do Case
				Case acols[Linha,1] = "L"
					U_DSTA13bL()
				Case acols[Linha,1] = "R"
					U_DSTA13bR()
				Case acols[Linha,1] = "V"
					U_DSTA13bV()
			Endcase
		Endif
	Next
	Close(oDlg)
return nil

User Function DSTA13BL() 
	Local   aRegSD3     := {}
	Private lMsHelpAuto := .F.
	Private lMsErroAuto := .F.

	Aadd(aRegSD3,{"D3_FILIAL" ,xFilial("SD3")                 ,NIL})
//	Aadd(aRegSD3,{"D3_TM"     ,"001"                          ,NIL})
	Aadd(aRegSD3,{"D3_TM"     ,"506"                          ,NIL})
	Aadd(aRegSD3,{"D3_COD"    ,SC2->C2_PRODUTO                ,NIL})
	Aadd(aRegSD3,{"D3_UM"     ,SC2->C2_UM                     ,NIL})
	Aadd(aRegSD3,{"D3_QUANT"  ,SC2->C2_QUANT                  ,NIL})
	Aadd(aRegSD3,{"D3_OP"     ,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),NIL})
//	Aadd(aRegSD3,{"D3_CF"     ,"PR0"                          ,NIL})
	Aadd(aRegSD3,{"D3_CF"     ,"RE0"                          ,NIL})
	Aadd(aRegSD3,{"D3_LOCAL"  ,SC2->C2_LOCAL                  ,NIL})
	Aadd(aRegSD3,{"D3_X_ARMZ" ,SC2->C2_LOCAL                  ,NIL})
	Aadd(aRegSD3,{"D3_DOC"    ,SC2->C2_NUM                    ,NIL})
	Aadd(aRegSD3,{"D3_EMISSAO",dDataBase                      ,NIL})
	Aadd(aRegSD3,{"D3_GRUPO"  ,SC2->C2_GRUPO                  ,NIL})
	Aadd(aRegSD3,{"D3_SEGUM"  ,SC2->C2_SEGUM                  ,NIL})
	Aadd(aRegSD3,{"D3_QTSEGUM",SC2->C2_QTSEGUM                ,NIL})
	Aadd(aRegSD3,{"D3_USUARIO",SubStr(cUsuario,7,15)          ,NIL})  
	Aadd(aRegSD3,{"D3_XDESC"  , "LIBERADO EXAME FINAL" ,NIL})  
    Aadd(aRegSD3,{"D3_HORA"  , TIME(),NIL})
	VerSaldo()
//	MsExecAuto( { |x, y| Mata250( x, y ) }, aRegSD3, 3 )			  
	MsExecAuto( { |x, y| Mata240( x, y ) }, aRegSD3, 3 )			

	//-- Verifica se houve algum erro.
	If lMsErroAuto
		If Aviso("Pergunta","OP nao encerrada. Deseja visualizar o log?",{"Sim","Nao"},1,"Atencao") == 1
			MostraErro()
		EndIf
	Else
		If RecLock("SC2",.F.)
			SC2->C2_X_STATU := "6"
			SC2->C2_DATRF   := dDataBase
			IF aCols[Linha,2] = "SG"
				SC2->C2_OBS		:= "SEM GARANTIA" + SC2->C2_OBS
			ENDIF
			SC2->(MsUnLock())
		Endif
	EndIf

Return Nil   

Static Function VerSaldo()
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+SC2->C2_PRODUTO+'01')     
	if .not.found() .and. RecLock("SB2",.T.)
		SB2->B2_Filial := xFilial("SB2")
		SB2->B2_Cod    := SC2->C2_PRODUTO   
		SB2->B2_Local  := '01'
		MsUnLock()
	endif
	dbSelectArea("SB9")    
	dbSetOrder(1)
	dbSeek(xFilial("SB9")+SC2->C2_PRODUTO+'01')
	if .not.found() .and. RecLock("SB9",.T.)
		SB9->B9_Filial := xFilial("SB9")
		SB9->B9_Cod    := SC2->C2_PRODUTO
		SB9->B9_Local  := '01'
		MsUnLock()
	endif         
	dbSelectArea("SB2")
	If SB2->B2_QATU < 1
		If RecLock("SB2",.F.)
			SB2->B2_QATU    := 1
			SB2->B2_VATU1   := 10
			SB2->B2_CM1     := 10  
			SB2->B2_QNPT    := 0   
			SB2->B2_QTNP    := 0     
			SB2->B2_RESERVA := 0
			MsUnLock()
		Endif
	Else
		If RecLock("SB2",.F.)
			SB2->B2_QNPT    := 0
			SB2->B2_QTNP	:= 0
			SB2->B2_RESERVA := 0
			MsUnLock()
		Endif
	Endif
Return nil

User Function DSTA13BR()
	Local aRegSD3 := {}

	//-- Inclusao.
	Aadd(aRegSD3,{"D3_FILIAL" ,xFilial("SD3")                 ,NIL})
//	Aadd(aRegSD3,{"D3_TM"     ,"001"                          ,NIL}) 
    Aadd(aRegSD3,{"D3_TM"     ,"509"                          ,NIL})
	Aadd(aRegSD3,{"D3_COD"    ,SC2->C2_PRODUTO                ,NIL})
	Aadd(aRegSD3,{"D3_UM"     ,SC2->C2_UM                     ,NIL})
	Aadd(aRegSD3,{"D3_QUANT"  ,SC2->C2_QUANT                  ,NIL})
	Aadd(aRegSD3,{"D3_PERDA"  ,SC2->C2_QUANT                  ,NIL})
	Aadd(aRegSD3,{"D3_OP"     ,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),NIL})
//	Aadd(aRegSD3,{"D3_CF"     ,"PR0"                          ,NIL})
	Aadd(aRegSD3,{"D3_CF"     ,"RE0"                          ,NIL})
	Aadd(aRegSD3,{"D3_LOCAL"  ,SC2->C2_LOCAL                  ,NIL})
	Aadd(aRegSD3,{"D3_X_ARMZ" ,SC2->C2_LOCAL                  ,NIL})
	Aadd(aRegSD3,{"D3_DOC"    ,SC2->C2_NUM                    ,NIL})
	Aadd(aRegSD3,{"D3_EMISSAO",dDataBase                      ,NIL})
	Aadd(aRegSD3,{"D3_GRUPO"  ,SC2->C2_GRUPO                  ,NIL})
	Aadd(aRegSD3,{"D3_SEGUM"  ,SC2->C2_SEGUM                  ,NIL})
	Aadd(aRegSD3,{"D3_QTSEGUM",SC2->C2_QTSEGUM                ,NIL})
	Aadd(aRegSD3,{"D3_USUARIO",SubStr(cUsuario,7,15)          ,NIL})
	Aadd(aRegSD3,{"D3_XDESC"  , "RECUSADO EXAME FINAL",NIL})
	Aadd(aRegSD3,{"D3_HORA"  , TIME(),NIL})
	
	VerSaldo()
//  MsExecAuto({|x,y| Mata250(x,y) },aRegSD3,3)
    MsExecAuto({|x,y| Mata240(x,y) },aRegSD3,3)
	//-- Verifica se houve algum erro.
	If lMsErroAuto
		If Aviso("Pergunta","OP NAO REJEITADA. Deseja visualizar o log?",{"Sim","Nao"},1,"Atencao") = 1
			MostraErro()
		EndIf
	Else
		If RecLock("SC2",.F.)
			SC2->C2_X_STATU := "9"
			SC2->C2_PERDA   := SC2->C2_QUANT
			SC2->C2_MOTREJE := aCols[n,2]   
			SC2->C2_DATRF   := dDataBase
			SC2->(MsUnLock())
		Endif
	EndIf                

Return Nil

User Function DSTA13BV()
	if Reclock ("SC2",.F.)
		SC2->C2_X_Statu := "1"
		SC2->C2_XACLAVE := ""
		SC2->C2_XNUMLOT := ""
		SC2->C2_XNUMROD := ""
		SC2->C2_XRODADA := ""
		SC2->C2_XTRILHO := ""
		SC2->C2_XBICO   := ""
		SC2->C2_XDTCLAV := CTOD("")
		SC2->C2_XDTLOTE := CTOD("")
		SC2->C2_OBS     := alltrim(SC2->C2_OBS) + "REPROCESSO"
		MsUnLock()
	Endif
Return Nil

User Function DESTA13C()
	BrwLegenda("Legenda",cCadastro,{{"BR_VERDE"   ,"Inspecao" },;
                                    {"BR_AZUL"    ,"Montagem" },;
                                    {"BR_AMARELO" ,"Autoclave"},;
                                    {"BR_VERMELHO","Liberado" },; 
                                    {"BR_BRANCO"  ,"Terceiro" },;
                                    {"BR_PRETO"   ,"Recusado" }})
Return Nil

User Function fMotReje(cOp,cMot)
	Local lRet := .T.

	Do Case
		Case Empty(cop) .and. Empty(cMot)
			lRet := .T.
		Case cOp == "R" .and. !ExistCpo("SX5","43"+cMot)
			lRet := .F.
		Case cOp == "L" .and. Empty(cMot)
			lRet := .T.
		Case cOp == "L" .and. Upper(cMot) != "SG"
			lRet := .F.
	Endcase
Return(lRet)

User Function DESTA13D
	Local cSql    := ""
	Local aCampos := {}
	Local cNomTmp := ""
	Local aArea   := GetArea()

	aAdd(aCampos,{"D3_LOCAL"  ,"Local"     ,"@!"                  })
	aAdd(aCampos,{"D3_COD"    ,"Código"    ,"@!"                  })
	aAdd(aCampos,{"B1_DESC"   ,"Descricao" ,"@!"                  })
	aAdd(aCampos,{"D3_EMISSAO","Emissao"   ,""                    })
	aAdd(aCampos,{"D3_QUANT"  ,"Quantidade","@e 99,999,999,999.99"})
	aAdd(aCampos,{"D3_UM"     ,"UM"        ,"@!"                  })


	cSql := "SELECT D3_LOCAL,D3_COD,B1_DESC,D3_EMISSAO,D3_QUANT,D3_UM,SD3.R_E_C_N_O_ AS REC"
	cSql += " FROM "+RetSqlName("SD3")+" SD3"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D3_COD"

	cSql += " WHERE SD3.D_E_L_E_T_ = ''"
	cSql += " AND   D3_FILIAL = '"+xFilial("SD3")+"'"
	cSql += " AND   SUBSTR(D3_OP,1,6) = '"+SC2->C2_NUM+"'"
	cSql += " AND   SUBSTR(D3_OP,7,2) = '"+SC2->C2_ITEM+"'"
	cSql += " AND   SUBSTR(D3_CF,1,1) = 'R'"
	cSql += " AND   D3_ESTORNO <> 'S'"

	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","D3_EMISSAO","D",08,0)
	TcSetField("ARQ_SQL","D3_QUANT"  ,"N",14,2)

	dbSelectArea("ARQ_SQL")

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)

	@ 000,000 TO 210,600 DIALOG oDlgEmp TITLE SC2->C2_NUM+"/"+SC2->C2_ITEM
		@ 003,003 TO 080,300 BROWSE "TMP" OBJECT oBrwEmp FIELDS aCampos
		@ 085,240 BMPBUTTON TYPE  1 Action Close(oDlgEmp)
		@ 085,270 BMPBUTTON TYPE 15 Action SD3Visual()
	Activate Dialog oDlgEmp Centered

	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())

	RestArea(aArea)
Return nil

Static Function SD3Visual()
	Local   aArea := GetArea()
	Private aAcho := {}
	Private l240  := .T. 
	Private l250  := .F.
	Private l241  := .F.
	Private l242  := .F.
	Private l261  := .F.
	Private l185  := .F.
	Private l650  := .F.

	A240AAcho()

	dbSelectArea("SD3")
	dbGoTo(TMP->REC)

	A240Visual("SD3",RecNo(),2)

	RestArea(aArea)
Return