#include "DellaVia.ch"
#include "rwmake.ch"

User Function DST10MPV(cPedido)

	local 	cPedido
	Private cMens	
	dbSelectArea("SC5")
	dbSeek(xFilial("SC5")+cPedido)
	If !found()
		MsgAlert("Pedido Não Gerado","Atenção")
		return nil
	Endif
    cMens := SC5->C5_MENNOTA
                         
	Define Font oFontBold  Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 200,510 DIALOG oDlg1 TITLE "Altera Mensagem"
    //
	@ 005,005 TO 060,250 Title "Pedido de Venda" PIXEL
	@ 012,010 GET cMens       Picture "@!" OBJECT oGetFil                    //SIZE 200,10      
	//
	@ 060,005 TO 080,250 PIXEL //Botões
	@ 065,185 BMPBUTTON TYPE 1 ACTION AtuMsg()

	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function AtuMsG()
	dbSelectArea("SC5")
	if RecLock("SC5",.F.)
		SC5->C5_MENNOTA := cMens
		MsUnlock()
	endif
	Close(oDlg1)
Return nil