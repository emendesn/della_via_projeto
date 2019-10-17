#include "rwmake.ch"
#include "topconn.ch"

User Function DFATR82V3()

	Private cString
	Private aOrd 		:= {}
	Private CbTxt       := ""
	Private cDesc1      := "Relatorio de Mapa Diario de Faturamento "
	Private cDesc2      := ""
	Private cDesc3      := ""
	Private cPict       := ""
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 220
	Private tamanho     := "G"
	Private nomeprog    := "DFATR82V3"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private titulo      := "Mapa Diario de Faturamento Por vendedor"
	Private nLin        := 80
	Private nPag		:= 0
	Private Cabec1      := " "
	Private Cabec2      := " "
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private imprime     := .T.
	Private wnrel      	:= "DFATR82"
	Private _cPerg     	:= "DFAT82"

	Private cString 	:= "SF2"

	dbSelectArea("SF2")
	dbSetOrder(1)

	_aRegs:={}

	AAdd(_aRegs,{_cPerg,"01","Da  Data          ","","","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"02","Ate Data          ","","","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"03","Do  Produto       ","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AAdd(_aRegs,{_cPerg,"04","Ate Produto       ","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AAdd(_aRegs,{_cPerg,"05","Do  Cliente       ","","","mv_ch5","C", 6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CLI"})
	AAdd(_aRegs,{_cPerg,"06","Ate Cliente       ","","","mv_ch6","C", 6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CLI"})
	AAdd(_aRegs,{_cPerg,"07","Da  Loja          ","","","mv_ch7","C", 2,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"08","Ate Loja          ","","","mv_ch8","C", 2,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"09","Do  Motorista     ","","","mv_ch9","C", 6,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"10","Ate Motorista     ","","","mv_cha","C", 6,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"11","Do  Vendedor      ","","","mv_chb","C", 6,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"12","Ate Vendedor      ","","","mv_chc","C", 6,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"13","Do  Indicador     ","","","mv_chd","C", 6,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"14","Ate indicador     ","","","mv_che","C", 6,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"15","Filial            ","","","mv_chf","C", 2,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"16","                  ","","","mv_chg","C", 2,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"17","Da Nota Saida     ","","","mv_chh","C", 6,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"18","Ate Nota Saida    ","","","mv_chi","C", 6,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"19","Coeficiente Liq.  ","","","mv_chj","N", 6,4,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"20","Agrupar           ","","","mv_chk","N", 1,0,0,"C","","mv_par20","Motorista","","","","","Vendendor","","","","","Indicador","","","","","","","","","","","","","",""})

	ValidPerg(_aRegs,_cPerg)

	Pergunte(_cPerg,.F.)

	aOrd :={"Por Cod.Produto", "Por Cod.Cliente", "Por Nota Fiscal de Saida","Geral" }

	wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	Processa( {|| ImpRel() } )
Return

Static Function ImpRel()
	LOCAL _cQry
	LOCAL cCod     := cVar := cCodGen := ""
	LOCAL cCodVen  := cCodVen4 := cCodVen5 := ""
	LOCAL cCodCli  := ""
	LOCAL cNota    := ""
	LOCAL _aTam    := _aEstrutura := {}
	LOCAL nOrdem   := aReturn[8]
	LOCAL Titulo   := AllTrim(Titulo) + "  -  " + aOrd[nOrdem]
	LOCAL nTotVlr  := nVlrCons:= nTotCus := nTotDif  := nTtPneu  := nTtCons := nTotRec := 0
	LOCAL nTotTab  := nTotDes := nDescon := nDesconC := nNFReal  := TtNFReal:= 0
	LOCAL nGerVlr  := nGerCus := nGerDif :=	nGerTab  := nGerPneu := nGerCons:= nGerRec := 0
	LOCAL nQtGerCons := nGerDes := 0
	LOCAL cabec1   := "   Coeficiente : "+Alltrim(Str(mv_par19))+"                                                     Periodo de " + DtoC(mv_par01) + " a " + DtoC(mv_par02) + " "
	LOCAL cabec2   := "   Nota   Cod.Cliente Nome do Cliente                   Cod.Serviço         Desc.Serviço            Medida            Banda   Largura   Qtd.  Preco Tab.  DM%  Venda NF  Venda Liq.   Custo   Marg.Contr.  Markup   Coleta "
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 
//                               1         2         3         4         5         6         7         8         9        10        11  
	nOrdem := iif(nOrdem > 2,nOrdem+3,nOrdem)


	IF Select("TRBFAT") > 0
		dbSelectArea("TRBFAT")
		TRBFAT->(dbCloseArea())
	EndIF

	_cQry := "SELECT F2_DOC,    F2_SERIE,   F2_CLIENTE, F2_LOJA,   F2_VEND3,  F2_VEND4,  F2_VEND5, F2_EMISSAO, "
	_cQry += "       D2_TIPO,   D2_COD,     D2_QUANT,   D2_TES,    D2_UM,     D2_GRUPO,  D2_TOTAL, D2_XCSBI, "
	_cQry += "       D2_PEDIDO, D2_ITEM,    D2_ITEMPV,  D2_COD,    D2_PRCVEN, D2_PRUNIT, D2_DESCON, "
	_cQry += "       C6_PRCVEN, C6_VALDESC, C6_NUMOP,   C6_ITEMOP, "
	_cQry += "       B1_DESC,   B1_CUSTD, "  
	_cQry += "       F4_DUPLIC, "
	_cQry += "       A1_NOME, "
	_cQry += "       A3_NOME "
	_cQry += " from " + RetSqlName("SF2") + " SF2 " 
	_cQry += " join " + RetSqlName("SD2") + " SD2 "
	_cQry += "  on SD2.D_E_L_E_T_ = ' ' "
	_cQry += " and D2_FILIAL      = '" + mv_par15 + "' "
	_cQry += " and D2_DOC         = F2_DOC "
	_cQry += " and D2_Serie       = F2_Serie "
	_cQry += " and D2_COD between '" + mv_par03 + "' and '" + mv_par04 + "' "
	IF nOrdem = 1  //Por Produto
		_cQry += " and D2_GRUPO  <> 'CARC' "  
	Endif
	If nOrdem = 7
		_cQry += " and D2_TES    <> '903' "
	Else
		_cQry += " and D2_TES    <> '556' "
	EndIF                                     
	_cQry += "join " + RetSqlName("SF4") + " SF4 "
	_cQry += "  on SF4.D_E_L_E_T_ = '' "  
	_cQry += " and F4_FILIAL      = '' "
	_cQry += " and F4_CODIGO      = D2_TES  "
	_cQry += "join " + RetSqlName("SC6") + " SC6 "
	_cQry += "  on SC6.D_E_L_E_T_ = ' ' "
	_cQry += " and C6_Filial      = D2_Filial "
	_cQry += " and C6_NUM         = D2_PEDIDO "
	_cQry += " and C6_ITEM        = D2_ITEMPV "
	_cQry += "join " +  RetSqlName("SB1") + " SB1 "
	_cQry += "  on SB1.D_E_L_E_T_ = '' "
	_cQry += " and B1_FILIAL      = '" + xFilial("SB1") + "' "
	_cQry += " and B1_COD         = D2_COD "        
	_cQry += "join " +  RetSqlName("SA1") + " SA1  "
	_cQry += "  on SA1.D_E_L_E_T_ = '' "  
	_cQry += " and A1_FILIAL      = '' "
	_cQry += " and A1_COD         = F2_CLIENTE  "
	_cQry += " and A1_LOJA        = F2_LOJA  "
	_cQry += "left join " + RetSqlName("SA3") + " SA3 "
	_cQry += "  on SA3.D_E_L_E_T_ = '' "
	_cQry += " and SA3.A3_FILIAL  = '' "
	If mv_par20 = 1
		_cQry += " and SA3.A3_COD = SF2.F2_VEND3 "
	ElseIf mv_par20 = 2
		_cQry += " and SA3.A3_COD = SF2.F2_VEND4 "
	ElseIf mv_par20 = 3
		_cQry += " and SA3.A3_COD = SF2.F2_VEND5 "
	EndIf
	
	_cQry += " where SF2.D_E_L_E_T_ = '' "
	_cQry += "   and F2_FILIAL      = '" + mv_par15       + "' "
	_cQry += "   and F2_EMISSAO     between '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' "
	_cQry += "   and F2_DOC         between '" + mv_par17       + "' and '" + mv_par18       + "' "
	_cQry += "   and F2_CLIENTE     between '" + mv_par05       + "' and '" + mv_par06       + "' "
	_cQry += "   and F2_LOJA        between '" + mv_par07       + "' and '" + mv_par08       + "' "
	_cQry += "   and F2_TIPO        = 'N' "

	If mv_par20 = 1
		_cQry += " AND F2_VEND3 BETWEEN '"+mv_par09        + "' AND '" + mv_par10       + "'"
	Elseif mv_par20 = 2
		_cQry += " AND F2_VEND4 BETWEEN '"+mv_par11        + "' AND '" + mv_par12       + "'"
	Elseif mv_par20 = 3
		_cQry += " AND F2_VEND5 BETWEEN '"+mv_par13        + "' AND '" + mv_par14       + "'"
	Endif
	IF nOrdem = 1  //Por Produto
		_cQry += " order by D2_COD "
	ElseIF nOrdem = 2  //Por Cod.Cliente
		_cQry += " order by F2_CLIENTE "
	ElseIF nOrdem = 6  //Por Nota Fiscal de Saida
		_cQry += " order by F2_DOC "
	ElseIF nOrdem = 7  //Geral
		_cQry += " order by D2_GRUPO  "
	EndIF

	_cQry := ChangeQuery(_cQry)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRBFAT",.F.,.T.)

	TcSetField("TRBFAT", "F2_EMISSAO", "D")

	dbSelectArea("TRBFAT")
	dbGoTop()

	_aEstrutura := {}

	_aTam := TamSX3("D2_COD")
	aAdd(_aEstrutura,{"TMP_COD"     ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("F2_DOC")
	aAdd(_aEstrutura,{"TMP_DOC"     ,"C",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_EMISSA" ,"D",8})
	_aTam := TamSX3("D2_ITEM")
	aAdd(_aEstrutura,{"TMP_D2ITEM"  ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("F2_SERIE")
	aAdd(_aEstrutura,{"TMP_SERIE"   ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("F2_CLIENTE")
	aAdd(_aEstrutura,{"TMP_CLI"     ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("A1_NOME")
	aAdd(_aEstrutura,{"TMP_NOME"    ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("B1_DESC")
	aAdd(_aEstrutura,{"TMP_DESC"    ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("B1_PRODUTO")
	aAdd(_aEstrutura,{"TMP_PROD"    ,"C",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_BANDA"   ,"C",10,0})
	aAdd(_aEstrutura,{"TMP_LARG"    ,"N",5,0})
	_aTam := TamSX3("D2_QUANT")
	aAdd(_aEstrutura,{"TMP_QUANT"   ,"N",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_PRCTB"   ,"N",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_DM"      ,"N",8,2})
	_aTam := TamSX3("D2_PEDIDO")
	aAdd(_aEstrutura,{"TMP_PED"     ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("D2_ITEMPV")
	aAdd(_aEstrutura,{"TMP_ITPV"    ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("D2_ITEMPV")
	aAdd(_aEstrutura,{"TMP_ITEM"    ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("F2_VEND3")
	aAdd(_aEstrutura,{"TMP_VEND"    ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("A3_NOME")
	aAdd(_aEstrutura,{"TMP_NOMEV"   ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("D2_TES")
	aAdd(_aEstrutura,{"TMP_TES"     ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("B1_CUSTD")
	aAdd(_aEstrutura,{"TMP_CUSTD"   ,"N",_aTam[1],_aTam[2]})
	_aTam := TamSX3("D2_GRUPO")
	aAdd(_aEstrutura,{"TMP_GRUPO"   ,"C",_aTam[1],_aTam[2]})
	_aTam := TamSX3("D2_PRCVEN")
	aAdd(_aEstrutura,{"TMP_COEF"    ,"N",_aTam[1],_aTam[2]})
	aAdd(_aEstrutura,{"TMP_MARK"    ,"N",_aTam[1],_aTam[2]})
	_aTam := TamSX3("D2_TOTAL")
	aAdd(_aEstrutura,{"TMP_PRECO"   ,"N",_aTam[1],_aTam[2]})
	_aTam := TamSX3("D2_DESCON")
	aAdd(_aEstrutura,{"TMP_DESCO"   ,"N",_aTam[1],_aTam[2]})
	_aTam := TamSX3("F4_DUPLIC")
	aAdd(_aEstrutura,{"TMP_DUPLIC"  ,"C",_aTam[1],_aTam[2]})  
	_aTam := TamSX3("C6_NUMOP")
	aAdd(_aEstrutura,{"TMP_NUMOP"   ,"C",_aTam[1],_aTam[2]})  
	_aTam := TamSX3("C6_ITEMOP")
	aAdd(_aEstrutura,{"TMP_ITEMOP"  ,"C",_aTam[1],_aTam[2]})  
	

	cNomArq := CriaTrab(_aEstrutura,.T.)

	dbUseArea(.T.,,cNomArq,"TMP",.T.,.F.)

	dbSelectArea("TMP")
	IF nOrdem = 1
		IndRegua("TMP",cNomArq,"TMP_VEND+TMP_COD+Descend(Strzero(TMP_COEF,11,2))",,,"Selecionando Registros")
	ElseIF nOrdem = 2
		IndRegua("TMP",cNomArq,"TMP_VEND+TMP_CLI+Descend(Strzero(TMP_COEF,11,2))",,,"Selecionando Registros")
	ElseIF nOrdem = 6
		IndRegua("TMP",cNomArq,"TMP_VEND+TMP_DOC+Descend(Strzero(TMP_COEF,11,2))",,,"Selecionando Registros")
	ElseIF nOrdem = 7
		IndRegua("TMP",cNomArq,"TMP_VEND+TMP_GRUPO+Descend(Strzero(TMP->TMP_COEF,11,2))+Descend(Strzero(TMP->TMP_PRECO,11,2))",,,"Selecionando Registros")
	EndIF

	//dbSetIndex(cNomArq+OrdbagExt())

	dbSelectArea("TRBFAT")

	ProcRegua(0)
	incProc("Carregando temporario...")
	While ! Eof()

		if Reclock("TMP",.T.)
			TMP->TMP_COD    := TRBFAT->D2_COD
			TMP->TMP_DOC    := TRBFAT->F2_DOC
			TMP->TMP_EMISSA := TRBFAT->F2_EMISSAO
			TMP->TMP_D2ITEM := TRBFAT->D2_ITEM
			TMP->TMP_SERIE  := TRBFAT->F2_SERIE
			TMP->TMP_CLI    := TRBFAT->F2_CLIENTE
			TMP->TMP_NOME   := LEFT(Alltrim(TRBFAT->A1_NOME),30)
			TMP->TMP_DESC   := Substr(Alltrim(TRBFAT->B1_DESC),1,20)
			TMP->TMP_QUANT  := TRBFAT->D2_QUANT
			TMP->TMP_PRCTB  := iif(TRBFAT->D2_PRUNIT<=0,TRBFAT->D2_TOTAL,TRBFAT->D2_PRUNIT*TRBFAT->D2_QUANT)
			TMP->TMP_PED    := TRBFAT->D2_PEDIDO
			TMP->TMP_ITPV   := TRBFAT->D2_ITEMPV
			TMP->TMP_NUMOP  := TRBFAT->C6_NUMOP
			TMP->TMP_ITEMOP := TRBFAT->C6_ITEMOP
			TMP->TMP_VEND   := IIF(mv_par20 = 1,TRBFAT->F2_VEND3,IIF(mv_par20 = 2,TRBFAT->F2_VEND4,IIF(mv_par20 = 3,TRBFAT->F2_VEND5,"")))
			TMP->TMP_NOMEV  := Alltrim(TRBFAT->A3_NOME)
			TMP->TMP_TES    := TRBFAT->D2_TES                
			TMP->TMP_DUPLIC := TRBFAT->F4_DUPLIC
			TMP->TMP_GRUPO  := TRBFAT->D2_GRUPO           
			Do case
				Case AllTrim(TRBFAT->D2_GRUPO) = "SERV" 
					cSql := "SELECT C2_PRODUTO,D3_COD,SUM(G1_XCSBI) AS CUSTD, B1_XLARG " 
  					cSql += "  FROM SC2030 SC2 " 
  		    		cSql += "  LEFT JOIN SD3030 SD3 "    
            		cSql += "    ON SD3.D_E_L_E_T_                 = '' " 
            		cSql += "   AND SD3.D3_FILIAL                  = C2_FILIAL "
            		cSql += "   AND SD3.D3_OP                      = C2_NUM || C2_ITEM || C2_SEQUEN "   
    				cSql += "   AND SD3.D3_ESTORNO                 = '' "
    				cSql += "   AND SD3.D3_GRUPO                   = 'BAND' "    
    				cSql += "  LEFT JOIN SB1030 SB1 "    
            		cSql += "    ON SB1.D_E_L_E_T_                 = '' "
            		cSql += "   AND SB1.B1_FILIAL                  = '' "     
    				cSql += "   AND SB1.B1_COD                     = D3_COD "     
    				cSql += "  LEFT JOIN SG1030 SG1"
    				cSql += "    ON SG1.D_E_L_E_T_                 = '' "       			
    				cSql += "   AND SG1.G1_FILIAL                  = '' "     
    				cSql += "   AND SG1.G1_COD                     = C2_PRODUTO "
            		cSql += "   AND SG1.G1_COMP                    = D3_COD  "                  
            		cSql += "   AND D3_EMISSAO BETWEEN SG1.G1_INI AND SG1.G1_FIM "
            		cSql += " WHERE SC2.D_E_L_E_T_                 = '' " 
    				cSql += "   AND SC2.C2_FILIAL                  = '" + mv_par15                    + "' " 
    				cSql += "   AND SC2.C2_NUM					   = '" + TRBFAT->C6_NUMOP               + "' "
    				cSql += "   AND SC2.C2_ITEM                    = '" + TRBFAT->C6_ITEMOP              + "' "
    				cSql += "   AND SC2.C2_SEQUEN                  = '001' "
                	cSql += " GROUP BY C2_PRODUTO,D3_COD,B1_XLARG "       
					cSql := ChangeQuery(cSql)                                               
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"ARQ_SQL",.F.,.T.)                            
					TcSetField("ARQ_SQL", "CUSTD", "N",14,4)
					dbSelectArea("ARQ_SQL")
					dbGoTop() 
					TMP->TMP_PROD   := ARQ_SQL->C2_PRODUTO
					TMP->TMP_BANDA  := ARQ_SQL->D3_COD
					TMP->TMP_LARG   := ARQ_SQL->B1_XLARG
					//TMP->TMP_CUSTD  := TMP->TMP_CUSTD + ARQ_SQL->CUSTD 
					TMP->TMP_CUSTD  := TRBFAT->D2_XCSBI
					dbSelectArea("ARQ_SQL")
					dbCloseArea("ARQ_SQL")
				Case AllTrim(TRBFAT->D2_GRUPO) $ "CI/SC"
					cSql := "SELECT B1_PRODUTO, G1_XCSBI " 
  					cSql += "  FROM SB1030 SB1 "    
                    cSql += "  JOIN SG1030 SG1"
    				cSql += "    ON SG1.D_E_L_E_T_                 = '' "       			
    				cSql += "   AND SG1.G1_FILIAL                  = '' "     
    				cSql += "   AND SG1.G1_COD                     = 'MANC' "
            		cSql += "   AND SG1.G1_COMP                    = SB1.B1_PRODUTO  "                  
            		cSql += "   AND '" + DTOS(TRBFAT->F2_EMISSAO) + "' BETWEEN SG1.G1_INI AND SG1.G1_FIM "
            		cSql += " WHERE SB1.D_E_L_E_T_                 = '' " 
            		cSql += "   AND SB1.B1_FILIAL                  = '" + xFilial("SB1") + "' "
            		cSql += "   AND SB1.B1_COD                     = '" + TRBFAT->D2_COD + "' "   
            		cSql := ChangeQuery(cSql)                                               
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"ARQ_SG1",.F.,.T.)                            
					TcSetField("ARQ_SG1", "G1_XCSBI", "N",14,4)
					dbSelectArea("ARQ_SG1")
					dbGoTop() 
					If eof()
						TMP->TMP_PROD   := TRBFAT->D2_COD
					Else
					   	TMP->TMP_PROD   := ARQ_SG1->B1_PRODUTO
					EndIf
					//TMP->TMP_CUSTD  := TRBFAT->F2_QUANT * ARQ_SG1->G1_XCSBI    
					TMP->TMP_CUSTD  := TRBFAT->D2_XCSBI
					TMP->TMP_BANDA  := ""
					TMP->TMP_LARG   := 0   
					dbSelectArea("ARQ_SG1")
					dbCloseArea("ARQ_SG1")
				Otherwise               
			    	TMP->TMP_PROD   := TRBFAT->D2_COD
					TMP->TMP_CUSTD  := TRBFAT->B1_CUSTD
					TMP->TMP_BANDA  := ""
					TMP->TMP_LARG   := 0
			EndCase
						
			TMP->TMP_PRECO   := IIF(TRBFAT->D2_TES=='903',0,TRBFAT->D2_TOTAL)  //IIF( cGrupo <> "ATEC",,TRBFAT->C6_PRCVEN) //D2_TOTAL+TRBFAT->D2_DESCON
			TMP->TMP_DESCO   := TRBFAT->D2_DESCON //TRBFAT->C6_VALDESC                   //IIF( cGrupo <> "ATEC",,0) //TRBFAT->D2_DESCON
			IF TMP->TMP_PRCTB > 0
				IF TMP->TMP_PRECO > TMP->TMP_PRCTB
					TMP->TMP_DM      :=Round(Abs(((TMP->TMP_PRECO/TMP->TMP_PRCTB)-1)*100),2)
				Else
					IF TMP->TMP_PRECO != 0.01
						TMP->TMP_DM      := Round((((TMP->TMP_PRECO/TMP->TMP_PRCTB)-1)*100)*-1,2)
					Else
						TMP->TMP_DM      :=Round(-9999,2)
					EndIF
				EndIF
			Else
				TMP->TMP_DM      := 0
			EndIF
			TMP->TMP_COEF    := (TMP->TMP_PRECO*mv_par19) - TMP->TMP_CUSTD
			TMP->TMP_MARK    := (TMP->TMP_PRECO*mv_par19) / TMP->TMP_CUSTD
				
			MsUnlock()
		Endif

		dbSelectArea("TRBFAT")
		TRBFAT->(dbSkip())
	EndDo
	incProc("Temporario Gerado...")
	dbSelectArea("TRBFAT")
	dbCloseArea()

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGotop()


	nLin := 99
	While ! Eof()
		cChave := TMP_VEND
		cNotaSEPU := ""
		aResumoSEPU := {}
		
		IF nLin > 55
			nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin += 2
		EndIF

		nLin += 2
		@ nLin,000 PSAY iif(mv_par20=1,"Motorista: ",iif(mv_par20=2,"Vendedor: ","Indicador: "))+TMP_VEND+" - "+TMP_NOMEV
		nLin += 2
		incProc("Imprimindo...")
		Do While !eof() .AND. TMP_VEND = cChave
		
			IF TMP->TMP_TES = '594'
				dbSkip()
				Loop
			Endif
			
			SB1->(dbSetOrder(1))
			SB1->( dbSeek(xFilial("SB1") + TMP->TMP_COD,.F.) )
	
			If  TMP->TMP_GRUPO == "CARC"
				SC6->( dbSeek(xFilial("SC6") +TMP->TMP_PED+TMP->TMP_ITPV ,.F.) )
				SC2->( dbSeek(xFilial("SC2") + SC6->C6_NFORI+Substr(SC6->C6_ITEMORI,3,2),.F.) )
				cOP := SC2->C2_NUM+SC2->C2_ITEM
	
				nServico := 0
				While !Eof() .And. xFilial("SC6")==SC6->C6_FILIAL .And. TMP->TMP_PED == SC6->C6_NUM
					SB1->( dbSeek(xFilial("SB1") + SC6->C6_PRODUTO,.F.) )		
					If Alltrim(Upper(SB1->B1_GRUPO)) == "SERV" .AND. SC6->C6_NUMOP+SC6->C6_ITEMOP == cOP
						SF4->( dbSeek(xFilial("SF4") + SC6->C6_TES,.F.) )
						If SF4->F4_DUPLIC == "S" .and. SF4->F4_ESTOQUE = 'N'
							nServico := SC6->C6_VALOR 
						EndIf				
						Exit
					Endif
					SC6->(dbSkip())
				EndDo		
				IF nServico != 0
					nTtPneu  += 1
					nGerPneu += 1
				EndIF
				SC6->( dbSeek(xFilial("SC6") + TMP->TMP_PED+Strzero(Val(TMP->TMP_ITPV)+1,2) ,.F.) )
				IF SC6->C6_TES == '903'
					nTotRec += TMP->TMP_QUANT
					nGerRec += TMP->TMP_QUANT
				EndIF	
			EndIf	
	
			IF lEnd
				@ nLin, 001 Psay "Cancelado pelo operador "
				Exit
			EndIF

			IF nLin > 55
				nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
				nLin += 2
			EndIF
	
			IF nOrdem = 1 .and. TMP->TMP_COD != cCodGen
				nLin ++
				@ nLin, 003 Psay 'Faturamento do Produto : '+ TMP->TMP_COD+' -  '+TMP->TMP_DESC
				cCodGen := TMP->TMP_COD
				nLin := nLin + 2
			EndIF
			IF nOrdem = 2 .and. TMP->TMP_CLI != cCodGen
				nLin ++
				@ nLin, 003 Psay 'Faturamento do Cliente : '+ TMP->TMP_CLI + ' ' + TMP->TMP_NOME
				cCodGen := TMP->TMP_CLI
				nLin := nLin + 2
			EndIF
			IF nOrdem = 6 .and. TMP->TMP_DOC != cCodGen
				nLin ++
				@ nLin, 003 Psay 'Faturamento da Nota : ' + TMP->TMP_DOC
				cCodGen := TMP->TMP_DOC
				nLin := nLin + 2
			EndIF
	
			IF nOrdem = 7 .and. TMP->TMP_GRUPO != cCodGen
				IF Trim(TMP->TMP_GRUPO) != "CARC"
					nLin ++
					SBM->(dbSetOrder(1))
					SBM->(dbSeek(xFilial("SBM")+TMP->TMP_GRUPO ) )
					@ nLin, 003 Psay 'Faturamento do Grupo : ' + IIF(Trim(TMP->TMP_GRUPO) $ "CI/SC", "Conserto",Trim(SBM->BM_DESC) )
					cCodGen := TMP->TMP_GRUPO
					nLin := nLin + 2
				EndIF
			EndIF

			@ nLin, 003 Psay TMP->TMP_DOC+"/"+TMP->TMP_D2ITEM
			@ nLin, 013 Psay TMP->TMP_CLI
			@ nLin, 023 Psay Alltrim(TMP->TMP_NOME)
			@ nLin, 057 Psay TMP->TMP_COD
			@ nLin, 075 Psay TMP->TMP_DESC  //2
			@ nLin, 100 Psay TMP->TMP_PROD  //13
			@ nLin, 120 Psay TMP->TMP_BANDA //10
			If TMP->TMP_LARG > 0
				@ nLin, 130 Psay TMP->TMP_LARG  //10
	        Endif
			
			@ nLin, 136 Psay TMP->TMP_QUANT Picture "@E 999"
			
			IF TMP->TMP_TES == '903'
				@ nLin, 159 Psay "RECUSADO"
			Else
				@ nLin, 141 Psay TMP->TMP_PRCTB 				            Picture "@E 99,999.99"
				@ nLin, 150 Psay TMP->TMP_DM    				            Picture "@E 99999.99" //2
				If TMP->TMP_PRECO > 0
					@ nLin, 159 Psay TMP->TMP_PRECO  			            Picture "@E 99,999.99" //2
					@ nLin, 168 Psay TMP->TMP_PRECO*mv_par19 	            Picture "@E 99,999.99" //Coeficiente.
				Endif
				If TMP->TMP_CUSTD > 0
					@ nLin, 178 Psay TMP->TMP_CUSTD 			            Picture "@E 99,999.99" //Custo
				EndIf                                          
				@ nLin, 188 Psay TMP->TMP_PRECO*mv_par19 - TMP->TMP_CUSTD            Picture "@E 99,999.99" //margem
				
				@ nLin, 203 Psay (TMP->TMP_PRECO*mv_par19) / TMP->TMP_CUSTD Picture "@E 999.99"    //Markup 
			
				IF TMP->TMP_DUPLIC = "S"
					nTotVlr  += TMP->TMP_PRECO 
					nGerVlr  += TMP->TMP_PRECO 
					nDescon  += TMP->TMP_DESCO 
					nDesconC += TMP->TMP_DESCO 
					nNFReal  += TMP->TMP_PRECO + TMP->TMP_DESCO
					TtNFReal += TMP->TMP_PRECO + TMP->TMP_DESCO
				
					nTotCus += TMP->TMP_CUSTD
					nTotDif += TMP->TMP_PRECO*mv_par19 - TMP->TMP_CUSTD
					nTotTab += TMP->TMP_PRCTB
	
					nGerCus += TMP->TMP_CUSTD
					nGerDif += TMP->TMP_PRECO*mv_par19 - TMP->TMP_CUSTD
					nGerTab += TMP->TMP_PRCTB
				EndIF
			EndIF   
			If !empty(TMP->TMP_NUMOP)
				@ nLin, 213 Psay TMP->TMP_NUMOP + "/" + TMP->TMP_ITEMOP
			Else
				@ nLin, 213 Psay TMP->TMP_PED   + "/" + TMP->TMP_ITPV
			Endif
			nLin ++
			IF TMP->TMP_TES == '903' .and. ! Trim(TMP->TMP_GRUPO) $ "CI/SC"
				SC6->(dbSetOrder(1))
				SC6->(dbSeek(xFilial("SC6") + TMP->TMP_PED + TMP->TMP_ITEM ) )
	
				SC2->(dbSetOrder(1))
				SC2->(dbSeek(xFilial("SC2") + SC6->C6_NUMOP + SC6->C6_ITEMOP + "001" ) )
			EndIF 
	
			IF Trim(TMP->TMP_GRUPO) $ 'CI/SC'
				IF TMP->TMP_TES != '903'
					nTtCons     += TMP->TMP_QUANT
					nQtGerCons  += TMP->TMP_QUANT
				EndIF	
				IF TMP->TMP_DUPLIC = "S"
					nVlrCons   += TMP->TMP_PRECO
					nGerCons   += TMP->TMP_PRECO
				EndIF	
			EndIF
	
			if !(TMP->TMP_DOC+TMP->TMP_SERIE $ cNotaSEPU)
				cNotaSepu += TMP->TMP_DOC+TMP->TMP_SERIE+"*"
				cSqlSepu := ""
				cSqlSepu += " SELECT E1_MOTDESC,ZS_DESCR,SUM(E5_VALOR) AS VALOR"
				cSqlSepu += " FROM "+RetSqlName("SE5")+" SE5"

				cSqlSepu += " JOIN "+RetSqlName("SE1")+" SE1"
				cSqlSepu += " ON   SE1.D_E_L_E_T_ = ''"
				cSqlSepu += " AND  E1_FILIAL = E5_FILIAL"
				cSqlSepu += " AND  E1_PREFIXO = E5_PREFIXO"
				cSqlSepu += " AND  E1_NUM = E5_NUMERO"
				cSqlSepu += " AND  E1_PARCELA = E5_PARCELA"

				cSqlSepu += " LEFT JOIN "+RetSqlName("SZS")+" SZS"
				cSqlSepu += " ON   SZS.D_E_L_E_T_ = ''"
				cSqlSepu += " AND  ZS_FILIAL = '"+xFilial("SZS")+"'"
				cSqlSepu += " AND  ZS_COD = E1_MOTDESC"

				cSqlSepu += " WHERE SE5.D_E_L_E_T_ = ''"
				cSqlSepu += " AND   E5_FILIAL = '  '"
				cSqlSepu += " AND   E5_BANCO = 'SEP'"
				cSqlSepu += " AND   E5_AGENCIA = '00001'"
				cSqlSepu += " AND   E5_CONTA = '0000000001'"
				cSqlSepu += " AND   E5_NUMCHEQ = '"+AllTrim(TMP->TMP_SERIE)+"' || '"+AllTrim(TMP->TMP_DOC)+"'"
				cSqlSepu += " GROUP BY E1_MOTDESC,ZS_DESCR"
				cSqlSepu += " ORDER BY E1_MOTDESC"

				cSqlSepu := ChangeQuery(cSqlSepu)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cSqlSepu),"ARQ_SEPU", .T., .T.)
				TcSetField("ARQ_SEPU","VALOR","N",14,2)
				
				dbSelectArea("ARQ_SEPU")
				dbGoTop()
				Do while !eof()
					nPos := aScan(aResumoSepu, { |x| AllTrim(x[1]) == AllTrim(ARQ_SEPU->E1_MOTDESC) })
					If nPos > 0
						aResumoSepu[nPos,3] += ARQ_SEPU->VALOR
					Else
						aadd(aResumoSepu,{ARQ_SEPU->E1_MOTDESC,ARQ_SEPU->ZS_DESCR,ARQ_SEPU->VALOR})
					Endif
					dbskip()
				Enddo
				dbSelectArea("ARQ_SEPU")
				dbCloseArea()
			Endif

			dbSelectArea("TMP")
			TMP->(dbSkip())
	
			IF nOrdem != 7
				cVar := IIF(nOrdem = 1,TMP_COD,IIF(nOrdem = 2,TMP->TMP_CLI,IIF(Alltrim(Str(nOrdem)) $ '3/4/5',TMP->TMP_VEND,;
				IIF(nOrdem = 5,TMP->TMP_VEND5,TMP->TMP_DOC))))
			ElseIF 	nOrdem == 7
				cVar := TMP->TMP_GRUPO		
			EndIF
	
			IF cVar != cCodGen  .or. eof() .or. TMP_VEND <> cChave // Totalizadores  bof() -->> eof()
				//IF cVar != "CARC" .and. (nOrdem == 7 .OR. nOrdem== 6)
				IF cCodGen != "CARC" .and. (nOrdem == 7 .OR. nOrdem== 6)
					IF nTotTab > 0
						IF nTotVlr > nTotTab
							nTotDes := Abs(((nTotVlr/nTotTab)-1)*100)
							nGerDes += Abs(((nTotVlr/nTotTab)-1)*100)
						Else
							nTotDes := (((nTotVlr/nTotTab)-1)*100)*-1
							nGerDes += (((nTotVlr/nTotTab)-1)*100)*-1
						EndIF
					Else
						nTotDes := 0
					EndIF
					nLin := nLin + 2
					@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)    Desc.Concedido                    Tt.NF Real   "
					@ nLin, 128 Psay "Preco Tab.     DM%      Total NF      Tt.Venda Liq.     Custo         Marg.Contr.  Markup "
					nLin ++
					@ nLin, 005 Psay nTtPneu
					@ nLin, 022 Psay nTtCons
					@ nLin, 039 Psay nVlrCons Picture "@E 99,999,999.99"
					@ nLin, 065 Psay nTotRec
					@ nLin, 077 Psay nDescon Picture "@E 99,999,999.99"
					@ nLin, 107 Psay nNFReal Picture "@E 99,999,999.99"
					@ nLin, 124 Psay nTotTab Picture "@E 99,999,999.99"          //Preco de Tabela
					@ nLin, 138 Psay nTotDes Picture "@E 9999.9999"              //Desconto Medio
					@ nLin, 147 Psay nTotVlr Picture "@E 99,999,999.99"          //Preco de venda
					@ nLin, 165 Psay nTotVlr*mv_par19 Picture "@E 99,999,999.99" //Tabela=Coeficiente
					@ nLin, 179 Psay nTotCus Picture "@E 9,999,999.99" //Custo
					@ nLin, 195 Psay nTotDif Picture "@E 9,999,999.99" //Diferenca
					@ nLin, 209 Psay (nTotVlr*mv_par19)/nTotCus Picture "@E 999.9999" //MarkUp
	
					nTotVlr := nTotCus := nTotDif := nTtPneu := nTotRec := nTtCons := nVlrCons := nTotTab := nDescon:= nNFReal :=0
	
					nLin ++
				EndIF
			EndIF
		Enddo
		

		nLin++
		IF nLin > 55
			nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin += 2
		EndIF
		@nLin  ,001 PSAY "Resumo SEPU"
		@nLin+1,001 PSAY Replicate("-",68)
		nLin:=nLin+2

		nTotSepu := 0
		aResumoSepu := aSort(aResumoSepu,,, { |x, y| x[1] < y[1] })
		For k=1 to Len(aResumoSepu)
			IF nLin > 55
				nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
				nLin += 2
			EndIF
			@ nLin,001 PSAY aResumoSepu[k,1]+"-"+Subst(aResumoSepu[k,2],1,50)
			@ nLin,055 PSAY aResumoSepu[k,3] PICTURE "@E 999,999,999.99"
			nLin++
			nTotSepu += aResumoSepu[k,3]
		Next k
		nLin++
		@nLin,001 PSAY "Total Sepu"
		@nLin,055 PSAY nTotSepu PICTURE "@E 999,999,999.99"
		nLin+=2
	EndDo

	IF nLin != 80
		IF nLin > 55
			nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin += 2
		EndIF
		nLin ++
		@ nLin, 001 Psay "Total Geral: "

		nLin := nLin + 2

		IF nGerTab > 0
			IF nGerVlr > nGerTab  //nTotVlr > nTotTab
				nGerDes := Abs(((nGerVlr/nGerTab)-1)*100)
			Else
				nGerDes :=(((nGerVlr/nGerTab)-1)*100)*-1
			EndIF
		Else
			nGerDes := 0
		EndIF

		@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)    Desc.Concedido                    Tt.NF Real   "
		@ nLin, 128 Psay "Preco Tab.     DM%      Total NF      Tt.Venda Liq.     Custo         Marg.Contr.  Markup "
		nLin ++
		@ nLin, 005 Psay nGerPneu
		@ nLin, 022 Psay nQtGerCons
		@ nLin, 039 Psay nGerCons Picture "@E 99,999,999.99"
		@ nLin, 065 Psay nGerRec
		@ nLin, 077 Psay nDesconC Picture "@E 99,999,999.99"
		@ nLin, 107 Psay TtNFReal Picture "@E 99,999,999.99"
		@ nLin, 124 Psay nGerTab Picture "@E 99,999,999.99"          //Preco de Tabela
		@ nLin, 138 Psay nGerDes Picture "@E 9999.9999"              //Desconto Medio
		@ nLin, 147 Psay nGerVlr Picture "@E 99,999,999.99"          //Preco de venda
		@ nLin, 165 Psay nGerVlr*mv_par19 Picture "@E 99,999,999.99" //Tabela=Coeficiente
		@ nLin, 179 Psay nGerCus Picture "@E 9,999,999.99" //Custo
		@ nLin, 195 Psay nGerDif Picture "@E 9,999,999.99" //Diferenca
		@ nLin, 209 Psay (nGerVlr*mv_par19)/nGerCus Picture "@E 999.9999" //MarkUp
	
		Roda(cbcont,cbtxt,"G")
	EndIF

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomArq+GetDBExtension())
	fErase(cNomArq+OrdbagExt())

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	EndiF

	MS_FLUSH()
Return