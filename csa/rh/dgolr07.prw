
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR07 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR07   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Super bORORO                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SC7"
	Private aOrd           := {}
	Private cDesc1         := "Código do Fornecedor: Se informado, selecionará exclusivamente o Fornecedor."
	Private cDesc2         := "Situação: ( ) Todos (E)ncerrados (A)berto. Emissão De-Até: Obrigatório."
	Private cDesc3         := "Filial De-Até: Se informado, selecionará exclusivamente o intervalo de Filiais."
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR07"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOLR7"
	Private titulo         := "Relatorio de Pedidos de Compra"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR07"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

   aAdd(aRegs,{cPerg,"01","Código do Fornecedor  ?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""          })
   aAdd(aRegs,{cPerg,"02","Data Emissão Início   ?"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   aAdd(aRegs,{cPerg,"03","Data Emissão Final    ?"," "," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   aAdd(aRegs,{cPerg,"04","(A)bertos (E)ncerrados?"," "," ","mv_ch4","C",01,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   aAdd(aRegs,{cPerg,"05","Emitidos? (S)im/(N)ão ?"," "," ","mv_ch5","C",01,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   aAdd(aRegs,{cPerg,"06","Filial Inicial        ?"," "," ","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   aAdd(aRegs,{cPerg,"07","Filial Final          ?"," "," ","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          }) 
   aAdd(aRegs,{cPerg,"08","Todos     (S)im/(N)ão ?"," "," ","mv_ch8","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   aAdd(aRegs,{cPerg,"09","Grupo  Inicial        ?"," "," ","mv_ch9","C",04,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""          })
   aAdd(aRegs,{cPerg,"10","Grupo  Final          ?"," "," ","mv_chA","C",04,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""          })
   aAdd(aRegs,{cPerg,"11","Produto               ?"," "," ","mv_chB","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""          })

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
	   return nil
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif
    
 	if (mv_par03 - mv_par02) > 100
       Return nil   
   endif 

   RptStatus({||Runreport()})
   m_pag   := 01
   Li      := 80  

Return nil         
 
Static Function RunReport()

	Cabec1:=" FL EMISSAO  FORNEC LJ NUMERO ITEM E A R     QUANTIDADE PRODUTO         GRUP DESCRICAO"

	cSql :=	"select C7_FILIAL, "
	cSql += "       C7_EMISSAO, "
	cSql += "       C7_NUM, "
	cSql += "       C7_ITEM, "
	cSql += "       C7_FORNECE, "
	cSql += "       C7_LOJA, "
	cSql += "       C7_PRODUTO," 
	cSql += "       C7_QUANT, "
	cSql += "       C7_EMITIDO, "
	cSql += "       C7_DESCRI, "
	cSql += "       C7_ENCER, "
	cSql += "       C7_RESIDUO, "
	cSql += "       B1_GRUPO"
	cSql += "  from " + RetSqlName("SC7")+ " SC7 , SB1010 SB1 "
	cSql += " where SC7.D_E_L_E_T_ = ' ' "  
	cSql += "   and SB1.D_E_L_E_T_ = ' ' "     
 	if mv_par06 # space(2) .or. mv_par07 # space(2)
       cSql += "   and C7_FILIAL  >= '" + upper(trim(mv_par06)) + "' " 
       cSql += "   and C7_FILIAL  <= '" + upper(trim(mv_par07)) + "' "  
   else
       cSql += "   and C7_FILIAL >= '  ' and C7_FILIAL <= 'ZZ' "
   endif
   if mv_par01 # space(06)     
       cSql += "   and C7_FORNECE  = '" + upper(trim(mv_par01)) + "' "  
       cSql += "   and C7_EMISSAO >= '" + dtos(mv_par02) + "' "
       cSql += "   and C7_EMISSAO <= '" + dtos(mv_par03) + "' "  
   else
       cSql += "   and C7_EMISSAO >= '" + dtos(mv_par02) + "' "
       cSql += "   and C7_EMISSAO <= '" + dtos(mv_par03) + "' "  
   endif  
   if upper(mv_par04) =  "A"
       cSql += " and C7_ENCER = ' ' "
   endif
   if upper(mv_par04) = "E"
       cSql += " and C7_ENCER = 'E' "
   endif
   if upper(mv_par05) = "S"   
       cSql += " and C7_EMITIDO = 'S' "
   endif
   if upper(mv_par05) = "N" 
       cSql += " and C7_EMITIDO = 'N' "
   endif
	if mv_par11 # space(6)
       cSql += " and SB1.B1_Cod =   '" + mv_par11 + "'"
   endif
   cSql += "   and SB1.B1_GRUPO >= '" + mv_par09 + "'"
   cSql += "   and SB1.B1_GRUPO <= '" + mv_par10 + "'"  
   csql += "   and SB1.B1_COD = SC7.C7_PRODUTO " 
   cSql += " order BY C7_FILIAL,C7_EMISSAO,C7_FORNECE,C7_LOJA,C7_NUM,C7_ITEM "

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","C7_EMISSAO","D")
	TcSetField("ARQ_SQL","C7_QUANT","N",14,2)
	
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

        if mv_par08 = "S" .or. ARQ_SQL->C7_RESIDUO # "S" 
           @Li, 001      PSAY ARQ_SQL->C7_FILIAL
	       @Li, pcol()+1 PSAY ARQ_SQL->C7_EMISSAO
	       @Li, pcol()+1 PSAY ARQ_SQL->C7_FORNECE
           @Li, pcol()+1 PSAY ARQ_SQL->C7_LOJA
	       @Li, pcol()+1 PSAY ARQ_SQL->C7_NUM 
	       @Li, pcol()+1 PSAY ARQ_SQL->C7_ITEM
           @Li, pcol()+1 Psay ARQ_SQL->C7_EMITIDO 
           @Li, pcol()+1 PSAY ARQ_SQL->C7_ENCER 
           @Li, pcol()+1 PSAY ARQ_SQL->C7_RESIDUO
           @Li, pcol()+1 PSAY ARQ_SQL->C7_QUANT PICTURE "999,999,999.99"
           @Li, pcol()+1 PSAY ARQ_SQL->C7_PRODUTO 
           @Li, pcol()+1 pSAY ARQ_SQL->B1_GRUPO
           @Li, pcol()+1 PSAY ARQ_SQL->C7_DESCRI
        
		   LI++
		endif   
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
