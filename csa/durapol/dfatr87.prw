#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR87
	Private cString        := ""
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Status X Cliente"
	Private tamanho        := "G"
	Private nomeprog       := "DFATR87"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FATR87"
	Private titulo         := "Status X Cliente"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR87"
	Private lImp           := .f.
	Private aStatus        := {}

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"03","Do Cliente         ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"04","Ate o Cliente      ?"," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })

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
	Titulo := AllTrim(titulo) + " - De " + dtoc(mv_par01) + " ate " + dtoc(mv_par02)
	Cabec1:="     OP          Emissao    Produto           Descrição                        Grupo   Quantidade   Coleta              Motivo de Rejeição"
	        *     XXXXXX-XX   99/99/99   XXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXX    99,999,999   XXXXXX/XXX - XXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    	    *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	cSql := ""
	cSql := cSql + "SELECT C2_FILIAL,C2_FORNECE,C2_LOJA,A1_NOME,C2_X_STATU,X5_DESCRI,C2_NUM,C2_ITEM"
	cSql := cSql + " ,C2_EMISSAO,C2_PRODUTO,B1_DESC,B1_GRUPO,C2_QUANT,C2_NUMD1,C2_SERIED1,C2_ITEMD1,C2_MOTREJE"
	cSql := cSql + " FROM "+RetSqlName("SC2")+" SC2"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SA1")+" SA1"
	cSql := cSql + " ON   SA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  A1_FILIAL = ''"
	cSql := cSql + " AND  A1_COD = C2_FORNECE"
	cSql := cSql + " AND  A1_LOJA = C2_LOJA"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  B1_COD = C2_PRODUTO"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SX5")+" SX5"
	cSql := cSql + " ON   SX5.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  X5_FILIAL = ''"
	cSql := cSql + " AND  X5_TABELA = 'Z1'"
	cSql := cSql + " AND  X5_CHAVE = C2_X_STATU"

	cSql := cSql + " WHERE SC2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   C2_FILIAL = '"+xFilial("SC2")+"'"
	cSql := cSql + " AND   C2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   C2_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql := cSql + " AND   C2_FORNECE <> ''"
	cSql := cSql + " ORDER BY C2_FILIAL,C2_FORNECE,C2_LOJA,C2_X_STATU"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql) })
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.) })

	TcSetField("ARQ_SQL","C2_EMISSAO","D")
	TcSetField("ARQ_SQL","C2_QUANT","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif

		cCli := C2_FORNECE+C2_LOJA    
		
		@ LI,000 PSAY C2_FORNECE + "-" + C2_LOJA + " - " + A1_NOME
		LI++

		Do While !eof() .AND. C2_FORNECE+C2_LOJA = cCli
			cStatus := X5_DESCRI
			nQuant  := 0
			If AllTrim(C2_X_STATU) = "9"
				LI++
				@ LI,005 PSAY cStatus
				LI++
			Endif
			Do While !eof() .AND. C2_FORNECE+C2_LOJA = cCli .AND. X5_DESCRI = cStatus
				IncProc("Imprimindo ...")
				If lAbortPrint
					LI+=3
					@ LI,001 PSAY "*** Cancelado pelo Operador ***"
					lImp := .F.
					exit
				Endif
				If AllTrim(C2_X_STATU) = "9"
					if li>55
						LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
						LI+=2
					endif
					@ LI,005 PSAY C2_NUM+"-"+C2_ITEM
					@ LI,017 PSAY C2_EMISSAO
					@ LI,028 PSAY C2_PRODUTO
					@ LI,046 PSAY B1_DESC
					@ LI,079 PSAY B1_GRUPO
					@ LI,087 PSAY C2_QUANT PICTURE "@e 99,999,999" 
					@ LI,100 PSAY C2_NUMD1+"/"+C2_SERIED1+" - "+C2_ITEMD1
					@ LI,120 PSAY Tabela("43",AllTrim(C2_MOTREJE),.F.)
					LI++
				Endif
				nQuant += C2_QUANT
				dbSkip()
			Enddo

			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif
			@ LI,005 PSAY cStatus
			@ LI,087 PSAY nQuant Picture "@e 99,999,999"
			LI++
		Enddo
		@ LI,000 PSAY IniFatLine+FimFatLine
		LI+=2
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil