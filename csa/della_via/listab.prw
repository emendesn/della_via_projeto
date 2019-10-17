#include "Protheus.ch"
#INCLUDE "VKEY.CH"

#define LIM_LINHAS 58

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LISTAB   º Autor ³ Alexandre Martim   º Data ³  30/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Este programa tem como objetivo otimizar por coordenador   º±±
±±º          ³DellaVia a listar determinados produtos selecionados pelo   º±±
±±º          ³mesmo, sendo que podera ver somente as tabelas amarradas a  º±±
±±º          ³seu grupo de atendimento (SU0).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºArquivos  ³ SZJ -> Arquivo personalizado contendo a lista de produtos  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico DellaVia                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LISTAB()
     //
     Local cPerg := "LISTAB"
     Private _cAlias,_cOrder,_cRec,cOpcao, _lPrimeiravez:=.t., _lInclui:=.f., _nTipo:=0,;
             _cGrupo, _cGrupos, _cCond:=""
     //
     _cAlias := Alias()
     _cOrder := IndexOrd()
     _cRec   := Recno()
     //
     // Habilita Parametros
     //
     Perg(cPerg)
     pergunte(cPerg,.F.)
     SetKey( VK_F12, { || pergunte(cPerg,.T.) } )
     //
     cCadastro := "Lista de Produtos"
     //
     aRotina := { { "Pesquisar" ,"AxPesqui"	    ,0,1},;
	         	  { "Visualizar",'U_LisTabA(2)' ,0,2},;
	    	  	  { "Incluir"   ,'U_LisTabI()'  ,0,3},;
	      		  { "Alterar"   ,'U_LisTabA(4)' ,0,4},;
			      { "Excluir"   ,'U_LisTabA(5)' ,0,5},;
		      	  { "Imprimir"  ,'U_ImpList()' ,0,6} }
	 //	    
     _cGrupo  := ""
     _cGrupos := ""
     DbSelectArea("SU7")
     DbSetOrder(4)              
     DbGotop()
     If DbSeek(xFilial("SU7")+__cUserId)
        _cGrupo	:= SU7->U7_POSTO
     Endif	                            
     //
     If !Empty(_cGrupo)
        _aAreaSU7 := GetArea("SU7")
        _cGrupos  := ""	
        DbSelectArea("SU7")
        DbGoTop()
        Do While !Eof()
		   //
           If SU7->U7_POSTO == _cGrupo
              _cGrupos 	+= SU7->U7_CODUSU+"/"
           Endif
		   //
           DbSkip()
	       //
        Enddo
        //
        If !Empty(_cGrupos)
           _cCond := "SZJ->ZJ_FILIAL = '"+xFilial("SZJ")+"' .And. SZJ->ZJ_OPERADO $ '"+_cGrupos+"' "
        Endif
	    //
	 Endif
	 //
     dbSelectArea("SZJ")
     dbSetOrder(1)
     //If !cNivel > 5
        Set Filter To &_cCond
        DbGoTop()
     //Endif	
     //
     mBrowse( 10,50,222,600,"SZJ")
     //
     //If !cNivel > 5
        Set Filter To
        DbGoTop()
     //Endif
     //
     SetKey( VK_F12, Nil )
     //
     dbSelectArea(_cAlias)
     dbSetOrder(_cOrder)
     dbGoto(_cRec)
     //
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LISTABI  º Autor ³ Alexandre Martim   º Data ³  30/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Programa para controlar a manutencao de lista de produtos  º±±
±±º          ³ INCLUSAO                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico DellaVia                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºArquivos  ³ SZJ -> Arquivo personalizado contendo a lista de produtos  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LISTABI()
     //
     Local lGravou	:= .F.
     Local nX       := 0
     Local nUsado	:= 0
     Local nPosItem := 0
     Local nOpcA	:= 0
     Local nOpc 	:= 3
     Local aGet		:= {}
     Local oDlg
     Local oGetD 
     Local aObjects  := {} 
     Local aPosObj   := {} 
     Local aSizeAut  := MsAdvSize()
     //
     Private aCols	 := {}
     Private _aClone := {}
     Private aHeader := {}
     Private _cTab   := ""
     Private _aTabs  := {}
     //
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Cria variaveis M->????? da Enchoice                          ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     Private M->ZJ_LISTA   := CriaVar("ZJ_LISTA")
     Private M->ZJ_TABELA  := CriaVar("ZJ_TABELA")
     Private M->ZJ_DESCRI  := CriaVar("ZJ_DESCRI")
     //
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³Montagem do Array do Cabecalho                                          ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     dbSelectArea("SX3")
     dbSetOrder(2)
     dbSeek("ZJ_LISTA")
     aadd(aGet,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
     dbSelectArea("SX3")
     dbSetOrder(2)
     dbSeek("ZJ_TABELA")
     aadd(aGet,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,"DA0"})
     dbSelectArea("SX3")
     dbSetOrder(2)
     dbSeek("ZJ_DESCRI")
     aadd(aGet,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
     //
     _cCampos_nao_Editaveis := "ZJ_LISTA,ZJ_OPERADO,ZJ_TABELA,ZJ_DESCTAB,ZJ_DESCRI"
     //
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Montando aHeader                                             ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     dbSelectArea("SX3")
     dbSetOrder(1)
     dbSeek("SZJ",.F.)
     nUsado:=0
     aHeader:={}
     Do While !Eof() .And. (x3_arquivo == "SZJ")
        If AllTrim(X3_CAMPO)=="ZJ_FILIAL"
           dbSkip()
           Loop
        Endif
        IF X3USO(x3_usado) .AND. cNivel >= x3_nivel  .AND. !(AllTrim(x3_campo) $ _cCampos_nao_Editaveis)
         	nUsado:=nUsado+1
            AADD(aHeader,{ TRIM(x3_titulo), AllTrim(x3_campo), x3_picture,;
                    x3_tamanho, x3_decimal,x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context } )
     		If ( AllTrim(SX3->X3_CAMPO)=="ZJ_ITEM" )
	    		nPosItem := nUsado
		    Endif
        Endif
        dbSkip()
     Enddo
     //
     If Len(aCols) = 0
        aCols := { Array(nUsado+1) }
        aCols[1,nUsado+1] := .F.
        For x:=1 to nUsado
            aCols[1, x] := If(AllTrim(Upper(aHeader[x,2])) == "ZJ_ITEM",StrZero(1,3),CriaVar(aHeader[x,2]))
        Next
     Endif
     //
     AAdd( aObjects, { 100,  20, .T., .F. } )
     AAdd( aObjects, { 315,  70, .T., .T. } )
     aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
     aPosObj := MsObjSize( aInfo, aObjects )
     _lInclui:=.t.
     //
     M->ZJ_LISTA   := GetSx8Num( "SZJ", "ZJ_LISTA" )
     M->ZJ_OPERADO := __cUserId
     //
     dbSelectArea("PAP")
     dbSetOrder(1)
     If dbSeek(xFilial("PAP")+_cGrupo,.F.)
        Do While !Eof() .and. xFilial("PAP")==PAP->PAP_FILIAL .and. PAP->PAP_GRPATD==_cGrupo
           DbSelectArea("DA0")
           DbSetOrder(1)
           If DbSeek(xFilial("DA0")+PAP->PAP_CODTAB,.f.)
              If DA0_ATIVO = "1"
                 aadd(_aTabs, PAP->PAP_CODTAB+"-"+DA0->DA0_DESCRI)
              Endif
           Endif
           dbSelectArea("PAP")
           DbSkip()
        Enddo
     Endif
     //
     DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
            //
            @ 018,010 SAY aGet[1][1] 	  SIZE 030,011 	OF oDlg PIXEL
            @ 018,040 MSGET M->ZJ_LISTA   SIZE 040,011 	OF oDlg PIXEL ;
			PICTURE "@!" ;
        	VALID (ExistChav("SZJ",M->ZJ_LISTA)) ;
			WHEN VisualSX3('ZJ_LISTA') ;
			F3 aGet[1][3]
			//
            @ 018,095 SAY aGet[2][1]   SIZE 030,011 	OF oDlg PIXEL
            @ 018,120 MSCOMBOBOX oCbx  VAR _cTab ITEMS _aTabs SIZE 110,040 OF oDlg PIXEL ;
              VALID (ExistChav("SZJ",M->ZJ_LISTA+M->ZJ_OPERADO+left(_cTab,3))) ;
			//
            @ 018,245 SAY aGet[3][1] 	 SIZE 030,011  OF oDlg PIXEL
            @ 018,280 MSGET M->ZJ_DESCRI SIZE 105,011  OF oDlg PIXEL PICTURE "@S40" ;
			VALID CheckSX3('ZJ_DESCRI') ;
			WHEN VisualSX3('ZJ_DESCRI') ;
			F3 aGet[3][3]
			//
            oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_LISTABLinOk","U_LISTABTudOk","+ZJ_ITEM",.T.,,,,9999,"U_LISTABFieldOk")
     ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})
     //
     If ( nOpcA == 1 )
          Begin Transaction
             lGravou := LISTABGrava(1)
          End Transaction
     EndIf
     //
