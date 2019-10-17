#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

/****************************************************************************
*****************************************************************************
** Programa * DGolR01  * Autor  * by Golo            * Data *  06/06/06    **
*****************************************************************************
** Desc.    *   Super Relatorio                                            **
*****************************************************************************
** Uso      *  Grupo Della Via                                             **
*****************************************************************************
****************************************************************************/

User Function DGOLR01 ()
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Código do Cliente: Se informado, selecionará exclusivamente o Cliente."
	Private cDesc2         := "Vencimento de-até: Obrigatório, informar preferencialmente o intervalo adequado para busca mais rápida."
	Private cDesc3         := ""
	Private tamanho        := "G"
	Private nomeprog       := "DGOLR01"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOLR1"
	Private titulo         := "Relatorio de Títulos a Receber em Aberto"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR01"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}

    aAdd(aRegs,{cPerg,"01","Código do Cliente      ?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""          })
    aAdd(aRegs,{cPerg,"02","Do Vencimento Real     ?"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"03","Até o Vencimento Real  ?"," "," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Do Prefixo             ?"," "," ","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"05","Até o Prefixo          ?"," "," ","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })


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

	Do While .T.
		Pergunte(cPerg,.F.)
		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

		If nLastKey == 27
			Exit
		Endif

		if (mv_par03 - mv_par02) > 120
			msgbox("O Intervalor de datas não pode ser maior que 120 dias","Parametros","STOP")
			Loop
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			 Exit
		Endif
		
	    RptStatus({||Runreport()})

	    m_pag   := 01
	    Li      := 80
	Enddo
Return nil


Static Function RunReport()
	Cabec1:="                                                                               Vencimento      Dias         Valor         Saldo         Valor"
	Cabec2:="Cliente    Nome                  Tipo Prefixo Titulo    Emissao   Vencimento   Real       em Atraso     do Titulo     em Aberto     Corrigido         Juros  Portador  Histórico                   Telefone"
	        *XXXXXX-XX  XXXXXXXXXXXXXXXXXXXX  XX   XXX     XXXXXX/X  99/99/99  99/99/99     99/99/99         999  9,999,999.99  9,999,999.99  9,999,999.99  9,999,999.99  XXX       XXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXX
	        *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cTipo := ""
	cTipoParam := AllTrim(GetNewPar("MV_TIPOCOB","DP,CHD,NF,CH"))
	
	For k=1 to Len(cTipoParam)
		cChar := Substr(cTipoParam,k,1)

		If cChar <> "," .AND. cChar <> " "
			cTipo += iif(Len(cTipo)=0,"'","") + cChar
		Elseif cChar <> " "
			cTipo += "','"
		Endif

	Next k
	cTipo += iif(Len(cTipo) > 0,"'","")


	cSql :=	"SELECT E1_FILIAL"
	cSql += " ,     E1_PREFIXO"
	cSql += " ,     E1_NUM"
	cSql += " ,     E1_PARCELA"
	cSql += " ,     E1_TIPO"
	cSql += " ,     E1_CLIENTE"
	cSql += " ,     E1_LOJA"
	cSql += " ,     E1_NOMCLI"
	cSql += " ,     E1_EMISSAO"
	cSql += " ,     E1_VENCTO"
	cSql += " ,     E1_VENCREA"
	cSql += " ,     E1_VALOR"
	cSql += " ,     E1_SALDO"
	cSql += " ,     E1_HIST"
	cSql += " ,     E1_PORTADO"
	cSql += " ,     E1_PORCJUR"
	cSql += " FROM " + RetSqlName("SE1")
	cSql += " WHERE D_E_L_E_T_ = ' '"
	cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"

	if mv_par01 <> space(06)
		cSql += " AND   E1_CLIENTE  = '" + Upper(Trim(mv_par01)) + "'"
	endif

	cSql += " AND   E1_VENCREA BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"'"
	cSql += " AND   E1_MSFIL = '"+cFilAnt+"'"
	If Len(cTipo) > 0
		cSql += " AND   E1_TIPO IN("+cTipo+")"
	Endif
	cSql += " AND   E1_PREFIXO BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
	cSql += " AND   E1_SALDO > 0"
	cSql += " ORDER BY E1_CLIENTE,E1_LOJA,E1_NUM,E1_PARCELA"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","E1_EMISSAO","D")
	TcSetField("ARQ_SQL","E1_VENCTO", "D")
	TcSetField("ARQ_SQL","E1_VENCREA","D")
	TcSetField("ARQ_SQL","E1_SALDO",  "N",14,2)
	TcSetField("ARQ_SQL","E1_VALOR"  ,"N",14,2)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	Do while !eof()   
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			return
		Endif

		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+ARQ_SQL->E1_CLIENTE+ARQ_SQL->E1_LOJA)
		dbSelectArea("ARQ_SQL")

		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			LI+=2
		endif

		@ Li,000 PSAY E1_CLIENTE+"-"+E1_LOJA
		@ Li,011 PSAY E1_NOMCLI
		@ Li,033 PSAY E1_TIPO
		@ Li,038 Psay E1_PREFIXO
		@ Li,046 PSAY E1_NUM+Iif(Len(Trim(E1_PARCELA))>0,"/"+E1_PARCELA,"")
		@ Li,056 PSAY E1_EMISSAO
		@ Li,066 PSAY E1_VENCTO
		@ Li,079 PSAY E1_VENCREA
		@ Li,096 PSAY (dDataBase-E1_VENCREA) PICTURE "@E 999"
		@ Li,101 PSAY E1_VALOR PICTURE "@E 9,999,999.99"
		@ Li,115 PSAY E1_SALDO PICTURE "@E 9,999,999.99"
		nValJur := (E1_SALDO * (E1_PORCJUR/100))*(dDataBase-E1_VENCREA)
		@ Li,129 PSAY E1_SALDO+nValJur PICTURE "@E 9,999,999.99"
		@ Li,143 PSAY nValJur PICTURE "@E 9,999,999.99"
		@ Li,157 PSAY E1_PORTADO
		@ Li,167 PSAY E1_HIST
		@ LI,195 PSAY iif(Empty(SA1->A1_TELCOB),AllTrim(SA1->A1_DDD + " " + SA1->A1_TEL),AllTrim(SA1->A1_DDDCOB + " " + SA1->A1_TELCOB))
		LI++
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	Endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil