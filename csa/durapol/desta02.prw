#include 'protheus.ch'
#Include 'Dellavia.ch'

/*
DESTA02
Rotina para Informe dos dados da Autoclave             
*/

User Function DESTA02()
                         
Local cQuery     		:= ""
Local oGetDe,oGetAte,oGetDtAutC,oGetRod,oGetAutc,oGetTri,oGetNRod,oPesq
Local nX
Local aObjects 			:= {}
Local aSize    			:= {}
Local aInfo    			:= {}
Local aPosObj  			:= {}
Local aPos    			:= {}
Local oDlgVal,oGetVal

//-- GetDados
Private aHeader			:= {}
Private aCols			:= {} 
Private aAlter  		:= {}

//-- Outras variaveis
Private cLote       	:= Space(6)
Private dDataDe     	:= CtoD("")
Private dDataAte    	:= CtoD("")
Private cDtAutC			:= dDataBase
Private cAutoClave 		:= Space(2)
Private cTrilho     	:= Space(1)
Private cNumRodada  	:= Space(2)
Private cRodada     	:= Space(5)
Private aRegs       	:= {}
Private cPerg       	:= "ESTA02"
Private cCadastro   	:= "Autoclave"
Private aRotina     	:= {}
Private cMarca      	:= GetMark()
Private oDlgEsp,oMult     
Private lLote       	:= .F. //Considera somente lote de producao

              
//-- cria grupo de perguntas no SX1
aRegs						:={}
AAdd(aRegs,{cPerg,"01","Producao De?"   ,"Producao De?"   ,"Producao De?"   ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"02","Producao Ate?"  ,"Producao Ate?"  ,"Producao Ate?"  ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)

//-- faz pergunta
Pergunte(cPerg,.T.)

dDataDe  					:= mv_par01
dDataAte 					:= mv_par02
                                                                                        
AAdd( aHeader, { "Nr.Bico"		, "BICO"				, "99"	, 02, 0, "U_VldBico(M->Bico)" , , "C", , } )     
AAdd( aHeader, { "Num OP"	    , "C2_NUM"			    , ""  	, 06, 0, , , "C", , } )
AAdd( aHeader, { "Item"			, "C2_ITEM"			    , ""  	, 02, 0, , , "C", , } )      
AAdd( aHeader, { "Status"		, "C2_X_STATU"	        , ""  	, 01, 0, , , "C", , } )      
AAdd( aHeader, { "Emissao"	    , "C2_EMISSAO"			, ""  	, 08, 0, , , "D", , } )   
AAdd( aHeader, { "Tipo"			, "B1_XESPEC"			, ""  	, 01, 0, , , "C", , } )    
AAdd( aHeader, { "Banda"		, "D3_X_PROD"			, ""  	, 15, 0, , , "C", , } )     
AAdd( aHeader, { "Ser Pneu"		, "C2_SERIEPN"			, ""  	, 15, 0, , , "C", , } )     
AAdd( aHeader, { "Num Fogo"		, "C2_NUMFOGO"			, ""  	, 06, 0, , , "C", , } )     
AAdd( aHeader, { "Dt Entreg"	, "C2_DATPRF"			, ""  	, 08, 0, , , "D", , } )     
AAdd( aHeader, { "Carcaca"		, "C2_PRODUTO"			, ""  	, 15, 0, , , "C", , } )       
AAdd( aHeader, { "Nome"			, "C2_XNREDUZ"			, ""  	, 20, 0, , , "C", , } )      
AAdd( aHeader, { "Servico"	    , "D1_SERVICO" 			, ""  	, 15, 0, , , "C", , } )      
AAdd( aHeader, { "Descricao" 	, "B1_DESC"         	, ""  	, 30, 0, , , "C", , } )                                   

dbSelectArea("SX3")
dbSetOrder(2)
MsSeek("C2_XNREDUZ")
For nX:= 2 to Len(aHeader)
	aHeader[nX , 2] := SX3->X3_CAMPO
Next

IF Select("TMP") > 0
	TMP->(dbCloseArea())
EndIF	

cQry := "Select MIN(C2_XNUMLOT) LOTEMIN "
cQry += "  From " + RetSqlName("SC2") + " SC2, " 
cQry +=             RetSqlName("SZM") + " SZM "
cQry += " Where C2_XNUMLOT <> '' AND ZM_NUMLOTE = C2_XNUMLOT AND ZM_X_HRFIM = '' "
cQry += "   and SC2.D_E_L_E_T_ = ' ' "
cQry += "   and SZM.D_E_L_E_T_ = ' ' "
cQry += "   and C2_FILIAL = '" + xFilial("SC2") + "' "
cQry += "   and ZM_FILIAL = '" + xFilial("SZM") + "' "      
	
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TMP",.F.,.T.)
dbSelectArea("TMP")
dbGoTop()
While ! Eof()
		cLote := TMP->LOTEMIN
		Exit
EndDo
	
IF Empty(cLote)
		cLote := '000001'
EndIF

dbSelectArea("SC2")
dbSetOrder(1)

IF Select("TRBSC2") > 0
	TRBSC2->(dbCloseArea())
EndIF	

cQuery := "   SELECT  '  ' AS BICO, C2_NUM,     C2_ITEM,   C2_X_STATU, C2_EMISSAO,  B1_X_ESPEC, D3_X_PROD,  "
cQuery += "       	  C2_SERIEPN,   C2_NUMFOGO, C2_DATPRF, C2_PRODUTO, C2_XNREDUZ,  D1_SERVICO, B1_DESC "
cQuery += "  	 FROM SC2030 SC2 "
cQuery += "    	 JOIN SD1030 SD1 "
cQuery += "      	   ON SD1.D_E_L_E_T_   	= ' '"
cQuery += "        AND SD1.D1_FILIAL        = SC2.C2_FILIAL "
cQuery += "        AND SD1.D1_DOC          	= SC2.C2_NUMD1 "
cQuery += "        AND SD1.D1_SERIE     	= SC2.C2_SERIED1 "
cQuery += "        AND SD1.D1_FORNECE 		= SC2.C2_FORNECE "
cQuery += "        AND SD1.D1_LOJA         	= SC2.C2_LOJA "
cQuery += "        AND SD1.D1_COD 			= SC2.C2_PRODUTO "
cQuery += "        AND SD1.D1_ITEM 			= SC2.C2_ITEMD1 "
cQuery += "       JOIN SB1030 SB1 "                                                                                                                                                                                                          
cQuery += "         ON SB1.D_E_L_E_T_ 		= ' '"
cQuery += "        AND SB1.B1_FILIAL 		= '' "
cQuery += "        AND SB1.B1_COD 			= SD1.D1_SERVICO "    
cQuery += "        AND SB1.B1_X_ESPEC 		<> 'Q' "    
cQuery += "       LEFT JOIN SD3030 SD3 "
cQuery += "         ON SD3.D_E_L_E_T_ 		= ' '"
cQuery += "        AND SD3.D3_FILIAL 		= SC2.C2_FILIAL "
cQuery += "        AND SD3.D3_OP 			= SC2.C2_NUM || SC2.C2_ITEM || '001  ' "
cQuery += "        AND SD3.D3_GRUPO 			= 'BAND' "
cQuery += "      WHERE SC2.D_E_L_E_T_ 			= ' '"
cQuery += "        AND C2_FILIAL 			= '" + xFilial("SC2") + "' "
cQuery += "        AND C2_DATPRI 			>= '" + DtoS(dDataDe) + "' "        
cQuery += "        AND C2_DATPRI 			<= '" + DtoS(dDataAte) + "' "        
cQuery += "        AND C2_X_STATU 			IN ('4','5','7') "
cQuery += "        AND C2_XACLAVE 			= '  ' "
IF lLote
	cQuery += "    AND C2_XNUMLOT 			= '" + cLote + "' "
EndIF
cQuery += "      ORDER BY C2_XNUMLOT, C2_X_ORDEM, C2_NUM, C2_ITEM, C2_DATPRF "

dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), "TRBSC2", .F., .F. )
TcSetField("TRBSC2","C2_EMISSAO","D",08,0) 
TcSetField("TRBSC2","C2_DATPRF",  "D",08,0) 

