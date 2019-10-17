#include "rwmake.ch"                                

User Function AJUSOBS()
     //
     Processa( {|| PROCAJUS() }, "Atualizando o campo F4_OBS da TES, processando..." )
     //
Return

Static Function ProcAjus()
     //
     Local _cTmpAlias := "TIMP"
     //
     IF File("f:\temp\SF4010.DBF")
		//
		DbUseArea(.T.,,"SF4010.DTC",_cTmpAlias,.F.,.F.)
		//	
        DbGoTop()
        ProcRegua(RecCount())
        //
		Do While !Eof()
		   //
           IncProc("TES --> "+AllTrim((_cTmpAlias)->F4_CODIGO))
	       //
           dbSelectArea("SF4")
           dbSetOrder(1)
           If dbSeek(xFilial("SF4")+(_cTmpAlias)->F4_CODIGO,.F.)
              If RecLock("SF4",.F.)
                 SF4->F4_OBS := (_cTmpAlias)->F4_OBS
                 MSUnLock()
                 IncProc("Atualizando TES --> "+AllTrim((_cTmpAlias)->F4_CODIGO))
              EndIf
           Endif
	       //
           DbSelectArea(_cTmpAlias)
           DbSkip()
		   //		
		EndDo
		//	
		DbSelectArea(_cTmpAlias)
		DbCloseArea()
		//	
	EndIF
    //
Return

    
    