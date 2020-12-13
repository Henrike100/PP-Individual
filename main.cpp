#include <stdio.h>
#include <string>

using namespace std;

string testes[] = {
    // Apenas nome do arquivo
    "teste.cpp",
    "main.py",
    "stdio.h",
    // Um diretório
    "src/main.c",
    "dir/file",
    "inc/constants.h",
    // Dois diretórios
    "codigos/exemplos/hello-world.c",
    "dir1/dir2/exemplo",
    "a/b/um_nome_bem_grande_pode_ser_colocado_aqui_ja_que_nao_foi_definido_tamanho",
    // Apenas nome do arquivo com sufixo no final
    "teste.cpp pp",
    "main.py .py",
    "stdio.h .h",
    // Um diretório com sufixo no final
    "src/main.c .c",
    "dir/file ile",
    "inc/constants.h .hpp",
    // Dois diretórios com sufixo no final
    "codigos/exemplos/hello-world.c .c",
    "dir1/dir2/exemplo lo",
    "a/b/um_nome_bem_grande_pode_ser_colocado_aqui_ja_que_nao_foi_definido_tamanho _ja_que_nao_foi_definido_tamanho",
    // Flag -z
    "-z testando",
    "-z _a_falta_de_",
    "-z dir/barra_n",
    // flag --zero
    "--zero __esse_comando",
    "--zero __faz_a_mesma_coisa",
    "--zero literalmente_a_mesma_coisa/_que_a_flag_-z",
    // flag -s
    "-s 123 abc123",
    "-s _de_arquivo diretorio/exemplo_de_arquivo",
    "-s sufixo_diferente nada_foi_removido",
    // flag --suffix=SUFIXO
    "--suffix=suffix foi_removido_suffix",
    "--suffix=um_suffix_bem_maior_que_o_nome_do_arquivo abc",
    "--suffix=.cpp src/main.cpp",
    // flag -a
    "-a multiplos nomes sao permitidos com essa flag",
    "-a para passar o sufixo agora precisa usar a flag -s antes do -a",
    "-a dir1/dir2/file1 dir1/dir2/file2",
    // flag --multiple
    "--multiple essa flag funciona da mesma forma que a flag -a",
    "--multiple exemplo1 exemplo2",
    "--multiple projeto/README.md projeto/.gitignore",
    // Duas ou mais flags juntas
    "-a -z duas flags",
    "--suffix=.py -z file.py exemplo.py main.py",
    "--zero --multiple -s .h a.h b.h c.h d.h e.h",
    // Outras flags
    "--help",
    "--version",
};

int main() {
    for(const auto& t : testes) {
        const string basename = "basename " + t + " >> basename.txt";
        const string mybasename = "./mybasename.pl " + t + " >> mybasename.txt";

        system(basename.c_str());
        system(mybasename.c_str());
    }

    system("diff basename.txt mybasename.txt");

    return 0;
}