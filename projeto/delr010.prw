/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELR010  �Autor  �Ricardo Mansano     � Data �  04/07/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Televendas X Loja                             ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamado via Menu.                                          ���
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
Project Function DELR010()
Local cQuery     	:= ""
Local aOrd       	:= {}
Local cDesc1     	:= "Este programa eh responsavel pela"
Local cDesc2     	:= "geracao do Relatorio de Televendas X Loja"
Local cDesc3     	:= ""
Private cbtxt    	:= Space(10)
Private cbcont   	:= 00
Private cTitulo  	:= "Televendas X Loja"
Private m_pag    	:= 01  // Pagina Inicial (deve constar em todos os relatorios)
Private cPerg    	:= "DEL010"
Private nNomeProg 	:= "DEL010"
Private cString  	:= "SE1"
Private aReturn  	:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private wnrel    	:= nNomeProg
Private cTamanho  	:= "P" // "P"equeno "M"edio "G"rande
Private nTipo    	:= 18  // 15=Comprimido 18=Normal


// Impede Execucao em Ambiente Codebase
#IFDEF TOP
#ELSE
	Aviso("Aten��o !","Relatorio s� pode ser executado na Matriz - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
	Return Nil
#ENDIF

// Ajusta Perguntas
PutSx1(cPerg,"01","Do Grupo de Atendimento   ?","","","mv_ch1" ,"C",02,0,0,"G","","SU0","","","MV_PAR01"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"02","Ate o Grupo de Atendimento?","","","mv_ch2" ,"C",02,0,0,"G","","SU0","","","MV_PAR02"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"03","Do Codigo de Operador     ?","","","mv_ch3" ,"C",06,0,0,"G","","SU7","","","MV_PAR03"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"04","Ate o Codigo de Operador  ?","","","mv_ch4" ,"C",06,0,0,"G","","SU7","","","MV_PAR04"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSX1(cPerg,"05","Da data                   ?","","","mv_ch5" ,"D",08,0,0,"G","",""   ,"","","MV_PAR05"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"06","Ate a data                ?","","","mv_ch6" ,"D",08,0,0,"G","",""   ,"","","MV_PAR06"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"07","Do Codigo da Loja Destino ?","","","mv_ch7" ,"C",06,0,0,"G","","SBM","","","MV_PAR07"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"08","Ate o Cod. da Loja Destino?","","","mv_ch8" ,"C",06,0,0,"G","","SBM","","","MV_PAR08"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
Pergunte(cPerg,.F.)

// Variaveis utilizadas para Impress�o do Cabe�alho e Rodap� (Obrigatorias)
cbtxt    := SPACE(10)
cbcont   := 0
Li       := 80
m_pag    := 1

//��������������������Ŀ
//� Executa Relatorio  �
//����������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �StaticRel �Autor  �Ricardo Mansano     � Data �  03/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao �Impressao dos dados do relatorio                            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Utilizada pela rotina principal deste programa             ���
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
Local dOldData		:= CtoD("  /  /  ")
Local cOldOperador 	:= ""

Local Cabec2		:= ""
Local Cabec1		:= "  Data Emissao   Vlr.Orc.(TLV)   Vlr.Fat(Loja)"
//
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17

//������������������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para par�metros                                               �
//� MV_PAR01   	Do codigo do Grupo de Atendimento                                      �
//� MV_PAR02	Ate o codigo do Grupo de Atendimento                                   �
//� MV_PAR03	Do codigo do operador                                                  �
//� MV_PAR04	Ate o codigo do operador                                               �
//� MV_PAR05	Da data                                                                �
//� MV_PAR06	Ate a data                                                             �
//� MV_PAR07	Do Codigo da Loja Destino                                              �
//� MV_PAR08	Ate o Codigo da Loja Destino                                           �
//��������������������������������������������������������������������������������������
cQuery := "select UA_OPERADO, U7_NOME, UA_EMISSAO, sum(UA_VLRLIQ) VALOR_ORC, sum(UA_VDALOJ) VALOR_FAT "
cQuery += "from " + RetSqlName("SUA") + " SUA "
cQuery += "inner join " + RetSqlName("SU7") + " SU7 "
cQuery += "on UA_OPERADO = U7_COD "
cQuery += "where "
cQuery += "SUA.D_E_L_E_T_ <> '*' and "
cQuery += "SU7.D_E_L_E_T_ <> '*' and "
cQuery += "UA_FILIAL = '" + xFilial("SUA") + "' and "
cQuery += "U7_FILIAL = '" + xFilial("SU7") + "' and "
cQuery += "UA_LOJASL1 <> '" + Space(TamSX3("UA_LOJASL1")[1]) + "' and "
cQuery += "U7_POSTO between '" + MV_PAR01 + "' and '" + MV_PAR02 + "' and "
cQuery += "UA_OPERADO between '" + MV_PAR03 + "' and '" + MV_PAR04 + "' and "
cQuery += "UA_EMISSAO between '" + DtoS(MV_PAR05) + "' and '" + DtoS(MV_PAR06) + "' and "
cQuery += "UA_LOJASL1 between '" + MV_PAR07 + "' and '" + MV_PAR08 + "' "
cQuery += "group by UA_OPERADO, UA_EMISSAO, U7_NOME "
cQuery += "order by UA_OPERADO, UA_EMISSAO, U7_NOME "
cQuery := ChangeQuery(cQuery)

// Cria tabela tempor�ria para o Relatorio
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)},"Aguarde...","Processando Dados...")

