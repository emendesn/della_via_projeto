 MaFisIniNF(2,SF2->(Recno()),@aOtimizacao,"SF2",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a gravacao nas funcoes Fiscais               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 MaFisWrite()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua a gravacao dos registros referente a Nota no SF3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
MaFisAtuSF3(1,"S",SF2->(Recno()),"SF2")
dbSelectArea("SF3")
dbSetOrder(5)
If MsSeek( xFilial("SF3") + cSerNota + cNumNota )
	While !Eof() .AND. xFilial("SF3")+cSerNota+cNumNota == SF3->F3_FILIAL+SF3->F3_SERIE+SF3->F3_NFISCAL
		RecLock("SF3",.F.)
		SF3->F3_DTCANC        := dDatabase
		SF3->F3_OBSERV       := "NF CANCELADA"
		SF3->(MsUnLock())
		MaFisEnd()
		MsUnLock()
		SF3->(dbSkip())
	Enddo
Endif
