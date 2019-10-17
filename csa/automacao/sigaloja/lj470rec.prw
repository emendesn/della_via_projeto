/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LJ470REC �Autor  �Marcelo Alcantara   � Data �  07/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Ponde de entrada para alterar os dados do arquivo de nota   ���
���          �recebido para quando o local for = 15 receber como local 01 ���
�������������������������������������������������������������������������͹��
���Parametros� Estrutura do Array - aFieldsSF2:                           ���
���          � aFieldsSF2[X][1]- Nome do campo                            ���
���          � aFieldsSF2[X][2]- Tamanho do campo                         ���
���          � aFieldsSF2[X][3]- Tipo do campo                            ���
���          � aFieldsSF2[X][4]- conteudo do campo                        ���
���                                                                       ���
���          �Estrutura do Array - aFieldsSD2                             ���
���          �aFieldsSD2[X][1]- Nome do campo                             ���
���          �aFieldsSD2[X][2]- Tamanho do campo                          ���
���          �aFieldsSD2[X][3]- Tipo do campo                             ���
���                                                                       ���
���          �Estrutura do Array - aDadosSD2                              ���
���          �aDadosSD2[Item][X]- X - Indice dos                          ���
���          �campos com seus conteudo.                                   ���
�������������������������������������������������������������������������͹��
���Retorno   � aFieldsSF2 - SF2                                           ���
���          � aFieldsSD2 - SD2                                           ���
���          � aDadosSD2  - DADOS SD2                                     ���
�������������������������������������������������������������������������͹��
���Aplicacao �Ponto de entrada execultada apos a leitura do arquivo de NF ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                           	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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


