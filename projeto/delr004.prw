#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELR004  บAutor  ณRicardo Mansano     บ Data ณ  23/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Seguros vendidos                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Chamado via Menu.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบMarcio Domณ20/12/06ณ      ณQuebra de totais por Categoria e Especie 	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบMarcelo A ณ03/01/06ณ      ณacrecentado cabecalho com totalizadores por บฑฑ
ฑฑบ          ณ        ณ      ณquera de categoria.                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELR004()
//User Function DELR004B()

Local cQuery     	:= ""
Local aOrd       	:= {}
Local cDesc1     	:= "Este programa eh responsavel pela"
Local cDesc2     	:= "geracao do Relatorio de Seguros"
Local cDesc3     	:= ""
Private cbtxt    	:= Space(10)
Private cbcont   	:= 00
Private cTitulo  	:= "Seguros Vendidos"
Private m_pag    	:= 01  // Pagina Inicial (deve constar em todos os relatorios)
Private cPerg    	:= "DEL004"
Private nNomeProg 	:= "DEL004"
Private cString  	:= "SL1"
Private aReturn  	:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private wnrel    	:= nNomeProg
Private cTamanho  	:= "P" // "P"equeno "M"edio "G"rande
Private nTipo    	:= 18  // 15=Comprimido 18=Normal


