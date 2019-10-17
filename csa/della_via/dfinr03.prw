#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNFinr02   บ Autor ณ Fabio Henrique บ      Data ณ  04/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emissao de duplicata                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol Renovadora de Pneus                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Nfinr02


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Emissao de duplicatas Durapol"
Local cPict          := ""
Local titulo         := "Emissao de duplicatas"
Local nLin           := 2
Local cPerg          := "FINR01"
Local Cabec1         := "Este programa ira emitir duplicatas conforme"
Local Cabec2         := "os parametros selecionados"
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "NFinr02"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NFinr02"

Pergunte (cPerg,.F.)               // PERGUNTA NO SX1

Private cString := "SE1"

dbSelectArea("SE1")
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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  26/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)
dbSeek(xFilial()+mv_par03+mv_par01+mv_par04)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())


If Found()

	@ nLin,000 PSAY CHR(15)	
	While !Eof().and. E1_NUM >= mv_par01 .and. E1_NUM <= mv_par02 .And. E1_PREFIXO == mv_par03 .And. E1_PARCELA >= mv_par04 .And. E1_PARCELA <= mv_par05
	                                                           
	 	If lAbortPrint
     		 @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
     		 Exit
  		Endif

           	// IMPRESSAO DO CABEวALHO DA DUPLICATA
			@ nLin,007 PSAY REPL("-",130)
			nLin:= nLin + 1			             
			@ nLin,007 PSAY ("|")
			@ nLin,086 PSAY ("| ") + SUBS(SM0->M0_ENDENT,1,25) + (" ") + SUBS(SM0->M0_BAIRENT,1,17)+ ("     |")
			nLin:= nLin + 1		 
			@ nLin,007 PSAY ("|")	
			@ nLin,011 PSAY ("DURAPOL")
			@ nLin,086 PSAY ("| CEP: ") + SUBS(SM0->M0_CEPENT,1,5) + ("-") + SUBS(SM0->M0_CEPENT,5,3) + " " + SUBS(SM0->M0_CIDENT,1,19) + (" - SP         |")
			nLin:= nLin + 1			   
			@ nLin,007 PSAY ("|")                                                                                                             
			@ nLin,011 PSAY ("RENOVADORA DE PNEUS LTDA")
			@ nLin,086 PSAY ("| INSCRICAO NO CGC(MF):") + SUBS(SM0->M0_CGC,1,2) + (".") + SUBS(SM0->M0_CGC,3,3) + (".") + SUBS(SM0->M0_CGC,6,3) + ("/")+ SUBS(SM0->M0_CGC,9,3) + ("-")+ SUBS(SM0->M0_CGC,13,2)+ ("          |")
			nLin:= nLin + 1		 
			@ nLin,007 PSAY ("|")	
			@ nLin,086 PSAY ("| INSCRICAO ESTADUAL..:     ") + SUBS(SM0->M0_INSC,1,12) + ("          |")
			nLin:= nLin + 1		 
			@ nLin,007 PSAY ("|")	
			@ nLin,086 PSAY ("| INSCRICAO NO C.C.M. :      1.013.204-0          |")		
			nLin:= nLin + 1		 
				if xFilial() == '01'
					@ nLin,007 PSAY ("|")
					@ nLin,011 PSAY ("FONE: ")	+ SUBS(SM0->M0_TEL,3,2) + " " + SUBS(SM0->M0_TEL,5,3) + "-" + SUBS(SM0->M0_TEL,8,4)
					@ nLin,086 PSAY ("|") + REPL("-",49) + ("|") 
					nLin := nLin + 1                                                                                               
					@ nLin,007 PSAY ("|")
					@ nLin,011 PSAY ("FAX : ")	+ SUBS(SM0->M0_FAX,3,2) + " " + SUBS(SM0->M0_FAX,5,3) + "-" + SUBS(SM0->M0_FAX,8,4)
					@ nLin,086 PSAY ("| Data Emissao : ") + dtoc(dDATABASE) + ("                         |")	
				else
					@ nLin,007 PSAY ("|")
					@ nLin,011 PSAY ("FONE: ")	+ SUBS(SM0->M0_TEL,3,2) + " " + SUBS(SM0->M0_TEL,5,4) + "-" + SUBS(SM0->M0_TEL,9,4) 
					@ nLin,086 PSAY ("|") + REPL("-",49) + ("|") 
					nLin := nLin + 1     
					@ nLin,007 PSAY ("|")
					@ nLin,011 PSAY ("FAX : ")	+ SUBS(SM0->M0_FAX,3,2) + " " + SUBS(SM0->M0_FAX,5,4) + "-" + SUBS(SM0->M0_FAX,9,4)
					@ nLin,086 PSAY ("| Data Emissao : ") + dtoc(dDATABASE) + ("                         |")	
				endif
			nLin:= nLin + 1			                                               
			@ nLin,007 PSAY REPL("-",130)
			// FIM DA IMPRESSAO DO CABEวALHO
			
			nLin:= nLin + 1                     
			@ nLin,007 PSAY ("|") 	
			@ nLin,009 PSAY ("NOTA        EMISSAO        VALOR        |        FATURA        PARCELA        VALOR        VENCIMENTO ")   
			@ nLin,136 PSAY ("|")
			nLin:= nLin + 1
			@ nLin,007 PSAY REPL("-",130)
			nLin:= nLin + 1         
			@ nLin,007 PSAY ("|") 	     	
			@ nLin,009 PSAY SE1->E1_NUM
			@ nLin,020 PSAY SE1->E1_EMISSAO
			@ nLin,034 PSAY SE1->E1_VALOR Picture"@E@Z 999,999.99" + "     |"
					
		//	dbSetOrder(10)
		//	dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM)
			
			@ nLin,058 PSAY SE1->E1_NUM
			@ nLin,073 PSAY SE1->E1_PARCELA
			@ nLin,086 PSAY SE1->E1_VALOR Picture"@E@Z 999,999.99"
			@ nLin,100 PSAY SE1->E1_VENCTO
			@ nLin,136 PSAY ("|")
			nLin:= nLin + 1                      
			@ nLin,007 PSAY REPL("-",130)        
			nLin:= nLin + 1                      
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)                      
			
           		// IMPRESSAO DOS DADOS DO CLIENTE       
            	If found()    
					@ nLin,007 PSAY ("|") 	
					@ nLin,009 PSAY "Sacado ..: " + A1_NOME
					@ nLin,136 PSAY ("|")
					nLin:= nLin + 1	     
					@ nLin,007 PSAY ("|")
					@ nLin,009 PSAY "Endereco.: " + A1_END
					@ nLin,136 PSAY ("|")
					nLin:= nLin + 1      
					@ nLin,007 PSAY ("|")                  
					@ nLin,009 PSAY "Municipio: " + A1_MUN
					@ nLin,036 PSAY A1_EST
					@ nLin,041 PSAY "CEP: " + SUBS(A1_CEP,1,5) + "-" + SUBS(A1_CEP,5,3)
					@ nLin,136 PSAY ("|")
					nLin := nLin + 1      
					@ nLin,007 PSAY ("|")
					@ nLin,009 PSAY "End. Cobranca: " + A1_ENDCOB
					@ nLin,136 PSAY ("|")
					nLin := nLin + 1     
					@ nLin,007 PSAY ("|")
					@ nLin,009 PSAY "CNPJ/CPF: " + A1_CGC
					@ nLin,041 PSAY "Inscr.: " + A1_INSCR
					@ nLin,136 PSAY ("|")
					nLin := nLin + 1
					@ nLin,007 PSAY REPL("-",130)
					nLin := nLin + 1
				Endif	                             
				// FIM DA IMPRESSรO DOS DADOS DO CLIENTE
			
			 // IMPRESSรO DO VALOR POR EXTENSO
			DbSelectArea("SE1")
			dbSetOrder(1)
			@ nLin,007 PSAY ("|")
			@ nLin,033 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),1,69)) + REPLICATE("*",69),1,69)
			@ nLin,136 PSAY ("|")
			nLin:= nLin + 1
			@ nLin,007 PSAY ("|")
	      	@ nLin,033 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),70,69)) + REPLICATE("*",69),1,69) 
	      	@ nLin,136 PSAY ("|")
			nLin:= nLin + 1      
			@ nLin,007 PSAY ("|")
   	  		@ nLin,033 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),140,69)) + REPLICATE("*",69),1,69)
   	  		@ nLin,136 PSAY ("|")
   	  		nLin:= nLin + 1
			@ nLin,007 PSAY REPL("-",130)   	  		
			DbSkip()          

			nLin := nLin + 1 	 
			@ nLin,007 PSAY ("|")		
			@ nLin,065 PSAY "| PAGAVEL A DURAPOL RENOVADORA DE PNEUS LTDA"
			@ nLin,136 PSAY ("|")
			nLin := nLin + 1                                                 
			@ nLin,007 PSAY ("|")
			@ nLin,009 PSAY "CAIXA:__________________________ DATA PGTO __ / __ / __ "
			@ nLin,065 PSAY "| OU A SUA ORDEM NA PRACA E VENCIMENTO INDICADOS"			
			@ nLin,136 PSAY ("|")			            
			nLin := nLin + 1 
			@ nLin,007 PSAY REPL("-",130)   	  		
	
			nLin := nLin+41  	// PARA POSICIONAR A PROXIMA DUPLICATA NA PRำXIMA PAGINA
	
	EndDO
EndIf


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