dbGoTop()

Do while !eof()     
	aAdd(aCols,{BICO,C2_NUM,C2_ITEM,C2_X_STATU,C2_EMISSAO,B1_X_ESPEC,D3_X_PROD,C2_SERIEPN,C2_NUMFOGO,C2_DATPRF,C2_PRODUTO,C2_XNREDUZ,D1_SERVICO,B1_DESC,.F.})
	dbSkip()
Enddo
	         
TRBSC2->( dbCloseArea() )
If empty(aCols)
	MsgStop("Sem Registros ... !!!.","Atenção")
	return nil
Endif

//-- Calcula as dimensoes dos objetos
aSize  := MsAdvSize(.T.)

AAdd( aObjects, { 100,40,.T.,.T. } )
AAdd( aObjects, { 100,60,.T.,.T. } )

aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4], 0, 0 }
aPosObj:= MsObjSize( aInfo, aObjects, .T. )

dbSelectArea("SC2")

aPos := {}
AAdd(aPos,aPosObj[1,1]-12)
AAdd(aPos,aPosObj[1,2])
AAdd(aPos,aPosObj[1,3]-113.6)
AAdd(aPos,aPosObj[1,4]-445.7)

	@ aSize[7]+20,00 TO aSize[6]-20,aSize[5]-50 DIALOG oDlgEsp TITLE cCadastro

	@ aPos[1]+10,08 	SAY 	"Entrega De" 	                          											PIXEL OF oDlgEsp SIZE 70,7
	@ aPos[1]+10,40 	MSGET 	oGetDe 		VAR dDataDe 	PICTURE "@D"								WHEN .F. 	PIXEL OF oDlgEsp SIZE 20,7

	@ aPos[1]+10,85 	SAY 	"Ate"																				PIXEL OF oDlgEsp SIZE 70,7
	@ aPos[1]+10,100 	MSGET 	oGetAte 	VAR dDataAte	PICTURE "@D" 							  	WHEN .F.	PIXEL OF oDlgEsp SIZE 20,7

	@ aPos[1]+10,143 	SAY 	"Data Autoclave" 																	PIXEL OF oDlgEsp SIZE 70,7
	@ aPos[1]+10,180 	MSGET 	oGetDtAutC 	VAR cDtAutC		PICTURE "@D" 	VALID !Empty(cDtAutC) 		WHEN .T. 	PIXEL OF oDlgEsp SIZE 20,7

	@ aPos[1]+25,08 	SAY 	"Rodada" 																			PIXEL OF oDlgEsp SIZE 70,7
	@ aPos[1]+25,40 	MSGET 	oGetNRod 	VAR cNumRodada  PICTURE "99" 	VALID !Empty(cNumRodada) 	WHEN .T. 	PIXEL OF oDlgEsp SIZE 10,7

	@ aPos[1]+25,75 	SAY 	"Horário" 																			PIXEL OF oDlgEsp SIZE 70,7
	@ aPos[1]+25,100 	MSGET 	oGetRod 	VAR cRodada  	PICTURE "99:99" VALID !Empty(cRodada) 		WHEN .T. 	PIXEL OF oDlgEsp SIZE 10,7

	@ aPos[1]+25,143 	SAY 	"Autoclave" 																		PIXEL OF oDlgEsp SIZE 70,7
	@ aPos[1]+25,180 	MSGET 	oGetAutC 	VAR cAutoClave  PICTURE "99" 	VALID !Empty(cAutoClave) 	WHEN .T. 	PIXEL OF oDlgEsp SIZE 15,7

	@ aPos[1]+25,210 	SAY 	"Trilho" 																			PIXEL OF oDlgEsp SIZE 70,7
	@ aPos[1]+25,230 	MSGET oGetTri 		VAR cTrilho  	PICTURE "9" 	VALID !Empty(cTrilho) 		WHEN .T. 	PIXEL OF oDlgEsp SIZE 10,7

	@ aPosObj[2,1]-45,   aPosObj[2,2] TO aPosObj[2,3]-40, aPosObj[2,4]-23 MULTILINE MODIFY VALID U_LINOK() FREEZE 1 OBJECT oMult
	@aPosObj[ 2, 3 ]-35, aPosObj[ 2, 4 ]-200 BUTTON oPesq PROMPT '&Pesquisar' SIZE 42,12 PIXEL ACTION DESTA02c()
	DEFINE SBUTTON FROM  aPosObj[2,3]-35, aPosObj[2,4]-130 TYPE 1 ENABLE OF oDlgEsp ACTION If(DESTA02a(),Close(oDlgEsp),NIL)
	DEFINE SBUTTON FROM  aPosObj[2,3]-35, aPosObj[2,4]-80  TYPE 2 ENABLE OF oDlgEsp ACTION If(DESTA02b(),Close(oDlgEsp),NIL)

