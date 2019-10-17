#Include "Protheus.Ch"

User Function ALTVEND()
     //
     Local aCores    := {{  'F2_TIPO=="N"'	 , 'DISABLE'},;		// NF Normal
	       				{  'F2_TIPO=="P"'	 , 'BR_AZUL'},;		// NF de Compl. IPI
		      			{  'F2_TIPO=="I"'	 , 'BR_MARRON'},;	// NF de Compl. ICMS
			     		{  'F2_TIPO=="C"'	 , 'BR_PINK'},;		// NF de Compl. Preco/Frete
				    	{  'F2_TIPO=="B"'	 , 'BR_CINZA'},;	// NF de Beneficiamento
					    {  'F2_TIPO=="D"'    , 'BR_AMARELO'} }	// NF de Devolucao
     //
     Private cAlias1 := "SF2"
     Private cCadastro := "Altera vendedor pelo Documento de Saida"
     Private aRotina := {}
     //
     aAdd( aRotina, {"Pesquisar"   ,"AxPesqui"    ,0,1})
     aAdd( aRotina, {"Visualizar"  ,"MC090Visual" ,0,2})
     aAdd( aRotina, {"Altera Vend.","u_FAltVend()",0,3})
     aAdd( aRotina, {"Legenda"     ,"MC090Legend" ,0,5})
     //
     dbSelectArea(cAlias1)
     dbSetOrder(1)
     dbGoTop()
     //
     mBrowse(,,,,"SF2",,,,,,aCores)
     //
     dbSelectArea("SF2")
     dbSetOrder(1)
     //
Return

User Function FAltVend()
       //
       Local lMark  := .F.
       Local oTit   := LoadBitmap( GetResources(), "BR_VERDE" )
       Local oBax   := LoadBitmap( GetResources(), "BR_VERMELHO" )
       Local oPar   := LoadBitmap( GetResources(), "BR_AZUL" )
       //
       Local nOpca := 0
       Local _cVendedor := SF2->F2_VEND1, _cTipoVnd := SF2->F2_TIPVND
       Local _nVlrComissao, _dPagto, _lNegAlt:=.f.
       Local oGetd
       Local nOpc := 3
       Local nX   := 0
       Local oDlg := NIL
       //
       Private cTitulo := "Alteracao de Vendedor"
       Private aCols   := {}
       Private aHeader := {}
       Private _cOrcamento := Space(6)
       //
       _cCampos_nao_Editaveis := "PAB_ORC/PAB_MSEXP"
       //
       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Montando aHeader                                             ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       dbSelectArea("SX3")
       dbSetOrder(1)
       dbSeek("PAB",.F.)
       nUsado:=0
       aHeader:={}
       Do While !Eof() .And. (x3_arquivo == "PAB")
          If AllTrim(X3_CAMPO)=="PAB_FILIAL"
             dbSkip()
             Loop
          Endif
          IF X3USO(x3_usado) .AND. cNivel >= x3_nivel  .AND. !(AllTrim(x3_campo) $ _cCampos_nao_Editaveis)
             nUsado:=nUsado+1
             AADD(aHeader,{ TRIM(x3_titulo), AllTrim(x3_campo), x3_picture,;
                  x3_tamanho, x3_decimal,x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context } )
          Endif
          dbSkip()
       Enddo
       //
       dbSelectArea("SL1")
       dbSetOrder(2)
       If DbSeek(xFilial("SL1")+SF2->F2_SERIE+SF2->F2_DOC,.f.)
          //
          _cOrcamento := SL1->L1_NUM
          //
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³Montagem do aCols                                                       ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          dbSelectArea("PAB")
          dbSetOrder(3)
          dbSeek(xFilial("PAB")+_cOrcamento,.f.)
          Do While ( !Eof() .And. xFilial("PAB") == PAB->PAB_FILIAL .And. PAB_ORC == _cOrcamento )
             aadd(aCols,Array(nUsado+1))
             aCols[Len(aCols)][nUsado+1] := .F.
             For nX := 1 To nUsado                         
                 If ( aHeader[nX][10] != "V" )              
     	   	    	If !Empty( nPosPAB := FieldPos(aHeader[nX][2] ) ) 
     	    	       aCols[Len(aCols)][nX] := PAB->(FieldGet( nPosPAB ) )
                    EndIf 					
                 Else
                     aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
                 EndIf
             Next
             dbSelectArea("PAB")
             DbSkip()					
          EndDo
       Endif
       //
       If Empty(_cOrcamento)
          nOpc := 2
       Endif
       //
       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Cria variaveis M->????? da Enchoice                          ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       RegToMemory("PAB",.f.,.t.)
       //
       If Len(aCols) = 0
          aCols := { Array(nUsado+1) }
          aCols[1,nUsado+1] := .F.
          For x:=1 to nUsado
              aCols[1, x] := CriaVar(aHeader[x,2])
          Next
       Endif
       //
       DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 460,790 OF oMainWnd PIXEL
          //                   
          @ 012,005 TO 062,290 LABEL "" OF oDlg PIXEL
          @ 022,013 SAY "Altera para Vendedor  : " SIZE 70,8 PIXEL OF oDlg
          @ 022,077 MSGET _cVendedor F3 "SA3" VALID (Iif(_lNegAlt,(Alert("Nota Já processada para comissao, permissao negada!"),;
                                                     .f.),.t.)) PICTURE "@!" SIZE 35,8 PIXEL OF oDlg
          @ 020,120 TO 032,280 OF oDlg PIXEL
          @ 023,125 SAY Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_NOME") SIZE 70,8 PIXEL OF oDlg
          //
          @ 042,013 SAY "Altera o Tipo de Venda: " SIZE 70,8 PIXEL OF oDlg
          @ 042,077 MSGET _cTipoVnd  F3 "PAG"  PICTURE "@!" SIZE 35,8 PIXEL OF oDlg 
          @ 040,120 TO 052,280 OF oDlg PIXEL
          @ 043,125 SAY Posicione("PAG",1,xFilial("PAG")+_cTipoVnd,"PAG_DESC") SIZE 70,8 PIXEL OF oDlg
          //
          DEFINE SBUTTON FROM 014,310 TYPE 1 OF oDlg ENABLE ONSTOP "Confirma alteracao do vendedor" ACTION (nOpca:=1,oDlg:End())
          DEFINE SBUTTON FROM 032,310 TYPE 2 OF oDlg ENABLE ONSTOP "Sair..." ACTION (nOpca:=2,oDlg:End())
          //
          @ 069,005 SAY "Equipe de montagem" SIZE 70,8 PIXEL OF oDlg
          //
          oGetd:=MsGetDados():New(077,005,225,390,nOpc,"U_PABLinOk","U_PABTudOk","",.T.,,,,,,"U_PABFieldOk",,,oDlg)
          //
       ACTIVATE MSDIALOG oDlg CENTER // ON INIT EnchoiceBar(oDlg, {|| oDlg:End(),nOpcA:=1}  ,{|| oDlg:End()} )
       //
       If nOpca==1 .and. !Empty(_cVendedor) .and. !Empty(_cTipoVnd)
          //
          ProcVend(_cVendedor,_cTipoVnd)
          //
       Endif
       //
