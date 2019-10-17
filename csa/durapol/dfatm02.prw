
User Function DFATM02()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFATM02   ºAutor  ³Microsiga           º Data ³  18/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Finalidade de executar a troca dos clientes com o relacio   º±±
±±º          ³mento do poder de terceiros.(A Entrada ficar sem alteracao).º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol -                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol -                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Local oDlg     := ""
Local cPerg    := "FATM02"
Local nOpc     := 0
Local aButtons := {}
Local aReg     := {}
Local aSays    := {}
Local aCra     := {"Confirma","Redigita","Abandona"}
Private cCadastro := "Transferencia de cliente"


AAdd(aReg,{cPerg,"01","Qual Pedido  ?"     ,"Do Cliente"   ,"Da  Data"       ,"mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aReg,{cPerg,"02","Cliente Novo ?"     ,"Ate Cliente"  ,"Ate Data"       ,"mv_ch2","C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AAdd(aReg,{cPerg,"03","Loja cliente ?"     ,"Da Loja"      ,"Ate Data"       ,"mv_ch3","C", 2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aReg,cPerg)
Pergunte(cPerg,.F.)

Aadd( aSays,"Este programa tem o objetivo de realizar a troca do cliente, de acordo com os dados ")
Aadd( aSays,"informados nos parametros.")
Aadd( aSays,"A troca so ira intervir nos dados referentes a saida do pedido.")

Aadd( aButtons,{5,.T., {|| Pergunte("FATM02",.T.) } } )
Aadd( aButtons,{1,.T., {|o| nOpc := 1, o:oWnd:End() } } )
Aadd( aButtons,{2,.T., {|o| o:oWnd:End() } } )


Formbatch( cCadastro, aSays, aButtons)

IF nOpc == 1
	Processa({|| Acerta()},"Realizando troca de cliente....")
EndIF	

Return
                        

Static Function Acerta()

SC5->( dbSetOrder(1) )
SC6->( dbSetOrder(1) )
SC9->( dbSetOrder(1) )

SC5->( dbSeek(xFilial("SC5") + mv_par01) )

	RecLock("SC5",.F.)
	
		SC5->C5_CLIORIG   := SC5->C5_CLIENTE //--Mantem historico da gravacao
		SC5->C5_LOJORIG   := SC5->C5_LOJACLI //--Mantem historico da gravacao
		SC5->C5_CLIENTE   := MV_PAR02
		SC5->C5_LOJACLI   := MV_PAR03
		
	MsUnlock()

SC6->( dbSeek(xFilial("SC6") + SC5->C5_NUM) )

While !Eof() .and. SC5->C5_NUM == SC6->C6_NUM
	IncProc()
	
	//Verifica os Itens Liberados
	IF SC9->( dbSeek(xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM ) )
		RecLock("SC9",.F.)
			Replace SC9->C9_CLIENTE with MV_PAR02
			Replace SC9->C9_LOJA    with MV_PAR03
		MsUnlock()
	EndIF
	
	//Regravo Poder de Terceiro
	dbSelectArea("SB6")
	dbSetOrder(1)
	IF dbSeek(xFilial("SB6") + SC6->C6_PRODUTO + SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_IDENTB6,.F.)
		RecLock("SB6",.F.)
			Replace SB6->B6_CLIFOR with MV_PAR02
			Replace SB6->B6_LOJA   with MV_PAR03
		MsUnlock()
	EndIF	

	
	dbSelectArea("SC6")
	//Regravo Itens do pedido de vendas
	RecLock("SC6",.F.)
		Replace SC6->C6_CLI  with MV_PAR02
		Replace SC6->C6_LOJA with MV_PAR03
	MsUnlock()	
	
	SC6->( dbSkip() )
EndDo
      
MsgInfo("Fim do processamento","Atenção")

Return