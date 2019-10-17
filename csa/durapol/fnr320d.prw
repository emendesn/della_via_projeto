/*
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� DATA   � BOPS �Prograd.�ALTERACAO                                      ���
��������������������������������������������������������������������������Ĵ��
���28.08.00�oooooo�Rubens P�Implementacao multimoeda                       ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#INCLUDE "FINR320.CH"
#include "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR320  � Autor � Paulo Boschetti       � Data � 05.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posi��o Geral da Cobran�a.                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR320(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FNR320D()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL cString:="SE1"
LOCAL cDesc1 := STR0001 //"Este programa ir� emitir a posi��o geral da cobran�a no m�s"
LOCAL cDesc2 := STR0002 //"referente a data base do sistema."
LOCAL cDesc3 :=""
LOCAL Tamanho := "P"
Local aPergs	:= {}
Local dOldDtBase := dDataBase
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

PRIVATE titulo
PRIVATE cabec1
PRIVATE cabec2 
PRIVATE aReturn := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1} //{ OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FNR320D"
PRIVATE cPerg   :="FIN320"
PRIVATE nLastKey:= 0
PRIVATE nJuros  := 0

//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
titulo := OemToAnsi(STR0005)  //"Posicao Geral do Contas a Receber"
cabec1 := OemToAnsi(STR0006)+GetMv("MV_SIMB1")+OemToAnsi(STR0007)  //"                                             Valores ("###")            Quantidade"
cabec2 := ""

Aadd(aPergs,{"Considerar Pedidos Vendas","�Considerar Pedidos Ventas","Include Sales Orders","mv_chc","N",1,0,1,"C","","mv_par12","Sim","Si ","Yes","","","Nao","No ","No ","","","","","","","","","","","","","","","","","","","S",".FIN61009."})
Aadd( aHelpPor, 'Informe a data base do sistema a ser '  )
Aadd( aHelpPor, 'considerada para n�o ter que alter�-la '  )
Aadd( aHelpPor, 'antes de imprimir este relat�rio' )

Aadd( aHelpSpa, 'Digite la fecha base del sistema que se'	)
Aadd( aHelpSpa, 'debe considerar para no tener que ')
Aadd( aHelpSpa, 'modificarla antes de imprimir este informe')

Aadd( aHelpEng, 'Enter the system base date to be considered')
Aadd( aHelpEng, ' so it won�t be necessary to change it ' )
Aadd( aHelpEng, 'before printing this report')
Aadd(aPergs, {"Data Base","Fecha Base","Base Date","mv_chd","D",8,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, 'Selecione "Sim" para que sejam         '  )
Aadd( aHelpPor, 'considerados no relat�rio, t�tulos cuja'  )
Aadd( aHelpPor, 'emiss�o seja em data posterior a database' )
Aadd( aHelpPor, 'do relat�rio, ou "N�o" em caso contr�rio'  )

Aadd( aHelpSpa, 'Seleccione "S�" para que se consideren en'	)
Aadd( aHelpSpa, 'el informe los t�tulos cuya emisi�n sea en')
Aadd( aHelpSpa, 'fecha posterior a la fecha base de dicho '	)
Aadd( aHelpSpa, 'informe o "No" en caso contrario'	)

Aadd( aHelpEng, 'Choose "Yes" for bills which issue date '	)
Aadd( aHelpEng, 'is posterior to the report base date in ' 	)
Aadd( aHelpEng, 'the report, otherwise "No"' 			)

Aadd(aPergs, {"Tit. Emissao Futura?","Tit.Emision Futura  ","Future Issue Bill   ","mv_che","N",1,0,2,"C","","mv_par14","Sim","Si","Yes","","","N�o","No","No","","","","","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa})
AjustaSx1("FIN320",aPergs)

//Nao retire esta chamada. Verifique antes !!!
//Ela � necessaria para o correto funcionamento da pergunte 13 (Data Base)
PutDtBase()
//������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                         �
//��������������������������������������������������������������
pergunte("FIN320",.F.)

//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                        �
//� mv_par01            // Imprime Por Filial ou Empresa.       �
//� mv_par02            // Nas baixas, Dt Baixa, Digit ou Dispo �
//� mv_par03            // Seleciona tipos ( Sim / Nao ).       �
//� mv_par04            // Prefixo inicial                      �
//� mv_par05            // Prefixo final                        �
//� mv_par06            // Considera Juros                      �
//� mv_par07            // Considera TES para Pedido Venda      �
//� mv_par08            // Considera data base                  �
//� mv_par09            // Qual moeda                           �
//� mv_par10            // Outras moedas                        �
//� mv_par11            // Considerar Abatimentos(Sim/Nao)      �
//� mv_par12            // Considerar Pedidos Vendas(Sim/Nao)   �
//� mv_par13            // Data Base									 �
//� mv_par14            // Tit. Emissao Futura 						 �
//���������������������������������������������������������������
//�������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                       �
//���������������������������������������������������������������
wnrel:="FINR320"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
dDataBase := mv_par13 // Altera data base conforme parametro
RptStatus({|lEnd| Fa320Imp(@lEnd,wnRel,cString)},titulo)
dDataBase := dOldDtBase // Restaura Data base

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR320  � Autor � Paulo Boschetti       � Data � 05.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posi��o Geral da Cobran�a.                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA320Imp(lEnd,wnRelm,Cstring)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Parametro 1 - lEnd    - A��o do CodeBlock                  ���
���          � Parametro 2 - wnRel   - T�tulo do relat�rio                ���
���          � Parametro 3 - cString - Mensagem                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FA320Imp(lEnd,wnRel,cString)

LOCAL CbCont,CbTxt
LOCAL tamanho:="P"
LOCAL nSaldo :=0,nDias:=0,I:=0,J:=0,nSaldoAtu:=0
LOCAL nFirst :=1,nFirst1:=1
LOCAL aVal[39,2]
LOCAL nRecebido:=0
LOCAL nValJuros:=0
LOCAL nDesconto:=0
LOCAL nCorrecao:=0
LOCAL nMulta   :=0
LOCAL nOriginal:=0
LOCAL dDataBaixa
Local cCondSC6
#IFDEF TOP
	LOCAL nX,cCondFil,nIndex
	Local cQuery
#ELSE
	Local cArq	
#ENDIF	
Local cFilterUser := aReturn[7]
Local aSitua := ARRAY(8)
Local nI:=0
Local nMoedaBco := 1
Local nDecs := MsDecimais(mv_par09)
Local cFiltro, cIndTmp, cAliasTmp
Local nTipoData := 1
Local lAdto
Local nValAbat := 0
Local nAbt		:= 0

aSitua[1] := OemtoAnsi(STR0028)		//"Carteira"
aSitua[2] := OemtoAnsi(STR0029)		//"Cobranca Simples"
aSitua[3] := OemToAnsi(STR0030) 		//"Cobranca Descontada"
aSitua[4] := OemToAnsi(STR0031) 		//"Cobranca Caucionada"
aSitua[5] := OemToAnsi(STR0032)		//"Cobranca Vinculada"
aSitua[6] := OemToAnsi(STR0033)		//"Cobranca Extra-Judicial"
aSitua[7] := OemToAnsi(STR0034)	   //"Cobranca Cartorio"
aSitua[8] := OemToAnsi(STR0035) 	   //"Cobr Cauc Descont"

//Tipo da data para a composicao do saldo via SaldoTit()
If mv_par02 == 1			// Data da baixa (E5_BAIXA)
	nTipoData := 1
ElseIf mv_par02 == 2 	//Data de Digitacao (E5_DTDIGIT)
	nTipoData := 3
Else							//Data de Disponibilidade (E5_DTDISPO)
	nTipoData := 2
Endif

dbSelectArea("SX5")
dbSeek("  "+"07")

While !Eof() .and. X5_TABELA == "07"

	nI++
	If nI > Len(aSitua)
		Aadd(aSitua," ")		// garante um novo elemento
	Endif
	aSitua[nI] := TRIM(X5Descri())
	dbSkip()
Enddo

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
PRIVATE  cTipos := ""

//������������������������������������������������������������Ŀ
//� Verifica se seleciona tipos para total faturamento         �
//��������������������������������������������������������������
If mv_par03 == 1
	finaTipos()
Endif

dbSelectArea("SE1")
dbSetOrder(1)
If mv_par01 == 1
	dbSeek(xFilial("SE1"))
Else 
	dbGotop()
Endif

For i := 1 to 39
	For j := 1 to 2
		aVal[I,J] := 0
	Next j
Next i

//������������������������������������������������������������Ŀ
//� Filtra APENAS os emitidos antes da database, pois este rela�
//� torio pode ser retroativo.                                 �
//��������������������������������������������������������������
#IFDEF TOP
	IF TcSrvType() != "AS/400"
		aStru  := SE1->(dbStruct())
		cAliasTmp := "FINR320"
		cQuery := ""
		aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery +=         ",R_E_C_N_O_ RECNO "
		cQuery += "FROM "+RetSqlName("SE1")+ " SE1 "
		cQuery += "WHERE "
		If mv_par01 == 1
			cQuery += "SE1.E1_FILIAL ='"+xFilial("SE1")+"' AND "
		Endif	
		If MV_PAR14 == 2 //Nao considerar titulos com emissao futura
			cQuery += "SE1.E1_EMISSAO <= '"+Dtos(dDataBase)+"' AND "
		Endif	
		cQuery += "SE1.E1_PREFIXO >= '"+MV_PAR04+"' AND "	
		cQuery += "SE1.E1_PREFIXO <= '"+MV_PAR05+"' AND "
		If mv_par10 == 2 
			cQuery += "SE1.E1_MOEDA = "+Str(MV_PAR09,2)+" AND "
		Endif	
		cQuery += "SE1.D_E_L_E_T_=' ' "
   	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)	
		For nX :=  1 To Len(aStru)
			If aStru[nX][2] <> "C"
				TcSetField(cAliasTmp,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	Else
#ENDIF
		cFiltro := ""
		If Mv_par01 == 1
			cFiltro += "E1_FILIAL>='"+xFilial("SE1")+"'.And."
		Endif
		If MV_PAR14 == 2 //Nao considerar titulos com emissao futura
			cFiltro += "Dtos(E1_EMISSAO)<='"+Dtos(dDataBase)+"'.And."
		Endif	
		cFiltro += "E1_PREFIXO>='"+MV_PAR04+"'.And."	
		cFiltro += "E1_PREFIXO<='"+MV_PAR05+"'"
		If mv_par10 == 2 
			cFiltro += ".And.E1_MOEDA == "+Str(MV_PAR09,2)
		Endif	
		dbSelectArea("SE1")
		dbSetOrder(1)
		cIndTmp := CriaTrab(,.F.)
		IndRegua("SE1",cIndTmp,IndexKey(),,cFiltro)
		dbGotop()
		cAliasTmp := "SE1"
#IFDEF TOP
	Endif
#ENDIF

dbSelectArea(cAliasTmp)
SetRegua(RecCount()+SE5->(RecCount())+SC6->(RecCount()))

While !Eof()

	dbSelectArea(cAliasTmp)

	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
		Exit
	Endif
    
	IncRegua()
   
	If mv_par03 == 1
		If !Inside(E1_TIPO)
			dbSkip()
			Loop
		Endif
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Considera filtro do usuario                                  �
	//����������������������������������������������������������������
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif
		
	IF !Empty(E1_FATURA) .and. Substr(E1_FATURA,1,6) != "NOTFAT" .and. E1_DTFATUR <= dDataBase
		dbSkip()
		Loop
	Endif
		
	If mv_par01 == 1 .and. E1_FILIAL != xFilial("SE1")
		Exit
	EndIF
   
	//����������������������������������������Ŀ
   //� Verifica se � provis�rio ou abatimento �
   //������������������������������������������
	If E1_TIPO $ MVPROVIS+"/"+MVABATIM
      If E1_TIPO $ MVABATIM	//Somo o valor caso seja abatimento 
      	If mv_par11 == 1  
				nAbt := IIF(dDatabase < E1_BAIXA, xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0)), xMoeda(E1_SALDO,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0)))		// no resumo por tipo de titulos
	         aVal[35,1] += nAbt
   	      aVal[35,2] += IIF(nAbt > 0,1,0)
   	   Endif
      Else            
         aVal[16,1] += xMoeda(E1_SALDO,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
         aVal[16,2] += IIF(SE1->E1_SALDO > 0,1,0)
      Endif
		dbSkip()
		Loop
	Endif

	//��������������������������������������������������������������Ŀ
	//� Calcula o faturamento baseado na data base/item 1 analise    �
	//����������������������������������������������������������������
	If Month(E1_EMISSAO) == Month(dDatabase) .and. Year(E1_EMISSAO) == Year(dDataBase)
		If !(E1_TIPO $MV_CRNEG+"/"+MVRECANT)
			nDias := (E1_VENCREA - E1_EMISSAO)
			If nDias <= 1
				aVal[1,1] += xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
				aVal[1,2] += 1
			Else
				aVal[2,1] += xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
				aVal[2,2] += 1
			Endif
		Endif
	Endif
    
	nSaldoAtu := 0
	//��������������������������������������������������������������Ŀ
	//� Acumula titulos vencidos/vencer / Item 2 e 3 da analise      �
	//����������������������������������������������������������������
	If mv_par08 == 1
		#IFDEF TOP
			IF TcSrvType() != "AS/400"
				// Posiciona SE2 ou SE1 para pegar o saldo do titulo correto
				SE1->(DbGoto((cAliasTmp)->RECNO))
			Endif	
		#ENDIF
		IF !Empty(SE1->E1_BAIXA) .and. IIF(mv_par02 == 1,(SE1->E1_SALDO == 0 .and. SE1->E1_BAIXA <= dDataBase),.F.)
			nSaldoAtu := 0
		Else
			nSaldoAtu := SaldoTit( 	E1_PREFIXO,;
										E1_NUM,;
										E1_PARCELA,;
										E1_TIPO,;
										E1_NATUREZ,;
										"R",;
										E1_CLIENTE,;
										MV_PAR09,;
										dDataBase,;
										dDataBase,;
										E1_LOJA,;
										E1_FILIAL,;
										IIf(cPaisLoc=="BRA",E1_TXMOEDA,0),nTipoData )

				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldoAtu,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
					nSaldoAtu -= SE1->E1_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldoAtu,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					nSaldoAtu += SE1->E1_ACRESC
				Endif

		Endif
	Else
      If cPaisLoc == "BRA"
		  nSaldoAtu := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),E1_MOEDA,mv_par09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
	   Else
		  nSaldoAtu := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
	   EndIf
	Endif
	
	nValAbat := 0		
	If !(E1_TIPO $MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM)
		// Se considerar titulos com emissao futura, envia a data de ref. para Somaabat para que ela considere os
		// titulos de abatimento com emissao <= Database + 40 anos (30 * 480) - Emissao futura
		nValAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",1,,E1_CLIENTE,E1_LOJA,E1_FILIAL,If(mv_par14==1,dDataBase+(30*480),dDataBase))
	Endif
	
	If nSaldoAtu > 0 .and. (mv_par11 == 1 .or. STR(nSaldoAtu,17,2) == STR(nValAbat,17,2))
		nSaldoAtu-= nValAbat
   Endif  
  	nSaldoAtu:=Round(NoRound(nSaldoAtu,3),2)

	If nSaldoAtu > 0
		dBaixa := dDataBase
		nJuros := 0
		If mv_par06 == 1
			fa070juros(mv_par09)
		Endif

		lAdto := E1_TIPO $ MVRECANT+"/"+MV_CRNEG

		If E1_VENCREA < dDataBase
			nSaldoAtu+=nJuros
			nDias := (dDatabase - E1_VENCTO)
	
			aVal[34,1] += nSaldoAtu

			If !lAdto
				If nDias <= 15
					aVal[38,1] += nSaldoAtu
					aVal[38,2] += 1
				ElseIf nDias > 15 .And. nDias <= 30
					aVal[3,1] += nSaldoAtu
					aVal[3,2] += 1
				ElseIf nDias > 30 .And. nDias <= 60
					aVal[4,1] += nSaldoAtu
					aVal[4,2] += 1
				ElseIf nDias > 60 .And. nDias <= 90
					aVal[5,1] += nSaldoAtu
					aVal[5,2] += 1
				Else
					aVal[6,1] += nSaldoAtu
					aVal[6,2] += 1
				Endif
			Endif
		Else
			If !lAdto
				aVal[34,1] += nSaldoAtu
         	nDias      := (E1_VENCREA - dDatabase)
				If nDias <= 15
       	  		aVal[39,1] += nSaldoAtu
    	   		aVal[39,2] += 1
            ElseIf nDias > 15 .And. nDias <= 30
        	    	aVal[7,1] += nSaldoAtu
            	aVal[7,2] += 1
         	ElseIf nDias > 30 .And. nDias <= 60
           		aVal[8,1] += nSaldoAtu
            	aVal[8,2] += 1
         	ElseIf nDias > 60 .And. nDias <= 90
           		aVal[9,1] += nSaldoAtu
            	aVal[9,2] += 1
         	Else
           		aVal[10,1] += nSaldoAtu
            	aVal[10,2] += 1
         	EndIF
			Endif
		EndIF
	Endif

	//��������������������������������������������������������������Ŀ
	//� Calcula a distribuicao de cobranca / item 4  analise         �
	//����������������������������������������������������������������
	If nSaldoAtu > 0
		IF !(E1_TIPO $MV_CRNEG+"/"+MVRECANT)
			Do Case
				Case E1_SITUACA   $ " 0FG"
					aVal[25,1] += nSaldoAtu
					aVal[25,2] += 1
				Case E1_SITUACA   $ "1H"
					aVal[26,1] += nSaldoAtu
					aVal[26,2] += 1
				Case E1_SITUACA   = "2"
					aVal[27,1] += nSaldoAtu
					aVal[27,2] += 1
				Case E1_SITUACA   = "3"
					aVal[28,1] += nSaldoAtu
					aVal[28,2] += 1
				Case E1_SITUACA   = "4"
					aVal[29,1] += nSaldoAtu
					aVal[29,2] += 1
				Case E1_SITUACA   = "5"
					aVal[30,1] += nSaldoAtu
					aVal[30,2] += 1
				Case E1_SITUACA   = "6"
					aVal[31,1] += nSaldoAtu
					aVal[31,2] += 1
				Case E1_SITUACA   = "7"
					aVal[37,1] += nSaldoAtu
					aVal[37,2] += 1
			EndCase
		Endif
	Endif
    
	//���������������������Ŀ
	//� Valor Recebido.     �
	//�����������������������
	If nFirst1 == 1
		SA6->(dbSetorder(1)) // para pegar a moeda do banco.
		dbSelectArea("SE5") 
		If mv_par01 == 1
			dbSeek(xFilial("SE5"))
		Else
			dbGotop()
		Endif
		#IFDEF TOP
			IF TcSrvType() != "AS/400"
				aStru  := SE5->(dbStruct())
				cAliasSe5 := "NEWSE5"
				cCondFil := ""
				aEval(aStru,{|x| cCondFil += ","+AllTrim(x[1])})
				cCondFil := "SELECT "+SubStr(cCondFil,2)
				cCondFil +=         ",R_E_C_N_O_ RECNO "
				cCondFil += "FROM "+RetSqlName("SE5") + " SE5 "
				cCondFil += "WHERE " 
				If mv_par01 == 1
					cCondFil += "E5_FILIAL='" + xFilial("SE5") + "' AND "
				Endif
				cCondFil += "E5_TIPODOC IN ('VL','V2','JR','J2','CM','C2','MT','M2','DC','D2','TL','BA') AND E5_RECPAG = 'R' AND "
				cCondFil += "E5_PREFIXO >= '"+MV_PAR04+"' AND "	
				cCondFil += "E5_PREFIXO <= '"+MV_PAR05+"' AND "
            If mv_par02 == 1
					cCondFil += "E5_DATA >= '"
				ElseIf mv_par02 == 2
					cCondFil += "E5_DTDIGIT >= '"
				ElseIf mv_par02 == 3
					cCondFil += "E5_DTDISPO >= '"
				Endif				
				cCondFIl += Subs(dtos(dDataBase),1,6)+"01"+"' AND "
            If mv_par02 == 1
					cCondFil += "E5_DATA <= '"
				ElseIf mv_par02 == 2
					cCondFil += "E5_DTDIGIT <= '"
				ElseIf mv_par02 == 3
					cCondFil += "E5_DTDISPO <= '"
				Endif				
				cCondFIl += Dtos(LastDay(dDataBase))+"' AND "
				cCondFil += "D_E_L_E_T_=' ' "
		   	
				cCondFil := ChangeQuery(cCondFil)
		   	
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCondFil),cAliasSe5,.T.,.T.)
				For nX :=  1 To Len(aStru)
					If aStru[nX][2] <> "C"
						TcSetField(cAliasSe5,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
					EndIf
				Next nX
			Else
		#ENDIF
				cCondFil := ""
				If mv_par01 == 1
					cCondFil += "E5_FILIAL=='" + xFilial("SE5") + "' .And. "
				Endif
				cCondFil += "E5_TIPODOC$'VL/V2/JR/J2/CM/C2/MT/M2/DC/D2/TL/BA' .and. E5_RECPAG == 'R' .and. "
				cCondFil += "E5_PREFIXO>='"+MV_PAR04+"'.And."	
				ccondFil += "E5_PREFIXO<='"+MV_PAR05+"'.And."
            If mv_par02 == 1
					cCondFil += "DTOS(E5_DATA) >= '"
				ElseIf mv_par02 == 2
					cCondFil += "DTOS(E5_DTDIGIT) >= '"
				ElseIf mv_par02 == 3
					cCondFil += "DTOS(E5_DTDISPO) >= '"
				Endif				
				cCOndFIl += Subs(dtos(dDataBase),1,6)+"01"+"'.and."
            If mv_par02 == 1
					cCondFil += "DTOS(E5_DATA) <= '"
				ElseIf mv_par02 == 2
					cCondFil += "DTOS(E5_DTDIGIT) <= '"
				ElseIf mv_par02 == 3
					cCondFil += "DTOS(E5_DTDISPO) <= '"
				Endif				
				cCOndFIl += Dtos(LastDay(dDataBase))+"'"
				cArq :=CriaTrab(NIL,.F.)
				IndRegua("SE5",cArq,IndexKey(),,cCondFil,STR0009) //"Selecionando Registros.."
				nIndex:=RetIndex("SE5")
				#IFNDEF TOP
					dbSetIndex(cArq+OrdBagExt())
				#ENDIF					
				dbSetOrder(nIndex+1)
				cAliasSe5 := "SE5"
				DbGoTop()
		#IFDEF TOP
			Endif
		#ENDIF
		
		DbSelectArea(cAliasSe5)
		DbGoTop()
       
		While (mv_par01 != 1 .OR. xFilial("SE5") == (cAliasSe5)->E5_FILIAL) .AND. !Eof()
		
			IncRegua()            

        	// Ignora registros que nao sao da moeda quando escolhido nao imprimir
			SA6->(dbSeek(xFilial()+(cAliasSe5)->E5_BANCO+(cAliasSe5)->E5_AGENCIA+(cAliasSe5)->E5_CONTA))
            If mv_par10 == 2 .AND. Max(SA6->A6_MOEDA, 1) != mv_par09 
         	   dbSkip()
               Loop
            Endif
     
	     	nMoedaBco := If(SA6->(Found()), Max(SA6->A6_MOEDA, 1), 1)

			If mv_par02 == 1
		  		dDataBaixa := (cAliasSe5)->E5_DATA
			ElseIf mv_par02 == 2
		  		dDataBaixa := (cAliasSe5)->E5_DTDIGIT
			ElseIf mv_par02 == 3
		  		dDataBaixa := (cAliasSe5)->E5_DTDISPO
			Endif				
            
         //�������������������Ŀ
         //� Valor Recebido.   �
         //���������������������
			If Month(dDatabase)== Month(dDataBaixa) .and.;
				Year(dDataBase) ==Year(dDataBaixa)   .and.;
				(cAliasSe5)->E5_RECPAG=="R" .and. dDataBaixa <= dDatabase .AND.;
				(cAliasSe5)->E5_TIPODOC$"VL/V2/BA" ;
				.and.  (cAliasSe5)->E5_SITUACA <> "C" .and. ;
				(	MovBcoBx((cAliasSe5)->E5_MOTBX) .or. ;
				((cAliasSe5)->E5_MOTBX=="CMP" .and. (cAliasSe5)->E5_TIPO $ MVRECANT+"#"+MV_CRNEG ) )			

				//������������������������������������������������������������������Ŀ
				//� Verifica se existe estorno para esta baixa                       �
				//��������������������������������������������������������������������
				#IFDEF TOP
					IF TcSrvType() != "AS/400"
						SE5->(dbGoto((cAliasSe5)->RECNO))
					Endif
				#ENDIF	
				If !TemBxCanc((cAliasSe5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
					nRecebido += xMoeda((cAliasSe5)->E5_VALOR,nMoedaBco,mv_par09,(cAliasSe5)->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",(cAliasSe5)->E5_TXMOEDA,0))
				EndIf
			EndIf

	      If Month(dDatabase) = Month(dDataBaixa) .and. ;
	      	Year(dDataBase)  = Year(dDataBaixa)  .and. (cAliasSe5)->E5_RECPAG=="R" .and. ;
	         dDataBaixa <= dDatabase .and. (cAliasSe5)->E5_SITUACA <> "C" .and. ;
	         MovBcoBx((cAliasSe5)->E5_MOTBX) 
	         nValorE5 := xMoeda((cAliasSe5)->E5_VALOR,nMoedaBco,mv_par09,(cAliasSe5)->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",(cAliasSe5)->E5_TXMOEDA,0))
	         Do Case 
	         	Case (cAliasSe5)->E5_TIPODOC $ "JR/J2/TL"  //Valor juros
	            	nValJuros += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "CM/C2"     //Valor da correcao
	            	nCorrecao += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "MT/M2"     //Valor da Multa
	            	nMulta    += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "DC/D2"     //Valor do Desconto
	            	ndesconto += nValorE5
				EndCase
			EndIf
			dbSelectArea(cAliasSe5)
	      dbSkip()
		Enddo
		#IFDEF TOP
			IF TcSrvType() != "AS/400"
				dbSelectArea(cAliasSe5)
				dbCloseArea()
				dbSelectArea("SE5")
			Else
		#ENDIF
				dbSelectArea("SE5")
				DbClearFil()
				RetIndex("SE5")
				FErase(cArq+OrdBagExt())
		#IFDEF TOP
			Endif
		#ENDIF
		nFirst1++
		dbSelectArea(cAliasTmp)
	EndIf
    
	//��������������������������������������������������������������Ŀ
	//� Calcula a distribuicao por tipo de titulo / item 5 analise   �
	//����������������������������������������������������������������
	If nSaldoAtu > 0 .and. (mv_par14 == 1 .Or. E1_EMISSAO <= dDatabase)
		Do Case
			Case E1_TIPO  $ MVDUPLIC
				aVal[11,1] += nSaldoAtu
            aVal[11,2] += 1
			Case E1_TIPO  $ MVNOTAFIS
				aVal[12,1] += nSaldoAtu
				aVal[12,2] += 1
			Case E1_TIPO  $ MVCHEQUES
				aVal[13,1] += nSaldoAtu
				aVal[13,2] += 1
			Case E1_TIPO   = "CN"
				aVal[14,1] += nSaldoAtu
				aVal[14,2] += 1
			Case E1_TIPO  $ MVTAXA
				aVal[15,1] += nSaldoAtu
				aVal[15,2] += 1
			Case E1_TIPO  $ MVRECANT
				aVal[24,1] += nSaldoAtu
				aVal[24,2] += 1
			Case E1_TIPO $ MV_CRNEG				
				aVal[36,1] += nSaldoAtu
				aVal[36,2] += 1
			OtherWise
				aVal[16,1]  += nSaldoAtu
				aVal[16,2]  += 1	
		EndCase
	End
    
	//��������������������������������������������������������������Ŀ
	//� Calcula T.Carteira pedidos a entregar / item 6 da analise    �
	//����������������������������������������������������������������
	If nFirst == 1 .and. mv_par12 == 1	
		dbSelectArea("SC6")
		cCondSC6 := 'C6_QTDVEN > C6_QTDENT '
		cArq :=CriaTrab("",.F.)
		INDREGUA("SC6",cArq,IndexKey(),,cCondSC6,OemToAnsi(STR0009))  //"Selecionando Registros.."
		nIndex:=RetIndex("SC6")
		#IFNDEF TOP
			dbSetIndex(cArq+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		If mv_par01 == 1
			dbSeek(cFilial)
		Else
			dbGotop()
		Endif
        
		While !Eof()

         IF mv_par01 == 1 .and. cFilial != C6_FILIAL
				Exit
         Endif

         //��������������������������������������������������������������Ŀ
         //� Posicionar do SC5 para localiza moeda do pedido              �
         //����������������������������������������������������������������
         dbSelectArea( "SC5" )
         dbSeek( cFilial + SC6->C6_NUM )
         dbSelectArea( "SC6" )

		 	// Calcula se moeda for igual a escolhida ou for para converter
		 	If SC5->C5_MOEDA == mv_par09 .OR. mv_par10 == 1             
            nSaldo := xMoeda(fa320Saldo(),SC5->C5_MOEDA, mv_par09,SC5->C5_EMISSAO,nDecs+1)
            If nSaldo > 0
					If dDatabase < C6_ENTREG // itens a vencer					 
						nDias := (C6_ENTREG - dDatabase)
						If nDias <= 30
							aVal[17,2]++
							aVal[17,1]+= nSaldo
						ElseIf nDias > 30 .And. nDias <= 60
							aVal[18,2]++
							aVal[18,1]+= nSaldo
						ElseIf nDias > 60 .And. nDias <= 90
							aVal[19,2]++
							aVal[19,1]+= nSaldo
						Else
							aVal[20,2]++
							aVal[20,1]+= nSaldo
						Endif
					Else // itens vencidos
						nDias := (dDatabase - C6_ENTREG)
						aVal[21,2]++
						aVal[21,1]+= nSaldo
					EndIf
				Endif
			Endif
			dbSkip()
		EndDo
		RetIndex("SC6")
		Set Filter to
		Ferase(cArq+OrdBagExt())
		nFirst++
		dbSelectArea(cAliasTmp)
	Endif
    
	//��������������������������������������������������������������Ŀ
	//� Calcula o P.M.A e P.M.P - indices / item 7 da analise        �
	//����������������������������������������������������������������
	If nSaldoAtu != 0
		aVal[22,1] += (E1_VENCREA-E1_EMISSAO)
		aVal[22,2] += 1
		aVal[23,1] += (E1_VENCREA-E1_EMISSAO)*;
					   xMoeda(nSaldoAtu,E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
		aVal[23,2] +=  xMoeda(nSaldoAtu,E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
	EndIf
	dbSelectArea(cAliasTmp)
	nSaldoAtu:=0
	dbSkip()
Enddo
#IFDEF TOP
	IF TcSrvType() != "AS/400"
		dbSelectArea(cAliasTmp)
		dbCloseArea()
		dbSelectArea("SE1")
	Else
#ENDIF
		dbSelectArea("SE1")
		DbClearFil()
		RetIndex("SE1")
		FErase(cIndTmp+OrdBagExt())
#IFDEF TOP
	Endif
#ENDIF

IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
Endif

@Li ,  0 PSAY OemToAnsi(STR0010)  //"FATURAMENTO (no mes)"
//@Li , 40 PSAY aVal[1,1]+aVal[2,1]    PICTURE TM(aVal[1,1]+aVal[2,1],18, nDecs)
@Li , 40 PSAY FatMes()               PICTURE TM(aVal[1,1]+aVal[2,1],18, nDecs)
@Li , 72 PSAY aVal[1,2]+aVal[2,2]    PICTURE "999999"
Li++
/*
@Li ,  0 PSAY OemToAnsi(STR0011)  //"A Vista"
@Li , 40 PSAY aVal[1,1]	     	 PICTURE TM(aVal[1,1],18,nDecs)
@Li , 72 PSAY aVal[1,2]   	      PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0012)  //"A Prazo"
@Li , 40 PSAY aVal[2,1]	     	 PICTURE TM(aVal[2,1],18,nDecs)
@Li , 72 PSAY aVal[2,2]   	      PICTURE "999999"
Li++
*/
@Li ,  0 PSAY REPLICATE("-",80) 
li++
nOriginal := nRecebido-(nValJuros+nMulta+nCorrecao-nDesconto)
@li,   0 PSAY OemToAnsi(STR0051)  //"VALORES BAIXADOS"
li++
@li,   0 PSAY OemToAnsi(STR0013)  //"Recebido"
@li,  40 PSAY nRecebido			Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0014)  //"Taxa Permanencia"
@li,  40 PSAY nValJuros            Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0015)  //"Multa"
@li,  40 PSAY nMulta           Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0016)  //"Correcao"
@li,  40 PSAY nCorrecao        Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0017)  //"Descontos"
@li,  40 PSAY nDesconto			Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0018)  //"Original"
@li,  40 PSAY nOriginal        Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@Li ,  0 PSAY REPLICATE("-",80) 
li++
@Li ,  0 PSAY OemToAnsi(STR0019)  //"TITULOS A VENCER"
@Li , 40 PSAY (aVal[39,1]+aVal[7,1]+aVal[8,1]+aVal[9,1]+aVal[10,1])             PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[39,2]+aVal[7,2]+aVal[8,2]+aVal[9,2]+aVal[10,2]               PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0052)  //"Ate 15 Dias"
@Li , 40 PSAY aVal[39,1]   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[39,2]   PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0053)  //"De 16 a 30 Dias"
@Li , 40 PSAY aVal[7,1]    PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[7,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0023)  //"De 31 a 60 dias"
@Li , 40 PSAY aVal[8,1]    PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[8,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0024)  //"De 61 a 90 dias"
@Li , 40 PSAY aVal[9,1]    PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[9,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0025)  //"Acima de 90 Dias"
@Li , 40 PSAY aVal[10,1]   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[10,2]   PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
Li++
@Li ,  0 PSAY OemToAnsi(STR0026)  //"TITULOS VENCIDOS"
@Li , 40 PSAY (aVal[38,1]+aVal[3,1]+aVal[4,1]+aVal[5,1]+aVal[6,1])    PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[38,2]+aVal[3,2]+aVal[4,2]+aVal[5,2]+aVal[6,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0052)  //"Ate 15 Dias"
@Li , 40 PSAY aVal[38,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[38,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0053)  //"De 16 a 30 Dias"
@Li , 40 PSAY aVal[3,1]	   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[3,2]		PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0023)  //"De 31 a 60 dias"
@Li , 40 PSAY aVal[4,1]	   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[4,2]   	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0024)  //"De 61 a 90 dias"
@Li , 40 PSAY aVal[5,1]	   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[5,2]		PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0025)  //"Acima de 90 Dias"
@Li , 40 PSAY aVal[6,1]		PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[6,2]		PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
li++
@Li ,  0 PSAY OemToAnsi(STR0020)   //"Recebimento Antecipado"
@Li , 40 PSAY aVal[24,1]   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[24,2]   PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0021)  //"Notas de Credito"
@Li , 40 PSAY aVal[36,1]   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[36,2]   PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
li++
@Li ,  0 PSAY OemToAnsi(STR0027)  //"DISTRIBUICAO DA COBRANCA"
Li++

