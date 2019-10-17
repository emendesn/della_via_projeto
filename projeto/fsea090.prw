#INCLUDE 'FSEA090.CH'
#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA090  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para manutencao Cad. de Excecoes Validacao e campos บฑฑ
ฑฑบ          ณ nas  Importacoes                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FSEA090()
Private cCadastro := STR0001 //'Cadastro de Exce็๕es de Valida็ใo'
Private cDelFunc  := '.T.'
Private aRotina   := {}

aAdd( aRotina, { STR0002, 'AxPesqui', 0, 1 } )  // 'Pesquisar'
aAdd( aRotina, { STR0003, 'AxVisual', 0, 2 } )  // 'Visualizar'
aAdd( aRotina, { STR0004, 'AxInclui', 0, 3 } )  // 'Incluir'
aAdd( aRotina, { STR0005, 'AxAltera', 0, 4 } )  // 'Alterar'
aAdd( aRotina, { STR0006, 'AxDeleta', 0, 5 } )  // 'Excluir'

dbSelectArea( 'UA4' )
dbSetOrder( 1 )
mBrowse( ,,,, 'UA4')

Return NIL

/////////////////////////////////////////////////////////////////////////////