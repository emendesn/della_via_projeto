/*/

╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠

╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддд©╠╠

╠╠ЁFun┤└o    ЁMaFisAtuSFЁ Autor Ё Edson Maricate        Ё Data Ё21.02.2000 Ё╠╠

╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддд╢╠╠

╠╠Ё          ЁRotina de atualizacao dos livros fiscais                     Ё╠╠

╠╠Ё          Ё                                                             Ё╠╠

╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠

╠╠ЁParametrosЁExpN1 : Tipo de Operacao                                     Ё╠╠

╠╠Ё          Ё        [1] Inclusao                                         Ё╠╠

╠╠Ё          Ё        [2] Exclusao                                         Ё╠╠

╠╠Ё          ЁExpC2 : Tipo de Movimento                                    Ё╠╠

╠╠Ё          Ё        [E] Entrada                                          Ё╠╠

╠╠Ё          Ё        [S] Saida                                            Ё╠╠

╠╠Ё          ЁExpN3 : RecNo do cabecalho da nota fiscal                    Ё╠╠

╠╠Ё          ЁExpC4 : Alias do cabecalho da nota fiscal                    Ё╠╠

╠╠Ё          Ё                                                             Ё╠╠

╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠

╠╠ЁRetorno   ЁNenhum                                                       Ё╠╠

╠╠Ё          Ё                                                             Ё╠╠

╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠

╠╠ЁDescri┤└o ЁEsta rotina tem como objetivo atualizar os livros fiscais comЁ╠╠

╠╠Ё          Ёbase em uma nota fiscal de entrada ou saida.                 Ё╠╠

╠╠Ё          Ё                                                             Ё╠╠

╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠

╠╠ЁUso       Ё Generico                                                    Ё╠╠

╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠

╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠

ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ

/*/

Function MaFisAtuSF3(nCaso,cTpOper,nRecNF,cAlias,cPDV)

 

Local aArea             := GetArea()

Local aAreaSF1        := SF1->(GetArea())

Local aAreaSF2        := SF2->(GetArea())

Local aLivro   := {}

Local aFixos   := {}

Local aRecSF3         := {}

Local aSF3      := {}

Local nVlrTotal         := 0

Local nY       := 0 

Local nX       := 0 

Local cCliFor  := ""

Local cLoja             := ""

Local cNumNF := ""

Local cSerie   := ""

Local dDEmissao       := ""

Local cEspecie         := ""

Local cFormul := ""

Local cQuery    := ""

Local cAliasSF3 := "SF3"

Local dEntrada         := Ctod("")

Local lObserv := .F.

Local lQuery    := .F.

 

DEFAULT cPDV := ""

 

Do Case

Case cTpOper=="E"

         If Empty(cAlias)

                   cAlias := "SF1"

                   dbSelectArea("SF1")

                   MsGoto(nRecNF)

         EndIf

         //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Posiciona o cabecalho da NF de Entrada                  Ё

         //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         cCliFor          := (cAlias)->F1_FORNECE

         cLoja            := (cAlias)->F1_LOJA

         cNumNF                  := (cAlias)->F1_DOC

         cSerie           := (cAlias)->F1_SERIE

         dDEmissao     := (cAlias)->F1_EMISSAO

         cEspecie       := (cAlias)->F1_ESPECIE

         cFormul                  := (cAlias)->F1_FORMUL

         dEntrada       := (cAlias)->F1_DTDIGIT

         If cPaisLoc<>"BRA"

                   cTipo:=(cAlias)->F1_TIPO

         Endif

         //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Verifica se a NF esta carregada nas Funcoes Fiscais.    Ё

         //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         If nCaso == 1 .And. !MaFisFound("NF")

                   MaFisIniNF(1,nRecNF)

         EndIf

         //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Gravar Livro Fiscal da NF refrente ao Despacho.         Ё

         //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         If cPaisLoc == "ARG"

                   If nCaso == 1 .and. (cAlias)->F1_TIPO_NF == "9"

                            MaFisF3Eic(nCaso)

                   EndIf   

         EndIf            

