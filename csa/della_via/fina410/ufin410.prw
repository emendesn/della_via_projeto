#include "FINA410.CH"
#Include "PROTHEUS.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINA410    ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 02.05.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Refaz acumulados de Clientes/Fornecedores                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINA410()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function Fina410(lDireto)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local 	nOpca     := 0

LOCAL aSays:={}, aButtons:={}
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa	:= {}
Local aPergs	:= {}

Private cCadastro := OemToAnsi(STR0003)  //"Refaz Dados Clientes/Fornecedores"

//Cliente de
aHelpPor := {}
aHelpEng := {}
aHelpSpa	:= {}

aadd(aHelpPor,"Selecione o código inicial do intervalo")
aadd(aHelpPor,"de códigos de clientes a serem")
aadd(aHelpPor,"considerados")

aadd(aHelpEng,"Select the initial code of the customer")
aadd(aHelpEng,"codes interval to be considered")

aadd(aHelpSpa,"Digite el codigo inicial del intervalo")
aadd(aHelpSpa,"de codigos de clientes que debe ")
aadd(aHelpSpa,"considerado")

Aadd(aPergs,{"Do Cliente ?","¿De Proveedor?","From Supplier ?","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","S","001","",aHelpPor,aHelpEng,aHelpSpa})
//Cliente Ate
aHelpPor := {}
aHelpEng := {}
aHelpSpa	:= {}

aadd(aHelpPor,"Selecione o código final do intervalo")
aadd(aHelpPor,"de códigos de clientes a serem")
aadd(aHelpPor,"considerados")

aadd(aHelpEng,"Select the final code of the supplier")
aadd(aHelpEng,"codes interval to be considered")

aadd(aHelpSpa,"Digite el codigo final del intervalo")
aadd(aHelpSpa,"de codigos de proveedores que debe ")
aadd(aHelpSpa,"considerado")

Aadd(aPergs,{"Ate Cliente ?","¿A  Proveedor?","To Supplier ?","mv_ch4","C",6,0,0,"G","","mv_par04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","S","001","",aHelpPor,aHelpEng,aHelpSpa})

//Fornecedor de
aHelpPor := {}
aHelpEng := {}
aHelpSpa	:= {}

aadd(aHelpPor,"Selecione o código inicial do intervalo")
aadd(aHelpPor,"de códigos de fornecedores a serem")
aadd(aHelpPor,"considerados")

aadd(aHelpEng,"Select the initial code of the supplier")
aadd(aHelpEng,"codes interval to be considered")

aadd(aHelpSpa,"Digite el codigo inicial del intervalo")
aadd(aHelpSpa,"de codigos de proveedores que debe ")
aadd(aHelpSpa,"considerado")

Aadd(aPergs,{"Do Fornecedor ?","¿De Proveedor?","From Supplier ?","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","S","001","",aHelpPor,aHelpEng,aHelpSpa})
//Fornecedor Ate
aHelpPor := {}
aHelpEng := {}
aHelpSpa	:= {}

aadd(aHelpPor,"Selecione o código final do intervalo")
aadd(aHelpPor,"de códigos de fornecedores a serem")
aadd(aHelpPor,"considerados")

aadd(aHelpEng,"Select the final code of the supplier")
aadd(aHelpEng,"codes interval to be considered")

aadd(aHelpSpa,"Digite el codigo final del intervalo")
aadd(aHelpSpa,"de codigos de proveedores que debe ")
aadd(aHelpSpa,"considerado")

Aadd(aPergs,{"Ate Fornecedor ?","¿A  Proveedor?","To Supplier ?","mv_ch6","C",6,0,0,"G","","mv_par06","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA2","S","001","",aHelpPor,aHelpEng,aHelpSpa})
AjustaSX1("AFI410",aPergs)
AjustaSXD("P", "FINA410", "AFI410", {"","",""}, "S", {"Calculos de analise de credito","",""}, {"Calculos de analise de credito","",""}, "")
If IsBlind() .Or. lDireto
	BatchProcess( 	cCadastro, 	STR0004 + Chr(13) + Chr(10) +;
	STR0005, "AFI410",;
	{ || U_fa410Processa(.T.) }, { || .F. })
	Return .T.
