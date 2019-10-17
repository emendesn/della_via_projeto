#Include 'rwmake.ch'
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UFINA100  ºAutor  ³Marcio Domingos     º Data ³  02/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para filtro das movimentações bancarias do caixa da   º±±
±±º          ³ Loja                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UFina100()

Local _aEstru	:= {}   
Private cCadastro := "Movimentacao Bancaria"
Private aCores	:= {  	{"E5_RECPAG='P'","BR_AZUL"},;
						{"E5_RECPAG='R'","BR_VERDE"}}           
Private _lPagar	:= .F.
						

Private aRotina   := {  { "Pesquisa"   			,"AxPesqui"  		, 0 ,1},;   // Pesquisar
						{ "Visualizar" 			,"AxVisual"			, 0 ,2},; 	// Visualizar						
						{ "Pagar"  				,"fA100Pag"			, 0 ,3},; 	// Mov. Financeira a Pagar
						{ "Receber" 			,"fA100Rec"			, 0 ,4},;  	// Mov. Financeira a Receber
						{ "Excluir"		 		,"fA100Can" 		, 0 ,5},;  	// Excluit Mov. Financeira
						{ "Estorn. Transf."		,"fA100Est"		  	, 0 ,6},;   // Estornar Transf.
						{ "Legenda" 			,"F100Legenda"  	, 0 ,7}} 	// Legenda
						

//Verifica se Transferencia ja foi feita na data base
dbSelectArea("SLJ")
dbSetOrder(1) //LJ_FILIAL+LJ_CODIGO
dbGoTop()
if dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0"))
	if SLJ->LJ_DTSANGR >= dDataBase
		Aviso("Aviso","Transferencia automatica ja efetuada nesta data!! ",{"Ok"})             
		
		aRotina   := {  { "Pesquisa"   			,"AxPesqui"  		, 0 ,1},;   // Pesquisar
						{ "Visualizar" 			,"AxVisual"			, 0 ,2},; 	// Visualizar						
						{ "Legenda" 			,"F100Legenda"  	, 0 ,7}} 	// Legenda
	Endif
else
	Aviso("Aviso","Nao foi possivel encontrar a loja no cadastro de Ident. de Loja, Transferencia nao efetuada",{"Ok"})
	Return
Endif						

DbSelectarea("SE5")            
_cCond := "SE5->E5_FILIAL = '"+xFilial("SE5")+"' .And. SE5->E5_BANCO = SLF->LF_COD"

Set Filter To &_cCond
mBrowse(,,,,"SE5",,,,,,aCores,,,1)

Return .T.
