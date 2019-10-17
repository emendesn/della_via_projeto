#Include 'rwmake.ch'          
#Include 'tbiconn.ch'

User Function ActSE1()                   

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"  TABLES "SB1","SA1"

DbSelectArea("SE1")
DbSetOrder(6)
DbGotop()

DbSeek(xFilial("SE1")+"20060320")

Do While 	SE1->E1_FILIAL 	= 	xFilial("SE1")		.And.;
			SE1->E1_EMISSAO >= 	Stod("20060320")	.And. !Eof()
			
	If !Rtrim(SE1->E1_TIPO) $ "CC&CD"			
		DbSkip()
		Loop
	Endif
	
	RecLock("SE1",.F.)
	SE1->E1_NOMCLI	:= Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_NOME")	
	MsUnlock()
	
	DbSkip()
	
Enddo

Return .T.	
	