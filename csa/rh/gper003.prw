#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER011  � Autor � R.H. - Reginaldo      � Data � 24.09.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcionarios Admitidos                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function GPER003()

Local cDesc1  := "Funcionarios Admitidos "
Local cDesc2  := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := "SRA"                 // alias do arquivo principal (Base)
Local aOrd    := {"Matricula"," Nome"} 
Local aRegs   := {}
//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn := {"Zebrado", 1,"Administra��o", 2, 2, 1, "",1 }	//"Zebrado"###"Administra��o"
Private NomeProg:= "GPER003"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "GPER03"


//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
Private Titulo
Private AT_PRG   := "GPER003"
Private wCabec0  := 1
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
_aPerg := {}
cPerg := "GPER03"

aAdd(_aPerg, {cPerg,"02","Data de        "," " ," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"03","Data ate       "," " ," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"04","Filial de      "," " ," ","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"05","Filial ate     "," " ," ","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg, {cPerg,"10","Categorias     "," " ," ","mv_ch5","C",12,0,0,"G","fCategoria","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(_aPerg)


pergunte("GPER03",.F.)

cTit   := " Funcionarios Admitidos "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER003"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem     := aReturn[8]
dDataDe    := mv_par01
dDataAte   := mv_par02
cFilDe     := mv_par03
cFilAte    := mv_par04
cCategoria := mv_par05
wCabec1  := "Fl C.C.   Matric. Nome                                Dt Admissao  Funcao                                Salario "
Titulo   := " Relacao de Funcionarios Admitidos de " + Dtoc(dDatade) + " a " + Dtoc(dDataAte)

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER210  � Autor � R.H. - Reginaldo      � Data � 24.05.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcionarios Admitidos   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � GPR210Imp(lEnd,wnRel,cString)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GR210Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local CbTxt //Ambiente
Local CbCont
Local lAceita  		:= .F.

/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/

If nOrdem == 1
   cOrdem := "RA_FILIAL,RA_MAT"
ElseIf nOrdem == 2
   cOrdem := "RA_FILIAL,RA_NOME"
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

cQuery_ := "SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC,RA_CATFUNC,RA_ADMISSA,RA_SALARIO,RA_NUMCP,RA_SERCP,RJ_DESCCMP "
cQuery_ += " FROM " + RETSQLNAME("SRA") + "," + RETSQLNAME("SRJ")
cQuery_ += " WHERE RA_FILIAL >= '" + cFilDe +"' AND RA_FILIAL <= '"+cFilAte+"'"
cQuery_ += " AND RA_CATFUNC IN"+cCat
cQuery_ += " AND RA_ADMISSA >= '" + Dtos(dDataDe) + "' AND RA_ADMISSA <='"+ DTOS(dDataAte)+"'"
cQuery_ += " AND RA_CODFUNC = RJ_FUNCAO "
cQuery_ += " AND " + RETSQLNAME("SRA") + ".D_E_L_E_T_ = ' ' " 
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
	
	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
	IncRegua()
	
	//��������������������������������������������������������������Ŀ
	//� Cancela Impres�o ao se pressionar <ALT> + <A>                �
	//����������������������������������������������������������������
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	

    cDet :=  sranew->ra_filial  + " " + SRANEW->RA_CC+" "+sranew->ra_mat     + "  " + sranew->ra_nome + "  "
    cDet +=  TRansform(STOD(SRANEW->RA_ADMISSA),"@R 99/99/9999") + "  " + substr(SRANEW->RJ_DESCCMP,1,40) + "  " + TRansform(SRANEW->RA_SALARIO,"@E 99,999.99") 
    Impr(cDet)

    dbSkip()
    nTot ++

Enddo
Set Century off
Impr("")
Impr("Total de Funcionario " + Transform(nTot, "9999") )
Impr("","P")

//��������������������������������������������������������������Ŀ
//� Termino do relatorio                                         �
//����������������������������������������������������������������

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

//�����������������������������������������������������������Ŀ
//� Armazena a estrutura do arquivo de perguntas SX1 no array �
//�������������������������������������������������������������
_aCampos := DbStruct()


//������������������������������������������������������������Ŀ
//� Estabelece o limite para a grava��o do registro pelo menor �
//� valor obtido entre a compara��o da estrutura do arquivo e  �
//� a dimens�o da linha do array enviado como par�metro        �
//��������������������������������������������������������������
_nLimite := Iif(Len(_aPerg[1])<Len(_aCampos), Len(_aPerg[1]), Len(_aCampos))

FOR _n:=1 TO Len(_aPerg)
	//�������������������������������������������������������������
	//� Verifica se o registro da pergunta j� n�o est� cadastrado �
	//�������������������������������������������������������������
	IF !DbSeek(_aPerg[_n, 1] + _aPerg[_n, 2], .f.)
		//�����������������������������������������������������������Ŀ
		//� Caso n�o esteja cadastrado, cria registro novo e grava os �
		//� campos com base nos dados do array passado como par�metro �
		//�������������������������������������������������������������
		RecLock("SX1", .T.)
			FOR _x:=1 TO _nLimite
				FieldPut(FieldPos(_aCampos[_x, 1]), _aPerg[_n, _x])
			NEXT
		MsUnlock()
	ENDIF
NEXT

RETURN