@Li ,  0 PSAY aSitua[1]
@Li , 40 PSAY aVal[25,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[25,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[2]
@Li , 40 PSAY aVal[26,1]  	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[26,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[3]
@Li , 40 PSAY aVal[27,1]  	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[27,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[4]
@Li , 40 PSAY aVal[28,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[28,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[5]
@Li , 40 PSAY aVal[29,1]  	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[29,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[6]
@Li , 40 PSAY aVal[30,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[30,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[7]
@Li , 40 PSAY aVal[31,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[31,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[8]
@Li , 40 PSAY aVal[37,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[37,2]	PICTURE "999999"
Li++

@Li ,  0 PSAY REPLICATE("-",80) 
Li++
@Li ,  0 PSAY OemToAnsi(STR0036)  //"POR TIPO DE TITULO"
Li++
@Li ,  0 PSAY OemToAnsi(STR0037)  //"Duplicatas"
@Li , 40 PSAY aVal[11,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[11,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0038)  //"Notas Fiscais"
@Li , 40 PSAY aVal[12,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[12,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0039)  //"Cheques Pre-Datados"
@Li , 40 PSAY aVal[13,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[13,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0040)  //"Carne De Pagamento"
@Li , 40 PSAY aVal[14,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[14,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0041)  //"Impostos"
@Li , 40 PSAY aVal[15,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[15,2]			      PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0042)  //"Abatimentos"
@Li , 40 PSAY aVal[35,1]        			PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[35,2]        			PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0043)  //"Outros"
@Li , 40 PSAY aVal[16,1]				  	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[16,2]					PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
Li++
@Li ,  0 PSAY OemToAnsi(STR0044)  //"CARTEIRA DE PEDIDOS A ENTREGAR"
@Li , 43 PSAY aVal[17,1]+aVal[18,1]+aVal[19,1]+aVal[20,1]+aVal[21,1]  Picture PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[17,2]+aVal[18,2]+aVal[19,2]+aVal[20,2]+aVal[21,2]  Picture "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0045)  //"Itens de Pedidos Vencidos"
@Li , 43 PSAY aVal[21,1]             PICTURE  PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[21,2]             PICTURE  "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0022)  //"Ate 30 Dias"
@Li , 43 PSAY aVal[17,1]             PICTURE PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[17,2]             PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0023)  //"De 31 a 60 Dias"
@Li , 43 PSAY aVal[18,1]             PICTURE PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[18,2]             PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0024)  //"De 61 a 90 Dias"
@Li , 43 PSAY aVal[19,1]             PICTURE PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[19,2]             PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0025)  //"Acima De 90 Dias"
@Li , 43 PSAY aVal[20,1]             PICTURE PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[20,2]             PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
Li++
@Li ,  0 PSAY OemToAnsi(STR0047)  //"Prazo Medio Absoluto"
@Li , 72 PSAY (aVal[22,1]/aVal[22,2])   	      PICTURE "999.99"
Li++
@Li ,  0 PSAY OemToAnsi(STR0048)  //"Prazo Medio Ponderado"
@Li , 72 PSAY (aVal[23,1]/aVal[23,2])   	      PICTURE "999.99"
Li++
@Li ,  0 PSAY OemToAnsi(STR0049)  //"Quociente De Atraso"
@Li , 72 PSAY  (((aVal[38,1]+aVal[3,1]+aVal[4,1]+aVal[5,1]+aVal[6,1])/aVal[34,1]))*100 PICTURE "999.99"
Li++

Set Device To Screen
dbSelectArea("SE1")
dbSetOrder(1)
Set Filter to
dbSelectArea("SE5")
dbSetOrder(1)
Set Filter to

If aReturn[5] = 1
    Set Printer TO
    dbCommitAll()
    Ourspool(wnrel)
Endif
MS_FLUSH()


Static Function InSide(cTp)
Return (cTp$cTipos)


/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSx1    � Autor � Wagner Mobile Costa	� Data � 25/10/01 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica/cria SX1 a partir de matriz para verificacao          ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Siga                                                           ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ := 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PutDtBase� Autor � Mauricio Pequim Jr    � Data � 18/07/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Acerta parametro database do relatorio                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Finr320.prx                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("FIN32013")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return

Static function FatMes()
	Local aArea    := GetArea()
	Local nValFat  := 0
	Local cSql     := ""
	Local cDataIni := Substr(dtos(dDataBase),1,6)+"01"
	Local cDataFim := dtos(dDataBase)

	cSql := "SELECT SUM(D2_TOTAL) AS FATMES"
	cSql += " FROM "+RetSqlName("SF2")+" SF2"

	cSql += " JOIN "+RetSqlName("SD2")+" SD2"
	cSql += " ON  SD2.D_E_L_E_T_ = ''"
	cSql += " AND D2_FILIAL = F2_FILIAL"
	cSql += " AND D2_DOC = F2_DOC"

	cSql += " JOIN "+RetSqlName("SF4")+" SF4"
	cSql += " ON  SF4.D_E_L_E_T_ = ''"
	cSql += " AND F4_CODIGO = D2_TES"
	cSql += " AND F4_DUPLIC = 'S'"

	cSql += " WHERE SF2.D_E_L_E_T_ = ''"
	cSql += " AND   F2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"

	cSql := ChangeQuery(cSql)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"FAT_MES",.T.,.T.)	
	dbSelectArea("FAT_MES")
	nValFat := FATMES
	dbCloseArea()

	RestArea(aArea)
Return nValFat