OtherWise

         If Empty(cAlias)

                   cAlias := "SF2"

                   dbSelectArea("SF2")

                   MsGoto(nRecNF)

         EndIf

         //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Posiciona o cabecalho da NF de Saida                    Ё

         //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         cCliFor          := (cAlias)->F2_CLIENTE

         cLoja                     := (cAlias)->F2_LOJA

         cNumNF                  := (cAlias)->F2_DOC

         cSerie           := (cAlias)->F2_SERIE

         dDEmissao     := (cAlias)->F2_EMISSAO

         cEspecie                 := (cAlias)->F2_ESPECIE

         cFormul                  := IIf(cPaisLoc=="BRA"," ",(cAlias)->F2_FORMUL)

         If cPaisLoc <> "BRA"

                   If (cAlias)->(FieldPos('F2_DTDIGIT')) > 0

                            dEntrada                := (cAlias)->F2_DTDIGIT

                   Else

                            dEntrada                := dDataBase

                   EndIf   

         Else

                   dEntrada                := (cAlias)->F2_EMISSAO

         Endif

         If cPaisLoc<>"BRA"

                   cTipo:=(cAlias)->F2_TIPO

         Endif

         //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Verifica se a NF esta carregada nas Funcoes Fiscais.( Inclusao )  Ё

         //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         If nCaso == 1 .And. !MaFisFound("NF")

                   MaFisIniNF(2,nRecNF)

         EndIf

EndCase

Do Case

