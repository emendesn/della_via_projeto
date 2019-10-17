#include "rwmake.ch"
#include "topconn.ch"

User Function DVCONF01()
	Private Titulo   := "Desmarca Contabilização"
	Private cPerg    := "DCON01"
	Private aRegs    := {}
	Private aSays    := {}
	Private aButtons := {}

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Até a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})

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

	aAdd(aSays,"Esta rotina desmarca o campo LA nas tabelas SE1 e SE5 liberando os regsitros para")
	aAdd(aSays,"nova contabiliação de acordo com os parametros especificados")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcLA() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcLA()
	Private cSql   := ""

	If !msgbox("Confirma a atualização das tabelas ?","Executar","YESNO")
		Return
	Endif

	FechaBatch()
	
	cSql := ""
	cSql := cSql + "UPDATE "+RetSqlName("SE5")
	cSql := cSql + " SET E5_LA = ''"
	cSql := cSql + " WHERE D_E_L_E_T_ = ''"
	cSql := cSql + " AND   E5_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   E5_TIPODOC NOT IN('TR','TE')"
	cSql := cSql + " AND   E5_RECPAG = 'R'"
	cSql := cSql + " AND   E5_LA <> ''"

	MsgRun("Atualizando SE5 ...",,{|| TcSqlExec(cSql)})

	cSql := ""
	cSql := cSql + "UPDATE "+RetSqlName("SE1")
	cSql := cSql + " SET E1_LA = ''"
	cSql := cSql + " WHERE D_E_L_E_T_ = ''"
	cSql := cSql + " AND   E1_EMIS1 BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   E1_ORIGEM = 'FINA040'"
	cSql := cSql + " AND   E1_LA <> ''"

	MsgRun("Atualizando SE1 ...",,{|| TcSqlExec(cSql)})
Return nil