Endif

Pergunte("AFI410",.f.)
AADD(aSays, OemToAnsi(STR0004))  //"  Este programa tem como objetivo recalcular os saldos acumulados de    "
AADD(aSays, OemToAnsi(STR0005))  //"clientes e/ou fornecedores.                                             "
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
AADD(aButtons, { 5,.T.,{|| Pergunte("AFI410",.T. ) } } )
FormBatch( cCadastro, aSays, aButtons )

If  nOpcA == 1
	Processa({|lEnd| U_fa410Processa()})  // Chamada da funcao de recalculos
Endif

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fa410Process³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 02.05.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Reprocessamento arquivos de cliente/fornecedor                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa410Processa()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nao ha'                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function Fa410Processa(lBat)

// Variaveis utilizadas na chamada da stored procedure - TOP

Local nValForte := 0,nSaldoTit:=0
Local nMoeda  := Int(Val(GetMv("MV_MCUSTO")))
Local nMoedaF := 0
Local cFilBusca := "  "
Local nTaxaM	:=0
Local lRet      := .T.
Local aBaixas

/*
#IFDEF TOP
Local cFilOld := cFilAnt
Local cCliDe, cCliAte, cForDe, cForAte, cArrayFil
Local cCRNEG  := "/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVIRABT+"/"+MVFUABT+"/"+MVINABT+"/"+MVISABT+"/"+MVPIABT+"/"+MVCFABT
Local cCRNEG1 := "/"+MVRECANT+"/"+MV_CRNEG
Local cCPNEG  := "/"+MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM
Local cTipoLC
Local cProcNam := '       '
#ENDIF
*/
// Fim das variaveis utilizadas na chamada da stored procedure
DEFAULT lBat	:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica parametros informados                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
#IFDEF TOP
cProcNam := 'FIN003'

If ExistProc( cProcNam ) .and. ( TcSrvType() <> "AS/400" )
cCRNEG     := Iif(Empty(cCRNEG),  ' ', cCRNEG)
cCRNEG1    := Iif(Empty(cCRNEG1), ' ', cCRNEG1)
cCPNEG     := Iif(Empty(cCPNEG),  ' ', cCPNEG)
cTipoLC   := "/"+GetSESTipos({ || ES_SALDUP == "2"},"1")
cTipoLC   := Iif(Empty(cTipoLC)," ", cTipoLC)
cCliDe    := Iif(Empty(mv_par03), ' ', Rtrim(mv_par03))
cCliAte   := Rtrim(mv_par04)
cForDe    := Iif(Empty(mv_par05), ' ', Rtrim(mv_par05))
cForAte   := Rtrim(mv_par06)

cArrayFil := ""
dbSelectArea("SM0")
dbSeek(cEmpAnt)
While !Eof() .and. cEmpAnt = SM0->M0_CODIGO
cArrayFil += SM0->M0_CODFIL
DbSkip()
EndDo

