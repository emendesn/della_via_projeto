#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELR007  ºAutor  ³Ricardo Mansano     º Data ³  09/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ Fab.Tradicional  ³Contato ³ mansano@microsiga.com.br       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Aviso de Sinistro.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Chamdo via Menu.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DELR007()
Local cQuery     	:= ""
Local aOrd       	:= {}
Local cDesc1     	:= "Este programa eh responsavel pela"
Local cDesc2     	:= "geracao do Aviso de Sinistro"
Local cDesc3     	:= ""
Local _aArea   		:= {}
Local _aAlias  		:= {}

Private cTamanho  	:= "P" // "P"equeno "M"edio "G"rande
Private nTipo    	:= 15  // 15=Comprimido 18=Normal
Private Li			:= 00
Private cbtxt    	:= Space(10)
Private cbcont   	:= 00
Private cTitulo  	:= "Aviso de Sinistro"
Private m_pag    	:= 01  // Pagina Inicial (deve constar em todos os relatorios)
Private cPerg    	:= ""
Private cNomeProg 	:= "DELR007"
Private cString  	:= "PA8"
Private aReturn  	:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private wnrel    	:= cNomeProg

// Valida os casos de seguros nao Sinistrados
if Empty(PA8->PA8_DTSN)
	Aviso("Atenção !!!","Seguro não Sinistrado !!!",{" << Voltar"},2,"Aviso de Sinistro !")
	Return
endif

P_CtrlArea(1,@_aArea,@_aAlias,{"SM0","SBM","SA1","PAA","SB1","PAC"}) // GetArea

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa Relatorio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,cNomeProg,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,cTamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| StaticRel(@lEnd,wnRel,cString,cTamanho,nTipo)},cTitulo)

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StaticRel ºAutor  ³Ricardo Mansano     º Data ³  03/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ Fab.Tradicional  ³Contato ³ mansano@microsiga.com.br       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Impressao dos dados do relatorio                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Utilizada pela rotina principal deste programa             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function StaticRel(lEnd,wnRel,cString,cTamanho,nTipo)
Local nX			:= 0
Local cTxtCabec		:= ""
Local cTipoProduto	:= ""
Local aDadosCli		:= {}
Local aLinhas		:= {}
Local Cabec1		:= ""
Local Cabec2		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O Relatorio imprimira o Registro de Sinistros (PA8) posicionado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("PA8")
//PA8->(DbSetOrder(4)) // PA8_FILIAL+PA8_ORCSG+PA8_ITEM
//PA8->(DbSeek(xFilial("PA8")+"000282"))

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec(cTitulo,Cabec1,Cabec2,cNomeprog,cTamanho,nTipo)

// Localiza o Tipo do Produto pelo Grupo para imprimir o Cabecalho e demais detalhes no Relatorio
cTipoProduto := GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+PA8->PA8_CPROSG,1,"Erro")
cTipoProduto := GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cTipoProduto,1,"Erro")

cTxtCabec := "Seguro de " +Iif(Alltrim(cTipoProduto)=="R","Rodas","Pneus")+ " Della Via Pneus"
nX := 40 - (Len(cTxtCabec) / 2) // Acha o Centro
Li++
@ Li,nX PSay cTxtCabec
Li++
Li++

Li++
@ Li,000 PSay "Numero do Lacre: "+PA8->PA8_LACRE
@ Li,040 PSay "Numero do Sinistro: "+PA8->PA8_APOLIC
Li++

Li++
@ Li,000 PSay "Motivo da Reclamacao"
Li++
@ Li,000 PSay Replicate("-",80)
Li++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Motivo - Contem 200 Caracteres, logo abaixo imprimo o mesmo em         ³
//³          tres linhas, mas verifico antes se existe conteudo no mesmo.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTxtCabec := GetAdvFVal("PAA","PAA_DESC",xFilial("PAA")+PA8->PA8_CODMOT,1,"Erro")
@ Li,000 PSay PA8->PA8_CODMOT + " - " + SubStr(cTxtCabec,1,70)
Li++
// Imprime apenas se existir conteudo
If AllTrim(SubStr(cTxtCabec,71,80))<>""
	@ Li,000 PSay SubStr(cTxtCabec,71,80)
	Li++
Endif
If AllTrim(SubStr(cTxtCabec,151,50))<>""
	@ Li,000 PSay SubStr(cTxtCabec,151,50)
	Li++
Endif
Li++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados Gerais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ Li,000 PSay "Dados Gerais"
Li++
@ Li,000 PSay Replicate("-",80)
Li++
@ Li,000 PSay "Especificacao " +Iif(Alltrim(cTipoProduto)=="R","da Roda","do Pneu")+ ": "+;
GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+PA8->PA8_CPROSG,1,"Erro")
Li++
@ Li,000 PSay "Nome do Examinador: " + PA8->PA8_EXAMIN
Li++
@ Li,000 PSay "Km atual do Veiculo: " + StrZero(PA8->PA8_KMSN,6)

aDadosCli := GetAdvFVal("SM0",{"M0_NOME","M0_CIDENT","M0_ESTENT"},SM0->M0_CODIGO+PA8->PA8_LOJSN,1,{"Erro","Erro","Erro"})
Li++
@ Li,000 PSay "Revenda: " + aDadosCli[1]
Li++
@ Li,000 PSay "Cidade/UF: " + Alltrim(aDadosCli[2])+" - "+AllTrim(aDadosCli[3])
Li++
@ Li,000 PSay "Data do Sinistro: " + DtoC(PA8->PA8_DTSN)
Li++
@ Li,000 PSay "Matricula no.: " + PA8->PA8_MATRIC
Li++
@ Li,000 PSay "Residuo.: " + Transform(PA8->PA8_RESID,"999.99")
Li++
@ Li,000 PSay "Certificado: " + PA8->PA8_CERTIF
Li++
Li++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ Li,000 PSay "Declaracao"
Li++
@ Li,000 PSay Replicate("-",80)
Li++
// Detalhes da Declaracao
If cTipoProduto == "R"
	aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"003",1,"Erro"), 80)
Else
	aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"004",1,"Erro"), 80)
Endif
For nX := 1 to Len(aLinhas)
	@ Li++,000 PSay aLinhas[nX]
Next nI
Li++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Texto Complementar da Declaracao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Li++
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"005",1,"Erro"), 80)
For nX := 1 to Len(aLinhas)
	@ Li++,000 PSay aLinhas[nX]
Next nI
Li++

Li++
@ Li,000 PSay "Nota Fiscal no.: " + PA8->PA8_NFSG+"/"+PA8_SRSG
@ Li,040 PSay "Datada de: " + DtoC(PA8_DTSG)
Li++
Li++
Li++

Li++
@ Li,000 PSay Alltrim(GetAdvFVal("SM0","M0_CIDENT",SM0->M0_CODIGO+PA8->PA8_LOJSN,1,"Erro")) +", "+ DtoC(dDataBase)
Li++
Li++
Li++
Li++

Li++
@ Li,000 PSay "______________________"
Li++
@ Li,000 PSay "Assinatura do Segurado"
Li++
Li++
Li++
Li++

@ Li,000 Psay "_________________________"
@ Li,040 Psay "_________________________"
Li++
@ Li,000 Psay "R.G."
@ Li,040 Psay "C.P.F."

Li += 4

@ Li,040 Psay "_________________________"
Li++
@ Li,040 Psay "Assinatura Gerente Loja"
Li++
@ Li,040 Psay "e carimbo"

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return NIL