Return(lGravou)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LISTABA  º Autor ³ Alexandre Martim   º Data ³  30/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Programa para controlar a manutencao de lista de produtos  º±±
±±º          ³ ALTERACAO/VISUALIZACAO/EXCLUSAO                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico DellaVia                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºArquivos  ³ SZJ -> Arquivo personalizado contendo a lista de produtos  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LISTABA(_nT)
     //
     Local lGravou	:= .F.
     Local nX       := 0
     Local nUsado	:= 0
     Local nPosItem := 0
     Local nOpcA	:= 0
     Local nOpc 	:= Iif(_nT==5,2,_nT)
     Local aGet		:= {}
     Local nPosSZJ  := 0
     Local oDlg
     Local oGetD 
     Local aObjects  := {} 
     Local aPosObj   := {} 
     Local aSizeAut  := MsAdvSize()
     //
     Private aCols	 := {}
     Private _aClone := {}
     Private aHeader := {}
     Private _cTab   := SZJ->ZJ_TABELA
     Private _aTabs  := {}
     //
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Cria variaveis M->????? da Enchoice                          ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     Private M->ZJ_LISTA   := SZJ->ZJ_LISTA
     Private M->ZJ_TABELA  := SZJ->ZJ_TABELA
     Private M->ZJ_DESCRI  := SZJ->ZJ_DESCRI
     Private M->ZJ_OPERADO := SZJ->ZJ_OPERADO
     //
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³Montagem do Array do Cabecalho                                          ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     dbSelectArea("SX3")
     dbSetOrder(2)
     dbSeek("ZJ_LISTA")
     aadd(aGet,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
     dbSelectArea("SX3")
     dbSetOrder(2)
     dbSeek("ZJ_TABELA")
     aadd(aGet,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,"DA0"})
     dbSelectArea("SX3")
     dbSetOrder(2)
     dbSeek("ZJ_DESCRI")
     aadd(aGet,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
     //
     _cCampos_nao_Editaveis := "ZJ_LISTA,ZJ_OPERADO,ZJ_TABELA,ZJ_DESCTAB,ZJ_DESCRI"
     //
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Montando aHeader                                             ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     dbSelectArea("SX3")
     dbSetOrder(1)
     dbSeek("SZJ",.F.)
     nUsado:=0
     aHeader:={}
     Do While !Eof() .And. (x3_arquivo == "SZJ")
        If AllTrim(X3_CAMPO)=="ZJ_FILIAL"
           dbSkip()
           Loop
        Endif
        IF X3USO(x3_usado) .AND. cNivel >= x3_nivel  .AND. !(AllTrim(x3_campo) $ _cCampos_nao_Editaveis)
         	nUsado:=nUsado+1
            AADD(aHeader,{ TRIM(x3_titulo), AllTrim(x3_campo), x3_picture,;
                    x3_tamanho, x3_decimal,x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context } )
     		If ( AllTrim(SX3->X3_CAMPO)=="ZJ_ITEM" )
	    		nPosItem := nUsado
		    Endif
        Endif
        dbSkip()
     Enddo
     //
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³Montagem do aCols                                                       ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     dbSelectArea("SZJ")
     dbSetOrder(1)
     If dbSeek(xFilial("SZJ")+M->ZJ_LISTA+M->ZJ_OPERADO+_cTab,.f.)
        Do While ( !Eof() .And. xFilial("SZJ") == SZJ->ZJ_FILIAL .and.;
				SZJ->ZJ_LISTA==M->ZJ_LISTA .and. SZJ->ZJ_OPERADO==M->ZJ_OPERADO .and.;
				SZJ->ZJ_TABELA==_cTab )
           If ( SoftLock("SZJ" ) )
              aadd(aCols,Array(nUsado+1))
              For nX := 1 To nUsado
                  If ( aHeader[nX][10] != "V" )              
   			    	If !Empty( nPosSZJ := FieldPos(aHeader[nX][2] ) ) 
   				       aCols[Len(aCols)][nX] := SZJ->(FieldGet( nPosSZJ ) )
                    EndIf 					
                  Else
                       aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
                  EndIf
              Next
              aCols[Len(aCols)][nUsado+1] := .F.
           Else
              lTravas := .T.
           EndIf
           dbSelectArea("SZJ")
           DbSkip()					
        EndDo
     Endif
     //
     AAdd( aObjects, { 100,  20, .T., .F. } )
     AAdd( aObjects, { 315,  70, .T., .T. } )
     aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
     aPosObj := MsObjSize( aInfo, aObjects )
     _lInclui:=.f.
     _nTipo:=_nT
     //
     dbSelectArea("PAP")
     dbSetOrder(1)
     If dbSeek(xFilial("PAP")+_cGrupo,.F.) .and. !Empty(_cGrupo)
        Do While !Eof() .and. xFilial("PAP")==PAP->PAP_FILIAL .and. PAP->PAP_GRPATD==_cGrupo
           DbSelectArea("DA0")
           DbSetOrder(1)
           If DbSeek(xFilial("DA0")+PAP->PAP_CODTAB,.f.)
              If _cTab==PAP->PAP_CODTAB
                  _cTab:=PAP->PAP_CODTAB+"-"+DA0->DA0_DESCRI
              Endif
              aadd(_aTabs, PAP->PAP_CODTAB+"-"+DA0->DA0_DESCRI)
           Endif
           dbSelectArea("PAP")
           DbSkip()
        Enddo
     Else
        MsgAlert("A tabela gravada nao pertence ao seu grupo de atendimento ["+_cGrupo+"], verifique!")
     Endif
     
     //
     DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
            //
            @ 018,010 SAY aGet[1][1] 	  SIZE 030,011 	OF oDlg PIXEL
            @ 018,040 MSGET M->ZJ_LISTA   SIZE 040,011 	OF oDlg PIXEL ;
			PICTURE "@!" ;
        	VALID CheckSX3('ZJ_LISTA') ;
			WHEN .f.;
			F3 aGet[1][3]
			//
            @ 018,095 SAY aGet[2][1]   SIZE 030,011 	OF oDlg PIXEL
            @ 018,120 MSCOMBOBOX oCbx  VAR _cTab ITEMS _aTabs SIZE 110,040 OF oDlg PIXEL WHEN .f.
			//
            @ 018,245 SAY aGet[3][1] 	 SIZE 030,011 	OF oDlg PIXEL
            @ 018,280 MSGET M->ZJ_DESCRI SIZE 105,011 	OF oDlg PIXEL PICTURE "@S40";
			VALID CheckSX3('ZJ_DESCRI') ;
			WHEN VisualSX3('ZJ_DESCRI') ;
			F3 aGet[3][3]
			//
            oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_LISTABLinOk","U_LISTABTudOk","+ZJ_ITEM",.T.,,,,9999,"U_LISTABFieldOk")
     ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})
     //
     //
     If ( nOpcA == 1 )
          If _nTipo <> 2
             Begin Transaction
                lGravou := LISTABGrava(Iif(_nTipo==5,3,2))
             End Transaction
          Endif
     EndIf
     //
