#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESTR02   บ Autor ณ Reinaldo Caldas    บ Data ณ  05/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emissao Laudo do CQ para Pneus Recusados                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Duparol                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DESTR02


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
Private nomeprog   := "DESTR02"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DESTR02"
Private _Cabec1     := "                       LAUDO DOS PNEUS RECUSADOS                                       "
Private _Cabec2     := "   MEDIDA                   MARCA              SERIE                 LAUDO             "

Pergunte(cPerg,.F.)               // Pergunta no SX1

Private cString := "SD4"

dbSelectArea("SD4")
dbSetOrder(1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
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
Return

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
Local nLin    := 2
Local _cOP    := ""
Local aItens  := {}

IF Select("SD7TMP") > 0
	dbSelectArea("SD7TMP")
	dbCloseArea()
EndIF

_cQry:= "SELECT * "
_cQry+= " FROM " + RetSqlName("SD7") + " SD7 "
_cQry+= " WHERE D7_X_OP >= '"+mv_par01+"' AND D7_X_OP <= '"+mv_par02+"' AND D1_TIPO = 2 AND "
_cQry+= " D_E_L_E_T_ = '' "
	
_cQry := ChangeQuery(_cQry)
				
dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'SD7TMP', .F., .T.)
dbGoTop()
_cOP :=  SD7TMP->D7_X_OP
While !Eof()
	SC2->(dbSetOrder(1))
	SC2->(dbSeek(xFilial("SC2")+SD7TMP->D7_X_OP))
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	
	aAdd(aItens,{SC2->C2_PRODUTO,SC2->C2_X_MARCA,SC2->C2_SERIEPN,SD7TMP->D7_MOTREJ})	
	dbSelectArea("SD7TMP")
	dbSkip()
EndDo

	IF _cOP !=  SD7TMP->D7_X_OP
		_cOP :=  SD7TMP->D7_X_OP
		SD7->(dbSetOrder(1))
		SD7->(dbSeek(xFilial("SD7")+SD7TMP->D7_NUMERO))
		While!Eof() .and. _cOP == SD7TMP->D7_X_OP
			
		EndDo		

dbSelectArea(SD7)
dbSetOrder(3)
dbSeek(xFilial()+mv_par01)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !Eof() .and. 
SetRegua(RecCount())

If Found()
   	@ nLin,000 PSAY chr(255)+Chr(15)                // Compressao de Impressao
	
	While !Eof().and. Alltrim(SD4->D4_OP) >= Alltrim(mv_par01) .and. ;
		Alltrim(SD4->D4_OP) <= Alltrim(mv_par02)
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
	
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSeek(xFilial("SC2")+SD4->D4_OP)
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC2")+SC2->C2_PEDIDO) 
			
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SC2")+SC5->SC5_CLIENTE+SC5_LOJA)
		
		
		@ nLin,015 PSAY Alltrim (SM0->M0_NOMECOM) //Razao Social 
		@ nLin,025 PSAY Alltrim (SM0->M0_CGC)     //Cod. Cliente
		nLin := nLin + 1
		
		@ nLin,015 PSAY Alltrim (SN0->M0_NOMECOM) //Razao Social
		@ nLin,025 PSAY Alltrim (SN0->M0_INSC)    // IE
		nLin := nLin + 4
		
		@ nLin,015 PSAY (SD2->D2_DOC)     // Numero da NF
		nLin := nLin + 1
		
		@ nLin,015 PSAY (SD2->D2_EMISSAO)   // Data de Emissao da NF     
		nLin := nLin + 1              
		
		@ nLin,015 PSAY (SA1->A1_NOME)     // Nome do Cliente
		nLin := nLin + 1
		
		@ nLin,015 PSAY (SA1->A1_END)     // Endereco do Cliente
		nLin := nLin + 1
		
		@ nLin,015 PSAY (SA1->A1_ENDCOB)  //Endereco de Cobranca
		nLin := nLin + 1
		
		@ nLin,015 PSAY (SA1->A1_MUN)     //Municipio
	    @ nLin,045 PSAY (SA1->A1_CEP)     // CEP
		nLin := nLin + 1
		
	    @ nLin,015 PSAY (SA1->A1_CGC)    //CNPJ
	    @ nLin,045 PSAY (SA1->A1_INSCR)  // IE
	    nLin := nLin + 1
	    
	    @ nLin,015 PSAY (SC5->C5_VEND1)  //Vendedor DV   
	    nLin := nLin + 3
	    
	    // 2บ PARTE DO RELATORIO
	    @ Nlin,001 PSAY (_cabec1)
	    nLin :=NLin +1
	    
	    @ Nlin,001 PSAY (_cabec2) 
	    nLin :=NLin+1
	    
	    @ NLin,015 PSAY (SC2->C2_PRODUTO)  // Medida
	    @ NLin,019 PSAY (SC2->C2_MARCAPN)  //Marca
	    @ NLin,022 PSAY (SC2->C2_SERIEPN)  //Serie
        @ NLin,027 PSAY (SD7->D7_MOTREJE)  //Motivo da Rejeicao
		  			
		M_pag ()
		
		//EndIF
		dbSelectArea(cString)
		dbSkip()
	EndDO
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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