#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function rfine21()      

SetPrvt("_VRARRE")

_VRARRE := STRZERO((SE2->E2_SALDO-SE2->E2_E_VLENT-SE2->E2_E_MUL)*100,14)

Return(_VRARRE)      
