#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.1.1.19:4080/0103/DVVENDEDOR.apw?WSDL
Gerado em        08/18/05 09:01:38
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.050513
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _RRSBSLA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSDVVENDEDOR
------------------------------------------------------------------------------- */

WSCLIENT WSDVVENDEDOR

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD LISTAVENDEDOR

	WSDATA   _URL                      AS String
	WSDATA   cCODEMPRESA               AS string
	WSDATA   nPAGEFIRST                AS integer
	WSDATA   nPAGELEN                  AS integer
	WSDATA   oWSLISTAVENDEDORRESULT    AS DVVENDEDOR_ARRAYOFFILIALVENDVIEW

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSDVVENDEDOR
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.050506P] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSDVVENDEDOR
	::oWSLISTAVENDEDORRESULT := DVVENDEDOR_ARRAYOFFILIALVENDVIEW():New()
Return

WSMETHOD RESET WSCLIENT WSDVVENDEDOR
	::cCODEMPRESA        := NIL 
	::nPAGEFIRST         := NIL 
	::nPAGELEN           := NIL 
	::oWSLISTAVENDEDORRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSDVVENDEDOR
Local oClone := WSDVVENDEDOR():New()
	oClone:_URL          := ::_URL 
	oClone:cCODEMPRESA   := ::cCODEMPRESA
	oClone:nPAGEFIRST    := ::nPAGEFIRST
	oClone:nPAGELEN      := ::nPAGELEN
	oClone:oWSLISTAVENDEDORRESULT :=  IIF(::oWSLISTAVENDEDORRESULT = NIL , NIL ,::oWSLISTAVENDEDORRESULT:Clone() )
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method LISTAVENDEDOR of Service WSDVVENDEDOR
------------------------------------------------------------------------------- */

WSMETHOD LISTAVENDEDOR WSSEND cCODEMPRESA,nPAGEFIRST,nPAGELEN WSRECEIVE oWSLISTAVENDEDORRESULT WSCLIENT WSDVVENDEDOR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<LISTAVENDEDOR xmlns="http://192.1.1.19:4080/0103/">'
cSoap += WSSoapValue("CODEMPRESA", ::cCODEMPRESA, cCODEMPRESA , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("PAGEFIRST", ::nPAGEFIRST, nPAGEFIRST , "integer", .T. , .F., 0 ) 
cSoap += WSSoapValue("PAGELEN", ::nPAGELEN, nPAGELEN , "integer", .T. , .F., 0 ) 
cSoap += "</LISTAVENDEDOR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/0103/LISTAVENDEDOR",; 
	"DOCUMENT","http://192.1.1.19:4080/0103/",,"1.031217",; 
	"http://192.1.1.19:4080/0103/DVVENDEDOR.apw")

