
user function tstcli()

PRIVATE lMsHelpAuto   := .F.
PRIVATE lMsErroAuto   := .F.   
PRIVATE _aReg         := {}  

AAdd( _aReg, { "A1_COD"     , "999999"                        , NIL } )
AAdd( _aReg, { "A1_LOJA"    , "99"                            , NIL } )
AAdd( _aReg, { "A1_NOME"    , "TESTE IMPORTACAO"              , NIL } )
AAdd( _aReg, { "A1_PESSOA"  , "J"                             , NIL } )
AAdd( _aReg, { "A1_NREDUZ"  , "TESTE"                         , NIL } )
AAdd( _aReg, { "A1_END"     , "R XYZ 123"                     , NIL } )
AAdd( _aReg, { "A1_MUN"     , "SAO PAULO"                     , NIL } )
AAdd( _aReg, { "A1_EST"     , "SP"                            , NIL } )
AAdd( _aReg, { "A1_CEP"     , "99999999"                      , NIL } )
AAdd( _aReg, { "A1_CGC"     , "01596333000198"                , NIL } )
AAdd( _aReg, { "A1_INSCR"   , "246034888119"                  , NIL } )

MsExecAuto( {|x,y| Mata030(x,y)}, _aReg, 3 )

//-- Verifica se houve algum erro.
If lMsErroAuto
	MostraErro()
EndIf

Return