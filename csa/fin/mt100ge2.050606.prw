#Include "rwmake.ch"
/*
Denis - 25/04/2006
O programa executava as alterações por meio de RecLock() -> MsUnlock(), foi
alterado para UPDATE direto, porque se a condição de pagamento gerar mais de
um titulo, todos serão alterados, e não apenas o titulo posicionado, como estava
antes.
*/
User Function MT100GE2
	Local cFilSE2  := SE2->E2_FILIAL
	Local cPrf     := SE2->E2_PREFIXO
	Local cNum     := SE2->E2_NUM
	Local cFornece := SE2->E2_FORNECE
	Local cLoja    := SE2->E2_LOJA
	Local cSql     := ""

	cSql := cSql + "UPDATE "+RetSqlName("SE2")
	/*
	Gravar a conta, centro de custo e item informados no SD1 estes
	campos sao obrigatorios e eram gerados vazios, o que fazia a
	usuaria ter dificuldades na hora de manipular titulos do SE2
	*/
	cSql := cSql + " SET E2_CONTAD  = '"+SD1->D1_CONTA+"'"
	cSql := cSql + " ,   E2_CCD     = '"+SD1->D1_CC+"'"
	cSql := cSql + " ,   E2_ITEMD   = '"+SD1->D1_ITEMCTA+"'"

	/*
	Denis - 25/04/2006
	Grava informações do portador no titulo de acordo com o que foi informado
	pelo Depto Financeiro, porém somente quando o fornecedor não for Pirelli.
	FS_DEL020 --> Parametro com Código+Loja da Pirelli.
	DV_PORTADO --> Parametro com Código do portador.
	*/
	If SE2->(E2_FORNECE+E2_LOJA) <> AllTrim(SuperGetMv("FS_DEL020",.F.,"00056701"))
		cSql := cSql + " ,   E2_PORTADO = '"+AllTrim(SuperGetMv("DV_PORTADO",.F.,"341"))+"'"
	Endif

	cSql := cSql + " WHERE D_E_L_E_T_ = ''"
	cSql := cSql + " AND   E2_FILIAL  = '"+cFilSE2+"'"
	cSql := cSql + " AND   E2_PREFIXO = '"+cPrf+"'"
	cSql := cSql + " AND   E2_NUM     = '"+cNum+"'"
	cSql := cSql + " AND   E2_FORNECE = '"+cFornece+"'"
	cSql := cSql + " AND   E2_LOJA    = '"+cLoja+"'"
	
	If TcSqlExec(cSql) < 0
		MsgBox(TcSqlError(),"MT100GE2","STOP")
	Endif
Return nil