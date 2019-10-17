#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR29 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR29   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório transferencia entre filiais                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SC5"
	Private aOrd           := {}
	Private cDesc1         := "Cliente:15LQFY"
	Private cDesc2         := "Grupo de-até"
	Private cDesc3         := "Filial Origem/Destino"
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR29"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL29"
	Private titulo         := "Relatório Transferência Entre Filiais"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR29"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

    aAdd(aRegs,{cPerg,"01","Código do Cliente     ?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""          })
    aAdd(aRegs,{cPerg,"02","Data Emissão Início   ?"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"03","Data Emissão Final    ?"," "," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Situação do Pedido    ?"," "," ","mv_ch4","N",01,0,0,"C","","mv_par04","Todos        ","","","","","Abertos       ","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"05","Filial Origem Inicial ?"," "," ","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"06","Filial Origem Final   ?"," "," ","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"07","Filial Destino Inicial?"," "," ","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"08","Filial Destino Final  ?"," "," ","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"09","Grupo  Inicial        ?"," "," ","mv_ch9","C",04,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""          })
    aAdd(aRegs,{cPerg,"10","Grupo  Final          ?"," "," ","mv_chA","C",04,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"11","Ordem                 ?"," "," ","mv_chB","N",01,0,0,"C","","mv_par11","Filial Origem","","","","","Filial Destino","","","","","Grupo","","","","","Produto","","","","","Emissão ","","","","   ","","","",""          })
    
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
	
    if mv_par01 # space(6) .or. mv_par02 # ctod("  /  /  ") .or. mv_par03 # ctod("  /  /  ")
       RptStatus({||Runreport()})
    endif
    m_pag   := 01
    Li      := 80  

Enddo
Return nil
 
Static Function RunReport()

	Cabec1:=" FO FD CLIENT NUMPED EMISSAO  GRUP CODIGO DESCRICAO                      NF.SAI EMISSAO  IT QTD.SAI NF.ENT DT.REC.  QTD.ENT    SALDO"

	cSql :=	"select C5_FILIAL, "
	cSql += "       C5_LOJACLI, "
	cSql += "       C5_CLIENTE, "
	cSql += "       C5_NUM, "
	cSql += "       C5_EMISSAO, "
	cSql += "       B1_GRUPO, "
	cSql += "       C6_NOTA, "
	cSql += "       C6_ITEM, "
	cSql += "       C6_PRODUTO, "
	cSql += "       C6_QTDVEN, "
	cSql += "       C6_DESCRI, "
	cSql += "       C6_DATFAT, "
	cSql += "       D1_DOC, "
	cSql += "       D1_DTDIGIT, "
	cSql += "       D1_QUANT "
    cSql += "  from " + RetSqlName("SC5")+ " SC5 "
    cSql += "   join " + RetSqlName("SC6")+ " SC6 "
    cSql += "     on SC6.D_E_L_E_T_ =  '' " 
    cSql += "   and C6_FILIAL      = C5_FILIAL "
    cSql += "   and C6_NUM         = C5_NUM "
    if mv_par04 = 2
    	cSql += "   and C6_NOTA    = '' "
    endif                                   
    cSql += "   join " + RetSqlName("SB1")+ " SB1 " 
    cSql += "     on SB1.D_E_L_E_T_ =  '' " 
    cSql += "   and B1_FILIAL            =  '' "
    cSql += "   and B1_COD               = C6_PRODUTO "
    cSql += "   and B1_GRUPO        >= '" + mv_par09 + "' "
    cSql += "   and B1_GRUPO        <= '" + mv_par10 + "' "
    cSql += "    left join " + RetSqlName("SD1")+ " SD1 "
    cSql += "     on SD1.D_E_L_E_T_  =  '' "
    cSql += "    and D1_FILIAL            = C6_LOJA "
    cSql += "    and D1_FORNECE      = '000500' "
    cSql += "    and D1_LOJA              = C6_FILIAL "
    cSql += "    and D1_DOC               = C6_NOTA "
    cSql += "    and D1_COD               = C6_PRODUTO "
    cSql += " where SC5.D_E_L_E_T_ =  ' ' " 
    cSql += "   and C5_FILIAL     >= '" + upper(trim(mv_par05)) + "' " 
    cSql += "   and C5_FILIAL     <= '" + upper(trim(mv_par06)) + "' "  
    if mv_par01 = space(06)     
       cSql += "   and C5_CLIENTE  = '15LQFY' "   
    else
       cSql += "   and C5_CLIENTE  = '" + upper(trim(mv_par01)) + "' "
    endif  
        cSql += "   and C5_LOJACLI    >= '" + upper(trim(mv_par07)) + "' " 
    cSql += "   and C5_LOJACLI    <= '" + upper(trim(mv_par08)) + "' "  
    cSql += "   and C5_EMISSAO    >= '" + dtos(mv_par02) + "' "
    cSql += "   and C5_EMISSAO    <= '" + dtos(mv_par03) + "' "                   
    
    Do Case
    	Case mv_par11 = 1
    		 cSql += " order BY C5_FILIAL,C5_LOJACLI,C5_NUM,C6_ITEM "   
    	Case mv_par11 = 2      
    	     cSql += " order BY C5_LOJACLI,C5_FILIAL,C5_NUM,C6_ITEM "  
    	Case mv_par11 = 3      
    	     cSql += " order BY B1_GRUPO,C6_PRODUTO,C5_FILIAL,C5_LOJACLI,C5_NUM,C6_ITEM "
    	Case mv_par11 = 4     
    	     cSql += " order BY C6_PRODUTO,C5_FILIAL,C5_LOJACLI,C5_NUM,C6_ITEM "
    	Case mv_par11 = 5     
    	     cSql += " order BY C5_FILIAL,C5_LOJACLI,DTOS(C5_EMISSAO),C5_NUM,C6_ITEM "    
    Endcase
    
	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","C5_EMISSAO","D")
	TcSetField("ARQ_SQL","C6_DATFAT" ,"D")
	TcSetField("ARQ_SQL","D1_DTDIGIT","D")
	TcSetField("ARQ_SQL","C6_QTDVEN" ,"N",14,2)
	TcSetField("ARQ_SQL","D1_QUANT"  ,"N",14,2)
	
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
		
		@Li, 001      PSAY ARQ_SQL->C5_FILIAL
	    @Li, pcol()+1 PSAY ARQ_SQL->C5_LOJACLI
	    @Li, pcol()+1 PSAY ARQ_SQL->C5_CLIENTE
	    @Li, pcol()+1 PSAY ARQ_SQL->C5_NUM   
        @Li, pcol()+1 PSAY ARQ_SQL->C5_EMISSAO  
	    @Li, pcol()+1 PSAY ARQ_SQL->B1_GRUPO
        @Li, pcol()+1 PSAY SUBSTR(ARQ_SQL->C6_PRODUTO,1,6) 
        @Li, pcol()+1 PSAY ARQ_SQL->C6_DESCRI    
        @Li, pcol()+1 PSAY ARQ_SQL->C6_NOTA 
        @Li, pcol()+1 PSAY ARQ_SQL->C6_DATFAT
        @Li, pcol()+1 Psay ARQ_SQL->C6_ITEM 
        @Li, pcol()+1 PSAY ARQ_SQL->C6_QTDVEN PICTURE "999,999"
        @Li, pcol()+1 PSAY ARQ_SQL->D1_DOC
        @Li, pcol()+1 PSAY ARQ_SQL->D1_DTDIGIT
        @Li, pcol()+1 PSAY ARQ_SQL->D1_QUANT PICTURE "999,999"    
        @Li, pcol()+1 psay (ARQ_SQL->C6_QTDVEN - ARQ_SQL->D1_QUANT) PICTURE "999,999"
        
        LI ++
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
