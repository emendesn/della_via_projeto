#include "rwmake.ch"
#include "topconn.ch"

User Function TSTMSAUTO()
	Local   aDados      := {}
	Private lMsErroAuto := .F.

	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(xFilial("SE1")+"01A000497AC")


	aAdd( aDados, { "E1_PREFIXO" ,SE1->E1_PREFIXO    ,NIL })
	aAdd( aDados, { "E1_NUM"     ,SE1->E1_NUM        ,NIL })
	aAdd( aDados, { "E1_PARCELA" ,SE1->E1_PARCELA    ,NIL })
	aAdd( aDados, { "E1_CLIENTE" ,SE1->E1_CLIENTE    ,NIL })
	aAdd( aDados, { "E1_TIPO"    ,SE1->E1_TIPO       ,NIL })
	aAdd( aDados, { "E1_LOJA"    ,SE1->E1_LOJA       ,NIL })
	aAdd( aDados, { "E1_TIPO"    ,SE1->E1_TIPO       ,NIL })

	aAdd( aDados, { "AUTMOTBX"   ,"NOR"              ,NIL })
	aAdd( aDados, { "AUTBANCO"   ,"CX1"              ,NIL })
	aAdd( aDados, { "AUTAGENCIA" ,"00001"            ,NIL })
	aAdd( aDados, { "AUTCONTA"   ,"0000000001"       ,NIL })

	aAdd( aDados, { "AUTDTBAIXA" ,dDataBase          ,NIL })
	aAdd( aDados, { "AUTHIST"    ,"TESTE MSEXECAUTO" ,NIL })
	aAdd( aDados, { "AUTVALREC"  , 6.48              ,NIL })

	MsExecAuto( { |x,y| Fina070(x,y) } ,aDados,3)

	If lMsErroAuto
		MostraErro()
	EndIf
Return