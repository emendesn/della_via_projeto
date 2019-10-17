
user function tstse1()

PRIVATE lMsHelpAuto   := .F.
PRIVATE lMsErroAuto   := .F.   
PRIVATE _aReg         := {}  

AAdd( _aReg, { "E1_FILIAL"  , xFilial("SE1")                  , NIL } )
AAdd( _aReg, { "E1_PREFIXO" , "SEP"                           , NIL } )
AAdd( _aReg, { "E1_NUM"     , "100000"                        , NIL } )
AAdd( _aReg, { "E1_PARCELA" , "A"                             , NIL } )
AAdd( _aReg, { "E1_TIPO"    , "NCC"                           , NIL } )
AAdd( _aReg, { "E1_NATUREZ" , "1001"                          , NIL } )
AAdd( _aReg, { "E1_CLIENTE" , "000460"                        , NIL } )
AAdd( _aReg, { "E1_LOJA"    , "01"                            , NIL } )
AAdd( _aReg, { "E1_EMISSAO" , dDataBase                       , NIL } )
AAdd( _aReg, { "E1_VENCTO"  , dDataBase                       , NIL } )
AAdd( _aReg, { "E1_VENCREA" , dDataBase                       , NIL } )
AAdd( _aReg, { "E1_VALOR"   , 1000                            , NIL } )
AAdd( _aReg, { "E1_MOTDESC" , "001"                           , NIL } )
AAdd( _aReg, { "E1_COLETA"  , "000001"                        , NIL } )

MsExecAuto( {|x,y| Fina040(x,y)}, _aReg, 3 )

//-- Verifica se houve algum erro.
If lMsErroAuto
	MostraErro()
EndIf

Return