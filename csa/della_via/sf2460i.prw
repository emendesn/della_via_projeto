/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF2460I  ºAutor  ³Alexandre Martim    º Data ³  05/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada no final da gravacao do documento de     º±±
±±º          ³saida para gravar o campo de portador do clinte nos titulos º±±
±±º          ³gerados caso existam.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     Local cArqGerado := ""
     Local cDirGrv := GetNewPar("MV_LJDIRGR", GetClientDir())
     
     //
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC5","SC6","SF2","SD2","SE1","SF4"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //
     If cEmpAnt == "01"  // DELLA VIA
        //
        DbSelectArea("SF2")
        If Reclock("SF2",.f.)
			SF2->F2_BCO1	:= SC5->C5_BCO1
			SF2->F2_TIPVND	:= SC5->C5_TPVEND
   
			//Marcelo Alcantara 08/12
			SF2->F2_PLACA	:= SC5->C5_PLACA
			SF2->F2_CODCON	:= SC5->C5_CODCON
			SF2->F2_ORIGEM	:= SC5->C5_ORIGEM 

           MsUnlock()
        Endif
        //
        // Gera meio magnetico para um conjunto de TES especifico
        //
        If FunName() <> "LOJA430"   //--> Marcelo Alcantara
	        If SD2->D2_TES $ Alltrim(GetMV('MV_TESTRAN',,'555/551/558/563/'))
    	       LjMsgRun("Aguarde!, Gerando meio magnetico",, {|| LJ430Disk(SF2->F2_DOC, SF2->F2_SERIE, cFilAnt+SF2->F2_LOJA, @cArqGerado) })
	           If File( cDirGrv + cArqGerado )
	              MsgInfo( "Criado arquivo de Nota em : " + cDirGrv + Chr(10) + cArqGerado )
	           Endif
    	    Endif
		EndIf
        //
        DbSelectArea("SE1")
        DbSetOrder(2)                          
        DbGoTop()
        If DbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+&(getmv("MV_1DUPREF"))+SF2->F2_DOC)
           Do While 		!Eof() .and. ;
           					SE1->E1_FILIAL		==	xFilial("SE1") 	.and.;
           					SE1->E1_CLIENTE	==	SF2->F2_CLIENTE 	.and.;
                    		SE1->E1_LOJA		==	SF2->F2_LOJA 		.and.; 
                    		SE1->E1_NUM			==	SF2->F2_DOC 		.and.;
                    		SE1->E1_PREFIXO	==	&(getmv("MV_1DUPREF"))
                    		
              Reclock("SE1",.f.)
              SE1->E1_BCO1 := SC5->C5_BCO1
              MsUnlock()
              
              DbSelectArea("SE1")
              DbSkip()
           Enddo
        Endif



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Marcelo Alcantara 22/12/05                                           ³
	//³Verifica se o Tipo de operacao esta igual ao orcamento caso contrario³
	//³Grava novamente.                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        DbSelectArea("SF2")
        SUA->(dbSetOrder(2))	//UA_FILIAL+UA_SERIE+UA_DOC
        If SUA->(dbSeek(XFILIAL("SUA")+SF2->F2_SERIE+SF2->F2_DOC))
            Reclock("SF2",.f.)
			SF2->F2_TIPVND	:= SUA->UA_TIPOVND
			MsUnlock()
		EndIf	
		
//		If SF2->F2_FORMUL = "S" // Formulário Próprio
			Aviso("Aviso","Foi gerada NF n: "+SF2->F2_DOC+" "+SF2->F2_SERIE,{"OK"})
//		Endif	
     
     Endif

     //
     // Restaura Areas
     For _nX1 := 1 To Len(_aAlias1)
         dbSelectArea(_aAlias1[_nX1,1])
         dbSetOrder(_aAlias1[_nX1,2])
         dbGoTo(_aAlias1[_nX1,3])
     Next
     RestArea(_aArea1)
     //

Return
