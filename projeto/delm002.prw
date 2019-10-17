#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELM002         บAutor ณNorbert Waage Junior บData ณ 08/07/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de manutencao de credito de clientes                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cEmp - Empresa onde sera feita a manutencao                   บฑฑ
ฑฑบ          ณ cFil - Filial onde sera feita a manutencao                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pelo menu ou pelo workflow                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบMarcio Domณ13/06/06ณ      ณAdicionada ocorrencia 15 para pagamento em car-บฑฑ
ฑฑบ          ณ        ณ      ณtorio.                                         บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELM002(aEmp)
Local cArq		:= ""
Local cQuery 	:= ""
Local cTipos	:= ""
Local cTpTit	:= ""
Local nLimVcto	:= 0
Local lSA1Exc	:= .F.
Local lSE1Exc	:= .F.
Local lBlind	:= IsBlind()
Local cParChDev	:= ""
Local cParLeP	:= ""
Local cParTerc	:= ""
Local cParProt	:= ""
Local cDtVenc
Local cHora   := Time()
Local cArqTxt := "\CREDITO\BLQCRD_" + DtoS(Date()) + "_" + SubStr(cHora, 1, 2) + SubStr(cHora, 4, 2) + SubStr(cHora, 7, 2) + ".LOG"
Local cEOL    := "Chr(13) + Chr(10)"
Local nHdl    := 0
Local cLin    := ""
Local cSavCli := ""
Local lGrvLog := .F.
Local lUncCli := .F.
Local i
//Local nPos

If Len(aEmp) > 0             
	Conout("DELM002 - Linha 54 - Via Job")
	lBlind := .T.
	
	cEmpAnt			:= aEmp[1]
	cFilAnt		    := aEmp[2]
	
	// Abre as Tabelas para ser usado via JOB
	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2] FUNNAME "DELM002" MODULO "LOJA" TABLES "SA1","SE1","SX1","SX2","SX3","SX6","SZB"
	
Else                                
	Conout("DELM002 - Linha 63 - Manual")

	ValidPerg("MDEL02")
	If Pergunte("MDEL02", .T.)
		lUncCli := .T.
	EndIf
	
	If !MsgNoYes(OemtoAnsi("Confirma anแlise dos clientes?"), "Pergunta")
		Return
	EndIf
	
	If Empty(MV_PAR01 + MV_PAR02) .And. lUncCli
		lUncCli := .F.
	EndIf
	
	msgRun("Aguarde...",, {|| .T.})
EndIf

