#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function F240Sum()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

SetPrvt("_valor,_abat,_juros")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ F420SOMA.PRW                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para alterar o valor utilizado na funcao  ³±±
±±³          ³ SOMAVALOR() do sispag                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desenvolvi³ Renato Genesini                                            ³±±
±±³mento     ³ 23/05/2005                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Utilizado no sispag do Itau para totalizar os acrescimos   ³±±
±±³            e descontos no valor total enviado ao banco.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
_Abat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_Valor := SE2->E2_SALDO - _Abat 

//-- Variavel publica declarada no ponto de entrada f240arq()
//_nTotEnt   += SE2->E2_E_VLENT (LINHA DA FUNCTION ORIGINAL)

//_nTotAcres += SE2->E2_E_MUL 
_nTotAcres += SE2->E2_MULTA

//_nTotGps   += (SE2->E2_SALDO - SE2->E2_E_VLENT - SE2->E2_E_MUL) 
_nTotGps   += (SE2->E2_SALDO - SE2->E2_MULTA) 

//_nSubDar   += SE2->E2_E_MUL + SE2->E2_E_JUR                
_nSubDar   += SE2->E2_MULTA + SE2->E2_JUROS                


//_nTotDar   += (SE2->E2_SALDO - SE2->E2_E_MUL - SE2->E2_E_JUR)
_nTotDar   += (SE2->E2_SALDO - SE2->E2_MULTA - SE2->E2_JUROS)

Return(_Valor)        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00
