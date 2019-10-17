#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � IMPATF   �Autor  �Ernani Forastieri   � Data �  10/10/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para importacao de Ativo Fixo usando MSExecAuto a   ���
���          � a partir de arquivo texto com layout pre definido          ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ImpATF()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := ""
Local cDesc1  := "Este rotina ira fazer a importacao do cadastros de Ativo Fixo"
Local cDesc2  := ""
Private _cArquivo := ""
Private cPerg := ""

/*
CriaSX1()
Pergunte(cPerg, .F.)
*/

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd( aButton, { 5, .T., {|| _cArquivo := SelArq()    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...", "Executando rotina.", .T. )

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � RUNPROC  �Autor  �Ernani Forastieri   � Data �  10/10/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de processamento                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunProc(lEnd)
Local _aDadCab  := {}
Local _aDadItens := {}
Local _aDadHist  := {}
Local _aVetCab := {}
Local _aVetCpos:= {}
Local _aVetHpos:= {}
Local _aVetItens:= {}
Local _nNumCposCab := 0
Local _nNumCposItem := 0
Local _nCt := 0
Local _nNumHposItem := 0
LOCAL _cFileLog
Local _cPath := ""
Local i, _nHdl
Local _cBuffer := ""
Local _nTamLin := 1273 //  Tamanho  + chr(13) + chr(10)

If !File(_cArquivo)
	MSGBOX("Arquivo de importacao nao encontrado", "", "ERRO")
	Return NIL
EndIF



//{Campo, Tipo, Col.Ini, 	Tamanho, Dec, Importa ou nao } //	Descricao do Produto

aAdd( _aDadCab, { "N1_FILIAL" ,	"C", 	   1, 	 2, 0, .T.  } ) //	Filial do Sistema
aAdd( _aDadCab, { "N1_CBASE"  ,	"C", 	   3, 	10, 0, .T.  } ) //	C�digo Base do Bem
aAdd( _aDadCab, { "N1_ITEM"   ,	"C", 	  13, 	 4, 0, .T.  } ) //	Numero do Item
aAdd( _aDadCab, { "N1_AQUISIC", "D", 	  17, 	 8, 0, .T.  } ) //	Data de Aquisi��o
aAdd( _aDadCab, { "N1_DESCRIC", "C", 	  25, 	40, 0, .T.  } ) //	Descri��o Sint+tica
aAdd( _aDadCab, { "N1_QUANTD" ,	"N", 	  65, 	 9, 3, .T.  } ) //	Quantidade do Bem
aAdd( _aDadCab, { "N1_BAIXA"  ,	"D", 	  74, 	 8, 0, .T.  } ) //	Data da Baixa
aAdd( _aDadCab, { "N1_CHAPA"  ,	"C", 	  82, 	 6, 0, .T.  } ) //	Numero da Plaqueta
aAdd( _aDadCab, { "N1_GRUPO"  ,	"C", 	  88, 	 4, 0, .T.  } ) //	Grupo do Bem
aAdd( _aDadCab, { "N1_CSEGURO", "C", 	  92, 	25, 0, .T.  } ) //	Cia. de Seguro
aAdd( _aDadCab, { "N1_APOLICE", "C", 	 117, 	15, 0, .T.  } ) //	Numero da Ap�lice
aAdd( _aDadCab, { "N1_DTVENC" ,	"D", 	 132, 	 8, 0, .T.  } ) //	Vencimento do Seguro
aAdd( _aDadCab, { "N1_TIPOSEG",	"C", 	 140, 	 5, 0, .T.  } ) //	Tipo de Seguro
aAdd( _aDadCab, { "N1_FORNEC" ,	"C", 	 145, 	 6, 0, .T.  } ) //	C�digo do Fornecedor
aAdd( _aDadCab, { "N1_LOJA"   ,	"C", 	 151, 	 2, 0, .T.  } ) //	Loja do Fornecedor
aAdd( _aDadCab, { "N1_LOCAL"  ,	"C", 	 153, 	 6, 0, .T.  } ) //	Endereco
aAdd( _aDadCab, { "N1_NSERIE" ,	"C", 	 159, 	 3, 0, .T.  } ) //	S+rie da Nota Fiscal
aAdd( _aDadCab, { "N1_NFISCAL", "C", 	 162, 	 6, 0, .T.  } ) //	Numero da Nota Fiscal
aAdd( _aDadCab, { "N1_PROJETO", "C", 	 168, 	10, 0, .T.  } ) //	C�digo do Projeto
aAdd( _aDadCab, { "N1_CHASSIS", "C", 	 178, 	20, 0, .T.  } ) //	Numero Chassis Veiculo
aAdd( _aDadCab, { "N1_PLACA"  ,	"C", 	 198, 	 7, 0, .T.  } ) //	Placa do Veiculo
aAdd( _aDadCab, { "N1_STATUS" ,	"C", 	 205, 	 1, 0, .F.  } ) //	Status Atual do Bem
aAdd( _aDadCab, { "N1_PATRIM" ,	"C", 	 206, 	 1, 0, .T.  } ) //	Classificacao
aAdd( _aDadCab, { "N1_CODCIAP", "C", 	 207, 	 6, 0, .T.  } ) //	Codigo CIAP
aAdd( _aDadCab, { "N1_ICMSAPR", "N", 	 213, 	18, 2, .T.  } ) //	Icms do Item
aAdd( _aDadCab, { "N1_DTBLOQ" ,	"D", 	 231, 	 8, 0, .T.  } ) //	Data para bloqueio
aAdd( _aDadCab, { "N1_CODBEM" ,	"C", 	 239, 	16, 0, .T.  } ) //	Codigo do Bem no SIGAMNT
aAdd( _aDadCab, { "N1_BASESUP", "C", 	 255, 	10, 0, .F.  } ) //	Codigo Base Superior
aAdd( _aDadCab, { "N1_ITEMSUP", "C", 	 265, 	 4, 0, .F.  } ) //	Item Superior
// Total			269

aAdd( _aDadItens, { "N3_FILIAL" , 	"C", 	   1, 	 2, 0, .T.  } ) //	Filial do Sistema
aAdd( _aDadItens, { "N3_CBASE"  , 	"C", 	   3, 	10, 0, .T.  } ) //	Codigo Base do Bem
aAdd( _aDadItens, { "N3_ITEM"   ,   "C", 	  13, 	 4, 0, .T.  } ) //	Codigo do Item do Bem
aAdd( _aDadItens, { "N3_TIPO"   ,   "C", 	 269, 	 2, 0, .T.  } ) //	Tipo do Ativo
aAdd( _aDadItens, { "N3_BAIXA"  , 	"C", 	 271, 	 1, 0, .T.  } ) //	Ocorrencia da Baixa
aAdd( _aDadItens, { "N3_HISTOR" , 	"C", 	 272, 	40, 0, .T.  } ) //	Historico do Valor
aAdd( _aDadItens, { "N3_CCONTAB", 	"C", 	 312, 	20, 0, .T.  } ) //	Conta Contabil
aAdd( _aDadItens, { "N3_CUSTBEM", 	"C",  	 332, 	 9, 0, .T.  } ) //	C Custo da Conta do Bem
aAdd( _aDadItens, { "N3_CDEPREC", 	"C",  	 341, 	20, 0, .T.  } ) //	Conta Despesa Depreciacao
aAdd( _aDadItens, { "N3_CCUSTO" , 	"C", 	 361, 	 9, 0, .T.  } ) //	Centro de Custo Despesa
aAdd( _aDadItens, { "N3_CCDEPR" , 	"C", 	 370, 	20, 0, .T.  } ) //	Conta Deprec. Acumulada
aAdd( _aDadItens, { "N3_CDESP"  , 	"C", 	 390, 	20, 0, .T.  } ) //	Cta Correcao Depreciacao
aAdd( _aDadItens, { "N3_CCORREC", 	"C", 	 410, 	20, 0, .T.  } ) //	Conta Correcao Bem
aAdd( _aDadItens, { "N3_NLANCTO", 	"C", 	 430, 	 9, 0, .T.  } ) //	Num Lancto Contabil
aAdd( _aDadItens, { "N3_DLANCTO", 	"D", 	 439, 	 8, 0, .T.  } ) //	Data lancamento
aAdd( _aDadItens, { "N3_DINDEPR", 	"D", 	 447, 	 8, 0, .T.  } ) //	Data Inicio depreciacao
aAdd( _aDadItens, { "N3_DEXAUST", 	"D", 	 455, 	 8, 0, .T.  } ) //	Data Exaustao do Bem
aAdd( _aDadItens, { "N3_VORIG1" , 	"N", 	 463, 	16, 2, .T.  } ) //	Valor Original Moeda 1
aAdd( _aDadItens, { "N3_TXDEPR1", 	"N", 	 479, 	 8, 4, .T.  } ) //	Taxa Anual Deprecia��o 1
aAdd( _aDadItens, { "N3_VORIG2" , 	"N", 	 487, 	16, 4, .T.  } ) //	Valor Original Moeda 2
aAdd( _aDadItens, { "N3_TXDEPR2", 	"N", 	 503, 	 8, 4, .T.  } ) //	Taxa Anual Deprecia��o 2
aAdd( _aDadItens, { "N3_VORIG3" , 	"N", 	 511, 	16, 4, .T.  } ) //	Valor Original Moeda 3
aAdd( _aDadItens, { "N3_TXDEPR3", 	"N", 	 527, 	 8, 4, .T.  } ) //	Taxa Anual Deprecia��o 3
aAdd( _aDadItens, { "N3_VORIG4" , 	"N", 	 535, 	16, 4, .T.  } ) //	Valor Original Moeda 4
aAdd( _aDadItens, { "N3_TXDEPR4", 	"N", 	 551, 	 8, 4, .T.  } ) //	Taxa Anual Deprecia��o 4
aAdd( _aDadItens, { "N3_VORIG5" , 	"N", 	 559, 	16, 4, .T.  } ) //	Valor Original Moeda 5
aAdd( _aDadItens, { "N3_TXDEPR5", 	"N", 	 575, 	 8, 4, .T.  } ) //	Taxa Anual Deprecia��o 5
aAdd( _aDadItens, { "N3_VRCBAL1", 	"N", 	 583, 	16, 2, .T.  } ) //	Correcao Balanco Moeda 1
aAdd( _aDadItens, { "N3_VRDBAL1", 	"N", 	 599, 	16, 2, .T.  } ) //	Deprecia Balanco Moeda 1
aAdd( _aDadItens, { "N3_VRCMES1", 	"N", 	 615, 	16, 2, .T.  } ) //	Correcao no Mes Moeda 1
aAdd( _aDadItens, { "N3_VRDMES1", 	"N", 	 631, 	16, 2, .T.  } ) //	Valor Depr. Mes Moeda 1
aAdd( _aDadItens, { "N3_VRCACM1", 	"N", 	 647, 	16, 2, .T.  } ) //	Correcao Acumulada Moeda1
aAdd( _aDadItens, { "N3_VRDACM1", 	"N", 	 663, 	16, 2, .T.  } ) //	Deprecia Acumulada Moeda1
aAdd( _aDadItens, { "N3_VRDBAL2", 	"N", 	 679, 	16, 4, .T.  } ) //	Depreciac Balanco Moeda 2
aAdd( _aDadItens, { "N3_VRDMES2", 	"N", 	 695, 	16, 4, .T.  } ) //	Deprecia Mes Moeda 2
aAdd( _aDadItens, { "N3_VRDACM2", 	"N", 	 711, 	16, 4, .T.  } ) //	Deprecia Acumulada Moeda2
aAdd( _aDadItens, { "N3_VRDBAL3", 	"N", 	 727, 	16, 4, .T.  } ) //	Depreciac Balanco Moeda 3
aAdd( _aDadItens, { "N3_VRDMES3", 	"N", 	 743, 	16, 4, .T.  } ) //	Deprecia Mes Moeda 3
aAdd( _aDadItens, { "N3_VRDACM3", 	"N", 	 759, 	16, 4, .T.  } ) //	Deprecia Acumulada Moeda3
aAdd( _aDadItens, { "N3_VRDBAL4", 	"N", 	 775, 	16, 4, .T.  } ) //	Depreciac Balanco Moeda 4
aAdd( _aDadItens, { "N3_VRDMES4", 	"N", 	 791, 	16, 4, .T.  } ) //	Deprecia Mes Moeda 4
aAdd( _aDadItens, { "N3_VRDACM4", 	"N", 	 807, 	16, 4, .T.  } ) //	Deprecia Acumulada Moeda4
aAdd( _aDadItens, { "N3_VRDBAL5", 	"N", 	 823, 	16, 4, .T.  } ) //	Depreciac Balanco Moeda 5
aAdd( _aDadItens, { "N3_VRDMES5", 	"N", 	 839, 	16, 4, .T.  } ) //	Deprecia Mes Moeda 5
aAdd( _aDadItens, { "N3_VRDACM5", 	"N", 	 855, 	16, 4, .T.  } ) //	Deprecia Acumulada Moeda5
aAdd( _aDadItens, { "N3_INDICE1", 	"N", 	 871, 	 8, 4, .T.  } ) //	Indice de Deprecia��o 1
aAdd( _aDadItens, { "N3_INDICE2", 	"N", 	 879, 	 8, 4, .T.  } ) //	Indice de Deprecia��o 2
aAdd( _aDadItens, { "N3_INDICE3", 	"N", 	 887, 	 8, 4, .T.  } ) //	Indice de Deprecia��o 3
aAdd( _aDadItens, { "N3_INDICE4", 	"N", 	 895, 	 8, 4, .T.  } ) //	Indice de Deprecia��o 4
aAdd( _aDadItens, { "N3_INDICE5", 	"N", 	 903, 	 8, 4, .T.  } ) //	Indice de Deprecia��o 5
aAdd( _aDadItens, { "N3_DTBAIXA", 	"D", 	 911, 	 8, 0, .T.  } ) //	Data da Baixa do Bem
aAdd( _aDadItens, { "N3_VRCDM1" , 	"N", 	 919, 	14, 2, .T.  } ) //	Corr. Depr. no Mes
aAdd( _aDadItens, { "N3_VRCDB1" , 	"N", 	 933, 	14, 2, .T.  } ) //	Corr Depr Acum no Exerc.
aAdd( _aDadItens, { "N3_VRCDA1" , 	"N", 	 947, 	14, 2, .T.  } ) //	Corr Depr Acumulada
aAdd( _aDadItens, { "N3_AQUISIC", 	"D", 	 961, 	 8, 0, .T.  } ) //	Data Aquisicao Original
aAdd( _aDadItens, { "N3_DEPREC" , 	"C", 	 969, 	40, 0, .T.  } ) //	Taxa Variavel de Deprec.
aAdd( _aDadItens, { "N3_OK"     ,	"C", 	1009, 	 2, 0, .T.  } ) //	Flag Marcacao da Baixa
aAdd( _aDadItens, { "N3_SEQ"    ,	"C", 	1011, 	 3, 0, .T.  } ) //	Sequencia de aquisicao
aAdd( _aDadItens, { "N3_FIMDEPR", 	"D", 	1014, 	 8, 0, .T.  } ) //	Data fim da depreciacao
aAdd( _aDadItens, { "N3_CCDESP" , 	"C", 	1022, 	 9, 0, .T.  } ) //	Centro Custo Desp Depr.
aAdd( _aDadItens, { "N3_CCCDEP" , 	"C", 	1031, 	 9, 0, .T.  } ) //	Centro Custo Dep. Acumul.
aAdd( _aDadItens, { "N3_CCCDES" , 	"C", 	1040, 	 9, 0, .T.  } ) //	Centro Custo Corr. Depr.
aAdd( _aDadItens, { "N3_CCCORR" , 	"C", 	1049, 	 9, 0, .T.  } ) //	Centro Custo Corr. Monet.
aAdd( _aDadItens, { "N3_SUBCTA" , 	"C", 	1058, 	 9, 0, .T.  } ) //	Item Despesa
aAdd( _aDadItens, { "N3_SUBCCON", 	"C", 	1067, 	 9, 0, .T.  } ) //	Item Conta do Bem
aAdd( _aDadItens, { "N3_SUBCDEP", 	"C", 	1076, 	 9, 0, .T.  } ) //	Item Despesa Depreciacao
aAdd( _aDadItens, { "N3_SUBCCDE", 	"C", 	1085, 	 9, 0, .T.  } ) //	Item Correcao Depreciacao
aAdd( _aDadItens, { "N3_SUBCDES", 	"C", 	1094, 	 9, 0, .T.  } ) //	Item Cor.Des. Depreciacao
aAdd( _aDadItens, { "N3_SUBCCOR", 	"C", 	1103, 	 9, 0, .T.  } ) //	Item Correcao Monetaria
aAdd( _aDadItens, { "N3_BXICMS" , 	"N", 	1112, 	18, 2, .T.  } ) //	Valor do ICMS Baixado
aAdd( _aDadItens, { "N3_SEQREAV", 	"C", 	1130, 	 2, 0, .T.  } ) //	Sequencia de Reavaliacao
aAdd( _aDadItens, { "N3_AMPLIA1", 	"N", 	1132, 	14, 2, .T.  } ) //	Vl da Ampliacao na moeda1
aAdd( _aDadItens, { "N3_AMPLIA2", 	"N", 	1146, 	14, 4, .T.  } ) //	Vl da Ampliacao na moeda2
aAdd( _aDadItens, { "N3_AMPLIA3", 	"N", 	1160, 	14, 4, .T.  } ) //	Vl da Ampliacao na Moeda3
aAdd( _aDadItens, { "N3_AMPLIA4", 	"N", 	1174, 	14, 4, .T.  } ) //	Vl da Ampliacao na Moeda4
aAdd( _aDadItens, { "N3_AMPLIA5", 	"N", 	1188, 	14, 4, .T.  } ) //	Vl da Ampliacao na Moeda5
aAdd( _aDadItens, { "N3_CODBAIX", 	"C", 	1202, 	 6, 0, .T.  } ) //	Cod lig Aquis por Transf
aAdd( _aDadItens, { "N3_FILORIG", 	"C", 	1208, 	 2, 0, .T.  } ) //	Filial Origem
aAdd( _aDadItens, { "N3_CLVL"   , 	"C", 	1210, 	 9, 0, .T.  } ) //	Classe de Valor Despesa
aAdd( _aDadItens, { "N3_CLVLCON", 	"C", 	1219, 	 9, 0, .T.  } ) //	Classe de Valor do Bem
aAdd( _aDadItens, { "N3_CLVLDEP", 	"C", 	1228, 	 9, 0, .T.  } ) //	Classe Vlr Despesa Dep.
aAdd( _aDadItens, { "N3_CLVLCDE", 	"C", 	1237, 	 9, 0, .T.  } ) //	Classe de Vlr Dep. Acum.
aAdd( _aDadItens, { "N3_CLVLDES", 	"C", 	1246,    9, 0, .T.  } ) //	Classe de Vlr Cor. Depr.
aAdd( _aDadItens, { "N3_CLVLCOR", 	"C", 	1255, 	 9, 0, .T.  } ) //	Classe de Vlr Correc Bem
aAdd( _aDadItens, { "N3_TPDEPR" , 	"C", 	1264, 	 1, 0, .T.  } ) //	Tipo de depreciacao
aAdd( _aDadItens, { "N3_IDBAIXA", 	"C", 	1265, 	 1, 0, .T.  } ) //	Identificac�o da Baixa
aAdd( _aDadItens, { "N3_LOCAL"  , 	"C", 	1266, 	 6, 0, .T.  } ) //	Endereco
// Total 1272

_nNumCposCab  := LEN(_aDadCab)
_nNumCposItem := LEN(_aDadItens)

AutoGrLog("-------------------------------------")
AutoGrLog("INICIANDO O LOG - IMPORTACAO DE BENS")
AutoGrLog("-------------------------------------")
AutoGrLog("ARQUIVO............: "+_cArquivo)
AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
AutoGrLog("DATA...............: "+Dtoc(MsDate()))
AutoGrLog("HORA...............: "+Time())
AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath", ""))
AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath", ""))
AutoGrLog("VERS�O.............: "+GetVersao())
AutoGrLog("M�DULO.............: "+"SIGA"+cModulo)
AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
AutoGrLog("USU�RIO............: "+SubStr(cUsuario, 7, 15))
AutoGrLog("-------------------------------------")
AutoGrLog(" ")

_nHdl := FOpen(_cArquivo, 0) //     FT_FUSE(_cArquivo)

If _nHdl < 0
	ApMsgStop('Problemas na abertura do arquivo de importa��o', 'ATEN��O' )
	return NIL
EndIf

fSeek( _nHdl, 0, 0) //FT_FGOTOP()
//ProcRegua(FT_FLASTREC())

_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //FT_FREADLN()

While _nBtLidos >= _nTamLin //!FT_FEOF()
	_nCt++
	
	IncProc("Processando ...")
	
	_aVetCab := {}
	
	For i:=1 to _nNumCposCab
		
		If _aDadCab[i][6]
			_xDado := SUBS(_cBuffer, _aDadCab[i][3], _aDadCab[i][4])
			
			If     _aDadCab[i][2] == "C"
				
				_xDado := ALLTRIM(_xDado)
				
			ElseIf _aDadCab[i][2] == "N"
				
				_xDado := VAL(_xDado) / (10 ^_aDadCab[i][5])
				
			ElseIf _aDadCab[i][2] == "D"
				
				_xDado := CTOD(SUBS(_xDado, 7, 2)+"/"+SUBS(_xDado, 5, 2)+"/"+SUBS(_xDado, 3, 2))
				
			EndIf
			
			aAdd(_aVetCab, {_aDadCab[i][1], _xDado, NIL} )
			
		EndIf
		
	Next
	
	_cBemAnt := SUBS(_cBuffer, 1, 16)
	
	//	While !FT_FEOF() .and. _cBemAnt == SUBS(_cBuffer, 1, 16)
	
	_aVetCpos := {}
	_aVetItens:= {}
	_aVetHpos := {}
	
	For i:=1 to _nNumCposItem
		
		
		If _aDadItens[i][6]
			_xDado := SUBS(_cBuffer, _aDadItens[i][3], _aDadItens[i][4])
			
			If     _aDadItens[i][2] == "C"
				
				_xDado := ALLTRIM(_xDado)
				
			ElseIf _aDadItens[i][2] == "N"
				
				_xDado := VAL(_xDado) / (10 ^_aDadItens[i][5])
				
			ElseIf _aDadItens[i][2] == "D"
				
				_xDado := CTOD(SUBS(_xDado, 7, 2)+"/"+SUBS(_xDado, 5, 2)+"/"+SUBS(_xDado, 3, 2))

//				_xDado := CTOD(SUBS(_xDado, 1, 2)+"/"+SUBS(_xDado, 3, 2)+"/"+SUBS(_xDado, 7, 2))
				
			EndIf
			
			aAdd(_aVetCpos, {_aDadItens[i][1], _xDado, NIL} )
			
		EndIf
		
	Next
	
	aAdd(_aVetItens, _aVetCpos)
	
	// Setar o dbOrder do SX3 porque ha um erro na funcao ATFX3 do ATFXFUN
	// que deposiciona o order
	SX3->( dbSetOrder( 1 ) )
	
	lMsErroAuto := .F.
	MSExecAuto({|x, y, z| AtfA010(x, y, z)}, _aVetCab, _aVetItens, 3)
	
	If lMsErroAuto
		AutoGrLog(Str(_nCt, 5)+" "+SUBS(_cBuffer, 1, 50 )+" Nao gerado ")
		AutoGrLog(REPLICATE("=", 50))
		DisarmTransaction()
	Endif
	
	//	FT_FSKIP()
	
	_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //  _cBuffer := FT_FREADLN()
	
EndDo

_cFileLog := "ATF.LOG" //NomeAutoLog()

If _cFileLog <> ""
	MostraErro(_cPath, _cFileLog)
Endif

FClose(_nHdl) //FT_FUSE()

MsgInfo("Processo Finalizado")
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � SELARQ   �Autor  �Ernani Forastieri   � Data �  10/10/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina auxiliar para selecao do arquivo texto              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SelArq()
Private _cExtens   := "Arquivo Texto (*.TXT) |*.TXT|"
_cRet := cGetFile(_cExtens, "Selecione o Arquivo", , , .T., GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)
_cRet := ALLTRIM(_cRet)
Return _cRet

/////////////////////////////////////////////////////////////////////////////