aResult := TCSPExec( xProcedures(cProcNam), cFilOld, ;
StrZero(mv_par01,1), StrZero(mv_par02,1), GetMv("MV_MCUSTO"),;
dtos(dDatabase),     cCRNEG,               cCRNEG1,           ;
cCPNEG, cTipoLC, 		cCliDe,               cCliAte,           ;
cForDe, cForAte, cArrayFil )
If Empty(aResult)
MsgAlert(OemToAnsi(STR0008))  //"Erro na chamada do processo"
Elseif aResult[1] == "01" .or. aResult[1] == "1"
MsgAlert(OemToAnsi(STR0009))  //"Atualizacao OK"
Else
MsgAlert(OemToAnsi(STR0010))  //"Atualizacao com Erro"
Endif
cFilAnt := cFilOld
Else
#ENDIF
*/
If !lBat
	If mv_par01 == 1
		ProcRegua(SA1->(RecCount())+SA2->(RecCount())+SE1->(RecCount())+SE2->(RecCount()))
	Elseif mv_par01 == 2
		ProcRegua(SA1->(RecCount())+SE1->(RecCount()))
	ElseIf mv_par01 == 3
		ProcRegua(SA2->(RecCount())+SE2->(RecCount()))
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cadastro de Clientes                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 != 3
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+MV_PAR03)
	While !Eof() .AND. SA1->A1_COD >= MV_PAR03 .AND. SA1->A1_COD <= MV_PAR04
		
		If !lBat
			IncProc()
		EndIf
		
		If SA1->A1_COD >= mv_par03 .And. SA1->A1_COD <= mv_par04
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de entrada para filtro dos registros                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("FIN410FT")
				lRet := ExecBlock("FIN410FT",.F.,.F.,{mv_par01,"1"})
				If !lRet
					dbSkip()
					Loop
				EndIf
			Endif
			Reclock( "SA1" )
			SA1->A1_SALDUP := 0
			SA1->A1_SALDUPM:= 0
			SA1->A1_SALFIN := 0
			SA1->A1_SALFINM:= 0
			SA1->A1_MAIDUPL:= 0
			SA1->A1_ATR    := 0
			SA1->A1_PAGATR := 0
			SA1->A1_NROPAG := 0
			SA1->A1_VACUM  := 0
			SA1->A1_ULTCOM :=	CTOD("//")
			If mv_par02 == 1 // Refaz dados historicos
				SA1->A1_MSALDO := 0
				SA1->A1_METR := 0
				SA1->A1_MATR := 0
			Endif
			MsUnlock()
		Endif
		SA1->(dbSkip())
	Enddo
EndIf

