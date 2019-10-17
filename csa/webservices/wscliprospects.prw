#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.1.1.19:4080/0103/DVPROSPECTS.apw?WSDL
Gerado em        08/18/05 08:57:05
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.050513
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _HLNPXQB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSDVPROSPECTS
------------------------------------------------------------------------------- */

WSCLIENT WSDVPROSPECTS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD LISTAPROSPECT

	WSDATA   _URL                      AS String
	WSDATA   cCODEMPRESA               AS string
	WSDATA   cCODVEND                  AS string
	WSDATA   cORDEM                    AS string
	WSDATA   cNOMECLI                  AS string
	WSDATA   nPAGEFIRST                AS integer
	WSDATA   nPAGELEN                  AS integer
	WSDATA   oWSLISTAPROSPECTRESULT    AS DVPROSPECTS_ARRAYOFFILIALPROSVIEW

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSDVPROSPECTS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.050506P] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSDVPROSPECTS
	::oWSLISTAPROSPECTRESULT := DVPROSPECTS_ARRAYOFFILIALPROSVIEW():New()
Return

WSMETHOD RESET WSCLIENT WSDVPROSPECTS
	::cCODEMPRESA        := NIL 
	::cCODVEND           := NIL 
	::cORDEM             := NIL 
	::cNOMECLI           := NIL 
	::nPAGEFIRST         := NIL 
	::nPAGELEN           := NIL 
	::oWSLISTAPROSPECTRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSDVPROSPECTS
Local oClone := WSDVPROSPECTS():New()
	oClone:_URL          := ::_URL 
	oClone:cCODEMPRESA   := ::cCODEMPRESA
	oClone:cCODVEND      := ::cCODVEND
	oClone:cORDEM        := ::cORDEM
	oClone:cNOMECLI      := ::cNOMECLI
	oClone:nPAGEFIRST    := ::nPAGEFIRST
	oClone:nPAGELEN      := ::nPAGELEN
	oClone:oWSLISTAPROSPECTRESULT :=  IIF(::oWSLISTAPROSPECTRESULT = NIL , NIL ,::oWSLISTAPROSPECTRESULT:Clone() )
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method LISTAPROSPECT of Service WSDVPROSPECTS
------------------------------------------------------------------------------- */

