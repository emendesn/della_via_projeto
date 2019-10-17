
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR03 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR03   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SE2"
	Private aOrd           := {}
	Private cDesc1         := "Código do Fornecedor: Se informado, selecionará exclusivamente o Fornecedor."
	Private cDesc2         := "Vencimento de-até: Obrigatório, informar preferencialmente o intervalo adequado para busca mais rápida."
	Private cDesc3         := "Saldo do título  : Se zero selecionará todos os registros com saldo. Prefixo: Pode ser utilizada para seleção de filiais."
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR03"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOLR3"
	Private titulo         := "Relatorio de Títulos a Pagar em Aberto"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR03"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

    aAdd(aRegs,{cPerg,"01","Código do Fornecedor  ?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""          })
    aAdd(aRegs,{cPerg,"02","Vencimento Real Início?"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"03","Vencimento Real Final ?"," "," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Saldo do Título Início?"," "," ","mv_ch4","N",12,2,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"05","Saldo do Título Final ?"," "," ","mv_ch5","N",12,2,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"06","Prefixo Inicial       ?"," "," ","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"07","Prefixo Final         ?"," "," ","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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

Do While .t.	
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
	   //	Return
	   Exit
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		//Return
		Exit
	Endif

    RptStatus({||Runreport()})
    m_pag   := 01
    Li      := 80  
    mv_par01:=space(06)
    mv_par04:=space(08)
    mv_par05:=space(08) 
    mv_par06:=space(12)
    mv_par07:=space(12)
Enddo
Return nil
 
Static Function RunReport()

	Cabec1:=" FORNEC LJ NOME DO FORNECEDOR   TIP PRE TITULO P DT.EMISS DT.VENC. DT.VENCR NUMERO   BANCO VALOR TITULO SALDO ABERTO HISTORICO"

	cSql :=	"select E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA, E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_NUMBCO,E2_VALOR,E2_SALDO,E2_HIST"
    cSql += "  from " + RetSqlName("SE2")+ " SE2 "
    cSql += " where SE2.D_E_L_E_T_ = ' ' "
    cSql += "   and E2_FILIAL  >= '  ' "
    cSql += "   and E2_FILIAL  <= 'ZZ' "  
    if mv_par01 # space(06)     // USUARIO INFORMOU O CÓDIGO DO CLIENTE
       cSql += "   and E2_FORNECE  = '" + upper(trim(mv_par01)) + "' "  
       cSql += "   and E2_VENCREA >= '" + dtos(mv_par02) + "' "
       cSql += "   and E2_VENCREA <= '" + dtos(mv_par03) + "' "  
    else
       cSql += "   and E2_VENCREA >= '" + dtos(mv_par02) + "' "
       cSql += "   and E2_VENCREA <= '" + dtos(mv_par03) + "' "  
    endif  
    if mv_par06 # space(03) .or. mv_par07 # space(03)
       cSql += " and E2_PREFIXO >= '" + alltrim(upper(mv_par06)) + "' "
       cSql += " and E2_PREFIXO <= '" + alltrim(upper(mv_par07)) + "' "
    endif
    if mv_par04 = 0 .and. mv_par05 = 0    // USUARIO NÃO INFORMOU O VALOR PROCURADO
       cSql += "   and E2_SALDO   > 0"
    else
       cSql += "   and E2_SALDO   >= " + alltrim(str(mv_par04,12,2)) 
       cSql += "   and E2_SALDO   <= " + alltrim(str(mv_par05,12,2))
    endif 
    cSql += " order BY E2_FORNECE, E2_LOJA, E2_NUM, E2_PARCELA "

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","E2_EMISSAO","D")
	TcSetField("ARQ_SQL","E2_VENCTO", "D")
	TcSetField("ARQ_SQL","E2_VENCREA","D")
	TcSetField("ARQ_SQL","E2_SALDO",  "N",14,2)
	TcSetField("ARQ_SQL","E2_VALOR"  ,"N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)

	Do While !eof() 
	
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			return
		Endif

		lImp:=.t.
		if li>55
               LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			   LI+=2
		endif
	
	     @Li, 001      PSAY ARQ_SQL->E2_FORNECE
        @Li, pcol()+1 PSAY ARQ_SQL->E2_LOJA
	     @Li, pcol()+1 PSAY ARQ_SQL->E2_NOMFOR 
	     @Li, pcol()+1 PSAY ARQ_SQL->E2_TIPO
        @Li, pcol()+1 Psay ARQ_SQL->E2_PREFIXO 
        @Li, pcol()+1 PSAY ARQ_SQL->E2_NUM 
        @Li, pcol()+1 PSAY ARQ_SQL->E2_PARCELA
        @Li, pcol()+1 PSAY ARQ_SQL->E2_EMISSAO
        @Li, pcol()+1 PSAY ARQ_SQL->E2_VENCTO
        @Li, pcol()+1 PSAY ARQ_SQL->E2_VENCREA
        @Li, pcol()+1 PSAY ARQ_SQL->E2_NUMBCO
        @Li, pcol()+1 PSAY ARQ_SQL->E2_VALOR PICTURE "@E 9,999,999.99"
        @Li, pcol()+1 PSAY ARQ_SQL->E2_SALDO PICTURE "@E 9,999,999.99" 
        @Li, pcol()+1 PSAY ARQ_SQL->E2_HIST
        
		LI++
		dbSkip()
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
