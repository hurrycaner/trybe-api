class LandingController < ApplicationController
  def landing
    render html: 'Bem vindo a TRYBE-API! Acesse <a href="https://trybe-api.herokuapp.com">aqui</a> para visualizar a documentação'.html_safe
  end
end