// Trata campos diferente de Caracter
For nX := 1 To Len(aStrucTRB)
	If aStrucTRB[nX][2] <> "C" .And. FieldPos(aStrucTRB[nX][1]) <> 0
		TcSetField(cAliasTRB,aStrucTRB[nX][1],aStrucTRB[nX][2],aStrucTRB[nX][3],aStrucTRB[nX][4])
	EndIf
Next nX

//MemoWrite("DELA010_AK.SQL", cQuery)

SetRegua(RecCount())
aDados := {}

While TRB->(!Eof())
	IncRegua()
	
	//�������������������������������������������Ŀ
	//� Imprime Cabecalho.                        �
	//���������������������������������������������
	If Li > 60
		Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)
	EndIf
	
	//�������������������������������������������Ŀ
	//� Verifica salto de Operador                �
	//���������������������������������������������
	If cOldOperador <> TRB->UA_OPERADO
		//�������������������������������������������Ŀ
		//� Imprime SubTotal por Operador             �
		//���������������������������������������������
		If (nTotOrcParc > 0).or.(nTotFatParc > 0)
			@ Li,002 PSay "Total Operador:"
			@ Li,020 PSay nTotOrcParc Picture "@E 999,999.99"
			@ Li,036 PSay nTotFatParc Picture "@E 999,999.99"
			Li+=2
			// Zera Subtotais
			nTotOrcParc := 0
			nTotFatParc := 0
		Endif
		
		@ Li,000 PSay "OPERADOR: "+TRB->UA_OPERADO +" - "+ TRB->U7_NOME //RetField("SU7",1,xFilial("SU7")+TRB->UA_OPERADO,"U7_NOME")
		Li += 2
		dOldData := CTOD(" /  /  ")
	Endif
	
	//�������������������������������������������Ŀ
	//� Verifica salto de Data                    �
	//���������������������������������������������
	If dOldData <> TRB->UA_EMISSAO
		
		//�������������������������������������������Ŀ
		//� Imprime Emissao dos Orcamentos/Vendas     �
		//���������������������������������������������
		@ Li,002 PSay TRB->UA_EMISSAO
	Endif
	
	//�����������������Ŀ
	//� Imprime valores �
	//�������������������
	@ Li,020 PSay TRB->VALOR_ORC Picture "@E 999,999.99"
	
	// Totalizadores
	nTotOrcParc	+= TRB->VALOR_ORC
	nTotOrcGer 	+= TRB->VALOR_ORC
	
	@ Li,036 PSay TRB->VALOR_FAT Picture "@E 999,999.99"
	
	// Totalizadores
	nTotFatParc	+= TRB->VALOR_FAT
	nTotFatGer 	+= TRB->VALOR_FAT
	
	//����������������������������������������������������������Ŀ
	//� Guarda informacoes para verificar o saltos do relatorio  �
	//������������������������������������������������������������
	dOldData     := TRB->UA_EMISSAO
	cOldOperador := TRB->UA_OPERADO
	
	TRB->(dbSkip())
	Li++
EndDo

//�������������������������������������������Ŀ
//� Imprime SubTotal Final e Total Geral      �
//���������������������������������������������
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
