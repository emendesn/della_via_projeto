#Include 'rwmake.ch'       


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK280SU5  ºAutor  ³Marcio Domingos     º Data ³  07/15/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para criar contato no atendimento receptivo ±±
±±º          ³Telecobranca                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function TK280SU5(cCliente,cLoja)
Local _aArea	:= GetArea()    

//MsgBox("TK280SU5")
                                                                          
DbSelectArea("AC8")
DbSetorder(2)
If !DbSeek(xFilial("AC8")+"SA1"+xFilial("SA1")+cCliente+cLoja)
    
	DbSelectarea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+cCliente+cLoja)
	
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
	AC8->AC8_CODENT		:= 	cCliente+cLoja
	AC8->AC8_CODCON		:=  cCodCont
	MsUnlock()                             
Else
	cCodCont	:= AC8->AC8_CODCON	
Endif                             
RestArea(_aArea)
Return cCodCont