If Empty(cEOL)
	cEOL := Chr(13) + Chr(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

lGrvLog		:= GetNewPar("FS_DEL049", .F.)
cParChDev	:= AllTrim(Upper(FormatIn(TrataTipo(GetMv("FS_DEL040"),"/"),"/")))
cParLeP		:= AllTrim(Upper(FormatIn(TrataTipo(GetMv("FS_DEL041"),"/"),"/")))
cParTerc	:= AllTrim(Upper(FormatIn(TrataTipo(GetMv("FS_DEL042"),"/"),"/")))
cParProt	:= AllTrim(Upper(FormatIn(TrataTipo(GetMv("FS_DEL043"),"/"),"/")))

nLimVcto	:= GetMv("FS_DEL045")
cTipos		:= TrataTipo(GetMv("MV_CRDTPLC"),"/")

cDtVenc		:= DTOS(dDatabase - nLimVcto)
cTpTit		:= AllTrim(Upper(FormatIn(cTipos,"/")))

aParChDev	:= StrToKArr(GetMv("FS_DEL040"), "/")
aParLeP		:= StrToKArr(GetMv("FS_DEL041"), "/")
aParTerc	:= StrToKArr(GetMv("FS_DEL042"), "/")
aParProt	:= StrToKArr(GetMv("FS_DEL043"), "/")

If lBlind
	ConOut("Analise de clientes - Iniciando")
EndIf

If lGrvLog
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abre arquivo de log ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nHdl := fCreate(cArqTxt)
	
	If nHdl == -1
		If lBlind
			ConOut("O arquivo de log " + cArqTxt + " nใo p๔de ser criado!")
		Else
			MsgStop(OemtoAnsi("O arquivo de log " + cArqTxt + " nใo p๔de ser criado!"), "Aviso")
		EndIf
		Return
	Endif
Endif

dbSelectArea("SZB")
dbSetOrder(1) // ZB_FILIAL+ZB_PREFIXO+ZB_NUM+ZB_PARCELA+ZB_TIPO+ZB_CLIENTE+ZB_LOJA

DbSelectArea("SX2")
DbSetOrder(1)

DbSeek("SA1")
lSA1Exc := (SX2->X2_MODO == "E")

DbSeek("SE1")
lSE1Exc := (SX2->X2_MODO == "E")

DbSelectArea("SA1")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria indice temporario sem considerar a Filialณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArq := CriaTrab(Nil,.F.)
DbSelectArea("SA1")
IndRegua("SA1",cArq,"A1_COD+A1_LOJA")

#IFDEF TOP
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Desbloqueio de Clientes ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//Campos
	cQuery	:=	"SELECT DISTINCT SE1.E1_CLIENTE, SE1.E1_LOJA "
	
	//Tabelas
	cQuery	+=	"FROM " + RetSqlName("SE1") + " SE1 "
	
	cQuery	+=	"INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
	
	//Relacionamentos
	If	(lSA1Exc .And. lSE1Exc) .Or. (!lSA1Exc .And. !lSE1Exc)
		cQuery += "SA1.A1_FILIAL = SE1.E1_FILIAL AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA "
	Else
		cQuery += "SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA "
	EndIf
	
	//Filtro
	cQuery	+=	"WHERE SE1.D_E_L_E_T_ <> '*' AND "
	
	cQuery	+=	"SA1.D_E_L_E_T_ <> '*' AND "
	
	//Cliente
	If lUncCli
		cQuery  +=  "SE1.E1_CLIENTE = '" + MV_PAR01 + "' AND SE1.E1_LOJA = '" + MV_PAR02 + "' AND "
	EndIf
	
	//Cliente bloqueado
	cQuery	+=	"SA1.A1_VENCLC = '20010101' AND ("
	
	//Cheques Devolvidos
	cQuery	+=	"SE1.E1_PORTADO NOT IN ("
	
	//Cheques Devolvidos
	For i := 1 to Len(aParChDev)
		If !Empty(aParChDev[i])
			cQuery += "'" + aParChDev[i] + "', "
		EndIf
	Next i
	
	//Lucros e Perdas
	For i := 1 to Len(aParLeP)
		If !Empty(aParLeP[i])
			cQuery += "'" + aParLeP[i] + "', "
		EndIf
	Next i
	
	//Cobranca em Terceiros
	For i := 1 to Len(aParTerc)
		If !Empty(aParTerc[i])
			cQuery += "'" + aParTerc[i] + "', "
		EndIf
	Next i
	
	//Titulo Protestado
	For i := 1 to Len(aParProt)
		If !Empty(aParProt[i])
			cQuery += "'" + aParProt[i] + "', "
		EndIf
	Next i
	
	cQuery := Left(cQuery, Len(cQuery) - 2)
	cQuery += ") AND "
	
	//Titulo Vencido
	cQuery	+=	"(SE1.E1_VENCREA BETWEEN '" + cDtVenc + "' AND '" + DtoS(dDataBase - 1) + "' AND SE1.E1_SALDO > 0) AND "
	
	//Pagamento em Cartorio
	cQuery	+=	"(CONCAT(CONCAT(CONCAT(SE1.E1_PREFIXO, SE1.E1_NUM), SE1.E1_PARCELA), SE1.E1_TIPO) NOT IN "
	cQuery	+=	"(SELECT CONCAT(CONCAT(CONCAT(ZB_PREFIXO, ZB_NUM), ZB_PARCELA), ZB_TIPO) "
	cQuery	+=	"FROM " + RetSQLName("SZB") + " "
	cQuery	+=	"WHERE D_E_L_E_T_ <> '*' AND "
	cQuery	+=	"(ZB_OCORR = '08' OR ZB_OCORR = '15')))"
	
	//Ordem
	cQuery	+=	") ORDER BY SE1.E1_CLIENTE, SE1.E1_LOJA"
	
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("DELM02_1.SQL", cQuery)
	
	If Select("TMP") != 0
		TMP->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
	
	While !TMP->(Eof())
		
		If cSavCli == TMP->(E1_CLIENTE + E1_LOJA)
			TMP->(dbSkip())
			Loop
		EndIf
		
		cSavCli := TMP->(E1_CLIENTE + E1_LOJA)
		
		If SA1->(DbSeek(TMP->(E1_CLIENTE+E1_LOJA)))
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Altera vencimento do limite de credito ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !Empty(SA1->A1_DTLCANT)
				RecLock("SA1",.F.)
				SA1->A1_VENCLC	:= SA1->A1_DTLCANT
				MsUnLock("SA1")
				
				If lGrvLog
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Grava log de alteracao do cliente ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					cLin := SA1->A1_COD  + Space(1)
					cLin += SA1->A1_LOJA + Space(1)
					cLin += SA1->A1_NOME + Space(1)
					cLin += DtoC(SA1->A1_DTLCANT) + Space(1)
					cLin += "DESBLOQUEADO   "
					cLin += cEOL
					fWrite(nHdl, cLin, Len(cLin))
				EndIf
			EndIf
			
		EndIf
		
		TMP->(DbSkip())
		
	End
	
	TMP->(DbCloseArea())
	
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Bloqueio de Clientes ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cSavCli := ""
	
	//Campos
	cQuery	:=	"SELECT DISTINCT SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_PORTADO "
	
	//Tabelas
	cQuery	+=	"FROM " + RetSqlName("SE1") + " SE1 "
	
	cQuery	+=	"INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
	
	//Relacionamentos
	If	(lSA1Exc .And. lSE1Exc) .Or. (!lSA1Exc .And. !lSE1Exc)
		cQuery += "SA1.A1_FILIAL = SE1.E1_FILIAL AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA "
	Else
		cQuery += "SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA "
	EndIf
	
	//Filtro
	cQuery	+=	"WHERE SE1.D_E_L_E_T_ <> '*' AND "
	
	cQuery	+=	"SA1.D_E_L_E_T_ <> '*' AND "
	
	//Cliente
	If lUncCli
		cQuery  +=  "SE1.E1_CLIENTE = '" + MV_PAR01 + "' AND SE1.E1_LOJA = '" + MV_PAR02 + "' AND "
	EndIf
	
	//Exclui cliente vip
	cQuery	+=	"SA1.A1_VIP <> 'S' AND ("
	
	//Cheques Devolvidos
	cQuery	+=	"(SE1.E1_PORTADO IN " + cParChDev + " AND SE1.E1_SALDO > 0) OR "
	
	//Lucros e Perdas
	cQuery	+=	"(SE1.E1_PORTADO IN " + cParLeP + " AND SE1.E1_SALDO = 0) OR "
	
	//Cobranca em Terceiros
	cQuery	+=	"(SE1.E1_PORTADO IN " + cParTerc + ") OR "
	
	//Titulo Vencido
	cQuery	+=	"(SE1.E1_VENCREA < '" + cDtVenc + "' AND SE1.E1_SALDO > 0) OR "
	
	//Titulo Protestado
	cQuery	+=	"(SE1.E1_PORTADO IN " + cParProt + ") OR "
	
	//Pagamento em Cartorio
	cQuery	+=	"(CONCAT(CONCAT(CONCAT(SE1.E1_PREFIXO, SE1.E1_NUM), SE1.E1_PARCELA), SE1.E1_TIPO) IN "
	cQuery	+=	"(SELECT CONCAT(CONCAT(CONCAT(ZB_PREFIXO, ZB_NUM), ZB_PARCELA), ZB_TIPO) "
	cQuery	+=	"FROM " + RetSQLName("SZB") + " "
	cQuery	+=	"WHERE D_E_L_E_T_ <> '*' AND "
	cQuery	+=	"ZB_OCORR = '08'))"
	
	//Ordem
	cQuery	+=	") ORDER BY SE1.E1_CLIENTE, SE1.E1_LOJA"
	
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("DELM02_2.SQL", cQuery)
	
	If Select("TMP") != 0
		TMP->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
	
	While !TMP->(Eof())
		
		If cSavCli == TMP->(E1_CLIENTE + E1_LOJA)
			TMP->(dbSkip())
			Loop
		EndIf
		
		cSavCli := TMP->(E1_CLIENTE + E1_LOJA)
		
		If SA1->(DbSeek(TMP->(E1_CLIENTE+E1_LOJA)))
			
			If lGrvLog
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Grava log de alteracao do cliente ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cLin := SA1->A1_COD  + Space(1)
				cLin += SA1->A1_LOJA + Space(1)
				cLin += SA1->A1_NOME + Space(1)
				cLin += DtoC(SA1->A1_VENCLC) + Space(1)
				
				//Cheques Devolvidos
				If TMP->E1_PORTADO $ GetMv("FS_DEL040")
					cLin += "CHQ DEVOLVIDO  "
					//Lucros e Perdas
				ElseIf TMP->E1_PORTADO $ GetMv("FS_DEL041")
					cLin += "LUCROS E PERDAS"
					//Cobranca em Terceiros
				ElseIf TMP->E1_PORTADO $ GetMv("FS_DEL042")
					cLin += "EM TERCEIROS   "
					//Titulo Protestado
				ElseIf TMP->E1_PORTADO $ GetMv("FS_DEL043")
					cLin += "PROTESTADO     "
					//Cartorio
				ElseIf SZB->(dbSeek(xFilial("SZB") + TMP->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO)))
					cLin += "CARTORIO       "
					//Vencido
				Else
					cLin += "VENCIDO        "
				EndIf
				
				cLin += cEOL
				fWrite(nHdl, cLin, Len(cLin))
			EndIf
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Altera vencimento do limite de credito ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			RecLock("SA1",.F.)
			SA1->A1_DTLCANT := SA1->A1_VENCLC
			SA1->A1_VENCLC	:= CtoD("01/01/01")
			MsUnLock("SA1")
			
		EndIf
		
		TMP->(DbSkip())
		
	End
	
	TMP->(DbCloseArea())
	
