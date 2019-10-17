#Include 'rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UTMKA180  ºAutor  ³Marcio Domingos     º Data ³  16/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para inclusão de contatos no atendimento  º±±
±±           ³ Receptivo.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UTMKA180()
Local _aArea	:= GetArea()    

TMKA180()

DbSelectArea("SK1")
DbSetOrder(1)                      
DbGoTop() 

DbSeek(xFilial("SK1"))

Do While K1_FILIAL =	xFilial("SK1")	.And. !Eof()

	DbSelectArea("AC8")
	DbSetorder(2)
	If !DbSeek(xFilial("AC8")+"SA1"+xFilial("SA1")+SK1->K1_CLIENTE+SK1->K1_LOJA)
	    
		DbSelectarea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SK1->K1_CLIENTE+SK1->K1_LOJA)
		
		cCodCont				:= GetSXENum("SU5","U5_CODCONT")
	 	ConfirmSX8()
	 	
		RecLock("SU5",.T.)     
		SU5->U5_FILIAL		:=	xFilial("SU5")
		SU5->U5_CODCONT		:= 	cCodCont
		SU5->U5_CONTAT		:=  SA1->A1_NOME
		SU5->U5_DDD			:=	SA1->A1_DDD
		If SA1->A1_PESSOA = "J"
			SU5->U5_FCOM1		:= 	SA1->A1_TEL
		Else
			SU5->U5_FONE		:= 	SA1->A1_TEL
		Endif	
		MsUnlock()
		
		RecLock("AC8",.T.)
		AC8->AC8_FILIAL		:=	xFilial("AC8")
		AC8->AC8_FILENT		:= 	xFilial("SA1")
		AC8->AC8_ENTIDA		:=  "SA1"
		AC8->AC8_CODENT		:= 	+SK1->K1_CLIENTE+SK1->K1_LOJA
		AC8->AC8_CODCON		:=  cCodCont
		MsUnlock()                             
	Endif                             
	
	DbSelectArea("SK1")
	DbSkip()	
	
Enddo

RestArea(_aArea)
Return .T.