Return(lGravou)


Static Function LISTABGrava(nOpcao)
        //
		Local aArea    := GetArea()
		Local nUsado   := Len(aHeader)
		Local nPosItem := aScan(aHeader,{|x| AllTrim(x[2])=="ZJ_ITEM" })
		Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="ZJ_PRODUTO" })
		Local nPosSZJ  := 0 
		Local nX       := 0
		Local nY       := 0
		Local lGravou  := .F.
		Local lnovo    := .F.
        //
		Do Case
			Case ( nOpcao <> 3 )
				For nX := 1 To Len(aCols)
					If ( !aCols[nX][nUsado+1] )
						dbSelectArea("SZJ")
						dbSetOrder(1)
						If ( dbSeek(xFilial("SZJ")+M->ZJ_LISTA+M->ZJ_OPERADO+M->ZJ_TABELA+aCols[nX][nPosProd]) )
							RecLock("SZJ",.F.)
						Else
							RecLock("SZJ",.T.)
                            lnovo := .F.
						EndIf
						For nY := 1 To nUsado
							If ( aHeader[nY][10] != "V" )
								If !Empty( nPosSZJ := FieldPos(aHeader[nY][2]) )
									SZJ->(FieldPut( nPosSZJ ,aCols[nX][nY]))	
								EndIf 							
							EndIf
						Next nY
						SZJ->ZJ_FILIAL	:= xFilial("SZJ")
						SZJ->ZJ_LISTA	:= M->ZJ_LISTA
						SZJ->ZJ_TABELA 	:= _cTab
						SZJ->ZJ_DESCRI 	:= M->ZJ_DESCRI
						SZJ->ZJ_OPERADO := M->ZJ_OPERADO
						lGravou := .T.
						If lnovo
						   ConfirmSx8()
						Endif
					Else
						dbSelectArea("SZJ")
						dbSetOrder(1)
						If ( dbSeek(xFilial("SZJ")+M->ZJ_LISTA+M->ZJ_OPERADO+M->ZJ_TABELA+aCols[nX][nPosProd]) )
							RecLock("SZJ")
							dbDelete()
						EndIf
					EndIf
				Next nX
			OtherWise
				For nX := 1 To Len(aCols)
					dbSelectArea("SZJ")
					dbSetOrder(1)
					If ( dbSeek(xFilial("SZJ")+M->ZJ_LISTA+M->ZJ_OPERADO+M->ZJ_TABELA+aCols[nX][nPosProd]) )
						RecLock("SZJ")
						dbDelete()
					EndIf
				Next nX
		EndCase
		RestArea(aArea)
		//
