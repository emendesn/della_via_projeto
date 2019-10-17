#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.1.1.19:4080/0103/DVVENDAS.apw?WSDL
Gerado em        08/18/05 08:59:36
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.050513
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _RXOTTJH ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSDVVENDAS
------------------------------------------------------------------------------- */
              #INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.1.1.19:4080/0103/DVVENDEDOR.apw?WSDL
Gerado em        08/18/05 09:01:14
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.050513
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _LJIMLAR ; Return  // "dummy" function - Internal Use 

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



WSCLIENT WSDVVENDAS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CONSULTANF
	WSMETHOD VENDASCLI
	WSMETHOD VENDASVEND

	WSDATA   _URL                      AS String
	WSDATA   cCODEMPRESA               AS string
	WSDATA   cCODFILIAL                AS string
	WSDATA   cNUMNF                    AS string
	WSDATA   cSERIENF                  AS string
	WSDATA   oWSCONSULTANFRESULT       AS DVVENDAS_NOTAFISCALVIEW
	WSDATA   cCODCLI                   AS string
	WSDATA   dDATAINI                  AS date
	WSDATA   dDATAFIM                  AS date
	WSDATA   cORDEM                    AS string
	WSDATA   oWSVENDASCLIRESULT        AS DVVENDAS_ARRAYOFVENDASVIEW
	WSDATA   cCODVENDEDOR              AS string
	WSDATA   oWSVENDASVENDRESULT       AS DVVENDAS_ARRAYOFVENDASVIEW

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSDVVENDAS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.050506P] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSDVVENDAS
	::oWSCONSULTANFRESULT := DVVENDAS_NOTAFISCALVIEW():New()
	::oWSVENDASCLIRESULT := DVVENDAS_ARRAYOFVENDASVIEW():New()
	::oWSVENDASVENDRESULT := DVVENDAS_ARRAYOFVENDASVIEW():New()
Return

WSMETHOD RESET WSCLIENT WSDVVENDAS
	::cCODEMPRESA        := NIL 
	::cCODFILIAL         := NIL 
	::cNUMNF             := NIL 
	::cSERIENF           := NIL 
	::oWSCONSULTANFRESULT := NIL 
	::cCODCLI            := NIL 
	::dDATAINI           := NIL 
	::dDATAFIM           := NIL 
	::cORDEM             := NIL 
	::oWSVENDASCLIRESULT := NIL 
	::cCODVENDEDOR       := NIL 
	::oWSVENDASVENDRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSDVVENDAS
Local oClone := WSDVVENDAS():New()
	oClone:_URL          := ::_URL 
	oClone:cCODEMPRESA   := ::cCODEMPRESA
	oClone:cCODFILIAL    := ::cCODFILIAL
	oClone:cNUMNF        := ::cNUMNF
	oClone:cSERIENF      := ::cSERIENF
	oClone:oWSCONSULTANFRESULT :=  IIF(::oWSCONSULTANFRESULT = NIL , NIL ,::oWSCONSULTANFRESULT:Clone() )
	oClone:cCODCLI       := ::cCODCLI
	oClone:dDATAINI      := ::dDATAINI
	oClone:dDATAFIM      := ::dDATAFIM
	oClone:cORDEM        := ::cORDEM
	oClone:oWSVENDASCLIRESULT :=  IIF(::oWSVENDASCLIRESULT = NIL , NIL ,::oWSVENDASCLIRESULT:Clone() )
	oClone:cCODVENDEDOR  := ::cCODVENDEDOR
	oClone:oWSVENDASVENDRESULT :=  IIF(::oWSVENDASVENDRESULT = NIL , NIL ,::oWSVENDASVENDRESULT:Clone() )
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CONSULTANF of Service WSDVVENDAS
------------------------------------------------------------------------------- */