Return

User Function PABLinOk()
Return .t.

User Function PABTudOk()
Return .t.

User Function PABFieldOk()
Return .t.

Static Function ProcVend(_cVendedor,_cTipoVnd)
       //
       Local nUsado  := Len(aHeader)
       Local nX      := 0
       Local nY      := 0
       //
       If !Empty(_cOrcamento)
           //
           dbSelectArea("SL1")
           dbSetOrder(1)
           If DbSeek(xFilial("SL1")+_cOrcamento,.f.)
              If RecLock("SL1",.F.)
                 SL1->L1_VEND    := _cVendedor
                 SL1->L1_TIPOVND := _cTipoVnd
                 msUnlock()
              Endif
           Endif
           //
           dbSelectArea("PAB")
           dbSetOrder(3) // Por Orcamento
           If ( dbSeek(xFilial("PAB")+_cOrcamento,.f.) )
              Do While !Eof() .and. PAB->PAB_FILIAL==xFilial("PAB") .and. PAB->PAB_ORC == _cOrcamento
                 RecLock("PAB",.f.)
                 dbDelete()
                 MsUnlock()
                 DbSkip()
              Enddo
      		EndIf
     		If Len(aCols)>0
               For nX := 1 To Len(aCols)
      	           If ( !aCols[nX][nUsado+1] )
                      RecLock("PAB",.t.)
                      For nY := 1 To nUsado
    				      If ( aHeader[nY][10] != "V" )
                             If !Empty( nPosPAB := FieldPos(aHeader[nY][2]) )
    							PAB->(FieldPut( nPosPAB ,aCols[nX][nY]))
                             EndIf 							
                         EndIf
                     Next nY
                     PAB->PAB_FILIAL := xFilial("PAB")
                     PAB->PAB_ORC    := _cOrcamento
                     MsUnLock()
                  Endif
              Next
           Endif
       Endif
       //
       dbSelectArea("SF2")
       If RecLock("SF2",.F.)
          SF2->F2_VEND1  := _cVendedor
          SF2->F2_TIPVND := _cTipoVnd
          msUnlock()
       Endif
       //
       dbSelectArea("SD2")
       dbSetOrder(3)
       If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.f.)
          dbSelectArea("SC5")
          dbSetOrder(1)
          If DbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.f.)
             If RecLock("SC5",.F.)
                SC5->C5_VEND1 := _cVendedor
                msUnlock()
             Endif
          Endif
          dbSelectArea("SUA")
          dbSetOrder(8)
          If DbSeek(xFilial("SUA")+SD2->D2_PEDIDO,.f.)
             If RecLock("SUA",.F.)
                SUA->UA_VEND    := _cVendedor
                SUA->UA_TIPOVND := _cTipoVnd
                msUnlock()
             Endif
          Endif
       Endif
       //
       dbSelectArea("SE1")
       If DbSeek(xFilial("SE1")+Iif(Alltrim(SF2->F2_ESPECIE)="CF",SF2->F2_SERIE,&(getmv("MV_1DUPREF")))+SF2->F2_DOC,.f.)
          Do While !Eof() .and. SE1->E1_FILIAL==xFilial("SE1") .and. SE1->E1_NUM == SF2->F2_DOC .and.;
                   SE1->E1_PREFIXO == Iif(Alltrim(SF2->F2_ESPECIE)="CF",SF2->F2_SERIE,&(getmv("MV_1DUPREF")))
             If RecLock("SE1",.F.)
                SE1->E1_VEND1 := _cVendedor
                msUnlock()
             Endif
             DbSkip()
          Enddo
       Endif
       //
Return
