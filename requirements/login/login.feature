Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter logado
Para que eu possa ver e responder enquetes de forma rápida.

Cenário: Credenciais Válidas
Given que o cliente informou credenciais Válidas
When solicitar para fazer Login
Then o sistema deve enviar o usuario para tela de pesquisas
E manter o usuário conectado

Cenário: Credenciais Invalidas
Given que o  cliente informou credenciais inválidas
When solicitar para fazer login 
Then o sistema deve retornar uma mensagem de erro
