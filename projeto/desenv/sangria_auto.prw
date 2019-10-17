/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³sangriaA  ºAutor  ³Marcelo Alcantara   º Data ³  06/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a Sangria Altomaticamente de para banco especificado º±±
±±º          ³na tabela SZ8.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaLoja                                                   º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
//#INCLUDE "TBICONN.CH"

User Function SangriaA()
local nVal			:= 0.00
Local cSE5 			:= RetSQLName("SE5")
Local _cOperador	:=SLF->LF_COD
Local _aRecebTot	:= {}
Local lCont:= .T.
Local aNumLiq       := {}
Local i
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "03" MODULO "loja" // Prepara Ambiente para teste

//Verifica se Transferencia ja foi feita na data base
dbSelectArea("SLJ")
dbSetOrder(1) //LJ_FILIAL+LJ_CODIGO
dbGoTop()
if dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0"))
	if SLJ->LJ_DTSANGR >= dDataBase
		Aviso("Aviso","Transferencia automatica ja efetuada nesta data!! ",{"Ok"})
		Return
	Endif
else
	Aviso("Aviso","Nao foi possivel encontrar a loja no cadastro de Ident. de Loja, Transferencia nao efetuada",{"Ok"})
	Return
Endif

// Declara Variaveis
dbSelectArea("SE5")
Private oBrowse
Private oDlg
Private cBanco		:= "   " 					//Banco de Deposito
Private cAgencia	:= CriaVar("E5_AGENCIA")	//Agencia
Private cConta		:= CriaVar("E5_CONTA")		//Conta
Private cHistorico	:= CriaVar("E5_HISTOR")		//Historico da Transferencia
Private cTipo		:=""						//Tipo de Deposito
Private cNumDoc		:= CriaVar("E5_NUMCHEQ")	//Numero do Documento
Private nValor		:= 0.00						//Valor da Transferencia

Private _cOperador	:=SLF->LF_COD
Private _dEmissao	:= dDataBase
Private _cSerie		:= SLG->LG_SERIE
Private _aTitulo	:= {}

//Verifica se o banco é TOP
dbSelectArea("SX5")
if RDDName() <> "TOPCONN"
	MsgStop("Este Rotina so pode ser executada com a versao do sistema para TopConnect")
	Return nil
endif

// gera uma consulta para filtrar formas de pagtos
@ 0,0 TO 400,640 DIALOG oDlg TITLE "Transferencia do Caixa Automatica"

cQuery := "select * from " + RetSqlName("SL1")
cQuery += " where D_E_L_E_T_ <> '*' "
cQuery += "and L1_FILIAL = '" + xFilial("SL1") + "' "
cQuery += "and L1_OPERADO = '" +_cOperador+"'" //MV_PAR01 + "' "
cQuery += "and L1_EMISNF = '" + DtoS(_dEmissao) + "' "
cQuery += "order by L1_EMISNF"

tcQuery cQuery New Alias "QRY"
tcSetField("QRY", "L1_EMISSAO", "D")
tcSetField("QRY", "L1_EMISNF" , "D")

// Abre arquivo SZ8 e seleciona todos os registros
cQry1:= "SELECT Z8_FILIAL, Z8_CODADM, Z8_BANCO, Z8_AGENCIA, Z8_CONTA, 0 AS VALOR, qSAE.AE_DESC, AE_TIPO FROM "+RetSqlName("SZ8")+" qSZ8"
cQry1+= " LEFT JOIN "+RetSqlName("SAE")+" qSAE ON qSZ8.Z8_CODADM=qSAE.AE_COD AND qSAE.D_E_L_E_T_ <> '*'"
CqRY1+= " WHERE Z8_FILIAL = '"+SM0->M0_CODFIL+"' AND qSZ8.D_E_L_E_T_ <> '*'"
CqRY1+= " ORDER BY Z8_CODADM"

TCQUERY CqRY1 NEW ALIAS "QRY_SZ8"

