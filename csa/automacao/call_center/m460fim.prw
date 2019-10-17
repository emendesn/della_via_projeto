#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Microsiga           º Data ³  07/27/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. para ataualizar o status do atendimento quando a NF forº±±
±±º          ³Emitida                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM()

Local _aArea 	:= GetArea()
Private _lProc:=.f.

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

RestArea(_aArea)
// Salva Alias Corrente.
_cAlias:=Alias()

If SUBSTR(FUNNAME(),1,3)="MAT" // So Processa, caso a Rotina geradora nao tenha vindo do SIGALOJA/Distribuicao
	
	dBselectarea("SC9")
	_nRecnoSC9:=Recno()
	dBgotop()
	_cPed:=Spac(6)
	While ! Eof()
		If IsMark("C9_OK",ThisMark(),ThisInv()) .and. SC9->C9_NFISCAL=Spac(6)
			_cPed:=SC9->C9_PEDIDO
			
			IF _cPed > SD2->D2_PEDIDO
				exit
			ENDIF
			
			
		ENDIF
		
		dBskip()
	Enddo
	
	If !_cPed =Spac(6)
		dBgoto(_nRecnoSC9)
		dBselectarea(_cAlias)
		Return .T.
	Endif
	dBgoto(_nRecnoSC9)
Endif

_cAlias:=Alias()


aHeader:={}
aCols  :={}
_nUsado:=0

dBselectarea("SX3")
dbsetorder(1)
dbseek("SF2")
While !Eof() .And. X3_ARQUIVO  == "SF2"
	
	IF SX3->X3_CAMPO = "F2_DOC    "  .OR. SX3->X3_CAMPO = "F2_SERIE  "  .OR. SX3->X3_CAMPO = "F2_CLIENTE"  .OR. SX3->X3_CAMPO = "F2_EMISSAO"  .OR. SX3->X3_CAMPO = "F2_TIPO   "  .OR. SX3->X3_CAMPO = "F2_VEND1  "  .OR. SX3->X3_CAMPO = "F2_FIMP   " .OR. SX3->X3_CAMPO = "F2_HORA   "
		AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, X3_VALID,X3_USADO, X3_TIPO, X3_ARQUIVO } )
	Endif
	
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria ARRAY - Replica                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBselectarea("SF2")
_nOrderSF2:=IndexOrd()
_nRecnoSF2:=Recno()
_cSerie:=SF2->F2_SERIE

dbsetorder(4)
dBseek(xFilial("SF2")+_cSerie+DTOS(DDATABASE),.T.)

While ! Eof() .AND. F2_FILIAL + F2_SERIE = xFilial("SF2")+_cSerie .AND. DTOS(F2_EMISSAO) == DTOS(DDATABASE)
	AAdd(aCols,{SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,Dtoc(SF2->F2_EMISSAO),SF2->F2_TIPO,SF2->F2_VEND1,SPAC(1),SF2->F2_HORA,.F.})
	dBselectarea("SF2")
	dBskip()
Enddo

dBselectarea("SF2")
dBsetorder(_nOrderSF2)
dBgoto(_nRecnoSF2)


If Len(aCols)=0
	AAdd(aCols,{Spac(6),Spac(3),Spac(6),Dtoc(ddatabase),Spac(1),Spac(6)," ",Spac(10),.F.})
Endif

@ 109,044 To 342,648 Dialog oBj11 Title OemToAnsi("Notas Fiscais Emitidas em  "+Dtoc(SF2->F2_EMISSAO))
@ 008,005 To 235,494 Multiline
@ 068,215 BmpButton Type 1 Action Close(oBj11)
Activate Dialog oBj11 Center
dBselectarea(_cAlias)
Return .T.
