
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR10V1 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR10V1   ºAutor³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SB1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "o log de movimentação da Durapol"
	Private cDesc3         := "Relatório de LOG Durapol"
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR10V1"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOR10"
	Private titulo         := "Relatorio LOG de Movimentação da Durapol"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR10V1"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

    aAdd(aRegs,{cPerg,"01","Filial de            ?"," "," ","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"02","Filial ate           ?"," "," ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"03","Data de              ?"," "," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Data ate             ?"," "," ","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"05","Ordem                ?"," "," ","mv_ch5","N",01,0,0,"C","","mv_par05","Sequencia ","","","","","OP","","","","","Tipo","","","","","Nome","","","","","","","","","   ","","","",""          })

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
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

    RptStatus({||Runreport()})

Static Function RunReport()
           //          1         2         3         4         5         6         7         8         9        10        11      
           //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Cabec1:=" FL T NUMDOC SER EMISSAO  HORA  NOME                  DESCR                                        NUMOP  IT "
	
    // C T	SETOR
    // 1 C	Coleta
    // 2 I	Inspeção
    // 3 M	Conserto
    // 4 B	Banda
    // 5 A	Autoclave
    // 6 F  CQ
    // 7 S  Faturamento
    
	cSql :=	" SELECT F1_FILIAL         AS FILIAL, "    
	cSql += "       '1'                AS SETOR, "
    cSql += "       'C'                AS TIPO, "
    cSql += "        F1_DOC            AS DOC, " 
    cSql += "        F1_SERIE          AS SERIE, " 
    cSql += "        F1_EMISSAO        AS EMISSAO, " 
    cSql += "        F1_HORA           AS HORA, " 
    cSql += "        A1_NREDUZ         AS NOME, "
    cSql += "        D1_COD            AS DESCR, "
    cSql += "        D1_NUMC2          AS NUMOP, "
    cSql += "        D1_ITEMC2         AS ITEMOP " 
  	cSql += "        FROM SF1030 SF1, SA1010 SA1, SD1030 SD1 "
 	cSql += "        WHERE SF1.D_E_L_E_T_ = '' "
 	cSql += "        AND F1_FILIAL     between '" + mv_par01       + "' and '" + mv_par02       + "' "
   	cSql += "        AND F1_EMISSAO    between '" + dtos(mv_par03) + "' and '" + dtos(mv_par04) + "' "
   	cSql += "        AND SA1.D_E_L_E_T_ = '' "
   	cSql += "        AND F1_FORNECE    = A1_COD "
   	cSql += "        AND F1_LOJA       = A1_LOJA "
   	cSql += "        AND F1_FILIAL     = D1_FILIAL "
   	cSql += "        AND F1_DOC        = D1_DOC "  
   	cSql += "        AND F1_TIPO       = 'B' " 
   	cSql += "        AND SD1.D_E_L_E_T_ = '' "
   	cSql += "        AND D1_TES        = '121' "  
   	cSql += "  UNION "
    cSql += " SELECT ZD3_FILIAL         AS FILIAL, "     
    cSql += "        case when substr(ZD3_TM,1,1) = '5' then '5' else '2' end AS SETOR, "
    cSql += "        case when substr(ZD3_TM,1,1) = '5' then 'A' else 'I' end AS TIPO, "
    cSql += "        ''                 AS DOC, "
    cSql += "        ''                 AS SERIE, "  
    cSql += "        ZD3_EMISSA         AS EMISSAO, "
    cSql += "        ZD3_HORA           AS HORA, "
    cSql += "        C2_XNREDUZ         AS NOME, "
    cSql += "        ZD3_XDESC          AS DESCR, "   
    cSql += "        ZD3_NUMOP          AS NUMOP, "
    cSql += "        ZD3_ITOP           AS ITEMOP "
  	cSql += "   FROM ZD3030 ZD3, SC2030 SC2 "
 	cSql += "  WHERE SC2.D_E_L_E_T_    = '' "                    
 	cSql += "    AND ZD3.D_E_L_E_T_    = '' "
    cSql += "    AND C2_FILIAL         = ZD3_FILIAL "             
   	cSql += "    AND ZD3_NUMOP         = C2_NUM "
   	cSql += "    AND ZD3_ITOP          = C2_ITEM "
   	cSql += "    AND ZD3_FILIAL        between '" + mv_par01       + "' and '" + mv_par02       + "' "
   	cSql += "    AND ZD3_EMISSA        between '" + dtos(mv_par03) + "' and '" + dtos(mv_par04) + "' "
   	cSql += "  UNION "
    cSql += " SELECT D3_FILIAL         AS FILIAL, "
    cSql += "        case when D3_TM IN ('506','509') then '6' else '3' end AS SETOR, "         
    cSql += "        case when D3_TM IN ('506','509') then 'F' "
    cSql += "             when D3_TM = '502' AND D3_GRUPO = 'MANC' then 'M' "
    cSql += "             when D3_TM = '502' AND D3_GRUPO = 'BAND' then 'B' "
    cSql += "        end AS TIPO, "
    cSql += "        D3_DOC            AS DOC, "
    cSql += "        D3_TM             AS SERIE, "  
    cSql += "        D3_EMISSAO        AS EMISSAO, "
    cSql += "        D3_HORA           AS HORA, "
    cSql += "        C2_XNREDUZ        AS NOME, "
    cSql += "        D3_XDESC          AS DESCR, "   
    cSql += "        SUBSTR(D3_OP,1,6) AS NUMOP, "
    cSql += "        SUBSTR(D3_OP,7,2) AS ITEMOP "
  	cSql += "   FROM SD3030 SD3, SC2030 SC2 "
 	cSql += "  WHERE SC2.D_E_L_E_T_    = '' "                    
 	cSql += "    AND SD3.D_E_L_E_T_    = '' "
    cSql += "    AND C2_FILIAL         = D3_FILIAL "             
   	cSql += "    AND D3_OP             = C2_NUM||C2_ITEM||'001' "
   	cSql += "    AND D3_FILIAL         between '" + mv_par01       + "' and '" + mv_par02       + "' "
   	cSql += "    AND D3_EMISSAO        between '" + dtos(mv_par03) + "' and '" + dtos(mv_par04) + "' "
   	cSql += "    AND D3_TM             IN ('502','506','509') "
 	cSql += "  UNION "
	cSql += " SELECT F2_FILIAL         AS FILIAL, "     
	cSql += "        '7'               AS SETOR, "
 	cSql += "        'S'               AS TIPO, "
  	cSql += "        F2_DOC            AS DOC, "
   	cSql += "        F2_SERIE          AS SERIE, "
    cSql += "        F2_EMISSAO        AS EMISSAO, "
    cSql += "        F2_HORA           AS HORA, "
    cSql += "        A1_NREDUZ         AS NOME, "
    cSql += "        D2_COD            AS DESCR, "
    cSql += "        C6_NUMOP          AS NUMOP, "
    cSql += "        C6_ITEMOP         AS ITEMOP "
  	cSql += "   FROM SF2030 SF2, SA1010 SA1, SD2030 SD2, SC6030 SC6 "
 	cSql += "  WHERE SF2.D_E_L_E_T_    = '' " 
 	cSql += "    AND F2_FILIAL         between '" + mv_par01       + "' and '" + mv_par02       + "' " 
   	cSql += "    AND F2_EMISSAO        between '" + dtos(mv_par03) + "' and '" + dtos(mv_par04) + "' "
   	cSql += "    AND F2_CLIENTE        = A1_COD "
   	cSql += "    AND F2_LOJA           = A1_LOJA "
   	cSql += "    AND F2_FILIAL         = D2_FILIAL " 
   	cSql += "    AND SD2.D_E_L_E_T_    = '' " 
   	cSql += "    AND D2_DOC            = F2_DOC "  
   	cSql += "    AND D2_TES            = '594' "  
   	cSql += "    AND SC6.D_E_L_E_T_    = '' " 
   	cSql += "    AND C6_FILIAL         = D2_FILIAL "
   	cSql += "    AND C6_NUM            = D2_PEDIDO "
   	cSql += "    AND C6_ITEM           = D2_ITEMPV "
   	Do Case
   		Case mv_par05 = 1
 			cSql += " ORDER BY FILIAL, EMISSAO, HORA,   SETOR,  TIPO "
 		Case mv_par05 = 2
 			cSql += " ORDER BY FILIAL, NUMOP,   ITEMOP, SETOR,  EMISSAO, HORA " 
 		Case mv_par05 = 3
 			cSql += " ORDER BY FILIAL, TIPO,    SETOR,  NOME,   NUMOP, ITEMOP,  EMISSAO, HORA "   
 		Case mv_par05 = 4
 			cSql += " ORDER BY FILIAL, NOME,    NUMOP,  ITEMOP, SETOR, TIPO,    HORA "
    EndCase
    
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","EMISSAO","D")
	
	dbSelectArea("ARQ_SQL")
	
	Do While !eof() 
	
		If lAbortPrint
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

	    @Li, 001 PSAY ARQ_SQL->FILIAL
	    @Li, 004 PSAY ARQ_SQL->TIPO 
	    @Li, 006 PSAY ARQ_SQL->DOC
	    @Li, 013 PSAY ARQ_SQL->SERIE
        @Li, 017 PSAY ARQ_SQL->EMISSAO
	    @Li, 026 PSAY ARQ_SQL->HORA
        @Li, 032 Psay ALLTRIM(ARQ_SQL->NOME) 
        @Li, 054 PSAY ARQ_SQL->DESCR
        @Li, 099 PSAY ARQ_SQL->NUMOP
        @Li, 106 PSAY ARQ_SQL->ITEMOP
        
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