If mv_par01 != 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cadastro de Fornecedores                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea( "SA2" )
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+MV_PAR05)

	While !Eof() .AND. SA2->A2_COD >= mv_par05 .And. SA2->A2_COD <= mv_par06
		If !lBat
			IncProc()
		EndIf
		If SA2->A2_COD >= mv_par05 .And. SA2->A2_COD <= mv_par06
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de entrada para filtro dos registros                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("FIN410FT")
				lRet := ExecBlock("FIN410FT",.F.,.F.,{mv_par01,"2"})
				If !lRet
					dbSkip()
					Loop
				EndIf
			Endif
			Reclock( "SA2" )
			SA2->A2_SALDUP := 0
			SA2->A2_SALDUPM:= 0
			MsUnlock()
		Endif
		SA2->(dbSkip())
	Enddo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos a Receber - Atualiza saldos clientes                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 != 3
	DbSelectArea("SE1")
	DbSetOrder(2)
	DbSeek(xFilial("SE1")+MV_PAR03)
	While !Eof() .AND. SE1->E1_CLIENTE >= MV_PAR03 .AND. SE1->E1_CLIENTE <= MV_PAR04
		If !lBat
			IncProc()
		EndIf
		If SE1->E1_CLIENTE >= mv_par03 .And. SE1->E1_CLIENTE <= mv_par04
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de entrada para filtro dos registros                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("FIN410FT")
				lRet := ExecBlock("FIN410FT",.F.,.F.,{mv_par01,"3"})
				If !lRet
					dbSkip()
					Loop
				EndIf
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Saldo do Cliente                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SA1")
			If !Empty(xFilial("SA1")) .and. !Empty(xFilial("SE1"))
				cFilBusca := SE1->E1_FILIAL		// Ambos exclusivos, neste caso
				// a filial serah 1 para 1
			Else
				cFilBusca := xFilial("SA1")		// filial do cliente (SA1)
			Endif
			
			If (dbSeek( cFilBusca+SE1->E1_CLIENTE+SE1->E1_LOJA ) )
				nMoedaF		:= If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMoeda)
				nTaxaM:=Round(SE1->E1_VLCRUZ/SE1->E1_VALOR,3)
				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVIRABT+"/"+MVFUABT+"/"+MVINABT+"/"+MVISABT+"/"+MVPIABT+"/"+MVCFABT
					AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO)
					IF Year(SE1->E1_EMISSAO) == Year(dDataBase)
						Reclock( "SA1" )
						SA1->A1_VACUM -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,,nTaxaM)
						MsUnLock()
					Endif
				Else
					nSaldoTit := SE1->E1_SALDO
					nSaldoTit := Iif(nSaldoTit < 0, 0, nSaldoTit)
					IF !(SE1->E1_TIPO $ MVPROVIS)
						AtuSalDup("+",nSaldoTit,SE1->E1_MOEDA,SE1->E1_TIPO,nTaxaM,SE1->E1_EMISSAO)
					Endif
					Reclock( "SA1" )
					SA1->A1_PRICOM  := Iif(SE1->E1_EMISSAO<A1_PRICOM.or.Empty(A1_PRICOM),SE1->E1_EMISSAO,A1_PRICOM)
					SA1->A1_ULTCOM  := Iif(A1_ULTCOM<SE1->E1_EMISSAO,SE1->E1_EMISSAO,A1_ULTCOM)
					IF Year(SE1->E1_EMISSAO) == Year(dDataBase)
						SA1->A1_VACUM += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO)
					Endif
					
					IF !(SE1->E1_TIPO $ MVPROVIS)
						If AllTrim(Upper(SE1->E1_ORIGEM)) == "MATA460"
							SF2->(dbSetOrder(2))
							nValForte := 0
							If SF2->(dbSeek(xFilial("SF2")+SE1->(E1_CLIENTE+E1_LOJA+E1_NUM+E1_PREFIXO)))
								nValForte := xMoeda(SF2->F2_VALFAT,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO)
							Endif
						Else
							nValForte := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO)
						Endif
						If nValForte > SA1->A1_MAIDUPL
							SA1->A1_MAIDUPL := nValForte
						EndIF
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza Atrasos/Pagamentos em Atraso do Cliente  - 07/12/95     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aBaixas:=Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,;
						SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_MOEDA,"R",SE1->E1_CLIENTE,;
						dDataBase,SE1->E1_LOJA)
						
						If (Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT") .And.;
							STR(SE1->E1_SALDO,17,2) != STR(SE1->E1_VALOR,17,2)
							// Nao faz sentido atualizar quando eh o cliente padrao
							// Essa consistencia serve apenas para modulo Sigaloja(12), pois outros modulos nao utilizam cliente padrao
							If nModulo <> 12 .or. !(GetMv( "MV_CLIPAD" )+ GetMv( "MV_LOJAPAD" ) == SE1->E1_Cliente+SE1->E1_Loja)
								SA1->A1_NROPAG += aBaixas[11]
							EndIf
						Endif
						If SE1->E1_SALDO == 0
							If (Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT")
								If (SE1->E1_BAIXA - SE1->E1_VENCREA) > 0
									SA1->A1_PAGATR += SE1->E1_VALLIQ
								Endif
							Endif
						Else
							If SE1->E1_VENCREA < dDatabase
								SA1->A1_ATR += SE1->E1_SALDO
							Endif
						Endif
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza Dados Historicos                                        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If mv_par02 == 1
							
							//A1_MSALDO - Maior saldo de duplicatas do Cliente
							//A1_METR - Media de atrasos do Cliente
							//A1_MATR - Maior atraso do Cliente
							
							SA1->A1_MSALDO := Iif(SA1->A1_SALDUPM > SA1->A1_MSALDO,SA1->A1_SALDUPM,SA1->A1_MSALDO)
							IF Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT"
								If (SE1->E1_BAIXA - SE1->E1_VENCREA) > SA1->A1_MATR
									SA1->A1_MATR := SE1->E1_BAIXA - SE1->E1_VENCREA
								EndIf
								If !Empty(SE1->E1_BAIXA)
									SA1->A1_METR := (SA1->A1_METR * (SA1->A1_NROPAG-1) + (SE1->E1_BAIXA - SE1->E1_VENCREA))/ SA1->A1_NROPAG
								Endif
							Endif
						Endif
						MsUnlock( )
					Endif
				Endif
			Endif
		Endif
		dbSelectArea( "SE1" )
		SE1->(dbSkip())
	Enddo
EndIf
If mv_par01 != 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulos a Pagar - atualiza saldos fornecedores                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SE2" )
	DbSetOrder(6)
	DbSeek(xFilial("SE2")+MV_PAR05)
	// dbGoTop()
	While !Eof() .AND. SE2->E2_FORNECE >= mv_par05 .And. SE2->E2_FORNECE<= mv_par06
		If !lBat
			IncProc()
		EndIf
		If SE2->E2_FORNECE >= mv_par05 .And. SE2->E2_FORNECE<= mv_par06
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de entrada para filtro dos registros                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("FIN410FT")
				lRet := ExecBlock("FIN410FT",.F.,.F.,{mv_par01,"4"})
				If !lRet
					dbSkip()
					Loop
				EndIf
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Saldo do Fornecedor                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SA2")
			If !Empty(xFilial("SA2")) .and. !Empty(xFilial("SE2"))
				cFilBusca := SE2->E2_FILIAL		// Ambos exclusivos, neste caso
				// a filial serah 1 para 1
			Else
				cFilBusca := xFilial("SA2")		// filial do fornecedor (SA2)
			Endif
			
			If (dbSeek( cFilBusca+SE2->E2_FORNECE+SE2->E2_LOJA ) )
				Reclock( "SA2" )
				If  SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM
					SA2->A2_SALDUP  -= xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
					SA2->A2_SALDUPM -= xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO)
				Else
					SA2->A2_SALDUP  += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
					SA2->A2_SALDUPM += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO)
					SA2->A2_PRICOM  := Iif(SE2->E2_EMISSAO<A2_PRICOM .or. empty(A2_PRICOM),SE2->E2_EMISSAO,A2_PRICOM)
					SA2->A2_ULTCOM  := Iif(A2_ULTCOM<SE2->E2_EMISSAO,SE2->E2_EMISSAO,A2_ULTCOM)
				EndIf
				MsUnlock()
			EndIf
		Endif
		dbSelectArea("SE2")
		SE2->( dbSkip())
	Enddo
