#!/usr/bin/env swipl

flag("-a").
flag("--multiple").
flag("-s").
flag("-z").
flag("--zero").

is_help_or_version(Argv) :-
    [Flag|_] = Argv,
    atom_string(Flag, FlagString),
    FlagString == "--help",
    write("Uso:  basename NOME [SUFIXO]"), nl,
    write(" ou:  basename OPÇÃO... NOME..."), nl,
    write("Mostra o NOME sem quaisquer componentes iniciais de diretório."), nl,
    write("Se especificado, remove também o SUFIXO final."), nl,
    nl,
    write("Argumentos obrigatórios para opções longas também o são para opções curtas."), nl,
    write("  -a, --multiple       provê suporte a múltiplos argumentos e trata cada um"), nl,
    write("                         como um NOME"), nl,
    write("  -s, --suffix=SUFIXO  remove um SUFIXO; implica em -a"), nl,
    write("  -z, --zero           termina as linhas de saída com NULO, e não nova linha"), nl,
    write("      --help     mostra esta ajuda e sai"), nl,
    write("      --version  informa a versão e sai"), nl,
    nl,
    write("Exemplos:"), nl,
    write("  basename /usr/bin/sort          -> \"sort\""), nl,
    write("  basename include/stdio.h .h     -> \"stdio\""), nl,
    write("  basename -s .h include/stdio.h  -> \"stdio\""), nl,
    write("  basename -a algo/txt1 algo/txt2 -> \"txt1\" seguido de \"txt2\""), nl,
    nl,
    write("Página de ajuda do GNU coreutils: <https://www.gnu.org/software/coreutils/>"), nl,
    write("Relate erros de tradução do basename: <https://translationproject.org/team/pt_BR.html>"), nl,
    write("Documentação completa em: <https://www.gnu.org/software/coreutils/basename>"), nl,
    write("ou disponível localmente via: info \"(coreutils) basename invocation\""), nl, halt(0).

is_help_or_version(Argv) :-
    [Flag|_] = Argv,
    atom_string(Flag, FlagString),
    FlagString == "--version",
    write("basename (GNU coreutils) 8.30"), nl,
    write("Copyright (C) 2018 Free Software Foundation, Inc."), nl,
    write("Licença GPLv3+: GNU GPL versão 3 ou posterior <https://gnu.org/licenses/gpl.html>"), nl,
    write("Este é um software livre: você é livre para alterá-lo e redistribuí-lo."), nl,
    write("NÃO HÁ QUALQUER GARANTIA, na máxima extensão permitida em lei."), nl,
    nl,
    write("Escrito por David MacKenzie."), nl, halt(0).

is_help_or_version(_).

get_last_element([X], Filename):-
    Filename = X.

get_last_element([_|Tail], Filename):-
    get_last_element(Tail, Filename).

get_number_of_names(Xs, L) :- get_number_of_names(Xs, 0, L).

get_number_of_names([], L, L).
get_number_of_names([_|Xs], T, L) :-
    T1 is T+1,
    get_number_of_names(Xs, T1, L).

verify_number_of_names(NumberOfArguments, _, _, _) :-
    NumberOfArguments == 0,
    write('basename: falta operando'), nl,
    write('Tente "basename --help" para mais informações.'), nl, halt(0).

verify_number_of_names(NumberOfArguments, NameList, HasFlagA, HasFlagS) :-
    HasFlagA == false,
    HasFlagS == false,
    NumberOfArguments > 2,
    write('basename: operando extra “'),
    [_|Tail1] = NameList,
    [_|Tail2] = Tail1,
    [Operand|_] = Tail2,
    write(Operand), write('”'), nl,
    write('Tente "basename --help" para mais informações.'), nl, halt(0).

verify_number_of_names(_, _, _, _).

compare_strings(Suffix, Value, String, Terminator, NewLength) :-
    Suffix == Value,
    % can remove suffix
    sub_string(String, 0, NewLength, _, Answer),
    write(Answer), write(Terminator).

compare_strings(Suffix, Value, String, Terminator, _) :-
    % suffix and value are different
    % don't remove anything
    Suffix \= Value,
    write(String), write(Terminator).

verify_newstring_length(NewLength, String, Terminator, Suffix, SuffixLength) :-
    NewLength > 0,
    % get the last SuffixLength chars from String...
    sub_string(String, _, SuffixLength, 0, Value),

    % ...and compare with suffix
    compare_strings(Suffix, Value, String, Terminator, NewLength).

verify_newstring_length(NewLength, String, Terminator, _, _) :-
    % if suffix has more characters than the string or
    % if suffix and string are equal
    NewLength =< 0,
    % print filename (no change)
    write(String), write(Terminator).

remove_suffix(String, Suffix, Terminator) :-
    string_length(Suffix, SuffixLength),
    string_length(String, StringLength),

    % length of the string after removing the suffix
    NewLength is StringLength-SuffixLength,
    verify_newstring_length(NewLength, String, Terminator, Suffix, SuffixLength).

verify_if_suffix_exists(Filename, Suffix, Terminator) :-
    Suffix \= [],
    % convert type of suffix (atom -> string)
    atom_string(Suffix, Newsuffix),
    remove_suffix(Filename, Newsuffix, Terminator).

