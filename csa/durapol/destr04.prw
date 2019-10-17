#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESTR04   บ Autor ณ                    บ Data ณ  05/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emissao Laudo do CQ p/ Pneus Recusados - Processo Revisado บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Duparol                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DESTR04


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Emissao Laudo do CQ para Pneus Recusados "
Local cPict          := ""
Local titulo         := "Emissao Laudo do CQ para Pneus Recusados "
Local cPerg          := "ESTR01"
Local Cabec1         := "Este programa ira emitir Laudo do CQ para Pneus Recusados de acordo com
Local Cabec2         := "os parametros selecionados"
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "DESTR04"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DESTR04"
Private _Cabec1     := "                       LAUDO DE PNEUS RECUSADOS                                       "
Private _Cabec2     := "   MEDIDA                   MARCA              SERIE  FOGO                 LAUDO        COLETA NFE      ITEM             "

While .T.//come็o loop da tela de impressใo



Pergunte(cPerg,.F.)               // Pergunta no SX1

Private cString := "SC2"

dbSelectArea("SC2")
dbSetOrder(1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	EXIT
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
VerImp()

RptStatus({||RunReport()})
Enddo // fim loop para tela de impressใo

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  05/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport

Local nOrdem
Local nLin    := 4
Local _cOP    := ""
Local aItens  := {}
Local aCabec  := {}

IF Select("SC2TMP") > 0
	dbSelectArea("SC2TMP")
	dbCloseArea()
EndIF

// Alterado by Golo para suportar multifiliais
//_cQry:= "SELECT * "
//_cQry+= " FROM " + RetSqlName("SC2") + " SC2 "
//_cQry+= " WHERE C2_NUM||C2_ITEM||C2_SEQUEN >='" + " '" + mv_par01 +
//_cQry+= "' AND C2_NUM||C2_ITEM||C2_SEQUEN <= '"+mv_par02+"' AND C2_X_STATU = '9' AND "
//_cQry+= " D_E_L_E_T_ = '' "


_cQry:= "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_X_STATU, C2_FILIAL, C2_PRODUTO, C2_MARCAPN, C2_SERIEPN, C2_MOTREJE, C2_NUMFOGO, C2_ITEM "
_cQry+= " FROM " + RetSqlName("SC2") + " SC2 "
_cQry+= " WHERE C2_NUM||C2_ITEM||C2_SEQUEN >=" + " '" + mv_par01 + "' "
_cQry+= " AND C2_NUM||C2_ITEM||C2_SEQUEN   <=" + " '" + mv_par02 + "' "
_cQry+= " AND C2_X_STATU = '9'"
_cqry+= " AND C2_FILIAL = " + " '" + xFilial("SC2") + "' "
_cQry+= " AND D_E_L_E_T_ = '' "
	
_cQry := ChangeQuery(_cQry)
				
dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'SC2TMP', .F., .T.)
dbGoTop()

While !Eof()

	SetRegua(RecCount())
	
	SC5->(dbSeek(xFilial("SC5")+SC2TMP->C2_NUM))
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(xFilial("SD2")+SC5->C5_NOTA+SC5->C5_SERIE))
	
	aAdd(aCabec,{Alltrim(SA1->A1_NOME),SA1->A1_END,IIF(Empty(SA1->A1_ENDCOB),SA1->A1_END,SA1->A1_ENDCOB),SA1->A1_MUN,SA1->A1_CEP,SA1->A1_CGC,SA1->A1_INSCR,SC5->C5_VEND1})
	
	aAdd(aItens,{SC2TMP->C2_PRODUTO,SC2TMP->C2_MARCAPN,SC2TMP->C2_SERIEPN,SC2TMP->C2_MOTREJE,IIF(Empty(SD2->D2_DOC),"",SD2->D2_DOC),SC2TMP->C2_NUMFOGO,SC2TMP->C2_ITEM,SD2->D2_EMISSAO})
	
	dbSelectArea("SC2TMP")
	dbSkip()
EndDo
    
