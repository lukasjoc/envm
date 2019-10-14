"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const ctags_1 = require("./ctags");
const perl = require("./perl");
const definitions_1 = require("./definitions");
const symbols_1 = require("./symbols");
const completions_1 = require("./completions");
const format_1 = require("./format");
function activate(context) {
    let tags = new ctags_1.Ctags();
    tags
        .checkVersion()
        .then(() => {
        vscode.languages.setLanguageConfiguration(perl.MODE.language, perl.CONFIG);
        let definitionProvider = new definitions_1.PerlDefinitionProvider(tags);
        context.subscriptions.push(vscode.languages.registerDefinitionProvider(perl.MODE, definitionProvider));
        context.subscriptions.push(vscode.languages.registerHoverProvider(perl.MODE, definitionProvider));
        context.subscriptions.push(vscode.languages.registerSignatureHelpProvider(perl.MODE, definitionProvider, "(", ","));
        let completionProvider = new completions_1.PerlCompletionProvider(tags);
        context.subscriptions.push(vscode.languages.registerCompletionItemProvider(perl.MODE, completionProvider));
        let symbolProvider = new symbols_1.PerlSymbolProvider(tags);
        context.subscriptions.push(vscode.languages.registerDocumentSymbolProvider(perl.MODE, symbolProvider));
        context.subscriptions.push(vscode.languages.registerWorkspaceSymbolProvider(symbolProvider));
        vscode.workspace.onDidSaveTextDocument(document => {
            if (document.languageId === "perl") {
                tags.generateProjectTagsFile();
            }
        });
        tags.generateProjectTagsFile();
    })
        .catch(error => {
        vscode.window.showInformationMessage("Could no find a compatible version of Exuberant Ctags.");
    });
    vscode.commands.registerCommand("perl.generateTags", () => {
        if (vscode.workspace.rootPath === undefined) {
            vscode.window.showInformationMessage("Can only generate tags when a workspace is open.");
        }
        else {
            tags.generateProjectTagsFile();
        }
    });
    let formatProvider = new format_1.PerlFormattingProvider();
    context.subscriptions.push(vscode.languages.registerDocumentRangeFormattingEditProvider(perl.MODE, formatProvider));
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map