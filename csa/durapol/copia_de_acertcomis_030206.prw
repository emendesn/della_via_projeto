#include "rwmake.ch"
User Function AcertComis
Local _aArea := GetArea()

Processa({|| Ajuste()},"Atualizando ...")

RestArea(_aArea)
Return

Static Function Ajuste

Local _aArea      := GetArea()
Local _nComis3 :=0
Local _nComis4 :=0
Local _nComis5 :=0
Local cVend3   := ""
Local cVend4   := ""
Local cVend5   := ""
Local _cNota      := ""
Local _cSerie     := ""

dbSelectArea("SC5")
ProcRegua(SC5->(LastRec()))
dbGotop()

nProc  := 0
nProc2 := 0


While !Eof()
	IncProc("Atualizando pedidos...Atual= "+SC5->C5_NUM)
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	IF Empty(SC5->C5_VEND3)
		dbSelectArea("SC5")	
			Reclock("SC5",.F.)
				SC5->C5_VEND3 := SA1->A1_VEND3
			MsUnlock()
	EndIF
	IF Empty(SC5->C5_VEND4)
		dbSelectArea("SC5")	
			Reclock("SC5",.F.)
				SC5->C5_VEND4 := SA1->A1_VEND4
			MsUnlock()
	EndIF
	IF Empty(SC5->C5_VEND5)
		dbSelectArea("SC5")	
			Reclock("SC5",.F.)
				SC5->C5_VEND5 := SA1->A1_VEND5
			MsUnlock()
	EndIF
	//Recupero os %
	_cNota  := SC5->C5_NOTA
	_cSerie := SC5->C5_SERIE
	cVend3  := SC5->C5_VEND3
	cVend4  := SC5->C5_VEND4
	cVend5  := SC5->C5_VEND5
	
	SA3->(dbSetOrder(1))
	SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND3))
		_nComis3 := SA3->A3_COMIS
	SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND4))
		_nComis4 := SA3->A3_COMIS
	SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND5))
		_nComis5 := SA3->A3_COMIS
	//Atualiza SC5
	dbSelectArea("SC5")	
	Reclock("SC5",.F.)
		SC5->C5_COMIS3 := _nComis3
		SC5->C5_COMIS4 := _nComis4
		SC5->C5_COMIS5 := _nComis5
	MsUnLock()
		
	//Atualiza sc6
	SC6->(dbSetOrder(4))
	SC6->(dbSeek(xFilial("SC6")+_cNota+_cSerie))
	While !Eof() .and. xFilial("SC6")+_cNota+_cSerie == SC6->C6_FILIAL+SC6->C6_NOTA+SC6->C6_SERIE
		Reclock("SC6",.F.)
			SC6->C6_COMIS3 := _nComis3
			SC6->C6_COMIS4 := _nComis4
			SC6->C6_COMIS5 := _nComis5
		MsUnlock()
		dbSkip()
	EndDo
	//Atualiza SF2
	dbSelectArea("SF2")
	dbSetOrder(1)
	IF dbSeek(xFilial("SF2")+_cNota+_cSerie)
	
		Reclock("SF2",.F.)
			SF2->F2_VEND3 := cVend3
			SF2->F2_VEND4 := cVend4
			SF2->F2_VEND5 := cVend5
		MsUnlock()
	EndIF	
	
	//Atualiza SD2
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(xFilial("SC6")+_cNota+_cSerie))
	While !Eof().and. xFilial("SD2")+_cNota+_cSerie == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
		Reclock("SD2",.F.)
			SD2->D2_COMIS3 := _nComis3
			SD2->D2_COMIS4 := _nComis4
			SD2->D2_COMIS5 := _nComis5
		MsUnlock()
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	//Atualiza SE1
	SE1->(dbSetOrder(1))
	SE1->(dbSeek(xFilial("SE1")+_cSerie+_cNota))
	While !Eof() .and. xFilial("SC5")+_cSerie+_cNota == SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM
			Reclock("SE1",.F.)
			SE1->E1_COMIS3 := _nComis3
			SE1->E1_COMIS4 := _nComis4
			SE1->E1_COMIS5 := _nComis5
		MsUnlock()
		dbSkip()
	EndDo
	_nComis3 := 0
	_nComis4 := 0
	_nComis5 := 0
	dbSelectArea("SC5")
	dbSkip()
EndDo

RestArea(_aArea)
Return