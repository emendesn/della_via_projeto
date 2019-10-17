#include "rwmake.ch"
#include "topconn.ch"

User Function DVCONF02()
	Private Titulo   := "Desmarca Contabilização - Faturamento"
	Private cPerg    := "DCON02"
	Private aRegs    := {}
	Private aSays    := {}
	Private aButtons := {}

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Até a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"03","Loja               ?"," "," ","mv_ch3","C", 02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.F.)

	aAdd(aSays,"Esta rotina desmarca o campo F2_DTLANC na tabela SF2 liberando os regsitros para")
	aAdd(aSays,"nova contabiliação de acordo com os parametros especificados")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcLA() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcLA()
	Private cSql   := ""

	If !msgbox("Confirma a atualização da tabela ?","Executar","YESNO")
		Return
	Endif

	FechaBatch()
	
	cSql := ""
	cSql := cSql + "UPDATE "+RetSqlName("SF2")
	cSql := cSql + " SET F2_DTLANC = ''"
	cSql := cSql + " WHERE D_E_L_E_T_ = ''"
	cSql := cSql + " AND   F2_FILIAL = '"+mv_par03+"'"
	cSql := cSql + " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"

	MsgRun("Atualizando SF2 ...",,{|| TcSqlExec(cSql)})
Return nil