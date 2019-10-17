///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxMark.prw      | AUTOR | Rodrigo Artur  | DATA | 07/11/2005 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxMar()                                         |//
//|           |                |//
//|           |    |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#include "Protheus.Ch"

User Function ListBoxMar()
Local aSalvAmb := {}
Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Notas Fiscais Excluidas"
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "LBOK" )
Local oNo      := LoadBitmap( GetResources(), "LBNO" )
Local oChk     := Nil

Private lChk     := .F.
Private oLbx := Nil
Private aVetor := {}

dbSelectArea("SA6")
aSalvAmb := GetArea()
dbSetOrder(1)
dbSeek(xFilial("SA6"))

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
While !Eof() .And. A6_FILIAL == xFilial("SA6")	
   aAdd( aVetor, { lMark, A6_COD, A6_AGENCIA, A6_NUMCON, A6_NOME, A6_NREDUZ, A6_BAIRRO, A6_MUN })
	dbSkip()
End

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao existe bancos a consultar", {"Ok"} )
   Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
   
@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
   " ", "Banco", "Agencia", "C/C", "Nome Banco", "Fantasia", "Bairro", "Municipio" ;
   SIZE 230,095 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
                       aVetor[oLbx:nAt,2],;
                       aVetor[oLbx:nAt,3],;
                       aVetor[oLbx:nAt,4],;
                       aVetor[oLbx:nAt,5],;
                       aVetor[oLbx:nAt,6],;
                       aVetor[oLbx:nAt,7],;
                       aVetor[oLbx:nAt,8]}}
	 
@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg;
          ON CLICK(Iif(lChk,Marca(lChk),Marca(lChk)))

DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER
RestArea( aSalvAmb )

Return .T.

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxMark.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxMar()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que marca ou desmarca todos os objetos                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function Marca(lMarca)
Local i := 0
For i := 1 To Len(aVetor)
   aVetor[i][1] := lMarca
Next i
oLbx:Refresh()
Return