Return(lGravou)


User Function LISTABLinOk()
        //
		Local nUsado   := Len(aHeader)
		Local lRetorno := .T.
		Local _nPos
		Local nPosProd := Ascan(aHeader,{|x| AllTrim(x[2])=="ZJ_PRODUTO"})
        Local _nPosDel := Len(aHeader) + 1
        //
		If !GDDeleted() 
           //
           _nPos := aScan(aCols,{|x| x[nPosProd]==aCols[n, nPosProd] })
           //
           If _nPos > 0 .and. _nPos <> n .and. !aCols[n,_nPosDel]
              Alert("Este Produto ja foi lancado nesta Lista, verifique!")
              Return .F.
           Endif
	       //
           DbSelectArea("DA1")
           DbSetOrder(1)
           If !DbSeek(xFilial("DA1")+Left(_cTab,3)+aCols[n, nPosProd],.f.)
              Alert("Este Produto nao pertence a tabela selecionada, verifique!")
              Return .F.
           Endif
           //
		EndIf
		//
Return(lRetorno)


User Function LISTABFieldOk()
        //
	    //
Return(.T.)


User Function LISTABTudOk()
        //
		Local lRetorno := .T.
		Local nPosProd := Ascan(aHeader,{|x| AllTrim(x[2])=="ZJ_PRODUTO"})
		//
		If !GDDeleted() 
           //
           For _n:=1 to Len(aCols)
               //
               DbSelectArea("DA1")
               DbSetOrder(1)
               If !DbSeek(xFilial("DA1")+Left(_cTab,3)+aCols[_n, nPosProd],.f.)
                  Alert("Este Produto nao pertence a tabela selecionada, verifique!")
                  Return .F.
               Endif
               //
           Next
           //
        EndIf
		//
