#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELR006  บAutor  ณRicardo Mansano     บ Data ณ  03/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de DOACAO.                                       บฑฑ
ฑฑบ          ณ 01-DOACAO eh localizada pela Cond. de Pagamento=FS_DEL012  บฑฑ
ฑฑบ          ณ 02-AGREGADO eh localizado como a proxima venda apos a      บฑฑ
ฑฑบ          ณ  doacao ou caso esta nao exista pela venda anterior        บฑฑ
ฑฑบ          ณ  desde que esta nao seja agregada de uma doacao anterior.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Chamado Via Menu.                                          บฑฑ
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
Project Function DELR006()
Local cQuery     	:= ""
Local aOrd       	:= {}
Local cDesc1     	:= "Este programa eh responsavel pela"
Local cDesc2     	:= "geracao do Relatorio de Doacao"
Local cDesc3     	:= ""
Private cbtxt    	:= Space(10)
Private cbcont   	:= 00
Private cTitulo  	:= "Relatorio de Doacao"
Private m_pag    	:= 01  // Pagina Inicial (deve constar em todos os relatorios)
Private cPerg    	:= "DEL006"
Private nNomeProg 	:= "DEL006"
Private cString  	:= "SL1"
Private aReturn  	:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private wnrel    	:= nNomeProg
Private cTamanho  	:= "M"
Private nTipo    	:= 15
    
