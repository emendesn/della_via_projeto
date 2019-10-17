USER FUNCTION GeraSB2()
     
Processa({|| RunProc()})

Return

STATIC FUNCTION RunProc

dbSelectArea("SB9")
dbSetOrder(1)
dbSeek(xFilial("SB9"),.T.)
ProcRegua(RecCount()/50)

While !Eof() .And. xFilial("SB9") == SB9->B9_FILIAL

  IncProc("Aguarde Atualização... " + SB9->B9_FILIAL+"-"+SB9->B9_COD)
  
  dbSelectArea("SB2")
  dbSetOrder(1)
  If dbSeek(xFilial("SB2")+SB9->B9_COD+SB9->B9_LOCAL,.F.) 
     RecLock("SB2",.F.)
  Else
     RecLock("SB2",.T.)
  EndIf
  SB2->B2_FILIAL := xFilial("SB2")
  SB2->B2_COD    := SB9->B9_COD
  SB2->B2_QATU   := SB9->B9_QINI                        
  SB2->B2_LOCAL  := SB9->B9_LOCAL
  SB2->B2_VATU1  := SB9->B9_VINI1
  SB2->B2_CM1    := Iif(SB9->B9_QINI > 0, SB9->B9_VINI1 / SB9->B9_QINI, 0 )
  MsUnlock()
  
  dbSelectArea("SB9")
  dbSkip()

EndDo     

Return