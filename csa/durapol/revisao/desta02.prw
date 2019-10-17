#Include 'rwmake.ch'
#Include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DESTA02  � Autor � Jader                 � Data �18.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para Informe dos dados da Autoclave                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � DuraPol                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Alteracao�  Programacao da producao 16/12/05 Reinaldo Caldas          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DESTA02()
                         
Local cQuery        := ""
Local oGetDe,oGetAte,oGetRod,oGetAutc,oGetTri,oGetNRod,oPesq
Local _nX
Local aObjects := {}
Local aSize    := {}
Local aInfo    := {}
Local aPosObj  := {}
Local _aPos    := {}

//-- GetDados
Private aHeader	    := {}
Private aCols		:= {}

//-- Outras variaveis
Private dDataDe     := CtoD("")
Private dDataAte    := CtoD("")
Private cAutoClave  := Space(2)
Private cTrilho     := Space(1)
Private cNumRodada  := Space(2)
Private cRodada     := Space(5)
Private cBico       := Space(2)
Private aRegs       := {}
Private cPerg       := "ESTA02"
Private cCadastro   := "Autoclave"
Private aRotina     := {}
Private cMarca      := GetMark()
Private oDlgEsp,oMult     
Private _aCampos := {}
Private lLote       := .F. //Considera somente lote de producao

              
//-- cria grupo de perguntas no SX1
aRegs:={}
AAdd(aRegs,{cPerg,"01","Producao De?"   ,"Producao De?"   ,"Producao De?"   ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"02","Producao Ate?"  ,"Producao Ate?"  ,"Producao Ate?"  ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)

//-- faz pergunta
Pergunte(cPerg,.T.)

dDataDe  := mv_par01
dDataAte := mv_par02
                                                                                        
AAdd( aHeader, { "Nr.Bico", "CBICO", "99",  2, 0, "U_VldBico(cBico)" , , "C", , } )
AAdd( _aCampos, "CBICO" )

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC2")

While !Eof() .And. SX3->X3_ARQUIVO == "SC2"
	If SX3->X3_BROWSE == "S" .And. SX3->X3_CONTEXT <> "V"
		AAdd( aHeader, { SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE,  SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F." , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
		AAdd( _aCampos, SX3->X3_CAMPO )
	Endif
	dbSkip()
Enddo

//-- posicona neste campo que e' visual para nao pemitir a alteracao dos campos do acols
dbSetOrder(2)
MsSeek("C2_XNREDUZ")

For _nX:=2 To Len(aHeader)
	aHeader[_nX,2] := SX3->X3_CAMPO
Next

	IF Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIF	
	_cQry := "Select MIN(C2_XNUMLOT) LOTEMIN "
	_cQry += " From " + RetSqlName("SC2")+ " SC2 "          
	_cQry += " Where C2_XNUMLOT <> '' AND C2_QUJE = 0 AND "
	_cQry += " SC2.D_E_L_E_T_ = ' ' "
	_cQry += " and C2_FILIAL = '" + xFilial("SC2") + "' "
	
	_cQry := ChangeQuery(_cQry)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TMP",.F.,.T.)
	dbSelectArea("TMP")
	dbGoTop()
	While ! Eof()
		cLote := TMP->LOTEMIN
		Exit
	EndDo
	
	IF Empty(cLote)
		cLote := '000001'
	EndIF
	
	
	IF Aviso("Encerramento de Producao ","O lote de produ��o " + cLote + " pode n�o conter as 22 Ordens de Produ��es.As OP's apresentadas ser�o somente deste lote.",{"Continuar","Sair"})==1
		lLote :=.T.
	Else
		MsgInfo("Favor realizar a devida manutencao no lote " + cLote + " para o seu encerramento.","Aten��o!!")
		Return	 
		
	EndIF

dbSelectArea("SC2")
dbSetOrder(1)

IF Select("TRBSC2") > 0
	TRBSC2->(dbCloseArea())
EndIF	

cQuery := "SELECT * FROM " + RetSqlName("SC2")
cQuery += " WHERE C2_FILIAL = '" + xFilial('SC2') + "' "
cQuery += "   AND C2_DATPRI >= '" + DtoS(dDataDe) + "' "        
cQuery += "   AND C2_DATPRI <= '" + DtoS(dDataAte) + "' "        
cQuery += "   AND C2_X_STATU <> '7' "
cQuery += "   AND C2_QUANT <> C2_QUJE "
cQuery += "   AND C2_XACLAVE = '  ' "
IF lLote
	cQuery += "   AND C2_XNUMLOT = '' "
EndIF
cQuery += "   AND D_E_L_E_T_ = ' '"
cQuery += " ORDER BY C2_XNUMLOT, C2_X_ORDEM, C2_DATPRF, C2_NUM, C2_ITEM, C2_SEQUEN "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), "TRBSC2", .F., .F. )
  
dbGoTop()

While !Eof()
	                    
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+TRBSC2->C2_PRODUTO)
	
	AAdd( aCols, Array( Len( aHeader ) + 1 ) )

	aCols[Len( aCols ), 1 ] := Space(2)

	For _nX:=1 To Len(_aCampos)
		If _aCampos[_nX]<>"CBICO"        
			If aHeader[_nX,8]=="D" 
				_cCampo := "STOD(TRBSC2->"+Alltrim(_aCampos[_nX])+")"
			Else
				_cCampo := "TRBSC2->"+Alltrim(_aCampos[_nX])
			Endif	
			aCols[Len( aCols ), _nX ] := &(_cCampo)
		Endif	
	Next

	aCols[Len( aCols ),Len( aHeader ) + 1] := .F.
	         
	dbSelectArea("TRBSC2")
	dbSkip() 

