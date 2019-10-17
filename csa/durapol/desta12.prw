#include 'protheus.ch'
#Include 'Dellavia.ch'
// Estorno OP
User Function DESTA12()

	Private aCores      := {}
	Private cCadastro	:= 'Producao'
	Private cIndex      := ''
	Private cChave      := ''
	Private aRotina		:= {	{ OemToAnsi('Pesquisar')    ,'AxPesqui'    , 0, 1 },;
                    			{ OemToAnsi('Estornar')     ,'U_DESTA12E'  , 0, 5 },;
                    			{ OemToAnsi('Legenda')      ,'U_DESTA12L'  , 0, 2 } }
                    			
	Aadd( aCores, { "C2_X_STATU == '9'"                           , "BR_PRETO"    } )
	Aadd( aCores, { "C2_X_STATU == '6'"                           , "BR_VERMELHO" } )
	Aadd( aCores, { "C2_X_STATU $ '1'"                            , "BR_VERDE"    } )
	Aadd( aCores, { "C2_X_STATU $ ' 2345' .and. C2_XNUMROD = '  '", "BR_AZUL"     } )
	Aadd( aCores, { "C2_X_STATU $ ' 2345' .and. C2_XNUMROD # '  '", "BR_AMARELO"  } )
	Aadd( aCores, { ".T."                                         , "BR_BRANCO"   } )

	dbSelectArea("SC2")
	MBrowse( 6,1,22,75,'SC2',,,,,, aCores )

Return Nil

User Function DESTA12E () 

	Local aRegSD3 			:= {}
	Local lOk     			:= .T.
	Private lMsHelpAuto   	:= .F.
	Private lMsErroAuto   	:= .F.
	
	If .not.(SC2->C2_X_STATU  $ '96')
		MsgStop( 'Esta OP ainda nao foi encerrada.' )
		Return Nil
	EndIf 
	
	aSaveArea:=getarea()
	dbSelectArea("SC6")
	dbSetOrder(7)                                      
	dbSeek(xFilial("SC6") + SC2->C2_NUM+SC2->C2_ITEM )
	restArea(aSaveArea)  
	IF !Empty(SC6->C6_NOTA)    
 		MsgStop( 'Esta OP Já foi faturada ...' )
		Return Nil
	endif

	lOk := MsgYesNo( 'Confirma o Estorno da OP ?' )

	IF !lOK
		MsgStop("OP Nao Estornada ...")
		Return Nil
	endif
	     
    dbSelectArea("SD3")
    dbSetOrder( 13 )
	dbSeek( xFilial("SD3") + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + "  " + "CARC")  
	if found()
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2")+SD3->D3_COD+SD3->D3_LOCAL)
		if found() .and. Reclock("SB2",.F.)
			SB2->B2_QATU  := SB2->B2_QATU + 1
			SB2->B2_VATU1 := SB2->B2_VATU1 + SD3->D3_CUSTO1
			SB2->B2_CM1   := SB2->B2_VATU1 / SB2->B2_QATU
			msunlock()
		Endif    
	 	dbSelectArea("SD3")
		if RecLock("SD3",.F.)
			delete
	 		MsUnlock()
	 	endif  
	else
		bororo73
	endif	  
	restArea(aSaveArea)        
	dbSelectArea("SC2")
	
	if RecLock( 'SC2', .F. )
		SC2->C2_X_STATU := '1'
		SC2->C2_QUJE    := 0
		SC2->C2_MOTREJE := '' 
		SC2->C2_DATRF   := ctod('  /  /  ')
	 	SC2->C2_XDTCLAV := ctod('  /  /  ')
		SC2->C2_XNUMROD := ''
		SC2->C2_XRODADA := ''
		SC2->C2_XACLAVE := ''
		SC2->C2_XTRILHO := ''
		SC2->C2_XBICO   := ''
		SC2->C2_PERDA   := 0    
		SC2->C2_MOTREJE := ''
		MsUnLock()	
	 endif
			
Return Nil

User Function DESTA12L()

BrwLegenda( 'Legenda', cCadastro, { { 'BR_VERDE'   , 'Inspecao ' },;
                                    { 'BR_AZUL'    , 'Montagem ' },;
                                    { 'BR_AMARELO' , 'Autoclave' },;
                                    { 'BR_VERMELHO', 'Produzido' },;
                                    { 'BR_PRETO'   , 'Recusadoo' } } )

Return Nil



