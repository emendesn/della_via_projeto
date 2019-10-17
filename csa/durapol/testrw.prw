Baixa De
Baixa Ate // pegar pelo e1_baixa
Vendedor De
Vendedor Ate // pelo e1_cliente posicionar o a1 e filtrar o vendedor pelo cadastro do cliente e nao pelo que esta no titulo

Dt.Baixa (e1_baixa) 
Titulo 
Prefixo 
Dt.Emissao (e1_emissao)
Cliente (e1_cliente)
Vend.do Cadastro (a1_vend ??)
Vend.do Titulo (e1_vend ??)
Valor Titulo  (valor do e1_valliq)
Base Comissao (valor do SE3)
%Comissao Venda (buscar do se3)
%Comissao Cadastro (buscar do SA3)
Valor Comissao (buscar do SE3)
Confere (Imprimir o texto OK caso o registro nao tenha nenhuma inconsistencia)

Se o vendedor do cadastro bater com o vendedor do titulo    e ;
Se o valor do titulo bater com o valor base comissao do se3 e ;
Se o %comissao do se3 bater com o %comissao do cadastro vendedor
Imprimir o Texto OK na coluna "Confere"