// Impede Execucao em Ambiente Codebase
#IFDEF TOP
#ELSE
	Aviso("Aten็ใo !","Relatorio s๓ pode ser executado na Matriz - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
	Return Nil
#ENDIF

// Ajusta Perguntas
PutSx1(cPerg,"01","Da Loja                   ?","","","mv_ch1" ,"C",02,0,0,"G","","SM0","","","MV_PAR01"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"02","Ate a Loja                ?","","","mv_ch2" ,"C",02,0,0,"G","","SM0","","","MV_PAR02"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSX1(cPerg,"03","Da data de Emissao        ?","","","mv_ch3" ,"D",08,0,0,"G","",""   ,"","","MV_PAR03"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"04","Ate a data de Emissao     ?","","","mv_ch4" ,"D",08,0,0,"G","",""   ,"","","MV_PAR04"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSx1(cPerg,"05","Do codigo do Produto      ?","","","mv_ch5" ,"C",15,0,0,"G","","SB1","","","MV_PAR05"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"06","Ate o codigo do Produto   ?","","","mv_ch6" ,"C",15,0,0,"G","","SB1","","","MV_PAR06"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"07","Da Grupo                  ?","","","mv_ch7" ,"C",04,0,0,"G","","SBM","","","MV_PAR07"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"08","Ate o Grupo               ?","","","mv_ch8" ,"C",04,0,0,"G","","SBM","","","MV_PAR08"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
Pergunte(cPerg,.F.)

// Variaveis utilizadas para Impresso do Cabealho e Rodap (Obrigatorias)
cbtxt    := SPACE(10)
cbcont   := 0
Li       := 80
m_pag    := 1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa Relatorio  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,nNomeProg,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,cTamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| StaticRel(@lEnd,wnRel,cString,cTamanho,nTipo)},cTitulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStaticRel บAutor  ณRicardo Mansano     บ Data ณ  03/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณImpressao dos dados do relatorio                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Utilizada pela rotina principal deste programa             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function StaticRel(lEnd,wnRel,cString,cTamanho,nTipo)
Local cAliasTRB 	:= "TRB" // Alias para vendas de Doacao por periodo
Local nX			:= 0
Local nZ			:= 0
Local aStrucTRB		:= SL1->(dbStruct())
Local aDados  		:= {}
Local nPIOF        	:= GetMV("FS_DEL022") // Percentual de IOF
Local nCustoApolice	:= GetMV("FS_DEL023") // Custo da ap๓lice (valor em reais)
Local nPComiss     	:= GetMV("FS_DEL024") // Percentual de comissใo bruta
Local nPIRRF       	:= GetMV("FS_DEL025") // Percentual de IRRF
Local nPISS        	:= GetMV("FS_DEL026") // Percentual de ISS
Local nPMargVCS    	:= GetMV("FS_DEL027") // Percentual de margem VCS
Local nVlrIOF		:= 0
Local nVlrApolice	:= 0
Local nVlrComBruta	:= 0
Local nVlrIRRF		:= 0
Local nVlrISS      	:= 0

// Totalizadores
Local nTotProQtd 	:= 0
Local nTotProVlr 	:= 0
Local nTotEspQtd 	:= 0
Local nTotEspVlr 	:= 0
Local nTotCatQtd 	:= 0
Local nTotCatVlr 	:= 0
Local nTotGerQtd 	:= 0
Local nTotGerVlr 	:= 0
Local nTotCatC		:= 0
// Variaveis de Acumulo
Local cOldEspecie  	:= ""
Local cOldProduto  	:= ""
Local cOldEsCabec  	:= ""
Local cOldCatCabec 	:= ""
Local cOldCateg  	:= ""

Local Cabec2		:= ""
Local Cabec1		:= "  Codigo Descricao          Quant.     Vlr.Unit.           Vlr.Total"
//  Codigo Descricao          Quant.     Vlr.Unit.           Vlr.Total
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parmetros                                               ณ
//ณ MV_PAR01   	Da Loja                                                                ณ
//ณ MV_PAR02	Ate a Loja                                                             ณ
//ณ MV_PAR03	Da data de Emissao                                                     ณ
//ณ MV_PAR04	Ate a data de Emissao                                                  ณ
//ณ MV_PAR05	Do codigo do Produto                                                   ณ
//ณ MV_PAR06	Ate o codigo do Produto                                                ณ
//ณ MV_PAR07	Da Grupo                                                               ณ
//ณ MV_PAR08	Ate o Grupo                                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "select ("
//cQuery += "select K1.B1_CATEG || '-' || K1.B1_SPECIE2 || '-' || rtrim(K2.L2_PRODUTO) || '-' || K2.L2_DESCRI "
cQuery += "select (SELECT Z6_TIPO FROM SZ6010 WHERE Z6_COD = K1.B1_CATEG AND D_E_L_E_T_ <> '*') || '-' || K1.B1_SPECIE2 || '-' || rtrim(K2.L2_PRODUTO) || '-' || K2.L2_DESCRI "
cQuery += "  from SL2010 K2 inner join SB1010 K1 "
cQuery += "    on K2.L2_PRODUTO =  K1.B1_COD "
cQuery += " where K2.D_E_L_E_T_ <> '*' "
cQuery += "   and K1.D_E_L_E_T_ <> '*' "
cQuery += "   and K2.L2_FILIAL  =  SL2.L2_FILIAL "
cQuery += "   and K2.L2_NUM     =  SL2.L2_NUM "
cQuery += "   and K2.L2_ITEM    =  SL2.L2_ITREF "
cQuery += "   and K2.L2_PRODUTO between '" + rTrim(MV_PAR05) + "' and '" + rTrim(MV_PAR06) + "' "
cQuery += "   and K1.B1_FILIAL  =  '" + xFilial("SB1") + "' "
cQuery += "   and K1.B1_GRUPO   between '" + MV_PAR07 + "' and '" + MV_PAR08 + "' "
//cQuery += "   and K1.B1_DESPIR  between '" + MV_PAR09 + "' and '" + MV_PAR10 + "' "
cQuery += "   and K2.L2_DOC <> '      '" // Marcio
cQuery += "       ) PRODPAI, L2_QUANT, B1_PRV1 "
cQuery += "  from SL2010 SL2 inner join SB1010 SB1 "
cQuery += "    on SL2.L2_PRODUTO = SB1.B1_COD "
cQuery += " where SL2.D_E_L_E_T_ <> '*' "
cQuery += "   and SB1.D_E_L_E_T_ <> '*' "
cQuery += "   and SB1.B1_FILIAL  =  '" + xFilial("SB1") + "' "
cQuery += "   and SB1.B1_GRUPO   =  '" + GetMV("FS_DEL001") + "' "
cQuery += "   and SL2.L2_FILIAL  between '" + MV_PAR01 + "' and '" + MV_PAR02 + "' "
cQuery += "   and SL2.L2_EMISSAO between '" + DtoS(MV_PAR03) + "' and '" + DtoS(MV_PAR04) + "' "
cQuery += "   and SL2.L2_DOC <> '      '" // Marcio
cQuery += " order by PRODPAI "

MemoWrite("DELR004.SQL", cQuery)
cQuery := ChangeQuery(cQuery)

// Cria tabela temporแria para o Relatorio
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)},"Aguarde...","Processando Dados...")

