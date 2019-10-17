#Include "MSOLE.CH"
#Include "RWMAKE.CH"  //"FIVEWIN.CH"
#Include "FONT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DFATR08A ³ Autor ³ Ely Antunes           ³ Data ³ 26.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da ficha de SEPU                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Durapol                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DFATR08()

PRIVATE cCadastro := "Emissao de Ficha SEPU"
PRIVATE aRotina := {{"Pesquisa" ,"AxPesqui"  ,0,1},;
					{"Visualiza","U_DFATR08A(1)",0,2},;
					{"Imprime"  ,"U_DFATR08A(2)"  ,0,4}}

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DFATR08A ³ Autor ³ Ely Antunes           ³ Data ³ 26.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao Ficha de SEPU preenchimento dos campos do DOT    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DFATR08A(nOpc)

Local cArqDot := "FICHASEPU.DOT"  // Nome do Arquivo MODELO do Word
Local cPathDot:= Alltrim(GetMv("MV_PATWORD")) + cArqDot // PATH DO ARQUIVO MODELO WORD 
//NO SERVIDOR ; CONFIGURAR PATH ABAIXO DO ROOTPATH PROTHEUS E INFORMAR NO PARAMETRO
Local dDataEmi, cOP, HandleWord
Private nTotPed := 0 ; nCntLin := 0 ; nCntCol := 0
Private cPathEst:= Alltrim(GetMv("MV_PATTERM")) // PATH DO ARQUIVO A SER ARMAZENADO NA
//ESTACAO DE TRABALHO, POR EXEMPLO --> C:\WORDTMP\ ou C:\RELATO\
Private cPathView := Alltrim(GetMv("MV_PATVIEW")) // PATH ONDE ESTA INSTALADO O WORDVIEW.EXE 
// PODE TER LETRA DO DRIVE   

If !File(cPathDot) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgBox(cModelo+" nao encontrado no Servidor")
	Return NIL
EndIf

cOP := SC2->C2_NUM

If File( cPathEst + cArqDot ) // Caso encontre arquivo ja gerado na estacao
//com o mesmo nome apaga primeiramente antes de gerar a nova impressao
	Ferase( cPathEst + cArqDot )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando link de comunicacao com o word                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
HandleWord := OLE_CreateLink()

CpyS2T(cPathDot,cPathEst,.T.) // Copia do Server para o Remote, eh necessario
//para que o wordview e o proprio word possam preparar o arquivo para impressao e
// ou visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da
// estacao , por exemplo C:\WORDTMP

//Cria novo arquivo no Word na estacao
OLE_NewFile( HandleWord, cPathEst + cArqDot)

//Salva o arquivo com o novo nome na estacao
OLE_SaveAsFile( HandleWord, cPathEst + "FP" + cOP + ".DOT", , , .F., oleWdFormatDocument )

// Preenche dados do cliente
// Verificar nomes de variaveis no .DOT via Word ... atraves da tecla ALT+F9

dbSelectArea("SF1")
dbSetOrder(1)
MsSeek(xFilial("SF1")+SC2->C2_NUM)

dbSelectArea("SD1")
dbSetOrder(2)
MsSeek(xFilial("SD1")+SC2->C2_PRODUTO+SC2->C2_NUM,.f.)

dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA )

OLE_SetDocumentVar(HandleWord, "A1_COD"    ,SA1->A1_COD)  // codigo
OLE_SetDocumentVar(HandleWord, "A1_NOME"   ,SA1->A1_NOME) // nome
OLE_SetDocumentVar(HandleWord, "A1_END"    ,SA1->A1_END)  // endereco
OLE_SetDocumentVar(HandleWord, "A1_MUN"    ,SA1->A1_MUN)  // cidade
OLE_SetDocumentVar(HandleWord, "A1_EST"    ,SA1->A1_EST)  // estado
OLE_SetDocumentVar(HandleWord, "A1_TEL"    ,SA1->A1_TEL)  // telefone

// Preenche dados da Ficha da OP
// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit

OLE_SetDocumentVar(HandleWord, "C2_EMISSAO"    ,DTOC(dDataBase))  // data de emissao

OLE_SetDocumentVar(HandleWord, "C2_XCOLORI"    ,SC2->C2_XCOLORI)  // coleta original
OLE_SetDocumentVar(HandleWord, "C2_XDPRDOR"    ,SC2->C2_XDPRDOR)  // data coleta original
OLE_SetDocumentVar(HandleWord, "C2_XULTNF"     ,SC2->C2_XULTNF)  // ultima nf fatura
OLE_SetDocumentVar(HandleWord, "C2_XDFATOR"    ,SC2->C2_XDFATOR)  // data fatura original
OLE_SetDocumentVar(HandleWord, "C2_NUM"        ,SC2->C2_NUM+SC2->C2_ITEM)      // coleta exame
OLE_SetDocumentVar(HandleWord, "F1_EMISSAO"    ,SF1->F1_DTDIGIT)  // data coleta exame
OLE_SetDocumentVar(HandleWord, "C2_EMISSAO"    ,SC2->C2_EMISSAO)  // data inspecao