WSMETHOD CONSULTANF WSSEND cCODEMPRESA,cCODFILIAL,cNUMNF,cSERIENF WSRECEIVE oWSCONSULTANFRESULT WSCLIENT WSDVVENDAS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONSULTANF xmlns="http://192.1.1.19:4080/0103/">'
cSoap += WSSoapValue("CODEMPRESA", ::cCODEMPRESA, cCODEMPRESA , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("CODFILIAL", ::cCODFILIAL, cCODFILIAL , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("NUMNF", ::cNUMNF, cNUMNF , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("SERIENF", ::cSERIENF, cSERIENF , "string", .T. , .F., 0 ) 
cSoap += "</CONSULTANF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/0103/CONSULTANF",; 
	"DOCUMENT","http://192.1.1.19:4080/0103/",,"1.031217",; 
	"http://192.1.1.19:4080/0103/DVVENDAS.apw")

::Init()
::oWSCONSULTANFRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTANFRESPONSE:_CONSULTANFRESULT","NOTAFISCALVIEW",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method VENDASCLI of Service WSDVVENDAS
------------------------------------------------------------------------------- */

WSMETHOD VENDASCLI WSSEND cCODEMPRESA,cCODCLI,dDATAINI,dDATAFIM,cORDEM WSRECEIVE oWSVENDASCLIRESULT WSCLIENT WSDVVENDAS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<VENDASCLI xmlns="http://192.1.1.19:4080/0103/">'
cSoap += WSSoapValue("CODEMPRESA", ::cCODEMPRESA, cCODEMPRESA , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("CODCLI", ::cCODCLI, cCODCLI , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("DATAINI", ::dDATAINI, dDATAINI , "date", .T. , .F., 0 ) 
cSoap += WSSoapValue("DATAFIM", ::dDATAFIM, dDATAFIM , "date", .T. , .F., 0 ) 
cSoap += WSSoapValue("ORDEM", ::cORDEM, cORDEM , "string", .T. , .F., 0 ) 
cSoap += "</VENDASCLI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/0103/VENDASCLI",; 
	"DOCUMENT","http://192.1.1.19:4080/0103/",,"1.031217",; 
	"http://192.1.1.19:4080/0103/DVVENDAS.apw")

::Init()
::oWSVENDASCLIRESULT:SoapRecv( WSAdvValue( oXmlRet,"_VENDASCLIRESPONSE:_VENDASCLIRESULT","ARRAYOFVENDASVIEW",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method VENDASVEND of Service WSDVVENDAS
------------------------------------------------------------------------------- */

WSMETHOD VENDASVEND WSSEND cCODEMPRESA,cCODVENDEDOR,dDATAINI,dDATAFIM,cORDEM WSRECEIVE oWSVENDASVENDRESULT WSCLIENT WSDVVENDAS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<VENDASVEND xmlns="http://192.1.1.19:4080/0103/">'
cSoap += WSSoapValue("CODEMPRESA", ::cCODEMPRESA, cCODEMPRESA , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("CODVENDEDOR", ::cCODVENDEDOR, cCODVENDEDOR , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("DATAINI", ::dDATAINI, dDATAINI , "date", .T. , .F., 0 ) 
cSoap += WSSoapValue("DATAFIM", ::dDATAFIM, dDATAFIM , "date", .T. , .F., 0 ) 
cSoap += WSSoapValue("ORDEM", ::cORDEM, cORDEM , "string", .T. , .F., 0 ) 
cSoap += "</VENDASVEND>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/0103/VENDASVEND",; 
	"DOCUMENT","http://192.1.1.19:4080/0103/",,"1.031217",; 
	"http://192.1.1.19:4080/0103/DVVENDAS.apw")

::Init()
::oWSVENDASVENDRESULT:SoapRecv( WSAdvValue( oXmlRet,"_VENDASVENDRESPONSE:_VENDASVENDRESULT","ARRAYOFVENDASVIEW",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure NOTAFISCALVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDAS_NOTAFISCALVIEW
	WSDATA   nBASEICM                  AS float
	WSDATA   nBASEINS                  AS float
	WSDATA   nBASEIPI                  AS float
	WSDATA   nBASEISS                  AS float
	WSDATA   nBASIMP1                  AS float
	WSDATA   nBASIMP2                  AS float
	WSDATA   nBASIMP3                  AS float
	WSDATA   nBASIMP4                  AS float
	WSDATA   nBASIMP5                  AS float
	WSDATA   nBASIMP6                  AS float
	WSDATA   nBRICMS                   AS float
	WSDATA   cCARGA                    AS string
	WSDATA   cCLIENTE                  AS string
	WSDATA   cCOND                     AS string
	WSDATA   nCONTSOC                  AS float
	WSDATA   nDESCCAB                  AS float
	WSDATA   nDESCONT                  AS float
	WSDATA   nDESPESA                  AS float
	WSDATA   cDOC                      AS string
	WSDATA   dDTBASE0                  AS date OPTIONAL
	WSDATA   dDTBASE1                  AS date OPTIONAL
	WSDATA   dDTDIGIT                  AS date OPTIONAL
	WSDATA   dDTENTR                   AS date OPTIONAL
	WSDATA   dDTLANC                   AS date OPTIONAL
	WSDATA   dDTREAJ                   AS date OPTIONAL
	WSDATA   cDUPL                     AS string
	WSDATA   cECF                      AS string
	WSDATA   dEMISSAO                  AS date OPTIONAL
	WSDATA   cESPECI1                  AS string
	WSDATA   cESPECI2                  AS string
	WSDATA   cESPECI3                  AS string
	WSDATA   cESPECI4                  AS string
	WSDATA   cESPECIE                  AS string
	WSDATA   cEST                      AS string
	WSDATA   nFATORB0                  AS float
	WSDATA   nFATORB1                  AS float
	WSDATA   cFILIAL                   AS string
	WSDATA   cFIMP                     AS string
	WSDATA   cFORMUL                   AS string
	WSDATA   nFRETAUT                  AS float
	WSDATA   nFRETE                    AS float
	WSDATA   cHAWB                     AS string
	WSDATA   cHORA                     AS string
	WSDATA   nICMAUTO                  AS float
	WSDATA   nICMFRET                  AS float
	WSDATA   nICMSDIF                  AS float
	WSDATA   nICMSRET                  AS float
	WSDATA   oWSITENSNF                AS DVVENDAS_ARRAYOFITENSNFVIEW
	WSDATA   cLOJA                     AS string
	WSDATA   cLOTE                     AS string
	WSDATA   cMAPA                     AS string
	WSDATA   nMOEDA                    AS integer
	WSDATA   cNEXTDOC                  AS string
	WSDATA   cNEXTSER                  AS string
	WSDATA   cNFCUPOM                  AS string
	WSDATA   cNFEACRS                  AS string
	WSDATA   cNFORI                    AS string
	WSDATA   cOK                       AS string
	WSDATA   cORDPAGO                  AS string
	WSDATA   nPBRUTO                   AS float
	WSDATA   cPDV                      AS string
	WSDATA   cPEDPEND                  AS string
	WSDATA   nPLIQUI                   AS float
	WSDATA   cPREFIXO                  AS string
	WSDATA   cREAJUST                  AS string
	WSDATA   cREDESP                   AS string
	WSDATA   cREGIAO                   AS string
	WSDATA   nSEGURO                   AS float
	WSDATA   cSEQCAR                   AS string
	WSDATA   cSEQENT                   AS string
	WSDATA   cSERIE                    AS string
	WSDATA   cSERIORI                  AS string
	WSDATA   cTIPO                     AS string
	WSDATA   cTIPOCLI                  AS string
	WSDATA   cTIPODOC                  AS string
	WSDATA   cTIPOREM                  AS string
	WSDATA   cTIPORET                  AS string
	WSDATA   cTRANSP                   AS string
	WSDATA   nTXMOEDA                  AS float
	WSDATA   cUSERLGA                  AS string
	WSDATA   cUSERLGI                  AS string
	WSDATA   nVALACRS                  AS float
	WSDATA   nVALBRUT                  AS float
	WSDATA   nVALCOFI                  AS float
	WSDATA   nVALCSLL                  AS float
	WSDATA   nVALFAT                   AS float
	WSDATA   nVALICM                   AS float
	WSDATA   nVALIMP1                  AS float
	WSDATA   nVALIMP2                  AS float
	WSDATA   nVALIMP3                  AS float
	WSDATA   nVALIMP4                  AS float
	WSDATA   nVALIMP5                  AS float
	WSDATA   nVALIMP6                  AS float
	WSDATA   nVALINSS                  AS float
	WSDATA   nVALIPI                   AS float
	WSDATA   nVALIRRF                  AS float
	WSDATA   nVALISS                   AS float
	WSDATA   nVALMERC                  AS float
	WSDATA   nVALPIS                   AS float
	WSDATA   nVARIAC                   AS float
	WSDATA   cVEND1                    AS string
	WSDATA   cVEND2                    AS string
	WSDATA   cVEND3                    AS string
	WSDATA   cVEND4                    AS string
	WSDATA   cVEND5                    AS string
	WSDATA   nVOLUME1                  AS integer
	WSDATA   nVOLUME2                  AS integer
	WSDATA   nVOLUME3                  AS integer
	WSDATA   nVOLUME4                  AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDAS_NOTAFISCALVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDAS_NOTAFISCALVIEW
Return

WSMETHOD CLONE WSCLIENT DVVENDAS_NOTAFISCALVIEW
	Local oClone := DVVENDAS_NOTAFISCALVIEW():NEW()
	oClone:nBASEICM             := ::nBASEICM
	oClone:nBASEINS             := ::nBASEINS
	oClone:nBASEIPI             := ::nBASEIPI
	oClone:nBASEISS             := ::nBASEISS
	oClone:nBASIMP1             := ::nBASIMP1
	oClone:nBASIMP2             := ::nBASIMP2
	oClone:nBASIMP3             := ::nBASIMP3
	oClone:nBASIMP4             := ::nBASIMP4
	oClone:nBASIMP5             := ::nBASIMP5
	oClone:nBASIMP6             := ::nBASIMP6
	oClone:nBRICMS              := ::nBRICMS
	oClone:cCARGA               := ::cCARGA
	oClone:cCLIENTE             := ::cCLIENTE
	oClone:cCOND                := ::cCOND
	oClone:nCONTSOC             := ::nCONTSOC
	oClone:nDESCCAB             := ::nDESCCAB
	oClone:nDESCONT             := ::nDESCONT
	oClone:nDESPESA             := ::nDESPESA
	oClone:cDOC                 := ::cDOC
	oClone:dDTBASE0             := ::dDTBASE0
	oClone:dDTBASE1             := ::dDTBASE1
	oClone:dDTDIGIT             := ::dDTDIGIT
	oClone:dDTENTR              := ::dDTENTR
	oClone:dDTLANC              := ::dDTLANC
	oClone:dDTREAJ              := ::dDTREAJ
	oClone:cDUPL                := ::cDUPL
	oClone:cECF                 := ::cECF
	oClone:dEMISSAO             := ::dEMISSAO
	oClone:cESPECI1             := ::cESPECI1
	oClone:cESPECI2             := ::cESPECI2
	oClone:cESPECI3             := ::cESPECI3
	oClone:cESPECI4             := ::cESPECI4
	oClone:cESPECIE             := ::cESPECIE
	oClone:cEST                 := ::cEST
	oClone:nFATORB0             := ::nFATORB0
	oClone:nFATORB1             := ::nFATORB1
	oClone:cFILIAL              := ::cFILIAL
	oClone:cFIMP                := ::cFIMP
	oClone:cFORMUL              := ::cFORMUL
	oClone:nFRETAUT             := ::nFRETAUT
	oClone:nFRETE               := ::nFRETE
	oClone:cHAWB                := ::cHAWB
	oClone:cHORA                := ::cHORA
	oClone:nICMAUTO             := ::nICMAUTO
	oClone:nICMFRET             := ::nICMFRET
	oClone:nICMSDIF             := ::nICMSDIF
	oClone:nICMSRET             := ::nICMSRET
	oClone:oWSITENSNF           := IIF(::oWSITENSNF = NIL , NIL , ::oWSITENSNF:Clone() )
	oClone:cLOJA                := ::cLOJA
	oClone:cLOTE                := ::cLOTE
	oClone:cMAPA                := ::cMAPA
	oClone:nMOEDA               := ::nMOEDA
	oClone:cNEXTDOC             := ::cNEXTDOC
	oClone:cNEXTSER             := ::cNEXTSER
	oClone:cNFCUPOM             := ::cNFCUPOM
	oClone:cNFEACRS             := ::cNFEACRS
	oClone:cNFORI               := ::cNFORI
	oClone:cOK                  := ::cOK
	oClone:cORDPAGO             := ::cORDPAGO
	oClone:nPBRUTO              := ::nPBRUTO
	oClone:cPDV                 := ::cPDV
	oClone:cPEDPEND             := ::cPEDPEND
	oClone:nPLIQUI              := ::nPLIQUI
	oClone:cPREFIXO             := ::cPREFIXO
	oClone:cREAJUST             := ::cREAJUST
	oClone:cREDESP              := ::cREDESP
	oClone:cREGIAO              := ::cREGIAO
	oClone:nSEGURO              := ::nSEGURO
	oClone:cSEQCAR              := ::cSEQCAR
	oClone:cSEQENT              := ::cSEQENT
	oClone:cSERIE               := ::cSERIE
	oClone:cSERIORI             := ::cSERIORI
	oClone:cTIPO                := ::cTIPO
	oClone:cTIPOCLI             := ::cTIPOCLI
	oClone:cTIPODOC             := ::cTIPODOC
	oClone:cTIPOREM             := ::cTIPOREM
	oClone:cTIPORET             := ::cTIPORET
	oClone:cTRANSP              := ::cTRANSP
	oClone:nTXMOEDA             := ::nTXMOEDA
	oClone:cUSERLGA             := ::cUSERLGA
	oClone:cUSERLGI             := ::cUSERLGI
	oClone:nVALACRS             := ::nVALACRS
	oClone:nVALBRUT             := ::nVALBRUT
	oClone:nVALCOFI             := ::nVALCOFI
	oClone:nVALCSLL             := ::nVALCSLL
	oClone:nVALFAT              := ::nVALFAT
	oClone:nVALICM              := ::nVALICM
	oClone:nVALIMP1             := ::nVALIMP1
	oClone:nVALIMP2             := ::nVALIMP2
	oClone:nVALIMP3             := ::nVALIMP3
	oClone:nVALIMP4             := ::nVALIMP4
	oClone:nVALIMP5             := ::nVALIMP5
	oClone:nVALIMP6             := ::nVALIMP6
	oClone:nVALINSS             := ::nVALINSS
	oClone:nVALIPI              := ::nVALIPI
	oClone:nVALIRRF             := ::nVALIRRF
	oClone:nVALISS              := ::nVALISS
	oClone:nVALMERC             := ::nVALMERC
	oClone:nVALPIS              := ::nVALPIS
	oClone:nVARIAC              := ::nVARIAC
	oClone:cVEND1               := ::cVEND1
	oClone:cVEND2               := ::cVEND2
	oClone:cVEND3               := ::cVEND3
	oClone:cVEND4               := ::cVEND4
	oClone:cVEND5               := ::cVEND5
	oClone:nVOLUME1             := ::nVOLUME1
	oClone:nVOLUME2             := ::nVOLUME2
	oClone:nVOLUME3             := ::nVOLUME3
	oClone:nVOLUME4             := ::nVOLUME4
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDAS_NOTAFISCALVIEW
	Local oNode48
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nBASEICM           :=  WSAdvValue( oResponse,"_BASEICM","float",NIL,"Property nBASEICM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEINS           :=  WSAdvValue( oResponse,"_BASEINS","float",NIL,"Property nBASEINS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEIPI           :=  WSAdvValue( oResponse,"_BASEIPI","float",NIL,"Property nBASEIPI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEISS           :=  WSAdvValue( oResponse,"_BASEISS","float",NIL,"Property nBASEISS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP1           :=  WSAdvValue( oResponse,"_BASIMP1","float",NIL,"Property nBASIMP1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP2           :=  WSAdvValue( oResponse,"_BASIMP2","float",NIL,"Property nBASIMP2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP3           :=  WSAdvValue( oResponse,"_BASIMP3","float",NIL,"Property nBASIMP3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP4           :=  WSAdvValue( oResponse,"_BASIMP4","float",NIL,"Property nBASIMP4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP5           :=  WSAdvValue( oResponse,"_BASIMP5","float",NIL,"Property nBASIMP5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP6           :=  WSAdvValue( oResponse,"_BASIMP6","float",NIL,"Property nBASIMP6 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBRICMS            :=  WSAdvValue( oResponse,"_BRICMS","float",NIL,"Property nBRICMS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cCARGA             :=  WSAdvValue( oResponse,"_CARGA","string",NIL,"Property cCARGA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLIENTE           :=  WSAdvValue( oResponse,"_CLIENTE","string",NIL,"Property cCLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCOND              :=  WSAdvValue( oResponse,"_COND","string",NIL,"Property cCOND as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nCONTSOC           :=  WSAdvValue( oResponse,"_CONTSOC","float",NIL,"Property nCONTSOC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESCCAB           :=  WSAdvValue( oResponse,"_DESCCAB","float",NIL,"Property nDESCCAB as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESCONT           :=  WSAdvValue( oResponse,"_DESCONT","float",NIL,"Property nDESCONT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESPESA           :=  WSAdvValue( oResponse,"_DESPESA","float",NIL,"Property nDESPESA as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cDOC               :=  WSAdvValue( oResponse,"_DOC","string",NIL,"Property cDOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dDTBASE0           :=  WSAdvValue( oResponse,"_DTBASE0","date",NIL,NIL,NIL,"D",NIL) 
	::dDTBASE1           :=  WSAdvValue( oResponse,"_DTBASE1","date",NIL,NIL,NIL,"D",NIL) 
	::dDTDIGIT           :=  WSAdvValue( oResponse,"_DTDIGIT","date",NIL,NIL,NIL,"D",NIL) 
	::dDTENTR            :=  WSAdvValue( oResponse,"_DTENTR","date",NIL,NIL,NIL,"D",NIL) 
	::dDTLANC            :=  WSAdvValue( oResponse,"_DTLANC","date",NIL,NIL,NIL,"D",NIL) 
	::dDTREAJ            :=  WSAdvValue( oResponse,"_DTREAJ","date",NIL,NIL,NIL,"D",NIL) 
	::cDUPL              :=  WSAdvValue( oResponse,"_DUPL","string",NIL,"Property cDUPL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cECF               :=  WSAdvValue( oResponse,"_ECF","string",NIL,"Property cECF as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dEMISSAO           :=  WSAdvValue( oResponse,"_EMISSAO","date",NIL,NIL,NIL,"D",NIL) 
	::cESPECI1           :=  WSAdvValue( oResponse,"_ESPECI1","string",NIL,"Property cESPECI1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESPECI2           :=  WSAdvValue( oResponse,"_ESPECI2","string",NIL,"Property cESPECI2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESPECI3           :=  WSAdvValue( oResponse,"_ESPECI3","string",NIL,"Property cESPECI3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESPECI4           :=  WSAdvValue( oResponse,"_ESPECI4","string",NIL,"Property cESPECI4 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESPECIE           :=  WSAdvValue( oResponse,"_ESPECIE","string",NIL,"Property cESPECIE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cEST               :=  WSAdvValue( oResponse,"_EST","string",NIL,"Property cEST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nFATORB0           :=  WSAdvValue( oResponse,"_FATORB0","float",NIL,"Property nFATORB0 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nFATORB1           :=  WSAdvValue( oResponse,"_FATORB1","float",NIL,"Property nFATORB1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFIMP              :=  WSAdvValue( oResponse,"_FIMP","string",NIL,"Property cFIMP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFORMUL            :=  WSAdvValue( oResponse,"_FORMUL","string",NIL,"Property cFORMUL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nFRETAUT           :=  WSAdvValue( oResponse,"_FRETAUT","float",NIL,"Property nFRETAUT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nFRETE             :=  WSAdvValue( oResponse,"_FRETE","float",NIL,"Property nFRETE as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cHAWB              :=  WSAdvValue( oResponse,"_HAWB","string",NIL,"Property cHAWB as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cHORA              :=  WSAdvValue( oResponse,"_HORA","string",NIL,"Property cHORA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nICMAUTO           :=  WSAdvValue( oResponse,"_ICMAUTO","float",NIL,"Property nICMAUTO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nICMFRET           :=  WSAdvValue( oResponse,"_ICMFRET","float",NIL,"Property nICMFRET as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nICMSDIF           :=  WSAdvValue( oResponse,"_ICMSDIF","float",NIL,"Property nICMSDIF as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nICMSRET           :=  WSAdvValue( oResponse,"_ICMSRET","float",NIL,"Property nICMSRET as s:float on SOAP Response not found.",NIL,"N",NIL) 
	oNode48 :=  WSAdvValue( oResponse,"_ITENSNF","ARRAYOFITENSNFVIEW",NIL,"Property oWSITENSNF as s0:ARRAYOFITENSNFVIEW on SOAP Response not found.",NIL,"O",NIL) 
	If oNode48 != NIL
		::oWSITENSNF := DVVENDAS_ARRAYOFITENSNFVIEW():New()
		::oWSITENSNF:SoapRecv(oNode48)
	EndIf
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,"Property cLOJA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOTE              :=  WSAdvValue( oResponse,"_LOTE","string",NIL,"Property cLOTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMAPA              :=  WSAdvValue( oResponse,"_MAPA","string",NIL,"Property cMAPA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nMOEDA             :=  WSAdvValue( oResponse,"_MOEDA","integer",NIL,"Property nMOEDA as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cNEXTDOC           :=  WSAdvValue( oResponse,"_NEXTDOC","string",NIL,"Property cNEXTDOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNEXTSER           :=  WSAdvValue( oResponse,"_NEXTSER","string",NIL,"Property cNEXTSER as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNFCUPOM           :=  WSAdvValue( oResponse,"_NFCUPOM","string",NIL,"Property cNFCUPOM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNFEACRS           :=  WSAdvValue( oResponse,"_NFEACRS","string",NIL,"Property cNFEACRS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNFORI             :=  WSAdvValue( oResponse,"_NFORI","string",NIL,"Property cNFORI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cOK                :=  WSAdvValue( oResponse,"_OK","string",NIL,"Property cOK as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cORDPAGO           :=  WSAdvValue( oResponse,"_ORDPAGO","string",NIL,"Property cORDPAGO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPBRUTO            :=  WSAdvValue( oResponse,"_PBRUTO","float",NIL,"Property nPBRUTO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cPDV               :=  WSAdvValue( oResponse,"_PDV","string",NIL,"Property cPDV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPEDPEND           :=  WSAdvValue( oResponse,"_PEDPEND","string",NIL,"Property cPEDPEND as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPLIQUI            :=  WSAdvValue( oResponse,"_PLIQUI","float",NIL,"Property nPLIQUI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cPREFIXO           :=  WSAdvValue( oResponse,"_PREFIXO","string",NIL,"Property cPREFIXO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREAJUST           :=  WSAdvValue( oResponse,"_REAJUST","string",NIL,"Property cREAJUST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREDESP            :=  WSAdvValue( oResponse,"_REDESP","string",NIL,"Property cREDESP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREGIAO            :=  WSAdvValue( oResponse,"_REGIAO","string",NIL,"Property cREGIAO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nSEGURO            :=  WSAdvValue( oResponse,"_SEGURO","float",NIL,"Property nSEGURO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cSEQCAR            :=  WSAdvValue( oResponse,"_SEQCAR","string",NIL,"Property cSEQCAR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSEQENT            :=  WSAdvValue( oResponse,"_SEQENT","string",NIL,"Property cSEQENT as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSERIE             :=  WSAdvValue( oResponse,"_SERIE","string",NIL,"Property cSERIE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSERIORI           :=  WSAdvValue( oResponse,"_SERIORI","string",NIL,"Property cSERIORI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPO              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,"Property cTIPO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPOCLI           :=  WSAdvValue( oResponse,"_TIPOCLI","string",NIL,"Property cTIPOCLI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPODOC           :=  WSAdvValue( oResponse,"_TIPODOC","string",NIL,"Property cTIPODOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPOREM           :=  WSAdvValue( oResponse,"_TIPOREM","string",NIL,"Property cTIPOREM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPORET           :=  WSAdvValue( oResponse,"_TIPORET","string",NIL,"Property cTIPORET as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTRANSP            :=  WSAdvValue( oResponse,"_TRANSP","string",NIL,"Property cTRANSP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nTXMOEDA           :=  WSAdvValue( oResponse,"_TXMOEDA","float",NIL,"Property nTXMOEDA as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cUSERLGA           :=  WSAdvValue( oResponse,"_USERLGA","string",NIL,"Property cUSERLGA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cUSERLGI           :=  WSAdvValue( oResponse,"_USERLGI","string",NIL,"Property cUSERLGI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nVALACRS           :=  WSAdvValue( oResponse,"_VALACRS","float",NIL,"Property nVALACRS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALBRUT           :=  WSAdvValue( oResponse,"_VALBRUT","float",NIL,"Property nVALBRUT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALCOFI           :=  WSAdvValue( oResponse,"_VALCOFI","float",NIL,"Property nVALCOFI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALCSLL           :=  WSAdvValue( oResponse,"_VALCSLL","float",NIL,"Property nVALCSLL as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALFAT            :=  WSAdvValue( oResponse,"_VALFAT","float",NIL,"Property nVALFAT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALICM            :=  WSAdvValue( oResponse,"_VALICM","float",NIL,"Property nVALICM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP1           :=  WSAdvValue( oResponse,"_VALIMP1","float",NIL,"Property nVALIMP1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP2           :=  WSAdvValue( oResponse,"_VALIMP2","float",NIL,"Property nVALIMP2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP3           :=  WSAdvValue( oResponse,"_VALIMP3","float",NIL,"Property nVALIMP3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP4           :=  WSAdvValue( oResponse,"_VALIMP4","float",NIL,"Property nVALIMP4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP5           :=  WSAdvValue( oResponse,"_VALIMP5","float",NIL,"Property nVALIMP5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP6           :=  WSAdvValue( oResponse,"_VALIMP6","float",NIL,"Property nVALIMP6 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALINSS           :=  WSAdvValue( oResponse,"_VALINSS","float",NIL,"Property nVALINSS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIPI            :=  WSAdvValue( oResponse,"_VALIPI","float",NIL,"Property nVALIPI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIRRF           :=  WSAdvValue( oResponse,"_VALIRRF","float",NIL,"Property nVALIRRF as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALISS            :=  WSAdvValue( oResponse,"_VALISS","float",NIL,"Property nVALISS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALMERC           :=  WSAdvValue( oResponse,"_VALMERC","float",NIL,"Property nVALMERC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALPIS            :=  WSAdvValue( oResponse,"_VALPIS","float",NIL,"Property nVALPIS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVARIAC            :=  WSAdvValue( oResponse,"_VARIAC","float",NIL,"Property nVARIAC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cVEND1             :=  WSAdvValue( oResponse,"_VEND1","string",NIL,"Property cVEND1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND2             :=  WSAdvValue( oResponse,"_VEND2","string",NIL,"Property cVEND2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND3             :=  WSAdvValue( oResponse,"_VEND3","string",NIL,"Property cVEND3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND4             :=  WSAdvValue( oResponse,"_VEND4","string",NIL,"Property cVEND4 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND5             :=  WSAdvValue( oResponse,"_VEND5","string",NIL,"Property cVEND5 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nVOLUME1           :=  WSAdvValue( oResponse,"_VOLUME1","integer",NIL,"Property nVOLUME1 as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nVOLUME2           :=  WSAdvValue( oResponse,"_VOLUME2","integer",NIL,"Property nVOLUME2 as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nVOLUME3           :=  WSAdvValue( oResponse,"_VOLUME3","integer",NIL,"Property nVOLUME3 as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nVOLUME4           :=  WSAdvValue( oResponse,"_VOLUME4","integer",NIL,"Property nVOLUME4 as s:integer on SOAP Response not found.",NIL,"N",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFVENDASVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDAS_ARRAYOFVENDASVIEW
	WSDATA   oWSVENDASVIEW             AS DVVENDAS_VENDASVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDAS_ARRAYOFVENDASVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDAS_ARRAYOFVENDASVIEW
	::oWSVENDASVIEW        := {} // Array Of  DVVENDAS_VENDASVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVVENDAS_ARRAYOFVENDASVIEW
	Local oClone := DVVENDAS_ARRAYOFVENDASVIEW():NEW()
	oClone:oWSVENDASVIEW := NIL
	If ::oWSVENDASVIEW <> NIL 
		oClone:oWSVENDASVIEW := {}
		aEval( ::oWSVENDASVIEW , { |x| aadd( oClone:oWSVENDASVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDAS_ARRAYOFVENDASVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_VENDASVIEW","VENDASVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSVENDASVIEW , DVVENDAS_VENDASVIEW():New() )
			::oWSVENDASVIEW[len(::oWSVENDASVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFITENSNFVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDAS_ARRAYOFITENSNFVIEW
	WSDATA   oWSITENSNFVIEW            AS DVVENDAS_ITENSNFVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDAS_ARRAYOFITENSNFVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDAS_ARRAYOFITENSNFVIEW
	::oWSITENSNFVIEW       := {} // Array Of  DVVENDAS_ITENSNFVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVVENDAS_ARRAYOFITENSNFVIEW
	Local oClone := DVVENDAS_ARRAYOFITENSNFVIEW():NEW()
	oClone:oWSITENSNFVIEW := NIL
	If ::oWSITENSNFVIEW <> NIL 
		oClone:oWSITENSNFVIEW := {}
		aEval( ::oWSITENSNFVIEW , { |x| aadd( oClone:oWSITENSNFVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDAS_ARRAYOFITENSNFVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ITENSNFVIEW","ITENSNFVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSITENSNFVIEW , DVVENDAS_ITENSNFVIEW():New() )
			::oWSITENSNFVIEW[len(::oWSITENSNFVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure VENDASVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDAS_VENDASVIEW
	WSDATA   oWSCABECNF                AS DVVENDAS_ARRAYOFCABECNFVIEW
	WSDATA   cFILIAL                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDAS_VENDASVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDAS_VENDASVIEW
Return

WSMETHOD CLONE WSCLIENT DVVENDAS_VENDASVIEW
	Local oClone := DVVENDAS_VENDASVIEW():NEW()
	oClone:oWSCABECNF           := IIF(::oWSCABECNF = NIL , NIL , ::oWSCABECNF:Clone() )
	oClone:cFILIAL              := ::cFILIAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDAS_VENDASVIEW
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_CABECNF","ARRAYOFCABECNFVIEW",NIL,"Property oWSCABECNF as s0:ARRAYOFCABECNFVIEW on SOAP Response not found.",NIL,"O",NIL) 
	If oNode1 != NIL
		::oWSCABECNF := DVVENDAS_ARRAYOFCABECNFVIEW():New()
		::oWSCABECNF:SoapRecv(oNode1)
	EndIf
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ITENSNFVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDAS_ITENSNFVIEW
	WSDATA   nALIQINS                  AS float
	WSDATA   nALIQISS                  AS float
	WSDATA   nALQIMP1                  AS float
	WSDATA   nALQIMP2                  AS float
	WSDATA   nALQIMP3                  AS float
	WSDATA   nALQIMP4                  AS float
	WSDATA   nALQIMP5                  AS float
	WSDATA   nALQIMP6                  AS float
	WSDATA   nBASEICM                  AS float
	WSDATA   nBASEINS                  AS float
	WSDATA   nBASEIPI                  AS float
	WSDATA   nBASEISS                  AS float
	WSDATA   nBASEORI                  AS float
	WSDATA   nBASIMP1                  AS float
	WSDATA   nBASIMP2                  AS float
	WSDATA   nBASIMP3                  AS float
	WSDATA   nBASIMP4                  AS float
	WSDATA   nBASIMP5                  AS float
	WSDATA   nBASIMP6                  AS float
	WSDATA   nBRICMS                   AS float
	WSDATA   cCCUSTO                   AS string
	WSDATA   cCF                       AS string
	WSDATA   cCLASFIS                  AS string
	WSDATA   cCLIENTE                  AS string
	WSDATA   cCLOCAL                   AS string
	WSDATA   cCLVL                     AS string
	WSDATA   nCM1                      AS float
	WSDATA   cCOD                      AS string
	WSDATA   cCODFAB                   AS string
	WSDATA   cCODISS                   AS string
	WSDATA   nCOMIS1                   AS float
	WSDATA   nCOMIS2                   AS float
	WSDATA   nCOMIS3                   AS float
	WSDATA   nCOMIS4                   AS float
	WSDATA   nCOMIS5                   AS float
	WSDATA   cCONTA                    AS string
	WSDATA   nCUSFF1                   AS float
	WSDATA   nCUSFF2                   AS float
	WSDATA   nCUSFF3                   AS float
	WSDATA   nCUSFF4                   AS float
	WSDATA   nCUSFF5                   AS float
	WSDATA   nCUSTO1                   AS float
	WSDATA   nCUSTO2                   AS float
	WSDATA   nCUSTO3                   AS float
	WSDATA   nCUSTO4                   AS float
	WSDATA   nCUSTO5                   AS float
	WSDATA   nDESC                     AS float
	WSDATA   nDESCON                   AS float
	WSDATA   nDESCZFR                  AS float
	WSDATA   nDESPESA                  AS float
	WSDATA   nDESPMM                   AS float
	WSDATA   cDOC                      AS string
	WSDATA   dDTDIGIT                  AS date OPTIONAL
	WSDATA   dDTLCTCT                  AS date OPTIONAL
	WSDATA   dDTVALID                  AS date OPTIONAL
	WSDATA   cEDTPMS                   AS string
	WSDATA   dEMISSAO                  AS date OPTIONAL
	WSDATA   dENVCNAB                  AS date OPTIONAL
	WSDATA   cEST                      AS string
	WSDATA   cFILIAL                   AS string
	WSDATA   cFORMUL                   AS string
	WSDATA   cGRADE                    AS string
	WSDATA   cGRUPO                    AS string
	WSDATA   nICMFRET                  AS float
	WSDATA   nICMSRET                  AS float
	WSDATA   cIDENTB6                  AS string
	WSDATA   nIPI                      AS float
	WSDATA   cITEM                     AS string
	WSDATA   cITEMCC                   AS string
	WSDATA   cITEMORI                  AS string
	WSDATA   cITEMPV                   AS string
	WSDATA   cITEMREM                  AS string
	WSDATA   cLICITA                   AS string
	WSDATA   cLOCALIZ                  AS string
	WSDATA   cLOJA                     AS string
	WSDATA   cLOJAFA                   AS string
	WSDATA   cLOTECTL                  AS string
	WSDATA   nMM                       AS float
	WSDATA   cNFORI                    AS string
	WSDATA   cNUMLOTE                  AS string
	WSDATA   cNUMSEQ                   AS string
	WSDATA   cNUMSERI                  AS string
	WSDATA   cOK                       AS string
	WSDATA   cOP                       AS string
	WSDATA   cORIGLAN                  AS string
	WSDATA   cPDV                      AS string
	WSDATA   cPEDIDO                   AS string
	WSDATA   nPESO                     AS float
	WSDATA   nPICM                     AS float
	WSDATA   nPOTENCI                  AS float
	WSDATA   nPRCVEN                   AS float
	WSDATA   cPREEMB                   AS string
	WSDATA   cPROJPMS                  AS string
	WSDATA   nPRUNIT                   AS float
	WSDATA   nQTDAFAT                  AS float
	WSDATA   nQTDEDEV                  AS float
	WSDATA   nQTDEFAT                  AS float
	WSDATA   nQTSEGUM                  AS float
	WSDATA   nQUANT                    AS float
	WSDATA   cREGWMS                   AS string
	WSDATA   cREMITO                   AS string
	WSDATA   cSEGUM                    AS string
	WSDATA   nSEGURO                   AS float
	WSDATA   cSEQCALC                  AS string
	WSDATA   cSEQUEN                   AS string
	WSDATA   cSERIE                    AS string
	WSDATA   cSERIORI                  AS string
	WSDATA   cSERIREM                  AS string
	WSDATA   cSERVIC                   AS string
	WSDATA   cSTSERV                   AS string
	WSDATA   cTASKPMS                  AS string
	WSDATA   cTES                      AS string
	WSDATA   cTIPO                     AS string
	WSDATA   cTIPODOC                  AS string
	WSDATA   cTIPOREM                  AS string
	WSDATA   nTOTAL                    AS float
	WSDATA   cTP                       AS string
	WSDATA   cTPDCENV                  AS string
	WSDATA   cTPESTR                   AS string
	WSDATA   cUM                       AS string
	WSDATA   cUSERLGA                  AS string
	WSDATA   cUSERLGI                  AS string
	WSDATA   nVAC                      AS float
	WSDATA   nVALACRS                  AS float
	WSDATA   nVALBRUT                  AS float
	WSDATA   nVALDEV                   AS float
	WSDATA   nVALFRE                   AS float
	WSDATA   nVALICM                   AS float
	WSDATA   nVALIMP1                  AS float
	WSDATA   nVALIMP2                  AS float
	WSDATA   nVALIMP3                  AS float
	WSDATA   nVALIMP4                  AS float
	WSDATA   nVALIMP5                  AS float
	WSDATA   nVALIMP6                  AS float
	WSDATA   nVALINS                   AS float
	WSDATA   nVALIPI                   AS float
	WSDATA   nVALISS                   AS float
	WSDATA   nVARPRUN                  AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDAS_ITENSNFVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDAS_ITENSNFVIEW
Return

WSMETHOD CLONE WSCLIENT DVVENDAS_ITENSNFVIEW
	Local oClone := DVVENDAS_ITENSNFVIEW():NEW()
	oClone:nALIQINS             := ::nALIQINS
	oClone:nALIQISS             := ::nALIQISS
	oClone:nALQIMP1             := ::nALQIMP1
	oClone:nALQIMP2             := ::nALQIMP2
	oClone:nALQIMP3             := ::nALQIMP3
	oClone:nALQIMP4             := ::nALQIMP4
	oClone:nALQIMP5             := ::nALQIMP5
	oClone:nALQIMP6             := ::nALQIMP6
	oClone:nBASEICM             := ::nBASEICM
	oClone:nBASEINS             := ::nBASEINS
	oClone:nBASEIPI             := ::nBASEIPI
	oClone:nBASEISS             := ::nBASEISS
	oClone:nBASEORI             := ::nBASEORI
	oClone:nBASIMP1             := ::nBASIMP1
	oClone:nBASIMP2             := ::nBASIMP2
	oClone:nBASIMP3             := ::nBASIMP3
	oClone:nBASIMP4             := ::nBASIMP4
	oClone:nBASIMP5             := ::nBASIMP5
	oClone:nBASIMP6             := ::nBASIMP6
	oClone:nBRICMS              := ::nBRICMS
	oClone:cCCUSTO              := ::cCCUSTO
	oClone:cCF                  := ::cCF
	oClone:cCLASFIS             := ::cCLASFIS
	oClone:cCLIENTE             := ::cCLIENTE
	oClone:cCLOCAL              := ::cCLOCAL
	oClone:cCLVL                := ::cCLVL
	oClone:nCM1                 := ::nCM1
	oClone:cCOD                 := ::cCOD
	oClone:cCODFAB              := ::cCODFAB
	oClone:cCODISS              := ::cCODISS
	oClone:nCOMIS1              := ::nCOMIS1
	oClone:nCOMIS2              := ::nCOMIS2
	oClone:nCOMIS3              := ::nCOMIS3
	oClone:nCOMIS4              := ::nCOMIS4
	oClone:nCOMIS5              := ::nCOMIS5
	oClone:cCONTA               := ::cCONTA
	oClone:nCUSFF1              := ::nCUSFF1
	oClone:nCUSFF2              := ::nCUSFF2
	oClone:nCUSFF3              := ::nCUSFF3
	oClone:nCUSFF4              := ::nCUSFF4
	oClone:nCUSFF5              := ::nCUSFF5
	oClone:nCUSTO1              := ::nCUSTO1
	oClone:nCUSTO2              := ::nCUSTO2
	oClone:nCUSTO3              := ::nCUSTO3
	oClone:nCUSTO4              := ::nCUSTO4
	oClone:nCUSTO5              := ::nCUSTO5
	oClone:nDESC                := ::nDESC
	oClone:nDESCON              := ::nDESCON
	oClone:nDESCZFR             := ::nDESCZFR
	oClone:nDESPESA             := ::nDESPESA
	oClone:nDESPMM              := ::nDESPMM
	oClone:cDOC                 := ::cDOC
	oClone:dDTDIGIT             := ::dDTDIGIT
	oClone:dDTLCTCT             := ::dDTLCTCT
	oClone:dDTVALID             := ::dDTVALID
	oClone:cEDTPMS              := ::cEDTPMS
	oClone:dEMISSAO             := ::dEMISSAO
	oClone:dENVCNAB             := ::dENVCNAB
	oClone:cEST                 := ::cEST
	oClone:cFILIAL              := ::cFILIAL
	oClone:cFORMUL              := ::cFORMUL
	oClone:cGRADE               := ::cGRADE
	oClone:cGRUPO               := ::cGRUPO
	oClone:nICMFRET             := ::nICMFRET
	oClone:nICMSRET             := ::nICMSRET
	oClone:cIDENTB6             := ::cIDENTB6
	oClone:nIPI                 := ::nIPI
	oClone:cITEM                := ::cITEM
	oClone:cITEMCC              := ::cITEMCC
	oClone:cITEMORI             := ::cITEMORI
	oClone:cITEMPV              := ::cITEMPV
	oClone:cITEMREM             := ::cITEMREM
	oClone:cLICITA              := ::cLICITA
	oClone:cLOCALIZ             := ::cLOCALIZ
	oClone:cLOJA                := ::cLOJA
	oClone:cLOJAFA              := ::cLOJAFA
	oClone:cLOTECTL             := ::cLOTECTL
	oClone:nMM                  := ::nMM
	oClone:cNFORI               := ::cNFORI
	oClone:cNUMLOTE             := ::cNUMLOTE
	oClone:cNUMSEQ              := ::cNUMSEQ
	oClone:cNUMSERI             := ::cNUMSERI
	oClone:cOK                  := ::cOK
	oClone:cOP                  := ::cOP
	oClone:cORIGLAN             := ::cORIGLAN
	oClone:cPDV                 := ::cPDV
	oClone:cPEDIDO              := ::cPEDIDO
	oClone:nPESO                := ::nPESO
	oClone:nPICM                := ::nPICM
	oClone:nPOTENCI             := ::nPOTENCI
	oClone:nPRCVEN              := ::nPRCVEN
	oClone:cPREEMB              := ::cPREEMB
	oClone:cPROJPMS             := ::cPROJPMS
	oClone:nPRUNIT              := ::nPRUNIT
	oClone:nQTDAFAT             := ::nQTDAFAT
	oClone:nQTDEDEV             := ::nQTDEDEV
	oClone:nQTDEFAT             := ::nQTDEFAT
	oClone:nQTSEGUM             := ::nQTSEGUM
	oClone:nQUANT               := ::nQUANT
	oClone:cREGWMS              := ::cREGWMS
	oClone:cREMITO              := ::cREMITO
	oClone:cSEGUM               := ::cSEGUM
	oClone:nSEGURO              := ::nSEGURO
	oClone:cSEQCALC             := ::cSEQCALC
	oClone:cSEQUEN              := ::cSEQUEN
	oClone:cSERIE               := ::cSERIE
	oClone:cSERIORI             := ::cSERIORI
	oClone:cSERIREM             := ::cSERIREM
	oClone:cSERVIC              := ::cSERVIC
	oClone:cSTSERV              := ::cSTSERV
	oClone:cTASKPMS             := ::cTASKPMS
	oClone:cTES                 := ::cTES
	oClone:cTIPO                := ::cTIPO
	oClone:cTIPODOC             := ::cTIPODOC
	oClone:cTIPOREM             := ::cTIPOREM
	oClone:nTOTAL               := ::nTOTAL
	oClone:cTP                  := ::cTP
	oClone:cTPDCENV             := ::cTPDCENV
	oClone:cTPESTR              := ::cTPESTR
	oClone:cUM                  := ::cUM
	oClone:cUSERLGA             := ::cUSERLGA
	oClone:cUSERLGI             := ::cUSERLGI
	oClone:nVAC                 := ::nVAC
	oClone:nVALACRS             := ::nVALACRS
	oClone:nVALBRUT             := ::nVALBRUT
	oClone:nVALDEV              := ::nVALDEV
	oClone:nVALFRE              := ::nVALFRE
	oClone:nVALICM              := ::nVALICM
	oClone:nVALIMP1             := ::nVALIMP1
	oClone:nVALIMP2             := ::nVALIMP2
	oClone:nVALIMP3             := ::nVALIMP3
	oClone:nVALIMP4             := ::nVALIMP4
	oClone:nVALIMP5             := ::nVALIMP5
	oClone:nVALIMP6             := ::nVALIMP6
	oClone:nVALINS              := ::nVALINS
	oClone:nVALIPI              := ::nVALIPI
	oClone:nVALISS              := ::nVALISS
	oClone:nVARPRUN             := ::nVARPRUN
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDAS_ITENSNFVIEW
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nALIQINS           :=  WSAdvValue( oResponse,"_ALIQINS","float",NIL,"Property nALIQINS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nALIQISS           :=  WSAdvValue( oResponse,"_ALIQISS","float",NIL,"Property nALIQISS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nALQIMP1           :=  WSAdvValue( oResponse,"_ALQIMP1","float",NIL,"Property nALQIMP1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nALQIMP2           :=  WSAdvValue( oResponse,"_ALQIMP2","float",NIL,"Property nALQIMP2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nALQIMP3           :=  WSAdvValue( oResponse,"_ALQIMP3","float",NIL,"Property nALQIMP3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nALQIMP4           :=  WSAdvValue( oResponse,"_ALQIMP4","float",NIL,"Property nALQIMP4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nALQIMP5           :=  WSAdvValue( oResponse,"_ALQIMP5","float",NIL,"Property nALQIMP5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nALQIMP6           :=  WSAdvValue( oResponse,"_ALQIMP6","float",NIL,"Property nALQIMP6 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEICM           :=  WSAdvValue( oResponse,"_BASEICM","float",NIL,"Property nBASEICM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEINS           :=  WSAdvValue( oResponse,"_BASEINS","float",NIL,"Property nBASEINS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEIPI           :=  WSAdvValue( oResponse,"_BASEIPI","float",NIL,"Property nBASEIPI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEISS           :=  WSAdvValue( oResponse,"_BASEISS","float",NIL,"Property nBASEISS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEORI           :=  WSAdvValue( oResponse,"_BASEORI","float",NIL,"Property nBASEORI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP1           :=  WSAdvValue( oResponse,"_BASIMP1","float",NIL,"Property nBASIMP1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP2           :=  WSAdvValue( oResponse,"_BASIMP2","float",NIL,"Property nBASIMP2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP3           :=  WSAdvValue( oResponse,"_BASIMP3","float",NIL,"Property nBASIMP3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP4           :=  WSAdvValue( oResponse,"_BASIMP4","float",NIL,"Property nBASIMP4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP5           :=  WSAdvValue( oResponse,"_BASIMP5","float",NIL,"Property nBASIMP5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP6           :=  WSAdvValue( oResponse,"_BASIMP6","float",NIL,"Property nBASIMP6 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBRICMS            :=  WSAdvValue( oResponse,"_BRICMS","float",NIL,"Property nBRICMS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cCCUSTO            :=  WSAdvValue( oResponse,"_CCUSTO","string",NIL,"Property cCCUSTO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCF                :=  WSAdvValue( oResponse,"_CF","string",NIL,"Property cCF as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLASFIS           :=  WSAdvValue( oResponse,"_CLASFIS","string",NIL,"Property cCLASFIS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLIENTE           :=  WSAdvValue( oResponse,"_CLIENTE","string",NIL,"Property cCLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLOCAL            :=  WSAdvValue( oResponse,"_CLOCAL","string",NIL,"Property cCLOCAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLVL              :=  WSAdvValue( oResponse,"_CLVL","string",NIL,"Property cCLVL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nCM1               :=  WSAdvValue( oResponse,"_CM1","float",NIL,"Property nCM1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cCOD               :=  WSAdvValue( oResponse,"_COD","string",NIL,"Property cCOD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODFAB            :=  WSAdvValue( oResponse,"_CODFAB","string",NIL,"Property cCODFAB as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODISS            :=  WSAdvValue( oResponse,"_CODISS","string",NIL,"Property cCODISS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nCOMIS1            :=  WSAdvValue( oResponse,"_COMIS1","float",NIL,"Property nCOMIS1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS2            :=  WSAdvValue( oResponse,"_COMIS2","float",NIL,"Property nCOMIS2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS3            :=  WSAdvValue( oResponse,"_COMIS3","float",NIL,"Property nCOMIS3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS4            :=  WSAdvValue( oResponse,"_COMIS4","float",NIL,"Property nCOMIS4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS5            :=  WSAdvValue( oResponse,"_COMIS5","float",NIL,"Property nCOMIS5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cCONTA             :=  WSAdvValue( oResponse,"_CONTA","string",NIL,"Property cCONTA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nCUSFF1            :=  WSAdvValue( oResponse,"_CUSFF1","float",NIL,"Property nCUSFF1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSFF2            :=  WSAdvValue( oResponse,"_CUSFF2","float",NIL,"Property nCUSFF2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSFF3            :=  WSAdvValue( oResponse,"_CUSFF3","float",NIL,"Property nCUSFF3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSFF4            :=  WSAdvValue( oResponse,"_CUSFF4","float",NIL,"Property nCUSFF4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSFF5            :=  WSAdvValue( oResponse,"_CUSFF5","float",NIL,"Property nCUSFF5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSTO1            :=  WSAdvValue( oResponse,"_CUSTO1","float",NIL,"Property nCUSTO1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSTO2            :=  WSAdvValue( oResponse,"_CUSTO2","float",NIL,"Property nCUSTO2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSTO3            :=  WSAdvValue( oResponse,"_CUSTO3","float",NIL,"Property nCUSTO3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSTO4            :=  WSAdvValue( oResponse,"_CUSTO4","float",NIL,"Property nCUSTO4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCUSTO5            :=  WSAdvValue( oResponse,"_CUSTO5","float",NIL,"Property nCUSTO5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESC              :=  WSAdvValue( oResponse,"_DESC","float",NIL,"Property nDESC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESCON            :=  WSAdvValue( oResponse,"_DESCON","float",NIL,"Property nDESCON as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESCZFR           :=  WSAdvValue( oResponse,"_DESCZFR","float",NIL,"Property nDESCZFR as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESPESA           :=  WSAdvValue( oResponse,"_DESPESA","float",NIL,"Property nDESPESA as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESPMM            :=  WSAdvValue( oResponse,"_DESPMM","float",NIL,"Property nDESPMM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cDOC               :=  WSAdvValue( oResponse,"_DOC","string",NIL,"Property cDOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dDTDIGIT           :=  WSAdvValue( oResponse,"_DTDIGIT","date",NIL,NIL,NIL,"D",NIL) 
	::dDTLCTCT           :=  WSAdvValue( oResponse,"_DTLCTCT","date",NIL,NIL,NIL,"D",NIL) 
	::dDTVALID           :=  WSAdvValue( oResponse,"_DTVALID","date",NIL,NIL,NIL,"D",NIL) 
	::cEDTPMS            :=  WSAdvValue( oResponse,"_EDTPMS","string",NIL,"Property cEDTPMS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dEMISSAO           :=  WSAdvValue( oResponse,"_EMISSAO","date",NIL,NIL,NIL,"D",NIL) 
	::dENVCNAB           :=  WSAdvValue( oResponse,"_ENVCNAB","date",NIL,NIL,NIL,"D",NIL) 
	::cEST               :=  WSAdvValue( oResponse,"_EST","string",NIL,"Property cEST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFORMUL            :=  WSAdvValue( oResponse,"_FORMUL","string",NIL,"Property cFORMUL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cGRADE             :=  WSAdvValue( oResponse,"_GRADE","string",NIL,"Property cGRADE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cGRUPO             :=  WSAdvValue( oResponse,"_GRUPO","string",NIL,"Property cGRUPO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nICMFRET           :=  WSAdvValue( oResponse,"_ICMFRET","float",NIL,"Property nICMFRET as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nICMSRET           :=  WSAdvValue( oResponse,"_ICMSRET","float",NIL,"Property nICMSRET as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cIDENTB6           :=  WSAdvValue( oResponse,"_IDENTB6","string",NIL,"Property cIDENTB6 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nIPI               :=  WSAdvValue( oResponse,"_IPI","float",NIL,"Property nIPI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cITEM              :=  WSAdvValue( oResponse,"_ITEM","string",NIL,"Property cITEM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cITEMCC            :=  WSAdvValue( oResponse,"_ITEMCC","string",NIL,"Property cITEMCC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cITEMORI           :=  WSAdvValue( oResponse,"_ITEMORI","string",NIL,"Property cITEMORI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cITEMPV            :=  WSAdvValue( oResponse,"_ITEMPV","string",NIL,"Property cITEMPV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cITEMREM           :=  WSAdvValue( oResponse,"_ITEMREM","string",NIL,"Property cITEMREM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLICITA            :=  WSAdvValue( oResponse,"_LICITA","string",NIL,"Property cLICITA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOCALIZ           :=  WSAdvValue( oResponse,"_LOCALIZ","string",NIL,"Property cLOCALIZ as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,"Property cLOJA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOJAFA            :=  WSAdvValue( oResponse,"_LOJAFA","string",NIL,"Property cLOJAFA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOTECTL           :=  WSAdvValue( oResponse,"_LOTECTL","string",NIL,"Property cLOTECTL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nMM                :=  WSAdvValue( oResponse,"_MM","float",NIL,"Property nMM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cNFORI             :=  WSAdvValue( oResponse,"_NFORI","string",NIL,"Property cNFORI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNUMLOTE           :=  WSAdvValue( oResponse,"_NUMLOTE","string",NIL,"Property cNUMLOTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNUMSEQ            :=  WSAdvValue( oResponse,"_NUMSEQ","string",NIL,"Property cNUMSEQ as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNUMSERI           :=  WSAdvValue( oResponse,"_NUMSERI","string",NIL,"Property cNUMSERI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cOK                :=  WSAdvValue( oResponse,"_OK","string",NIL,"Property cOK as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cOP                :=  WSAdvValue( oResponse,"_OP","string",NIL,"Property cOP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cORIGLAN           :=  WSAdvValue( oResponse,"_ORIGLAN","string",NIL,"Property cORIGLAN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPDV               :=  WSAdvValue( oResponse,"_PDV","string",NIL,"Property cPDV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPEDIDO            :=  WSAdvValue( oResponse,"_PEDIDO","string",NIL,"Property cPEDIDO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPESO              :=  WSAdvValue( oResponse,"_PESO","float",NIL,"Property nPESO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nPICM              :=  WSAdvValue( oResponse,"_PICM","float",NIL,"Property nPICM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nPOTENCI           :=  WSAdvValue( oResponse,"_POTENCI","float",NIL,"Property nPOTENCI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nPRCVEN            :=  WSAdvValue( oResponse,"_PRCVEN","float",NIL,"Property nPRCVEN as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cPREEMB            :=  WSAdvValue( oResponse,"_PREEMB","string",NIL,"Property cPREEMB as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPROJPMS           :=  WSAdvValue( oResponse,"_PROJPMS","string",NIL,"Property cPROJPMS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPRUNIT            :=  WSAdvValue( oResponse,"_PRUNIT","float",NIL,"Property nPRUNIT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nQTDAFAT           :=  WSAdvValue( oResponse,"_QTDAFAT","float",NIL,"Property nQTDAFAT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nQTDEDEV           :=  WSAdvValue( oResponse,"_QTDEDEV","float",NIL,"Property nQTDEDEV as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nQTDEFAT           :=  WSAdvValue( oResponse,"_QTDEFAT","float",NIL,"Property nQTDEFAT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nQTSEGUM           :=  WSAdvValue( oResponse,"_QTSEGUM","float",NIL,"Property nQTSEGUM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nQUANT             :=  WSAdvValue( oResponse,"_QUANT","float",NIL,"Property nQUANT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cREGWMS            :=  WSAdvValue( oResponse,"_REGWMS","string",NIL,"Property cREGWMS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREMITO            :=  WSAdvValue( oResponse,"_REMITO","string",NIL,"Property cREMITO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSEGUM             :=  WSAdvValue( oResponse,"_SEGUM","string",NIL,"Property cSEGUM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nSEGURO            :=  WSAdvValue( oResponse,"_SEGURO","float",NIL,"Property nSEGURO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cSEQCALC           :=  WSAdvValue( oResponse,"_SEQCALC","string",NIL,"Property cSEQCALC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSEQUEN            :=  WSAdvValue( oResponse,"_SEQUEN","string",NIL,"Property cSEQUEN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSERIE             :=  WSAdvValue( oResponse,"_SERIE","string",NIL,"Property cSERIE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSERIORI           :=  WSAdvValue( oResponse,"_SERIORI","string",NIL,"Property cSERIORI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSERIREM           :=  WSAdvValue( oResponse,"_SERIREM","string",NIL,"Property cSERIREM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSERVIC            :=  WSAdvValue( oResponse,"_SERVIC","string",NIL,"Property cSERVIC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSTSERV            :=  WSAdvValue( oResponse,"_STSERV","string",NIL,"Property cSTSERV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTASKPMS           :=  WSAdvValue( oResponse,"_TASKPMS","string",NIL,"Property cTASKPMS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTES               :=  WSAdvValue( oResponse,"_TES","string",NIL,"Property cTES as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPO              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,"Property cTIPO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPODOC           :=  WSAdvValue( oResponse,"_TIPODOC","string",NIL,"Property cTIPODOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPOREM           :=  WSAdvValue( oResponse,"_TIPOREM","string",NIL,"Property cTIPOREM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nTOTAL             :=  WSAdvValue( oResponse,"_TOTAL","float",NIL,"Property nTOTAL as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cTP                :=  WSAdvValue( oResponse,"_TP","string",NIL,"Property cTP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTPDCENV           :=  WSAdvValue( oResponse,"_TPDCENV","string",NIL,"Property cTPDCENV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTPESTR            :=  WSAdvValue( oResponse,"_TPESTR","string",NIL,"Property cTPESTR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cUM                :=  WSAdvValue( oResponse,"_UM","string",NIL,"Property cUM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cUSERLGA           :=  WSAdvValue( oResponse,"_USERLGA","string",NIL,"Property cUSERLGA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cUSERLGI           :=  WSAdvValue( oResponse,"_USERLGI","string",NIL,"Property cUSERLGI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nVAC               :=  WSAdvValue( oResponse,"_VAC","float",NIL,"Property nVAC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALACRS           :=  WSAdvValue( oResponse,"_VALACRS","float",NIL,"Property nVALACRS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALBRUT           :=  WSAdvValue( oResponse,"_VALBRUT","float",NIL,"Property nVALBRUT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALDEV            :=  WSAdvValue( oResponse,"_VALDEV","float",NIL,"Property nVALDEV as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALFRE            :=  WSAdvValue( oResponse,"_VALFRE","float",NIL,"Property nVALFRE as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALICM            :=  WSAdvValue( oResponse,"_VALICM","float",NIL,"Property nVALICM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP1           :=  WSAdvValue( oResponse,"_VALIMP1","float",NIL,"Property nVALIMP1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP2           :=  WSAdvValue( oResponse,"_VALIMP2","float",NIL,"Property nVALIMP2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP3           :=  WSAdvValue( oResponse,"_VALIMP3","float",NIL,"Property nVALIMP3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP4           :=  WSAdvValue( oResponse,"_VALIMP4","float",NIL,"Property nVALIMP4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP5           :=  WSAdvValue( oResponse,"_VALIMP5","float",NIL,"Property nVALIMP5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP6           :=  WSAdvValue( oResponse,"_VALIMP6","float",NIL,"Property nVALIMP6 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALINS            :=  WSAdvValue( oResponse,"_VALINS","float",NIL,"Property nVALINS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIPI            :=  WSAdvValue( oResponse,"_VALIPI","float",NIL,"Property nVALIPI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALISS            :=  WSAdvValue( oResponse,"_VALISS","float",NIL,"Property nVALISS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVARPRUN           :=  WSAdvValue( oResponse,"_VARPRUN","float",NIL,"Property nVARPRUN as s:float on SOAP Response not found.",NIL,"N",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFCABECNFVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDAS_ARRAYOFCABECNFVIEW
	WSDATA   oWSCABECNFVIEW            AS DVVENDAS_CABECNFVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDAS_ARRAYOFCABECNFVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDAS_ARRAYOFCABECNFVIEW
	::oWSCABECNFVIEW       := {} // Array Of  DVVENDAS_CABECNFVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVVENDAS_ARRAYOFCABECNFVIEW
	Local oClone := DVVENDAS_ARRAYOFCABECNFVIEW():NEW()
	oClone:oWSCABECNFVIEW := NIL
	If ::oWSCABECNFVIEW <> NIL 
		oClone:oWSCABECNFVIEW := {}
		aEval( ::oWSCABECNFVIEW , { |x| aadd( oClone:oWSCABECNFVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDAS_ARRAYOFCABECNFVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CABECNFVIEW","CABECNFVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCABECNFVIEW , DVVENDAS_CABECNFVIEW():New() )
			::oWSCABECNFVIEW[len(::oWSCABECNFVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure CABECNFVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVVENDAS_CABECNFVIEW
	WSDATA   nBASEICM                  AS float
	WSDATA   nBASEINS                  AS float
	WSDATA   nBASEIPI                  AS float
	WSDATA   nBASEISS                  AS float
	WSDATA   nBASIMP1                  AS float
	WSDATA   nBASIMP2                  AS float
	WSDATA   nBASIMP3                  AS float
	WSDATA   nBASIMP4                  AS float
	WSDATA   nBASIMP5                  AS float
	WSDATA   nBASIMP6                  AS float
	WSDATA   nBRICMS                   AS float
	WSDATA   cCARGA                    AS string
	WSDATA   cCLIENTE                  AS string
	WSDATA   cCOND                     AS string
	WSDATA   nCONTSOC                  AS float
	WSDATA   nDESCCAB                  AS float
	WSDATA   nDESCONT                  AS float
	WSDATA   nDESPESA                  AS float
	WSDATA   cDOC                      AS string
	WSDATA   dDTBASE0                  AS date OPTIONAL
	WSDATA   dDTBASE1                  AS date OPTIONAL
	WSDATA   dDTDIGIT                  AS date OPTIONAL
	WSDATA   dDTENTR                   AS date OPTIONAL
	WSDATA   dDTLANC                   AS date OPTIONAL
	WSDATA   dDTREAJ                   AS date OPTIONAL
	WSDATA   cDUPL                     AS string
	WSDATA   cECF                      AS string
	WSDATA   dEMISSAO                  AS date OPTIONAL
	WSDATA   cESPECI1                  AS string
	WSDATA   cESPECI2                  AS string
	WSDATA   cESPECI3                  AS string
	WSDATA   cESPECI4                  AS string
	WSDATA   cESPECIE                  AS string
	WSDATA   cEST                      AS string
	WSDATA   nFATORB0                  AS float
	WSDATA   nFATORB1                  AS float
	WSDATA   cFILIAL                   AS string
	WSDATA   cFIMP                     AS string
	WSDATA   cFORMUL                   AS string
	WSDATA   nFRETAUT                  AS float
	WSDATA   nFRETE                    AS float
	WSDATA   cHAWB                     AS string
	WSDATA   cHORA                     AS string
	WSDATA   nICMAUTO                  AS float
	WSDATA   nICMFRET                  AS float
	WSDATA   nICMSDIF                  AS float
	WSDATA   nICMSRET                  AS float
	WSDATA   cLOJA                     AS string
	WSDATA   cLOTE                     AS string
	WSDATA   cMAPA                     AS string
	WSDATA   nMOEDA                    AS integer
	WSDATA   cNEXTDOC                  AS string
	WSDATA   cNEXTSER                  AS string
	WSDATA   cNFCUPOM                  AS string
	WSDATA   cNFEACRS                  AS string
	WSDATA   cNFORI                    AS string
	WSDATA   cOK                       AS string
	WSDATA   cORDPAGO                  AS string
	WSDATA   nPBRUTO                   AS float
	WSDATA   cPDV                      AS string
	WSDATA   cPEDPEND                  AS string
	WSDATA   nPLIQUI                   AS float
	WSDATA   cPREFIXO                  AS string
	WSDATA   cREAJUST                  AS string
	WSDATA   cREDESP                   AS string
	WSDATA   cREGIAO                   AS string
	WSDATA   nSEGURO                   AS float
	WSDATA   cSEQCAR                   AS string
	WSDATA   cSEQENT                   AS string
	WSDATA   cSERIE                    AS string
	WSDATA   cSERIORI                  AS string
	WSDATA   cTIPO                     AS string
	WSDATA   cTIPOCLI                  AS string
	WSDATA   cTIPODOC                  AS string
	WSDATA   cTIPOREM                  AS string
	WSDATA   cTIPORET                  AS string
	WSDATA   cTRANSP                   AS string
	WSDATA   nTXMOEDA                  AS float
	WSDATA   cUSERLGA                  AS string
	WSDATA   cUSERLGI                  AS string
	WSDATA   nVALACRS                  AS float
	WSDATA   nVALBRUT                  AS float
	WSDATA   nVALCOFI                  AS float
	WSDATA   nVALCSLL                  AS float
	WSDATA   nVALFAT                   AS float
	WSDATA   nVALICM                   AS float
	WSDATA   nVALIMP1                  AS float
	WSDATA   nVALIMP2                  AS float
	WSDATA   nVALIMP3                  AS float
	WSDATA   nVALIMP4                  AS float
	WSDATA   nVALIMP5                  AS float
	WSDATA   nVALIMP6                  AS float
	WSDATA   nVALINSS                  AS float
	WSDATA   nVALIPI                   AS float
	WSDATA   nVALIRRF                  AS float
	WSDATA   nVALISS                   AS float
	WSDATA   nVALMERC                  AS float
	WSDATA   nVALPIS                   AS float
	WSDATA   nVARIAC                   AS float
	WSDATA   cVEND1                    AS string
	WSDATA   cVEND2                    AS string
	WSDATA   cVEND3                    AS string
	WSDATA   cVEND4                    AS string
	WSDATA   cVEND5                    AS string
	WSDATA   nVOLUME1                  AS integer
	WSDATA   nVOLUME2                  AS integer
	WSDATA   nVOLUME3                  AS integer
	WSDATA   nVOLUME4                  AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVVENDAS_CABECNFVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVVENDAS_CABECNFVIEW
Return

WSMETHOD CLONE WSCLIENT DVVENDAS_CABECNFVIEW
	Local oClone := DVVENDAS_CABECNFVIEW():NEW()
	oClone:nBASEICM             := ::nBASEICM
	oClone:nBASEINS             := ::nBASEINS
	oClone:nBASEIPI             := ::nBASEIPI
	oClone:nBASEISS             := ::nBASEISS
	oClone:nBASIMP1             := ::nBASIMP1
	oClone:nBASIMP2             := ::nBASIMP2
	oClone:nBASIMP3             := ::nBASIMP3
	oClone:nBASIMP4             := ::nBASIMP4
	oClone:nBASIMP5             := ::nBASIMP5
	oClone:nBASIMP6             := ::nBASIMP6
	oClone:nBRICMS              := ::nBRICMS
	oClone:cCARGA               := ::cCARGA
	oClone:cCLIENTE             := ::cCLIENTE
	oClone:cCOND                := ::cCOND
	oClone:nCONTSOC             := ::nCONTSOC
	oClone:nDESCCAB             := ::nDESCCAB
	oClone:nDESCONT             := ::nDESCONT
	oClone:nDESPESA             := ::nDESPESA
	oClone:cDOC                 := ::cDOC
	oClone:dDTBASE0             := ::dDTBASE0
	oClone:dDTBASE1             := ::dDTBASE1
	oClone:dDTDIGIT             := ::dDTDIGIT
	oClone:dDTENTR              := ::dDTENTR
	oClone:dDTLANC              := ::dDTLANC
	oClone:dDTREAJ              := ::dDTREAJ
	oClone:cDUPL                := ::cDUPL
	oClone:cECF                 := ::cECF
	oClone:dEMISSAO             := ::dEMISSAO
	oClone:cESPECI1             := ::cESPECI1
	oClone:cESPECI2             := ::cESPECI2
	oClone:cESPECI3             := ::cESPECI3
	oClone:cESPECI4             := ::cESPECI4
	oClone:cESPECIE             := ::cESPECIE
	oClone:cEST                 := ::cEST
	oClone:nFATORB0             := ::nFATORB0
	oClone:nFATORB1             := ::nFATORB1
	oClone:cFILIAL              := ::cFILIAL
	oClone:cFIMP                := ::cFIMP
	oClone:cFORMUL              := ::cFORMUL
	oClone:nFRETAUT             := ::nFRETAUT
	oClone:nFRETE               := ::nFRETE
	oClone:cHAWB                := ::cHAWB
	oClone:cHORA                := ::cHORA
	oClone:nICMAUTO             := ::nICMAUTO
	oClone:nICMFRET             := ::nICMFRET
	oClone:nICMSDIF             := ::nICMSDIF
	oClone:nICMSRET             := ::nICMSRET
	oClone:cLOJA                := ::cLOJA
	oClone:cLOTE                := ::cLOTE
	oClone:cMAPA                := ::cMAPA
	oClone:nMOEDA               := ::nMOEDA
	oClone:cNEXTDOC             := ::cNEXTDOC
	oClone:cNEXTSER             := ::cNEXTSER
	oClone:cNFCUPOM             := ::cNFCUPOM
	oClone:cNFEACRS             := ::cNFEACRS
	oClone:cNFORI               := ::cNFORI
	oClone:cOK                  := ::cOK
	oClone:cORDPAGO             := ::cORDPAGO
	oClone:nPBRUTO              := ::nPBRUTO
	oClone:cPDV                 := ::cPDV
	oClone:cPEDPEND             := ::cPEDPEND
	oClone:nPLIQUI              := ::nPLIQUI
	oClone:cPREFIXO             := ::cPREFIXO
	oClone:cREAJUST             := ::cREAJUST
	oClone:cREDESP              := ::cREDESP
	oClone:cREGIAO              := ::cREGIAO
	oClone:nSEGURO              := ::nSEGURO
	oClone:cSEQCAR              := ::cSEQCAR
	oClone:cSEQENT              := ::cSEQENT
	oClone:cSERIE               := ::cSERIE
	oClone:cSERIORI             := ::cSERIORI
	oClone:cTIPO                := ::cTIPO
	oClone:cTIPOCLI             := ::cTIPOCLI
	oClone:cTIPODOC             := ::cTIPODOC
	oClone:cTIPOREM             := ::cTIPOREM
	oClone:cTIPORET             := ::cTIPORET
	oClone:cTRANSP              := ::cTRANSP
	oClone:nTXMOEDA             := ::nTXMOEDA
	oClone:cUSERLGA             := ::cUSERLGA
	oClone:cUSERLGI             := ::cUSERLGI
	oClone:nVALACRS             := ::nVALACRS
	oClone:nVALBRUT             := ::nVALBRUT
	oClone:nVALCOFI             := ::nVALCOFI
	oClone:nVALCSLL             := ::nVALCSLL
	oClone:nVALFAT              := ::nVALFAT
	oClone:nVALICM              := ::nVALICM
	oClone:nVALIMP1             := ::nVALIMP1
	oClone:nVALIMP2             := ::nVALIMP2
	oClone:nVALIMP3             := ::nVALIMP3
	oClone:nVALIMP4             := ::nVALIMP4
	oClone:nVALIMP5             := ::nVALIMP5
	oClone:nVALIMP6             := ::nVALIMP6
	oClone:nVALINSS             := ::nVALINSS
	oClone:nVALIPI              := ::nVALIPI
	oClone:nVALIRRF             := ::nVALIRRF
	oClone:nVALISS              := ::nVALISS
	oClone:nVALMERC             := ::nVALMERC
	oClone:nVALPIS              := ::nVALPIS
	oClone:nVARIAC              := ::nVARIAC
	oClone:cVEND1               := ::cVEND1
	oClone:cVEND2               := ::cVEND2
	oClone:cVEND3               := ::cVEND3
	oClone:cVEND4               := ::cVEND4
	oClone:cVEND5               := ::cVEND5
	oClone:nVOLUME1             := ::nVOLUME1
	oClone:nVOLUME2             := ::nVOLUME2
	oClone:nVOLUME3             := ::nVOLUME3
	oClone:nVOLUME4             := ::nVOLUME4
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVVENDAS_CABECNFVIEW
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nBASEICM           :=  WSAdvValue( oResponse,"_BASEICM","float",NIL,"Property nBASEICM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEINS           :=  WSAdvValue( oResponse,"_BASEINS","float",NIL,"Property nBASEINS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEIPI           :=  WSAdvValue( oResponse,"_BASEIPI","float",NIL,"Property nBASEIPI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASEISS           :=  WSAdvValue( oResponse,"_BASEISS","float",NIL,"Property nBASEISS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP1           :=  WSAdvValue( oResponse,"_BASIMP1","float",NIL,"Property nBASIMP1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP2           :=  WSAdvValue( oResponse,"_BASIMP2","float",NIL,"Property nBASIMP2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP3           :=  WSAdvValue( oResponse,"_BASIMP3","float",NIL,"Property nBASIMP3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP4           :=  WSAdvValue( oResponse,"_BASIMP4","float",NIL,"Property nBASIMP4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP5           :=  WSAdvValue( oResponse,"_BASIMP5","float",NIL,"Property nBASIMP5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBASIMP6           :=  WSAdvValue( oResponse,"_BASIMP6","float",NIL,"Property nBASIMP6 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nBRICMS            :=  WSAdvValue( oResponse,"_BRICMS","float",NIL,"Property nBRICMS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cCARGA             :=  WSAdvValue( oResponse,"_CARGA","string",NIL,"Property cCARGA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLIENTE           :=  WSAdvValue( oResponse,"_CLIENTE","string",NIL,"Property cCLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCOND              :=  WSAdvValue( oResponse,"_COND","string",NIL,"Property cCOND as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nCONTSOC           :=  WSAdvValue( oResponse,"_CONTSOC","float",NIL,"Property nCONTSOC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESCCAB           :=  WSAdvValue( oResponse,"_DESCCAB","float",NIL,"Property nDESCCAB as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESCONT           :=  WSAdvValue( oResponse,"_DESCONT","float",NIL,"Property nDESCONT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nDESPESA           :=  WSAdvValue( oResponse,"_DESPESA","float",NIL,"Property nDESPESA as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cDOC               :=  WSAdvValue( oResponse,"_DOC","string",NIL,"Property cDOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dDTBASE0           :=  WSAdvValue( oResponse,"_DTBASE0","date",NIL,NIL,NIL,"D",NIL) 
	::dDTBASE1           :=  WSAdvValue( oResponse,"_DTBASE1","date",NIL,NIL,NIL,"D",NIL) 
	::dDTDIGIT           :=  WSAdvValue( oResponse,"_DTDIGIT","date",NIL,NIL,NIL,"D",NIL) 
	::dDTENTR            :=  WSAdvValue( oResponse,"_DTENTR","date",NIL,NIL,NIL,"D",NIL) 
	::dDTLANC            :=  WSAdvValue( oResponse,"_DTLANC","date",NIL,NIL,NIL,"D",NIL) 
	::dDTREAJ            :=  WSAdvValue( oResponse,"_DTREAJ","date",NIL,NIL,NIL,"D",NIL) 
	::cDUPL              :=  WSAdvValue( oResponse,"_DUPL","string",NIL,"Property cDUPL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cECF               :=  WSAdvValue( oResponse,"_ECF","string",NIL,"Property cECF as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dEMISSAO           :=  WSAdvValue( oResponse,"_EMISSAO","date",NIL,NIL,NIL,"D",NIL) 
	::cESPECI1           :=  WSAdvValue( oResponse,"_ESPECI1","string",NIL,"Property cESPECI1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESPECI2           :=  WSAdvValue( oResponse,"_ESPECI2","string",NIL,"Property cESPECI2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESPECI3           :=  WSAdvValue( oResponse,"_ESPECI3","string",NIL,"Property cESPECI3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESPECI4           :=  WSAdvValue( oResponse,"_ESPECI4","string",NIL,"Property cESPECI4 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESPECIE           :=  WSAdvValue( oResponse,"_ESPECIE","string",NIL,"Property cESPECIE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cEST               :=  WSAdvValue( oResponse,"_EST","string",NIL,"Property cEST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nFATORB0           :=  WSAdvValue( oResponse,"_FATORB0","float",NIL,"Property nFATORB0 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nFATORB1           :=  WSAdvValue( oResponse,"_FATORB1","float",NIL,"Property nFATORB1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFIMP              :=  WSAdvValue( oResponse,"_FIMP","string",NIL,"Property cFIMP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFORMUL            :=  WSAdvValue( oResponse,"_FORMUL","string",NIL,"Property cFORMUL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nFRETAUT           :=  WSAdvValue( oResponse,"_FRETAUT","float",NIL,"Property nFRETAUT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nFRETE             :=  WSAdvValue( oResponse,"_FRETE","float",NIL,"Property nFRETE as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cHAWB              :=  WSAdvValue( oResponse,"_HAWB","string",NIL,"Property cHAWB as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cHORA              :=  WSAdvValue( oResponse,"_HORA","string",NIL,"Property cHORA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nICMAUTO           :=  WSAdvValue( oResponse,"_ICMAUTO","float",NIL,"Property nICMAUTO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nICMFRET           :=  WSAdvValue( oResponse,"_ICMFRET","float",NIL,"Property nICMFRET as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nICMSDIF           :=  WSAdvValue( oResponse,"_ICMSDIF","float",NIL,"Property nICMSDIF as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nICMSRET           :=  WSAdvValue( oResponse,"_ICMSRET","float",NIL,"Property nICMSRET as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,"Property cLOJA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cLOTE              :=  WSAdvValue( oResponse,"_LOTE","string",NIL,"Property cLOTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMAPA              :=  WSAdvValue( oResponse,"_MAPA","string",NIL,"Property cMAPA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nMOEDA             :=  WSAdvValue( oResponse,"_MOEDA","integer",NIL,"Property nMOEDA as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cNEXTDOC           :=  WSAdvValue( oResponse,"_NEXTDOC","string",NIL,"Property cNEXTDOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNEXTSER           :=  WSAdvValue( oResponse,"_NEXTSER","string",NIL,"Property cNEXTSER as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNFCUPOM           :=  WSAdvValue( oResponse,"_NFCUPOM","string",NIL,"Property cNFCUPOM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNFEACRS           :=  WSAdvValue( oResponse,"_NFEACRS","string",NIL,"Property cNFEACRS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNFORI             :=  WSAdvValue( oResponse,"_NFORI","string",NIL,"Property cNFORI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cOK                :=  WSAdvValue( oResponse,"_OK","string",NIL,"Property cOK as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cORDPAGO           :=  WSAdvValue( oResponse,"_ORDPAGO","string",NIL,"Property cORDPAGO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPBRUTO            :=  WSAdvValue( oResponse,"_PBRUTO","float",NIL,"Property nPBRUTO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cPDV               :=  WSAdvValue( oResponse,"_PDV","string",NIL,"Property cPDV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPEDPEND           :=  WSAdvValue( oResponse,"_PEDPEND","string",NIL,"Property cPEDPEND as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPLIQUI            :=  WSAdvValue( oResponse,"_PLIQUI","float",NIL,"Property nPLIQUI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cPREFIXO           :=  WSAdvValue( oResponse,"_PREFIXO","string",NIL,"Property cPREFIXO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREAJUST           :=  WSAdvValue( oResponse,"_REAJUST","string",NIL,"Property cREAJUST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREDESP            :=  WSAdvValue( oResponse,"_REDESP","string",NIL,"Property cREDESP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREGIAO            :=  WSAdvValue( oResponse,"_REGIAO","string",NIL,"Property cREGIAO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nSEGURO            :=  WSAdvValue( oResponse,"_SEGURO","float",NIL,"Property nSEGURO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cSEQCAR            :=  WSAdvValue( oResponse,"_SEQCAR","string",NIL,"Property cSEQCAR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSEQENT            :=  WSAdvValue( oResponse,"_SEQENT","string",NIL,"Property cSEQENT as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSERIE             :=  WSAdvValue( oResponse,"_SERIE","string",NIL,"Property cSERIE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSERIORI           :=  WSAdvValue( oResponse,"_SERIORI","string",NIL,"Property cSERIORI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPO              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,"Property cTIPO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPOCLI           :=  WSAdvValue( oResponse,"_TIPOCLI","string",NIL,"Property cTIPOCLI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPODOC           :=  WSAdvValue( oResponse,"_TIPODOC","string",NIL,"Property cTIPODOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPOREM           :=  WSAdvValue( oResponse,"_TIPOREM","string",NIL,"Property cTIPOREM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPORET           :=  WSAdvValue( oResponse,"_TIPORET","string",NIL,"Property cTIPORET as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTRANSP            :=  WSAdvValue( oResponse,"_TRANSP","string",NIL,"Property cTRANSP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nTXMOEDA           :=  WSAdvValue( oResponse,"_TXMOEDA","float",NIL,"Property nTXMOEDA as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cUSERLGA           :=  WSAdvValue( oResponse,"_USERLGA","string",NIL,"Property cUSERLGA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cUSERLGI           :=  WSAdvValue( oResponse,"_USERLGI","string",NIL,"Property cUSERLGI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nVALACRS           :=  WSAdvValue( oResponse,"_VALACRS","float",NIL,"Property nVALACRS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALBRUT           :=  WSAdvValue( oResponse,"_VALBRUT","float",NIL,"Property nVALBRUT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALCOFI           :=  WSAdvValue( oResponse,"_VALCOFI","float",NIL,"Property nVALCOFI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALCSLL           :=  WSAdvValue( oResponse,"_VALCSLL","float",NIL,"Property nVALCSLL as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALFAT            :=  WSAdvValue( oResponse,"_VALFAT","float",NIL,"Property nVALFAT as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALICM            :=  WSAdvValue( oResponse,"_VALICM","float",NIL,"Property nVALICM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP1           :=  WSAdvValue( oResponse,"_VALIMP1","float",NIL,"Property nVALIMP1 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP2           :=  WSAdvValue( oResponse,"_VALIMP2","float",NIL,"Property nVALIMP2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP3           :=  WSAdvValue( oResponse,"_VALIMP3","float",NIL,"Property nVALIMP3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP4           :=  WSAdvValue( oResponse,"_VALIMP4","float",NIL,"Property nVALIMP4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP5           :=  WSAdvValue( oResponse,"_VALIMP5","float",NIL,"Property nVALIMP5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIMP6           :=  WSAdvValue( oResponse,"_VALIMP6","float",NIL,"Property nVALIMP6 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALINSS           :=  WSAdvValue( oResponse,"_VALINSS","float",NIL,"Property nVALINSS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIPI            :=  WSAdvValue( oResponse,"_VALIPI","float",NIL,"Property nVALIPI as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALIRRF           :=  WSAdvValue( oResponse,"_VALIRRF","float",NIL,"Property nVALIRRF as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALISS            :=  WSAdvValue( oResponse,"_VALISS","float",NIL,"Property nVALISS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALMERC           :=  WSAdvValue( oResponse,"_VALMERC","float",NIL,"Property nVALMERC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVALPIS            :=  WSAdvValue( oResponse,"_VALPIS","float",NIL,"Property nVALPIS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nVARIAC            :=  WSAdvValue( oResponse,"_VARIAC","float",NIL,"Property nVARIAC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cVEND1             :=  WSAdvValue( oResponse,"_VEND1","string",NIL,"Property cVEND1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND2             :=  WSAdvValue( oResponse,"_VEND2","string",NIL,"Property cVEND2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND3             :=  WSAdvValue( oResponse,"_VEND3","string",NIL,"Property cVEND3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND4             :=  WSAdvValue( oResponse,"_VEND4","string",NIL,"Property cVEND4 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND5             :=  WSAdvValue( oResponse,"_VEND5","string",NIL,"Property cVEND5 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nVOLUME1           :=  WSAdvValue( oResponse,"_VOLUME1","integer",NIL,"Property nVOLUME1 as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nVOLUME2           :=  WSAdvValue( oResponse,"_VOLUME2","integer",NIL,"Property nVOLUME2 as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nVOLUME3           :=  WSAdvValue( oResponse,"_VOLUME3","integer",NIL,"Property nVOLUME3 as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nVOLUME4           :=  WSAdvValue( oResponse,"_VOLUME4","integer",NIL,"Property nVOLUME4 as s:integer on SOAP Response not found.",NIL,"N",NIL) 
Return