// Trata campos diferente de Caracter
For nX := 1 To Len(aStrucTRB)
	If aStrucTRB[nX][2] <> "C" .And. FieldPos(aStrucTRB[nX][1]) <> 0
		TcSetField(cAliasTRB,aStrucTRB[nX][1],aStrucTRB[nX][2],aStrucTRB[nX][3],aStrucTRB[nX][4])
	EndIf
Next nX

SetRegua(RecCount())
aDados    := {}

While TRB->(!Eof())
	IncRegua()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Alimenta Array com dados da Query      ณ
	//ณ 1 - Especie                            ณ
	//ณ 2 - Produto                            ณ
	//ณ 3 - Descricao                          ณ
	//ณ 4 - Quantidade                         ณ
	//ณ 5 - Vlr.Unitario                       ณ
	//ณ 6 - Vlr.Total                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(TRB->PRODPAI)
		Aadd(aDados,{;            
		Subs(TRB->PRODPAI,01,10),;
		Subs(TRB->PRODPAI,12,04),;
		Subs(TRB->PRODPAI,17,06),;
		Subs(TRB->PRODPAI,24,15),;
		TRB->L2_QUANT,;
		TRB->B1_PRV1,;
		TRB->(L2_QUANT * B1_PRV1)})
	Endif
	
	TRB->(dbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Totais no Inicio do Relatorio             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Li > 60
	Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)
	
	If AllTrim(GetMv("MV_IMPSX1")) <> "S"
		// Imprime parametros
		If m_Pag == 2
			SX1->(dbSetOrder(1))
			SX1->(dbSeek(cPerg))
			
			@ Li,002 pSay "P A R A M E T R O S"
			Li += 2
			
			While !SX1->(EOF()) .And. SX1->X1_GRUPO == cPerg
				
				If SX1->X1_GSC == "G"
//					cConteudo := SX1->X1_CNT01
					If !SX1->X1_ORDEM $ "03&04
						cConteudo := &("M->MV_PAR" + StrZero(Val(SX1->X1_ORDEM), 2))
					Else
						cConteudo := dtoc(&("M->MV_PAR" + StrZero(Val(SX1->X1_ORDEM), 2)))
					Endif		
//				Else
//					cConteudo := &("SX1->X1_DEF" + StrZero(SX1->X1_PRESEL, 2)) // Marcio Domingos
//					cConteudo := &("M->MV_PAR" + StrZero(Val(SX1->X1_ORDEM), 2))
				EndIf
				@ Li,002 pSay "Pergunta " + SX1->X1_ORDEM + ": " + SX1->X1_PERGUNT + cConteudo
				Li++
				
				SX1->(dbSkip())
			EndDo
			
			Li++
			@ Li,000 PSay __PrtThinLine()
			Li += 2
		EndIf
	EndIf

EndIf

// Acumula total
For nX := 1 to Len(aDados)
	nTotGerVlr 	+= aDados[nX,6] // Vlr.Total
Next nX

