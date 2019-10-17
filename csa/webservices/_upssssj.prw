#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.1.1.19:4080/0103/DVCLIENTE.apw?WSDL
Gerado em        08/18/05 08:52:22
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.050513
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PKRKYFP ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSDVCLIENTE
------------------------------------------------------------------------------- */

WSCLIENT WSDVCLIENTE

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD LISTACLIENTE

	WSDATA   _URL                      AS String
	WSDATA   cCODEMPRESA               AS string
	WSDATA   cCODVEND                  AS string
	WSDATA   cORDEM                    AS string
	WSDATA   cNOMECLI                  AS string
	WSDATA   nPAGEFIRST                AS integer
	WSDATA   nPAGELEN                  AS integer
	WSDATA   oWSLISTACLIENTERESULT     AS DVCLIENTE_ARRAYOFFILIALCLIVIEW

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSDVCLIENTE
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.050506P] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSDVCLIENTE
	::oWSLISTACLIENTERESULT := DVCLIENTE_ARRAYOFFILIALCLIVIEW():New()
Return

WSMETHOD RESET WSCLIENT WSDVCLIENTE
	::cCODEMPRESA        := NIL 
	::cCODVEND           := NIL 
	::cORDEM             := NIL 
	::cNOMECLI           := NIL 
	::nPAGEFIRST         := NIL 
	::nPAGELEN           := NIL 
	::oWSLISTACLIENTERESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSDVCLIENTE
Local oClone := WSDVCLIENTE():New()
	oClone:_URL          := ::_URL 
	oClone:cCODEMPRESA   := ::cCODEMPRESA
	oClone:cCODVEND      := ::cCODVEND
	oClone:cORDEM        := ::cORDEM
	oClone:cNOMECLI      := ::cNOMECLI
	oClone:nPAGEFIRST    := ::nPAGEFIRST
	oClone:nPAGELEN      := ::nPAGELEN
	oClone:oWSLISTACLIENTERESULT :=  IIF(::oWSLISTACLIENTERESULT = NIL , NIL ,::oWSLISTACLIENTERESULT:Clone() )
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method LISTACLIENTE of Service WSDVCLIENTE
------------------------------------------------------------------------------- */

WSMETHOD LISTACLIENTE WSSEND cCODEMPRESA,cCODVEND,cORDEM,cNOMECLI,nPAGEFIRST,nPAGELEN WSRECEIVE oWSLISTACLIENTERESULT WSCLIENT WSDVCLIENTE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<LISTACLIENTE xmlns="http://192.1.1.19:4080/0103/">'
cSoap += WSSoapValue("CODEMPRESA", ::cCODEMPRESA, cCODEMPRESA , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("CODVEND", ::cCODVEND, cCODVEND , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("ORDEM", ::cORDEM, cORDEM , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("NOMECLI", ::cNOMECLI, cNOMECLI , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("PAGEFIRST", ::nPAGEFIRST, nPAGEFIRST , "integer", .T. , .F., 0 ) 
cSoap += WSSoapValue("PAGELEN", ::nPAGELEN, nPAGELEN , "integer", .T. , .F., 0 ) 
cSoap += "</LISTACLIENTE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.1.1.19:4080/0103/LISTACLIENTE",; 
	"DOCUMENT","http://192.1.1.19:4080/0103/",,"1.031217",; 
	"http://192.1.1.19:4080/0103/DVCLIENTE.apw")

::Init()
::oWSLISTACLIENTERESULT:SoapRecv( WSAdvValue( oXmlRet,"_LISTACLIENTERESPONSE:_LISTACLIENTERESULT","ARRAYOFFILIALCLIVIEW",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFFILIALCLIVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVCLIENTE_ARRAYOFFILIALCLIVIEW
	WSDATA   oWSFILIALCLIVIEW          AS DVCLIENTE_FILIALCLIVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVCLIENTE_ARRAYOFFILIALCLIVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVCLIENTE_ARRAYOFFILIALCLIVIEW
	::oWSFILIALCLIVIEW     := {} // Array Of  DVCLIENTE_FILIALCLIVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVCLIENTE_ARRAYOFFILIALCLIVIEW
	Local oClone := DVCLIENTE_ARRAYOFFILIALCLIVIEW():NEW()
	oClone:oWSFILIALCLIVIEW := NIL
	If ::oWSFILIALCLIVIEW <> NIL 
		oClone:oWSFILIALCLIVIEW := {}
		aEval( ::oWSFILIALCLIVIEW , { |x| aadd( oClone:oWSFILIALCLIVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVCLIENTE_ARRAYOFFILIALCLIVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_FILIALCLIVIEW","FILIALCLIVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSFILIALCLIVIEW , DVCLIENTE_FILIALCLIVIEW():New() )
			::oWSFILIALCLIVIEW[len(::oWSFILIALCLIVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure FILIALCLIVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVCLIENTE_FILIALCLIVIEW
	WSDATA   oWSCLIENTE                AS DVCLIENTE_ARRAYOFCLIENTEVIEW
	WSDATA   cFILIAL                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVCLIENTE_FILIALCLIVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVCLIENTE_FILIALCLIVIEW
Return

WSMETHOD CLONE WSCLIENT DVCLIENTE_FILIALCLIVIEW
	Local oClone := DVCLIENTE_FILIALCLIVIEW():NEW()
	oClone:oWSCLIENTE           := IIF(::oWSCLIENTE = NIL , NIL , ::oWSCLIENTE:Clone() )
	oClone:cFILIAL              := ::cFILIAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVCLIENTE_FILIALCLIVIEW
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_CLIENTE","ARRAYOFCLIENTEVIEW",NIL,"Property oWSCLIENTE as s0:ARRAYOFCLIENTEVIEW on SOAP Response not found.",NIL,"O",NIL) 
	If oNode1 != NIL
		::oWSCLIENTE := DVCLIENTE_ARRAYOFCLIENTEVIEW():New()
		::oWSCLIENTE:SoapRecv(oNode1)
	EndIf
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFCLIENTEVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVCLIENTE_ARRAYOFCLIENTEVIEW
	WSDATA   oWSCLIENTEVIEW            AS DVCLIENTE_CLIENTEVIEW OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVCLIENTE_ARRAYOFCLIENTEVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVCLIENTE_ARRAYOFCLIENTEVIEW
	::oWSCLIENTEVIEW       := {} // Array Of  DVCLIENTE_CLIENTEVIEW():New()
Return

WSMETHOD CLONE WSCLIENT DVCLIENTE_ARRAYOFCLIENTEVIEW
	Local oClone := DVCLIENTE_ARRAYOFCLIENTEVIEW():NEW()
	oClone:oWSCLIENTEVIEW := NIL
	If ::oWSCLIENTEVIEW <> NIL 
		oClone:oWSCLIENTEVIEW := {}
		aEval( ::oWSCLIENTEVIEW , { |x| aadd( oClone:oWSCLIENTEVIEW , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVCLIENTE_ARRAYOFCLIENTEVIEW
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLIENTEVIEW","CLIENTEVIEW",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCLIENTEVIEW , DVCLIENTE_CLIENTEVIEW():New() )
			::oWSCLIENTEVIEW[len(::oWSCLIENTEVIEW)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure CLIENTEVIEW
------------------------------------------------------------------------------- */

WSSTRUCT DVCLIENTE_CLIENTEVIEW
	WSDATA   cABATIMP                  AS string
	WSDATA   cABICS                    AS string
	WSDATA   cAGEDEP                   AS string
	WSDATA   cAGREG                    AS string
	WSDATA   nALIQIR                   AS float
	WSDATA   cATIVIDA                  AS string
	WSDATA   nATR                      AS float
	WSDATA   cB2B                      AS string
	WSDATA   cBAIRRO                   AS string
	WSDATA   cBAIRROC                  AS string
	WSDATA   cBAIRROE                  AS string
	WSDATA   cBCO1                     AS string
	WSDATA   cBCO2                     AS string
	WSDATA   cBCO3                     AS string
	WSDATA   cBCO4                     AS string
	WSDATA   cBCO5                     AS string
	WSDATA   cBLEMAIL                  AS string
	WSDATA   cCALCCON                  AS string
	WSDATA   cCALCSUF                  AS string
	WSDATA   cCARGO1                   AS string
	WSDATA   cCARGO2                   AS string
	WSDATA   cCARGO3                   AS string
	WSDATA   cCDRDES                   AS string
	WSDATA   cCEP                      AS string
	WSDATA   cCEPC                     AS string
	WSDATA   cCEPE                     AS string
	WSDATA   cCGC                      AS string
	WSDATA   nCHQDEVO                  AS integer
	WSDATA   cCLASSE                   AS string
	WSDATA   cCLASVEN                  AS string
	WSDATA   cCLICNV                   AS string
	WSDATA   cCLIFAT                   AS string
	WSDATA   cCOD                      AS string
	WSDATA   cCOD_MUN                  AS string
	WSDATA   cCODAGE                   AS string
	WSDATA   cCODFOR                   AS string
	WSDATA   cCODHIST                  AS string
	WSDATA   cCODLOC                   AS string
	WSDATA   cCODMARC                  AS string
	WSDATA   cCODMUN                   AS string
	WSDATA   nCODPAIS                  AS integer
	WSDATA   nCOMAGE                   AS float
	WSDATA   nCOMIS                    AS float
	WSDATA   nCOMIS2                   AS float
	WSDATA   nCOMIS3                   AS float
	WSDATA   nCOMIS4                   AS float
	WSDATA   nCOMIS5                   AS float
	WSDATA   cCOND                     AS string
	WSDATA   cCONDPAG                  AS string
	WSDATA   cCONTA                    AS string
	WSDATA   cCONTAB                   AS string
	WSDATA   cCONTATO                  AS string
	WSDATA   cCXPOSTA                  AS string
	WSDATA   cDDD                      AS string
	WSDATA   cDDI                      AS string
	WSDATA   nDESC                     AS integer
	WSDATA   cDEST_1                   AS string
	WSDATA   cDEST_2                   AS string
	WSDATA   cDEST_3                   AS string
	WSDATA   nDIASPAG                  AS integer
	WSDATA   dDTNASC                   AS date OPTIONAL
	WSDATA   dDTULCHQ                  AS date OPTIONAL
	WSDATA   dDTULTIT                  AS date OPTIONAL
	WSDATA   cEMAIL                    AS string
	WSDATA   cENDCOB                   AS string
	WSDATA   cENDE                     AS string
	WSDATA   cENDENT                   AS string
	WSDATA   cENDREC                   AS string
	WSDATA   cEST                      AS string
	WSDATA   cESTADO                   AS string
	WSDATA   cESTC                     AS string
	WSDATA   cESTE                     AS string
	WSDATA   cFAX                      AS string
	WSDATA   cFILDEB                   AS string
	WSDATA   cFILIAL                   AS string
	WSDATA   cFORMVIS                  AS string
	WSDATA   cGRPTRIB                  AS string
	WSDATA   cGRPVEN                   AS string
	WSDATA   cHPAGE                    AS string
	WSDATA   cIBGE                     AS string
	WSDATA   cINCISS                   AS string
	WSDATA   cINSCR                    AS string
	WSDATA   cINSCRM                   AS string
	WSDATA   cINSCRUR                  AS string
	WSDATA   nLC                       AS float
	WSDATA   nLCFIN                    AS float
	WSDATA   cLOJA                     AS string
	WSDATA   nMAIDUPL                  AS float
	WSDATA   nMATR                     AS integer
	WSDATA   nMCOMPRA                  AS float
	WSDATA   cMENSAGE                  AS string
	WSDATA   nMETR                     AS float
	WSDATA   nMOEDALC                  AS integer
	WSDATA   nMSALDO                   AS float
	WSDATA   cMSBLQL                   AS string
	WSDATA   cMSFIL                    AS string
	WSDATA   cMUN                      AS string
	WSDATA   cMUNC                     AS string
	WSDATA   cMUNE                     AS string
	WSDATA   cNATUREZ                  AS string
	WSDATA   cNOME                     AS string
	WSDATA   cNREDUZ                   AS string
	WSDATA   nNROCOM                   AS integer
	WSDATA   nNROPAG                   AS integer
	WSDATA   cNUMRA                    AS string
	WSDATA   cOBS                      AS string
	WSDATA   cOBSERV                   AS string
	WSDATA   nPAGATR                   AS float
	WSDATA   cPAIS                     AS string
	WSDATA   cPESSOA                   AS string
	WSDATA   cPFISICA                  AS string
	WSDATA   nPONTOS                   AS float
	WSDATA   dPRICOM                   AS date OPTIONAL
	WSDATA   cPRIOR                    AS string
	WSDATA   cRECCOFI                  AS string
	WSDATA   cRECCSLL                  AS string
	WSDATA   cRECINSS                  AS string
	WSDATA   cRECISS                   AS string
	WSDATA   cRECPIS                   AS string
	WSDATA   cREGIAO                   AS string
	WSDATA   cRG                       AS string
	WSDATA   cRISCO                    AS string
	WSDATA   cRTEC                     AS string
	WSDATA   nSALDUP                   AS float
	WSDATA   nSALDUPM                  AS float
	WSDATA   nSALFIN                   AS float
	WSDATA   nSALFINM                  AS float
	WSDATA   nSALPED                   AS float
	WSDATA   nSALPEDB                  AS float
	WSDATA   nSALPEDL                  AS float
	WSDATA   cSATIV1                   AS string
	WSDATA   cSATIV2                   AS string
	WSDATA   cSATIV3                   AS string
	WSDATA   cSATIV4                   AS string
	WSDATA   cSATIV5                   AS string
	WSDATA   cSATIV6                   AS string
	WSDATA   cSATIV7                   AS string
	WSDATA   cSATIV8                   AS string
	WSDATA   cSEG                      AS string
	WSDATA   cSITUA                    AS string
	WSDATA   cSUBCOD                   AS string
	WSDATA   cSUFRAMA                  AS string
	WSDATA   cSUPERR                   AS string
	WSDATA   cTABELA                   AS string
	WSDATA   cTEL                      AS string
	WSDATA   cTELEX                    AS string
	WSDATA   nTEMVIS                   AS integer
	WSDATA   cTIPCLI                   AS string
	WSDATA   cTIPO                     AS string
	WSDATA   cTIPOCLI                  AS string
	WSDATA   cTIPPER                   AS string
	WSDATA   nTITPROT                  AS integer
	WSDATA   cTMPSTD                   AS string
	WSDATA   cTMPVIS                   AS string
	WSDATA   cTPESSOA                  AS string
	WSDATA   cTPFRET                   AS string
	WSDATA   cTRANSF                   AS string
	WSDATA   cTRANSP                   AS string
	WSDATA   dULTCOM                   AS date OPTIONAL
	WSDATA   dULTVIS                   AS date OPTIONAL
	WSDATA   cUSERLGA                  AS string
	WSDATA   cUSERLGI                  AS string
	WSDATA   nVACUM                    AS float
	WSDATA   dVENCLC                   AS date OPTIONAL
	WSDATA   cVEND                     AS string
	WSDATA   cVEND2                    AS string
	WSDATA   cVEND3                    AS string
	WSDATA   cVEND4                    AS string
	WSDATA   cVEND5                    AS string
	WSDATA   cX_CONTA                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DVCLIENTE_CLIENTEVIEW
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DVCLIENTE_CLIENTEVIEW
Return

WSMETHOD CLONE WSCLIENT DVCLIENTE_CLIENTEVIEW
	Local oClone := DVCLIENTE_CLIENTEVIEW():NEW()
	oClone:cABATIMP             := ::cABATIMP
	oClone:cABICS               := ::cABICS
	oClone:cAGEDEP              := ::cAGEDEP
	oClone:cAGREG               := ::cAGREG
	oClone:nALIQIR              := ::nALIQIR
	oClone:cATIVIDA             := ::cATIVIDA
	oClone:nATR                 := ::nATR
	oClone:cB2B                 := ::cB2B
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cBAIRROC             := ::cBAIRROC
	oClone:cBAIRROE             := ::cBAIRROE
	oClone:cBCO1                := ::cBCO1
	oClone:cBCO2                := ::cBCO2
	oClone:cBCO3                := ::cBCO3
	oClone:cBCO4                := ::cBCO4
	oClone:cBCO5                := ::cBCO5
	oClone:cBLEMAIL             := ::cBLEMAIL
	oClone:cCALCCON             := ::cCALCCON
	oClone:cCALCSUF             := ::cCALCSUF
	oClone:cCARGO1              := ::cCARGO1
	oClone:cCARGO2              := ::cCARGO2
	oClone:cCARGO3              := ::cCARGO3
	oClone:cCDRDES              := ::cCDRDES
	oClone:cCEP                 := ::cCEP
	oClone:cCEPC                := ::cCEPC
	oClone:cCEPE                := ::cCEPE
	oClone:cCGC                 := ::cCGC
	oClone:nCHQDEVO             := ::nCHQDEVO
	oClone:cCLASSE              := ::cCLASSE
	oClone:cCLASVEN             := ::cCLASVEN
	oClone:cCLICNV              := ::cCLICNV
	oClone:cCLIFAT              := ::cCLIFAT
	oClone:cCOD                 := ::cCOD
	oClone:cCOD_MUN             := ::cCOD_MUN
	oClone:cCODAGE              := ::cCODAGE
	oClone:cCODFOR              := ::cCODFOR
	oClone:cCODHIST             := ::cCODHIST
	oClone:cCODLOC              := ::cCODLOC
	oClone:cCODMARC             := ::cCODMARC
	oClone:cCODMUN              := ::cCODMUN
	oClone:nCODPAIS             := ::nCODPAIS
	oClone:nCOMAGE              := ::nCOMAGE
	oClone:nCOMIS               := ::nCOMIS
	oClone:nCOMIS2              := ::nCOMIS2
	oClone:nCOMIS3              := ::nCOMIS3
	oClone:nCOMIS4              := ::nCOMIS4
	oClone:nCOMIS5              := ::nCOMIS5
	oClone:cCOND                := ::cCOND
	oClone:cCONDPAG             := ::cCONDPAG
	oClone:cCONTA               := ::cCONTA
	oClone:cCONTAB              := ::cCONTAB
	oClone:cCONTATO             := ::cCONTATO
	oClone:cCXPOSTA             := ::cCXPOSTA
	oClone:cDDD                 := ::cDDD
	oClone:cDDI                 := ::cDDI
	oClone:nDESC                := ::nDESC
	oClone:cDEST_1              := ::cDEST_1
	oClone:cDEST_2              := ::cDEST_2
	oClone:cDEST_3              := ::cDEST_3
	oClone:nDIASPAG             := ::nDIASPAG
	oClone:dDTNASC              := ::dDTNASC
	oClone:dDTULCHQ             := ::dDTULCHQ
	oClone:dDTULTIT             := ::dDTULTIT
	oClone:cEMAIL               := ::cEMAIL
	oClone:cENDCOB              := ::cENDCOB
	oClone:cENDE                := ::cENDE
	oClone:cENDENT              := ::cENDENT
	oClone:cENDREC              := ::cENDREC
	oClone:cEST                 := ::cEST
	oClone:cESTADO              := ::cESTADO
	oClone:cESTC                := ::cESTC
	oClone:cESTE                := ::cESTE
	oClone:cFAX                 := ::cFAX
	oClone:cFILDEB              := ::cFILDEB
	oClone:cFILIAL              := ::cFILIAL
	oClone:cFORMVIS             := ::cFORMVIS
	oClone:cGRPTRIB             := ::cGRPTRIB
	oClone:cGRPVEN              := ::cGRPVEN
	oClone:cHPAGE               := ::cHPAGE
	oClone:cIBGE                := ::cIBGE
	oClone:cINCISS              := ::cINCISS
	oClone:cINSCR               := ::cINSCR
	oClone:cINSCRM              := ::cINSCRM
	oClone:cINSCRUR             := ::cINSCRUR
	oClone:nLC                  := ::nLC
	oClone:nLCFIN               := ::nLCFIN
	oClone:cLOJA                := ::cLOJA
	oClone:nMAIDUPL             := ::nMAIDUPL
	oClone:nMATR                := ::nMATR
	oClone:nMCOMPRA             := ::nMCOMPRA
	oClone:cMENSAGE             := ::cMENSAGE
	oClone:nMETR                := ::nMETR
	oClone:nMOEDALC             := ::nMOEDALC
	oClone:nMSALDO              := ::nMSALDO
	oClone:cMSBLQL              := ::cMSBLQL
	oClone:cMSFIL               := ::cMSFIL
	oClone:cMUN                 := ::cMUN
	oClone:cMUNC                := ::cMUNC
	oClone:cMUNE                := ::cMUNE
	oClone:cNATUREZ             := ::cNATUREZ
	oClone:cNOME                := ::cNOME
	oClone:cNREDUZ              := ::cNREDUZ
	oClone:nNROCOM              := ::nNROCOM
	oClone:nNROPAG              := ::nNROPAG
	oClone:cNUMRA               := ::cNUMRA
	oClone:cOBS                 := ::cOBS
	oClone:cOBSERV              := ::cOBSERV
	oClone:nPAGATR              := ::nPAGATR
	oClone:cPAIS                := ::cPAIS
	oClone:cPESSOA              := ::cPESSOA
	oClone:cPFISICA             := ::cPFISICA
	oClone:nPONTOS              := ::nPONTOS
	oClone:dPRICOM              := ::dPRICOM
	oClone:cPRIOR               := ::cPRIOR
	oClone:cRECCOFI             := ::cRECCOFI
	oClone:cRECCSLL             := ::cRECCSLL
	oClone:cRECINSS             := ::cRECINSS
	oClone:cRECISS              := ::cRECISS
	oClone:cRECPIS              := ::cRECPIS
	oClone:cREGIAO              := ::cREGIAO
	oClone:cRG                  := ::cRG
	oClone:cRISCO               := ::cRISCO
	oClone:cRTEC                := ::cRTEC
	oClone:nSALDUP              := ::nSALDUP
	oClone:nSALDUPM             := ::nSALDUPM
	oClone:nSALFIN              := ::nSALFIN
	oClone:nSALFINM             := ::nSALFINM
	oClone:nSALPED              := ::nSALPED
	oClone:nSALPEDB             := ::nSALPEDB
	oClone:nSALPEDL             := ::nSALPEDL
	oClone:cSATIV1              := ::cSATIV1
	oClone:cSATIV2              := ::cSATIV2
	oClone:cSATIV3              := ::cSATIV3
	oClone:cSATIV4              := ::cSATIV4
	oClone:cSATIV5              := ::cSATIV5
	oClone:cSATIV6              := ::cSATIV6
	oClone:cSATIV7              := ::cSATIV7
	oClone:cSATIV8              := ::cSATIV8
	oClone:cSEG                 := ::cSEG
	oClone:cSITUA               := ::cSITUA
	oClone:cSUBCOD              := ::cSUBCOD
	oClone:cSUFRAMA             := ::cSUFRAMA
	oClone:cSUPERR              := ::cSUPERR
	oClone:cTABELA              := ::cTABELA
	oClone:cTEL                 := ::cTEL
	oClone:cTELEX               := ::cTELEX
	oClone:nTEMVIS              := ::nTEMVIS
	oClone:cTIPCLI              := ::cTIPCLI
	oClone:cTIPO                := ::cTIPO
	oClone:cTIPOCLI             := ::cTIPOCLI
	oClone:cTIPPER              := ::cTIPPER
	oClone:nTITPROT             := ::nTITPROT
	oClone:cTMPSTD              := ::cTMPSTD
	oClone:cTMPVIS              := ::cTMPVIS
	oClone:cTPESSOA             := ::cTPESSOA
	oClone:cTPFRET              := ::cTPFRET
	oClone:cTRANSF              := ::cTRANSF
	oClone:cTRANSP              := ::cTRANSP
	oClone:dULTCOM              := ::dULTCOM
	oClone:dULTVIS              := ::dULTVIS
	oClone:cUSERLGA             := ::cUSERLGA
	oClone:cUSERLGI             := ::cUSERLGI
	oClone:nVACUM               := ::nVACUM
	oClone:dVENCLC              := ::dVENCLC
	oClone:cVEND                := ::cVEND
	oClone:cVEND2               := ::cVEND2
	oClone:cVEND3               := ::cVEND3
	oClone:cVEND4               := ::cVEND4
	oClone:cVEND5               := ::cVEND5
	oClone:cX_CONTA             := ::cX_CONTA
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DVCLIENTE_CLIENTEVIEW
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cABATIMP           :=  WSAdvValue( oResponse,"_ABATIMP","string",NIL,"Property cABATIMP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cABICS             :=  WSAdvValue( oResponse,"_ABICS","string",NIL,"Property cABICS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cAGEDEP            :=  WSAdvValue( oResponse,"_AGEDEP","string",NIL,"Property cAGEDEP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cAGREG             :=  WSAdvValue( oResponse,"_AGREG","string",NIL,"Property cAGREG as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nALIQIR            :=  WSAdvValue( oResponse,"_ALIQIR","float",NIL,"Property nALIQIR as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cATIVIDA           :=  WSAdvValue( oResponse,"_ATIVIDA","string",NIL,"Property cATIVIDA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nATR               :=  WSAdvValue( oResponse,"_ATR","float",NIL,"Property nATR as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cB2B               :=  WSAdvValue( oResponse,"_B2B","string",NIL,"Property cB2B as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBAIRRO            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,"Property cBAIRRO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBAIRROC           :=  WSAdvValue( oResponse,"_BAIRROC","string",NIL,"Property cBAIRROC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBAIRROE           :=  WSAdvValue( oResponse,"_BAIRROE","string",NIL,"Property cBAIRROE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBCO1              :=  WSAdvValue( oResponse,"_BCO1","string",NIL,"Property cBCO1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBCO2              :=  WSAdvValue( oResponse,"_BCO2","string",NIL,"Property cBCO2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBCO3              :=  WSAdvValue( oResponse,"_BCO3","string",NIL,"Property cBCO3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBCO4              :=  WSAdvValue( oResponse,"_BCO4","string",NIL,"Property cBCO4 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBCO5              :=  WSAdvValue( oResponse,"_BCO5","string",NIL,"Property cBCO5 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cBLEMAIL           :=  WSAdvValue( oResponse,"_BLEMAIL","string",NIL,"Property cBLEMAIL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCALCCON           :=  WSAdvValue( oResponse,"_CALCCON","string",NIL,"Property cCALCCON as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCALCSUF           :=  WSAdvValue( oResponse,"_CALCSUF","string",NIL,"Property cCALCSUF as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCARGO1            :=  WSAdvValue( oResponse,"_CARGO1","string",NIL,"Property cCARGO1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCARGO2            :=  WSAdvValue( oResponse,"_CARGO2","string",NIL,"Property cCARGO2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCARGO3            :=  WSAdvValue( oResponse,"_CARGO3","string",NIL,"Property cCARGO3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCDRDES            :=  WSAdvValue( oResponse,"_CDRDES","string",NIL,"Property cCDRDES as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,"Property cCEP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCEPC              :=  WSAdvValue( oResponse,"_CEPC","string",NIL,"Property cCEPC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCEPE              :=  WSAdvValue( oResponse,"_CEPE","string",NIL,"Property cCEPE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCGC               :=  WSAdvValue( oResponse,"_CGC","string",NIL,"Property cCGC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nCHQDEVO           :=  WSAdvValue( oResponse,"_CHQDEVO","integer",NIL,"Property nCHQDEVO as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cCLASSE            :=  WSAdvValue( oResponse,"_CLASSE","string",NIL,"Property cCLASSE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLASVEN           :=  WSAdvValue( oResponse,"_CLASVEN","string",NIL,"Property cCLASVEN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLICNV            :=  WSAdvValue( oResponse,"_CLICNV","string",NIL,"Property cCLICNV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCLIFAT            :=  WSAdvValue( oResponse,"_CLIFAT","string",NIL,"Property cCLIFAT as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCOD               :=  WSAdvValue( oResponse,"_COD","string",NIL,"Property cCOD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCOD_MUN           :=  WSAdvValue( oResponse,"_COD_MUN","string",NIL,"Property cCOD_MUN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODAGE            :=  WSAdvValue( oResponse,"_CODAGE","string",NIL,"Property cCODAGE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODFOR            :=  WSAdvValue( oResponse,"_CODFOR","string",NIL,"Property cCODFOR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODHIST           :=  WSAdvValue( oResponse,"_CODHIST","string",NIL,"Property cCODHIST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODLOC            :=  WSAdvValue( oResponse,"_CODLOC","string",NIL,"Property cCODLOC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODMARC           :=  WSAdvValue( oResponse,"_CODMARC","string",NIL,"Property cCODMARC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODMUN            :=  WSAdvValue( oResponse,"_CODMUN","string",NIL,"Property cCODMUN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nCODPAIS           :=  WSAdvValue( oResponse,"_CODPAIS","integer",NIL,"Property nCODPAIS as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMAGE            :=  WSAdvValue( oResponse,"_COMAGE","float",NIL,"Property nCOMAGE as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS             :=  WSAdvValue( oResponse,"_COMIS","float",NIL,"Property nCOMIS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS2            :=  WSAdvValue( oResponse,"_COMIS2","float",NIL,"Property nCOMIS2 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS3            :=  WSAdvValue( oResponse,"_COMIS3","float",NIL,"Property nCOMIS3 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS4            :=  WSAdvValue( oResponse,"_COMIS4","float",NIL,"Property nCOMIS4 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nCOMIS5            :=  WSAdvValue( oResponse,"_COMIS5","float",NIL,"Property nCOMIS5 as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cCOND              :=  WSAdvValue( oResponse,"_COND","string",NIL,"Property cCOND as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCONDPAG           :=  WSAdvValue( oResponse,"_CONDPAG","string",NIL,"Property cCONDPAG as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCONTA             :=  WSAdvValue( oResponse,"_CONTA","string",NIL,"Property cCONTA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCONTAB            :=  WSAdvValue( oResponse,"_CONTAB","string",NIL,"Property cCONTAB as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCONTATO           :=  WSAdvValue( oResponse,"_CONTATO","string",NIL,"Property cCONTATO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCXPOSTA           :=  WSAdvValue( oResponse,"_CXPOSTA","string",NIL,"Property cCXPOSTA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDDD               :=  WSAdvValue( oResponse,"_DDD","string",NIL,"Property cDDD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDDI               :=  WSAdvValue( oResponse,"_DDI","string",NIL,"Property cDDI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nDESC              :=  WSAdvValue( oResponse,"_DESC","integer",NIL,"Property nDESC as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cDEST_1            :=  WSAdvValue( oResponse,"_DEST_1","string",NIL,"Property cDEST_1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDEST_2            :=  WSAdvValue( oResponse,"_DEST_2","string",NIL,"Property cDEST_2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cDEST_3            :=  WSAdvValue( oResponse,"_DEST_3","string",NIL,"Property cDEST_3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nDIASPAG           :=  WSAdvValue( oResponse,"_DIASPAG","integer",NIL,"Property nDIASPAG as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::dDTNASC            :=  WSAdvValue( oResponse,"_DTNASC","date",NIL,NIL,NIL,"D",NIL) 
	::dDTULCHQ           :=  WSAdvValue( oResponse,"_DTULCHQ","date",NIL,NIL,NIL,"D",NIL) 
	::dDTULTIT           :=  WSAdvValue( oResponse,"_DTULTIT","date",NIL,NIL,NIL,"D",NIL) 
	::cEMAIL             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,"Property cEMAIL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cENDCOB            :=  WSAdvValue( oResponse,"_ENDCOB","string",NIL,"Property cENDCOB as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cENDE              :=  WSAdvValue( oResponse,"_ENDE","string",NIL,"Property cENDE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cENDENT            :=  WSAdvValue( oResponse,"_ENDENT","string",NIL,"Property cENDENT as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cENDREC            :=  WSAdvValue( oResponse,"_ENDREC","string",NIL,"Property cENDREC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cEST               :=  WSAdvValue( oResponse,"_EST","string",NIL,"Property cEST as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESTADO            :=  WSAdvValue( oResponse,"_ESTADO","string",NIL,"Property cESTADO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESTC              :=  WSAdvValue( oResponse,"_ESTC","string",NIL,"Property cESTC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cESTE              :=  WSAdvValue( oResponse,"_ESTE","string",NIL,"Property cESTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFAX               :=  WSAdvValue( oResponse,"_FAX","string",NIL,"Property cFAX as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFILDEB            :=  WSAdvValue( oResponse,"_FILDEB","string",NIL,"Property cFILDEB as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,"Property cFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cFORMVIS           :=  WSAdvValue( oResponse,"_FORMVIS","string",NIL,"Property cFORMVIS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cGRPTRIB           :=  WSAdvValue( oResponse,"_GRPTRIB","string",NIL,"Property cGRPTRIB as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cGRPVEN            :=  WSAdvValue( oResponse,"_GRPVEN","string",NIL,"Property cGRPVEN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cHPAGE             :=  WSAdvValue( oResponse,"_HPAGE","string",NIL,"Property cHPAGE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cIBGE              :=  WSAdvValue( oResponse,"_IBGE","string",NIL,"Property cIBGE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cINCISS            :=  WSAdvValue( oResponse,"_INCISS","string",NIL,"Property cINCISS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cINSCR             :=  WSAdvValue( oResponse,"_INSCR","string",NIL,"Property cINSCR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cINSCRM            :=  WSAdvValue( oResponse,"_INSCRM","string",NIL,"Property cINSCRM as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cINSCRUR           :=  WSAdvValue( oResponse,"_INSCRUR","string",NIL,"Property cINSCRUR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nLC                :=  WSAdvValue( oResponse,"_LC","float",NIL,"Property nLC as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nLCFIN             :=  WSAdvValue( oResponse,"_LCFIN","float",NIL,"Property nLCFIN as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,"Property cLOJA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nMAIDUPL           :=  WSAdvValue( oResponse,"_MAIDUPL","float",NIL,"Property nMAIDUPL as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nMATR              :=  WSAdvValue( oResponse,"_MATR","integer",NIL,"Property nMATR as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nMCOMPRA           :=  WSAdvValue( oResponse,"_MCOMPRA","float",NIL,"Property nMCOMPRA as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cMENSAGE           :=  WSAdvValue( oResponse,"_MENSAGE","string",NIL,"Property cMENSAGE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nMETR              :=  WSAdvValue( oResponse,"_METR","float",NIL,"Property nMETR as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nMOEDALC           :=  WSAdvValue( oResponse,"_MOEDALC","integer",NIL,"Property nMOEDALC as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nMSALDO            :=  WSAdvValue( oResponse,"_MSALDO","float",NIL,"Property nMSALDO as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cMSBLQL            :=  WSAdvValue( oResponse,"_MSBLQL","string",NIL,"Property cMSBLQL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMSFIL             :=  WSAdvValue( oResponse,"_MSFIL","string",NIL,"Property cMSFIL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMUN               :=  WSAdvValue( oResponse,"_MUN","string",NIL,"Property cMUN as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMUNC              :=  WSAdvValue( oResponse,"_MUNC","string",NIL,"Property cMUNC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMUNE              :=  WSAdvValue( oResponse,"_MUNE","string",NIL,"Property cMUNE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNATUREZ           :=  WSAdvValue( oResponse,"_NATUREZ","string",NIL,"Property cNATUREZ as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cNREDUZ            :=  WSAdvValue( oResponse,"_NREDUZ","string",NIL,"Property cNREDUZ as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nNROCOM            :=  WSAdvValue( oResponse,"_NROCOM","integer",NIL,"Property nNROCOM as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::nNROPAG            :=  WSAdvValue( oResponse,"_NROPAG","integer",NIL,"Property nNROPAG as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cNUMRA             :=  WSAdvValue( oResponse,"_NUMRA","string",NIL,"Property cNUMRA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cOBS               :=  WSAdvValue( oResponse,"_OBS","string",NIL,"Property cOBS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cOBSERV            :=  WSAdvValue( oResponse,"_OBSERV","string",NIL,"Property cOBSERV as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPAGATR            :=  WSAdvValue( oResponse,"_PAGATR","float",NIL,"Property nPAGATR as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cPAIS              :=  WSAdvValue( oResponse,"_PAIS","string",NIL,"Property cPAIS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPESSOA            :=  WSAdvValue( oResponse,"_PESSOA","string",NIL,"Property cPESSOA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cPFISICA           :=  WSAdvValue( oResponse,"_PFISICA","string",NIL,"Property cPFISICA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nPONTOS            :=  WSAdvValue( oResponse,"_PONTOS","float",NIL,"Property nPONTOS as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::dPRICOM            :=  WSAdvValue( oResponse,"_PRICOM","date",NIL,NIL,NIL,"D",NIL) 
	::cPRIOR             :=  WSAdvValue( oResponse,"_PRIOR","string",NIL,"Property cPRIOR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cRECCOFI           :=  WSAdvValue( oResponse,"_RECCOFI","string",NIL,"Property cRECCOFI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cRECCSLL           :=  WSAdvValue( oResponse,"_RECCSLL","string",NIL,"Property cRECCSLL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cRECINSS           :=  WSAdvValue( oResponse,"_RECINSS","string",NIL,"Property cRECINSS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cRECISS            :=  WSAdvValue( oResponse,"_RECISS","string",NIL,"Property cRECISS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cRECPIS            :=  WSAdvValue( oResponse,"_RECPIS","string",NIL,"Property cRECPIS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cREGIAO            :=  WSAdvValue( oResponse,"_REGIAO","string",NIL,"Property cREGIAO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cRG                :=  WSAdvValue( oResponse,"_RG","string",NIL,"Property cRG as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cRISCO             :=  WSAdvValue( oResponse,"_RISCO","string",NIL,"Property cRISCO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cRTEC              :=  WSAdvValue( oResponse,"_RTEC","string",NIL,"Property cRTEC as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nSALDUP            :=  WSAdvValue( oResponse,"_SALDUP","float",NIL,"Property nSALDUP as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nSALDUPM           :=  WSAdvValue( oResponse,"_SALDUPM","float",NIL,"Property nSALDUPM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nSALFIN            :=  WSAdvValue( oResponse,"_SALFIN","float",NIL,"Property nSALFIN as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nSALFINM           :=  WSAdvValue( oResponse,"_SALFINM","float",NIL,"Property nSALFINM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nSALPED            :=  WSAdvValue( oResponse,"_SALPED","float",NIL,"Property nSALPED as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nSALPEDB           :=  WSAdvValue( oResponse,"_SALPEDB","float",NIL,"Property nSALPEDB as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::nSALPEDL           :=  WSAdvValue( oResponse,"_SALPEDL","float",NIL,"Property nSALPEDL as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::cSATIV1            :=  WSAdvValue( oResponse,"_SATIV1","string",NIL,"Property cSATIV1 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV2            :=  WSAdvValue( oResponse,"_SATIV2","string",NIL,"Property cSATIV2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV3            :=  WSAdvValue( oResponse,"_SATIV3","string",NIL,"Property cSATIV3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV4            :=  WSAdvValue( oResponse,"_SATIV4","string",NIL,"Property cSATIV4 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV5            :=  WSAdvValue( oResponse,"_SATIV5","string",NIL,"Property cSATIV5 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV6            :=  WSAdvValue( oResponse,"_SATIV6","string",NIL,"Property cSATIV6 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV7            :=  WSAdvValue( oResponse,"_SATIV7","string",NIL,"Property cSATIV7 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSATIV8            :=  WSAdvValue( oResponse,"_SATIV8","string",NIL,"Property cSATIV8 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSEG               :=  WSAdvValue( oResponse,"_SEG","string",NIL,"Property cSEG as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSITUA             :=  WSAdvValue( oResponse,"_SITUA","string",NIL,"Property cSITUA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSUBCOD            :=  WSAdvValue( oResponse,"_SUBCOD","string",NIL,"Property cSUBCOD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSUFRAMA           :=  WSAdvValue( oResponse,"_SUFRAMA","string",NIL,"Property cSUFRAMA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cSUPERR            :=  WSAdvValue( oResponse,"_SUPERR","string",NIL,"Property cSUPERR as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTABELA            :=  WSAdvValue( oResponse,"_TABELA","string",NIL,"Property cTABELA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTEL               :=  WSAdvValue( oResponse,"_TEL","string",NIL,"Property cTEL as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTELEX             :=  WSAdvValue( oResponse,"_TELEX","string",NIL,"Property cTELEX as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nTEMVIS            :=  WSAdvValue( oResponse,"_TEMVIS","integer",NIL,"Property nTEMVIS as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cTIPCLI            :=  WSAdvValue( oResponse,"_TIPCLI","string",NIL,"Property cTIPCLI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPO              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,"Property cTIPO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPOCLI           :=  WSAdvValue( oResponse,"_TIPOCLI","string",NIL,"Property cTIPOCLI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTIPPER            :=  WSAdvValue( oResponse,"_TIPPER","string",NIL,"Property cTIPPER as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nTITPROT           :=  WSAdvValue( oResponse,"_TITPROT","integer",NIL,"Property nTITPROT as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cTMPSTD            :=  WSAdvValue( oResponse,"_TMPSTD","string",NIL,"Property cTMPSTD as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTMPVIS            :=  WSAdvValue( oResponse,"_TMPVIS","string",NIL,"Property cTMPVIS as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTPESSOA           :=  WSAdvValue( oResponse,"_TPESSOA","string",NIL,"Property cTPESSOA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTPFRET            :=  WSAdvValue( oResponse,"_TPFRET","string",NIL,"Property cTPFRET as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTRANSF            :=  WSAdvValue( oResponse,"_TRANSF","string",NIL,"Property cTRANSF as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTRANSP            :=  WSAdvValue( oResponse,"_TRANSP","string",NIL,"Property cTRANSP as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::dULTCOM            :=  WSAdvValue( oResponse,"_ULTCOM","date",NIL,NIL,NIL,"D",NIL) 
	::dULTVIS            :=  WSAdvValue( oResponse,"_ULTVIS","date",NIL,NIL,NIL,"D",NIL) 
	::cUSERLGA           :=  WSAdvValue( oResponse,"_USERLGA","string",NIL,"Property cUSERLGA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cUSERLGI           :=  WSAdvValue( oResponse,"_USERLGI","string",NIL,"Property cUSERLGI as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nVACUM             :=  WSAdvValue( oResponse,"_VACUM","float",NIL,"Property nVACUM as s:float on SOAP Response not found.",NIL,"N",NIL) 
	::dVENCLC            :=  WSAdvValue( oResponse,"_VENCLC","date",NIL,NIL,NIL,"D",NIL) 
	::cVEND              :=  WSAdvValue( oResponse,"_VEND","string",NIL,"Property cVEND as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND2             :=  WSAdvValue( oResponse,"_VEND2","string",NIL,"Property cVEND2 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND3             :=  WSAdvValue( oResponse,"_VEND3","string",NIL,"Property cVEND3 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND4             :=  WSAdvValue( oResponse,"_VEND4","string",NIL,"Property cVEND4 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cVEND5             :=  WSAdvValue( oResponse,"_VEND5","string",NIL,"Property cVEND5 as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cX_CONTA           :=  WSAdvValue( oResponse,"_X_CONTA","string",NIL,"Property cX_CONTA as s:string on SOAP Response not found.",NIL,"S",NIL) 
Return


