#include "rwmake.ch"

User Function DLOJA01
	Private cTabela   := "PA8"
	Private cCadastro := ""
	Private cFilCpo   := ""
	Private aRotina   := {}
	Private aAtuCpo   := {}
	Private aAltera   := {}

	cFilCpo := "PA8_CODCLI*PA8_LOJCLI*PA8_NOMCLI*PA8_ITEM*PA8_ITORC*PA8_ITREF*PA8_VLPROSG*PA8_ORCSN"
	cFilCpo += "PA8_NFSN*PA8_SRSN*PA8_PERC*PA8_VLRCLI*PA8_VLRSEG*PA8_VLRCOR*PA8_DEVOL*PA8_MSEXP"

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := AllTrim(X2_NOME)
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	Do while !eof()
		aadd(aAtuCpo,AllTrim(X3_CAMPO))

		If X3_CONTEXT <> "V" .AND. X3_VISUAL <> "V" .AND. !(AllTrim(X3_CAMPO) $ cFilCpo)
			aadd(aAltera,AllTrim(X3_CAMPO))
		Endif
		dbSkip()
	Enddo

	aadd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aadd(aRotina,{"Visualizar","U_DLOJA01V",0,2})
	aadd(aRotina,{"Alterar"   ,"U_DLOJA01A",0,4})

	dbselectarea(cTabela)
	MBrowse(100,001,300,400,cTabela)
Return

User Function DLOJA01V(cAlias,nReg,nOpc)
	AxVisual(cAlias,nReg,nOpc,aAtuCpo)
Return

User Function DLOJA01A(cAlias,nReg,nOpc)
	AxAltera(cAlias,nReg,nOpc,aAtuCpo,aAltera)
Return