Return(.T.)

Static Function Perg(_cPerg)
       //
       Local _cAlias
       //
       _cAlias  := Alias()
       _cPerg   := PADR(_cPerg,6)
       _aRegs    := {}
       //
       dbSelectArea("SX1")
       dbSetOrder(1)
       //
       AADD(_aRegs,{_cPerg,"01","Inclusao Automatica?","","","mv_ch1","N",01,0,0,"C","","mv_par01","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"02","Produto De         ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","               ","","","","","","","","","","","","","","","","","","","","","SB1",""})
       AADD(_aRegs,{_cPerg,"03","Produto Ate        ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1",""})
       //
       For i := 1 to Len(_aRegs)
           If !DbSeek(_cPerg+_aRegs[i,2])
              RecLock("SX1",.T.)
              For j := 1 to FCount()
                  If j <= Len(_aRegs[i])
                     FieldPut(j,_aRegs[i,j])
                  Endif
              Next
              MsUnlock()
           Endif
       Next
       DbSelectArea(_cAlias)
       //
Return

Static Function Perg2(_cPerg)
       //
       Local _cAlias
       //
       _cAlias  := Alias()
       _cPerg   := PADR(_cPerg,6)
       _aRegs    := {}
       //
       dbSelectArea("SX1")
       dbSetOrder(1)
       //
       AADD(_aRegs,{_cPerg,"01","Lista p/ Referencia ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","  ","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"02","Lista a Copiar      ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","  ","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"03","Vendedor De         ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","  ","","","","","","","","","","","","","","","","","","","","","SA3",""})
       AADD(_aRegs,{_cPerg,"04","Vendedor Ate        ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA3",""})
       //
       For i := 1 to Len(_aRegs)
           If !DbSeek(_cPerg+_aRegs[i,2])
              RecLock("SX1",.T.)
              For j := 1 to FCount()
                  If j <= Len(_aRegs[i])
                     FieldPut(j,_aRegs[i,j])
                  Endif
              Next
              MsUnlock()
           Endif
       Next
       DbSelectArea(_cAlias)
       //
Return


User Function ImpList()
    //
	Private cDesc1  := "Relatorio de Lista de precos personalizada.                    "
	Private cDesc2  := "                                                               "
	Private cDesc3  := "Observar os parametros do Relatorio                            "
	Private cString :="SZJ"
	Private limite  := 80
	Private nMoeda, cTexto
    //
	Private wnrel
	Private Titulo  := ""
	Private cabec1  := ""
	Private cabec2  := ""
	Private cabec3  := ""
	Private tamanho := "" // Dependera da Ordem escolhida
	//
    Private aReturn := {"Zebrado",1,"Administracao",1,2,1,"",1}
			//           |        |  |              | | | |  |__ Ordem a ser Selecionada
			//           |        |  |              | | | |_____ Expressao de Filtro
			//           |        |  |              | | |_______ Porta ou Arquivo
			//           |        |  |              | |_________ Midia (Disco/Impressora)
			//           |        |  |              |___________ Formato
			//           |        |  |__________________________ Destinatario
			//           |        |_____________________________ Numero de Vias
			//           |______________________________________ Nome do Formulario
	//
    Private aOrd     := {"por Codigo","por Descricao"}
    //
	Private nomeprog := "LISTAB"
	Private nLastKey := 0
	Private cPerg    := ""
	Private nColun   := 0 
	Private nQuebra  := 5
    Private _cTab    := ""
    //
    #IFNDEF TOP
         Alert("Este Relatorio foi feito especificamente para ambiente TOP CONNECT!")
    #ENDIF
    //
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLinha := LIM_LINHAS
	m_pag   := 1
    dbSelectArea("SZJ")
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Perg(cPerg)
	//pergunte(cPerg,.F.)
	//
	mv_par01 := ""
	mv_par02 := "ZZZZZZZZZZZZZZZ"
	mv_par03 := SZJ->ZJ_LISTA
	//
    dbSelectArea("PAP")
    dbSetOrder(1)
      If dbSeek(xFilial("PAP")+_cGrupo,.F.)
       Do While !Eof() .and. xFilial("PAP")==PAP->PAP_FILIAL .and. PAP->PAP_GRPATD==_cGrupo
          DbSelectArea("DA0")
          DbSetOrder(1)
          If DbSeek(xFilial("DA0")+PAP->PAP_CODTAB,.f.)
             If DA0_ATIVO = "1"
                  If SZJ->ZJ_TABELA==PAP->PAP_CODTAB
                   _cTab:=PAP->PAP_CODTAB+"-"+DA0->DA0_DESCRI
                  Endif
             Else
                If SZJ->ZJ_TABELA==PAP->PAP_CODTAB
                   Aviso("Alerta","Esta Tabela encontra-se desativada para uso!",{"OK"},1,"")
                   Return
                Endif
             Endif
          Endif
          dbSelectArea("PAP")
          DbSkip()
       Enddo
    Endif
   */
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a fun‡„o SETPRINT   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := "LISTAB"  ;	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho,,.T.)
	//
	If nLastKey == 27
		Return
	Endif
    //
	SetDefault(aReturn,cString)
    //
	If nLastKey == 27
		Return
	Endif
    //
    Titulo  := "Lista Nro: "+SZJ->ZJ_LISTA+" Filial: "+SM0->M0_NOME
    Tamanho := "P"
    //
    Processa( {|| FLISTAB(wnRel) }, "Lista de precos..." )
    //
Return


Static Function FLISTAB(wnRel)
       //
       Private cbCont:=0,CbTxt:=Space(10),_lPrimeiraVez:=.t.
       //
       aCampos:={;
 	         {"FILIAL"   , "C" , 02,0},;
  	         {"PRODUTO"  , "C" , 15,0},;
  	         {"DESCRICAO", "C" , 45,0},;
  	         {"PRECO"    , "N" , 13,2} }
       //
       cArqTmp := CriaTrab(aCampos,.T.)
       dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)
       If aReturn[8] == 1
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+PRODUTO",,,"Selecionando Registros...")
       ElseIf aReturn[8] == 2
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+DESCRICAO",,,"Selecionando Registros...")
       Endif
	   //
       // Processa saldos 
       //
        GeraTmp()
       //
       cabec1  := "Produto Descricao                                       Preco "
       cabec2  := "--------------------------------------------------------------"
       //          xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99,999.99   
       //          01234567890123456789012345678901234567890123456789012345678901234
       //                    1         2         3         4         5         6    
       //
       // Processa o arquivo temporario
       //
       dbSelectArea("cArqTmp")
       DbGoTop()
       ProcRegua(cArqTmp->(RecCount()))
        Do While .t.
          //
          FImpOrd12()
          //
          If Eof()
            Exit
          Endif
          //
          dbSelectArea("cArqTmp")
          IncProc("Imprimindo...")
          DbSkip()
          //
        Enddo
       //
       _nLinha += 1
       @ _nLinha, 000 PSAY __PrtThinLine()
       //
       roda(cbcont,cbtxt,"P")
       //
       Set Device To Screen
       Set Filter To
       //
       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Apaga arquivos tempor rios  ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       dbSelectarea("cArqTmp")
       cArqTmp->( dbCloseArea() )
       FErase(cArqTmp+OrdBagExt())
       FErase(cArqTmp+GetDBExtension())
       //
       dbSelectArea("SZJ")
       If aReturn[5] = 1
          Set Printer To
          dbCommitAll()
          ourspool(wnrel)
       Endif
       MS_FLUSH()
       //