//cria arquivo temporario e abre workarea
DbSelectArea("QRY_SZ8")
cArq:= Criatrab(Nil,.F.)
Copy To &cArq
dbUseArea(.T.,, cArq, "TRB_TMP", .f.,.f.)
dbselectArea("TRB_TMP")
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Altera forma de pagamento para Corretora e Seguradora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !EOF()
	If TRB_TMP->AE_TIPO == "CT" .Or. TRB_TMP->AE_TIPO == "SG"
		RecLock("TRB_TMP", .F.)
		TRB_TMP->AE_TIPO := "FI"
		msUnlock()
	EndIf
	
	dbSkip()
End

//Indexa Arquivo Temporario
cIndex	:= CriaTrab(nil,.f.)
cChave	:= "Z8_FILIAL+Z8_CODADM+AE_TIPO"
IndRegua("TRB_TMP",cIndex,cChave,,,"Selecionando Registros...")  //"Selecionando Registros..."

//Seleciona Registro a Sangrar
dbSelectArea("QRY")
DbGoTop()
_cL1Doc		:= ""
_cL1Serie	:= ""
Do While .Not. Eof()
	//Verifica se houve Credito na venda
	IF L1_CREDITO > 0
		nVal:= L1_CREDITO
		dbSelectArea("TRB_TMP")
		if dbSeek(xFilial("SZ8")+"CR")
			RecLock("TRB_TMP",.F.)
			TRB_TMP->Valor:= TRB_TMP->Valor+nVal
			msUnlock()
		else		// Se Nao exisir Credito na Tabela SZ8.
			RecLock("TRB_TMP",.T.)
			TRB_TMP->Z8_FILIAL	:= SM0->M0_CodFil
			TRB_TMP->Z8_CODADM	:= "CR"
			TRB_TMP->Z8_BANCO	:= "CX1"
			TRB_TMP->Z8_AGENCIA	:= "00001"
			TRB_TMP->Z8_CONTA	:= "0000000001"
			TRB_TMP->VALOR		:= nVal
			msUnlock()
		endif
		dbSelectArea("QRY")
	ENDIF
	
	// Se Tiver Devolucao para venda nao soma nas parcelas
	SD2->(dbSetOrder(3))	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	if SD2->(dbSeek(xFilial("SD2")+QRY->L1_DOC+QRY->L1_SERIE))
		lTemDev:= .F.
		WHILE !SD2->(EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .AND. SD2->D2_DOC == QRY->L1_DOC .AND. SD2->D2_SERIE == QRY->L1_SERIE
	    	if SD2->D2_VALDEV > 0
				lTemDev:= .T.
			endif
			SD2->(dbSkip())
		EndDo	
	   	if lTemDev 
			// Posiciona SF2 para pegar serie do financeiro
			SF2->(dbSetOrder(1))  //Filial+doc+serie
			SF2->(dbSeek(xFilial("SF2") + QRY->L1_DOC + QRY->L1_SERIE))
			
			_cSerieSE1	:= &(GETMV("MV_LJPREF"))
	   		
            // Se Tiver Devolucao e tambem tiver titulo soma nas parcela
            SE1->(dbSetOrder(1))  // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	   		if !SE1->(dbSeek(xFilial("SE1")+ _cSerieSE1 + QRY->L1_DOC))
		   		dbSkip()
	   			Loop
	   		endif
   		endif
  	Endif
	
	// Verifica Formas de Pagto
	SL4->(dbSetOrder(1))	// L4_FILIAL+L4_NUM+L4_ORIGEM
	SL4->(dbSeek(xFilial("SL4")+QRY->L1_NUM))
	WHILE !SL4->(EOF()) .AND. SL4->L4_FILIAL == xFilial("SL4") .AND. SL4->L4_NUM == QRY->L1_NUM
		//Cheque Pre Datado
		IF ALLTRIM(SL4->L4_FORMA)=="CH" .AND. SL4->L4_DATA<>L1_EMISNF .AND. ALLTRIM(SL4->L4_ORIGEM) <> "SIGATMK"
			nVal:= SL4->L4_VALOR
			dbSelectArea("TRB_TMP")
			if dbSeek(xFilial("SZ8")+SL4->L4_FORMA)
				RecLock("TRB_TMP",.F.)
				TRB_TMP->Valor:= TRB_TMP->Valor+nVal
				msUnlock()
			else		// Se Nao exisir Credito na Tabela SZ8.
				RecLock("TRB_TMP",.T.)
				TRB_TMP->Z8_FILIAL	:= SM0->M0_CODFIL
				TRB_TMP->Z8_CODADM	:= "CH"
				TRB_TMP->Z8_BANCO	:= "CX1"
				TRB_TMP->Z8_AGENCIA	:= "00001"
				TRB_TMP->Z8_CONTA	:= "0000000001"
				TRB_TMP->VALOR		:= nVal
				msUnlock()
			endif
			dbSelectArea("QRY")
		Elseif ALLTRIM(SL4->L4_FORMA)<>"R$" .and. ALLTRIM(SL4->L4_FORMA)<>"CH" .and. ALLTRIM(SL4->L4_ORIGEM) <> "SIGATMK"
			nVal:= SL4->L4_VALOR
			dbSelectArea("TRB_TMP")
			if dbSeek(xFilial("SZ8")+SUBSTR(SL4->L4_ADMINIS,1,3)+SL4->L4_FORMA)
				RecLock("TRB_TMP",.F.)
				TRB_TMP->Valor:= TRB_TMP->Valor+nVal
				msUnlock()
			else 
				Aviso("Atencao","Nao foi possivel encontrar o Banco para Transferencia automatica para " + SL4->L4_ADMINIS + ;
				 			    "Favor verificar o cadastro de Bancos p/ Transf automatica. ",{"Ok"})				
				Sair()
				Return 
			endif
			dbSelectArea("QRY")
		Endif
		SL4->(dbSkip())
	Enddo
	dbSkip()
Enddo



// Recebimento de Titulos
dbSelectArea("SE5")
cSQLREC := "select * from " + cSE5
cSQLREC += " where D_E_L_E_T_ <> '*'"
cSQLREC += " and E5_BANCO = '" + _cOperador + "' "
cSQLREC += " and E5_RECPAG = 'R' and E5_TIPODOC = 'VL'"
cSQLREC += " and (E5_TIPO = 'NF' or E5_TIPO = 'DP' or E5_TIPO = 'FI' or E5_TIPO = 'BO')"
cSQLREC += " and E5_DATA = '" +DTOS(dDataBase) + "'"
cSQLREC += "order by E5_MOEDA"

tcQuery cSQLREC New Alias "QREC"

_nTotRec:= 0.00
_cDoca	:= ""
_cClia	:= ""
Do While !eof()                
	
	//Verifica se e cheque Predatado ou a vista
	If QREC->E5_MOEDA = "CH" //.and. (_cDoca <> QREC->E5_PREFIXO+QREC->E5_NUMERO+QREC->E5_PARCELAQ+QREC->E5_TIPO .or. QREC->E5_CLIFOR <>_cClia)
		If QREC->E5_MOTBX == "LIQ"
			If aScan(aNumLiq, rTrim(QREC->E5_DOCUMEN)) > 0
				dbSkip()
				Loop
			EndIf
			
			aAdd(aNumLiq, rTrim(QREC->E5_DOCUMEN))
			
			dbSelectArea("SE1")
			dbSetOrder(15) // E1_FILIAL+E1_NUMLIQ
			dbSeek(xFilial("SE1") + rTrim(QREC->E5_DOCUMEN))
			
			While !EOF();
				.And. SE1->E1_FILIAL == xFilial("SE1");
				.And. SE1->E1_NUMLIQ == rTrim(QREC->E5_DOCUMEN)
				
				_cPrefixo	:= SE1->E1_PREFIXO
				_cTitulo	:= SE1->E1_NUM
				_cParcela	:= SE1->E1_PARCELA
				_cTipo		:= SE1->E1_TIPO
				_cMoeda		:= "CH"
				_cCodCli	:= SE1->E1_CLIENTE
				_cLojaCli	:= SE1->E1_LOJA
				_cDescCli	:= Posicione("SA1", 1, XFILIAL("SA1") + _cCodCLi + _cLojaCli, "A1_NOME")
				
				dbSelectArea("SEF")
				dbSetOrder(3)  //EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM+EF_SEQUENC
				
				If Ascan(_aTitulo,_cPrefixo+_cTitulo+_cParcela+_cTipo) = 0 // Tratamento para recebimentos parciais no mesmo dia
					dbSeek(xFilial("SEF")+_cPrefixo+_cTitulo+_cParcela+_cTipo)
					While !EOF();
						.And. SEF->EF_FILIAL  == xFilial("SEF");
						.And. SEF->EF_PREFIXO == _cPrefixo;
						.And. SEF->EF_TITULO  == _cTitulo;
						.And. SEF->EF_PARCELA == _cParcela;
						.And. SEF->EF_TIPO    == _cTipo
						
						If FieldPos("EF_EMISSAO") > 0
							If DTOS(SEF->EF_EMISSAO) <> (QREC->E5_DATA)
								dbSkip()
								Loop
							EndIf
						Endif
						
						If DTOS(SEF->EF_VENCTO) > (QREC->E5_DATA)                          
							_nPos := Ascan(_aRecebTot, {|x| x[1] == _cMoeda} )
							If _nPos > 0
								_aRecebTot[_nPos][2] += SEF->EF_VALOR
							Else
								aAdd(_aRecebTot, {_cMoeda, SEF->EF_VALOR})
							Endif    
						Endif
						
						dbSkip()
					EndDo
					
					If Ascan(_aTitulo,_cPrefixo+_cTitulo+_cParcela+_cTipo) = 0
						aAdd(_aTitulo,_cPrefixo+_cTitulo+_cParcela+_cTipo)    
					Endif	
				EndIf
				
				dbSelectArea("SE1")
				dbSkip()
			End
		Endif	
	Endif	
	
	// Para as Outras Formas de Pagto
	If QREC->E5_MOEDA # "CH" .AND. QREC->E5_MOEDA # "R$"
		_nPos := Ascan(_aRecebTot, {|x| x[1] == QREC->E5_MOEDA} )
		If _nPos > 0
			_aRecebTot[_nPos][2]+= QREC->E5_VALOR
		Else
			aAdd(_aRecebTot, {QREC->E5_MOEDA, QREC->E5_VALOR})
		Endif
	EndIf   
	
	DbSelectArea("QREC")
	dbSkip()
EndDo

QREC->(dbCloseArea())

//Grava na Tabela Temporaria valores do Recebimento de Tituos
dbSelectArea("TRB_TMP")
DbGoBottom()
For i:= 1 to Len( _aRecebTot )
		if dbSeek(xFilial("SZ8")+ _aRecebTot[i][1])
			RecLock("TRB_TMP",.F.)
			TRB_TMP->Valor+= _aRecebTot[i][2]
			msUnlock()
		else		// Se Nao exisir Credito na Tabela SZ8.
			RecLock("TRB_TMP",.T.)  
			TRB_TMP->Z8_FILIAL	:= SM0->M0_CODFIL
			TRB_TMP->Z8_CODADM	:= _aRecebTot[i][1]
			TRB_TMP->Z8_BANCO	:= "CX1"
			TRB_TMP->Z8_AGENCIA	:= "00001"
			TRB_TMP->Z8_CONTA	:= "0000000001"
			TRB_TMP->AE_DESC	:= Alltrim(Posicione("SX5",1,xFilial("SX5")+"24"+_aRecebTot[i][1],"X5_DESCRI"))+" RECEB TITULO" 
			TRB_TMP->VALOR		+= _aRecebTot[i][2]
			msUnlock()
		endif	
Next

//Coloca Descricao de Cheque a Prazo  e Credito de Venda
dbSelectArea("TRB_TMP")
if dbSeek(xFilial("SZ8")+"CH")
	RecLock("TRB_TMP",.F.)
	TRB_TMP->AE_DESC:= "CHEQUE A PRAZO"
	msUnlock()
endif
if dbSeek(xFilial("SZ8")+"CR")
	RecLock("TRB_TMP",.F.)
	TRB_TMP->AE_DESC:= "CREDITO DE VENDA"
	msUnlock()
endif

dbSelectArea("TRB_TMP")
dbGoTop()
aCampos := {}
AADD(aCampos,{"Z8_CODADM","Cod Adm",""})
AADD(aCampos,{"AE_DESC","Descricao",""})
AADD(aCampos,{"AE_TIPO","Tipo",""})
AADD(aCampos,{"Z8_BANCO","Banco",""})
AADD(aCampos,{"Z8_AGENCIA","Agencia",""})
AADD(aCampos,{"Z8_CONTA","Conta",""})
AADD(aCampos,{"VALOR","Valor","@R 99,999.99",2})

//monta browse
@ 6,5 TO 180,320 BROWSE "TRB_TMP" FIELDS aCampos Object oBrowse
@ 184,200 BUTTON "_Ok" SIZE 40,15 ACTION ContSang()
@ 184,242 BUTTON "_Sair" SIZE 40,15 ACTION oDlg:end()

ACTIVATE DIALOG oDlg CENTERED
Sair()
Return nil

Static Function Sair()
dbSelectArea("QRY")
dbCloseArea() //Fecha Query
dbSelectArea("QRY_SZ8")
dbCloseArea() //Fecha Query
dbSelectArea("TRB_TMP")
msErase("TRB_TMP")
dbCloseArea()
//dbCloseArea() //Fecha aarquivo temporario
fErase(cArq+".*") //apaga arquivo temporario
Return nil



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para Efetuar o Lancamento de Transferencia            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Static Function ContSang()

if Aviso("Confirmacao","Deseja realmente efetuar a Transferencia Automatica?",{"Sim","Nao"},2,"Transferencia Automatica") == 2
//if SimNao("Deseja realmente efetuar a Transferencia Automatica?","Confirmacao") = "N"  
	Return
EndIf
Private _lBco1 := .T.
Private _lBco2 := .F.

// grava data da sangria automatica
dbSelectArea("SLJ")
dbSetOrder(1)	//LJ_FILIAL+LJ_CODIGO
dbGoTop()
if !dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0"))
	MsgBox("Nao foi possivel encontrar a loja no cadastro de Ident. de Loja, Transferencia nao efetuada")
	Return
endif
if Reclock("SLJ",.F.)
	SLJ->LJ_DTSANGR:= dDataBase
	msUnlock()
Endif

if !CarregaSa6(@cBanco,@cAgencia,@cConta,.F.)
	Msgbox("Erro ao encontrar o Banco do Caixa " + cBanco)
	Return
endif

dbSelectArea("TRB_TMP")
dbGoTop()

Do While .NOT. EOF()
	PegaBco(TRIM(Z8_CODADM))	
	if valor > 0

         // Gsabino 29.02.2008 - Grava o codigo da Administradora quando for sangria.
	    _cAdm       := ""
		cHistorico	:= "TRANSF. AUTOMAT. "
		IF TRIM(Z8_CODADM)=="CH"
			cHistorico+="CHEQUE A PRAZO"
		ELSEIF TRIM(Z8_CODADM)=="CR"
			cHistorico+="CREDITO DE VENDA"
		ELSE
			cHistorico+=AE_DESC
			// Gsabino 29.02.2008 - Grava o codigo da Administradora quando for sangria.
			_cAdm := Z8_CODADM
		ENDIF
		
		IF TRIM(Z8_CODADM)=="CH"
			cTipo		:= "CH"
		ELSEIF TRIM(Z8_CODADM)=="CR"
       		cTipo		:= "CR"
		ELSE
			cTipo		:= AE_Tipo
		ENDIF
		
		cNumDoc		:= DtoS(dDATABASE)
		nValor		:= Valor                                             
		
        // Gsabino 29.02.2008 - Grava o codigo da Administradora quando for sangria.
		U_AutoSang(cBanco,cAgencia,cConta,cNumDoc,cHistorico,cTipo,nValor,NIL,_cAdm)
	EndIF
	dbSkip()
Enddo

//fim da transferencia automatica
MsgInfo("   Transferencia Automatica Efetuada !!   ","Mensagem")
oDlg:End()
Return
      
Static Function PegaBco(cXAdm)
aArea:= GetArea()
DbSelectArea("SZ8")
dbSeek(xFilial("SZ8")+cXAdm)
cBanco	:= Z8_BANCO
cAgencia:= Z8_AGENCIA
cConta	:= Z8_CONTA
RestArea(aArea)
Return



