/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RFINM01  � Autor � Rogerio Leite         � Data � 02/12/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Browse para chamada de Baixa Receber Automatica            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamado diretamente do Menu                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico da Conibra .                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//������������������������������������������������������������������Ŀ
//� Seleciona a area de trabalho                                     �
//��������������������������������������������������������������������
dbSelectArea("SEA")

aRotina := {{"Pesquisa"        ,"AxPesqui"  , 0, 1},;
{"Visualiza"       ,"AxVisual"  , 0, 2},;
{"Selecionar Titulos" ,'ExecBlock("RFINA12",.F.,.F.,2)'  , 0, 2} }

//����������������������������Ŀ
//� Define o cabecalho da tela �
//������������������������������
cCadastro := OemToAnsi("Baixa Automatica")

mBrowse( 6, 1,22,75,"SE1",,"!E1_SALDO")

dbSelectArea("SE1")

Return
