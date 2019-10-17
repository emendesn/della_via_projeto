#INCLUDE "RWMAKE.CH"        // incluido pelo assistente de conversao do AP5 IDE em 09/05/01

User Function M460FIM()

Local _aArea 	:= GetArea()

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

// Salva Alias Corrente.
_cAlias:=Alias()

If SUBSTR(FUNNAME(),1,3)="MAT" // So Processa, caso a Rotina geradora nao tenha vindo do SIGALOJA/Distribuicao
	
	IF FUNNAME()<>"MATA410"
	dBselectarea("SC9")
	_nRecnoSC9:=Recno()
	dBgotop()
	_nQuant:=0
	While ! Eof()
		If IsMark("C9_OK",ThisMark(),ThisInv()) .and. SC9->C9_NFISCAL=Spac(6)
			_nQuant:=_nQuant + 1			
		ENDIF
		
		dBskip()
	Enddo
	
	if _nQuant > 0 
		dBgoto(_nRecnoSC9)
		dBselectarea(_cAlias)
	   RestArea(_aArea)
		Return .T.
	Else       
		dBgoto(_nRecnoSC9)
	Endif
	ENDIF
Endif

_cAlias:=Alias()

aHeader:={}
aCols  :={}
_nUsado:=0

dBselectarea("SX3")
dbsetorder(1)
dbseek("SF2")
While !Eof() .And. X3_ARQUIVO  == "SF2"
	
	IF SX3->X3_CAMPO = "F2_DOC    "  .OR. SX3->X3_CAMPO = "F2_SERIE  "  .OR. SX3->X3_CAMPO = "F2_CLIENTE"  .OR. SX3->X3_CAMPO = "F2_EMISSAO"  .OR. SX3->X3_CAMPO = "F2_TIPO   "  .OR. SX3->X3_CAMPO = "F2_VEND1  "  .OR. SX3->X3_CAMPO = "F2_HORA   "
		AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, X3_VALID,X3_USADO, X3_TIPO, X3_ARQUIVO } )
	Endif
	
	dbSkip()
EndDo

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Cria ARRAY - Replica                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dBselectarea("SF2")
_nOrderSF2:=IndexOrd()
_nRecnoSF2:=Recno()
_cSerie:=SF2->F2_SERIE

dbsetorder(4)
dBseek(xFilial("SF2")+_cSerie+DTOS(DDATABASE),.T.)

While ! Eof() .AND. F2_FILIAL + F2_SERIE = xFilial("SF2")+_cSerie .AND. DTOS(F2_EMISSAO) == DTOS(DDATABASE)
	AAdd(aCols,{SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,Dtoc(SF2->F2_EMISSAO),SF2->F2_TIPO,SF2->F2_VEND1,SF2->F2_HORA,.F.})
	dBselectarea("SF2")
	dBskip()
Enddo

dBselectarea("SF2")
dBsetorder(_nOrderSF2)
dBgoto(_nRecnoSF2)


If Len(aCols)=0
	AAdd(aCols,{Spac(6),Spac(3),Spac(6),Dtoc(ddatabase),Spac(1),Spac(6),Spac(10),.F.})
Endif


Private _lProc:=.f.
@ 109,044 To 342,648 Dialog oBj11 Title OemToAnsi("Notas Fiscais Emitidas em  "+Dtoc(SF2->F2_EMISSAO))
@ 008,015 To 075,284 Multiline
@ 090,125 BmpButton Type 1 Action Close(oBj11)
Activate Dialog oBj11 Center
dBselectarea(_cAlias)
RestArea(_aArea)
Return 

