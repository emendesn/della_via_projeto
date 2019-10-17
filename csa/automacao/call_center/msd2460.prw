
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460   ºAutor  ³Microsiga           º Data ³  07/27/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. para ataualizar o status do atendimento quando a NF forº±±
±±º          ³Emitida                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSD2460()
Local aArea    := GetArea()
Local aAreaSF2 := SF2->(GetArea())
Local aAreaSUA := SUA->(GetArea())
Local aMM  := {}
Local aTam := TamSX3("D2_MM")
Local nTam := aTam[1] - aTam[2] - 1

If cEmpAnt <> "01" //<> de Della Via
	Return
EndIf

DbSelectArea("SUA")
DbSetOrder(8)
If DbSeek(xFilial("SUA")+SD2->D2_PEDIDO)
	RecLock("SUA",.F.)
	SUA->UA_STATUS	:= "NF."
	SUA->UA_DOC		:= SD2->D2_DOC
	SUA->UA_SERIE	:= SD2->D2_SERIE
	SUA->UA_EMISNF	:= dDatabase
	MsUnlock()
Endif

dbSelectArea("SF2")
dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
dbSeek(xFilial("SF2") + SD2->(D2_DOC + D2_SERIE))

aMM := P_MargemMedia(SD2->D2_COD, SD2->D2_LOCAL, SD2->D2_QUANT, SF2->F2_TIPVND, SD2->D2_TOTAL)

RecLock("SD2", .F.)
SD2->D2_CM1    := IIf(SD2->D2_QUANT <> 0, SD2->D2_CUSTO1 / SD2->D2_QUANT, 0)
SD2->D2_DESPMM := aMM[2]
SD2->D2_MM     := IIf(Abs(aMM[1]) >= (10 ^ nTam), (10 ^ nTam) - 1, aMM[1])
msUnlock()

RestArea(aAreaSF2)
RestArea(aAreaSUA)
RestArea(aArea)

Return
