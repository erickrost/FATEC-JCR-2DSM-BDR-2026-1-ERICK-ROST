Table cliente {
  id integer [primary key]
  nome varchar
  cpf char (11) [unique]
  telefone varchar
}

Table carro {
  placa varchar (7) [primary key]
  modelo varchar
  montadora varchar
  ano_fabricacao integer
}

Table aluguel {
  id integer [primary key]
  cliente_id integer [ref: > cliente.id]
  carro_placa varchar [ref: > carro.placa]
  data_inicio timestamp [not null]
  data_fim timestamp
}