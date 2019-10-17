#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.1.1.19:4080/ws/MTSUPPLIER.apw?WSDL
Gerado em        06/22/05 18:05:31
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.050513
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _MAVMSMU ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSMTSUPPLIER
------------------------------------------------------------------------------- */

WSCLIENT WSMTSUPPLIER

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETHEADER
	WSMETHOD GETSUPPLIER
	WSMETHOD GETTYPEOFADDRESS
	WSMETHOD GETTYPEOFPHONE
	WSMETHOD PUTSUPPLIER

	WSDATA   _URL                      AS String
	WSDATA   cHEADERTYPE               AS string
	WSDATA   oWSGETHEADERRESULT        AS MTSUPPLIER_ARRAYOFBRWHEADER
	WSDATA   cUSERCODE                 AS string
	WSDATA   cSUPPLIERID               AS string
	WSDATA   oWSGETSUPPLIERRESULT      AS MTSUPPLIER_SUPPLIERVIEW
	WSDATA   oWSGETTYPEOFADDRESSRESULT AS MTSUPPLIER_ARRAYOFGENERICSTRUCT
	WSDATA   oWSGETTYPEOFPHONERESULT   AS MTSUPPLIER_ARRAYOFGENERICSTRUCT
	WSDATA   oWSSUPPLIER               AS MTSUPPLIER_SUPPLIERVIEW
	WSDATA   cPUTSUPPLIERRESULT        AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSUPPLIERVIEW           AS MTSUPPLIER_SUPPLIERVIEW

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSMTSUPPLIER
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.050506P] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSMTSUPPLIER
	::oWSGETHEADERRESULT := MTSUPPLIER_ARRAYOFBRWHEADER():New()
	::oWSGETSUPPLIERRESULT := MTSUPPLIER_SUPPLIERVIEW():New()
	::oWSGETTYPEOFADDRESSRESULT := MTSUPPLIER_ARRAYOFGENERICSTRUCT():New()
	::oWSGETTYPEOFPHONERESULT := MTSUPPLIER_ARRAYOFGENERICSTRUCT():New()
	::oWSSUPPLIER        := MTSUPPLIER_SUPPLIERVIEW():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSUPPLIERVIEW    := ::oWSSUPPLIER
Return

WSMETHOD RESET WSCLIENT WSMTSUPPLIER
	::cHEADERTYPE        := NIL 
	::oWSGETHEADERRESULT := NIL 
	::cUSERCODE          := NIL 
	::cSUPPLIERID        := NIL 
	::oWSGETSUPPLIERRESULT := NIL 
	::oWSGETTYPEOFADDRESSRESULT := NIL 
	::oWSGETTYPEOFPHONERESULT := NIL 
	::oWSSUPPLIER        := NIL 
	::cPUTSUPPLIERRESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSUPPLIERVIEW    := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSMTSUPPLIER
Local oClone := WSMTSUPPLIER():New()
	oClone:_URL          := ::_URL 
	oClone:cHEADERTYPE   := ::cHEADERTYPE
	oClone:oWSGETHEADERRESULT :=  IIF(::oWSGETHEADERRESULT = NIL , NIL ,::oWSGETHEADERRESULT:Clone() )
	oClone:cUSERCODE     := ::cUSERCODE
	oClone:cSUPPLIERID   := ::cSUPPLIERID
	oClone:oWSGETSUPPLIERRESULT :=  IIF(::oWSGETSUPPLIERRESULT = NIL , NIL ,::oWSGETSUPPLIERRESULT:Clone() )
	oClone:oWSGETTYPEOFADDRESSRESULT :=  IIF(::oWSGETTYPEOFADDRESSRESULT = NIL , NIL ,::oWSGETTYPEOFADDRESSRESULT:Clone() )
	oClone:oWSGETTYPEOFPHONERESULT :=  IIF(::oWSGETTYPEOFPHONERESULT = NIL , NIL ,::oWSGETTYPEOFPHONERESULT:Clone() )
	oClone:oWSSUPPLIER   :=  IIF(::oWSSUPPLIER = NIL , NIL ,::oWSSUPPLIER:Clone() )
	oClone:cPUTSUPPLIERRESULT := ::cPUTSUPPLIERRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSUPPLIERVIEW := oClone:oWSSUPPLIER
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method GETHEADER of Service WSMTSUPPLIER
------------------------------------------------------------------------------- */