ACTIVATE DIALOG oDlgEsp CENTERED

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para gravacao dos dados da AutoClave na OP          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DESTA02a()
        
Local lRet := .F.

If MsgYesNo("Confirma gravacao dos dados da Autoclave?","Confirmação")

	lRet := .T.

	Processa({|| GravaSC2()},"Gravando dados da Autoclave...")

Endif	

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para gravacao dos dados da Autoclave na OP          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaSC2()
                        
Local nX, cBico, cNum, cItem
Local cLoteFim 	:= TMP->LOTEMIN
Local lFim		:= .F.

For nX:=1 To Len(aCols)
	cBico		:= aCols[nX , 01]
	cNum   		:= aCols[nX , 02]
	cItem  		:= aCols[nX , 03]  
	If ! Empty(cBico) .And. ! Empty(cNum) 
		dbSelectArea("SC2")
		dbSetOrder(1)
		MsSeek(xFilial("SC2")+cNum+cItem+'001')
	    If ! Eof()
	    	RecLock("SC2",.F.)                   
		    SC2->C2_XACLAVE 	:= cAutoClave
		    SC2->C2_XNUMLOT 	:= cLote
		    SC2->C2_XNUMROD 	:= cNumRodada
		    SC2->C2_XRODADA 	:= cRodada
		    SC2->C2_XTRILHO 	:= cTrilho
		    SC2->C2_XBICO   	:= cBico
			SC2->C2_X_STATU		:= "5"     // autoclave  	 
		 	SC2->C2_XDTCLAV 	:= cDtAutC 
		  	SC2->C2_XDTLOTE 	:= cDtAutC //Finalizo a producao na entrada da autoclave
	    	MsUnlock()          
	    	If RecLock("ZD3",.T.)    
				ZD3->ZD3_Filial := SC2->C2_Filial
				ZD3->ZD3_NumOP	:= SC2->C2_Num
				ZD3->ZD3_ItOP	:= SC2->C2_Item
				ZD3->ZD3_TM		:= "5"
				ZD3->ZD3_XDESC	:= "A" + cAutoClave ; 
				                + "-R" + cNumRodada ;
				                + "-B" + cBico ;
				                + "-H" + dtoc(cDtAutC) + "-" + cRodada  
				ZD3->ZD3_EMISSA := dDataBase
				ZD3->ZD3_HORA	:= time()   
				ZD3->( MsUnLock() )
			Endif	
	    Endif 
	    
	    dbSelectArea("SZM")
		dbSetOrder(1)
		IF dbSeek(xFilial("SZM") + cLoteFim )
			IF !lFim
		   		IF MsgYesNo("Encerra a producao?","Confirma?")	        			        	
					lFim := .T.
					RecLock("SZM",.F.)					
				 	IF SZM->ZM_QTDLOTE != 22 
							SZM->ZM_STATUS := "P"
					Else
						SZM->ZM_STATUS  := "E"				 			
					EndIF
					SZM->ZM_X_DTFIM := dDataBase
					SZM->ZM_X_HRFIM := Time()//Finalizo a producao no apontamento da producao
					MsUnlock()
				EndIF
			Endif	
   		Endif
   	EndIF	
