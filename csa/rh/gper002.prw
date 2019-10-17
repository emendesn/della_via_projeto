#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER001 ³ Autor ³ R.H. - Reginaldo      ³ Data ³ 24.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcionarios em Ferias                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GPER002()

Local cDesc1  := "Funcionarios em Ferias "
Local cDesc2  := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := "SRA"                 // alias do arquivo principal (Base)
Local aOrd    := {"Filial + Matricula","Filial + C.Custo","Filial + Nome","Data Inicio + Nome"} 
Local aRegs   := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn := {"Zebrado", 1,"Administra‡„o", 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private NomeProg:= "GPER002"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "GPER02"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo
Private AT_PRG   := "GPER002"
Private wCabec0  := 2
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerg := {}
cPerg := "GPER02"

aAdd(_aPerg, {cPerg,"02","Data de        "," " ," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"03","Data ate       "," " ," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"04","Filial de      "," " ," ","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"05","Filial ate     "," " ," ","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"06","C. Custo de    "," " ," ","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"07","C. Custo ate   "," " ," ","mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"08","Matricula de   "," " ," ","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"09","Matricula ate  "," " ," ","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"10","Categorias     "," " ," ","mv_cha","C",10,0,0,"G","fCategoria","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(_aPerg)


pergunte("GPER02",.F.)

cTit   := " Funcionarios em Ferias "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER002"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem     := aReturn[8]
dDataDe    := mv_par01
dDataAte   := mv_par02
cFilDe     := mv_par03
cFilAte    := mv_par04
cCcDe      := mv_par05
cCcAte     := mv_par06
cMatDe     := mv_par07
cMatAte    := mv_par08
cCategoria := mv_par09
wCabec1  := "                                                   Periodo  Aquisitivo        Periodo Gozo         dias   dias    perc"
wCabec2  := "Fl C.C.   Matric. Nome                                de         ate         de         ate        Fer.   abono   13o."
Titulo   := " Relacao de Funcionarios em ferias de " + Dtoc(dDatade) + " a " + Dtoc(dDataAte)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| GR210Imp(@lEnd,wnRel,cString)},titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER210  ³ Autor ³ R.H. - Reginaldo      ³ Data ³ 24.05.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcionarios em ferias                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPR210Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GR210Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt //Ambiente
Local CbCont
Local lAceita  		:= .F.

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de Acesso do Usuario                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

If nOrdem == 1
   cOrdem := "RA_FILIAL,RA_MAT,RH_DATAINI"
ElseIf nOrdem == 2
   cOrdem := "RA_FILIAL,RA_CC,RA_NOME,RH_DATAINI"
ElseIf nOrdem == 3
   cOrdem := "RA_FILIAL,RA_NOME,RH_DATAINI"
ElseIf nOrdem == 4
   cOrdem := "RA_FILIAL,RH_DATAINI,RA_NOME"
Endif

cCat := "("
For nx := 1 to Len(cCategoria)
   If Substr(cCategoria,nx,1) != "*"
	   If cCat == "("
    	  cCat += "'"
	   Else
    	  cCat += "','"
	   EndIF
	   cCat += Substr(cCategoria,nx,1)
	EndIF   
Next
cCat += "')"

cQuery_ := "SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC,RA_CATFUNC,RA_SALARIO,RH_DATABAS,RH_DBASEAT,RH_DFERIAS,RH_DABONPE,RH_PERC13S,RH_DATAINI,RH_DATAFIM "
cQuery_ += " FROM " + RETSQLNAME("SRA") + "," +RETSQLNAME("SRH")
cQuery_ += " WHERE RA_FILIAL >= '" + cFilDe +"' AND RA_FILIAL <= '"+cFilAte+"'"
cQuery_ += " AND RA_MAT    >= '" + cMatDe   +"' AND RA_MAT    <= '"+cMatAte+"'" 
cQuery_ += " AND RA_CC     >= '" + cCcDe    +"' AND RA_CC     <= '"+cCcAte+"'" 
cQuery_ += " AND RA_CATFUNC IN"+cCat
cQuery_ += " AND RA_FILIAL = RH_FILIAL AND RA_MAT = RH_MAT" 
cQuery_ += " AND RH_DATAINI >= '" + Dtos(dDataDe) + "' AND RH_DATAINI <='"+ DTOS(dDataAte)+"'"
cQuery_ += " AND " + RETSQLNAME("SRA") + ".D_E_L_E_T_ = ' ' " 
CqUERY_ += " AND " + RETSQLNAME("SRH") + ".D_E_L_E_T_ = ' ' " 
cQuery_ += " ORDER BY " + cOrdem
cQuery_ := CHANGEQUERY(cQuery_)

_cArqTrb := CriaTrab(nil, .f.)
IF Select("SRANEW")>0
   DbSelectArea("SRANEW")
   DbCloseArea()
ENDIF

tcQuery cQuery_ NEW ALIAS "SRANEW"

dbSelectArea("SRANEW")
dbGoTop()
COPY TO &(_cArqTrb+OrdBagExt())
dbCloseArea()
dbUseArea(.T.,,_cArqTrb+OrdBagExt(),"SRANEW",.T.)

dbSelectArea("SRANEW")
dbGoTop()
nTot := 0
Set Century on
SetRegua(SRANEW->(RecCount()))
While	!EOF()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cancela ImpresÆo ao se pressionar <ALT> + <A>                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	

    cDet :=  sranew->ra_filial  + " " + SRANEW->RA_CC+" "+sranew->ra_mat     + "  " + sranew->ra_nome + "  "
    cDet +=  TRansform(STOD(SRANEW->RH_DATABAS),"@R 99/99/9999") + "  " +TRansform(STOD(SRANEW->RH_DBASEAT),"@R 99/99/9999") + "  " 
    cDet +=  TRansform(STOD(SRANEW->RH_DATAINI),"@R 99/99/9999") + "  " +TRansform(STOD(SRANEW->RH_DATAFIM),"@R 99/99/9999") + "  " 
    cDet +=  TRansform(SRANEW->RH_DFERIAS,"@R 999.9") + "  " +TRansform(SRANEW->RH_DABONPE,"@R 999.9") + "  " 
    cDet +=  TRansform(SRANEW->RH_PERC13S,"@R 999.99") 
    Impr(cDet)

    dbSkip()
    nTot ++

Enddo
Set Century off
Impr("")
Impr("Total de Funcionario " + Transform(nTot, "9999") )
Impr("","P")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SRANEW")
DbCloseArea()
Ferase(_cArqTrb+OrdBagExt())

DbSelectarea("SRA")
Set filter to
RetIndex("SRA")
DbGoTop()

Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

Static FUNCTION AjustaSx1(_aPerg)
Local _n,_aCampos,_nLimite,_x

DbSelectArea("SX1")
DbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena a estrutura do arquivo de perguntas SX1 no array ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aCampos := DbStruct()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estabelece o limite para a gravação do registro pelo menor ³
//³ valor obtido entre a comparação da estrutura do arquivo e  ³
//³ a dimensão da linha do array enviado como parâmetro        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLimite := Iif(Len(_aPerg[1])<Len(_aCampos), Len(_aPerg[1]), Len(_aCampos))

FOR _n:=1 TO Len(_aPerg)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o registro da pergunta já não está cadastrado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !DbSeek(_aPerg[_n, 1] + _aPerg[_n, 2], .f.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso não esteja cadastrado, cria registro novo e grava os ³
		//³ campos com base nos dados do array passado como parâmetro ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SX1", .T.)
			FOR _x:=1 TO _nLimite
				FieldPut(FieldPos(_aCampos[_x, 1]), _aPerg[_n, _x])
			NEXT
		MsUnlock()
	ENDIF
NEXT

RETURN
