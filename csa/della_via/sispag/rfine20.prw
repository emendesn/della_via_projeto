#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function rfine20()      

SetPrvt("_valtot")

_VALTOT := STRZERO((SE2->E2_SALDO - SE2->E2_E_MUL - SE2->E2_E_JUR)*100,14)

Return(_valtot)      
