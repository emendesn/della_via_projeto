#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR08 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ



±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR08   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        	:= "SF1"
	Private aOrd           	:= {}
	Private cDesc1         	:= ""
	Private cDesc2         	:= ""
	Private cDesc3         	:= ""
	Private tamanho        	:= "G"
	Private nomeprog       	:= "DGOLR08"
	Private lAbortPrint    	:= .F.
	Private nTipo          	:= 15
	Private aReturn        	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       	:= 0
	Private cPerg          	:= "DGOLR8"
	Private titulo         	:= "Minhas Recapagens"
	Private Li             	:= 80
	Private Cabec1         	:= ""
	Private Cabec2         	:= ""
	Private m_pag          	:= 01
	Private wnrel          	:= "DGOLR08"
	Private lImp           	:= .F.
	Private Cab1           	:= ""
	Private Cab2           	:= ""
   	Private Cab3           	:= ""   
	
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

    aAdd(aRegs,{cPerg,"01","Pesq (C)oleta (F)icha OP (N)ota Fiscal ?"," "," ","mv_ch1","C",01,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Cód. Cliente  (Só Nota Fiscal)         ?"," "," ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""          })
    aAdd(aRegs,{cPerg,"03","Emissão de    (Só Nota Fiscal)         ?"," "," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Emissão até   (Só Nota Fiscal)         ?"," "," ","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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
	Pergunte(cPerg,.T.) 

	if upper(mv_par01) = "N" 
 		vTabela := "SF2"
 		cString := vTabela
		aRegs    := {}                                                                  
    	wnrel := SetPrint(cString,NomeProg,.f.,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)
    	If nLastKey == 27
			Return nil
		Endif
		SetDefault(aReturn,cString)
		If nLastKey == 27
			Return nil
		Endif                                                   
    	RptStatus({||RunF2 ()})
        m_pag   := 01
    	Li      := 80  
    else
    	if upper(mv_par01) = "F"
    		vTabela := "SC2"  
    	else
    	    vTabela := "SF1"
    	endif
    	Private cCadastro := "Hiper Pesquisa Durapol"
		Private aRotina   := {	{ "Pesquisar"   ,"AxPesqui"           ,0,1},;
	                            { "Visualizar"  ,"u_DGOLR8A(vTabela)" ,0,2}}
        mBrowse(,,,,vTabela,,,,,,)
    endif
Return nil

	
Static Function RunF2()   
    Cabec1:="Periodo: " + dtoc(mv_par03) + " até " + dtoc(mv_par04)
	Cabec2:="CODIGO-LJ CLIENTE                                  MEDIDA          DESENHO         BANDA           FOGO            SERIE  NF     MOTIVO RECUSA"

	cSql :=	"select F2_FILIAL,F2_DOC ,F2_SERIE,F2_CLIENTE,F2_LOJA   ,F2_EMISSAO, "
	cSql += "       A1_FILIAL,A1_COD ,A1_LOJA ,A1_NOME, "
	cSql += "       D2_FILIAL,D2_DOC ,D2_SERIE,D2_CLIENTE,D2_LOJA   ,D2_ITEM, "
	cSql += "       C6_FILIAL,C6_NOTA,C6_SERIE,C6_NUM    ,C6_ITEM   ,C6_NUMOP  ,C6_ITEMOP,"
	cSql += "       C2_FILIAL,C2_NUM, C2_ITEM ,C2_X_STATU,C2_SERIEPN,C2_NUMFOGO,C2_PRODUTO,C2_CARCACA,C2_X_DESEN,C2_MOTREJE,"
	cSql += "       X5_DESCRI "
   	cSql += "  from " + RetSqlName("SF2") + " SF2 "  
   	cSql += "  join " + RetSqlName("SA1") + " SA1 "
   	cSql += "    on SA1.D_E_L_E_T_  = ' ' "
   	cSql += "   and SA1.A1_COD      = SF2.F2_CLIENTE "
   	cSql += "   and SA1.A1_LOJA     = SF2.F2_LOJA " 
   	cSql += "  join " + RetSqlName("SD2") + " SD2 "
   	cSql += "    on SD2.D_E_L_E_T_ = ' ' "
   	cSql += "   and SD2.D2_FILIAL  = SF2.F2_FILIAL "     
   	cSql += "   and SD2.D2_DOC     = SF2.F2_DOC "  
   	csql += "   and SD2.D2_SERIE   = SF2.F2_SERIE "
   	csql += "   and SD2.D2_CLIENTE = SF2.F2_CLIENTE "
   	csql += "   and SD2.D2_LOJA    = SF2.F2_LOJA " 
   	csql += "   and SD2.D2_GRUPO   = 'CARC' " 
   	cSql += "  join " + RetSqlName("SC6") + " SC6 "
   	cSql += "    on SC6.D_E_L_E_T_ = ' ' "
   	cSql += "   and SD2.D2_PEDIDO  = SC6.C6_NUM "
   	cSql += "   and SD2.D2_ItemPV  = SC6.C6_Item " 
   	cSql += "  join " + RetSqlName("SC2") + " SC2 "
   	cSql += "    on SC2.D_E_L_E_T_ = ' ' "
   	cSql += "   and SC2.C2_FILIAL  = SC6.C6_FILIAL "
   	cSql += "   and SC2.C2_NUM     = SC6.C6_NUMOP "
   	cSql += "   and SC2.C2_ITEM    = SC6.C6_ITEMOP "
   	cSql += "  left join " + RetSqlName("SX5") + " SX5  " 
    cSql += "    on sx5.D_E_L_E_T_  = ' ' "
    cSql += "   and sx5.x5_filial   = '  ' "
    cSql += "   and sx5.x5_tabela   = '43' "              
    cSql += "   and sx5.x5_chave    = SC2.C2_MOTREJE "
   	cSql += " where SF2.D_E_L_E_T_  = ' ' "  
   	cSql += "   and SF2.F2_FILIAL       = '" + xFilial("SF2") + "' "  
   	cSql += "   and SF2.F2_Cliente      = '" + mv_par02       + "' "
   	if empty(mv_par03)     
        cSql += "   and SF2.F2_EMISSAO  = '" + dtos(date())   + "' "
   	else
       	cSql += "   and SF2.F2_EMISSAO >= '" + dtos(mv_par03) + "' "
       	cSql += "   and SF2.F2_EMISSAO <= '" + dtos(mv_par04) + "' "  
   	endif
   	 
   	cSql += " order BY SF2.F2_FILIAL,SF2.F2_CLIENTE,SC2.C2_PRODUTO,SF2.F2_DOC "

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","F2_EMISSAO","D")
	
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

        @Li, 000      PSAY ARQ_SQL->F2_CLIENTE + "-" + ARQ_SQL->F2_LOJA 
        @Li, pcol()+1 PSAY ARQ_SQL->A1_NOME
        @Li, pcol()+1 PSAY ARQ_SQL->C2_PRODUTO
		@Li, pcol()+1 PSAY ARQ_SQL->C2_CARCACA
	    @Li, pcol()+1 PSAY ARQ_SQL->C2_X_DESEN
	    @Li, pcol()+1 PSAY ARQ_SQL->C2_SERIEPN
        @Li, pcol()+1 PSAY ARQ_SQL->C2_NUMFOGO
	    @Li, pcol()+1 PSAY ARQ_SQL->F2_DOC 
	    @Li, pcol()+1 PSAY ARQ_SQL->X5_DESCRI
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