EndDo	

TRBSC2->( dbCloseArea() )

If Empty( aCols )
	Aadd( aCols, Array( Len( aHeader ) + 1 ) )
	For _nX:=1 To Len(aHeader)
		If aHeader[_nX,8] == "C"
			xConteudo := Space(aHeader[_nX,4])
		ElseIf aHeader[_nX,8] == "N"
			xConteudo := 0
		ElseIf aHeader[_nX,8] == "D"
			xConteudo := CtoD("")
		Else
			xConteudo := ""	
		Endif
		aCols[Len( aCols ), _nX ] := xConteudo
	Next	
	aCols[1,Len(aHeader)+1] := .F.
EndIf

//-- Calcula as dimensoes dos objetos
aSize  := MsAdvSize(.T.)

AAdd( aObjects, { 100,40,.T.,.T. } )
AAdd( aObjects, { 100,60,.T.,.T. } )

aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4], 0, 0 }
aPosObj:= MsObjSize( aInfo, aObjects, .T. )

dbSelectArea("SC2")

_aPos := {}
AAdd(_aPos,aPosObj[1,1]-12)
AAdd(_aPos,aPosObj[1,2])
AAdd(_aPos,aPosObj[1,3]-113.6)
AAdd(_aPos,aPosObj[1,4]-445.7)

