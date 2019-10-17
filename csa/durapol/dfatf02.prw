#include "rwmake.ch"
#include "topconn.ch"

User Function DFATF02
	Private Titulo   := "Corrige vendedores no SA1"
	Private aSays    := {}
	Private aButtons := {}

	If SM0->M0_CODIGO <> "03"
		MsgStop("Este programa só pode ser executado na Durapol")
		Return
	Endif

	aAdd(aSays,"Esta rotina lê um temporário em DBF e atualiza as informações referentes aos")
	aAdd(aSays,"vendedores e atualiza na tabela SA1")
	aAdd(aSays,"")
	aAdd(aSays,"\SYSTEM\TEMP\SA1SOR.DBF")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcAtu() },Titulo,,.t.) }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcAtu()
	FechaBatch()
	If !File("\SYSTEM\TEMP\SA1SOR.DBF")
		msgbox("O arquivo \SYSTEM\TEMP\SA1SOR.DBF não foi encontrado, o programa será encerrado!!!","DFATF01","STOP")
		Return nil
	Endif

	cNomTmp := CriaTrab(,.F.)
	dbUseArea(.T.,"DBFCDXADS","\SYSTEM\TEMP\SA1SOR","SS",.F.,.F.)
	IndRegua("SS",cNomTmp,"COD+LOJA",,.t.,"Selecionando Registros...")
	dbSelectArea("SS")
	ProcRegua(LastRec())
	dbGoTop()

	Do While !eof()
		incProc(COD+" - "+LOJA)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SS->COD+SS->LOJA)
		If Found()
			If RecLock("SA1",.F.)
				If (A1_VEND3 = "000000" .OR. A1_VEND3 = Space(6)) .AND. SS->VEND3 <> Space(6)
					SA1->A1_VEND3 := SS->VEND3
				Endif
				If (A1_VEND4 = "000000" .OR. A1_VEND4 = Space(6)) .AND. SS->VEND4 <> Space(6)
					SA1->A1_VEND4 := SS->VEND4
				Endif
				If (A1_VEND5 = "000000" .OR. A1_VEND5 = Space(6)) .AND. SS->VEND5 <> Space(6)
					SA1->A1_VEND5 := SS->VEND5
				Endif
				MsUnlock()
			Endif
		Endif
		dbSelectArea("SS")
		dbSkip()
	Enddo
	dbCloseArea()
	msgbox("Fim de programa !!!","DFATF02","INFO")
Return nil