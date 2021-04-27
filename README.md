# Flutter micro-frontends

Proposta de arquitetura utilizando micro-frontends e arquitetura limpa.

## Instalação

Após clonar o projeto, rodar dentro de cada micro app

```bash
flutter packages get
```

Dentro do micro app de search, rodar:

```bash
flutter pub run build_runner build
```
## Por dentro de cada micro-frontend
- ***base_app*** responsável por rodar a aplicação, único que conhece todos os micro-frontends da aplicação.
- ***micro_commons_dps*** deve manter as dependências dos micro-frontends 
- ***micro_core*** sua responsabilidade é manter aquilo que é compartilhado entre os micro-frontends como por exemplo, widgets, themes e etc.
 
Cada micro-frontends carrega arquitetura limpa em seu interior da seguinte forma:

![alt text](https://uploaddeimagens.com.br/images/003/215/152/original/clean-arch.jpg?1619543095)

- **micro_app_search** contem uma busca no GitHub
- **micro_app_about** contem uma pagina simples sobre o app
 

## Modularização, Injeção de Deps e Rotas:
[Flutter Modular](https://pub.dev/packages/flutter_modular)

## Gerência de estados:
[MobX](https://pub.dev/packages/mobx)