Return Nil
          
Static Function FLin(_nquant)
       //
       _nLinha += _nquant
       If _nLinha >= LIM_LINHAS
          cabec(titulo,"Ref. a Tabela "+Alltrim(_cTab)+"  Obs.: "+Alltrim(SZJ->ZJ_DESCRI),"",nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
          _nLinha:=8
          @ _nLinha, 000 PSAY cabec1
          _nLinha += 1
          @ _nLinha, 000 PSAY __PrtThinLine()
          _nLinha += 1
       Endif
       //
Return 

Static Function FImpOrd12()
       //
       If Eof()
         Return
       Endif
       */
       FLin(1)
       @ _nLinha,000 PSAY Left(cArqTmp->PRODUTO,6)
	   @ _nLinha,008 PSAY cArqTmp->DESCRICAO
       @ _nLinha,053 PSAY TRANSFORM(cArqTmp->PRECO , "@E 99,999.99")
       //
Return



Static Function GeraTmp()
     //
     Processa( { || LISTABTmp() }, "Processando..." )
     //
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³  LISTAB   ºAutor  ³Alexandre Martim    º Data ³ 23/09/05    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera dados no arquivo temporario                            º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LISTABTmp(lEnd,oObj)
       //
       Local cEnter := Chr(13)
       //
       Local cAliasTmp,aStru,cQuery,cFiltro:="",cIndTmp,nIndex,nX,_nTotRec,cQuery2
       Local cAlias, cCampo, _nTotSaldo
       //
       cAliasTmp := "LISTAB"
       //
       cAlias := "SZJ"
       cCampo := "ZJ"
       //
       cQuery  := "SELECT Count(*) AS Soma "+cEnter
       //
       cQuery2 := "FROM "+RetSqlName(cAlias)+" "+cAlias+" "+cEnter
       cQuery2 += "WHERE "
       cQuery2 += cAlias + "." + cCampo + "_FILIAL = '"+'' +"' AND "+cEnter
       cQuery2 += cAlias + "." + cCampo + "_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "+cEnter
       cQuery2 += cAlias + "." + cCampo + "_LISTA = '"+mv_par03+"' "+cEnter
       //
       // cQuery2 += "ORDER BY "+cAlias + "." + cCampo + "_PRODUTO"
       //
       cQuery += cQuery2
       //
       // Memowrite("SQL.TXT",cQuery)
       //
       cQuery := ChangeQuery(cQuery)
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       _nTotRec := (cAliasTmp)->SOMA
       dbCloseArea()
       //
       cAliasTmp := "LISTAB"
       cQuery := "SELECT "+cAlias+"."+cCampo+"_FILIAL, "+cAlias+"."+cCampo+"_PRODUTO, "+cAlias+"."+cCampo+"_LISTA, "+;
                  cAlias+"."+cCampo+"_DESCRI, "+cAlias+"."+cCampo+"_TABELA "
       cQuery += cQuery2
       //
       cQuery := ChangeQuery(cQuery)
       //
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       //
       //TcSetField(cAliasTmp,"ZJ_PRECO","N",TamSx3("ZJ_PRECO")[1], TamSx3("ZJ_PRECO")[2] )
       //
       dbSelectArea(cAliasTmp)
       DbGoTop()
       ProcRegua(_nTotRec)
       Do While ( !Eof() ) 
          //
          dbSelectArea("SB1") 
          dbSetOrder(1)
          If !dbSeek(xFilial("SB1")+(cAliasTmp)->&(cCampo+"_PRODUTO"), .F.)
             IncProc("Produto - ["+Alltrim(SB1->B1_COD)+"]")
             dbSelectArea(cAliasTmp)
             dbSkip()
             loop
          Endif
          //
          dbSelectArea("DA1") 
          dbSetOrder(1)
          If !dbSeek(xFilial("DA1")+(cAliasTmp)->&(cCampo+"_TABELA")+(cAliasTmp)->&(cCampo+"_PRODUTO"), .F.)
             IncProc("Produto - ["+Alltrim(SB1->B1_COD)+"]")
             dbSelectArea(cAliasTmp)
             dbSkip()
             loop
          Endif
          //
          dbSelectArea("cArqTmp")  
          If RecLock("cArqTmp",.T.)
             cArqTmp->FILIAL    := (cAliasTmp)->&(cCampo+"_FILIAL")
             cArqTmp->PRODUTO   := (cAliasTmp)->&(cCampo+"_PRODUTO")
             cArqTmp->DESCRICAO := SB1->B1_DESC
             cArqTmp->PRECO     := DA1->DA1_PRCVEN
             msUnlock()
          Endif
          //
          dbSelectArea(cAliasTmp)
          IncProc("Produto - ["+Alltrim(SB1->B1_COD)+"]")
          dbSkip()
          //
       Enddo
       //
       dbSelectArea(cAliasTmp)
       dbCloseArea()
       dbSelectArea(cAlias)
       //
Return


Static Function Perg(_cPerg)
       //
       Local _cAlias
       Local _lAtualiza:=.f.
       //
       _cAlias := Alias()
       _cPerg  := PADR(_cPerg,6)
       _aRegs  := {}
       //
       dbSelectArea("SX1")
       dbSetOrder(1)
       //
       AADD(_aRegs,{_cPerg,"01","Produto de                   ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
       AADD(_aRegs,{_cPerg,"02","Produto Ate                  ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1",""})
       AADD(_aRegs,{_cPerg,"03","Numero da Lista              ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
       //
       For i := 1 to Len(_aRegs)
           If !DbSeek(_cPerg+_aRegs[i,2])
              RecLock("SX1",.T.)
              For j := 1 to FCount()
                  If j <= Len(_aRegs[i])
                     FieldPut(j,_aRegs[i,j])
                  Endif
              Next
              MsUnlock()
           Endif
       Next
       DbSelectArea(_cAlias)
       //
Return
