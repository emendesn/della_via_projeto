
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR09 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDGolR01   บAutor  ณ by Golo            บ Data ณ  06/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Super Relatorio                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Della Via                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "C๓digo do Cliente: Se informado, selecionarแ exclusivamente o Cliente.                                                   "
	Private cDesc2         := "Vencimento de-at้: Obrigat๓rio, informar preferencialmente o intervalo adequado para busca mais rแpida.                  "
	Private cDesc3         := "Saldo do tํtulo  : Se zero selecionarแ todos os registros com saldo. Prefixo: Pode ser utilizada para sele็ใo de filiais."
	Private tamanho        := "G"                                               
	Private nomeprog       := "DGOLR09"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOLR9"
	Private titulo         := "Pesquisa Titulos do Contas a Receber"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR09"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

    aAdd(aRegs,{cPerg,"01","C๓digo do Cliente      ?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""          })
    aAdd(aRegs,{cPerg,"02","Emissใo Inicial        ?"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"03","Emissใo Final          ?"," "," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Valor do Tํtulo Inicial?"," "," ","mv_ch4","N",12,2,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"05","Valor do Tํtulo Final  ?"," "," ","mv_ch5","N",12,2,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"06","Ident.CNAB Inicial     ?"," "," ","mv_ch6","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"07","Ident.CNAB Final       ?"," "," ","mv_ch7","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"08","Numero Bancario        ?"," "," ","mv_ch8","C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"09","Numero Bancario        ?"," "," ","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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

Do while .t.
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		//return //
		Exit
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		//return
		 Exit
	Endif   
	if empty(mv_par02) 
		msgbox("Tadannnnn....Data Emissใo Nใo Informado","Parametro","STOP")  
	   	loop
    endif
     
	if dtos(mv_par03)<dtos(mv_par02) 
		msgbox("Tadannnnn....Data Final < Data Inicial","Parametro","STOP")  
	   	loop
	endif
	if (mv_par03 - mv_par02) > 250  
		msgbox("Tadannnnn....Perํodo muito looooooooooongo","Parametro","STOP")  
	   	loop
    endif   
    RptStatus({||Runreport()})  
    m_pag   := 01
    Li      := 80  
   
Enddo 
Return nil


Static Function RunReport()
                                   
	Cabec1:=" CLIENT LJ NOME DO CLIENTE      TIP PRE TITULO P DT.EMISS DT.VENCR DT.BAIXA BCO AGEN  NUM.BANCO     NUM.BORD.IDENT.CNAB VALOR TITULO SALDO ABERTO HISTORICO"

	cSql :=	"select E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA, E1_TIPO,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_EMISSAO,E1_VENCREA,E1_BAIXA,E1_VALOR,E1_SALDO,E1_PORTADO,E1_AGEDEP,E1_NUMBCO,E1_NUMBOR,E1_IDCNAB,E1_HIST"
    cSql += "  from " + RetSqlName("SE1")+ " SE1 "
    cSql += " where SE1.D_E_L_E_T_ = ' ' "
    cSql += "   and E1_FILIAL      = '  ' "
    if !empty(mv_par01)     
       cSql += "   and E1_CLIENTE  = '" + upper(trim(mv_par01)) + "' "  
       cSql += "   and E1_EMISSAO >= '" + dtos(mv_par02) + "' "
       cSql += "   and E1_EMISSAO <= '" + dtos(mv_par03) + "' "  
    else
       cSql += "   and E1_EMISSAO >= '" + dtos(mv_par02) + "' "
       cSql += "   and E1_EMISSAO <= '" + dtos(mv_par03) + "' "  
    endif   
    if !empty(mv_par06) .or. !empty(mv_par07)
       cSql += " and E1_IDCNAB >= '" + alltrim(upper(mv_par06)) + "' "
       cSql += " and E1_IDCNAB <= '" + alltrim(upper(mv_par07)) + "' "
    endif
    if mv_par05 > 0    
       cSql += "   and E1_VALOR   >= " + alltrim(str(mv_par04,12,2)) 
       cSql += "   and E1_VALOR   <= " + alltrim(str(mv_par05,12,2))
    endif 
    if !empty(mv_par08) .or. !empty(mv_par09)    
       cSql += "   and E1_NUMBCO   >= '" + PADR(alltrim(mv_par08),15) + "'" 
       cSql += "   and E1_NUMBCO   <= '" + PADR(alltrim(mv_par09),15) + "'"
    endif 

    cSql += " order BY E1_CLIENTE, E1_LOJA, E1_NUM, E1_PARCELA "

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","E1_EMISSAO","D")
	TcSetField("ARQ_SQL","E1_VENCREA","D") 
	TcSetField("ARQ_SQL","E1_BAIXA"  ,"D")
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

		lImp:=.t.
		if li>55
               LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			   LI+=2
		endif
		
	    @Li, 001      PSAY ARQ_SQL->E1_CLIENTE
        @Li, pcol()+1 PSAY ARQ_SQL->E1_LOJA
	    @Li, pcol()+1 PSAY ARQ_SQL->E1_NOMCLI 
	    @Li, pcol()+1 PSAY ARQ_SQL->E1_TIPO
        @Li, pcol()+1 Psay ARQ_SQL->E1_PREFIXO 
        @Li, pcol()+1 PSAY ARQ_SQL->E1_NUM 
        @Li, pcol()+1 PSAY ARQ_SQL->E1_PARCELA
        @Li, pcol()+1 PSAY ARQ_SQL->E1_EMISSAO
        @Li, pcol()+1 PSAY ARQ_SQL->E1_VENCREA
        @Li, pcol()+1 PSAY ARQ_SQL->E1_BAIXA
        @Li, pcol()+1 PSAY ARQ_SQL->E1_PORTADO
        @Li, pcol()+1 PSAY ARQ_SQL->E1_AGEDEP
        @Li, pcol()+1 PSAY ARQ_SQL->E1_NUMBCO
        @Li, pcol()+1 PSAY ARQ_SQL->E1_NUMBOR
        @Li, pcol()+1 PSAY ARQ_SQL->E1_IDCNAB
        @Li, pcol()+1 PSAY ARQ_SQL->E1_VALOR PICTURE "@E 9,999,999.99"
        @Li, pcol()+1 PSAY ARQ_SQL->E1_SALDO PICTURE "@E 9,999,999.99"  
        @Li, pcol()+1 PSAY ARQ_SQL->E1_HIST
     
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