WSMETHOD LISTAPROSPECT WSSEND cCODEMPRESA,cCODVEND,cORDEM,cNOMECLI,nPAGEFIRST,nPAGELEN WSRECEIVE oWSLISTAPROSPECTRESULT WSCLIENT WSDVPROSPECTS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<LISTAPROSPECT xmlns="http://192.1.1.19:4080/0103/">'
cSoap += WSSoapValue("CODEMPRESA", ::cCODEMPRESA, cCODEMPRESA , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("CODVEND", ::cCODVEND, cCODVEND , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("ORDEM", ::cORDEM, cORDEM , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("NOMECLI", ::cNOMECLI, cNOMECLI , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("PAGEFIRST", ::nPAGEFIRST, nPAGEFIRST , "integer", .T. , .F., 0 ) 
cSoap += WSSoapValue("PAGELEN", ::nPAGELEN, nPAGELEN , "integer", .T. , .F., 0 ) 
cSoap += "</LISTAPROSPECT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/0103/LISTAPROSPECT",; 
	"DOCUMENT","http://192.1.1.19:4080/0103/",,"1.031217",; 
	"http://192.1.1.19:4080/0103/DVPROSPECTS.apw")

::Init()
::oWSLISTAPROSPECTRESULT:SoapRecv( WSAdvValue( oXmlRet,"_LISTAPROSPECTRESPONSE:_LISTAPROSPECTRESULT","ARRAYOFFILIALPROSVIEW",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFFILIALPROSVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVPROSPECTS_ARRAYOFFILIALPROSVIEW
	WSDATA   oWSFILIALPROSVIEW         AS DVPROSPECTS_FILIALPROSVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVPROSPECTS_ARRAYOFFILIALPROSVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVPROSPECTS_ARRAYOFFILIALPROSVIEW
	::oWSFILIALPROSVIEW    := {} // Array Of  DVPROSPECTS_FILIALPROSVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVPROSPECTS_ARRAYOFFILIALPROSVIEW
	Local oClone := DVPROSPECTS_ARRAYOFFILIALPROSVIEW():NEW()
	oClone:oWSFILIALPROSVIEW := NIL
	If ::oWSFILIALPROSVIEW <> NIL 
		oClone:oWSFILIALPROSVIEW := {}
		aEval( ::oWSFILIALPROSVIEW , { |x| aadd( oClone:oWSFILIALPROSVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVPROSPECTS_ARRAYOFFILIALPROSVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_FILIALPROSVIEW","FILIALPROSVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSFILIALPROSVIEW , DVPROSPECTS_FILIALPROSVIEW():New() )
			::oWSFILIALPROSVIEW[len(::oWSFILIALPROSVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure FILIALPROSVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVPROSPECTS_FILIALPROSVIEW
	WSDATA   cFILIAL                   AS string
	WSDATA   oWSPROSPLIST              AS DVPROSPECTS_ARRAYOFPROSPVIEW
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVPROSPECTS_FILIALPROSVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVPROSPECTS_FILIALPROSVIEW
Return

WSMETHOD CLONE WSCLIENT DVPROSPECTS_FILIALPROSVIEW
	Local oClone := DVPROSPECTS_FILIALPROSVIEW():NEW()
	oClone:cFILIAL              := ::cFILIAL
	oClone:oWSPROSPLIST         := IIF(::oWSPROSPLIST = NIL , NIL , ::oWSPROSPLIST:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVPROSPECTS_FILIALPROSVIEW
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_PROSPLIST","ARRAYOFPROSPVIEW",NIL,"Property oWSPROSPLIST as s0:ARRAYOFPROSPVIEW on SOAP Response not found.",NIL,"O",NIL) 
	If oNode2 != NIL
		::oWSPROSPLIST := DVPROSPECTS_ARRAYOFPROSPVIEW():New()
		::oWSPROSPLIST:SoapRecv(oNode2)
	EndIf
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFPROSPVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVPROSPECTS_ARRAYOFPROSPVIEW
	WSDATA   oWSPROSPVIEW              AS DVPROSPECTS_PROSPVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVPROSPECTS_ARRAYOFPROSPVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVPROSPECTS_ARRAYOFPROSPVIEW
	::oWSPROSPVIEW         := {} // Array Of  DVPROSPECTS_PROSPVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVPROSPECTS_ARRAYOFPROSPVIEW
	Local oClone := DVPROSPECTS_ARRAYOFPROSPVIEW():NEW()
	oClone:oWSPROSPVIEW := NIL
	If ::oWSPROSPVIEW <> NIL 
		oClone:oWSPROSPVIEW := {}
		aEval( ::oWSPROSPVIEW , { |x| aadd( oClone:oWSPROSPVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVPROSPECTS_ARRAYOFPROSPVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PROSPVIEW","PROSPVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSPROSPVIEW , DVPROSPECTS_PROSPVIEW():New() )
			::oWSPROSPVIEW[len(::oWSPROSPVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure PROSPVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVPROSPECTS_PROSPVIEW
	WSDATA   cBAIRRO                   AS string
	WSDATA   cCEP                      AS string
	WSDATA   cCGC                      AS string
	WSDATA   cCOD                      AS string
	WSDATA   cCODCLI                   AS string
	WSDATA   cCODHIST                  AS string
	WSDATA   cDDD                      AS string
	WSDATA   cDDI                      AS string
	WSDATA   dDTCONV                   AS date OPTIONAL
	WSDATA   dDTINCLU                  AS date OPTIONAL
	WSDATA   cEMAIL                    AS string
	WSDATA   cENDE                     AS string
	WSDATA   cEST                      AS string
	WSDATA   cFAX                      AS string
	WSDATA   cFILIAL                   AS string
	WSDATA   cINSCR                    AS string
	WSDATA   cLOJA                     AS string
	WSDATA   cLOJACLI                  AS string
	WSDATA   cMUN                      AS string
	WSDATA   cNOME                     AS string
	WSDATA   cNREDUZ                   AS string
	WSDATA   cORIGEM                   AS string
	WSDATA   cSATIV                    AS string
	WSDATA   cSATIV2                   AS string
	WSDATA   cSATIV3                   AS string
	WSDATA   cSATIV4                   AS string
	WSDATA   cSATIV5                   AS string
	WSDATA   cSATIV6                   AS string
	WSDATA   cSATIV7                   AS string
	WSDATA   cSATIV8                   AS string
	WSDATA   cSTATUSP                  AS string
	WSDATA   cTEL                      AS string
	WSDATA   cTIPO                     AS string
	WSDATA   dULTVIS                   AS date OPTIONAL
	WSDATA   cURL                      AS string
	WSDATA   cVEND                     AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVPROSPECTS_PROSPVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVPROSPECTS_PROSPVIEW
Return

WSMETHOD CLONE WSCLIENT DVPROSPECTS_PROSPVIEW
	Local oClone := DVPROSPECTS_PROSPVIEW():NEW()
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cCEP                 := ::cCEP
	oClone:cCGC                 := ::cCGC
	oClone:cCOD                 := ::cCOD
	oClone:cCODCLI              := ::cCODCLI
	oClone:cCODHIST             := ::cCODHIST
	oClone:cDDD                 := ::cDDD
	oClone:cDDI                 := ::cDDI
	oClone:dDTCONV              := ::dDTCONV
	oClone:dDTINCLU             := ::dDTINCLU
	oClone:cEMAIL               := ::cEMAIL
	oClone:cENDE                := ::cENDE
	oClone:cEST                 := ::cEST
	oClone:cFAX                 := ::cFAX
	oClone:cFILIAL              := ::cFILIAL
	oClone:cINSCR               := ::cINSCR
	oClone:cLOJA                := ::cLOJA
	oClone:cLOJACLI             := ::cLOJACLI
	oClone:cMUN                 := ::cMUN
	oClone:cNOME                := ::cNOME
	oClone:cNREDUZ              := ::cNREDUZ
	oClone:cORIGEM              := ::cORIGEM
	oClone:cSATIV               := ::cSATIV
	oClone:cSATIV2              := ::cSATIV2
	oClone:cSATIV3              := ::cSATIV3
	oClone:cSATIV4              := ::cSATIV4
	oClone:cSATIV5              := ::cSATIV5
	oClone:cSATIV6              := ::cSATIV6
	oClone:cSATIV7              := ::cSATIV7
	oClone:cSATIV8              := ::cSATIV8
	oClone:cSTATUSP             := ::cSTATUSP
	oClone:cTEL                 := ::cTEL
	oClone:cTIPO                := ::cTIPO
	oClone:dULTVIS              := ::dULTVIS
	oClone:cURL                 := ::cURL
	oClone:cVEND                := ::cVEND
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVPROSPECTS_PROSPVIEW
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cBAIRRO            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,"Property cBAIRRO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,"Property cCEP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCGC               :=  WSAdvValue( oResponse,"_CGC","string",NIL,"Property cCGC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCOD               :=  WSAdvValue( oResponse,"_COD","string",NIL,"Property cCOD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODCLI            :=  WSAdvValue( oResponse,"_CODCLI","string",NIL,"Property cCODCLI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODHIST           :=  WSAdvValue( oResponse,"_CODHIST","string",NIL,"Property cCODHIST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDDD               :=  WSAdvValue( oResponse,"_DDD","string",NIL,"Property cDDD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDDI               :=  WSAdvValue( oResponse,"_DDI","string",NIL,"Property cDDI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dDTCONV            :=  WSAdvValue( oResponse,"_DTCONV","date",NIL,NIL,NIL,"D",NIL) 
	::dDTINCLU           :=  WSAdvValue( oResponse,"_DTINCLU","date",NIL,NIL,NIL,"D",NIL) 
	::cEMAIL             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,"Property cEMAIL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cENDE              :=  WSAdvValue( oResponse,"_ENDE","string",NIL,"Property cENDE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cEST               :=  WSAdvValue( oResponse,"_EST","string",NIL,"Property cEST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFAX               :=  WSAdvValue( oResponse,"_FAX","string",NIL,"Property cFAX as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cINSCR             :=  WSAdvValue( oResponse,"_INSCR","string",NIL,"Property cINSCR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,"Property cLOJA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOJACLI           :=  WSAdvValue( oResponse,"_LOJACLI","string",NIL,"Property cLOJACLI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMUN               :=  WSAdvValue( oResponse,"_MUN","string",NIL,"Property cMUN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNREDUZ            :=  WSAdvValue( oResponse,"_NREDUZ","string",NIL,"Property cNREDUZ as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cORIGEM            :=  WSAdvValue( oResponse,"_ORIGEM","string",NIL,"Property cORIGEM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV             :=  WSAdvValue( oResponse,"_SATIV","string",NIL,"Property cSATIV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV2            :=  WSAdvValue( oResponse,"_SATIV2","string",NIL,"Property cSATIV2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV3            :=  WSAdvValue( oResponse,"_SATIV3","string",NIL,"Property cSATIV3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV4            :=  WSAdvValue( oResponse,"_SATIV4","string",NIL,"Property cSATIV4 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV5            :=  WSAdvValue( oResponse,"_SATIV5","string",NIL,"Property cSATIV5 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV6            :=  WSAdvValue( oResponse,"_SATIV6","string",NIL,"Property cSATIV6 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV7            :=  WSAdvValue( oResponse,"_SATIV7","string",NIL,"Property cSATIV7 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV8            :=  WSAdvValue( oResponse,"_SATIV8","string",NIL,"Property cSATIV8 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSTATUSP           :=  WSAdvValue( oResponse,"_STATUSP","string",NIL,"Property cSTATUSP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTEL               :=  WSAdvValue( oResponse,"_TEL","string",NIL,"Property cTEL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPO              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,"Property cTIPO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dULTVIS            :=  WSAdvValue( oResponse,"_ULTVIS","date",NIL,NIL,NIL,"D",NIL) 
	::cURL               :=  WSAdvValue( oResponse,"_URL","string",NIL,"Property cURL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND              :=  WSAdvValue( oResponse,"_VEND","string",NIL,"Property cVEND as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return


