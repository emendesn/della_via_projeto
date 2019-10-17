/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT100TOK บAutor  ณMicrosiga              บ Data ณ  10/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validacoes especificas da Della Via na Nota fiscal de Entrada บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Somente quando executado via MATA100/MATA103					 บฑฑ
ฑฑบ          ณ ParamIxb[1] -                                                 บฑฑ
ฑฑบ          ณ Um array com um elemento contendo uma variavel logica sendo   บฑฑ
ฑฑบ          ณ verdadeira se passou por todas as validacoes.                 บฑฑ
ฑฑบ          ณ Ler o conteudo de paramixb[1] para obter esta variavel logica บฑฑ
ฑฑบ          ณ no RdMake.                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Dados ok                                         บฑฑ
ฑฑบ          ณ        .F. - Dados incorretos                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Ponto de entrada executado em dois momentos:                  บฑฑ
ฑฑบ          ณ 1- Na validacao de inclusao da Nota fiscal de saida na tela   บฑฑ
ฑฑบ          ณ    de Saida de Materiais. (LOJA920)                           บฑฑ
ฑฑบ          ณ 2- Na validacao da tela de Receb. de Materiais (MATA100/      บฑฑ
ฑฑบ          ณ    MATA103)													 บฑฑ
ฑฑบ          ณ    VALIDACAO AO CONFIRMAR DIGITACAO MATA100	                 บฑฑ
ฑฑบ          ณ    Apos a digitacao dos items do MATA100 ao confirmar 	     บฑฑ
ฑฑบ          ณ    encerrando a entrada de dados, depois de fazer todas as 	 บฑฑ
ฑฑบ          ณ    verificacoes normais e antes de iniciar o processo de 	 บฑฑ
ฑฑบ          ณ    gravacao dos dados.	 								  	 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบBenedet   ณ10/06/05ณ      ณValidar a exclusao do sepu.                    บฑฑ
ฑฑบGaspar    ณ29/06/05ณ      ณValidar na execucao da rotina pelo LOJA920     บฑฑ
ฑฑบ          ณ        ณ      ณe na empresa 01 - Della Via Pneus              บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT100TOK()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializacao de variaveis.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea     := GetArea()
Local aAreaSA2  := SA2->(GetArea())
Local npCod     := aScan(aHeader, {|x| rTrim(x[2]) == "D1_COD"})
Local npLocal   := aScan(aHeader, {|x| rTrim(x[2]) == "D1_LOCAL"})
Local npLoteCtl := aScan(aHeader, {|x| rTrim(x[2]) == "D1_LOTECTL"})
Local npPedido  := aScan(aHeader, {|x| rTrim(x[2]) == "D1_PEDIDO"})
Local npTES     := aScan(aHeader, {|x| rTrim(x[2]) == "D1_TES"})
Local nTotLin := Len(aCols)
Local nTotCol := Len(aHeader) + 1
Local lRet := .T.
Local i
                     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o ponto de entrada estiver sendo executado na tela de Saida de Materiais, nao precisa fazer as validacoes abaixo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If AllTrim(Upper(FunName(0))) $ "LOJA920"
   Return(lRet)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o ponto de entrada estiver sendo executado fora da empresa 01 - Della Via Pneus, nao precisa fazer as validacoes abaixo  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If AllTrim(cEmpAnt) <> "01"
   Return(lRet)
EndIf


// Escolhe indice
PA4->(dbSetOrder(1))

For i := 1 to nTotLin

	If aCols[i][nTotCol] //linha deletada
		Loop
	EndIf
	
	// Valida somente inclusao
	If !INCLUI
		Loop
	EndIf
	
	// Busca os produtos SEPU
	If AllTrim(aCols[i][npCod]) == GetMV("FS_DEL008");
		.And. aCols[i][npLocal] == GetMV("FS_DEL013")
		
		// Verifica tipo de nota
		If cTipo <> "B"
			// Verifica se cliente/fornecedor e Della Via
			SA2->(dbSetOrder(1)) // A2_FILIAL+A2_COD+A2_LOJA
			SA2->(dbSeek(xFilial("SA2") + ca100For))
			If Left(SA2->A2_CGC, 8) <> "60957784"
				lRet := .F.
				msgAlert(OemtoAnsi("O tipo de nota para entrada de SEPU deve ser 'B' !"), "Aviso")
				Exit
			EndIf
		EndIf
		
		// Verifica tamanho do codigo SEPU
		If Len(AllTrim(aCols[i][npLoteCtl])) <> TamSX3("PA4_SEPU")[1]
			lRet := .F.
			msgAlert(OemtoAnsi("O tamanho do n๚mero SEPU estแ incorreto!"), "Aviso")
			Exit
		EndIf
		
		// Verifica se SEPU ja foi incluido
		If PA4->(dbSeek(xFilial("PA4") + AllTrim(aCols[i][npLoteCtl])))
			lRet := .F.
			msgAlert(OemtoAnsi("N๚mero de SEPU duplicado!"), "Aviso")
			Exit
		EndIf
	EndIf
	
	
Next i

RestArea(aAreaSA2)
RestArea(aArea)
Return(lRet)