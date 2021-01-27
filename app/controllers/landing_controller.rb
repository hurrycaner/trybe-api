class LandingController < ApplicationController
  def landing
    render html: 'Bem vindo a TRYBE-API! Acesse <a href="https://github.com/jramiresbrito/trybe-api">aqui</a> para visualizar a documentação'.html_safe
  end
end