::Init()
::oWSLISTAVENDEDORRESULT:SoapRecv( WSAdvValue( oXmlRet,"_LISTAVENDEDORRESPONSE:_LISTAVENDEDORRESULT","ARRAYOFFILIALVENDVIEW",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFFILIALVENDVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDEDOR_ARRAYOFFILIALVENDVIEW
	WSDATA   oWSFILIALVENDVIEW         AS DVVENDEDOR_FILIALVENDVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDEDOR_ARRAYOFFILIALVENDVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDEDOR_ARRAYOFFILIALVENDVIEW
	::oWSFILIALVENDVIEW    := {} // Array Of  DVVENDEDOR_FILIALVENDVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVVENDEDOR_ARRAYOFFILIALVENDVIEW
	Local oClone := DVVENDEDOR_ARRAYOFFILIALVENDVIEW():NEW()
	oClone:oWSFILIALVENDVIEW := NIL
	If ::oWSFILIALVENDVIEW <> NIL 
		oClone:oWSFILIALVENDVIEW := {}
		aEval( ::oWSFILIALVENDVIEW , { |x| aadd( oClone:oWSFILIALVENDVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDEDOR_ARRAYOFFILIALVENDVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_FILIALVENDVIEW","FILIALVENDVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSFILIALVENDVIEW , DVVENDEDOR_FILIALVENDVIEW():New() )
			::oWSFILIALVENDVIEW[len(::oWSFILIALVENDVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure FILIALVENDVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDEDOR_FILIALVENDVIEW
	WSDATA   cFILIAL                   AS string
	WSDATA   oWSVENDEDOR               AS DVVENDEDOR_ARRAYOFVENDEDORVIEW
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDEDOR_FILIALVENDVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDEDOR_FILIALVENDVIEW
Return

WSMETHOD CLONE WSCLIENT DVVENDEDOR_FILIALVENDVIEW
	Local oClone := DVVENDEDOR_FILIALVENDVIEW():NEW()
	oClone:cFILIAL              := ::cFILIAL
	oClone:oWSVENDEDOR          := IIF(::oWSVENDEDOR = NIL , NIL , ::oWSVENDEDOR:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDEDOR_FILIALVENDVIEW
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_VENDEDOR","ARRAYOFVENDEDORVIEW",NIL,"Property oWSVENDEDOR as s0:ARRAYOFVENDEDORVIEW on SOAP Response not found.",NIL,"O",NIL) 
	If oNode2 != NIL
		::oWSVENDEDOR := DVVENDEDOR_ARRAYOFVENDEDORVIEW():New()
		::oWSVENDEDOR:SoapRecv(oNode2)
	EndIf
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFVENDEDORVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDEDOR_ARRAYOFVENDEDORVIEW
	WSDATA   oWSVENDEDORVIEW           AS DVVENDEDOR_VENDEDORVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDEDOR_ARRAYOFVENDEDORVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDEDOR_ARRAYOFVENDEDORVIEW
	::oWSVENDEDORVIEW      := {} // Array Of  DVVENDEDOR_VENDEDORVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVVENDEDOR_ARRAYOFVENDEDORVIEW
	Local oClone := DVVENDEDOR_ARRAYOFVENDEDORVIEW():NEW()
	oClone:oWSVENDEDORVIEW := NIL
	If ::oWSVENDEDORVIEW <> NIL 
		oClone:oWSVENDEDORVIEW := {}
		aEval( ::oWSVENDEDORVIEW , { |x| aadd( oClone:oWSVENDEDORVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDEDOR_ARRAYOFVENDEDORVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_VENDEDORVIEW","VENDEDORVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSVENDEDORVIEW , DVVENDEDOR_VENDEDORVIEW():New() )
			::oWSVENDEDORVIEW[len(::oWSVENDEDORVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure VENDEDORVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDEDOR_VENDEDORVIEW
	WSDATA   cACREFIN                  AS string
	WSDATA   nALBAIXA                  AS integer
	WSDATA   nALEMISS                  AS integer
	WSDATA   cBAIRRO                   AS string
	WSDATA   cBCO1                     AS string
	WSDATA   cCEP                      AS string
	WSDATA   cCGC                      AS string
	WSDATA   cCLIFIM                   AS string
	WSDATA   cCLIINI                   AS string
	WSDATA   cCOD                      AS string
	WSDATA   cCODUSR                   AS string
	WSDATA   nCOMIS                    AS float
	WSDATA   cDDD                      AS string
	WSDATA   cDEPEND                   AS string
	WSDATA   nDIA                      AS integer
	WSDATA   nDIARESE                  AS integer
	WSDATA   cEMAIL                    AS string
	WSDATA   cENDE                     AS string
	WSDATA   cEST                      AS string
	WSDATA   cFAT_RH                   AS string
	WSDATA   cFAX                      AS string
	WSDATA   cFILIAL                   AS string
	WSDATA   cFORNECE                  AS string
	WSDATA   cFRETE                    AS string
	WSDATA   cGERASE2                  AS string
	WSDATA   cGEREN                    AS string
	WSDATA   cGRPREP                   AS string
	WSDATA   cGRUPSAN                  AS string
	WSDATA   cHPAGE                    AS string
	WSDATA   cICM                      AS string
	WSDATA   cICMSRET                  AS string
	WSDATA   cINSCR                    AS string
	WSDATA   cINSCRM                   AS string
	WSDATA   cIPI                      AS string
	WSDATA   cISS                      AS string
	WSDATA   cLOCARQ                   AS string
	WSDATA   cLOJA                     AS string
	WSDATA   cMENS1                    AS string
	WSDATA   cMENS2                    AS string
	WSDATA   cMUN                      AS string
	WSDATA   cNOME                     AS string
	WSDATA   cNREDUZ                   AS string
	WSDATA   cPEDFIM                   AS string
	WSDATA   cPEDINI                   AS string
	WSDATA   nPEN_ALI                  AS float
	WSDATA   nPERDESC                  AS float
	WSDATA   cPROXCLI                  AS string
	WSDATA   cPROXPED                  AS string
	WSDATA   cREGIAO                   AS string
	WSDATA   cSENHA                    AS string
	WSDATA   cSUPERV                   AS string
	WSDATA   cTEL                      AS string
	WSDATA   cTELEX                    AS string
	WSDATA   cTIPO                     AS string
	WSDATA   cTIPVEND                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDEDOR_VENDEDORVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDEDOR_VENDEDORVIEW
Return

WSMETHOD CLONE WSCLIENT DVVENDEDOR_VENDEDORVIEW
	Local oClone := DVVENDEDOR_VENDEDORVIEW():NEW()
	oClone:cACREFIN             := ::cACREFIN
	oClone:nALBAIXA             := ::nALBAIXA
	oClone:nALEMISS             := ::nALEMISS
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cBCO1                := ::cBCO1
	oClone:cCEP                 := ::cCEP
	oClone:cCGC                 := ::cCGC
	oClone:cCLIFIM              := ::cCLIFIM
	oClone:cCLIINI              := ::cCLIINI
	oClone:cCOD                 := ::cCOD
	oClone:cCODUSR              := ::cCODUSR
	oClone:nCOMIS               := ::nCOMIS
	oClone:cDDD                 := ::cDDD
	oClone:cDEPEND              := ::cDEPEND
	oClone:nDIA                 := ::nDIA
	oClone:nDIARESE             := ::nDIARESE
	oClone:cEMAIL               := ::cEMAIL
	oClone:cENDE                := ::cENDE
	oClone:cEST                 := ::cEST
	oClone:cFAT_RH              := ::cFAT_RH
	oClone:cFAX                 := ::cFAX
	oClone:cFILIAL              := ::cFILIAL
	oClone:cFORNECE             := ::cFORNECE
	oClone:cFRETE               := ::cFRETE
	oClone:cGERASE2             := ::cGERASE2
	oClone:cGEREN               := ::cGEREN
	oClone:cGRPREP              := ::cGRPREP
	oClone:cGRUPSAN             := ::cGRUPSAN
	oClone:cHPAGE               := ::cHPAGE
	oClone:cICM                 := ::cICM
	oClone:cICMSRET             := ::cICMSRET
	oClone:cINSCR               := ::cINSCR
	oClone:cINSCRM              := ::cINSCRM
	oClone:cIPI                 := ::cIPI
	oClone:cISS                 := ::cISS
	oClone:cLOCARQ              := ::cLOCARQ
	oClone:cLOJA                := ::cLOJA
	oClone:cMENS1               := ::cMENS1
	oClone:cMENS2               := ::cMENS2
	oClone:cMUN                 := ::cMUN
	oClone:cNOME                := ::cNOME
	oClone:cNREDUZ              := ::cNREDUZ
	oClone:cPEDFIM              := ::cPEDFIM
	oClone:cPEDINI              := ::cPEDINI
	oClone:nPEN_ALI             := ::nPEN_ALI
	oClone:nPERDESC             := ::nPERDESC
	oClone:cPROXCLI             := ::cPROXCLI
	oClone:cPROXPED             := ::cPROXPED
	oClone:cREGIAO              := ::cREGIAO
	oClone:cSENHA               := ::cSENHA
	oClone:cSUPERV              := ::cSUPERV
	oClone:cTEL                 := ::cTEL
	oClone:cTELEX               := ::cTELEX
	oClone:cTIPO                := ::cTIPO
	oClone:cTIPVEND             := ::cTIPVEND
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDEDOR_VENDEDORVIEW
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cACREFIN           :=  WSAdvValue( oResponse,"_ACREFIN","string",NIL,"Property cACREFIN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nALBAIXA           :=  WSAdvValue( oResponse,"_ALBAIXA","integer",NIL,"Property nALBAIXA as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nALEMISS           :=  WSAdvValue( oResponse,"_ALEMISS","integer",NIL,"Property nALEMISS as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cBAIRRO            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,"Property cBAIRRO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBCO1              :=  WSAdvValue( oResponse,"_BCO1","string",NIL,"Property cBCO1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,"Property cCEP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCGC               :=  WSAdvValue( oResponse,"_CGC","string",NIL,"Property cCGC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLIFIM            :=  WSAdvValue( oResponse,"_CLIFIM","string",NIL,"Property cCLIFIM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLIINI            :=  WSAdvValue( oResponse,"_CLIINI","string",NIL,"Property cCLIINI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCOD               :=  WSAdvValue( oResponse,"_COD","string",NIL,"Property cCOD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODUSR            :=  WSAdvValue( oResponse,"_CODUSR","string",NIL,"Property cCODUSR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nCOMIS             :=  WSAdvValue( oResponse,"_COMIS","float",NIL,"Property nCOMIS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cDDD               :=  WSAdvValue( oResponse,"_DDD","string",NIL,"Property cDDD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDEPEND            :=  WSAdvValue( oResponse,"_DEPEND","string",NIL,"Property cDEPEND as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nDIA               :=  WSAdvValue( oResponse,"_DIA","integer",NIL,"Property nDIA as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nDIARESE           :=  WSAdvValue( oResponse,"_DIARESE","integer",NIL,"Property nDIARESE as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cEMAIL             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,"Property cEMAIL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cENDE              :=  WSAdvValue( oResponse,"_ENDE","string",NIL,"Property cENDE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cEST               :=  WSAdvValue( oResponse,"_EST","string",NIL,"Property cEST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFAT_RH            :=  WSAdvValue( oResponse,"_FAT_RH","string",NIL,"Property cFAT_RH as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFAX               :=  WSAdvValue( oResponse,"_FAX","string",NIL,"Property cFAX as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFORNECE           :=  WSAdvValue( oResponse,"_FORNECE","string",NIL,"Property cFORNECE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFRETE             :=  WSAdvValue( oResponse,"_FRETE","string",NIL,"Property cFRETE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cGERASE2           :=  WSAdvValue( oResponse,"_GERASE2","string",NIL,"Property cGERASE2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cGEREN             :=  WSAdvValue( oResponse,"_GEREN","string",NIL,"Property cGEREN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cGRPREP            :=  WSAdvValue( oResponse,"_GRPREP","string",NIL,"Property cGRPREP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cGRUPSAN           :=  WSAdvValue( oResponse,"_GRUPSAN","string",NIL,"Property cGRUPSAN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cHPAGE             :=  WSAdvValue( oResponse,"_HPAGE","string",NIL,"Property cHPAGE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cICM               :=  WSAdvValue( oResponse,"_ICM","string",NIL,"Property cICM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cICMSRET           :=  WSAdvValue( oResponse,"_ICMSRET","string",NIL,"Property cICMSRET as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cINSCR             :=  WSAdvValue( oResponse,"_INSCR","string",NIL,"Property cINSCR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cINSCRM            :=  WSAdvValue( oResponse,"_INSCRM","string",NIL,"Property cINSCRM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cIPI               :=  WSAdvValue( oResponse,"_IPI","string",NIL,"Property cIPI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cISS               :=  WSAdvValue( oResponse,"_ISS","string",NIL,"Property cISS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOCARQ            :=  WSAdvValue( oResponse,"_LOCARQ","string",NIL,"Property cLOCARQ as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,"Property cLOJA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMENS1             :=  WSAdvValue( oResponse,"_MENS1","string",NIL,"Property cMENS1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMENS2             :=  WSAdvValue( oResponse,"_MENS2","string",NIL,"Property cMENS2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMUN               :=  WSAdvValue( oResponse,"_MUN","string",NIL,"Property cMUN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNREDUZ            :=  WSAdvValue( oResponse,"_NREDUZ","string",NIL,"Property cNREDUZ as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPEDFIM            :=  WSAdvValue( oResponse,"_PEDFIM","string",NIL,"Property cPEDFIM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPEDINI            :=  WSAdvValue( oResponse,"_PEDINI","string",NIL,"Property cPEDINI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPEN_ALI           :=  WSAdvValue( oResponse,"_PEN_ALI","float",NIL,"Property nPEN_ALI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nPERDESC           :=  WSAdvValue( oResponse,"_PERDESC","float",NIL,"Property nPERDESC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cPROXCLI           :=  WSAdvValue( oResponse,"_PROXCLI","string",NIL,"Property cPROXCLI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPROXPED           :=  WSAdvValue( oResponse,"_PROXPED","string",NIL,"Property cPROXPED as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREGIAO            :=  WSAdvValue( oResponse,"_REGIAO","string",NIL,"Property cREGIAO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSENHA             :=  WSAdvValue( oResponse,"_SENHA","string",NIL,"Property cSENHA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSUPERV            :=  WSAdvValue( oResponse,"_SUPERV","string",NIL,"Property cSUPERV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTEL               :=  WSAdvValue( oResponse,"_TEL","string",NIL,"Property cTEL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTELEX             :=  WSAdvValue( oResponse,"_TELEX","string",NIL,"Property cTELEX as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPO              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,"Property cTIPO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPVEND           :=  WSAdvValue( oResponse,"_TIPVEND","string",NIL,"Property cTIPVEND as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return