@ Li,000 PSay " G E R A L"
Li++
@ Li,000 PSay "PREMIO A RECEBER DO SEGURADO"
@ Li,058 PSay nTotGerVlr Picture "@E 999,999.99"
Li++
@ Li,000 PSay "(-) I.O.F.("+LTRim(str(nPIOF))+"%)"
nVlrIOF := (nTotGerVlr * nPIOF)/100
@ Li,058 PSay nVlrIOF Picture "@E 999,999.99"
Li++
@ Li,000 PSay "(=) PREMIO LIQUIDO + CUSTO DA APOLICE"
@ Li,058 PSay nTotGerVlr - nVlrIOF Picture "@E 999,999.99"
Li++
@ Li,000 PSay "(-) CUSTO DA APOLICE"
@ Li,058 PSay nCustoApolice Picture "@E 999,999.99"
Li++
@ Li,000 PSay "(=) VALOR DA APOLICE"
nVlrApolice := (nTotGerVlr - nVlrIOF) - nCustoApolice
@ Li,058 PSay nVlrApolice Picture "@E 999,999.99"
Li++
Li++

@ Li,000 PSay "COMISSAO BRUTA DELLA VIA"
nVlrComBruta := (nVlrApolice * nPComiss)/100
@ Li,058 PSay nVlrComBruta Picture "@E 999,999.99"
@ Li,069 PSay nPComiss     Picture "@E 99.99%"
Li++
@ Li,000 PSay "(-) I.R.R.F. ("+LTrim(str(nPIRRF))+"%)"
nVlrIRRF := (nVlrComBruta * nPIRRF)/100
@ Li,058 PSay nVlrIRRF Picture "@E 999,999.99"
Li++
@ Li,000 PSay "(-) I.S.S.   ("+LTrim(str(nPISS))+"%)"
nVlrISS := (nVlrComBruta * nPISS)/100
@ Li,058 PSay nVlrISS Picture "@E 999,999.99"
Li++
@ Li,000 PSay "(=) COMISSAO LIQUIDA"
@ Li,058 PSay nVlrComBruta - (nVlrIRRF + nVlrISS) Picture "@E 999,999.99"
Li++
Li++
@ Li,000 PSay "MARGEM VCS"
@ Li,058 PSay (nVlrApolice * nPMargVCS)/100 Picture "@E 999,999.99"
@ Li,069 PSay nPMargVCS Picture "@E 99.99%"
Li++
@ Li,000 PSay __PrtThinLine()
Li++

SZ7->(dbSetOrder(1)) // Z7_FILIAL+Z7_COD+Z7_DESC

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Relatorio                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotGerVlr := 0 // Zera Total Geral
For nX := 1 to Len(aDados)
	If Li > 60
		Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Imprime salto de Produto                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (!Empty(cOldProduto)) .and. (cOldProduto <> aDados[nX,3])
		@ Li,002 PSay Iif(nX=1,aDados[nX,3],cOldProduto)					// Codigo
		@ Li,009 PSay aDados[nX-Iif(nX>1,1,0),4]  							// Descricao
		@ Li,028 PSay nTotProQtd      	 			Picture "@E 999999"    	// Quantidade
		@ Li,035 PSay "*"
		@ Li,038 PSay aDados[nX-Iif(nX>1,1,0),6] 	Picture "@E 999,999.99"	// Vlr.Unitario
		@ Li,058 PSay nTotProVlr      				Picture "@E 999,999.99"	// Vlr.Total
		Li++
		// Limpa Sub-totais
		nTotProQtd := 0
		nTotProVlr := 0
	Endif
	
	If Li > 60
		Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Imprime salto da Categoria                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cOldCateg <> aDados[nX,1]
		// Imprime Total da Especie
		If !Empty(cOldCateg)
			Li++
			@ Li,002 PSay "TOTAL DA ESPECIE"
			@ Li,028 PSay nTotEspQtd Picture "@E 999999"     // Quantidade
			@ Li,058 PSay ntotEspVlr Picture "@E 999,999.99" // Vlr.Total
			Li++
			Li++
			@ Li,000 PSay "TOTAL "+cOldCateg
			@ Li,028 PSay nTotCatQtd Picture "@E 999999"     // Quantidade
			@ Li,058 PSay ntotCatVlr Picture "@E 999,999.99" // Vlr.Total
			Li++
			@ Li,000 PSay __PrtThinLine()
			Li++
			
			// Limpa Sub-Totais
			nTotCatQtd := 0
			nTotCatVlr := 0  
			nTotEspQtd := 0
			nTotEspVlr := 0
			cOldEspecie := ""
			
			// Resgata Especie Correta
			cOldCatCabec := aDados[nX,1]
			
		Endif                         