Case nCaso == 1

         //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Carega o Array contendo os Registros Fiscais (SF3)      Ё

         //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         dbSelectArea("SF3")

         dbSetOrder(If(cTpOper == "S".Or.cFormul=="S",5,4))

         #IFDEF TOP

                   If TcSrvType()<>"AS/400"

                            cAliasSF3 := "MaFisAtuSF3"

                            lQuery    := .T.

 

                            cQuery := "SELECT F3_FILIAL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,"

                            cQuery += "F3_LOJA,F3_CFO,F3_FORMUL,F3_DTCANC, R_E_C_N_O_ SF3RECNO "

                            cQuery += "FROM "+RetSqlName("SF3")+" SF3 "

                            cQuery += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "

                            cQuery += "SF3.F3_SERIE='"+cSerie+"' AND "

                            cQuery += "SF3.F3_NFISCAL='"+cNumNF+"' AND "

                            If !(cTpOper=="S".Or.cFormul=="S")

                                      cQuery += "SF3.F3_CLIEFOR='"+cCliFor+"' AND "

                                      cQuery += "SF3.F3_LOJA='"+cLoja+"' AND "

                            EndIf

                            cQuery += "SF3.D_E_L_E_T_=' ' "

                            cQuery += "ORDER BY "+SqlOrder(SF3->(IndexKey()))

 

                            cQuery := ChangeQuery(cQuery)

 

                            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)       

 

                            TcSetField(cAliasSF3,"F3_DTCANC","D",8,0)

                   Else

         #ENDIF

                  dbSeek(xFilial("SF3")+IIf(cTpOper=="S".Or.cFormul=="S",cSerie+cNumNF,cCliFor+cLoja+cNumNF+cSerie))

                  #IFDEF TOP

                   EndIf

                   #ENDIF

         While (!Eof().And. (cAliasSF3)->F3_FILIAL == xFilial("SF3") .And.;

                            (cAliasSF3)->F3_NFISCAL == cNumNF .And.;

                            (cAliasSF3)->F3_SERIE == cSerie .And.;

                            IIf(cTpOper=="S".Or.cFormul=="S",.T.,(cAliasSF3)->F3_CLIEFOR == cCliFor .And.;

                            (cAliasSF3)->F3_LOJA == cLoja) )

                   If       ((Substr((cAliasSF3)->F3_CFO,1,1) < "5" .And. (cAliasSF3)->F3_FORMUL == "S") .Or.;

                                      Substr((cAliasSF3)->F3_CFO,1,1) > "4").And.!Empty((cAliasSF3)->F3_DTCANC)

                            If lQuery

                                      aadd(aRecSF3,(cAliasSF3)->SF3RECNO)

                            Else

                                      aadd(aRecSF3,RecNo())

                            EndIf

                   EndIf

                   dbSelectArea(cAliasSF3)

                   dbSkip()

         EndDo

         If lQuery

                   dbSelectArea(cAliasSF3)

                   dbCloseArea()

                   dbSelectArea("SF3")

         EndIf   

         //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Grava arquivo de Livros Fiscais (SF3)                    Ё

         //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         aLivro      := MaFisRet(,"NF_LIVRO")

         aFixos           := MatxAfixos()

         lObserv                  := .F.

         If cPaisLoc=="BRA"

                   AEval(aLivro,{ |x| (nVlrTotal+=IIf(x[3]+x[4]+x[5]+x[6]+x[7]+x[9]+x[10]+x[11]>0,x[3]+x[4]+x[5]+x[6]+x[7]+x[9]+x[10]+x[11],0)),((lObserv  := IIf(!Empty(x[24]),.T.,lObserv)))})

         Else

                   If Len(aLivro) > 0

                            aLivro:=Adel(aLivro,1)

                            aLivro:=aSize(aLivro,Len(aLivro)-1)

                            nVlrTotal:=Len(aLivro)

                   Endif

         Endif

         If nVlrTotal > 0.00 .Or. lObserv

                   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

                   //Ё Coloca os lancamentos fiscais em ordem de CFO e CFO Extendido Ё

                   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

                   If cPaisLoc=="BRA"

                            Asort(aLivro,,,{|x,y| (x[1]+x[31])<(y[1]+y[31])})

                   Endif

                   For nX:=1 To Len(aLivro)

                            If If(cPaisLoc=="BRA",!Empty(aLivro[nx][1]),.T.)

                                     //здддддддддддддддддддддддддддддддддддддддддддддд©

                                      //Ё Recupera os registros Cancelados.            Ё

                                      //юдддддддддддддддддддддддддддддддддддддддддддддды

                                      If nX <= Len(aRecSF3)                                       

                                               SF3->(MsGoto(aRecSF3[nX]))

                                               RecLock("SF3",.F.)

                                      Else

                                               RecLock("SF3",.T.)

                                      EndIf

                                      For nY := 1 to Len(aFixos)

                                               If SF3->(FieldPos(aFixos[nY][1])) > 0

                        If cPaisLoc <>  "BRA" .AND. ValType(aLivro[nX][nY]) == "N" .AND. Subs(aFixos[nY][1],1,6) $ "F3_VAL|F3_BAS|F3_RET|F3_DES"   

                                                                 FieldPut(FieldPos(aFixos[nY][1]),Round(aLivro[nX][nY],MsDecimais(1)))

                                                        Else

                                                                  FieldPut(FieldPos(aFixos[nY][1]),aLivro[nX][nY])

                                                        EndIF           

                                               Endif   

                                      Next nY

                                      SF3->F3_FILIAL       := xFilial("SF3")

                                      SF3->F3_ENTRADA   := IIF(empty( dEntrada),dDatabase,dEntrada)

                                      SF3->F3_NFISCAL    := cNumNF

                                      SF3->F3_SERIE        := cSerie

                                      SF3->F3_CLIEFOR    := cCliFor

                                      SF3->F3_LOJA         := cLoja

                                      SF3->F3_PDV     := cPDV

                                      If !Empty(MaFisRet(,"NF_PNF_UF")) .And. ("CTR"$AllTrim(aNFCab[NF_ESPECIE]).Or."NFST"$AllTrim(aNFCab[NF_ESPECIE]))

                                               SF3->F3_ESTADO    := MaFisRet(,"NF_PNF_UF")

                                      Else

                                               SF3->F3_ESTADO    := IIF(cTpOper=="E",MaFisRet(,"NF_UFORIGEM"),MaFisRet(,"NF_UFDEST"))                                              

                                      EndIf

                                      SF3->F3_EMISSAO   := dDEmissao

                                      SF3->F3_FORMUL     := IIF(cTpOper=="E".Or.cPaisLoc<>"BRA",cFormul," ")

                                      SF3->F3_ESPECIE    := cEspecie

                                      SF3->F3_DTCANC    := CTOD("  /  /  ")

                                      If Type("l920Auto") == "L" .And. !l920Auto

                                               SF3->F3_DOCOR := If(lLote,c920NfFim,SF3->F3_DOCOR)

                                               SF3->F3_TIPO  := If(lLote,"L",SF3->F3_TIPO)

                                      EndIf

                                      //здддддддддддддддддддддддддддддддддддддддддддддддддд©

                                      //Ё Ponto de entrada para atualizar o livro fiscal   Ё

                                      //юдддддддддддддддддддддддддддддддддддддддддддддддддды

                                      If ExistBlock("MTA920L")

                                               ExecBlock("MTA920L",.f.,.f.)

                                      EndIf

                                      //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

                                      //Ё Livro de ICMS - Ajuste SINEF 03/04 - DOU 08.04.04         Ё

                                     //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

                                      If cPaisLoc=="BRA"

                                               If !Empty(aLivro[nX][35]) .And. (aLivro[nX][LF_ISS_ISENICM]<>0 .Or. aLivro[nX][LF_ISS_OUTRICM]<>0)

                                                        aSF3 := {}

                                                   For nY := 1 To SF3->(FCount())

                                                        aadd(aSF3,SF3->(FieldGet(nY)))

                                                   Next nY

                                                        RecLock("SF3",.T.)

                                                        For nY := 1 To Len(aSF3)

                                                                  If !"_MSIDENT"$SF3->(FieldName(nY))

                                                                           FieldPut(nY,aSF3[nY])

                                                                  EndIf

                                                        Next nY

                                                        SF3->F3_TIPO    := "N"

                                                        SF3->F3_ALIQICM := aLivro[nX][LF_ISS_ALIQICMS]

                                                        SF3->F3_BASEICM := 0

                                                        SF3->F3_VALICM  := 0

                                                        SF3->F3_ISENICM := aLivro[nX][LF_ISS_ISENICM]

                                                        SF3->F3_OUTRICM := aLivro[nX][LF_ISS_OUTRICM]

                                                        SF3->F3_BASEIPI := 0

                                                        SF3->F3_VALIPI  := 0

                                                        SF3->F3_ISENIPI := aLivro[nX][LF_ISS_ISENIPI]

                                                        SF3->F3_OUTRIPI := aLivro[nX][LF_ISS_OUTRIPI]

                                                        SF3->F3_CODISS  := ""

                                                        SF3->F3_OBSERV  := "NOTA FISCAL DE SERVICO"

                                                        //здддддддддддддддддддддддддддддддддддддддддддддддддд©

                                                        //Ё Ponto de entrada para atualizar o livro fiscal   Ё

                                                        //юдддддддддддддддддддддддддддддддддддддддддддддддддды

                                                        If ExistBlock("MTA920L")

                                                                  ExecBlock("MTA920L",.f.,.f.)

                                                        EndIf                                        

                                               EndIf

                                      EndIf

                            Endif

                   Next nX

         Endif

         //здддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Deleta os registros fiscais cancelados.      Ё

         //юдддддддддддддддддддддддддддддддддддддддддддддды

         If Len(aRecSF3) > Len(aLivro)

                   For nX := (Len(aLivro)+1) To Len(aRecSF3)

                            MsGoto(aRecSF3[nX])

                            RecLock("SF3",.F.,.T.)

                            dbDelete()

                   Next nX

         EndIf

