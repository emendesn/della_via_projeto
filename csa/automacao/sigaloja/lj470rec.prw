/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LJ470REC ºAutor  ³Marcelo Alcantara   º Data ³  07/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponde de entrada para alterar os dados do arquivo de nota   º±±
±±º          ³recebido para quando o local for = 15 receber como local 01 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Estrutura do Array - aFieldsSF2:                           º±±
±±º          ³ aFieldsSF2[X][1]- Nome do campo                            º±±
±±º          ³ aFieldsSF2[X][2]- Tamanho do campo                         º±±
±±º          ³ aFieldsSF2[X][3]- Tipo do campo                            º±±
±±º          ³ aFieldsSF2[X][4]- conteudo do campo                        º±±
±±º                                                                       º±±
±±º          ³Estrutura do Array - aFieldsSD2                             º±±
±±º          ³aFieldsSD2[X][1]- Nome do campo                             º±±
±±º          ³aFieldsSD2[X][2]- Tamanho do campo                          º±±
±±º          ³aFieldsSD2[X][3]- Tipo do campo                             º±±
±±º                                                                       º±±
±±º          ³Estrutura do Array - aDadosSD2                              º±±
±±º          ³aDadosSD2[Item][X]- X - Indice dos                          º±±
±±º          ³campos com seus conteudo.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ aFieldsSF2 - SF2                                           º±±
±±º          ³ aFieldsSD2 - SD2                                           º±±
±±º          ³ aDadosSD2  - DADOS SD2                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Ponto de entrada execultada apos a leitura do arquivo de NF º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Manutencao Efetuada                           	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LJ470REC()
Local _aFieldsSF2	:= Aclone(ParamIxb[1])
Local _aFieldsSD2	:= Aclone(ParamIxb[2])
Local _aDadosSD2	:= Aclone(ParamIxb[3])
Local i
// Se For a Matriz nao faz nada e retorna
If cFilAnt = '01'
	Return {_aFieldsSF2, _aFieldsSD2, _aDadosSD2}
EndIf

For i:= 1 to len(_aDadosSD2)
	//Se Encontrae a Posicao do Campo(FILIAL) no array 
	If (nPos := ASCAN(_aFieldsSD2,{|X| alltrim(subs(X[1],3))=='_FILIAL'})) > 0 	
		If _aDadosSD2[i][nPos] <> '01' //Se o registro vier da matriz nao mudar armazem
			Loop
		Endif
	EndIf
	
	//Se Encontrae a Posicao do Campo(LOCAL) no array 
	If (nPos := ASCAN(_aFieldsSD2,{|X| alltrim(subs(X[1],3))=='_LOCAL'})) > 0 	
		If _aDadosSD2[i][nPos] = '25' 	//Se For o Armazem 25 
			_aDadosSD2[i][nPos]:= '01'  //Mudar para armazem 01
		EndIf
    EndIf
Next

Return {_aFieldsSF2, _aFieldsSD2, _aDadosSD2}