//		SZ6->(dbSeek("01" + Iif(Empty(cOldCatCabec),aDados[nX,1],cOldCatCabec)))  // Tabela SZ6 estแ exclusiva para empresa 01
		
	Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)

// Imprime Sub Dicisao por Especie
//	@ Li,000 PSay Iif(Empty(cOldCatCabec),aDados[nX,1],cOldCatCabec)
	@ Li,000 PSay aDados[nX,1]
//	@ Li,053 PSay "VALOR DO SEGURO"
	Li++
	Li++	

	//Marcelo Alcantara
	// Acumula total para o cabecalho da categoria

	nTotCatC := 0
	For nZ := 1 to Len(aDados)
		If aDados[nZ,1] == aDados[nX,1]
			nTotCatC += aDados[nZ,6] 	// Vlr.Total
		EndIf
	Next nZ
	
	@ Li,000 PSay "PREMIO A RECEBER DO SEGURADO"
	@ Li,058 PSay nTotCatC Picture "@E 999,999.99"
	Li++
	@ Li,000 PSay "(-) I.O.F.("+LTRim(str(nPIOF))+"%)"
	nVlrIOF := (nTotCatC * nPIOF)/100
	@ Li,058 PSay nVlrIOF Picture "@E 999,999.99"
	Li++
	@ Li,000 PSay "(=) PREMIO LIQUIDO + CUSTO DA APOLICE"
	@ Li,058 PSay nTotCatC - nVlrIOF Picture "@E 999,999.99"
	Li++
	@ Li,000 PSay "(-) CUSTO DA APOLICE"
	@ Li,058 PSay nCustoApolice Picture "@E 999,999.99"
	Li++
	@ Li,000 PSay "(=) VALOR DA APOLICE"
	nVlrApolice := (nTotCatC - nVlrIOF) - nCustoApolice
	@ Li,058 PSay nVlrApolice Picture "@E 999,999.99"
	Li++
	Li++
	
	@ Li,000 PSay "COMISSAO BRUTA DELLA VIA"
	nVlrComBruta := (nVlrApolice * nPComiss)/100
	@ Li,058 PSay nVlrComBruta Picture "@E 999,999.99"
	@ Li,069 PSay nPComiss     Picture "@E 99.99%"
	Li++
	@ Li,000 PSay "(-) I.R.R.F. ("+LTrim(str(nPIRRF))+"%)"
	nVlrIRRF := (nVlrComBruta * nPIRRF)/100
	@ Li,058 PSay nVlrIRRF Picture "@E 999,999.99"
	Li++
	@ Li,000 PSay "(-) I.S.S.   ("+LTrim(str(nPISS))+"%)"
	nVlrISS := (nVlrComBruta * nPISS)/100
	@ Li,058 PSay nVlrISS Picture "@E 999,999.99"
	Li++
	@ Li,000 PSay "(=) COMISSAO LIQUIDA"
	@ Li,058 PSay nVlrComBruta - (nVlrIRRF + nVlrISS) Picture "@E 999,999.99"
	Li++
	Li++
	@ Li,000 PSay "MARGEM VCS"
	@ Li,058 PSay (nVlrApolice * nPMargVCS)/100 Picture "@E 999,999.99"
	@ Li,069 PSay nPMargVCS Picture "@E 99.99%"
	Li++
	@ Li,000 PSay __PrtThinLine()
	Li++		
	Li++		
	// Fim Marcelo
			
	Endif	

	If Li > 60
		Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Imprime salto da Especie                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cOldEspecie <> aDados[nX,2]
		// Imprime Total da Especie
		If !Empty(cOldEspecie)
			Li++
			@ Li,002 PSay "TOTAL DA ESPECIE"
			@ Li,028 PSay nTotEspQtd Picture "@E 999999"     // Quantidade
			@ Li,058 PSay ntotEspVlr Picture "@E 999,999.99" // Vlr.Total
			Li++
			Li++
			
			// Limpa Sub-Totais
			nTotEspQtd := 0
			nTotEspVlr := 0
			
			// Resgata Especie Correta
			cOldEsCabec := aDados[nX,2]
			
		Endif