Next

IF lFim
	cQry := ""
	cQry += " UPDATE "
	cQry +=  RetSqlName("SC2") + " "
	cQry += " SET C2_XNUMLOT = '' "
	cQry += " WHERE "
	cQry += " C2_XNUMLOT = '" + cLoteFim  + "' AND C2_X_STATU <> '5' "
	//AND C2_XDTLOTE = ''
	TcSqlExec(cQry)
EndIF

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DESTA02b ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para cancelamento dos dados digitados               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DESTA02b()

Local lRet := .F.

If MsgYesNo("Os dados digitados serão perdidos. Confirma?","Confirmação")
	lRet := .T.
Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DESTA02c ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para pesquisar OP                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DESTA02c()

Local oDlgPesq,oGetOP
Local nPos    
Local npOP 	:= 02
Local npIt	:= 03
Local cOp  	:= Space(6)
Local cIt  	:= Space(2)

DEFINE MSDIALOG oDlgPesq TITLE OemToAnsi("Pesquisar") From 12,10 To 17,40 OF oMainWnd

@ 5,08 SAY "Ordem de Serviço" PIXEL OF oDlgPesq SIZE 70,7
@ 5,55 MSGET oGetOP VAR cOp  PICTURE "@!" PIXEL OF oDlgPesq SIZE 15,7

