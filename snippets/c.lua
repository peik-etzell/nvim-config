---@diagnostic disable: undefined-global
return {
    s({
        dscr = 'Multiline comment',
        trig = '///',
    }, {
        t({ '/**', ' * ' }),
        i(1),
        t({ '', ' */' }),
    }),
    s({
        dscr = 'Template',
        trig = 'helloworld',
    }, {
        t({
            '#include <stdio.h>',
            '',
            'int main(int argc, char **argv) {',
            '  printf("Hello world!\\n");',
            '  return 0;',
            '}',
        }),
    }),
}