// Impede Execucao em Ambiente Codebase
#IFDEF TOP
#ELSE  
    Aviso("Aten็ใo !","Relatorio s๓ pode ser executado na Matriz - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
    Return Nil
#ENDIF

// Ajusta Perguntas
PutSx1(cPerg,"01","Do codigo do Cliente      ?","","","mv_ch1" ,"C",08,0,0,"G","","SA1","","","MV_PAR01"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","") 
PutSx1(cPerg,"02","Ate o codigo do Cliente   ?","","","mv_ch2" ,"C",08,0,0,"G","","SA1","","","MV_PAR02"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSX1(cPerg,"03","Da data de Emissao        ?","","","mv_ch3" ,"D",08,0,0,"G","",""   ,"","","MV_PAR03"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"04","Ate a data de Emissao     ?","","","mv_ch4" ,"D",08,0,0,"G","",""   ,"","","MV_PAR04"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSx1(cPerg,"05","Da Loja                   ?","","","mv_ch5" ,"C",02,0,0,"G","","SM0","","","MV_PAR05"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","") 
PutSx1(cPerg,"06","Ate a Loja                ?","","","mv_ch6" ,"C",02,0,0,"G","","SM0","","","MV_PAR06"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"07","Da Regional               ?","","","mv_ch7" ,"C",03,0,0,"C","",""   ,"","","MV_PAR07"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")  
PutSx1(cPerg,"08","Ate a Regional            ?","","","mv_ch8" ,"C",03,0,0,"C","",""   ,"","","MV_PAR08"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")  
PutSx1(cPerg,"09","Considera Loja do Cliente ?","","","mv_ch9" ,"C",01,0,0,"C","",""   ,"","","MV_PAR09"   ,"Sim"          ,"","","","Nao"       ,"","","","","","","","","","","")  
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
Local cAliasTRB2 	:= "POS" // Alias para vendas Posteriores a DOACAO
Local cAliasTRB3 	:= "ANT" // Alias para vendas Anteriores  a DOACAO
Local nX			:= 0      
Local lAchouAgreg 	:= .F.
Local aStrucTRB		:= SL1->(dbStruct())
Local nTotDoa   	:= 0 
Local nTotAgrega	:= 0 
Local lDataAnt		:= GetMV("FS_DEL011")  // Pesquisa Notas Agregadas anteriores a Doacao
Local cCondPgDoa	:= GetMV("FS_DEL012")  // Condicao de Pagamento para DOACAO
Local aDadosDoa		:= {}
Local aDadosAgrega	:= {}
Local aDadosResult	:= {}
Local nPosNota		:= 0  
Local aNota			:= {}
Local Cabec2		:= ""          
Local Cabec1		:= "T DT EMISS CUPOM  SER LJ DESC          COD CLI   NOME CLIENTE                    VL TOTAL VENDEDOR                      "
                      //X 99/99/99 000001 UNI 01 IPIRANGA       000001 01 CLIENTE PADRAO                 99.999,99 000001 VENDEDOR PADRAO 
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parmetros                                                ณ
//ณ	MV_PAR01    Do c๓digo do cliente;													ณ
//ณ	MV_PAR02	At้ o c๓digo do cliente;												ณ
//ณ	MV_PAR03	Da data de emissใo - data de emissใo do cupom fiscal;					ณ
//ณ	MV_PAR04	At้ a data de emissใo - data de emissใo do cupom fiscal;				ณ
//ณ	MV_PAR05	Da loja - c๓digo da loja Della Via;										ณ
//ณ	MV_PAR06	At้ a loja - c๓digo da loja Della Via;									ณ
//ณ	MV_PAR07	Da regional - c๓digo da regional em que estแ a loja Della Via;			ณ
//ณ	MV_PAR08	At้ a regional - c๓digo da regional em que estแ a loja Della Via;		ณ
//ณ	MV_PAR09	Considera Loja do Cliente (1=SIM e 2=NAO) 								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Filtra em SL1 Vendas de Doacao (L1_CONDPG=FS_DEL012)
cQuery := "SELECT L1_CONDPG,L1_EMISSAO,L1_DOC,L1_SERIE,    							"
cQuery += " L1_FILIAL,LJ_NOME,                                         				" 
cQuery += " L1_CLIENTE,L1_LOJA,A1_NOME,                                				" 
cQuery += " L1_VLRTOT,L1_VEND,A3_NOME                                  				" 
cQuery += " FROM " + RetSqlName("SL1")+" L1, "+RetSqlName("SA1")+" A1,				"
cQuery +=            RetSqlName("SA3")+" A3, "+RetSqlName("SLJ")+" LJ  			"
cQuery += " WHERE L1_DOC    	<>	''                                 				"
cQuery += " AND   L1_CONDPG		=	'"+cCondPgDoa+"'                   			    "
cQuery += " AND   L1_CLIENTE BETWEEN '"+MV_PAR01+"'AND'"+MV_PAR02+"' 			  	"
cQuery += " AND   L1_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"'AND'"+DtoS(MV_PAR04)+"'	"
cQuery += " AND   L1_FILIAL  BETWEEN '"+MV_PAR05+"'AND'"+MV_PAR06+"'				"
cQuery += " AND   A1_REGIAO  BETWEEN '"+MV_PAR07+"'AND'"+MV_PAR08+"'				"
cQuery += " AND   L1.D_E_L_E_T_ <> 	'*'                               			    "
cQuery += " AND   A1.D_E_L_E_T_ <> 	'*'                            			        "
cQuery += " AND   A3.D_E_L_E_T_ <> 	'*'                                 			"
cQuery += " AND   LJ.D_E_L_E_T_ <> 	'*'                                 			"
cQuery += " AND   A1_FILIAL	 	= 	'"+xFilial("SA1")+"'               				"
cQuery += " AND   A3_FILIAL 	= 	'"+xFilial("SA3")+"'               				"
cQuery += " AND   LJ_FILIAL	 	= 	'"+xFilial("SLJ")+"'               				"
cQuery += " AND   L1_CLIENTE	=	A1_COD                              			"
cQuery += " AND   L1_LOJA   	=	A1_LOJA                             			"
cQuery += " AND   L1_VEND   	=	A3_COD                              			"
cQuery += " AND   L1_FILIAL 	=	LJ_RPCFIL                           			"
cQuery += " ORDER BY L1_CLIENTE,L1_LOJA,L1_EMISSAO,L1_DOC              				"
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
While TRB->(!Eof()) 
	IncRegua()
		If Li > 60
			Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)
		EndIf                                                       
                          
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Venda de DOACAO                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aDadosDoa := {}
		Aadd(aDadosDoa,{"D",TRB->L1_EMISSAO,TRB->L1_DOC,TRB->L1_SERIE,TRB->L1_FILIAL,;
		                TRB->LJ_NOME,TRB->L1_CLIENTE,TRB->L1_LOJA,TRB->A1_NOME,TRB->L1_VLRTOT,;
						TRB->L1_VEND,Substr(TRB->A3_NOME,1,30)})
	
        // Limpa informacao de localizacao de Venda Agregada
		lAchouAgreg := .F.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Venda AGREGADA                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//ณ Sub-Query com Vendas posteriores                   ณ
		//ณ Ignoro a LOJA da Venda Agregada                    ณ
		//ณ OBS: Localiza apenas o primeiro registro utilizan- ณ
		//ณ      do o "FETCH FIRST 1 ROWS ONLY" do DB2         ณ 
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := "SELECT L1_CONDPG,L1_EMISSAO,L1_DOC,L1_SERIE,    				"
		cQuery += " L1_FILIAL,LJ_NOME,                                         	"
		cQuery += " L1_VLRTOT,L1_VEND,A3_NOME,L1.R_E_C_N_O_                    	"
		cQuery += " FROM " + RetSqlName("SL1")+" L1,                           	"
		cQuery +=            RetSqlName("SA3")+" A3, "+RetSqlName("SLJ")+" LJ 	"
		cQuery += " WHERE L1_CLIENTE       = '"+TRB->L1_CLIENTE+"'             	"
		// Considera Loja do Cliente (1=SIM e 2=NAO) 
		If MV_PAR09==1
			cQuery += " AND   L1_LOJA          = '"+TRB->L1_LOJA+"'           	"
		Endif
		cQuery += " AND   L1_CONDPG 	<>	'"+cCondPgDoa+"'                    "
		cQuery += " AND   L1_EMISSAO 	>= 	'"+DtoS(TRB->L1_EMISSAO)+"'        	"
		cQuery += " AND   L1_DOC     	<> 	'"+     TRB->L1_DOC     +"'        	"
		cQuery += " AND   L1.D_E_L_E_T_ <> 	'*'                                 "
		cQuery += " AND   A3.D_E_L_E_T_ <> 	'*'                                 "
		cQuery += " AND   LJ.D_E_L_E_T_ <> 	'*'                                 "
		cQuery += " AND   A3_FILIAL 	= 	'"+xFilial("SA3")+"'               	"
		cQuery += " AND   LJ_FILIAL 	= 	'"+xFilial("SLJ")+"'               	"
		cQuery += " AND   L1_VEND   	=	A3_COD                              "
		cQuery += " AND   L1_FILIAL 	=	LJ_RPCFIL                           "
		cQuery += " AND   L1_DOC    	<>	''                                  "
		cQuery += " ORDER BY L1_EMISSAO ASC                                    	"
		cQuery += " FETCH FIRST 1 ROWS ONLY                                    	"
		cQuery := ChangeQuery(cQuery)
		// Cria tabela temporแria para o Relatorio
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB2,.F.,.T.)},"Aguarde...","Processando Dados...")
		// Trata campos diferente de Caracter
		For nX := 1 To Len(aStrucTRB)
			If aStrucTRB[nX][2] <> "C" .And. FieldPos(aStrucTRB[nX][1]) <> 0
				TcSetField(cAliasTRB2,aStrucTRB[nX][1],aStrucTRB[nX][2],aStrucTRB[nX][3],aStrucTRB[nX][4])
			EndIf
		Next nX

		// Pega o Primeiro Registro da Sub-Query de Venda Posterior a DOACAO 
		If !POS->(Eof())
			// Informa que ja achou a Venda Agregada
			lAchouAgreg := .T.
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Verifica se a Nota Fiscal em questao ja nao        ณ
			//ณ foi utilizada como Agregada nas vendas posteriores ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		    nPosNota := aScan(aNota,{ |x| x[1] == POS->R_E_C_N_O_ })
		    If nPosNota == 0                      
				// Desconsidera Agregacao pois a mesma ja foi agregada a outra Doacao
				lAchouAgreg := .F.

		    	// Alimenta Array com a Nota jah utilizada como Agregada
				Aadd(aNota,{POS->R_E_C_N_O_})

				// Alimenta Arrays com os dados da Venda Agregada para Impressao posterior
				aDadosAgrega := {}
				Aadd(aDadosAgrega,{"A",POS->L1_EMISSAO,POS->L1_DOC,POS->L1_SERIE,POS->L1_FILIAL,;
				                   POS->LJ_NOME,TRB->L1_CLIENTE,TRB->L1_LOJA,TRB->A1_NOME,;
								   POS->L1_VLRTOT,POS->L1_VEND,Substr(POS->A3_NOME,1,30)})
		    Endif

			// Soma Total Agregado
			nTotAgrega += POS->L1_VLRTOT
		Endif
        // Fecha Query Temporaria
		POS->(dbCloseArea())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se nao achou Venda AGREGADA posterior procura      ณ
		//ณ com data anterior, desde que esta ja nao seja      ณ
		//ณ agregada de outra venda.                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//ณ OBS: o parametro lDataAnt(FS_DEL011)=.T. habilita  ณ
		//ณ localizacao de vendas anteriores a DOACAO,         ณ
		//ณ lDataAnt=.F. ignora vendas anteriores.             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (!lAchouAgreg).and.(lDataAnt==.T.)
			cQuery := "SELECT L1_CONDPG,L1_EMISSAO,L1_DOC,L1_SERIE,    				"
			cQuery += " L1_FILIAL,LJ_NOME,                                         	"
			cQuery += " L1_VLRTOT,L1_VEND,A3_NOME,                                 	"
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Nesta Sub-Query eu localizo a primeira Venda de DOACAO  ณ
			//ณ com data anterior a esta Venda Agregada                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cQuery += " (SELECT L1_NUM                                     			"
			cQuery += "  FROM SL1010 LZ                                            	"
			cQuery += "  WHERE L1_CLIENTE   = L1.L1_CLIENTE                    	    "
			// Considera Loja do Cliente (1=SIM e 2=NAO)
			If MV_PAR09==1
				cQuery += " AND   L1_LOJA          = '"+TRB->L1_LOJA+"'           	"
			Endif
			cQuery += "  AND   L1_CONDPG 	= '"+cCondPgDoa+"'                     	"
			cQuery += "  AND   L1_EMISSAO 	< L1.L1_EMISSAO                        	"
			cQuery += "  AND   LZ.D_E_L_E_T_<> '*'  	                           	"
			cQuery += "  AND   L1_DOC    	<> ''                                 	"
			cQuery += "  ORDER BY L1_EMISSAO DESC                                 	"
			cQuery += "  FETCH FIRST 1 ROWS ONLY)DOACAO_ANTERIOR,                  	"
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Nesta Sub-Query eu localizo a primeira Venda diferente de DOACAO          ณ
			//ณ com data anterior a esta Venda Agregada que sera usada para verificar se  ณ
			//ณ houve uma Agregacao entre a data da Doacao localizada na Sub-Query acima  ณ
			//ณ e a DOACAO que esta sendo analizada no While principal do programa.       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cQuery += " (SELECT L1_EMISSAO                                         	"
			cQuery += " FROM SL1010 LZ                                            	"
			cQuery += " WHERE L1_CLIENTE   = L1.L1_CLIENTE                    	    "
			// Considera Loja do Cliente (1=SIM e 2=NAO)
			If MV_PAR09==1
				cQuery += " AND   L1_LOJA          = '"+TRB->L1_LOJA+"'           	"
			Endif
			cQuery += " AND   L1_CONDPG 	<> '"+cCondPgDoa+"'                    	"
			cQuery += " AND   L1_EMISSAO 	< L1.L1_EMISSAO                        	"
			cQuery += " AND   LZ.D_E_L_E_T_<> '*'  	                           	    "
			cQuery += " AND   L1_DOC    	<> ''                                 	"
			cQuery += " ORDER BY L1_EMISSAO DESC                                 	"
			cQuery += " FETCH FIRST 1 ROWS ONLY)VENDA_ANTERIOR                     	"
			//-----------------------------------------------------------------------
			cQuery += " FROM " + RetSqlName("SL1")+" L1,                           	"
			cQuery +=            RetSqlName("SA3")+" A3, "+RetSqlName("SLJ")+" LJ 	"
			cQuery += " WHERE L1_CLIENTE       = '"+TRB->L1_CLIENTE+"'             	"
			// Considera Loja do Cliente (1=SIM e 2=NAO)
			If MV_PAR09==1
				cQuery += " AND   L1_LOJA          = '"+TRB->L1_LOJA+"'           	"
			Endif
			cQuery += " AND   L1_CONDPG 	<>	'"+cCondPgDoa+"'                    "
			cQuery += " AND   L1_EMISSAO 	< 	'"+DtoS(TRB->L1_EMISSAO)+"'        	"
			cQuery += " AND   L1.D_E_L_E_T_ <> 	'*'                                 "
			cQuery += " AND   A3.D_E_L_E_T_ <> 	'*'                                 "
			cQuery += " AND   LJ.D_E_L_E_T_ <> 	'*'                                 "
			cQuery += " AND   A3_FILIAL 	= 	'"+xFilial("SA3")+"'               	"
			cQuery += " AND   LJ_FILIAL	 	= 	'"+xFilial("SLJ")+"'               	"
			cQuery += " AND   L1_VEND   	=	A3_COD                              "
			cQuery += " AND   L1_FILIAL 	=	LJ_RPCFIL                           "
			cQuery += " AND   L1_DOC    	<>	''                                  "
			cQuery += " ORDER BY L1_EMISSAO DESC                                  	"
			cQuery += " FETCH FIRST 1 ROWS ONLY                                  	"
			cQuery := ChangeQuery(cQuery)
			// Cria tabela temporแria para o Relatorio
			MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB3,.F.,.T.)},"Aguarde...","Processando Dados...")
			// Trata campos diferente de Caracter
			For nX := 1 To Len(aStrucTRB)
				If aStrucTRB[nX][2] <> "C" .And. FieldPos(aStrucTRB[nX][1]) <> 0
					TcSetField(cAliasTRB3,aStrucTRB[nX][1],aStrucTRB[nX][2],aStrucTRB[nX][3],aStrucTRB[nX][4])
				EndIf
			Next nX               
			
			// Pega o Primeiro Registro da Sub-Query de Venda Anterior a DOACAO 
			If !ANT->(Eof()) .and. Empty(ANT->DOACAO_ANTERIOR)
				// Informa que ja achou a Venda Agregada
				lAchouAgreg := .T.
				
				aDadosAgrega := {}
				Aadd(aDadosAgrega,{"A",ANT->L1_EMISSAO,ANT->L1_DOC,ANT->L1_SERIE,ANT->L1_FILIAL,;
				                   ANT->LJ_NOME,TRB->L1_CLIENTE,TRB->L1_LOJA,TRB->A1_NOME,;
								   ANT->L1_VLRTOT,ANT->L1_VEND,Substr(ANT->A3_NOME,1,30)})
								   
				// Soma Total Agregado
				nTotAgrega += ANT->L1_VLRTOT                     
			Else                             
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Compara a Venda anterior de Doacao com a Venda anterior diferente de Doacao  ณ
				//ณ para verificar se houve uma venda entre a Doacao localizada na Sub-Query e   ณ
				//ณ a DOACAO que esta sendo analizada neste momento, pois se existiu esta venda  ณ
				//ณ quer dizer que a Doacao da Sub-Query jah possui um venda agregada            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If !Empty(ANT->VENDA_ANTERIOR)
					If ANT->VENDA_ANTERIOR > ANT->DOACAO_ANTERIOR
						// Informa que ja achou a Venda Agregada
						lAchouAgreg := .T.
						
						aDadosAgrega := {}
						Aadd(aDadosAgrega,{"A",ANT->L1_EMISSAO,ANT->L1_DOC,ANT->L1_SERIE,ANT->L1_FILIAL,;
						                   ANT->LJ_NOME,TRB->L1_CLIENTE,TRB->L1_LOJA,TRB->A1_NOME,;
										   ANT->L1_VLRTOT,ANT->L1_VEND,Substr(ANT->A3_NOME,1,30)})
										   
						// Soma Total Agregado
						nTotAgrega += ANT->L1_VLRTOT                     
					Endif
				Endif
			Endif
	        // Fecha Query Temporaria
			ANT->(dbCloseArea())
	    Endif
		
		// Total de DOACAO
		nTotDoa += TRB->L1_VLRTOT
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Define a ordem de Impressao (Doacao->Emissao x Agregado->Emissao)  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aDadosResult := {}
		// Se localizou Venda Agregada
		If Len(aDadosAgrega) > 0
			If aDadosDoa[1,2] <= aDadosAgrega[1,2] // Compara EMISSAO
				Aadd(aDadosResult,aDadosDoa)
				Aadd(aDadosResult,aDadosAgrega)
			Else
				Aadd(aDadosResult,aDadosAgrega)
				Aadd(aDadosResult,aDadosDoa)
			Endif                                    
		Else
			Aadd(aDadosResult,aDadosDoa)
		Endif	
		aDadosDoa    := {}
		aDadosAgrega := {}

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Imprime as Vendas de Doacoes e Agragacoes ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nX := 1 to Len(aDadosResult)
			@ Li,000 PSay aDadosResult[nX,1][1]  // D=Doacao / A=Agregacao
			@ Li,002 PSay aDadosResult[nX,1][2]  // Emissao
			@ Li,011 PSay aDadosResult[nX,1][3]  // Cupom
			@ Li,018 PSay aDadosResult[nX,1][4]  // Serie
			@ Li,022 PSay aDadosResult[nX,1][5]  // Loja
			@ Li,025 PSay aDadosResult[nX,1][6]  // Descricao da Loja
			@ Li,040 PSay aDadosResult[nX,1][7]  // Codigo Cliente
			@ Li,047 PSay aDadosResult[nX,1][8]  // Loja Cliente
			@ Li,050 PSay aDadosResult[nX,1][9]  // Nome Cliente
			@ Li,081 PSay aDadosResult[nX,1][10] Picture "@E 99999.99" // Total da Venda
			@ Li,091 PSay aDadosResult[nX,1][11]                        // Codigo Vendedor
			@ Li,098 PSay Substr(aDadosResult[nX,1][12],1,30)          // Nome Vendedor
			Li++
		Next i 
		Li++
		
TRB->(dbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Printa Totais ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ Li, 000 PSay Replicate("_",132)
Li++
@ Li,000 Psay "TOTAL DOADO:"
@ Li,045 PSay nTotDoa Picture "@E 999,999.99"
Li++
@ Li,000 Psay "TOTAL AGREGADO:"
@ Li,045 PSay nTotAgrega Picture "@E 999,999.99"
Li++
Li++
@ Li,000 Psay "INDICE:"
@ Li,045 PSay (nTotDoa/nTotAgrega)*100 Picture "@E 999,999.99%"
Li++
//@ Li,000 Psay "INDICE(New):"
//@ Li,045 PSay ((nTotAgrega/nTotDoa)-1)*100 Picture "@E 999,999.99%"
//Li++

// Fecha tabela temporaria (outras tabela temporarias foram fechadas ao fim de seu uso)
TRB->(dbCloseArea())

If aReturn[5] == 1
   Set Printer To
   Commit
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return NIL