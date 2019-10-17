#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVESTR04
	Private cString        := "SD2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Produtos parados em estoque"
	Private tamanho        := "P"
	Private nomeprog       := "DVESTR04"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "ESTR04"
	Private titulo         := "Produtos parados em estoque"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVESTR04"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Filial          ?"," "," ","mv_ch1","C", 02,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SM0","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Filial       ?"," "," ","mv_ch2","C", 02,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SM0","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do Grupo           ?"," "," ","mv_ch3","C", 04,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate o Grupo        ?"," "," ","mv_ch4","C", 04,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"05","Dias Parados       ?"," "," ","mv_ch5","N", 03,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","","999"       })


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
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	Processa({|| RunReport() },Titulo,,.t.)
Return nil


Static Function RunReport()
	Cabec1:="Da Filial ("+mv_par01+") ate ("+mv_par02+")     Do Grupo ("+mv_par03+") ate ("+mv_par04+")     Dias parados ("+AllTrim(Str(mv_par05))+")"
	Cabec2:="  Código           Descrição                       Grupo  U. Saida   Saldo Est"
	        *  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXX   99/99/99  999,999.99
    	    *012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8

	// Query
	cSql := "SELECT D2_FILIAL,LJ_NOME,D2_COD"
	cSql += " ,     MAX(D2_EMISSAO) AS SAIDA"
	cSql += " ,     ("
	cSql += "       SELECT SUM(B2_QATU)"
	cSql += "       FROM "+RetSqlName("SB2")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND B2_FILIAL = D2_FILIAL"
	cSql += "       AND B2_COD = D2_COD"
	cSql += "       AND B2_LOCAL IN('01','02')"
	cSql += "       ) AS SALDO"
	cSql += " FROM "+RetSqlName("SD2")+" SD2"

	cSql += " JOIN "+RetSqlName("SLJ")+" SLJ"
	cSql += " ON   SLJ.D_E_L_E_T_ = ''"
	cSql += " AND  LJ_FILIAL = ''"
	cSql += " AND  LJ_RPCFIL = D2_FILIAL"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = ''"
	cSql += " AND  B1_COD = D2_COD"
	cSql += " AND  B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

	cSql += " WHERE SD2.D_E_L_E_T_ = ''"
	cSql += " AND   D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " GROUP BY D2_FILIAL,LJ_NOME,D2_COD"
	cSql += " HAVING MAX(D2_EMISSAO) <= '"+dtos(dDataBase-mv_par05)+"'"
	cSql += " AND   ("
	cSql += "       SELECT SUM(B2_QATU)"
	cSql += "       FROM "+RetSqlName("SB2")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND B2_FILIAL = D2_FILIAL"
	cSql += "       AND B2_COD = D2_COD"
	cSql += "       ) > 0"
	cSql += " ORDER BY D2_FILIAL,D2_COD"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","SAIDA","D")
	TcSetField("ARQ_SQL","SALDO","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	nTotFil := 0
	nTotGer := 0
	Do While !eof()
		cFilQuebra := D2_FILIAL
		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI++
		@ LI,000 PSAY "Filial: " + D2_FILIAL + " - " + LJ_NOME
		LI+=2
		Do while !eof() .and. D2_FILIAL = cFilQuebra
			IncProc(D2_FILIAL + " - " + D2_COD)

			If lAbortPrint
				LI+=3
				@ LI,001 PSAY "*** Cancelado pelo Operador ***"
				lImp := .F.
				exit
			Endif

			lImp:=.t.
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI++
			endif
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbgoTop()
			dbSeek(xFilial("SB1")+ARQ_SQL->D2_COD)
			dbSelectArea("ARQ_SQL")
	
			@ LI,002 PSAY D2_COD
			@ LI,019 PSAY SB1->B1_DESC
			@ LI,051 PSAY SB1->B1_GRUPO
			@ LI,058 PSAY SAIDA
			@ LI,068 PSAY SALDO Picture "@e 999,999.99"
			nTotFil += SALDO
			nTotGer += SALDO
			LI++
			dbSkip()
		Enddo
		LI++
		@ LI,000 PSAY "Total da Filial"
		@ LI,068 PSAY nTotFil Picture "@e 999,999.99"
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp
		LI+=2
		@ LI,000 PSAY "Total Geral"
		@ LI,068 PSAY nTotGer Picture "@e 999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil