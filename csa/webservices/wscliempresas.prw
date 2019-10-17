#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.1.1.19:4080/0103/DVEMPRESAS.apw?WSDL
Gerado em        08/18/05 08:33:48
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.050513
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _UPSSSSJ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSDVEMPRESAS
------------------------------------------------------------------------------- */

WSCLIENT WSDVEMPRESAS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD LISTAEMPRESA

	WSDATA   _URL                      AS String
	WSDATA   oWSLISTAEMPRESARESULT     AS DVEMPRESAS_ARRAYOFEMPRESASVIEW

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSDVEMPRESAS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.050506P] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSDVEMPRESAS
	::oWSLISTAEMPRESARESULT := DVEMPRESAS_ARRAYOFEMPRESASVIEW():New()
Return

WSMETHOD RESET WSCLIENT WSDVEMPRESAS
	::oWSLISTAEMPRESARESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSDVEMPRESAS
Local oClone := WSDVEMPRESAS():New()
	oClone:_URL          := ::_URL 
	oClone:oWSLISTAEMPRESARESULT :=  IIF(::oWSLISTAEMPRESARESULT = NIL , NIL ,::oWSLISTAEMPRESARESULT:Clone() )
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method LISTAEMPRESA of Service WSDVEMPRESAS
------------------------------------------------------------------------------- */

WSMETHOD LISTAEMPRESA WSSEND NULLPARAM WSRECEIVE oWSLISTAEMPRESARESULT WSCLIENT WSDVEMPRESAS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<LISTAEMPRESA xmlns="http://192.1.1.19:4080/0103/">'
cSoap += "</LISTAEMPRESA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/0103/LISTAEMPRESA",; 
	"DOCUMENT","http://192.1.1.19:4080/0103/",,"1.031217",; 
	"http://192.1.1.19:4080/0103/DVEMPRESAS.apw")

::Init()
::oWSLISTAEMPRESARESULT:SoapRecv( WSAdvValue( oXmlRet,"_LISTAEMPRESARESPONSE:_LISTAEMPRESARESULT","ARRAYOFEMPRESASVIEW",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFEMPRESASVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVEMPRESAS_ARRAYOFEMPRESASVIEW
	WSDATA   oWSEMPRESASVIEW           AS DVEMPRESAS_EMPRESASVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVEMPRESAS_ARRAYOFEMPRESASVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVEMPRESAS_ARRAYOFEMPRESASVIEW
	::oWSEMPRESASVIEW      := {} // Array Of  DVEMPRESAS_EMPRESASVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVEMPRESAS_ARRAYOFEMPRESASVIEW
	Local oClone := DVEMPRESAS_ARRAYOFEMPRESASVIEW():NEW()
	oClone:oWSEMPRESASVIEW := NIL
	If ::oWSEMPRESASVIEW <> NIL 
		oClone:oWSEMPRESASVIEW := {}
		aEval( ::oWSEMPRESASVIEW , { |x| aadd( oClone:oWSEMPRESASVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVEMPRESAS_ARRAYOFEMPRESASVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EMPRESASVIEW","EMPRESASVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEMPRESASVIEW , DVEMPRESAS_EMPRESASVIEW():New() )
			::oWSEMPRESASVIEW[len(::oWSEMPRESASVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure EMPRESASVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVEMPRESAS_EMPRESASVIEW
	WSDATA   cCODIGO                   AS string
	WSDATA   cNOME                     AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVEMPRESAS_EMPRESASVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVEMPRESAS_EMPRESASVIEW
Return

WSMETHOD CLONE WSCLIENT DVEMPRESAS_EMPRESASVIEW
	Local oClone := DVEMPRESAS_EMPRESASVIEW():NEW()
	oClone:cCODIGO              := ::cCODIGO
	oClone:cNOME                := ::cNOME
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVEMPRESAS_EMPRESASVIEW
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCODIGO            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,"Property cCODIGO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return


