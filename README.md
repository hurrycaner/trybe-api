# TRYBE-API V1

Este projeto consiste na API criada como parte do processo de contratação da [Trybe](https://www.betrybe.com/).

## Documentação
A documentação foi realizada utilizando o [Insomnia](https://insomnia.rest/download/). Para importar a documentação, com o Insomnia aberto, clique no <code> workspace atual > import/export > import data > from file > e selecione o arquivo trybe-api.json </code> presente na raiz deste projeto.

Caso a importação ocorra com sucesso, seu workspace será alterado para Trybe-BE.

A documentação está presente na aba <code>DOCS</code> de cada requisição.
Todos os cabeçalhos foram comentados com explicação do seu significado. Para visualizar os comentários ative a sua exibição. Mais detalhes na sessão <code>Variáveis de ambiente (insomnia) e Informações adicionais</code> da documentação.

## Requisitos do Projeto
Os únicos requisito para o projeto é ter [Ruby](https://www.ruby-lang.org/pt/documentation/installation/) instalado na máquina, uma vez que este projeto foi desenvolvido utilizando [Ruby on Rails](https://guides.rubyonrails.org/v5.0/getting_started.html#installing-rails) e o banco de dados [PostgreSQL](https://www.postgresql.org/download/).

## Versões dos Requisitos

* Ruby 2.6.6p146 (2020-03-31 revision 67876)
* PostgreSQL 12.4
* Rails 6.0.3.4

## Adquirindo o projeto
A maneira mais fácil e recomendada de adquir este projeto é utilizando o [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). Para isso, dentro da sua ferramenta de linha de comando, navegue para a pasta onde deseja colocar o projeto e execute: <code>git clone https://github.com/jramiresbrito/trybe-api.git</code>. Caso tenha ssh configurado, o comando é <code>git clone git@github.com:jramiresbrito/trybe-api.git</code>.

Com o projeto baixado, acesse a pasta do projeto <code>cd trybe-api</code> e instale as dependências: <code>bundle install</code>. Caso ocorra um erro, com relação a versão da dependência **Sprockets**, basta executar o comando: <code>bundle update</code> e, em seguida: <code>bundle install</code>.

O passo final antes de estar pronto para utilização é fornecer as credenciais de acesso ao banco de dados. Essas credenciais devem ser fornecidas através de **variáveis de ambiente**. As variáveis que devem ser declaradas são:

* TRYBE_API_DATABASE_USER
* TRYBE_API_DATABASE_PASSWORD

Você pode encontrar essas variáveis no arquivo </code>.env.example</code> na raiz do projeto. Para declarar as variáveis, você pode optar por renomear o arquivo <code>.env.example</code> para <code>.env</code> ou criar um novo arquivo chamado <code>.env</code> na raiz do projeto.

Uma vez preenchidas as variáveis estamos prontos para criar o banco de dados.

## Criando o banco de dados
Um script responsável pela criação dos bancos de desenvolvimento e testes está disponível e deve ser executado com o comando: <code>rails db:create</code>. Se as variáveis de ambiente foram preenchidas corretamente os bancos chamados: <code>trybe_api_development</code> e <code>trybe_api_test</code> serão criados.

## Criando as tabelas
Para criar o schema do banco, basta executar o script responsável através do comando: <code>rails db:migrate</code>.

## Rodando a Suit de testes
O projeto foi totalmente desenvolvido utilizando TDD. Para rodar a suit de testes execute: <code>bundle exec rspec</code>

## Populando o banco de desenvolvimento
Com todos os testes passando, é hora de popular o banco de desenvolvimento: <code>rails db:seed</code>.

## Subindo o servidor
Se os passos anteriores foram corretamente executados, está tudo pronto para subir o servidor. Basta executar <code>rails s</code> e aguardar alguns instantes. Com o servidor no ar, a API está disponível no endereço: <code>localhost:3000</code>. Caso você utilize a porta 3000 para outra finalidade, é possível alterar a porta ao subir o servidor: <code>rails s -p NUMERO_DA_PORTA_DESEJADA</code>

## Versão em produção
A API foi publicada e sua versão em produção está disponível no endereço: <code>http://trybe-api.herokuapp.com/</code>