WSMETHOD GETHEADER WSSEND cHEADERTYPE WSRECEIVE oWSGETHEADERRESULT WSCLIENT WSMTSUPPLIER
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETHEADER xmlns="http://192.1.1.19:4080/WS/mtsupplier.apw">'
cSoap += WSSoapValue("HEADERTYPE", ::cHEADERTYPE, cHEADERTYPE , "string", .T. , .F., 0 ) 
cSoap += "</GETHEADER>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/ws/mtsupplier.apw/GETHEADER",; 
	"DOCUMENT","http://192.1.1.19:4080/WS/mtsupplier.apw",,"1.031217",; 
	"http://192.1.1.19:4080/ws/MTSUPPLIER.apw")

::Init()
::oWSGETHEADERRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETHEADERRESPONSE:_GETHEADERRESULT","ARRAYOFBRWHEADER",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method GETSUPPLIER of Service WSMTSUPPLIER
------------------------------------------------------------------------------- */

WSMETHOD GETSUPPLIER WSSEND cUSERCODE,cSUPPLIERID WSRECEIVE oWSGETSUPPLIERRESULT WSCLIENT WSMTSUPPLIER
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETSUPPLIER xmlns="http://192.1.1.19:4080/WS/mtsupplier.apw">'
cSoap += WSSoapValue("USERCODE", ::cUSERCODE, cUSERCODE , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("SUPPLIERID", ::cSUPPLIERID, cSUPPLIERID , "string", .T. , .F., 0 ) 
cSoap += "</GETSUPPLIER>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/WS/mtsupplier.apw/GETSUPPLIER",; 
	"DOCUMENT","http://192.1.1.19:4080/WS/mtsupplier.apw",,"1.031217",; 
	"http://192.1.1.19:4080/ws/MTSUPPLIER.apw")

::Init()
::oWSGETSUPPLIERRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETSUPPLIERRESPONSE:_GETSUPPLIERRESULT","SUPPLIERVIEW",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method GETTYPEOFADDRESS of Service WSMTSUPPLIER
------------------------------------------------------------------------------- */

WSMETHOD GETTYPEOFADDRESS WSSEND NULLPARAM WSRECEIVE oWSGETTYPEOFADDRESSRESULT WSCLIENT WSMTSUPPLIER
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETTYPEOFADDRESS xmlns="http://192.1.1.19:4080/WS/mtsupplier.apw">'
cSoap += "</GETTYPEOFADDRESS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/WS/mtsupplier.apw/GETTYPEOFADDRESS",; 
	"DOCUMENT","http://192.1.1.19:4080/WS/mtsupplier.apw",,"1.031217",; 
	"http://192.1.1.19:4080/ws/MTSUPPLIER.apw")

::Init()
::oWSGETTYPEOFADDRESSRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETTYPEOFADDRESSRESPONSE:_GETTYPEOFADDRESSRESULT","ARRAYOFGENERICSTRUCT",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method GETTYPEOFPHONE of Service WSMTSUPPLIER
------------------------------------------------------------------------------- */

WSMETHOD GETTYPEOFPHONE WSSEND NULLPARAM WSRECEIVE oWSGETTYPEOFPHONERESULT WSCLIENT WSMTSUPPLIER
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETTYPEOFPHONE xmlns="http://192.1.1.19:4080/WS/mtsupplier.apw">'
cSoap += "</GETTYPEOFPHONE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/WS/mtsupplier.apw/GETTYPEOFPHONE",; 
	"DOCUMENT","http://192.1.1.19:4080/WS/mtsupplier.apw",,"1.031217",; 
	"http://192.1.1.19:4080/ws/MTSUPPLIER.apw")

::Init()
::oWSGETTYPEOFPHONERESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETTYPEOFPHONERESPONSE:_GETTYPEOFPHONERESULT","ARRAYOFGENERICSTRUCT",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method PUTSUPPLIER of Service WSMTSUPPLIER
------------------------------------------------------------------------------- */