For _i := 1 To Len(aItens)

	IF lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIF
	
    @ nLin, 000 PSAY Chr(18)+Chr(15)
	@ nLin,055 PSAY Alltrim (SM0->M0_NOMECOM) //Razao Social 
	nLin := nLin + 1   
	@ nLin,055 PSAY "================================"
	nLin := nLin + 1 
	@ nLin,040 PSAY "CNPJ.....: "
	@ nLin,050 PSAY Alltrim(SM0->M0_CGC) Picture "@R 99.999.999/9999-99"  //Cod. Cliente
    @ nLin,080 PSAY "IE......: "
    @ nLin,090 PSAY Alltrim (SM0->M0_INSC)    // IE
	nLin := nLin + 4

	@ nLin,015 PSAY "Nota Fiscal..: "
	@ nLin,040 PSAY aItens[_i,5]    // Numero da NF
	nLin := nLin + 1
			
	@ nLin,015 PSAY "Data de Emissao ..: "
	@ nLin,040 PSAY aItens[_i,8]   // Data de Emissao da NF 
	
	nLin := nLin + 1              

	@ nLin,015 PSAY "Cliente...........: "
	@ nLin,040 PSAY Substr(Alltrim(aCabec[_i,1]),1,30)     // Nome do Cliente
	
	nLin := nLin + 1
		
	@ nLin,015 PSAY "Endereco .........: "
	@ nLin,040 PSAY Alltrim(aCabec[_i,2])     // Endereco do Cliente
		nLin := nLin + 1
		
	@ nLin,015 PSAY "Endereco Cobranca.: "
	@ nLin,040 PSAY aCabec[_i,3]  //Endereco de Cobranca
	
	nLin := nLin + 1
		
	@ nLin,015 PSAY "Municipio.........: "
	@ nLin,040 PSAY Alltrim(aCabec[_i,4])     //Municipio
	
	@ nLin,065 PSAY "CEP......: "
	@ nLin,085 PSAY aCabec[_i,5] Picture "@R 99999-999"    // CEP
	
	nLin := nLin + 1
		
	@ nLin,015 PSAY "CPF/CNPJ..:"
	@ nLin,040 PSAY aCabec[_i,6] Picture "@R 99.999.999/9999-99"   //CNPJ
	
	@ nLin,065 PSAY "I.E.........: "
	@ nLin,088 PSAY aCabec[_i,7]  // IE
	
	nLin := nLin + 1
	    
	@ nLin,015 PSAY "Vendedor.........: "
	@ nLin,040 PSAY aCabec[_i,8] 

	@ nLin,048 PSAY Alltrim(Posicione("SA3",1,xFilial("SA3")+aCabec[_i,8],"SA3->A3_NREDUZ"))
	
    nLin := nLin + 3
	    
	// 2บ PARTE DO RELATORIO
	@ nlin,010 PSAY "                                                 LAUDO DE PNEUS RECUSADOS "  
	nLin := nLin + 1
	@ nlin,010 PSAY "                                                 ======================== "
	nLin := nLin + 2
	//@ nlin,015 PSAY "MEDIDA                    MARCA        SERIE     FOGO             LAUDO                                   COLETA NFE       ITEM"
	nLin := nLin +1

	@ nlin,015 PSAY "PRODUTO:" + aItens[_i,1]
	nLin := nLin + 1
	@ nlin,015 PSAY "MARCA PNEU:" + aItens[_i,2]
	nLin := nLin + 1
	@ nlin,015 PSAY "SERIE PNEU:" + aItens[_i,3]
	nLin := nLin + 1
	@ nlin,015 PSAY "NUMERO FOGO:" + aItens[_i,6]
	nLin := nLin + 1
	IF !Empty(aItens[_i,4])
		@ nlin,015 PSAY "MOTIVO REJEICAO:" +Tabela("43",aItens[_i,4])
		nLin := nLin + 1
	EndIF	
    @ nlin,015 PSAY "NFE:" +aItens[_i,5]
    nLin := nLin + 1
	@ nlin,015 PSAY "ITEM:" +aItens[_i,7]
    
	
	nLin := 67
	
	IF nLin > 66
        @ nLin, 000 PSAY Chr(18)+Chr(15)
	    SetPrc(0,0) // (Zera o Formulario)
		nLin:=3
	EndIF
	
	
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPgEject(.F.)

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
_____________________________________________________________________________
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆFun็เo    ฆ VERIMP   ฆ Autor ฆ   Microsiga       ฆ Data ฆ 05/07/05     ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ Verifica posicionamento de papel na Impressora             ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ Durapol                                                    ฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
/*/

Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
IF aReturn[5]== 2

	nOpc       := 1
	While .T.

    	SetPrc(0,0)
    	dbCommitAll()

	    @ nLin ,000 PSAY " "
    	@ nLin ,004 PSAY "*"
	    @ nLin ,022 PSAY "."
		IF MsgYesNo("Fomulario esta posicionado ? ")
			nOpc := 1
		ElseIF MsgYesNo("Tenta Novamente ? ")
			nOpc := 2
		Else
			nOpc := 3
		Endif

    	Do Case
    		Case nOpc == 1
     			lContinua:=.T.
 	    		Exit
        	Case nOpc == 2
            	Loop
	        Case nOpc==3
    	        lContinua:=.F.
        		Return
		    EndCase
	EndDo
Endif

Return