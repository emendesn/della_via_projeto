/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TMKR041  ³ Autor ³ Marcos Daniel         ³ Data ³ 29/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cobrancas pendentes que estao na carteira de cobrancas     ³±±
±±³          ³ de um Operador.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AP8                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Armando   ³20/10/03³811   ³ Reisao do fonte do relatorio criado pela   ³±±
±±³          ³        ³      ³ equipe da fabrica de software.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Thiago G. ³03/08/04³811   ³Corrigido a IndRegua para que apos o seu 	  ³±±
±±³          ³        ³      ³processamento os indices do SU7 voltem a    ³±±
±±³          ³        ³      ³ser os originais.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UTMKR041()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel   	:= "TMKR041"  	 		// Nome do Arquivo utilizado no Spool
Local Titulo 	:= "Pendencias agendadas para o Operador"
Local cDesc1 	:= "Este programa ira emitir uma relacao das"
Local cDesc2 	:= "cobranças pendentes que estão na carteira"
Local cDesc3 	:= "de cobrança de um Operador."
Local nomeprog	:= "TMKR041.PRX"		// nome do programa
Local cString 	:= "SU7"		  		// Alias utilizado na Filtragem
Local lDic    	:= .F. 					// Habilita/Desabilita Dicionario
Local lComp   	:= .F. 					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro 	:= .T. 					// Habilita/Desabilita o Filtro


Private Tamanho := "G" 					// P/M/G
Private Limite  := 220 					// 80/132/220
Private aReturn := { "Zebrado",;			// [1] Reservado para Formulario	//"Zebrado"
					 1,;			  	// [2] Reservado para N§ de Vias
					 "Destinatario",;			// [3] Destinatario					//"Administracao"
					 2,;				// [4] Formato => 1-Comprimido 2-Normal
					 2,;	    		// [5] Midia   => 1-Disco 2-Impressora
					 1,;				// [6] Porta ou Arquivo 1-LPT1... 4-COM1...
					 "",;				// [7] Expressao do Filtro
					 1 } 				// [8] Ordem a ser selecionada
										// [9]..[10]..[n] Campos a Processar (se houver)
Private m_pag   := 1  				 	// Contador de Paginas
Private nLastKey:= 0  				 	// Controla o cancelamento da SetPrint e SetDefault
Private cPerg   := "TMK041"  		 	// Pergunta do Relatorio
Private aOrdem  := {}  				 	// Ordem do Relatorio

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                          ³
//³ Mv_Par01           // Da Filial                               ³
//³ Mv_Par02           // Ate a Filial                            ³
//³ Mv_Par03           // Do Grupo                                ³
//³ Mv_Par04           // Ate o Grupo                             ³
//³ Mv_Par05           // Do Operador                             ³
//³ Mv_Par06           // Ate o Operador                          ³
//³ Mv_Par07           // Tipo: 1-Interno; 2-Externo; 3-Ambos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

