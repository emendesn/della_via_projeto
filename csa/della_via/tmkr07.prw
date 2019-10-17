#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function TMKR07
	Private cString        := "SF2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Relação de Notas fiscais"
	Private tamanho        := "G"
	Private nomeprog       := "TMKR07"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "TMKR07"
	Private titulo         := "Relação de Notas fiscais"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "TMKR07"
	Private lImp           := .f.

	// Carrega - Cria parametros
	cPerg    := "TMKR07"
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Loja        ","","","mv_ch1","C",02,0,0,"G",""            ,"mv_par01",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	aAdd(aRegs,{cPerg,"02","Até a Loja     ","","","mv_ch2","C",02,0,0,"G",""            ,"mv_par02",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	aAdd(aRegs,{cPerg,"03","Da Emissao     ","","","mv_ch3","D",08,0,0,"G",""            ,"mv_par03",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"","","","",""})
	aAdd(aRegs,{cPerg,"04","Até a Emissao  ","","","mv_ch4","D",08,0,0,"G",""            ,"mv_par04",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"","","","",""})
	aAdd(aRegs,{cPerg,"05","Tipo de venda  ","","","mv_ch5","C",10,0,0,"G","U_fTipVend()","mv_par05",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"","","","",""})


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
	Cabec1:=" Nota     Cond."
	Cabec2:=" Fiscal   Pagto   Cliente                                                Placa                  Valor   Tela         Cnpj / Cpf           Emissao    Tipo Venda   Vendedor   Convenio   Veiculo"
	        * XXXXXX   XXX     XXXXXX/XX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXX-9999   99,999,999,999.99   XXXXXXXXXX   XXXXXXXXXXXXXXXXXX   99/99/99   XXXXXXXXXX   XXXXXX     XXXXXX     XXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXXX
	   	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cFilTipV := ""
	For jj=1 to Len(AllTrim(mv_par05))
		If Substr(mv_par05,jj,1) <> "*"
			cFilTipV := cFilTipV + "'"+Substr(mv_par05,jj,1)+"',"
		Endif
	Next jj
	If Len(cFilTipV) > 0
		cFilTipV := substr(cFilTipV,1,Len(cFilTipV)-1)
	Endif

	cSql := ""
	cSql := cSql + "SELECT DISTINCT F2_FILIAL,F2_DOC,F2_COND,F2_CLIENTE,F2_LOJA,A1_NOME,F2_PLACA,F2_VALBRUT"
	cSql := cSql + " ,F2_ORIGEM,A1_CGC,F2_EMISSAO,SUBSTR(PAG_DESC,1,10) AS PAG_DESC,F2_VEND1,F2_CODCON,PA0_DESC,PA1_DESC"
	cSql := cSql + " FROM "+RetSqlName("SF2")+" SF2"
	cSql := cSql + " ,    "+RetSqlName("SD2")+" SD2"
	cSql := cSql + " ,    "+RetSqlName("SA1")+" SA1"
	cSql := cSql + " ,    "+RetSqlName("SF4")+" SF4"
	cSql := cSql + " ,    "+RetSqlName("PAG")+" PAG"
	cSql := cSql + " ,    "+RetSqlName("PA0")+" PA0"
	cSql := cSql + " ,    "+RetSqlName("PA1")+" PA1"
	cSql := cSql + " WHERE SF2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   SD2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   SF4.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   SA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   PAG.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   PA0.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   PA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql := cSql + " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	cSql := cSql + " AND   F2_TIPVND IN("+cFilTipV+")
	cSql := cSql + " AND   D2_FILIAL = F2_FILIAL"
	cSql := cSql + " AND   D2_DOC = F2_DOC"
	cSql := cSql + " AND   D2_SERIE = F2_SERIE"
	cSql := cSql + " AND   F4_CODIGO = D2_TES"
	cSql := cSql + " AND   F4_DUPLIC = 'S'"
	cSql := cSql + " AND   A1_COD = F2_CLIENTE"
	cSql := cSql + " AND   A1_LOJA = F2_LOJA"
	cSql := cSql + " AND   PAG_TIPO = F2_TIPVND"
	cSql := cSql + " AND   PA0_COD = F2_CODMAR"
	cSql := cSql + " AND   PA1_COD = F2_CODMOD"
	cSql := cSql + " ORDER BY F2_FILIAL,F2_EMISSAO,F2_DOC"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","F2_EMISSAO","D")
	TcSetField("ARQ_SQL","F2_VALBRUT","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	nTotGeral := 0
	Do While !eof()
		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI+=2

		cLoja    := F2_FILIAL
		nTotLoja := 0
		@ Li,001 PSAY "Loja: "+cLoja
		Li+=2

		Do While !eof() .AND. F2_FILIAL = cLoja
			IncProc("Imprimindo ...")
			If lAbortPrint .and. lImp
				LI+=3
				@ LI,001 PSAY "*** Cancelado pelo Operador ***"
				lImp := .F.
				exit
			Endif
			lImp:=.t.
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif

			@ LI,001 PSAY F2_DOC
			@ LI,010 PSAY F2_COND
			@ LI,018 PSAY F2_CLIENTE+"/"+F2_LOJA+" - "+A1_NOME
			@ LI,073 PSAY iif(len(AllTrim(F2_PLACA))>0,Substr(F2_PLACA,1,3)+"-"+Substr(F2_PLACA,4,4),F2_PLACA)
			@ LI,084 PSAY F2_VALBRUT Picture "@e 99,999,999,999.99"
			@ LI,104 PSAY substr(F2_ORIGEM,1,10)
			@ LI,117 PSAY A1_CGC
			@ LI,138 PSAY F2_EMISSAO
			@ LI,149 PSAY PAG_DESC
			@ LI,162 PSAY F2_VEND1
			@ LI,173 PSAY F2_CODCON
			@ LI,184 PSAY AllTrim(PA0_DESC)+"/"+AllTrim(PA1_DESC)
			nTotGeral += F2_VALBRUT
			nTotLoja  += F2_VALBRUT
			LI++
			dbSkip()
		Enddo
		LI++
		@ LI,001 PSAY "T O T A L    D A    L O J A"
		@ LI,084 PSAY nTotGeral Picture "@e 99,999,999,999.99"
		LI+=2
	Enddo

	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp
		LI++
		@ LI,001 PSAY "T O T A L    G E R A L"
		@ LI,084 PSAY nTotGeral Picture "@e 99,999,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil