#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELR005  �Autor  �Carlos R. Abreu     � Data �  15/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato �carlos.roberto@microsiga.com.br ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de SEPU                                          ���
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
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELR005()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1       := "Este relatorio imprime a rela��o de SEPUs de acordo"
Local cDesc2       := "com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Relarotio de SEPU"
Local nLin         := 80
Local Cabec1       := "SEPU     DT INC   COD CLI   NOME CLIENTE                    LJ NOME AVALIADOR                  NUM LOT DT BONIF   VL BONIF  %DESG AC"
Local Cabec2       := ""
Local imprime      := .T.

Local _aArea   		:= {}
Local _aAlias  		:= {}
Local aOrd         := {}
Local cPerg        := "DELAR0"

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "DELR005"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RSEPU" // Coloque aqui o nome do arquivo usado para impressao em disco

Private _aPergunt := {}

P_CtrlArea(1,@_aArea,@_aAlias,{"PA4"}) // GetArea

dbSelectArea("PA4")
dbSetOrder(1) //PA4_FILIAL+PA4_SEPU

#IFDEF TOP
#ELSE
	Aviso("Aten��o !","Relatorio s� pode ser executado na Matriz - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
	Return Nil
#ENDIF

//��������������������������������������������������������������Ŀ
//� Ajusta perguntas dos paramtros                               �
//����������������������������������������������������������������
Aadd(_aPergunt,{cPerg ,"01","Do lote         ?","","","mv_ch1","C",06,0,0,"G","","mv_par01"})
Aadd(_aPergunt,{cPerg ,"02","At� o lote      ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(_aPergunt,{cPerg ,"03","Da loja         ?","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","DLB",""})
Aadd(_aPergunt,{cPerg ,"04","At� a loja      ?","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","DLB",""})
AAdd(_aPergunt,{cPerg ,"05","Da Dt Inclus�o  ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aPergunt,{cPerg ,"06","At� Dt.Inclus�o ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aPergunt,{cPerg ,"07","Status do SEPU  ?","","","mv_ch7","C",01,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","P2",""})

ValidPerg(_aPergunt,cPerg)

Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint("PA4",wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"PA4")

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

P_CtrlArea(2,_aArea,_aAlias) // RestArea

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
Local nTotBonif := 0
Local _lValPA4 := .T.

DbSelectArea("PA4TMP")
dbGoTop()

SetRegua(RecCount())

DbSelectArea("PA4")
DbSetOrder(1) //PA4_FILIAL+PA4_SEPU

While !PA4TMP->(EOF())
	
	PA4->(DBSeek(PA4TMP->PA4_FILIAL+PA4TMP->PA4_SEPU))
	
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
	
	//����������������������������������������������������������Ŀ
	//� Tratamento se houve filtro escolhido pelo usuario        �
	//������������������������������������������������������������
	_lValPA4 := .T.
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		_lValPA4 := .F.
	EndIf
	
	if _lValPA4
		@ nLin,000 PSay PA4_SEPU      // NUM DO SEPU
		@ nLin,009 PSay PA4_DTINC     // DATA DA INCLUSAO
		@ nLin,018 PSay PA4_CODCLI    // CODIGO DO CLIENTE
		@ nLin,025 PSay PA4_LOJA      // FILIAL
		@ nLin,028 PSay PA4_NOMCLI    // NOME DO CLIENTE
		@ nLin,061 PSay PA4_MSFIL     // LOJA CLIENTE
		@ nLin,064 PSay PA4_NTECFA    // NOME DO AVALIADOR
		@ nLin,096 PSay PA4_NUMLOT    // NUM DO LOTE
		@ nLin,104 PSay PA4_DTDIGI    // DATA BONIFICACAO
		@ nLin,114 PSay Transform(PA4_VBONFA, "@E 999,999.99")   // VLR BONIFICACAO
		@ nLin,126 PSay PA4_DESGAS    // % DESGASTE
		@ nLin,131 PSay PA4_ACTFA     // ACEITO (S / N)
		
		nTotBonif += PA4_VBONFA
		
		nLin := nLin + 1 // Avanca a linha de impressao
	endif
	
	PA4TMP->(dbSkip()) // Avanca o ponteiro do registro na query
EndDo

nLin++
@ nLin,000 PSay "____________________________________________________________________________________________________________________________________"
nLin++
nLin++

@ nLin,000 PSay "TOTAL BONIFICA��O :"
@ nLin,109 PSay Transform(nTotBonif, "@E 999,999,999.99")  // Imprime total de bonificacao

// Fecha arquivo
DbSelectArea("PA4TMP")
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
Local cPA4 := RetSQLName("PA4")

//���������������������������������������������������������������������Ŀ
//� Monta QUERY de acordo com os parametros escolhidos pelo usuario     �
//�����������������������������������������������������������������������
cSQL := "SELECT PA4_FILIAL, PA4_SEPU                                                "
cSQL += "FROM " + cPA4 + "                                                          "
cSQL += "WHERE D_E_L_E_T_ <> '*' AND                                                "
cSQL += "PA4_NUMLOT  BETWEEN  '" + mv_par01 + "' AND '" + mv_par02 + "' AND         "
cSQL += "PA4_LOJA    BETWEEN  '" + mv_par03 + "' AND '" + mv_par04 + "' AND         "
cSQL += "PA4_DTINC   BETWEEN  '" + DtoS(mv_par05) + "' AND '" + DtoS(mv_par06) + "' "

//���������������������������������������������������������������������Ŀ
//� Tratamento do parametro Status do SEPU  						  	  �
//�����������������������������������������������������������������������
if mv_par07 <> '1' //'TODOS'
	
	if mv_par07 == '2' //'Aguardando avaliacao - nao antecipado'
		cSQL += " AND PA4_ACTFA = '' AND PA4_ACTDV = '' AND PA4_CPRODV = '' "
	else
		if mv_par07 == '3' //'Aguardando avaliacao - antecipado'
			cSQL += " AND PA4_ACTFA = '' AND PA4_ACTDV = '' AND PA4_CPRODV <> '' "
		else
			if mv_par07 == '4' //'Avaliado pela loja - nao antecipado'
				cSQL += " AND PA4_ACTFA = '' AND PA4_ACTDV <> '' AND PA4_CPRODV = '' "
			else
				if mv_par07 == '5' //'Avaliado pela loja - antecipado'
					cSQL += " AND PA4_ACTFA = '' AND PA4_ACTDV <> '' AND PA4_CPRODV <> '' "
				else
					if mv_par07 == '6' //'Recusado pela Pirelli'
						cSQL += " AND PA4_ACTFA = 'N' "
					else //'Aprovado pela Pirelli'
						cSQL += " AND PA4_ACTFA = 'S' "
					endif
				endif
			endif
		endif
	endif
endif

cSQL += "ORDER BY PA4_SEPU"

cSQL := ChangeQuery(cSQL)
msAguarde({|| dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "PA4TMP", .F., .T.)}, "Selecionando registros...")

Return