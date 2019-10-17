USER FUNCTION Empenho

Processa({|| RunProc()})

return

STATIC FUNCTION RunProc

dbSelectArea("SC2")
dbSetOrder(1)
dbGotop()
ProcRegua(RecCount())

While !Eof() // .And. xFilial("SC2") == SC2->C2_FILIAL .And. Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) == "07501507001"
   IncProc(" OP " + SC2->C2_NUM + " DATA " + DTOS(SC2->C2_EMISSAO) )
   If SC2->C2_QUJE == 0
      SC2->( dbSkip() )
      Loop
   EndIf 
   If SC2->C2_EMISSAO > CtoD("11/08/2005")
      SC2->( dbSkip() )
      Loop
   EndIf 
   dbSelectArea("SD3")
   dbSetOrder(1)
   dbSeek(xFilial("SD3")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,.F.)
   lTemProducao   := .F.
   lTemRequisicao := .F.
   While !Eof() .And. xFilial("SD3") == SD3->D3_FILIAL .And. Alltrim(SD3->D3_OP) == Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
      If SD3->D3_ESTORNO == "S"
         SD3->( dbSkip() )
         Loop
      EndIf
      If SD3->D3_EMISSAO > CtoD("11/08/2005")
         SD3->( dbSkip() )
         Loop
      EndIf
      If SD3->D3_LOCAL != "98"
         SD3->( dbSkip() )
         Loop
      EndIf
      If SD3->D3_CF == "PR0"
         lTemProducao := .T.
         RecLock("SD3",.F.)
           SD3->D3_LOCAL := "01"
         MsUnlock()
         SD3->( dbSkip() )
         Loop
      EndIf                 
      If "RE" $ SD3->D3_CF
         lTemRequisicao := .T.
         SD3->( dbSkip() )
         Loop
      EndIf                 
      SD3->( dbSkip() )   
   EndDo
   If ( lTemProducao .And. !lTemRequisicao )
      dbSelectArea("SD4")
      dbSetOrder(2)
      dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,.F.)
      While !Eof() .And. xFilial("SD4") == SD4->D4_FILIAL .And. Alltrim(SD4->D4_OP) == Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
          SB1-> (dbSeek(xFilial("SB1")+SD4->D4_COD,.F.) )
          If SB1->B1_TIPO == "MO"
             SB1-> (dbSeek(xFilial("SB1")+SB1->B1_PRODUTO,.F.) )
          EndIf                  
          
          If Alltrim(SD4->D4_COD) == "245"                      
             SB1-> (dbSeek(xFilial("SB1")+"B140",.F.) )
          EndIf
          
          If Alltrim(SD4->D4_COD) == "243"                      
             SB1-> (dbSeek(xFilial("SB1")+"B120",.F.) )
          EndIf
          
          dbSelectArea("SD3")
          RecLock("SD3",.T.)
            SD3->D3_FILIAL := xFilial("SD3")
            SD3->D3_TM     := "502"
            SD3->D3_OP     := SD4->D4_OP
            SD3->D3_COD    := SB1->B1_COD
            SD3->D3_UM     := SB1->B1_UM
            SD3->D3_QUANT  := SD4->D4_QTDEORI  
            SD3->D3_CF     := "RE0"
            SD3->D3_LOCAL  := "01"
            SD3->D3_EMISSAO:= SC2->C2_DATRF
            SD3->D3_GRUPO  := SB1->B1_GRUPO
            SD3->D3_SEGUM  := SB1->B1_SEGUM
            SD3->D3_QTSEGUM:= SD4->D4_QTSEGUM
            SD3->D3_TIPO   := SB1->B1_TIPO
            SD3->D3_CHAVE  := "E0"
            SD3->D3_DOC    := NextNumero("SD3",2,"D3_DOC",.T.)
            SD3->D3_NUMSEQ := ProxNum()
          MsUnlock()                   
          dbSelectArea("SD4")
          dbSkip()
      EndDo
   EndIf
   dbSelectArea("SC2")
   SC2->( dbSkip() )
EndDo
RETURN