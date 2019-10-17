#Include "MSOLE.CH"
#Include "RWMAKE.CH"  //"FIVEWIN.CH"
#Include "FONT.CH"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DFATR07  บAutor  ณ Jader              บ Data ณ 23/08/2005  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao de Carta de SEPU                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DFATR07()

Private aRegs := {}
Private cPerg := "FATR07"
Private cCadastro := "Emissao de Carta de SEPU"
Private aRotina := {{"Pesquisa" ,"AxPesqui"  ,0,1},;
					{"Visualiza","U_DFATR07A(1)",0,2},;
					{"Imprime"  ,"U_DFATR07A(2)"  ,0,4}}

//-- cria grupo de perguntas e chama pergunte
aRegs := {}
AAdd(aRegs,{cPerg,"01","Responsavel?" ,"Responsavel?" ,"Responsavel?" ,"mv_ch1","C",30,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"02","Cargo?"       ,"Cargo?"       ,"Cargo?"       ,"mv_ch2","C",30,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)

Pergunte(cPerg,.T.)

dbSelectArea("SC2")
dbSetOrder(1)
dbGotop()
If Bof() .Or. Eof()
	MsgBox("Atencao... Nao existem dados no arquivo")
	Return(.F.)
Endif

MBrowse( 6,1,22,75,"SC2",,,,,,,,)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDFATR07A  บAutor  ณ Jader              บ Data ณ 23/08/2005  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenchimento das variaveis do Word e impressao            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DFATR07A(nOpc)

Local cArqDot := "CARTA-SEPU.DOT"                        //Nome do Arquivo MODELO do Word

Local cPathDot:= Alltrim(GetMv("MV_PATWORD")) + cArqDot //PATH DO ARQUIVO MODELO WORD NO SERVIDOR ; 
                                                        //CONFIGURAR PATH ABAIXO DO ROOTPATH PROTHEUS 
                                                        //E INFORMAR NO PARAMETRO
Local dDataEmi, cOP, HandleWord
Private nTotPed := 0 ; nCntLin := 0 ; nCntCol := 0
Private cPathEst:= Alltrim(GetMv("MV_PATTERM"))         //PATH DO ARQUIVO A SER ARMAZENADO NA
                                                        //ESTACAO DE TRABALHO, POR EXEMPLO --> C:\WORDTMP\ ou C:\RELATO\
Private cPathView := Alltrim(GetMv("MV_PATVIEW"))       //PATH ONDE ESTA INSTALADO O WORDVIEW.EXE 
                                                        //PODE TER LETRA DO DRIVE   

If !File(cPathDot)                                      //Verifica a existencia do DOT no ROOTPATH Protheus Servidor
	MsgBox(cArqDot+" nao encontrado no Servidor")
	Return NIL
EndIf

cDataEmi := DtExten(Month(dDataBase))
cOP      := SC2->C2_NUM

If File( cPathEst + cArqDot )
// Caso encontre arquivo ja gerado na estacao com o mesmo nome,
// apaga primeiramente antes de gerar a nova impressao
	Ferase( cPathEst + cArqDot )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criando link de comunicacao com o word                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
HandleWord := OLE_CreateLink()

CpyS2T(cPathDot,cPathEst,.T.)                          //Copia do Server para o Remote, eh necessario para que o wordview 
                                                       //e o proprio word possam preparar o arquivo para impressao e ou visualizacao .... 
                                                       //copia o DOT que esta no ROOTPATH Protheus para o PATH da
                                                       //estacao , por exemplo C:\WORDTMP
                                                       //Cria novo arquivo no Word na estacao
OLE_NewFile( HandleWord, cPathEst + cArqDot)

//Salva o arquivo com o novo nome na estacao
OLE_SaveAsFile( HandleWord, cPathEst + "OP" + cOP + ".DOT", , , .F., oleWdFormatDocument )

// Preenche emissao
OLE_SetDocumentVar(HandleWord, "EMISSAO"    ,cDataEmi)  // emissao

// Preenche dados do cliente
// Verificar nomes de variaveis no .DOT via Word ... atraves da tecla ALT+F9

dbSelectArea("SF1")
dbSetOrder(1)
MsSeek(xFilial("SF1") + SC2->C2_NUM_D1  + SC2->C2_SERIED1 + SC2->C2_FORNECE + SC2->C2_LOJA )

dbSelectArea("SA1")
dbSetOrder(1)
//MsSeek(xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA )
MsSeek(xFilial("SA1") + SC2->C2_FORNECE + SC2->C2_LOJA )

OLE_SetDocumentVar(HandleWord, "A1_NOME"   ,SA1->A1_NOME) // nome
OLE_SetDocumentVar(HandleWord, "A1_MUN"    ,SA1->A1_MUN)  // cidade
OLE_SetDocumentVar(HandleWord, "A1_EST"    ,SA1->A1_EST)  // estado
OLE_SetDocumentVar(HandleWord, "C2_NUM"    ,SC2->C2_NUM)  // coleta

// Preenche dados do pneu
// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit

OLE_SetDocumentVar(HandleWord, "C2_PRODUTO"    ,SC2->C2_PRODUTO)  // Medida
OLE_SetDocumentVar(HandleWord, "C2_NUMFOGO"    ,SC2->C2_NUMFOGO)  // fogo
OLE_SetDocumentVar(HandleWord, "C2_SERIEPN"    ,SC2->C2_SERIEPN)  // serie
OLE_SetDocumentVar(HandleWord, "C2_MARCAPN"    ,SC2->C2_MARCAPN)  // marca

// busca motivo da rejeicao/aprovacao
dbSelectArea("SZS")
dbSetOrder(1)
dbSeek(xFilial("SZS")+SC2->C2_XMREDIR)
_cMReDir := Alltrim(SZS->ZS_DESCR)
//_cStatus := U_StatSEPU(SZS->ZS_TIPO)
_cStatus := IF(SZS->ZS_APROVA=="S","APROVADO","REPROVADO")

// Preenche exame do Pneu
// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit
OLE_SetDocumentVar(HandleWord, "C2_XMREDIR"    ,_cMReDir)  // motivo rejeicao/aprovacao
OLE_SetDocumentVar(HandleWord, "STATUS"        ,_cStatus)  // status rejeicao/aprovacao
OLE_SetDocumentVar(HandleWord, "C2_XCOBS3"     ,MSMM(SC2->C2_XCOBS3,,,,3))  // observacao
OLE_SetDocumentVar(HandleWord, "C2_XVALAPR"    ,Transform(SC2->C2_XVALAPR,"@E 999,999.99"))  // valor aprovado

// Preenche assinatura
// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit
OLE_SetDocumentVar(HandleWord, "RESPONSAVEL"    ,PADC(Alltrim(mv_par01),30))  // responsavel
OLE_SetDocumentVar(HandleWord, "CARGO"          ,PADC(Alltrim(mv_par02),30))  // cargo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualizando as variaveis do documento do Word                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
OLE_UpdateFields(HandleWord)
OLE_SaveAsFile( HandleWord, cPathEst + "OP" + cOP + ".DOC", , , .F., oleWdFormatDocument )

If nOpc == 1 // Visualiza
	Ole_CloseFile(HandleWord)  
	lTemExeView := .T.
	If File(cPathView+"WORDVIEW.EXE")
		WordView := cPathView + "WORDVIEW " + cPathEst + "OP" + cOP + ".DOC"
	Else
		MsgBox("Atencao... WordView.Exe nao encontrado em seu equipamento verifique !!!")
		lTemExeView := .F.
	EndIf
	If lTemExeView
	   WaitRun( WordView )
	Endif
Else //Imprime
	Ole_PrintFile(HandleWord,"ALL",,,1) // Imprime o carta
    Inkey(2)
    Ole_CloseFile(HandleWord)
EndIf                                       

///MsgBox("Impressao realizada...!!!")

//fecha link com o Word
Ole_CloseLink(HandleWord)

If File(cPathEst + "OP" + cOP + ".DOT")
	fErase(cPathEst + "OP" + cOP + ".DOT")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DtExten  บAutor  ณ Jader              บ Data ณ 23/08/2005  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para retornar a data por extenso                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DtExten(nMes)

Local aMesExtenso := {}
Local cMes := ""

AAdd(aMesExtenso," de Janeiro de ")
AAdd(aMesExtenso," de Fevereiro de ")
AAdd(aMesExtenso," de Marco de ")
AAdd(aMesExtenso," de Abril de ")
AAdd(aMesExtenso," de Maio de ")
AAdd(aMesExtenso," de Junho de ")
AAdd(aMesExtenso," de Julho de ")
AAdd(aMesExtenso," de Agosto de ")
AAdd(aMesExtenso," de Setembro de ")
AAdd(aMesExtenso," de Outubro de ")
AAdd(aMesExtenso," de Novembro de ")
AAdd(aMesExtenso," de Dezembro de ")

cMes    := aMesExtenso[nMes]

dDataEmi := "Sใo Paulo , " + StrZero(Day(ddatabase),2,0) + cMes + Str(Year(dDataBase),4,0)

Return(dDataEmi)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ StatSEPU บAutor  ณ Jader              บ Data ณ 23/08/2005  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para o status do motivo do SEPU                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function StatSEPU(_cTipo)

Local _cStatus := ""

If _cTipo == "1"
	_cStatus := "BONIFICACAO DE PNEU RECLAMADO"
ElseIf _cTipo == "2"
	_cStatus := "BONIFICACAO CONSERTO"
ElseIf _cTipo == "3"
	_cStatus := "BONIFICACAO COMERCIAL"
ElseIf _cTipo == "4"
	_cStatus := "CREDITOS DIVERSOS"
ElseIf _cTipo == "5"
	_cStatus := "RECUSADO"
ElseIf _cTipo == "6"
    _cStatus := "BONIFICACAO CUPOM PIRELLI"
Endif

Return(_cStatus)