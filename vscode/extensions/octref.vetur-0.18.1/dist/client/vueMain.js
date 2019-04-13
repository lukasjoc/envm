"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const generate_grammar_1 = require("./generate_grammar");
const languages_1 = require("./languages");
const client_1 = require("./client");
const path_1 = require("path");
function activate(context) {
    /**
     * Custom Block Grammar generation command
     */
    context.subscriptions.push(vscode.commands.registerCommand('vetur.generateGrammar', generate_grammar_1.generateGrammarCommandHandler(context.extensionPath)));
    context.subscriptions.push(vscode.commands.registerCommand('vetur.applyWorkspaceEdits', (args) => {
        const edit = client.protocol2CodeConverter.asWorkspaceEdit(args);
        vscode.workspace.applyEdit(edit);
    }));
    context.subscriptions.push(vscode.commands.registerCommand('vetur.chooseTypeScriptRefactoring', (args) => {
        client.sendRequest('requestCodeActionEdits', args)
            .then(command => command && vscode.commands.executeCommand(command.command, ...command.arguments));
    }));
    languages_1.registerLanguageConfigurations();
    /**
     * Vue Language Server Initialization
     */
    const serverModule = context.asAbsolutePath(path_1.join('server', 'dist', 'vueServerMain.js'));
    const client = client_1.initializeLanguageClient(serverModule);
    context.subscriptions.push(client.start());
    client
        .onReady()
        .then(() => {
        registerCustomClientNotificationHandlers(client);
    })
        .catch(e => {
        console.log('Client initialization failed');
    });
}
exports.activate = activate;
function registerCustomClientNotificationHandlers(client) {
    client.onNotification('$/displayInfo', (msg) => {
        vscode.window.showInformationMessage(msg);
    });
    client.onNotification('$/displayWarning', (msg) => {
        vscode.window.showWarningMessage(msg);
    });
    client.onNotification('$/displayError', (msg) => {
        vscode.window.showErrorMessage(msg);
    });
}
//# sourceMappingURL=vueMain.js.map