verify_if_suffix_exists(Filename, Suffix, Terminator) :-
    % no suffix
    Suffix == [],
    write(Filename), write(Terminator).

answer(Argv, Suffix, Terminator, HasFlagA, _) :-
    Argv \= [],
    HasFlagA == true,
    answer(Argv, Suffix, Terminator, _, _),
    [_|Next] = Argv,
    answer(Next, Suffix, Terminator, HasFlagA, _).

answer(Argv, Suffix, Terminator, _, HasFlagS) :-
    Argv \= [],
    HasFlagS == true,
    answer(Argv, Suffix, Terminator, _, _),
    [_|Next] = Argv,
    answer(Next, Suffix, Terminator, _, HasFlagS).

answer(Argv, _, _, _, _) :-
    Argv == [], halt(0).

answer(Argv, Suffix, Terminator, _, _) :-
    Argv \= [],
    [Filepath|_] = Argv,
    split_string(Filepath, "/", "/", StringList),
    get_last_element(StringList, Filename),
    verify_if_suffix_exists(Filename, Suffix, Terminator).

invalid_flag(Flag) :-
    sub_string(Flag, 1, 1, _, SecondCharacter),
    SecondCharacter == "-",
    write('basename: opção não reconhecida “'), write(Flag), write('”'), nl,
    write('Tente "basename --help" para mais informações.'), nl, halt(0).

invalid_flag(Flag) :-
    sub_string(Flag, 1, 1, _, SecondCharacter),
    write('basename: opção inválida -- “'), write(SecondCharacter), write('”'), nl,
    write('Tente "basename --help" para mais informações.'), nl, halt(0).

is_valid_flag(Flag) :-
    atom_string(Flag, FlagString),
    flag(FlagString).

is_valid_flag(Flag) :-
    sub_string(Flag, Before, _, _, "="),
    sub_string(Flag, 0, Before, _, Name),
    Name == "--suffix".

is_valid_flag(Flag) :-
    sub_string(Flag, 0, 1, _, FirstCharacter),
    FirstCharacter == "-",
    invalid_flag(Flag).

is_valid_flag(_) :- fail.

handle_flag(Flag, Terminator, _, _, _, _, Tail, NewArgv) :-
    atom_string(Flag, FlagString),
    FlagString == "-z",
    Terminator = "\0",
    NewArgv = Tail.

handle_flag(Flag, Terminator, _, _, _, _, Tail, NewArgv) :-
    atom_string(Flag, FlagString),
    FlagString == "--zero",
    Terminator = "\0",
    NewArgv = Tail.

handle_flag(Flag, _, Suffix, _, HasFlagS, _, Tail, NewArgv) :-
    atom_string(Flag, FlagString),
    FlagString == "-s",
    [Suffix|NewArgv] = Tail,
    HasFlagS = true.

handle_flag(Flag, _, Suffix, _, HasFlagS, _, Tail, NewArgv) :-
    sub_string(Flag, Before, _, After, "="), !,
    sub_string(Flag, 0, Before, _, _),
    sub_string(Flag, _, After, 0, Suffix),
    NewArgv = Tail,
    HasFlagS = true.

handle_flag(Flag, _, _, _, _, HasFlagA, Tail, NewArgv) :-
    atom_string(Flag, FlagString),
    FlagString == "-a",
    HasFlagA = true,
    NewArgv = Tail.

handle_flag(Flag, _, _, _, _, HasFlagA, Tail, NewArgv) :-
    atom_string(Flag, FlagString),
    FlagString == "--multiple",
    HasFlagA = true,
    NewArgv = Tail.

handle_flag(_,_, _, _, _, _).

set_terminator(Terminator) :-
    Terminator = "\n".

set_terminator(_).

set_suffix(Argv, Suffix, HasFlagA) :-
    HasFlagA == false,
    get_last_element(Argv, Suffix).

set_suffix(_, Suffix, HasFlagA) :-
    HasFlagA == true,
    Suffix = [].

set_suffix(_, _, _).

set_flag_multiple(Flag) :-
    Flag = false.

set_flag_multiple(_).

verify_flags(Argv, Terminator, Suffix, NameList, HasFlagS, HasFlagA) :-
    [Flag|Tail] = Argv,
    is_valid_flag(Flag),
    handle_flag(Flag, Terminator, Suffix, NameList, HasFlagS, HasFlagA, Tail, NewArgv),
    verify_flags(NewArgv, Terminator, Suffix, NameList, HasFlagS, HasFlagA).

verify_flags(Argv, Terminator, Suffix, NameList, HasFlagS, HasFlagA) :-
    set_flag_multiple(HasFlagA),
    set_flag_multiple(HasFlagS),
    set_terminator(Terminator),
    set_suffix(Argv, Suffix, HasFlagA),
    NameList = Argv.

:- initialization(main, main).

main(Argv) :-
    is_help_or_version(Argv),
    verify_flags(Argv, Terminator, Suffix, NameList, HasFlagS, HasFlagA),
    get_number_of_names(NameList, Length),
    verify_number_of_names(Length, NameList, HasFlagA, HasFlagS),
    answer(NameList, Suffix, Terminator, HasFlagA, HasFlagS).
