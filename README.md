# Paradigmas de Programação - Trabalho Individual

| Aluno | Matrícula |
|-|-|
| Henrique Martins | 17/0050394 |

## Descrição do porte

Esse trabalho é um porte do [basename](https://github.com/wertarbyte/coreutils/blob/master/src/basename.c), originalmente escrito em <b>C</b>.
O porte foi produzido na linguagem <b>Prolog</b>, com o objetivo de implementar as mesmas funcionalidades em um paradigma diferente (o paradigma do Prolog é o <b>paradigma lógico</b>).
Para testar se o porte foi feito adequadamente, foi utilizado um código escrito em <b>C++</b> que roda as duas implementações e compara os resultados.

## Como executar

Talvez seja necessário dar permissão ao arquivo. Para fazer isso, use o comando

```
chmod +x mybasename.pl
```

Para executar, digite o comando

```
./mybasename.pl NAME [SUFIXO]
```

ou

```
./mybasename.pl OPÇÃO... NOME...
```

Para mais informações, digite:

```
./mybasename.pl --help
```

## Exemplos de execução

```
./mybasename.pl inc/stdio.h
stdio.h
```

```
./mybasename.pl src/main.cpp pp
main.c
```

```
./mybasename.pl -s .py project/main.py
main
```

```
./mybasename.pl -a dir/file1 dir/file2
file1
file2
```

```
./mybasename.pl --suffix=.h stdio.h string.h
stdio
string
```

```
./mybasename.pl -s pp --multiple src/main.cpp src/utils.cpp src/constants.cpp
main.c
utils.c
constants.c
```

## Como rodar os testes

Para rodar os testes, use os seguintes comandos:

```
g++ main.cpp -o main
./main
```