@ aSize[7]+20,00 TO aSize[6]-20,aSize[5]-50 DIALOG oDlgEsp TITLE cCadastro

	@ _aPos[1]+10,08 SAY "Entrega De" PIXEL OF oDlgEsp SIZE 70,7
	@ _aPos[1]+10,40 MSGET oGetDe VAR dDataDe PICTURE "@D" WHEN .F. PIXEL OF oDlgEsp SIZE 20,7

	@ _aPos[1]+10,85 SAY "Ate" PIXEL OF oDlgEsp SIZE 70,7
	@ _aPos[1]+10,100 MSGET oGetAte VAR dDataAte PICTURE "@D" WHEN .F. PIXEL OF oDlgEsp SIZE 20,7

	@ _aPos[1]+25,08 SAY "Rodada" PIXEL OF oDlgEsp SIZE 70,7
	@ _aPos[1]+25,40 MSGET oGetNRod VAR cNumRodada  PICTURE "99" VALID ! Empty(cNumRodada) WHEN .T. PIXEL OF oDlgEsp SIZE 10,7

	@ _aPos[1]+25,75 SAY "Hor�rio" PIXEL OF oDlgEsp SIZE 70,7
	@ _aPos[1]+25,100 MSGET oGetRod VAR cRodada  PICTURE "99:99" VALID ! Empty(cRodada) WHEN .T. PIXEL OF oDlgEsp SIZE 10,7

	@ _aPos[1]+25,143 SAY "Autoclave" PIXEL OF oDlgEsp SIZE 70,7
	@ _aPos[1]+25,180 MSGET oGetAutC VAR cAutoClave  PICTURE "99" VALID ! Empty(cAutoClave) WHEN .T. PIXEL OF oDlgEsp SIZE 15,7

	@ _aPos[1]+25,210 SAY "Trilho" PIXEL OF oDlgEsp SIZE 70,7
	@ _aPos[1]+25,230 MSGET oGetTri VAR cTrilho  PICTURE "9" VALID ! Empty(cTrilho) WHEN .T. PIXEL OF oDlgEsp SIZE 10,7

	@ aPosObj[2,1]-45, aPosObj[2,2] TO aPosObj[2,3]-40, aPosObj[2,4]-23 MULTILINE MODIFY VALID U_LINOK() FREEZE 1 OBJECT oMult
	@aPosObj[ 2, 3 ]-35, aPosObj[ 2, 4 ]-200 BUTTON oPesq PROMPT '&Pesquisar' SIZE 42,12 PIXEL ACTION DESTA02c()
	DEFINE SBUTTON FROM aPosObj[2,3]-35, aPosObj[2,4]-130 TYPE 1 ENABLE OF oDlgEsp ACTION If(DESTA02a(),Close(oDlgEsp),NIL)
	DEFINE SBUTTON FROM aPosObj[2,3]-35, aPosObj[2,4]-80  TYPE 2 ENABLE OF oDlgEsp ACTION If(DESTA02b(),Close(oDlgEsp),NIL)

ACTIVATE DIALOG oDlgEsp CENTERED

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DESTA02a � Autor � Jader                 � Data �18.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para gravacao dos dados da AutoClave na OP          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DESTA02a()
        
Local _lRet := .F.

If MsgYesNo("Confirma gravacao dos dados da Autoclave?","Confirma��o")

	_lRet := .T.

	Processa({|| GravaSC2()},"Gravando dados da Autoclave...")

Endif	

