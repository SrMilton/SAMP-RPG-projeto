# SAMP-RPG-projeto
## Autor: https://github.com/srmilton

### Descrição
Esse código foi feito para San Andreas Multi Player com a proposta de um modo de jogo RPG utilizando MySql e AntiCheat dedicado. Devido a quantidade de bugs e hackers nos codigos diponiveis atualmente, resolvi fazer esse com a minha cara totalmente do zero e com um anti cheat proprio (ainda não finalizado).

### Como usar
Esse projeto foi descontinuado e o código esta aberto, falta muita coisa a ser feita mas o mais dificil ja foi. Basta baixar o GameMode e abrir com o seu pawn.

### Requisitos
É necessario ter as bibliotecas utilizadas no projeto (primeiras linhas do código) em sua pasta de include. Também é necessario ter os plugins MySql, PawnCMD, sscanf e streamer.

### Como funciona
Todas as engines do código são feitas separadamente de forma que de pra alterar uma (ou até mesmo remover) sem afetar nenhuma das outras engines. O servidor tem sistema de registro e login salvos em uma database via mysql e o administrador tem acesso a praticamente tudo ingame, sem precisar ter que acessar os registros do servidor de forma externa.
