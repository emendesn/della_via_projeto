#include "rwmake.ch"
#include "topconn.ch"

User Function DSEPUA03
	Private cCadastro := ""
	Private cNomTmp   := ""
	Private cTabSX5   := "SP"
	Private aPicture  := {{"X5_CHAVE","Motivo","!!"},{"X5_DESCRI","Descrição","@!"}}
	Private aRotina   := {}
	Private aAtuCpo   := {}
	Private aAltera   := {}


	MsgRun("Preparando Cadastro ...",,{|| PrepSX3() })


	// Define Campos exibição
	aAdd(aAtuCpo,"X5_CHAVE")
	aAdd(aAtuCpo,"X5_DESCRI")


	// Define Campos permitindo alteração
	aAdd(aAltera,"X5_DESCRI")


	// Filtra registro da tabela no SX5
	dbselectarea("SX5")
	dbSetFilter({|| X5_TABELA = cTabSX5 },"X5_TABELA = cTabSX5")


	// Variáveis do MBrowse
	cCadastro := Capital(AllTrim(FunDesc()))

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui"    ,0,1})
	aAdd(aRotina,{"Visualizar","U_SEPUA03Vis",0,2})
	aAdd(aRotina,{"Incluir"   ,"U_SEPUA03Inc",0,3})
	aAdd(aRotina,{"Alterar"   ,"U_SEPUA03Alt",0,4})
	aAdd(aRotina,{"Excluir"   ,"U_SEPUA03Exc",0,5})

	MBrowse(,,,,"SX5")

	dbselectarea("SX5")
	dbClearFilter()


	// Retorna SX3 Original
	dbselectarea("SX3")
	dbCloseArea()
	dbUseArea(.T.,,"SX3"+Substr(cNumEmp,1,2)+"0","SX3",.T.,.F.)
	

	// Apaga temporários
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())
Return

User Function SEPUA03Vis(cAlias,nReg,nOpc)
	AxVisual(cAlias,nReg,nOpc,aAtuCpo)
Return

User Function SEPUA03Inc(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons)
	Local   aCRA    := {"Confirma","Redigita","Abandona"}
	Private aTELA[0][0]
	Private aGETS[0]
	Private cOpcao  := ""
	Private lF3     := .F.
	Private cTudoOk := ".T."

	bOk := &("{|| "+cTudoOk+"}")

	RegToMemory("SX5",(cOpcao=="INCLUIR"))

	M->X5_TABELA := cTabSX5
	M->X5_CHAVE  := Space(06)
	M->X5_DESCRI := Space(55)

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 9,0 TO TranslateBottom(.F.,28),80 OF oMainWnd
	aPosEnch := {,,(oDlg:nClientHeight - 4)/2,}  // Ocupa todo o espaço da janela
	EnChoice(cAlias,nReg,nOpc,aCRA,"CRA","Quanto … inclusão?",aAtuCpo,aPosEnch,aAtuCpo,,,,cTudoOk,,lF3)
	nOpca := 3
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,If(Obrigatorio(aGets,aTela).and. Eval(bOk),oDlg:End(),(nOpca:=3,.f.))},{|| nOpca := 3,oDlg:End()},,aButtons)
	dbSelectArea("SX5")
	dbSeek(xFilial("SX5")+M->X5_TABELA+M->X5_CHAVE)
	if !Found()
		If nOpcA == 1
			If RecLock("SX5",.T.)
				SX5->X5_FILIAL  := xFilial("SX5")
				SX5->X5_TABELA  := M->X5_TABELA
				SX5->X5_CHAVE   := M->X5_CHAVE
				SX5->X5_DESCRI  := M->X5_DESCRI
				SX5->X5_DESCENG := M->X5_DESCRI
				SX5->X5_DESCSPA := M->X5_DESCRI
				MsUnLock()
			Endif
		Endif
	Else
		Help(" ",1,"Ja Cadastrado",,"Chave ja cadastrada na tabela",4,1)
	Endif
Return

User Function SEPUA03Alt(cAlias,nReg,nOpc)
	AxAltera(cAlias,nReg,nOpc,aAtuCpo,aAltera)
Return

User Function SEPUA03Exc(cAlias,nReg,nOpc)
	AxDeleta(cAlias,nReg,nOpc,,aAtuCpo)
Return

Static Function PrepSX3()
	// Cria SX3 Temporário
	dbSelectArea("SX3")
	cNomTmp := CriaTrab(Nil,.F.)
	Copy To &cNomTmp for X3_ARQUIVO = "SX5" .AND. !(AllTrim(X3_CAMPO) $ "X5_DESCENG*X5_DESCSPA")
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"SX3",.F.,.F.)
	Index On X3_ARQUIVO+X3_ORDEM           TAG IND1 To &cNomTmp
	Index On X3_CAMPO                      TAG IND2 To &cNomTmp
	Index On X3_GRPSXG+X3_ARQUIVO+X3_ORDEM TAG IND3 To &cNomTmp
	Index On X3_ARQUIVO+X3_FOLDER+X3_ORDEM TAG IND4 To &cNomTmp

	// Altera descrições e pictures no SX3 Temporário
	dbSelectArea("SX3")
	dbSetOrder(2)

	For k=1 To Len(aPicture)
		dbSeek(aPicture[k,1])
		If RecLock("SX3",.F.)
			X3_TITULO  := aPicture[k,2]
			X3_PICTURE := aPicture[k,3]
			MsUnlock()
		Endif
	Next
Return