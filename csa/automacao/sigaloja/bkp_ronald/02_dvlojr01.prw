#Include "Protheus.Ch"
/*
Obs.: Este programa foi baseado em outro desenvolvido pela fabrica de softwa-
re - Microsiga. Do Original, somente as queries para pesquisa dos dados foram
mantidos do original.
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DVLOJR01 ºAutor  ³Ronald Piscioneri   º Data ³  17/10/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ CSA              ³Contato ³ ronald.piscioneri@microsiga... º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de DOACAO.                                       º±±
±±º          ³ 01-DOACAO eh localizada pela Tabela do Call Center, atra-  º±±
±±º          ³    ves do parametro FS_DEL048, que contem o codigo da ta-  º±±
±±º          ³    bela usada para a operacao de Doacao.                   º±±
±±º          ³ 02-AGREGADO eh o proximo Atendimento que gerou uma venda   º±±
±±º          ³    para este cliente (UA_STATUS = 'NF.'), podendo ser uma  º±±
±±º          ³    venda Anterior ou Posterior (definida pelo parametro    º±±
±±º          ³    FS_DEL011, que tambem serve para relatorio semelhante,  º±±
±±º          ³    mas que gera as informacoes pelos dados do Sigaloja -   º±±
±±º          ³    tabelas SL's).                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ >>> SX6 <<<                                                º±±
±±º          ³ FS_DEL048 - Codigo da Tabela do Call Center para a operacaoº±±
±±ºParametros³    de Doacao.                                              º±±
±±º          ³ FS_DEL011 - Considera venda com data anterior a operacao   º±±
±±º          ³    de Doacao                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Chamado Via Menu.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus (Protheus 8)                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±ºRonald    ³27/10/05³  -   ³Inclusao de Parametros "Do Grupo - Ate o    º±±
±±º          ³        ³      ³Grupo" e "Da Categoria - Ate a Categoria",  º±±
±±º          ³        ³      ³e totalizacao dos Doacoes que nao geraram   º±±
±±º          ³        ³      ³vendas.                                  	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DVLOJR01()
Local cQuery     	:= ""
Local aOrd       	:= {}
Local cDesc1     	:= "Este programa eh responsavel pela"
Local cDesc2     	:= "geracao do Relatorio de Doacao"
Local cDesc3     	:= "e Agregados."
Private cbtxt    	:= Space(10)
Private cbcont   	:= 00
Private cTitulo  	:= "Relatorio de Doacao e Agregados"
Private m_pag    	:= 01  // Pagina Inicial (deve constar em todos os relatorios)
Private cPerg    	:= "DVR001"
Private nNomeProg 	:= "DVLOJR01"
Private cString  	:= "SUA"
Private aReturn  	:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private wnrel    	:= nNomeProg
Private cTamanho  	:= "M"
Private nTipo    	:= 15
    
// Impede Execucao em Ambiente Codebase
#IFDEF TOP
#ELSE  
    Aviso("Atenção !","Relatorio só pode ser executado na Matriz - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
    Return Nil
#ENDIF

// Ajusta Perguntas
PutSx1(cPerg,"01","Do codigo do Cliente      ?","","","mv_ch1" ,"C",08,0,0,"G","","SA1","","","MV_PAR01"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","") 
PutSx1(cPerg,"02","Ate o codigo do Cliente   ?","","","mv_ch2" ,"C",08,0,0,"G","","SA1","","","MV_PAR02"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSX1(cPerg,"03","Da data de Emissao        ?","","","mv_ch3" ,"D",08,0,0,"G","",""   ,"","","MV_PAR03"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"04","Ate a data de Emissao     ?","","","mv_ch4" ,"D",08,0,0,"G","",""   ,"","","MV_PAR04"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSx1(cPerg,"05","Da Loja                   ?","","","mv_ch5" ,"C",02,0,0,"G","","SM0","","","MV_PAR05"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","") 
PutSx1(cPerg,"06","Ate a Loja                ?","","","mv_ch6" ,"C",02,0,0,"G","","SM0","","","MV_PAR06"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"07","Da Regional               ?","","","mv_ch7" ,"C",03,0,0,"G","",""   ,"","","MV_PAR07"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")  
PutSx1(cPerg,"08","Ate a Regional            ?","","","mv_ch8" ,"C",03,0,0,"G","",""   ,"","","MV_PAR08"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")  
PutSx1(cPerg,"09","Considera Loja do Cliente ?","","","mv_ch9" ,"C",01,0,0,"C","",""   ,"","","MV_PAR09"   ,"Sim"          ,"","","","Nao"       ,"","","","","","","","","","","")  
PutSx1(cPerg,"10","Do Grupo (Prod.Doados)    ?","","","mv_chA" ,"C",04,0,0,"G","",""   ,"","","MV_PAR10"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","SBM","") 
PutSx1(cPerg,"11","Ate o Grupo (Prod.Doados) ?","","","mv_chB" ,"C",04,0,0,"G","",""   ,"","","MV_PAR11"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","SBM","")
PutSx1(cPerg,"12","Da Categoria (P.Doados)   ?","","","mv_chC" ,"C",04,0,0,"G","",""   ,"","","MV_PAR12"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","SZ6","") 
PutSx1(cPerg,"13","Ate a Categoria (P.Doados)?","","","mv_chD" ,"C",04,0,0,"G","",""   ,"","","MV_PAR13"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","SZ6","")


Pergunte(cPerg,.F.)


// Variaveis utilizadas para Impressao do Cabecalho e Rodape (Obrigatorias)
cbtxt    := SPACE(10)
cbcont   := 0
Li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa Relatorio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ StaticRel ³ Autor ³ Ronald Piscioneri     ³ Data ³17/10/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Leia no Cabecalho do Programa                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function StaticRel(lEnd,wnRel,cString,cTamanho,nTipo)                
Local cAliasTRB 	:= "TRB" // Alias para vendas de Doacao por periodo
Local cAliasTRB2 	:= "POS" // Alias para vendas Posteriores a DOACAO
Local cAliasTRB3 	:= "ANT" // Alias para vendas Anteriores  a DOACAO
Local nX			:= 0      
Local lAchouAgreg 	:= .F.
Local aStrucTRB		:= SUA->(dbStruct())
Local nTotDoa   	:= 0 
Local nTotAgrega	:= 0 
Local lDataAnt		:= GetMV("FS_DEL011")  // Pesquisa Notas Agregadas anteriores a Doacao
Local cTabPgDoa	    := GetMV("FS_DEL048")  // Tabela de precos para DOACAO
Local nTotQAgreg    := 0
Local nTotQDoa      := 0
Local _nQtd         := 0
Local _cItem        := ""
Local _nItem        := 1
Local _cCodProd     := ""
Local lAchou        := .T.
Local lAchaSL1      := .T.
Local lAchaSL2      := .T.
Local lL1Venda      := .F.
Local aDadosDoa		:= {}
Local aDadosAgrega	:= {}
Local aDadosResult	:= {}
Local nTotSemAp     := 0
Local nQtdSemAp     := 0
Local nPosNota		:= 0  
Local aNota			:= {}
Local lPar          := .T.
Local cGrupo		:= ""          
Local cCateg		:= ""          
Local Cabec2		:= ""          
Local Cabec1		:= "T DT.EMISS NF-SERIE   FIL NOME CLIENTE              VALOR QTD VEND.   CODIGO CONVENIO             PRODUTO"
                      //T DT.EMISS NF-SERIE   FIL NOME CLIENTE              VALOR QTD VEND.   CODIGO CONVENIO             PRODUTO
                      //X 99/99/99 000001-A00 99  123456789D123456789V 999,999,99 999 999999  999999 123456789D123456789V 123456789D12345
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                                                ³
//³	MV_PAR01    Do codigo do cliente;													³
//³	MV_PAR02	Ate o codigo do cliente;												³
//³	MV_PAR03	Da data de emissao - data de emissao do atendimento;					³
//³	MV_PAR04	Ate a data de emissao - data de emissao do atendimento; 				³
//³	MV_PAR05	Da loja - codigo da loja Della Via;										³
//³	MV_PAR06	Ate a loja - codigo da loja Della Via;									³
//³	MV_PAR07	Da regional - codigo da regional em que esta a loja Della Via;			³
//³	MV_PAR08	Ate a regional - codigo da regional em que esta a loja Della Via;		³
//³	MV_PAR09	Considera Loja do Cliente (1=SIM e 2=NAO) 								³
//³	MV_PAR10	Do Grupo - Grupo de Produtos Inicial 									³
//³	MV_PAR11	Ate o Grupo - Grupo de Produtos Final                           	    ³
//³	MV_PAR12	Da Categoria - Categoria de Produtos Inicial                            ³
//³	MV_PAR13	Ate a Categoria - Categoria de Produtos Finall          				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Filtra em SUA as Vendas de Doacao (UA_TABELA=FS_DEL048)


cQuery := "SELECT UA_TABELA,UA_EMISSAO,UA_DOC,UA_SERIE,UA_NUM,UA_CODCON,            "
cQuery += " UA_FILIAL,LJ_NOME,                                         				" 
cQuery += " UA_CLIENTE,UA_LOJA,A1_NOME,                                				" 
cQuery += " UA_VALBRUT,UA_VEND,A3_NOME                                  			" 
cQuery += " FROM " + RetSqlName("SUA")+" UA, "+RetSqlName("SA1")+" A1,				"
cQuery +=            RetSqlName("SA3")+" A3, "+RetSqlName("SLJ")+" LJ  			    "
cQuery += " WHERE UA_STATUS = 'NF.'                                 				"
cQuery += " AND   UA_TABELA		=	'"+ctABPgDoa+"'                   			    "
cQuery += " AND   UA_CLIENTE BETWEEN '"+MV_PAR01+"'AND'"+MV_PAR02+"' 			  	"
cQuery += " AND   UA_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"'AND'"+DtoS(MV_PAR04)+"'	"
cQuery += " AND   UA_FILIAL  BETWEEN '"+MV_PAR05+"'AND'"+MV_PAR06+"'				"
cQuery += " AND   A1_REGIAO  BETWEEN '"+MV_PAR07+"'AND'"+MV_PAR08+"'				"
cQuery += " AND   UA.D_E_L_E_T_ <> 	'*'                               			    "
cQuery += " AND   A1.D_E_L_E_T_ <> 	'*'                            			        "
cQuery += " AND   A3.D_E_L_E_T_ <> 	'*'                                 			"
cQuery += " AND   LJ.D_E_L_E_T_ <> 	'*'                                 			"
cQuery += " AND   A1_FILIAL	 	= 	'"+xFilial("SA1")+"'               				"
cQuery += " AND   A3_FILIAL 	= 	'"+xFilial("SA3")+"'               				"
cQuery += " AND   LJ_FILIAL	 	= 	'"+xFilial("SLJ")+"'               				"
cQuery += " AND   UA_CLIENTE	=	A1_COD                              			"
cQuery += " AND   UA_LOJA   	=	A1_LOJA                             			"
cQuery += " AND   UA_VEND   	=	A3_COD                              			"
cQuery += " AND   UA_FILIAL 	=	LJ_RPCFIL                           			"
cQuery += " ORDER BY UA_CLIENTE,UA_LOJA,UA_EMISSAO,UA_DOC,UA_SERIE     				"
cQuery := ChangeQuery(cQuery)

// Cria tabela temporaria para o Relatorio
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
                          
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Venda de DOACAO                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDadosDoa := {}

//                        1           2                 3            4                5                6              7                 8             9              10                11                  12                  13              14          15       16
//		Aadd(aDadosDoa,{ "D" , TRB->UA_EMISSAO , TRB->UA_DOC , TRB->UA_SERIE , TRB->UA_FILIAL , TRB->LJ_NOME , TRB->UA_CLIENTE , TRB->UA_LOJA , TRB->A1_NOME , TRB->UA_VALBRUT , TRB->UA_VEND , Substr(TRB->A3_NOME,1,30), TRB->UA_NUM , TRB->UA_CODCON, cGRUPO , cCATEG })
        
        cGrupo := ""
        cCateg := ""
        dbSelectArea("SUB")
        dbSetOrder(1)
        dbSeek(TRB->UA_FILIAL+TRB->UA_NUM+"01")
        If Found()
           dbSelectArea("SB1")
           dbSetOrder(1)
           dbSeek("  "+SUB->UB_PRODUTO)
           If Found()
              cGrupo := SB1->B1_GRUPO
              cCateg := SB1->B1_CATEG
           EndIf    
        EndIf
        dbSelectArea("TRB")

		Aadd(aDadosDoa,{"D",TRB->UA_EMISSAO,TRB->UA_DOC,TRB->UA_SERIE,TRB->UA_FILIAL,;
		                TRB->LJ_NOME,TRB->UA_CLIENTE,TRB->UA_LOJA,TRB->A1_NOME,TRB->UA_VALBRUT,;
						TRB->UA_VEND,Substr(TRB->A3_NOME,1,30),TRB->UA_NUM, TRB->UA_CODCON,cGRUPO,cCATEG})
	
        // Limpa informacao de localizacao de Venda Agregada
		lAchouAgreg := .F.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Venda AGREGADA                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//³ Sub-Query com Vendas posteriores                   ³
		//³ Ignoro a LOJA da Venda Agregada                    ³
		//³ OBS: Localiza apenas o primeiro registro utilizan- ³
		//³      do o "FETCH FIRST 1 ROWS ONLY" do DB2         ³ 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cQuery := "SELECT UA_TABELA,UA_EMISSAO,UA_DOC,UA_SERIE,UA_NUM,UA_CODCON,"
		cQuery += " UA_FILIAL,LJ_NOME,                                         	"
		cQuery += " UA_VALBRUT,UA_VEND,A3_NOME,UA.R_E_C_N_O_                   	"
		cQuery += " FROM " + RetSqlName("SUA")+" UA,                           	"
		cQuery +=            RetSqlName("SA3")+" A3, "+RetSqlName("SLJ")+" LJ 	"
		cQuery += " WHERE UA_CLIENTE       = '"+TRB->UA_CLIENTE+"'             	"

		// Considera Loja do Cliente (1=SIM e 2=NAO) 
		If MV_PAR09==1
			cQuery += " AND   UA_LOJA          = '"+TRB->UA_LOJA+"'           	"
		Endif
		cQuery += " AND   UA_TABELA 	<>	'"+cTabPgDoa+"'                    "
		cQuery += " AND   UA_EMISSAO 	>= 	'"+DtoS(TRB->UA_EMISSAO)+"'        	"
		cQuery += " AND   UA_DOC     	<> 	'"+     TRB->UA_DOC     +"'        	"
		cQuery += " AND   UA_SERIE   	<> 	'"+     TRB->UA_SERIE   +"'        	"
		cQuery += " AND   UA.D_E_L_E_T_ <> 	'*'                                 "
		cQuery += " AND   A3.D_E_L_E_T_ <> 	'*'                                 "
		cQuery += " AND   LJ.D_E_L_E_T_ <> 	'*'                                 "
		cQuery += " AND   A3_FILIAL 	= 	'"+xFilial("SA3")+"'               	"
		cQuery += " AND   LJ_FILIAL 	= 	'"+xFilial("SLJ")+"'               	"
		cQuery += " AND   UA_VEND   	=	A3_COD                              "
		cQuery += " AND   UA_FILIAL 	=	LJ_RPCFIL                           "
  		cQuery += " AND   UA_STATUS 	= 	'NF.'                               "
		cQuery += " ORDER BY UA_EMISSAO ASC                                    	"
		cQuery += " FETCH FIRST 1 ROWS ONLY                                    	"
		cQuery := ChangeQuery(cQuery)

		// Cria tabela temporaria para o Relatorio
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
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a Nota Fiscal em questao ja nao        ³
			//³ foi utilizada como Agregada nas vendas posteriores ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    nPosNota := aScan(aNota,{ |x| x[1] == POS->R_E_C_N_O_ })
		    If nPosNota == 0                      

				// Desconsidera Agregacao pois a mesma ja foi agregada a outra Doacao
				lAchouAgreg := .F.

		    	// Alimenta Array com a Nota jah utilizada como Agregada
				Aadd(aNota,{POS->R_E_C_N_O_})

				// Alimenta Arrays com os dados da Venda Agregada para Impressao posterior
				aDadosAgrega := {}

//                            [1]        [2]             [3]           [4]              [5]              [6]               [7]             [8]          [9]            [10]               [11]             [12]                  [13]              [14]
//				aDadosAgrega,{"A", POS->UA_EMISSAO , POS->UA_DOC , POS->UA_SERIE , POS->UA_FILIAL , POS->LJ_NOME , TRB->UA_CLIENTE , TRB->UA_LOJA , TRB->A1_NOME , POS->UA_VALBRUT , POS->UA_VEND , Substr(POS->A3_NOME,1,28), POS->UA_NUM , POS->UA_CODCON }

				Aadd(aDadosAgrega,{"A",POS->UA_EMISSAO,POS->UA_DOC,POS->UA_SERIE,POS->UA_FILIAL,;
				                   POS->LJ_NOME,TRB->UA_CLIENTE,TRB->UA_LOJA,TRB->A1_NOME,;
								   POS->UA_VALBRUT,POS->UA_VEND,Substr(POS->A3_NOME,1,28),POS->UA_NUM,POS->UA_CODCON,"",""})
		    Endif
		Endif

        // Fecha Query Temporaria
		POS->(dbCloseArea())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao achou Venda AGREGADA posterior procura      ³
		//³ com data anterior, desde que esta ja nao seja      ³
		//³ agregada de outra venda.                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//³ OBS: o parametro lDataAnt(FS_DEL011)=.T. habilita  ³
		//³ localizacao de vendas anteriores a DOACAO,         ³
		//³ lDataAnt=.F. ignora vendas anteriores.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (!lAchouAgreg).and.(lDataAnt==.T.)
			cQuery := "SELECT UA_TABELA,UA_EMISSAO,UA_DOC,UA_SERIE,UA_NUM,UA_CODCON,	"
			cQuery += " UA_FILIAL,LJ_NOME,                                         	"
			cQuery += " UA_VALBRUT,UA_VEND,A3_NOME,                                 	"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nesta Sub-Query eu localizo a primeira Venda de DOACAO  ³
			//³ com data anterior a esta Venda Agregada                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			cQuery += " (SELECT UA_DOC                                     			"
			cQuery += " (SELECT UA_EMISSAO                                     		"
			cQuery += "  FROM SUA010 UAZ                                           	"
			cQuery += "  WHERE UA_CLIENTE   = UA.UA_CLIENTE                    	    "

			// Considera Loja do Cliente (1=SIM e 2=NAO)
			If MV_PAR09==1
				cQuery += " AND   UA_LOJA          = '"+TRB->UA_LOJA+"'           	"
			Endif
			cQuery += "  AND   UA_TABELA 	= '"+ctABPgDoa+"'                     	"
			cQuery += "  AND   UA_EMISSAO 	< UA.UA_EMISSAO                        	"
			cQuery += "  AND   UAZ.D_E_L_E_T_<> '*'  	                           	"
			cQuery += "  AND   UA_STATUS = 'NF.'                                    "
			cQuery += "  ORDER BY UA_EMISSAO DESC                                 	"
			cQuery += "  FETCH FIRST 1 ROWS ONLY)DOACAO_ANTERIOR,                  	"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nesta Sub-Query eu localizo a primeira Venda diferente de DOACAO          ³
			//³ com data anterior a esta Venda Agregada que sera usada para verificar se  ³
			//³ houve uma Agregacao entre a data da Doacao localizada na Sub-Query acima  ³
			//³ e a DOACAO que esta sendo analizada no While principal do programa.       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery += " (SELECT UA_EMISSAO                                         	"
			cQuery += " FROM SUA010 UAZ                                            	"
			cQuery += " WHERE UA_CLIENTE   = UA.UA_CLIENTE                    	    "

			// Considera Loja do Cliente (1=SIM e 2=NAO)
			If MV_PAR09==1
				cQuery += " AND   UA_LOJA          = '"+TRB->UA_LOJA+"'           	"
			Endif
			cQuery += " AND   UA_TABELA 	<> '"+cTabPgDoa+"'                    	"
			cQuery += " AND   UA_EMISSAO 	< UA.UA_EMISSAO                        	"
			cQuery += " AND   UAZ.D_E_L_E_T_<> '*'  	                           	    "
			cQuery += " AND   UA_STATUS    	= 'NF.'                                 	"
			cQuery += " ORDER BY UA_EMISSAO DESC                                 	"
			cQuery += " FETCH FIRST 1 ROWS ONLY)VENDA_ANTERIOR                     	"
			cQuery += " FROM " + RetSqlName("SUA")+" UA,                           	"
			cQuery +=            RetSqlName("SA3")+" A3, "+RetSqlName("SLJ")+" LJ 	"
			cQuery += " WHERE UA_CLIENTE       = '"+TRB->UA_CLIENTE+"'             	"

			// Considera Loja do Cliente (1=SIM e 2=NAO)
			If MV_PAR09==1
				cQuery += " AND   UA_LOJA          = '"+TRB->UA_LOJA+"'           	"
			Endif
			cQuery += " AND   UA_TABELA 	<>	'"+cTabPgDoa+"'                    "
			cQuery += " AND   UA_EMISSAO 	< 	'"+DtoS(TRB->UA_EMISSAO)+"'        	"
			cQuery += " AND   UA.D_E_L_E_T_ <> 	'*'                                 "
			cQuery += " AND   A3.D_E_L_E_T_ <> 	'*'                                 "
			cQuery += " AND   LJ.D_E_L_E_T_ <> 	'*'                                 "
			cQuery += " AND   A3_FILIAL 	= 	'"+xFilial("SA3")+"'               	"
			cQuery += " AND   LJ_FILIAL	 	= 	'"+xFilial("SLJ")+"'               	"
			cQuery += " AND   UA_VEND   	=	A3_COD                              "
			cQuery += " AND   UA_FILIAL 	=	LJ_RPCFIL                           "
			cQuery += " AND   UA_STATUS     =   'NF.'                               "
			cQuery += " ORDER BY UA_EMISSAO DESC                                  	"
			cQuery += " FETCH FIRST 1 ROWS ONLY                                  	"
			cQuery := ChangeQuery(cQuery)

			// Cria tabela temporária para o Relatorio
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

//                                  1              2              3            4               5                6              7                 8              9              10              11                    12                   13
//				Aadd(aDadosAgrega,{"A" , ANT->UA_EMISSAO , ANT->UA_DOC , TRB->UA_SERIE , ANT->UA_FILIAL , ANT->LJ_NOME , TRB->UA_CLIENTE , TRB->UA_LOJA , TRB->A1_NOME , ANT->UA_VALBRUT , ANT->UA_VEND , Substr(ANT->A3_NOME,1,30) , ANT->UA_NUM, ANT->UA_CODCON})

				Aadd(aDadosAgrega,{"A",ANT->UA_EMISSAO,ANT->UA_DOC,TRB->UA_SERIE,ANT->UA_FILIAL,;
				                   ANT->LJ_NOME,TRB->UA_CLIENTE,TRB->UA_LOJA,TRB->A1_NOME,;
								   ANT->UA_VALBRUT,ANT->UA_VEND,Substr(ANT->A3_NOME,1,30),ANT->UA_NUM,ANT->UA_CODCON,"",""})
			Else                             

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Compara a Venda anterior de Doacao com a Venda anterior diferente de Doacao  ³
				//³ para verificar se houve uma venda entre a Doacao localizada na Sub-Query e   ³
				//³ a DOACAO que esta sendo analizada neste momento, pois se existiu esta venda  ³
				//³ quer dizer que a Doacao da Sub-Query jah possui um venda agregada            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(ANT->VENDA_ANTERIOR)
					If ANT->VENDA_ANTERIOR > ANT->DOACAO_ANTERIOR

						// Informa que ja achou a Venda Agregada
						lAchouAgreg := .T.
						
						aDadosAgrega := {}
						Aadd(aDadosAgrega,{"A",ANT->UA_EMISSAO,ANT->UA_DOC,TRB->UA_SERIE,ANT->UA_FILIAL,;
						                   ANT->LJ_NOME,TRB->UA_CLIENTE,TRB->UA_LOJA,TRB->A1_NOME,;
										   ANT->UA_VALBRUT,ANT->UA_VEND,Substr(ANT->A3_NOME,1,30),ANT->UA_NUM,ANT->UA_CODCON,"",""})
					Endif
				Endif
			Endif

	        // Fecha Query Temporaria
			ANT->(dbCloseArea())
	    Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define a ordem de Impressao (Doacao->Emissao x Agregado->Emissao)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


        // - Posicoes dos arrays aDadosAgrega, aDadosDoa e aDadosResult:
        // -
        // - [1]  Tipo: D ou A                          Se UA_TABELA == cTabPgDoa, atribui-se "D" (Doacao)
        // - [2]  Data de Emissao                       (UA_EMISSAO)
        // - [3]  Nro. do Documento/NF                  (UA_DOC)
        // - [4]  Serie do Documento/NF                 (UA_SERIE)
        // - [5]  Filial                                (UA_FILIAL)
        // - [6]  Nome da Loja Della Via                (LJ_NOME)
        // - [7]  Codigo do Cliente                     (UA_CLIENTE)
        // - [8]  Loja do Cliente                       (UA_LOJA)
        // - [9]  Nome do Cliente                       (A1_NOME)
        // - [10] Valor Total da Venda                  (UA_VALBRUT)
        // - [11] Codigo do Vendedor                    (UA_VEND)
        // - [12] Nome do Vendedor                      (A3_NOME)
        // - [13] Nro. do Atendimento do Call Center    (UA_NUM)
        // - [14] Codigo do Convenio                    (UA_CODCON)
        // - [15] Grupo do Produto Doado - 1o. Item     (B1_GRUPO)
        // - [16] Categoria do Produto Doado - 1o. Item (B1_CATEG)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime as Vendas de Doacoes e Agragacoes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        lPar       := .T.
        nX         := 1
        While nX <= Len(aDadosResult) .AND. lPar == .T.
            //-  Verifica se os produtos doados encontram-se nos Parametros "Do Grupo / Ate o Grupo"
            //-  e "Da Categoria / Ate a Categoria"
            If aDadosResult[nX,1][1] == 'D'
               If aDadosResult[nX,1][15] < mv_par10
                  lPar := .F.
               EndIf   
               If aDadosResult[nX,1][15] > mv_par11
                  lPar := .F.
               EndIf   
               If aDadosResult[nX,1][16] < mv_par12
                  lPar := .F.
               EndIf   
               If aDadosResult[nX,1][16] > mv_par13
                  lPar := .F.
               EndIf
            EndIf
            If lPar == .F.
               Loop
            EndIf      

            _nQtd     := 0
            _cCodProd := ""
            lAchaSL1  := .T.
            lAchaSL2  := .T.
            lL1Venda  := .F.
            lAchou    := .T.
		    _nQtd     := 0
	       
            //-Imprime o array aDadosResult
 		    @ Li,000 PSay aDadosResult[nX,1][1]  // D=Doacao / A=Agregacao
			@ Li,002 PSay aDadosResult[nX,1][2]  // Emissao
			@ Li,011 PSay aDadosResult[nX,1][3]  // Nf
			@ Li,017 PSay "-"
			@ Li,018 PSay aDadosResult[nX,1][4]  // Serie
			@ Li,022 PSay aDadosResult[nX,1][5]  // Filial
			@ Li,026 PSay Substr(aDadosResult[nX,1][9],1,20)  // Nome do Cliente
			@ Li,047 PSay Transform((aDadosResult[nX,1][10]),"999,999.99")  // Valor da Operacao
            lAchou := .T.
            _nItem := 1
            _cItem := "01"
            dbSelectArea("SUB")
			dbSetOrder(1)
            While lAchou == .T.
			   dbSeek(aDadosResult[nX,1][5]+aDadosResult[nX,1][13]+_cItem)
		       If Found()
			      _nQtd     := SUB->UB_QUANT
			      _cCodProd := SUB->UB_PRODUTO
			      If aDadosResult[nX,1][1] == "D"
			         nTotQDoa := nTotQDoa + SUB->UB_QUANT
			      EndIf   
			      dbSelectArea("SB1")
			      dbSetOrder(1)
			      dbSeek("  "+ SUB->UB_PRODUTO)
			      If Found()
			         _cCodProd := Alltrim(SUB->UB_PRODUTO) + "-" + Substr(Alltrim(SB1->B1_DESC),1,26)
			      Else
			         _cCodProd := Alltrim(SUB->UB_PRODUTO)
			      EndIf  
			      _nItem++
			      _cItem := StrZero(_nItem,2)
			   Else
			      lAchou := .F.
			   EndIf
			EndDo   
	        @ Li,058 PSay Transform(_nQtd,"999")  //-Quantidade
			@ Li,062 PSay aDadosResult[nX,1][11]  //-Cod. Vendedor
			If Alltrim(aDadosResult[nX,1][14]) <> ""
			   dbSelectArea("PA6")
			   dbSetOrder(1)
			   dbSeek("  "+aDadosResult[nX,1][14])
			   If Found()
			      @ Li,069 PSay aDadosResult[nX,1][14]  // Cod.Convenio
			      @ Li,076 PSay Substr(PA6->PA6_DESC,1,20)
			   Else
			      @ Li,069 PSay "                           "
			   EndIf
			Else         
			   @ Li,069 PSay "                           "
            EndIf
			If aDadosResult[nX,1][1] == "D" .AND. Alltrim(_cCodProd) <> ""
			   @ Li,097 PSay _cCodProd
			EndIF		      

            // Caso nao possua vendas agregadas no Call Center, procura no SL1 (Orcamentos Sigaloja)
            If Len(aDadosResult) < 2 .AND. aDadosResult[nX,1][1] = "D"
               dbSelectArea("SL1")
               dbSetOrder(6) //-L1_FILIAL + L1_CLIENTE + L1_LOJA
 		       While lAchaSL1 == .T.
 		          If MV_PAR09==1
			         dbSeek (aDadosResult[nX,1][5] + aDadosResult[nX,1][7]+ aDadosResult[nX,1][8])
                  Else
                     dbSeek (aDadosResult[nX,1][5] + aDadosResult[nX,1][7])
                  EndIF
                  If Found()
                     If SL1->L1_DOC == "      "
                        lAchaSL1 := .F.
                        Loop
                     EndIf
                     Li++
                     lL1Venda := .T.
                     _nQtd    := 0
// ----------------> Desabilitado: a instrucao abaixo nao considera vendas com data diferente da data da Doacao.
//                   If DtoS(SL1->L1_EMISSAO) <> DtoS(aDadosResult[nX,1][2])
//                      lAchaSL1 := .F.
//                      Loop
//                   EndIf
                     @ Li,000 PSay "A"
			         @ Li,002 PSay DtoC(SL1->L1_EMISSAO) //aDadosResult[nX,1][2]  // Emissao
			         @ Li,011 PSay SL1->L1_DOC
			         @ Li,017 PSay "-"
			         @ Li,018 PSay SL1->L1_SERIE
			         @ Li,022 PSay SL1->L1_FILIAL
			         @ Li,026 PSay Substr(SL1->L1_NOMCLI,1,20)
			         @ Li,047 PSay Transform(SL1->L1_VALBRUT,"999,999.99")
                     _nItem := 1
			         _cItem := "01"
			         dbSelectArea("SL2")
			         dbSetOrder(1) // L2_FILIAL + L2_NUM + L2_ITEM
			         While lAchaSL2 == .T.
			            dbSeek(SL1->L1_FILIAL+SL1->L1_NUM+_cItem)
			            If Found()
			               _nQtd := _nQtd + SL2->L2_QUANT
			               _nItem++
			               _cItem := StrZero(_nItem,2)
			            Else
			               lAchaSL2 := .F.
			            EndIf
	                    SL2->(dbSkip())
	                    Loop
			         EndDo
			         @ Li,058 PSay Transform (_nQtd,"999")
			         @ Li,062 PSay SL1->L1_VEND
			         @ Li,069 PSay SL1->L1_CODCON
			         If Alltrim(SL1->L1_CODCON) <> ""
			            dbSelectArea("PA6")
			            dbSetOrder(1)
			            dbSeek("  "+SL1->L1_CODCON)
			            If Found()
			               @ Li,076 PSay Substr(PA6->PA6_DESC,1,20)
			            EndIf
                     EndIf
                     nTotAgrega := nTotAgrega + SL1->L1_VALBRUT
                     nTotQAgreg := nTotQAgreg + _nQtd
                     lAchaSL1 := .F.
                  Else
                     lAchaSL1 := .F.
                  EndIf
 	              Loop   
		       EndDo
		    EndIf

            // - Totalizacao: por Doacao, Agregado e Nao Aproveitado (Doacao que nao gerou venda)
            Do Case
               Case aDadosResult[nX,1][1] == 'A'
                  nTotAgrega := nTotAgrega + aDadosResult[nX,1][10]
                  nTotQAgreg := nTotQAgreg + _nQtd
               Case aDadosResult[nX,1][1] == 'D' 
                  nTotDoa    := nTotDoa    + aDadosResult[nX,1][10]
                  If Len(aDadosResult) < 2 .AND. lL1Venda == .F. // - Se nao houver vendas no Call Center e nao achou no Sigaloja, soma como nao aproveitados
                     nTotSemAp  := nTotSemAp  + aDadosResult[nX,1][10]
                     nQtdSemAp  := nQtdSemAp  + _nQtd
                  EndIf
            EndCase

            // - Volta Variaveis de Controle aos valores padroes a serem usados no proximo Loop
            lL1Venda   := .F.
            _nQtd      := 0
            _cCodProd  := ""
			      
            Li++
            nX++
            Loop
        EndDo
        If lPar == .T.
  		   Li++
  		EndIf   
TRB->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Imprime os Totais  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ Li, 000 PSay Replicate("_",132)
Li++
Li++
@ Li,000 Psay "TOTAL DOADO:"
@ Li,045 PSay nTotDoa Picture "@E 999,999,999.99"
Li++
@ Li,000 Psay "QUANT.DOADA:"
@ Li,045 PSay nTotQDoa Picture "@E 99999999999999"
Li++
Li++
@ Li,000 Psay "TOTAL AGREGADO:"
@ Li,045 PSay nTotAgrega Picture "@E 999,999,999.99"
Li++
@ Li,000 Psay "QUANT.AGREGADA:"
@ Li,045 PSay nTotQAgreg Picture "@E 99999999999999"
Li++
Li++
@ Li,000 Psay "INDICE:"
@ Li,048 PSay (nTotDoa/nTotAgrega)*100 Picture "@E 999,999.99%"
Li++
Li++
@ Li,000 Psay "DOACAO SEM APROVEITAMENTO:"
@ Li,045 PSay nTotSemAp Picture "@E 999,999,999.99"
Li++
@ Li,000 Psay "QUANT. SEM APROVEITAMENTO:"
@ Li,045 PSay nQtdSemAp  Picture "@E 99999999999999"
Li++
@ Li,000 Psay "INDICE DE APROVEITAMENTO"
@ Li,048 PSay ((nTotQDoa-nQtdSemAp)/nTotQDoa)*100 Picture "@E 999,999.99%"
Li++
Li++

// Fecha tabela temporaria (outras tabela temporarias foram fechadas ao fim de seu uso)
TRB->(dbCloseArea())

If aReturn[5] == 1
   Set Printer To
   Commit
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return NIL