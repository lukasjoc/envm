'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
const sassAutocomplete_1 = require("./sassAutocomplete");
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    setSassLanguageConfiguration();
    const sassCompletion = new sassAutocomplete_1.default();
    const sassCompletionRegister = vscode.languages.registerCompletionItemProvider([
        { language: 'sass', scheme: 'file' },
        { language: 'sass', scheme: 'untitled' }
    ], sassCompletion, '\\.', '@');
    context.subscriptions.push(vscode.workspace.onDidChangeConfiguration((config) => {
        if (config.affectsConfiguration('sass')) {
            setSassLanguageConfiguration();
        }
    }));
    context.subscriptions.push(sassCompletionRegister);
}
exports.activate = activate;
function setSassLanguageConfiguration() {
    const disableAutoIndent = vscode.workspace
        .getConfiguration('sass')
        .get('disableAutoIndent');
    vscode.languages.setLanguageConfiguration('sass', {
        wordPattern: /(#?-?\d*\.\d\w*%?)|([$@#!.:]?[\w-?]+%?)|[$@#!.]/g,
        onEnterRules: [
            {
                beforeText: /^((?!^(\/n|\s+|.*: .*|.*@.*|.*,|\s+\+.*)$).*|.*@media(?!^\s+$).*)$/,
                action: {
                    indentAction: disableAutoIndent
                        ? vscode.IndentAction.None
                        : vscode.IndentAction.Indent
                }
            }
        ]
    });
}
// this method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map