@ 5,87 SAY "Item" PIXEL OF oDlgPesq SIZE 70,7
@ 5,98 MSGET oGetOP VAR cIt  PICTURE "@!" PIXEL OF oDlgPesq SIZE 15,7
	
DEFINE SBUTTON FROM 22,85 TYPE 1 ACTION Close(oDlgPesq) ENABLE OF oDlgPesq

ACTIVATE MSDIALOG oDlgPesq CENTERED

nPos := AScan(aCols,{|x| x[npOP]+x[npIt]==cOp+cIt})

If nPos <> 0
	oMult:oBrowse:nAt := nPos
Endif	

oMult:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VldBico  ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para validacao do campo Bico para gravar marcar     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VldBico(cBico)
Local lRet		:= .T.
Local nX
Local cNumBico 	:= "00"
Local cOp   	:= aCols[n , 02]          
Local cItem		:= aCols[n , 03]
Local Tipo   	:= alltrim(aCols[n , 06])
Local Banda		:= alltrim(aCols[n , 07])
	
If cBico <> "" .and. cBico <> "00" .and. Tipo = "F" .and. Banda = "" 
	MsgStop("Banda Nao Lancada ... OP:" + cOp +  "/" + cItem,"Atenção")  
	lRet := .F.
Else
	For nX:=1 To Len(aCols)
		If ! Empty(cBico) .And. aCols[nX , 01] == cBico .And. nX <> n
			MsgStop("Número de Bico já digitado. Verifique.","Atenção")
			lRet 	:= .F.
			Exit
		Endif
		If ! Empty(aCols[nX , 01])
			If aCols[nX, 01] > cNumBico
				cNumBico := aCols[nX, 01]
			Endif	
		Endif
	Next

	If Empty(cBico)
		cBico          		:= Soma1(cNumBico,2)
		aCols[n , 01] 		:= cBico
	Endif	

	If cBico=="00"
		cBico          		:= Space(2)
		M->BICO             := cBico
		aCols[n , 01] 		:= cBico
	Endif 	
Endif                  

Return( lRet )	


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LinOk    ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para validacao da linha, para nao permitir em branco³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LinOk()

Local nX
Local lRet  	:= .T.
Local cBico 	:= alltrim(aCols[n , 01])
Local cOp   	:= aCols[n , 02]         
Local cItem		:= aCols[n , 03]
Local Tipo   	:= alltrim(aCols[n , 06])
Local Banda		:= alltrim(aCols[n , 07])
	
If cBico <> "" .and. Tipo = "F" .and. Banda = ""
	MsgStop("Banda Nao Lancada ... OP:" + cOp +  "/" + cItem,"Atenção")
	lRet 		:= .F.
Endif

If ! Empty(cBico) .And. Empty(cOp)
	MsgStop("Novas linhas não podem ser incluidas.","Atenção")
	ADel(aCols,n)
	aCols		:=ASize(aCols,n-1)
	n			:=n-1
Endif    

For nX:=1 To Len(aCols)
	If ! Empty(cBico) .And. aCols[nX , 01] == cBico .And. nX <> n
		MsgStop("Número de Bico já digitado. Verifique.","Atenção")
		lRet 	:= .F.
		Exit
	Endif
Next
	
Return(lRet)	
