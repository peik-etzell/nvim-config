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
            '#include <iostream>',
            '',
            'using namespace std;',
            '',
            'int main(int argc, char **argv) {',
            '  cout << "Hello world!" << endl;',
            '  return 0;',
            '}',
        }),
    }),
}