#ELSE
	If lBlind
		ConOut("Analise de clientes - Tentativa de execucao fora de ambiente TopConnect - Abortada")
	Else
		ApMsgAlert("Esta rotina s๓ pode ser executada em ambiente TopConnect!","Erro")
	EndIf
#ENDIF

If lGrvLog
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha arquivo de log ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	fClose(nHdl)
EndIf

If lBlind
	ConOut("Analise de clientes - Finalizada")
Else
	ApMsgAlert("Analise de clientes - Finalizada","Atualiza็ใo de clientes")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณApaga arquivo temporarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RetIndex("SA1")
DbSetorder(1)
Ferase(cArq+OrdBagExt())

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณ TrataTipo       บAutor ณNorbert Waage Junior บData ณ 09/08/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Substitui os separadores da string pelo segundo parametro     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cString - String a ser avaliada                               บฑฑ
ฑฑบ          ณ cSep    - Caractere a ser inserido no lugar do separador      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ cString - String alterada                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao generica                                               บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TrataTipo(cString,cSep)

Local aTipos	:= {"/",",",";","|","-"}
Local nX		:= 1
Local nAt		:= 0

While nX <= Len(aTipos)
	If (nAt := At(aTipos[nX],cString)) > 0
		cString := StrTran(cString,aTipos[nX],cSep)
	EndIf
	nX++
