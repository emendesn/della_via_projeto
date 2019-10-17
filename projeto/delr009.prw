#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELR009  บAutor  ณRicardo Mansano     บ Data ณ  01/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Vendas do Televendas                          บฑฑ
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
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELR009()
Local cQuery     	:= ""
Local aOrd       	:= {}
Local cDesc1     	:= "Este programa eh responsavel pela"
Local cDesc2     	:= "geracao do Relatorio de vendas do Televendas"
Local cDesc3     	:= ""
Private cbtxt    	:= Space(10)
Private cbcont   	:= 00
Private cTitulo  	:= "Televendas"
Private m_pag    	:= 01  // Pagina Inicial (deve constar em todos os relatorios)
Private cPerg    	:= "DEL009"
Private nNomeProg 	:= "DEL009"
Private cString  	:= "SUA"
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
PutSx1(cPerg,"01","Do Grupo de Atendimento   ?","","","mv_ch1" ,"C",02,0,0,"G","","SUA","","","MV_PAR01"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")  
PutSx1(cPerg,"02","Ate o Grupo de Atendimento?","","","mv_ch2" ,"C",02,0,0,"G","","SUA","","","MV_PAR02"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")  
PutSx1(cPerg,"03","Do Codigo de Operador     ?","","","mv_ch3" ,"C",06,0,0,"G","","SU7","","","MV_PAR03"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","") 
PutSx1(cPerg,"04","Ate o Codigo de Operador  ?","","","mv_ch4" ,"C",06,0,0,"G","","SU7","","","MV_PAR04"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSX1(cPerg,"05","Da data                   ?","","","mv_ch5" ,"D",08,0,0,"G","",""   ,"","","MV_PAR05"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"06","Ate a data                ?","","","mv_ch6" ,"D",08,0,0,"G","",""   ,"","","MV_PAR06"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
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
Local cAliasTRB 	:= "TRB" 
Local nX			:= 0      
Local aStrucTRB		:= SUA->(dbStruct())
Local nValFat		:= 0  

// Totalizadores
Local nTotOrcParc	:= 0 
Local nTotFatParc	:= 0 
Local nTotOrcGer 	:= 0 
Local nTotFatGer 	:= 0 

// Variaveis de Acumulo
Local cOldOperador 	:= ""

Local Cabec2		:= ""          
Local Cabec1		:= "  Data Emissao    Valor Orcado  Valor Faturado"
                      //  
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parmetros                                               ณ
//ณ MV_PAR01   	Do codigo do Grupo de Atendimento                                      ณ
//ณ MV_PAR02	Ate o codigo do Grupo de Atendimento                                   ณ
//ณ MV_PAR03	Do codigo do operador                                                  ณ
//ณ MV_PAR04	Ate o codigo do operador                                               ณ
//ณ MV_PAR05	Da data                                                                ณ
//ณ MV_PAR06	Ate a data                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT UA_OPERADO,UA_EMISSAO,UA_OPER,                                    "
cQuery += " SUM(UA_VLRLIQ)ORCADO,SUM(F2_VALFAT)FATURADO                             "
cQuery += " FROM "+RetSqlName("SU7")+" U7,"+RetSqlName("SUA")+" UA                 "
cQuery += " LEFT OUTER JOIN "+RetSqlName("SC5")+" C5                               	"
cQuery += "     ON  UA.UA_FILIAL = C5.C5_FILIAL                                     "
cQuery += "     AND UA.UA_NUMSC5 = C5.C5_NUM                                        "
cQuery += "     AND C5.D_E_L_E_T_ <> '*'                                            "
cQuery += " LEFT OUTER JOIN "+RetSqlName("SF2")+" F2                               "
cQuery += "     ON  C5.C5_FILIAL  =  F2.F2_FILIAL                                   "
cQuery += "     AND C5.C5_NOTA    =  F2.F2_DOC                                      "
cQuery += "     AND C5.C5_SERIE   =  F2.F2_SERIE                                    "
cQuery += "     AND F2.D_E_L_E_T_ <> '*'                                            "
cQuery += " WHERE  U7_POSTO   BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'            	"
cQuery += "  AND   UA_OPERADO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'            	"
cQuery += "  AND   UA_EMISSAO BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"'"
cQuery += "  AND   UA_OPERADO    =  U7_COD                                          "
cQuery += "  AND   UA.D_E_L_E_T_ <> '*'                                             "
cQuery += "  AND   U7.D_E_L_E_T_ <> '*'                                             "
cQuery += "  AND   UA_LOJASL1    =  ''                                              "
cQuery += "  AND   ((UA_OPER='2')OR(UA_OPER='1' AND UA_NUMSC5<>''))                 "
cQuery += "  GROUP BY UA_OPERADO,UA_EMISSAO,UA_OPER                                 "
cQuery += "  ORDER BY UA_OPERADO,UA_EMISSAO,UA_OPER                                 "
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

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Imprime Cabecalho.                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	 	If Li > 60
			Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)
		EndIf                                                       
	                          
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica salto de Operador                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If cOldOperador <> TRB->UA_OPERADO
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Imprime SubTotal por Operador             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If (nTotOrcParc > 0).or.(nTotFatParc > 0)
	  			@ Li,002 PSay "Total Operador:"
	  			@ Li,020 PSay nTotOrcParc Picture "@E 999,999.99"	
				@ Li,036 PSay nTotFatParc Picture "@E 999,999.99"	
				Li+=2
				// Zera Subtotais
				nTotOrcParc := 0
				nTotFatParc := 0
			Endif

			@ Li,000 PSay "OPERADOR: "+TRB->UA_OPERADO +" - "+ RetField("SU7",1,xFilial("SU7")+TRB->UA_OPERADO,"U7_NOME")
			Li += 2
		Endif
		
		@ Li,002 PSay TRB->UA_EMISSAO
		@ Li,020 PSay TRB->ORCADO Picture "@E 999,999.99"	
		@ Li,036 PSay TRB->FATURADO Picture "@E 999,999.99"	
  		Li++
  		
 		// Totalizadores
		nTotOrcParc	+= TRB->ORCADO
		nTotOrcGer 	+= TRB->ORCADO
		nTotFatParc	+= TRB->FATURADO
		nTotFatGer 	+= TRB->FATURADO

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Guarda informacoes para verificar o saltos do relatorio  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cOldOperador := TRB->UA_OPERADO

	TRB->(dbSkip())

	EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Imprime SubTotal Final e Total Geral      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ Li,002 PSay "Total Operador:"
@ Li,020 PSay nTotOrcParc Picture "@E 999,999.99"	
@ Li,036 PSay nTotFatParc Picture "@E 999,999.99"	
Li+=2
@ Li,000 PSay "TOTAL GERAL:"
@ Li,020 PSay nTotOrcGer  Picture "@E 999,999.99"	
@ Li,036 PSay nTotFatGer  Picture "@E 999,999.99"	

// Fecha tabela temporaria (outras tabela temporarias foram fechadas ao fim de seu uso)
TRB->(dbCloseArea())

If aReturn[5] == 1
   Set Printer To
   Commit
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return NIL
