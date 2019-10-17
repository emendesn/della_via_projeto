/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DCOMR01C   � Autor � AP6 IDE            � Data �  11/01/06  ���
�������������������������������������������������������������������������͹��
���Descricao � Resumo de Itens de Entrada - Coleta                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Durapol                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DCOMR01


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Resumo Itens de Entrada - Coleta"
Local cPict          := ""
Local titulo         := "Resumo Itens de Entrada - Coleta"
Local nLin           := 80                
Local Cabec1        := "Documento     Carcaca         Fogo       Marca        Desenho       Cliente/Fornecedor                          Qtd  Vlr.Unit�rio          Prc.Tab           Prc.Cliente        % Desconto "
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "G"
Private nomeprog         :=" DCOMR01C" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private _cPerg       := "COMR01"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DCOMR01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD1"

dbSelectArea("SD1")
dbSetOrder(1)

_aRegs := {}

AAdd(_aRegs,{_cPerg,"01","Da Emissao ?"   ,"Da Emissao"    ,"Da Emissao"    ,"mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Ate Emissao ?"  ,"Ate Emissaor"  ,"Ate Emissao"   ,"mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,_cPerg)


pergunte(_cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  24/11/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

IF Select("TRB") > 0
	TRB->(dbCloseArea())
EndIF

_cQry := "SELECT  D1_DOC, D1_COD, D1_NUMFOGO, D1_MARCAPN , D1_X_DESEN, D1_FORNECE, D1_LOJA, D1_QUANT, ACP_PRCVEN, ACP_PERDES, ACP_PERACR, ACP_CODPRO, D1_VUNIT  "
_cQry += "FROM "+RetSqlName("SD1")+ " SD1, "+RetSqlName("ACP")+ " ACP "
_cQry += "WHERE SD1.D1_FORNECE = ACP_CODREG AND D1_SERVICO = ACP_CODPRO AND "
_cQry += "SD1.D1_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' and "
_cQry += "SD1.D_E_L_E_T_ = '' AND "
_cQry +=" ACP.D_E_L_E_T_ = '' "
_cQry +=" ORDER BY D1_EMISSAO,D1_DOC, D1_ITEM "
_cQry := ChangeQuery(_cQry)

MEMOWRITE("ITEM.SQL",_CQRY)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

dbSelectArea("TRB")
dbGoTop()

SA1->(dbSetOrder(1))
DA1->(dbSetOrder(2))

While !EOF()

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

   If nLin > 58 // Salto de P�gina. Neste caso o formulario tem 51 linhas... 
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
      
   SA1->(dbSeek(xFilial("SA1")+TRB->D1_FORNECE+TRB->D1_LOJA))
   DA1->(dbSeek(xFilial("DA1")+TRB->ACP_CODPRO ) )                                                   

	@ nLin, 001 Psay TRB->D1_DOC
	@ nLin, 011 Psay TRB->D1_COD
	@ nLin, 030 Psay TRB->D1_NUMFOGO
	@ nLin, 043 Psay TRB->D1_MARCAPN
	@ nLin, 052	Psay TRB->D1_X_DESEN
	@ nLin, 069	Psay Alltrim(SA1->A1_NOME)
	@ nLin, 110 Psay TRB->D1_QUANT  Picture "@E 999"
	@ nLin, 118 Psay TRB->D1_VUNIT  Picture "@E 999.99"
	@ nLin, 132 Psay DA1->DA1_PRCVEN Picture "@E 999,999,999.99" //Tabela
	@ nLin, 149 Psay TRB->ACP_PRCVEN Picture "@E 999,999,999.99"
	@ nLin, 177 Psay IIF(TRB->ACP_PERDES == 0,TRB->ACP_PERACR,TRB->ACP_PERDES) Picture "@E 99.9999"
		
	nLin ++
   
   TRB->(dbSkip())  // Avanca o ponteiro do registro no arquivo
EndDo

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
