# Compiladores  

## Descrição

Este projeto é uma implementação de compilador da linguagem criada na matéria de Compiladores da Univeridade Federal do ABC chamado isiLanguage, para conclusão do curso e foi criado utilizando as tecnologias ANTLR e Java 17.


## ❓ Como usar

### Ferramentas Necessárias

- **[Eclipse](https://eclipseide.org/)** - Necessário para abrir o projeto em java

- **[antlr-4.7.1](https://www.antlr.org/download/antlr-4.7.1-complete.jar)** -

### Clonar o Repositório

Utilizando um terminal ou algum cliente git a sua escolha, clonar o repositório do projeto:

```
gh repo clone JV-Garrido/projetoCompiladores
```

### Gerar o Código e Compilar o Projeto

Abra o Eclipse importe o projeto utilizando a opção `File -> Import -> Gradle -> Existing Gradle Project`. Busque a pasta do projeto clonado, selecione-a e clique em `Finish`.

Para gerar o Lexer e o Parser a partir da gramática (arquivo com extensão .g4)

`java -cp antlr-4.7.1-complete.jar org.antlr.v4.Tool IsiLang.g4 -package parser -o ./src/parser/`

usamos o aplicativo org.antlr.v4.Tool

-cp para apontar no CLASSPATH a bibliioteca

-o indica que você irá gravar os arquivos na pasta correspondente

-package indica que cada classe gerada terá o cabeçalho do package definido