OtherWise

         //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Carega o Array contendo os Registros Fiscais (SF3)      Ё

         //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         dbSelectArea("SF3")

         dbSetOrder(If(cTpOper == "S".Or.cFormul=="S",5,4))

         #IFDEF TOP

                   If TcSrvType()<>"AS/400"

                            cAliasSF3 := "MaFisAtuSF3"

                            lQuery    := .T.

 

                            cQuery := "SELECT F3_FILIAL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,"

                            cQuery += "F3_LOJA,F3_CFO,F3_FORMUL,R_E_C_N_O_ SF3RECNO "

                            cQuery += "FROM "+RetSqlName("SF3")+" SF3 "

                            cQuery += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "

                            cQuery += "SF3.F3_SERIE='"+cSerie+"' AND "

                            cQuery += "SF3.F3_NFISCAL='"+cNumNF+"' AND "

                            If !(cTpOper=="S".Or.cFormul=="S")

                                      cQuery += "SF3.F3_CLIEFOR='"+cCliFor+"' AND "

                                      cQuery += "SF3.F3_LOJA='"+cLoja+"' AND "

                            EndIf

                            cQuery += "SF3.D_E_L_E_T_=' ' "

                            cQuery += "ORDER BY "+SqlOrder(SF3->(IndexKey()))

 

                            cQuery := ChangeQuery(cQuery)

 

                            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)       

                   Else

         #ENDIF

                  dbSeek(xFilial("SF3")+IIf(cTpOper=="S".Or.cFormul=="S",cSerie+cNumNF,cCliFor+cLoja+cNumNF+cSerie))

                   #IFDEF TOP

                   EndIf

                   #ENDIF

         While (!Eof().And. (cAliasSF3)->F3_FILIAL == xFilial("SF3") .And.;

                            (cAliasSF3)->F3_NFISCAL == cNumNF .And.;

                            (cAliasSF3)->F3_SERIE == cSerie .And.;

                            IIf(cTpOper=="S".Or.cFormul=="S",.T.,(cAliasSF3)->F3_CLIEFOR == cCliFor .And.;

                            (cAliasSF3)->F3_LOJA == cLoja) )

                   If ((cTpOper == "E" .And. Substr((cAliasSF3)->F3_CFO,1,1) < "5" .And. (cAliasSF3)->F3_FORMUL == cFormul) .Or.;

                                      (cTpOper == "S" .And. Substr((cAliasSF3)->F3_CFO,1,1) > "4"))

                            If lQuery

                                      aadd(aRecSF3,(cAliasSF3)->SF3RECNO)

                            Else

                                      aadd(aRecSF3,RecNo())

                            EndIf

                   EndIf

                   dbSelectArea(cAliasSF3)

                   dbSkip()

         EndDo

         If lQuery

                   dbSelectArea(cAliasSF3)

                   dbCloseArea()

                   dbSelectArea("SF3")

         EndIf

         //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

         //Ё Cancelamento dos Livros Fiscais.                         Ё

         //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

         dbSelectArea('SF3')

         For nX := 1 to Len(aRecSF3)

                   If cFormul == "S" .Or. cTpOper == "S"

                            MsGoto(aRecSF3[nX])

                            RecLock("SF3",.F.)

                            If IIf(cPaisLoc!="BRA",lAnulaSF3,.T.)                           

                                      SF3->F3_DTCANC := dDataBase

                                      SF3->F3_OBSERV := STR0008 //"NF CANCELADA"

                            Else

                                      dbDelete()

                            EndIf

                            MsUnlock()

                            If cTpOper == "S"

                                      //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©

                                      //Ё Pto de Entrada utilizado na Argentina                   Ё

                                      //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

                                      If ExistBlock("M520SF3") // LUCAS 18/08/99 ARGENTINA

                                               ExecBlock("M520SF3",.F.,.F.)

                                      Endif

                            EndIf

                   Else

                            MsGoto(aRecSF3[nX])

                            RecLock("SF3",.F.,.T.)

                            dbDelete()

                   EndIf

         Next

EndCase

RestArea(aAreaSF1)

RestArea(aAreaSF2)

RestArea(aArea)

Return(.T.)