WSMETHOD PUTSUPPLIER WSSEND cUSERCODE,cSUPPLIERID,oWSSUPPLIER WSRECEIVE cPUTSUPPLIERRESULT WSCLIENT WSMTSUPPLIER
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PUTSUPPLIER xmlns="http://192.1.1.19:4080/WS/mtsupplier.apw">'
cSoap += WSSoapValue("USERCODE", ::cUSERCODE, cUSERCODE , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("SUPPLIERID", ::cSUPPLIERID, cSUPPLIERID , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("SUPPLIER", ::oWSSUPPLIER, oWSSUPPLIER , "SUPPLIERVIEW", .T. , .F., 0 ) 
cSoap += "</PUTSUPPLIER>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/WS/mtsupplier.apw/PUTSUPPLIER",; 
	"DOCUMENT","http://192.1.1.19:4080/WS/mtsupplier.apw",,"1.031217",; 
	"http://192.1.1.19:4080/ws/MTSUPPLIER.apw")

::Init()
::cPUTSUPPLIERRESULT :=  WSAdvValue( oXmlRet,"_PUTSUPPLIERRESPONSE:_PUTSUPPLIERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFBRWHEADER
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_ARRAYOFBRWHEADER
	WSDATA   oWSBRWHEADER              AS MTSUPPLIER_BRWHEADER OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_ARRAYOFBRWHEADER
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_ARRAYOFBRWHEADER
	::oWSBRWHEADER         := {} // Array Of  MTSUPPLIER_BRWHEADER():New()
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_ARRAYOFBRWHEADER
	Local oClone := MTSUPPLIER_ARRAYOFBRWHEADER():NEW()
	oClone:oWSBRWHEADER := NIL
	If ::oWSBRWHEADER <> NIL 
		oClone:oWSBRWHEADER := {}
		aEval( ::oWSBRWHEADER , { |x| aadd( oClone:oWSBRWHEADER , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_ARRAYOFBRWHEADER
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BRWHEADER","BRWHEADER",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBRWHEADER , MTSUPPLIER_BRWHEADER():New() )
			::oWSBRWHEADER[len(::oWSBRWHEADER)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure SUPPLIERVIEW
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_SUPPLIERVIEW
	WSDATA   oWSADDRESSES              AS MTSUPPLIER_ARRAYOFADDRESSVIEW
	WSDATA   cDISTRICTID               AS string
	WSDATA   cEMAIL                    AS string
	WSDATA   cFEDERALID                AS string
	WSDATA   cHOMEPAGE                 AS string
	WSDATA   cNAME                     AS string
	WSDATA   cNICKNAME                 AS string
	WSDATA   oWSPHONES                 AS MTSUPPLIER_ARRAYOFPHONEVIEW OPTIONAL
	WSDATA   cSTATEID                  AS string
	WSDATA   cSUPPLIERCODE             AS string
	WSDATA   cUNITSUPPLIERCODE         AS string
	WSDATA   oWSUSERFIELDS             AS MTSUPPLIER_ARRAYOFUSERFIELD OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_SUPPLIERVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_SUPPLIERVIEW
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_SUPPLIERVIEW
	Local oClone := MTSUPPLIER_SUPPLIERVIEW():NEW()
	oClone:oWSADDRESSES         := IIF(::oWSADDRESSES = NIL , NIL , ::oWSADDRESSES:Clone() )
	oClone:cDISTRICTID          := ::cDISTRICTID
	oClone:cEMAIL               := ::cEMAIL
	oClone:cFEDERALID           := ::cFEDERALID
	oClone:cHOMEPAGE            := ::cHOMEPAGE
	oClone:cNAME                := ::cNAME
	oClone:cNICKNAME            := ::cNICKNAME
	oClone:oWSPHONES            := IIF(::oWSPHONES = NIL , NIL , ::oWSPHONES:Clone() )
	oClone:cSTATEID             := ::cSTATEID
	oClone:cSUPPLIERCODE        := ::cSUPPLIERCODE
	oClone:cUNITSUPPLIERCODE    := ::cUNITSUPPLIERCODE
	oClone:oWSUSERFIELDS        := IIF(::oWSUSERFIELDS = NIL , NIL , ::oWSUSERFIELDS:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT MTSUPPLIER_SUPPLIERVIEW
	Local cSoap := ""
	cSoap += WSSoapValue("ADDRESSES", ::oWSADDRESSES, ::oWSADDRESSES , "ARRAYOFADDRESSVIEW", .T. , .F., 0 ) 
	cSoap += WSSoapValue("DISTRICTID", ::cDISTRICTID, ::cDISTRICTID , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("EMAIL", ::cEMAIL, ::cEMAIL , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("FEDERALID", ::cFEDERALID, ::cFEDERALID , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("HOMEPAGE", ::cHOMEPAGE, ::cHOMEPAGE , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("NAME", ::cNAME, ::cNAME , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("NICKNAME", ::cNICKNAME, ::cNICKNAME , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("PHONES", ::oWSPHONES, ::oWSPHONES , "ARRAYOFPHONEVIEW", .F. , .F., 0 ) 
	cSoap += WSSoapValue("STATEID", ::cSTATEID, ::cSTATEID , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("SUPPLIERCODE", ::cSUPPLIERCODE, ::cSUPPLIERCODE , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("UNITSUPPLIERCODE", ::cUNITSUPPLIERCODE, ::cUNITSUPPLIERCODE , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("USERFIELDS", ::oWSUSERFIELDS, ::oWSUSERFIELDS , "ARRAYOFUSERFIELD", .F. , .F., 0 ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_SUPPLIERVIEW
	Local oNode1
	Local oNode8
	Local oNode12
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ADDRESSES","ARRAYOFADDRESSVIEW",NIL,"Property oWSADDRESSES as s0:ARRAYOFADDRESSVIEW on SOAP Response not found.",NIL,"O",NIL) 
	If oNode1 != NIL
		::oWSADDRESSES := MTSUPPLIER_ARRAYOFADDRESSVIEW():New()
		::oWSADDRESSES:SoapRecv(oNode1)
	EndIf
	::cDISTRICTID        :=  WSAdvValue( oResponse,"_DISTRICTID","string",NIL,"Property cDISTRICTID as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cEMAIL             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,"Property cEMAIL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFEDERALID         :=  WSAdvValue( oResponse,"_FEDERALID","string",NIL,"Property cFEDERALID as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cHOMEPAGE          :=  WSAdvValue( oResponse,"_HOMEPAGE","string",NIL,"Property cHOMEPAGE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNAME              :=  WSAdvValue( oResponse,"_NAME","string",NIL,"Property cNAME as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNICKNAME          :=  WSAdvValue( oResponse,"_NICKNAME","string",NIL,"Property cNICKNAME as s:string on SOAP Response not found.",NIL,"S",NIL) 
	oNode8 :=  WSAdvValue( oResponse,"_PHONES","ARRAYOFPHONEVIEW",NIL,NIL,NIL,"O",NIL) 
	If oNode8 != NIL
		::oWSPHONES := MTSUPPLIER_ARRAYOFPHONEVIEW():New()
		::oWSPHONES:SoapRecv(oNode8)
	EndIf
	::cSTATEID           :=  WSAdvValue( oResponse,"_STATEID","string",NIL,"Property cSTATEID as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSUPPLIERCODE      :=  WSAdvValue( oResponse,"_SUPPLIERCODE","string",NIL,"Property cSUPPLIERCODE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cUNITSUPPLIERCODE  :=  WSAdvValue( oResponse,"_UNITSUPPLIERCODE","string",NIL,"Property cUNITSUPPLIERCODE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	oNode12 :=  WSAdvValue( oResponse,"_USERFIELDS","ARRAYOFUSERFIELD",NIL,NIL,NIL,"O",NIL) 
	If oNode12 != NIL
		::oWSUSERFIELDS := MTSUPPLIER_ARRAYOFUSERFIELD():New()
		::oWSUSERFIELDS:SoapRecv(oNode12)
	EndIf
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFGENERICSTRUCT
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_ARRAYOFGENERICSTRUCT
	WSDATA   oWSGENERICSTRUCT          AS MTSUPPLIER_GENERICSTRUCT OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_ARRAYOFGENERICSTRUCT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_ARRAYOFGENERICSTRUCT
	::oWSGENERICSTRUCT     := {} // Array Of  MTSUPPLIER_GENERICSTRUCT():New()
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_ARRAYOFGENERICSTRUCT
	Local oClone := MTSUPPLIER_ARRAYOFGENERICSTRUCT():NEW()
	oClone:oWSGENERICSTRUCT := NIL
	If ::oWSGENERICSTRUCT <> NIL 
		oClone:oWSGENERICSTRUCT := {}
		aEval( ::oWSGENERICSTRUCT , { |x| aadd( oClone:oWSGENERICSTRUCT , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_ARRAYOFGENERICSTRUCT
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_GENERICSTRUCT","GENERICSTRUCT",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSGENERICSTRUCT , MTSUPPLIER_GENERICSTRUCT():New() )
			::oWSGENERICSTRUCT[len(::oWSGENERICSTRUCT)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure BRWHEADER
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_BRWHEADER
	WSDATA   cHEADERCOMBOBOX           AS string OPTIONAL
	WSDATA   nHEADERDEC                AS integer
	WSDATA   cHEADERFIELD              AS string
	WSDATA   lHEADEROBLIG              AS boolean OPTIONAL
	WSDATA   cHEADERPICTURE            AS string
	WSDATA   nHEADERSIZE               AS integer
	WSDATA   cHEADERTITLE              AS string
	WSDATA   cHEADERTYPE               AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_BRWHEADER
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_BRWHEADER
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_BRWHEADER
	Local oClone := MTSUPPLIER_BRWHEADER():NEW()
	oClone:cHEADERCOMBOBOX      := ::cHEADERCOMBOBOX
	oClone:nHEADERDEC           := ::nHEADERDEC
	oClone:cHEADERFIELD         := ::cHEADERFIELD
	oClone:lHEADEROBLIG         := ::lHEADEROBLIG
	oClone:cHEADERPICTURE       := ::cHEADERPICTURE
	oClone:nHEADERSIZE          := ::nHEADERSIZE
	oClone:cHEADERTITLE         := ::cHEADERTITLE
	oClone:cHEADERTYPE          := ::cHEADERTYPE
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_BRWHEADER
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cHEADERCOMBOBOX    :=  WSAdvValue( oResponse,"_HEADERCOMBOBOX","string",NIL,NIL,NIL,"S",NIL) 
	::nHEADERDEC         :=  WSAdvValue( oResponse,"_HEADERDEC","integer",NIL,"Property nHEADERDEC as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cHEADERFIELD       :=  WSAdvValue( oResponse,"_HEADERFIELD","string",NIL,"Property cHEADERFIELD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::lHEADEROBLIG       :=  WSAdvValue( oResponse,"_HEADEROBLIG","boolean",NIL,NIL,NIL,"L",NIL) 
	::cHEADERPICTURE     :=  WSAdvValue( oResponse,"_HEADERPICTURE","string",NIL,"Property cHEADERPICTURE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nHEADERSIZE        :=  WSAdvValue( oResponse,"_HEADERSIZE","integer",NIL,"Property nHEADERSIZE as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cHEADERTITLE       :=  WSAdvValue( oResponse,"_HEADERTITLE","string",NIL,"Property cHEADERTITLE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cHEADERTYPE        :=  WSAdvValue( oResponse,"_HEADERTYPE","string",NIL,"Property cHEADERTYPE as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFADDRESSVIEW
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_ARRAYOFADDRESSVIEW
	WSDATA   oWSADDRESSVIEW            AS MTSUPPLIER_ADDRESSVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_ARRAYOFADDRESSVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_ARRAYOFADDRESSVIEW
	::oWSADDRESSVIEW       := {} // Array Of  MTSUPPLIER_ADDRESSVIEW():New()
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_ARRAYOFADDRESSVIEW
	Local oClone := MTSUPPLIER_ARRAYOFADDRESSVIEW():NEW()
	oClone:oWSADDRESSVIEW := NIL
	If ::oWSADDRESSVIEW <> NIL 
		oClone:oWSADDRESSVIEW := {}
		aEval( ::oWSADDRESSVIEW , { |x| aadd( oClone:oWSADDRESSVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT MTSUPPLIER_ARRAYOFADDRESSVIEW
	Local cSoap := ""
	aEval( ::oWSADDRESSVIEW , {|x| cSoap := cSoap  +  WSSoapValue("ADDRESSVIEW", x , x , "ADDRESSVIEW", .F. , .F., 0 )  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_ARRAYOFADDRESSVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ADDRESSVIEW","ADDRESSVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSADDRESSVIEW , MTSUPPLIER_ADDRESSVIEW():New() )
			::oWSADDRESSVIEW[len(::oWSADDRESSVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFPHONEVIEW
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_ARRAYOFPHONEVIEW
	WSDATA   oWSPHONEVIEW              AS MTSUPPLIER_PHONEVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_ARRAYOFPHONEVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_ARRAYOFPHONEVIEW
	::oWSPHONEVIEW         := {} // Array Of  MTSUPPLIER_PHONEVIEW():New()
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_ARRAYOFPHONEVIEW
	Local oClone := MTSUPPLIER_ARRAYOFPHONEVIEW():NEW()
	oClone:oWSPHONEVIEW := NIL
	If ::oWSPHONEVIEW <> NIL 
		oClone:oWSPHONEVIEW := {}
		aEval( ::oWSPHONEVIEW , { |x| aadd( oClone:oWSPHONEVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT MTSUPPLIER_ARRAYOFPHONEVIEW
	Local cSoap := ""
	aEval( ::oWSPHONEVIEW , {|x| cSoap := cSoap  +  WSSoapValue("PHONEVIEW", x , x , "PHONEVIEW", .F. , .F., 0 )  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_ARRAYOFPHONEVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PHONEVIEW","PHONEVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSPHONEVIEW , MTSUPPLIER_PHONEVIEW():New() )
			::oWSPHONEVIEW[len(::oWSPHONEVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFUSERFIELD
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_ARRAYOFUSERFIELD
	WSDATA   oWSUSERFIELD              AS MTSUPPLIER_USERFIELD OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_ARRAYOFUSERFIELD
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_ARRAYOFUSERFIELD
	::oWSUSERFIELD         := {} // Array Of  MTSUPPLIER_USERFIELD():New()
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_ARRAYOFUSERFIELD
	Local oClone := MTSUPPLIER_ARRAYOFUSERFIELD():NEW()
	oClone:oWSUSERFIELD := NIL
	If ::oWSUSERFIELD <> NIL 
		oClone:oWSUSERFIELD := {}
		aEval( ::oWSUSERFIELD , { |x| aadd( oClone:oWSUSERFIELD , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT MTSUPPLIER_ARRAYOFUSERFIELD
	Local cSoap := ""
	aEval( ::oWSUSERFIELD , {|x| cSoap := cSoap  +  WSSoapValue("USERFIELD", x , x , "USERFIELD", .F. , .F., 0 )  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_ARRAYOFUSERFIELD
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_USERFIELD","USERFIELD",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSUSERFIELD , MTSUPPLIER_USERFIELD():New() )
			::oWSUSERFIELD[len(::oWSUSERFIELD)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure GENERICSTRUCT
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_GENERICSTRUCT
	WSDATA   cCODE                     AS string
	WSDATA   cDESCRIPTION              AS string
	WSDATA   nVALUE                    AS float OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_GENERICSTRUCT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_GENERICSTRUCT
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_GENERICSTRUCT
	Local oClone := MTSUPPLIER_GENERICSTRUCT():NEW()
	oClone:cCODE                := ::cCODE
	oClone:cDESCRIPTION         := ::cDESCRIPTION
	oClone:nVALUE               := ::nVALUE
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_GENERICSTRUCT
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCODE              :=  WSAdvValue( oResponse,"_CODE","string",NIL,"Property cCODE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDESCRIPTION       :=  WSAdvValue( oResponse,"_DESCRIPTION","string",NIL,"Property cDESCRIPTION as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nVALUE             :=  WSAdvValue( oResponse,"_VALUE","float",NIL,NIL,NIL,"N",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ADDRESSVIEW
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_ADDRESSVIEW
	WSDATA   cADDRESS                  AS string
	WSDATA   cADDRESSNUMBER            AS string
	WSDATA   cDISTRICT                 AS string
	WSDATA   cSTATE                    AS string
	WSDATA   cTYPEOFADDRESS            AS string
	WSDATA   cZIPCODE                  AS string
	WSDATA   cZONE                     AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_ADDRESSVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_ADDRESSVIEW
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_ADDRESSVIEW
	Local oClone := MTSUPPLIER_ADDRESSVIEW():NEW()
	oClone:cADDRESS             := ::cADDRESS
	oClone:cADDRESSNUMBER       := ::cADDRESSNUMBER
	oClone:cDISTRICT            := ::cDISTRICT
	oClone:cSTATE               := ::cSTATE
	oClone:cTYPEOFADDRESS       := ::cTYPEOFADDRESS
	oClone:cZIPCODE             := ::cZIPCODE
	oClone:cZONE                := ::cZONE
Return oClone

WSMETHOD SOAPSEND WSCLIENT MTSUPPLIER_ADDRESSVIEW
	Local cSoap := ""
	cSoap += WSSoapValue("ADDRESS", ::cADDRESS, ::cADDRESS , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("ADDRESSNUMBER", ::cADDRESSNUMBER, ::cADDRESSNUMBER , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("DISTRICT", ::cDISTRICT, ::cDISTRICT , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("STATE", ::cSTATE, ::cSTATE , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("TYPEOFADDRESS", ::cTYPEOFADDRESS, ::cTYPEOFADDRESS , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("ZIPCODE", ::cZIPCODE, ::cZIPCODE , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("ZONE", ::cZONE, ::cZONE , "string", .T. , .F., 0 ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_ADDRESSVIEW
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cADDRESS           :=  WSAdvValue( oResponse,"_ADDRESS","string",NIL,"Property cADDRESS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cADDRESSNUMBER     :=  WSAdvValue( oResponse,"_ADDRESSNUMBER","string",NIL,"Property cADDRESSNUMBER as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDISTRICT          :=  WSAdvValue( oResponse,"_DISTRICT","string",NIL,"Property cDISTRICT as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSTATE             :=  WSAdvValue( oResponse,"_STATE","string",NIL,"Property cSTATE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTYPEOFADDRESS     :=  WSAdvValue( oResponse,"_TYPEOFADDRESS","string",NIL,"Property cTYPEOFADDRESS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cZIPCODE           :=  WSAdvValue( oResponse,"_ZIPCODE","string",NIL,"Property cZIPCODE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cZONE              :=  WSAdvValue( oResponse,"_ZONE","string",NIL,"Property cZONE as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure PHONEVIEW
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_PHONEVIEW
	WSDATA   cCOUNTRYAREACODE          AS string OPTIONAL
	WSDATA   cLOCALAREACODE            AS string OPTIONAL
	WSDATA   cPHONENUMBER              AS string OPTIONAL
	WSDATA   cTYPEOFPHONE              AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_PHONEVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_PHONEVIEW
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_PHONEVIEW
	Local oClone := MTSUPPLIER_PHONEVIEW():NEW()
	oClone:cCOUNTRYAREACODE     := ::cCOUNTRYAREACODE
	oClone:cLOCALAREACODE       := ::cLOCALAREACODE
	oClone:cPHONENUMBER         := ::cPHONENUMBER
	oClone:cTYPEOFPHONE         := ::cTYPEOFPHONE
Return oClone

WSMETHOD SOAPSEND WSCLIENT MTSUPPLIER_PHONEVIEW
	Local cSoap := ""
	cSoap += WSSoapValue("COUNTRYAREACODE", ::cCOUNTRYAREACODE, ::cCOUNTRYAREACODE , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("LOCALAREACODE", ::cLOCALAREACODE, ::cLOCALAREACODE , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("PHONENUMBER", ::cPHONENUMBER, ::cPHONENUMBER , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("TYPEOFPHONE", ::cTYPEOFPHONE, ::cTYPEOFPHONE , "string", .T. , .F., 0 ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_PHONEVIEW
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCOUNTRYAREACODE   :=  WSAdvValue( oResponse,"_COUNTRYAREACODE","string",NIL,NIL,NIL,"S",NIL) 
	::cLOCALAREACODE     :=  WSAdvValue( oResponse,"_LOCALAREACODE","string",NIL,NIL,NIL,"S",NIL) 
	::cPHONENUMBER       :=  WSAdvValue( oResponse,"_PHONENUMBER","string",NIL,NIL,NIL,"S",NIL) 
	::cTYPEOFPHONE       :=  WSAdvValue( oResponse,"_TYPEOFPHONE","string",NIL,"Property cTYPEOFPHONE as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure USERFIELD
------------------------------------------------------------------------------- */

WSSTRUCT MTSUPPLIER_USERFIELD
	WSDATA   nUSERDEC                  AS integer OPTIONAL
	WSDATA   cUSERNAME                 AS string
	WSDATA   lUSEROBLIG                AS boolean OPTIONAL
	WSDATA   cUSERPICTURE              AS string OPTIONAL
	WSDATA   nUSERSIZE                 AS integer OPTIONAL
	WSDATA   cUSERTAG                  AS string OPTIONAL
	WSDATA   cUSERTITLE                AS string OPTIONAL
	WSDATA   cUSERTYPE                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MTSUPPLIER_USERFIELD
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MTSUPPLIER_USERFIELD
Return

WSMETHOD CLONE WSCLIENT MTSUPPLIER_USERFIELD
	Local oClone := MTSUPPLIER_USERFIELD():NEW()
	oClone:nUSERDEC             := ::nUSERDEC
	oClone:cUSERNAME            := ::cUSERNAME
	oClone:lUSEROBLIG           := ::lUSEROBLIG
	oClone:cUSERPICTURE         := ::cUSERPICTURE
	oClone:nUSERSIZE            := ::nUSERSIZE
	oClone:cUSERTAG             := ::cUSERTAG
	oClone:cUSERTITLE           := ::cUSERTITLE
	oClone:cUSERTYPE            := ::cUSERTYPE
Return oClone

WSMETHOD SOAPSEND WSCLIENT MTSUPPLIER_USERFIELD
	Local cSoap := ""
	cSoap += WSSoapValue("USERDEC", ::nUSERDEC, ::nUSERDEC , "integer", .F. , .F., 0 ) 
	cSoap += WSSoapValue("USERNAME", ::cUSERNAME, ::cUSERNAME , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("USEROBLIG", ::lUSEROBLIG, ::lUSEROBLIG , "boolean", .F. , .F., 0 ) 
	cSoap += WSSoapValue("USERPICTURE", ::cUSERPICTURE, ::cUSERPICTURE , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("USERSIZE", ::nUSERSIZE, ::nUSERSIZE , "integer", .F. , .F., 0 ) 
	cSoap += WSSoapValue("USERTAG", ::cUSERTAG, ::cUSERTAG , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("USERTITLE", ::cUSERTITLE, ::cUSERTITLE , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("USERTYPE", ::cUSERTYPE, ::cUSERTYPE , "string", .T. , .F., 0 ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MTSUPPLIER_USERFIELD
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nUSERDEC           :=  WSAdvValue( oResponse,"_USERDEC","integer",NIL,NIL,NIL,"N",NIL) 
	::cUSERNAME          :=  WSAdvValue( oResponse,"_USERNAME","string",NIL,"Property cUSERNAME as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::lUSEROBLIG         :=  WSAdvValue( oResponse,"_USEROBLIG","boolean",NIL,NIL,NIL,"L",NIL) 
	::cUSERPICTURE       :=  WSAdvValue( oResponse,"_USERPICTURE","string",NIL,NIL,NIL,"S",NIL) 
	::nUSERSIZE          :=  WSAdvValue( oResponse,"_USERSIZE","integer",NIL,NIL,NIL,"N",NIL) 
	::cUSERTAG           :=  WSAdvValue( oResponse,"_USERTAG","string",NIL,NIL,NIL,"S",NIL) 
	::cUSERTITLE         :=  WSAdvValue( oResponse,"_USERTITLE","string",NIL,NIL,NIL,"S",NIL) 
	::cUSERTYPE          :=  WSAdvValue( oResponse,"_USERTYPE","string",NIL,"Property cUSERTYPE as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return