EndIf
dbSelectArea( "SE1" )
dbSetOrder(1)
MsUnlockAll()

/*
#IFDEF TOP
Endif
#ENDIF
*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSXD ºAutor  ³Adilson H Yamaguchi º Data ³  03/15/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Incluir registro na tabela SXD                              º±±
±±º          |  Parametros:                                               º±±
±±º          |  	cTipo		- XD_TIPO                                 º±±
±±º          |  	cFuncao		- XD_FUNCAO                               º±±
±±º          |  	cPergunta	- XD_PERGUNT                              º±±
±±º          |  	aOrdem		- { XD_ORDBRZ, XD_ORDSPA, XD_ORDENG }     º±±
±±º          |  	cPropri		- XD_PROPRI                               º±±
±±º          |  	aTitulo		- { XD_TITBRZ, XD_TITSPA, XD_TITENG }     º±±
±±º          |  	aDescricao	- { XD_DESCBRZ, XD_DESCSPA, XD_DESCENG }  º±±
±±º          |		cPergSPE	- XD_PERGSPE                              º±±
±±º          |		bIncluir	- XD_PERGSPE                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7.10 ; MP8.11                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSXD(cTipo, cFuncao, cPergunta, aOrdem, cPropri, aTitulo, aDescricao, cPergSPE)
Local aOldArea := GetArea()
DbSelectArea("SXD")
DbSetOrder(1)
If !DbSeek(cFuncao)
	Reclock("SXD", .T.)
	SXD->XD_TIPO    := cTipo
	SXD->XD_FUNCAO  := cFuncao
	SXD->XD_PERGUNT := cPergunta
	SXD->XD_ORDBRZ  := aOrdem[1]
	SXD->XD_ORDSPA  := aOrdem[2]
	SXD->XD_ORDENG  := aOrdem[3]
	SXD->XD_PROPRI  := cPropri
	SXD->XD_TITBRZ  := aTitulo[1]
	SXD->XD_TITSPA  := aTitulo[2]
	SXD->XD_TITENG  := aTitulo[3]
	SXD->XD_DESCBRZ := aDescricao[1]
	SXD->XD_DESCSPA := aDescricao[2]
	SXD->XD_DESCENG := aDescricao[3]
	SXD->XD_PERGSPE := cPergSPE
	MsUnlock()
EndIf
DbSelectArea(aOldArea)
Return Nil