RptStatus({|lEnd| TK041Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TK041Imp  ³ Autor ³ Marcos Daniel         ³ Data ³ 29/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cobrancas pendentes que estao na carteira de cobrancas     ³±±
±±³          ³ de um Operador.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AP8                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function TK041Imp(lEnd,wnrel,cString,nomeprog,Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao Do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLi		:= 0			// Linha a ser impressa
Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio
Local cbCont	:= 0			// Numero de Registros Processados
Local cbText	:= SPACE(10)	// Mensagem do Rodape
Local cCabec1	:= "" 			// Label dos itens
Local cCabec2	:= "" 			// Label dos itens

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis especificas para este relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cSimb1   	:= Alltrim(GetMv("MV_SIMB1")) 	// Simbolo da moeda 1
Local aFilial	:= {}							// Array com as filiais válidas para o relatorio
Local nTotalDiv	:= 0							// Totaliza o valor da divida
Local nTotFil	:= 0							// Totalizador por filial
Local nTotOpe	:= 0							// Totalizador po Operador
Local nTotGer	:= 0							// Total Geral
Local nContOpe 	:= 0							// Total de Operadores a ser impresso
Local lExtACF  	:= .F.							// Informa se o dado existe no ACF
Local lCabOpe 	:= .T.							// Informa se esse é um novo Operador
Local lTotOpe  	:= .F.							// Informa se e necessario imprimir o totalizador
Local lTotGer	:= .F.							// Verifica se e fim de arquivo(SU7)
Local nX		:= 0 							// Contador

#IFDEF TOP
	cQuery := ""
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Encontra as Filiais validas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SM0")
DbGotop()
While !Eof()

	If M0_CODIGO <> cEmpAnt .OR. M0_CODFIL < Mv_Par01 .OR. M0_CODFIL > Mv_Par02
		DbSkip()
		Loop
	Endif

	Aadd(aFilial,{M0_CODIGO, M0_CODFIL, M0_FILIAL})

	DbSkip()
End

DbSelectArea("SU7")
DbSetOrder(1)
SetRegua(RecCount())

#IFDEF TOP

	cQuery := "SELECT SU7.U7_FILIAL, SU7.U7_POSTO, SU7.U7_COD, SU7.U7_NOME, SU7.D_E_L_E_T_  "
	cQuery += "FROM " + RetSQLName("SU7") + " SU7 "
	cQuery += "WHERE "
	
	cQuery += "SU7.U7_POSTO >= '" + Mv_Par03 + "' AND SU7.U7_POSTO <= '" + Mv_Par04 + "' AND "
	cQuery += "SU7.U7_COD >= '" + Mv_Par05 + "' AND SU7.U7_COD <= '" + Mv_Par06 + "' AND "
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ So acrescenta o filtro a query se for selecionada uma Ocorrencia.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cQuery += "SU7.D_E_L_E_T_ = ' ' "
	
	cQuery += "ORDER BY SU7.U7_FILIAL, SU7.U7_COD"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o tratamento/compatibilidade com o Top Connect    		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cQuery := ChangeQuery(cQuery)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pega uma sequencia de alias para o temporario.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cAliasTrb := GetNextAlias()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o ALIAS do arquivo temporario                     	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasTrb, .F., .T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deixa selecionado o arquivo filtrado                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea(cAliasTrb)
	DbGoTop()
	
#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ variaveis para aconfiguracao do IndRegua. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cArqTrb 	:= CriaTrab( Nil, .F. )				// Nome do arquivo temporario
	cAliasTrb 	:= "SU7"							// Tabela filtrada
	cIndex	 	:= "U7_FILIAL + U7_COD"				// Indice

	cQuery := "SU7->U7_POSTO >= '" + Mv_Par03 + "' .AND. SU7->U7_POSTO <= '" + Mv_Par04 + "' .AND."
	cQuery += "SU7->U7_COD >= '" + Mv_Par05 + "' .AND. SU7->U7_COD <= '" + Mv_Par06 + "'"

	DbSelectArea(cAliasTrb)
	IndRegua(cAliasTrb, cArqTrb, cIndex,, cQuery, "Selecionando") // "Selecionando as ocorrencias ..."
	nIndex := RetIndex("SU7")
	DbSetIndex(cArqTrb+OrdBagExt())
	DbSetOrder(nIndex+1)
    DbSeek(xFilial(cAliasTrb))

	SetRegua(RecCount())

#ENDIF

lTotGer := Eof()

While !Eof()
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario.                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If (!Empty(aReturn[7])) .AND. (!&(aReturn[7]))
		DbSkip()
		Loop
	Endif
	
	DbSelectArea("SU0")
	DbSetOrder(1)
	DbSeek(xFilial("SU0") + (cAliasTrb)->U7_POSTO)
	
	If Mv_Par07 <> 3 .AND. Alltrim(Str(Mv_Par07)) <> SU0->U0_TIPOIE
		DbSelectArea(cAliasTrb)
		DbSkip()
		Loop
	Endif
	
	If lEnd
		@Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os registros do relatorio.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("SU4")
	DbSetOrder(5)
	DbSeek(xFilial("SU4"))
	
	If DbSeek(xFilial("SU4") + (cAliasTrb)->U7_COD)      
	
		_cOpeAnt	:= (cAliasTrb)->U7_COD
	
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay __PrtFatLine()
						
//		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
//		@ nLi,000		PSay "Operador: " + (cAliasTrb)->U7_COD + "-" + (cAliasTrb)->U7_NOME // "Operador: "
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay "Cliente  Loja  Razão Social                              CPF-CNPJ            Total Divida    Enviado   Retorno   Hora  Nome Completo                        Atendimento  Data      Ativo" // "Cliente  Loja  Razão Social                              CPF-CNPJ            Total Divida    Enviado   Retorno   Hora  Nome Completo                        Atendimento  Data      Ativo/Receptivo"

		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay __PrtThinLine()
		lCabOpe := .F.
				
		Do While 	SU4->U4_FILIAL	==	xFilial("SU4")			.And.;
					SU4->U4_OPERAD	==	(cAliasTrb)->U7_COD		.And. !Eof()
		
			If SU4->U4_STATUS == "1" .OR. SU4->U4_TIPO == "2" .OR. SU4->U4_FORMA == "5"
				
				DbSelectArea("SU6")
				DbSetOrder(1)
				DbSeek(xFilial("SU6") + SU4->U4_LISTA)
				
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1") + SU6->U6_CODENT)
				
				lCabOpe := .T.
				lTotOpe := .F.
				
				For nX := 1 to Len(aFilial)
					
					DbSelectArea("ACF")
					DbSetOrder(1)
					If lExtACF := (DbSeek(aFilial[nX][2] + SU6->U6_CODLIG))
						
						DbSelectArea("SU5")
						DbSetOrder(1)
						DbSeek(xFilial("SU5") + ACF->ACF_CODCAM)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Calcula o total da divida.         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						DbSelectArea("ACG")
						DbSetOrder(1)
						DbSeek(aFilial[nX][2] + ACF->ACF_CODIGO)
						
						nTotalDiv := 0
						
						While !EOF() .AND. ACG->ACG_FILIAL == ACF->ACF_FILIAL .AND. ACG->ACG_CODIGO == ACF->ACF_CODIGO
							nTotalDiv += ACG->ACG_VALOR
							DbSkip()
						End
						
						TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
						
						@ nLi,000 PSay SubStr(SU6->U6_CODENT,1,6)									// Cliente
						@ nLi,009 PSay SubStr(SU6->U6_CODENT,7,2) 									// Loja
						@ nLi,015 PSay Padr(SA1->A1_NOME, 40) 										// Razao Social
						@ nLi,057 PSay SA1->A1_CGC	Picture "@R 999.999.999-99"						// CPF/CNPJ
						@ nLi,077 PSay nTotalDiv	Picture "@E 999,999,999.99" 					// Total Divida
						@ nLi,093 PSay SU4->U4_DATA													// Enviado
						@ nLi,103 PSay ACF->ACF_PENDEN												// Retorno
						@ nLi,113 PSay ACF->ACF_HRPEND												// Hora
						@ nLi,119 PSay SU5->U5_CONTAT												// Nome Contato
						@ nLi,156 PSay SU6->U6_CODLIG												// Atendimento
						@ nLi,169 PSay ACF->ACF_DATA												// Data
						
						@ nLi,179 PSay If(ACF->ACF_OPERA == "1", "Ativo", "Receptivo")					// Ativ/Recp
						
						nTotOpe	+= nTotalDiv
						nContOpe++
						
//						TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
//						nTotFil += nTotalDiv
						
//						TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
//						@ nLi,000 PSay __PrtThinLine()
						
//						TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
						
//						@ nLi,000		PSay "Total da Filial: " + aFilial[nX][2] + "-" + aFilial[nX][3]// "Total da Filial: "
//						@ nLi,074		PSay cSimb1 // "R$: "
//						@ nLi,077		PSay nTotFil		Picture "@E 999,999,999.99" // Total da Filial
						
//						nTotOpe += nTotFil
						nTotFil := 0
						
//						TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
//						@ nLi,000 PSay __PrtThinLine()
						
					Endif
					
				Next
				
			Endif   
			
			DbSelectArea("SU4")
			DbSkip()			          
			
			If _cOpeAnt <> SU4->U4_OPERAD .Or. Eof()  
			
				If nTotOpe > 0
					
					TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
					@ nLi,000 		PSay __PrtThinLine()
			
					TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
						
					@ nLi,000		PSay "Total do Operador: " // "Total do Operador: "
					@ nLi,020      	PSay _cOpeAnt + "-" + Posicione("SU7",1,xFilial("SU7")+_cOpeAnt,"U7_NOME")
					@ nLi,074		PSay cSimb1 // "R$: "
					@ nLi,077		PSay nTotOpe		Picture "@E 999,999,999.99" // Total do Operador
					
					TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
					
				Endif	
						
//		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
//		@ nLi,000 		PSay __PrtFatLine()
				
				nTotGer += nTotOpe
				
			Endif	
							
		Enddo	
		
	Endif
	

			
	nTotOpe := 0
	lExtACF := .F.
	
	DbSelectArea(cAliasTrb)
	DbSkip()
	
End

If !lTotGer .AND. nContOpe > 0
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 		PSay __PrtFatLine()
	
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	
	@ nLi,000		PSay "Total Geral: " // "Total Geral: "
	@ nLi,074		PSay cSimb1 // "R$: "
	@ nLi,077		PSay nTotGer		Picture "@E 999,999,999.99" // Total do Operador
	
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 		PSay __PrtFatLine()
Else
	@Prow()+1,001 PSay "Não ha informações para imprimir este relatório" // "Não ha informações para imprimir este relatório"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o rodape do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Roda(cbCont,cbText,Tamanho)

Set Device To Screen
If ( aReturn[5] = 1 )
	Set Printer To
	DbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)
