User Function DESTA06

Private cCadastro := "Programacao da Producao"
Private aRotina   := { {"Pesquisar"           ,"AxPesqui" ,0,1},;
					   {"Visualizar"          ,"AxVisual" ,0,2},;
					   {"Programacao"         ,"U_DESTA07x(3) ",0,3},;
					   {"Altera Programacao"  ,"U_DESTA07x(4) ",0,4},;
					   {"Exclui Programacao"  ,"U_DESTA07x(5) ",0,5}}
					   
dbSelectArea("SZL")
dbSetOrder(1)

mBrowse(,,,,"SZL",,,,,,)

Return Nil

