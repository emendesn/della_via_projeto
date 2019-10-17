#include "rwmake.ch"
#include "topconn.ch"

User Function DVIMP01()
	Private Titulo      := "Atualiza Data de ultima compra - TXT"
	Private aSays       := {}
	Private aButtons    := {}
	Private cFile       := ""
	Private cEOL        := "CHR(13)+CHR(10)"
	Private lAbortPrint := .F.

	cEOL := &cEOL // Caracter de Fim de linha

	aAdd(aSays,"Esta rotina atualiza o campo A1_ULTCOM de acordo com arquivo TXT selecionado,")
	aAdd(aSays,"verificando se existe nota para o cliente no SF2 ou não.")
	aAdd(aSays," ")
	aAdd(aSays,'Utilize o botão "Parametros" para selecionar o arquivo')

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcImp() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| cFile := cGetFile("Arquivos Texto | *.TXT|Todos os Arquivos | *.*", "Selecione o Arquivo") }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcImp()
	Local cBuffer     := ""
	Local nEOF        := 0
	Local nTamLinha   := 22
	Local nBytesLidos := 0
	Local nAtu        := 0
	Local cCnpj       := ""
	Local dUltCom     := ctod("//")
	Local aEstru      := {}
	Local cNomTmp     := ""
	Local lLog        := .F.
	Local cLog        := ""

	if Empty(cFile)
		msgbox("Primeiro voce selecionar um arquivo para importação!","Importação","STOP")
		Return nil
	Endif
	
	If !msgbox("Confirma o processamento do arquivo"+chr(10)+chr(13)+cFile+"?","Importação","YESNO")
		Return nil
	Endif
	
	nHdl := fOpen(cFile)
	If fError() != 0
		msgbox("Ocorreu um erro na abertura do arquivo","Importação","STOP")
		Return nil
	Endif

	FechaBatch()

	aEstru := {}
	aadd(aEstru,{"T_HORA"     ,"C",20,0})
	aadd(aEstru,{"T_SEP0"     ,"C",01,0})
	aadd(aEstru,{"T_CNPJ"     ,"C",14,0})
	aadd(aEstru,{"T_SEP1"     ,"C",01,0})
	aadd(aEstru,{"T_DATA"     ,"C",10,0})
	aadd(aEstru,{"T_SEP2"     ,"C",01,0})
	aadd(aEstru,{"T_DESC"     ,"C",50,0})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)

	nEOF := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)

	ProcRegua(nEOF/(nTamLinha + Len(cEOL)))
	
	Do While nEOF > nBytesLidos
		incProc(Str((nBytesLidos/nEOF)*100,5,2)+"% concluido")

		if lAbortPrint
			exit
		endif

		nBytesLidos += fRead(nHdl,@cBuffer,nTamLinha + Len(cEOL))
		cCnpj       := Substr(cBuffer,1,14)
		dUltCom     := stod(Substr(cBuffer,19,4)+Substr(cBuffer,17,2)+Substr(cBuffer,15,2))
		lLog        := .F.
		
		dbSelectArea("SA1")
		dbSetOrder(3)
		dbSeek(xFilial("SA1")+cCnpj)
		If Found()
			if VerSF2(SA1->A1_COD,SA1->A1_LOJA)
				If RecLock("SA1",.F.)
					SA1->A1_ULTCOM := dUltCom
					MsUnlock()
				Endif
			Else
				lLog := .T.
				cLog := "EXISTE NOTA FISCAL PARA ESSE CLIENTE"
			Endif
		Else
			lLog := .T.
			cLog := "CLIENTE NAO ENCONTRADO"
		Endif
		
		If lLog
			If RecLock("TMP",.T.)
				TMP->T_HORA := dtoc(Date())+" - "+Time()
				TMP->T_CNPJ := cCnpj
				TMP->T_DATA := dtoc(dUltCom)
				TMP->T_DESC := cLog
			Endif
		Endif
	Enddo
	fClose(nHdl)

	dbSelectArea("TMP")
	If Lastrec() > 0
		dbGoTop()
		Copy to DVIMP01.LOG SDF
		if msgbox("Deseja imprimir o Log de inconsistencias?","DVIMP01.LOG","YESNO")
			ImpLog()
		Endif
	Endif
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	msgbox("Atualização concluida com sucesso","Importação","INFO")
Return nil

Static Function VerSF2(cCodCli,cLojaCli)
	Local cSql := ""
	Local lRet := .T.
	
	cSql := "SELECT F2_DOC"
	cSql += " FROM "+RetSqlName("SF2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   F2_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   F2_CLIENTE = '"+cCodCli+"'"
	cSql += " AND   F2_LOJA = '"+cLojaCli+"'"
	cSql += " FETCH FIRST 1 ROWS ONLY"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	lRet := Empty(F2_DOC)
	dbCloseArea()
Return lRet

Static Function Implog()
	Private cString        := ""
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Relatório de inconsistencias - DVIMP01.LOG"
	Private tamanho        := "M"
	Private nomeprog       := "DVIMP01"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := ""
	Private titulo         := "Relatório de inconsistencias - DVIMP01.LOG"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVIMP01"
	
	lAbortPrint := .F.

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
	   Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
	   Return
	Endif

	Processa({|| RunReport() },Titulo,,.t.)
Return

Static Function RunReport()
	Cabec1:=" Data                   Cnpj / CPF       Ult.Compra   Erro"
	        * XXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXX   99/99/99     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    	    *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbgoTop()

	Do While !eof()
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
		Endif

		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif
	
		@ LI,001 PSAY T_HORA
		@ LI,024 PSAY T_CNPJ
		@ LI,041 PSAY T_DATA
		@ LI,054 PSAY T_DESC
		LI++
		dbSkip()
	Enddo

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil