
user function tstbx()

PRIVATE lMsHelpAuto   := .F.
PRIVATE lMsErroAuto   := .F.   
PRIVATE _aRegSE5 := {}  

_cSerie := "UNI"
_cNota  := "000000"

/*
		AAdd( _aRegSE5, { "E1_PREFIXO" , SE1->E1_PREFIXO                 , NIL } )
		AAdd( _aRegSE5, { "E1_NUMERO"  , SE1->E1_NUM                     , NIL } )
		AAdd( _aRegSE5, { "E1_PARCELA" , SE1->E1_PARCELA                 , NIL } )
		AAdd( _aRegSE5, { "E1_CLIENTE" , SE1->E1_CLIENTE                 , NIL } )
		AAdd( _aRegSE5, { "E1_LOJA"    , SE1->E1_LOJA                    , NIL } )
		AAdd( _aRegSE5, { "E1_TIPO"    , SE1->E1_TIPO                    , NIL } )
*/
/*
		AAdd( _aRegSE5, { "CPREFIXO"   , "SEP"                           , NIL } )
		AAdd( _aRegSE5, { "CNUMERO"    , "000333"                        , NIL } )
		AAdd( _aRegSE5, { "CPARCELA"   , "A"                             , NIL } )
		AAdd( _aRegSE5, { "CCLIENTE"   , "000460"                        , NIL } )
		AAdd( _aRegSE5, { "CLOJA"      , "01"                            , NIL } )
		AAdd( _aRegSE5, { "CTIPO"      , "NCC"                           , NIL } )
*/

		dbselectarea("SE1")
		dbsetorder(1)
		dbseek(xfilial("SE1")+"SEP000333A00046001NCC")
		
		//RegToMemory("SE1")

//		AAdd( _aRegSE5, { "E1_PREFIXO" , "SEP"                           , NIL } )
//		AAdd( _aRegSE5, { "E1_NUM"     , "000333"                        , NIL } )
//		AAdd( _aRegSE5, { "E1_PARCELA" , "A"                             , NIL } )
//		AAdd( _aRegSE5, { "E1_TIPO"    , "NCC"                           , NIL } )
//		AAdd( _aRegSE5, { "E1_CLIENTE" , "000460"                        , NIL } )
//		AAdd( _aRegSE5, { "E1_LOJA"    , "01"                            , NIL } )

		AAdd( _aRegSE5, { "DBAIXA"     , dDataBase                       , NIL } )
		AAdd( _aRegSE5, { "DDTCREDITO" , dDataBase                       , NIL } )
		AAdd( _aRegSE5, { "NVALREC"    , 10                              , NIL } )
		AAdd( _aRegSE5, { "CBANCO"     , "SEP"                           , NIL } )
		AAdd( _aRegSE5, { "CAGENCIA"   , "00001"                         , NIL } )
		AAdd( _aRegSE5, { "CCONTA"     , "0000000001"                    , NIL } )
		AAdd( _aRegSE5, { "CHIST070"   , _cSerie+"-"+_cNota              , NIL } )
		AAdd( _aRegSE5, { "CMOTBX"     , "NOR"                           , NIL } )
		
		MsExecAuto( {|x,y| Fina070(x,y)}, _aRegSE5, 1 )
		
		//-- Verifica se houve algum erro.
		If lMsErroAuto
			MostraErro()
		EndIf
