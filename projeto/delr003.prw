#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELR003  �Autor  �Carlos R. Abreu     � Data �  17/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato �carlos.roberto@microsiga.com.br ���                         	
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de lista de seguros                              ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                     ���
�������������������������������������������������������������������������͹��
���Aplicacao � Executado via menu.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���Marcelo A �09/01/07�      �Acrescentado tratamento para quebrar o rel  ���
���          �        �      �por categoria.                           	  ���
���          �        �      �Acrecentado totalizadores por valor do Segu.���
���          �        �      �                                            ���
���Marcelo A �10/01/07�      �Mudado o Lay-out do relatorio:              ���
���          �        �      �   -Retirado as colunas Serie, Cod Cliente, ���
���          �        �      �    Loja do Cliente.                     	  ���
���          �        �      �   -Acrescentado Coluna CPF/CNPJ.       	  ���
���          �        �      �   - Ajustado posicos das colunas.     	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Project Function DELR003()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1       := "Este relatorio imprime a rela��o de Seguros de acordo"
Local cDesc2       := "com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Relatorio de Lista de Seguros"
Local nLin         := 80
Local Cabec1       := "LOJA              NF     EMISSAO   CPF/CNPJ          NOME CLIENTE                    PRODUTO                                    PRC.UNIT     MATRICULA        CERTIFICADO  VLR.SEGURO"
Local Cabec2       := ""                                                                                                                                            
Local imprime      := .T.

Local _aArea   		:= {}
Local _aAlias  		:= {}
Local aOrd         := {}
Local cPerg        := "DELAR2"

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite           := 132
Private tamanho          := "G"
Private nomeprog         := "DELR003"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RSEGUROS" // Coloque aqui o nome do arquivo usado para impressao em disco

Private _aPergunt := {}

dbSelectArea("PA8")
dbSetOrder(1) //PA8_FILIAL+PA8_APOLIC

#IFDEF TOP
#ELSE
	Aviso("Aten��o !","Relatorio s� pode ser executado na Matriz - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
	Return Nil
#ENDIF

//��������������������������������������������������������������Ŀ
//� Ajusta perguntas dos paramtros                               �
//����������������������������������������������������������������
Aadd(_aPergunt,{cPerg ,"01","Da loja           ?","","","mv_ch1" ,"C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DLB",""})
Aadd(_aPergunt,{cPerg ,"02","At� a loja        ?","","","mv_ch2" ,"C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DLB",""})
AAdd(_aPergunt,{cPerg ,"03","Da Dt Emiss�o     ?","","","mv_ch3" ,"D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aPergunt,{cPerg ,"04","At� Dt.Emiss�o    ?","","","mv_ch4" ,"D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aPergunt,{cPerg ,"05","Do cod. cliente   ?","","","mv_ch5" ,"C",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
AAdd(_aPergunt,{cPerg ,"06","At� cod. cliente  ?","","","mv_ch6" ,"C",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
AAdd(_aPergunt,{cPerg ,"07","Do cod. produto   ?","","","mv_ch7" ,"C",15,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
AAdd(_aPergunt,{cPerg ,"08","At� cod. produto  ?","","","mv_ch8" ,"C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
AAdd(_aPergunt,{cPerg ,"09","Do grupo          ?","","","mv_ch9" ,"C",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SBM",""})
AAdd(_aPergunt,{cPerg ,"10","At� o grupo       ?","","","mv_ch10","C",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SBM",""})

ValidPerg(_aPergunt,cPerg)

Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint("PA8",wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"PA8")

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Monta a query baseado nos parametros preenchidos pelo ususario      �
//�����������������������������������������������������������������������
MontaSQL()

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunReport �Autor  �Carlos R. Abreu     � Data �  15/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato �carlos.roberto@microsiga.com.br ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Parametros� Cabec1 - Cabecalho principal                               ���
���          � Cabec2 - Cabecalho secundario                              ���
���          � Titulo - Titulo do relatorio                               ���
���          � nLin   - Linha atual onde esta o cursor                    ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                     ���
�������������������������������������������������������������������������͹��
���Aplicacao � Executado pela rotina principal                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nTotGeral	 := 0		//Totalizador geral de preco unitario.
Local nTotData	 := 0		//Totaliz por data de preco unito.
Local nTotCateg	 := 0		//Totaliz por categoria de preco unit.
Local nTotGerSeg := 0		//Totalizador geral de Valor do seguro.
Local nTotDatSeg := 0		//Totaliz por data de Valor do seguro.
Local nTotCatSeg := 0		//Totaliz por categoria de Valor de Seguro.
Local cPictCgc	 := ""		//Picture do Campo CPF/CNPJ
Local cData := 'DATA_INIC'


DbSelectArea("PA8TMP")
dbGoTop()

SetRegua(PA8->(RecCount()))

DbSelectArea("PA8")
DbSetOrder(3) //PA8_FILIAL+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM

While !PA8TMP->(EOF())
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	//Zera Totais categoria
	nTotCateg  := 0
	nTotCatSeg := 0
	
	
	//Imprime categoria
	cCateg := PA8TMP->CATEG
	@ nLin,000 PSay cCateg		
	nLin++
	nLin++

	While PA8TMP->CATEG = cCateg .And. !PA8TMP->(EOF())

		PA8->(DBSeek(PA8TMP->PA8_FILIAL+PA8TMP->PA8_CODCLI+PA8TMP->PA8_LOJCLI+PA8TMP->PA8_ITEM))
		
		//���������������������������������������������������������������������Ŀ
		//� Pesquisa o nome da loja                                             �
		//�����������������������������������������������������������������������
		SM0->(DBSeek('01'+PA8->PA8_LOJSG))
		
		//���������������������������������������������������������������������Ŀ
		//� Verifica o cancelamento pelo usuario...                             �
		//�����������������������������������������������������������������������
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//���������������������������������������������������������������������Ŀ
		//� Impressao do cabecalho do relatorio. . .                            �
		//�����������������������������������������������������������������������
		If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//���������������������������������������������������������������������Ŀ
		//� Tratamento de Pesquisa do nome da loja                              �
		//�����������������������������������������������������������������������
		if cData <> DTOC(PA8_DTSG)
			if cData <> 'DATA_INIC'
				@ nLin,000 PSay 'TOTAL DIA  ' + cData
				@ nLin,126 PSay Transform(nTotData, "@E 999,999,999.99")   		// TOTAL POR DATA
				@ nLin,167 PSay Transform(nTotDatSeg, "@E 999,999,999.99")   	// TOTAL DE SEGURO POR DATA				
				nLin++
				nLin++
			endif
			cData := DTOC(PA8_DTSG)
			nTotData 	:= 0
			nTotDatSeg	:= 0
			loop
		endif
		
		//Define Picture conforme tipo de Cliente (Fisica/Juridica)
		cPictCgc := IIf(Posicione("SA1",1,xFilial("SA1")+PA8_CODCLI+PA8_LOJCLI,"A1_PESSOA")=="F", "@R 999.999.999-99","@R 99.999.999/9999-99") 
		
		@ nLin,000 PSay Left(SM0->M0_NOME, 15)    // DESCR DA FILIAL
		@ nLin,018 PSay PA8_NFSG      // COD DA NOTA FISCAL
//      @ nLin,025 PSay PA8_SRSG      // SERIE DA NOTA
		@ nLin,025 PSay PA8_DTSG      // DATA EMISSAO DA NOTA
//		@ nLin,041 PSay PA8_CODCLI    // CODIGO DO CLIENTE
//		@ nLin,048 PSay PA8_LOJCLI    // LOJA CLIENTE
        @ nLin,035 PSay Posicione("SA1",1,xFilial("SA1")+PA8_CODCLI+PA8_LOJCLI,"A1_CGC") PICTURE cPictCgc	//CGC/CNPJ
		@ nLin,055 PSay Left(PA8_NOMCLI, 30)    // NOME DO CLIENTE
		@ nLin,087 PSay Left(PA8_CPROSG, 6)    // COD DO PRODUTO
		@ nLin,096 PSay PA8TMP->B1_DESC	    //	 DESCRICAO DO PRODUTO
		@ nLin,130 PSay Transform(PA8_VPROSG, "@E 999,999.99")  // VLR PRC UNITARIO
		@ nLin,143 PSay Left(PA8_MATRIC, 15)    // MATRICULA
		@ nLin,160 PSay PA8_APOLIC		//CERTIFICADO
		@ nLin,172 PSay Transform(PA8_VLRPRO, "@E 99,999.99")	//VALOR DO SEGURO
		
		//Adciona Totais de preco unitario
		nTotData  += PA8_VPROSG
		nTotGeral += PA8_VPROSG
		nTotCateg += PA8_VPROSG

		//Adciona Totais do Valor do Seguro
		nTotGerSeg += PA8_VLRPRO
		nTotDatSeg += PA8_VLRPRO
		nTotCatSeg += PA8_VLRPRO

		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		PA8TMP->(dbSkip()) // Avanca o ponteiro do registro na query
	EndDo

	@ nLin,000 PSay 'TOTAL DIA  ' + cData
	@ nLin,126 PSay Transform(nTotData, "@E 999,999,999.99")   		// TOTAL POR DATA
	@ nLin,167 PSay Transform(nTotDatSeg, "@E 999,999,999.99")   	// TOTAL DE SEGURO POR DATA				
	nLin+=2
	
	//Imprime total da Categoria
	@ nLin,000 PSay "TOTAL CATEGORIA " 
	@ nLin,126 PSay Transform(nTotCateg, "@E 999,999,999.99")   	// TOTAL CATEGORIA
	@ nLin,167 PSay Transform(nTotCatSeg, "@E 999,999,999.99")   	// TOTAL DE SEGURO POR DATA				
	nLin+=3

	cData := 'DATA_INIC'
	nTotData 	:= 0
	nTotDatSeg	:=0
Enddo

//Imprime total geral
@ nLin,000 PSay "TOTAL GERAL :"
@ nLin,126 PSay Transform(nTotGeral, "@E 999,999,999.99")  		// IMPRIME TOTAL GERAL
@ nLin,167 PSay Transform(nTotGerSeg, "@E 999,999,999.99")   	// TOTAL DE SEGURO POR DATA				

// Fecha arquivo
DbSelectArea("PA8TMP")
dbCloseArea()

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaSQL  �Autor  �Carlos R. Abreu     � Data �  15/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato �carlos.roberto@microsiga.com.br ���
�������������������������������������������������������������������������͹��
���Descri��o � Monta a query de acordo com os parametros                  ���
���          � escolhidos pelo usuario                                    ���
�������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                     ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                     ���
�������������������������������������������������������������������������͹��
���Aplicacao � Executado pelo programa RunReport                          ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaSQL()
Local cPA8 := RetSQLName("PA8")
Local cSB1 := RetSQLName("SB1")

//���������������������������������������������������������������������Ŀ
//� Monta QUERY de acordo com os parametros escolhidos pelo usuario     �
//�����������������������������������������������������������������������

cSQL := "SELECT PA8_CODCLI, PA8_ITEM, PA8_LOJCLI, PA8_ORCSG, PA8_ITORCS, PA8_FILIAL, PA8_APOLIC, B1_DESC, PA8_DTSG, "
cSQL += "(SELECT Z6_TIPO FROM SZ6010 WHERE Z6_COD = B1_CATEG AND D_E_L_E_T_ <> '*') AS CATEG "		//Marcelo
cSQL += "FROM " + cPA8 + " PA8                                                         		 "
cSQL += "INNER JOIN " + cSB1 + " SB1 ON PA8_CPROSG = B1_COD                            		 "
cSQL += "WHERE PA8.D_E_L_E_T_ <> '*' AND                                              		 "
cSQL += "SB1.D_E_L_E_T_ <> '*' AND                                                   		 "
cSQL += "PA8_LOJSG   BETWEEN  '" + mv_par01 + "' AND '" + mv_par02 + "' AND         		 "
cSQL += "PA8_DTSG    BETWEEN  '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' AND	 "
cSQL += "PA8_CODCLI  BETWEEN  '" + mv_par05 + "' AND '" + mv_par06 + "' AND         		 "
cSQL += "PA8_CPROSG  BETWEEN  '" + mv_par07 + "' AND '" + mv_par08 + "' AND         		 "
cSQL += "PA8_NFSG <> '      ' AND														     "
cSQL += "B1_GRUPO    BETWEEN  '" + mv_par09 + "' AND '" + mv_par10 + "'          		     "
cSQL += "ORDER BY CATEG, PA8_LOJSG, PA8_DTSG, PA8_SRSG, PA8_NFSG                             "

MemoWrite("DELR03.SQL", cSQL)

cSQL := ChangeQuery(cSQL)
msAguarde({|| dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "PA8TMP", .F., .T.)}, "Selecionando registros...")

Return