End

Return cString



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณPaulo Benedet          บ Data ณ  13/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Confere perguntas do SX1                                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cPerg - Grupo de perguntas                                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo menu                                      บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)
Local nCampos := 0
Local aDados  := {}
Local i, j

aAdd(aDados, {cPerg, "01", "Codigo do cliente ?           ", "", "", "mv_ch1", "C", 6, 0, 0, "G", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", "", "", "", ""})
aAdd(aDados, {cPerg, "02", "Loja do cliente ?             ", "", "", "mv_ch2", "C", 2, 0, 0, "G", "", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

//exemplo
//aAdd(aDados, {cPerg, "05", "Quinzena                     ?", "", "", "mv_ch5", "C", 1, 0, 0, "G", "", "MV_PAR05", "D1", "", "", "", "V2", "", "", "", "", "V3", "", "", "", "", "V4", "", "", "", "", "V5", "", "", "", "", "F3", "", "", "", ""})

dbSelectArea("SX1")
dbSetOrder(1)
nCampos := fCount()

For i := 1 to Len(aDados)
	If !dbSeek(aDados[i][1] + aDados[i][2])
		RecLock("SX1", .T.)
		For j := 1 to nCampos
			FieldPut(j, aDados[i][j])
		Next j
		msUnlock()
	EndIf
Next i

Return