// Preenche dados do Pneu
// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit

OLE_SetDocumentVar(HandleWord, "C2_PRODUTO"    ,SC2->C2_PRODUTO)  // medida
OLE_SetDocumentVar(HandleWord, "C2_MARCAPN"    ,SC2->C2_MARCAPN)  // marca
OLE_SetDocumentVar(HandleWord, "C2_XBANDA"     ,SC2->C2_XBANDA)   // banda
OLE_SetDocumentVar(HandleWord, "C2_SERIEPN"    ,SC2->C2_SERIEPN)  // serie
OLE_SetDocumentVar(HandleWord, "C2_NUMFOGO"    ,SC2->C2_NUMFOGO)  // fogo

OLE_SetDocumentVar(HandleWord, "C2_XSERVOR"    ,SC2->C2_XSERVOR)  // servico original
OLE_SetDocumentVar(HandleWord, "D1_SERVICO"    ,SD1->D1_SERVICO)  // servico exame
OLE_SetDocumentVar(HandleWord, "C2_XPRCTAB"    ,SC2->C2_XPRCTAB)  // preco tabela
OLE_SetDocumentVar(HandleWord, "C2_XPROFOR"    ,SC2->C2_XPROFOR)  // profundidade original
OLE_SetDocumentVar(HandleWord, "C2_XPROFAF"    ,SC2->C2_XPROFAF)  // profundidade aferida

dbSelectArea("SZS")
dbSetOrder(1)

// Preenche dados da analise da producao
// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit
                                                                           
MsSeek(xFilial("SZS")+SC2->C2_XMREPRD)

_cMotivo := SZS->ZS_COD + " - " + Alltrim(SZS->ZS_DESCR)
//_cStatus := U_StatSEPU(SZS->ZS_TIPO)
_cStatus := IF(SZS->ZS_APROVA=="S","APROVADO","REPROVADO")

OLE_SetDocumentVar(HandleWord, "MOTIVOPRD"    ,_cMotivo)  // motivo
OLE_SetDocumentVar(HandleWord, "STATUSPRD"    ,_cStatus)  // status
OLE_SetDocumentVar(HandleWord, "OBSPRD"       ,MSMM(SC2->C2_XCOBS1,,,,3))  // observacao

// Preenche dados da analise da comercial
// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit
                                                                           
MsSeek(xFilial("SZS")+SC2->C2_XMREFIN)

_cMotivo := SZS->ZS_COD + " - " + Alltrim(SZS->ZS_DESCR)
//_cStatus := U_StatSEPU(SZS->ZS_TIPO)
_cStatus := IF(SZS->ZS_APROVA=="S","APROVADO","REPROVADO")

OLE_SetDocumentVar(HandleWord, "MOTIVOCOM"    ,_cMotivo)  // motivo
OLE_SetDocumentVar(HandleWord, "STATUSCOM"    ,_cStatus)  // status
OLE_SetDocumentVar(HandleWord, "OBSCOM"       ,MSMM(SC2->C2_XCOBS2,,,,3))  // observacao

// Preenche dados da analise da comercial
// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit
                                                                           
MsSeek(xFilial("SZS")+SC2->C2_XMREDIR)

_cMotivo := SZS->ZS_COD + " - " + Alltrim(SZS->ZS_DESCR)
//_cStatus := U_StatSEPU(SZS->ZS_TIPO)
_cStatus := IF(SZS->ZS_APROVA=="S","APROVADO","REPROVADO")

OLE_SetDocumentVar(HandleWord, "MOTIVODIR"    ,_cMotivo)  // motivo
OLE_SetDocumentVar(HandleWord, "STATUSDIR"    ,_cStatus)  // status
OLE_SetDocumentVar(HandleWord, "OBSDIR"       ,MSMM(SC2->C2_XCOBS3,,,,3))  // observacao

OLE_SetDocumentVar(HandleWord, "C2_XVALAPR"    ,Transform(SC2->C2_XVALAPR,"@E 999,999,999.99"))  // valor aprovado


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando as variaveis do documento do Word                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_UpdateFields(HandleWord)
OLE_SaveAsFile( HandleWord, cPathEst + "FP" + cOP + ".DOC", , , .F., oleWdFormatDocument )

If nOpc == 1 // Visualiza
	Ole_CloseFile(HandleWord)  
	lTemExeView := .T.
	If File(cPathView+"WORDVIEW.EXE")
		WordView := cPathView + "WORDVIEW " + cPathEst + "FP" + cOP + ".DOC"
	Else
		MsgBox("Atencao... WordView.Exe nao encontrado em seu equipamento verifique !!!")
		lTemExeView := .F.
	EndIf
	If lTemExeView
	   WaitRun( WordView )
	Endif
Else //Imprime
	Ole_PrintFile(HandleWord,"ALL",,,1) // Imprime o ficha
	Inkey(2)
    Ole_CloseFile(HandleWord)
EndIf                                       

//fecha link com o Word
Ole_CloseLink(HandleWord)

If File(cPathEst + "FP" + cOP + ".DOT")
	fErase(cPathEst + "FP" + cOP + ".DOT")
EndIf

Return