//		SZ7->(dbSeek(xFilial("SZ7") + Iif(Empty(cOldEsCabec),aDados[nX,2],cOldEsCabec)))
		SZ7->(dbSeek(xFilial("SZ7") + aDados[nX,2]))
		
		// Imprime Sub Divisao por Especie
		@ Li,001 PSay SZ7->Z7_COD
		@ Li,006 PSay rTrim(SZ7->Z7_DESC)
		@ Li,053 PSay "VALOR DO SEGURO"
		Li++
		Li++
	Endif
	
	// Totalizadores
	nTotProQtd 	+= aDados[nX,5] // Quantidade PRODUTOS
	nTotProVlr 	+= aDados[nX,7] // Vlr.Total
	nTotEspQtd 	+= aDados[nX,5] // Quantidade ESPECIES
	nTotEspVlr 	+= aDados[nX,7] // Vlr.Total       
	nTotCatQtd 	+= aDados[nX,5] // Quantidade CATEGORIA
	nTotCatVlr 	+= aDados[nX,7] // Vlr.Total
	nTotGerQtd 	+= aDados[nX,5] // Quantidade GERAL
	nTotGerVlr 	+= aDados[nX,7] // Vlr.Total
	// Variaveis de Acumulo               
	cOldCateg	:= aDados[nX,1] // Categoria
	cOldEspecie := aDados[nX,2] // Especie
	cOldProduto := aDados[nX,3] // Codigo
	
Next i

If Len(aDados) > 0
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ultimo Produto / Sub total / Total Geral  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ Li,002 PSay cOldProduto		// Codigo
	@ Li,009 PSay aDados[Len(aDados),4]  	// Descricao
	@ Li,028 PSay nTotProQtd 		Picture "@E 999999"    	// Quantidade
	@ Li,035 PSay "*"
	@ Li,038 PSay aDados[Len(aDados),6] 	Picture "@E 999,999.99"	// Vlr.Unitario
	@ Li,058 PSay nTotProVlr      	Picture "@E 999,999.99"	// Vlr.Total
	Li++
	Li++
	@ Li,002 PSay "TOTAL DA ESPECIE"
	@ Li,028 PSay nTotEspQtd Picture "@E 999999"     // Quantidade
	@ Li,058 PSay ntotEspVlr Picture "@E 999,999.99" // Vlr.Total
	Li++
	Li++
	@ Li,000 PSay "TOTAL "+cOldCateg
	@ Li,028 PSay nTotCatQtd Picture "@E 999999"     // Quantidade
	@ Li,058 PSay ntotCatVlr Picture "@E 999,999.99" // Vlr.Total
	Li++
	// Imprime Separador
	@ Li,000 PSay __PrtThinLine()
	Li++
	@ Li,000 PSay "TOTAL GERAL"
	@ Li,028 PSay nTotGerQtd Picture "@E 999999"     // Quantidade
	@ Li,058 PSay ntotGerVlr Picture "@E 999,999.99" // Vlr.Total
	Li++
	// Imprime Separador
	@ Li,000 PSay __PrtThinLine()
	Li++
EndIf

// Fecha tabela temporaria (outras tabela temporarias foram fechadas ao fim de seu uso)
TRB->(dbCloseArea())

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return
