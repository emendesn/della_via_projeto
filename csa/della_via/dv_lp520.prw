/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DV_CC631  �Autor  �Microsiga           � Data �  04/14/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Lan�amento 520 sequencia 001                                ���
�������������������������������������������������������������������������͹��
���Uso       �ESPECIFICO DELLA VIA                                        ���
�������������������������������������������������������������������������ͼ��
�� LAN�AMENTO 520-001 DA DELLA VIA - CONTAS A RECEBER                      ��   
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DV_LP520()
local cReturn := 0   
IF(!(SE5->E5_MOTBX $ 'FAT#DAC#DEV#LIQ').AND.!(SE5->E5_TIPODOC$"BA#BL#RA") .AND. (SE5->E5_BANCO <> "EXC"))                                
   If empty(SE5->E5_LA)
     cReturn := SE5->E5_VALOR
     DbSelectArea("SE5")
     Reclock("SE5",.F.)
     SE5->E5_LA := "S"
     Msunlock()
   Endif
Endif   