Return(_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GravaSC2 � Autor � Jader                 � Data �18.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para gravacao dos dados da Autoclave na OP          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GravaSC2()
                        
Local _nX,_cNum,_cItem,_cSeq,_cBico,_cMarca
Local cLoteFim := TMP->LOTEMIN
Local lFim := .F.

ProcRegua(Len(aCols))

For _nX:=1 To Len(aCols)

	_cBico  := aCols[_nX,AScan(_aCampos,"CBICO")]
	_cNum   := aCols[_nX,AScan(_aCampos,"C2_NUM")]
	_cItem  := aCols[_nX,AScan(_aCampos,"C2_ITEM")]
	_cSeq   := aCols[_nX,AScan(_aCampos,"C2_SEQUEN")]
	
	If ! Empty(_cBico) .And. ! Empty(_cNum)

		IncProc("OP "+_cNum+_cItem+_cSeq)
		
		dbSelectArea("SC2")
		dbSetOrder(1)
		MsSeek(xFilial("SC2")+_cNum+_cItem+_cSeq)
	    
	    If ! Eof()
	    	RecLock("SC2",.F.)                   
		    	SC2->C2_XACLAVE := cAutoClave
		    	SC2->C2_XNUMLOT := cLote
		    	SC2->C2_XNUMROD := cNumRodada
		    	SC2->C2_XRODADA := cRodada
		    	SC2->C2_XTRILHO := cTrilho
		    	SC2->C2_XBICO   := _cBico
				SC2->C2_X_STATU	:= "5"  // autoclave  	 
		    	SC2->C2_XDTCLAV := dDataBase 
		    	SC2->C2_XDTLOTE := dDataBase //Finalizo a producao na entrada da autoclave
	    	MsUnlock()
	    Endif
	    
	    dbSelectArea("SZH")
		dbSetOrder(1)
		IF dbSeek(xFilial("SZH") + cLoteFim )
			IF !lFim
		    	IF MsgYesNo("Encerra a producao?","Confirma?")	        			        	
					lFim := .T.
					RecLock("SZH",.F.)					
					 	IF SZH->ZH_QTDLOTE != 22 
								SZH->ZH_STATUS := "P"
						Else
							SZH->ZH_STATUS  := "E"				 			
						EndIF
						SZH->ZH_X_HRFIM := cRodada //Finalizo a producao no apontamento da producao
					MsUnlock()
				EndIF
			EndIF
   	 	Endif
   	EndIF	
Next

IF lFim
	_cQry := ""
	_cQry += " UPDATE "
	_cQry +=  RetSqlName("SC2") + " "
	_cQry += " SET C2_XNUMLOT = '' "
	_cQry += " WHERE "
	_cQry += " C2_XNUMLOT = '" + cLoteFim  + "' AND C2_XDTLOTE = '' AND C2_X_STATU <> '5' "
	
	TcSqlExec(_cQry)
	
EndIF

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DESTA02b � Autor � Jader                 � Data �18.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para cancelamento dos dados digitados               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DESTA02b()

Local _lRet := .F.

If MsgYesNo("Os dados digitados ser�o perdidos. Confirma?","Confirma��o")
	_lRet := .T.
Endif

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DESTA02c � Autor � Jader                 � Data �18.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para pesquisar OP                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DESTA02c()

Local oDlgPesq,oGetOP
Local _nPos
Local _npOP := AScan(_aCampos,"C2_NUM")
Local _npIt := AScan(_aCampos,"C2_ITEM")
Local _cOp  := Space(6)
Local _cIt  := Space(2)

DEFINE MSDIALOG oDlgPesq TITLE OemToAnsi("Pesquisar") From 12,10 To 17,40 OF oMainWnd

@ 5,08 SAY "Ordem de Servi�o" PIXEL OF oDlgPesq SIZE 70,7
@ 5,55 MSGET oGetOP VAR _cOP  PICTURE "@!" PIXEL OF oDlgPesq SIZE 15,7

@ 5,87 SAY "Item" PIXEL OF oDlgPesq SIZE 70,7
@ 5,98 MSGET oGetOP VAR _cIt  PICTURE "@!" PIXEL OF oDlgPesq SIZE 15,7
	
DEFINE SBUTTON FROM 22,85 TYPE 1 ACTION Close(oDlgPesq) ENABLE OF oDlgPesq

ACTIVATE MSDIALOG oDlgPesq CENTERED

_nPos := AScan(aCols,{|x| x[_npOP]+x[_npIt]==_cOP+_cIt})

If _nPos <> 0
	oMult:oBrowse:nAt := _nPos
Endif	

oMult:Refresh()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � VldBico  � Autor � Jader                 � Data �18.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para validacao do campo Bico para gravar marcar     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VldBico(cBico)

Local _nX
Local _cNumBico := "00"
Local _nPos     := AScan(_aCampos,"CBICO")

For _nX:=1 To Len(aCols)
	If ! Empty(aCols[_nX,_nPos])
		If aCols[_nX,_nPos] > _cNumBico
			_cNumBico := aCols[_nX,_nPos]
		Endif	
	Endif
Next

If Empty(cBico)
	cBico          := Soma1(_cNumBico,2)
	aCols[n,_nPos] := cBico
Endif	

If cBico=="00"
	cBico          := Space(2)
	aCols[n,_nPos] := cBico
Endif 	

Return(.T.)	


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LinOk    � Autor � Jader                 � Data �18.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para validacao da linha, para nao permitir em branco���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LinOk()

Local _nX
Local _lRet  := .T.
Local _nPos  := AScan(_aCampos,"CBICO")
Local _cBico := aCols[n,_nPos]
Local _cOP   := aCols[n,AScan(_aCampos,"C2_NUM")]

If ! Empty(_cBico) .And. Empty(_cOP)
	MsgStop("Novas linhas n�o podem ser incluidas.","Aten��o")
	ADel(aCols,n)
	aCols:=ASize(aCols,n-1)
	n:=n-1
Endif    

For _nX:=1 To Len(aCols)
	If ! Empty(_cBico) .And. aCols[_nX,_nPos] == _cBico .And. _nX <> n
		MsgStop("N�mero de bico j� digitado. Verifique.","Aten��o")
		_lRet := .F.
		Exit
	Endif
Next
	
Return(_lRet)	
