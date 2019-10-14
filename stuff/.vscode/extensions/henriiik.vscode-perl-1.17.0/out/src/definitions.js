"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const utils = require("./utils");
class PerlDefinitionProvider {
    constructor(tags) {
        this.tags = tags;
    }
    provideDefinition(document, position, token) {
        return __awaiter(this, void 0, void 0, function* () {
            let wordRange = document.getWordRangeAtPosition(position);
            if (wordRange === undefined) {
                return;
            }
            let dataz = yield this.tags.projectOrFileTags(document);
            let word = document.getText(wordRange);
            let pkg = utils.getPackageBefore(document, wordRange);
            let fileName = document.fileName;
            let matches = [];
            let pkgMatch;
            let pkgMatchFolder = "";
            for (const tags of dataz) {
                if (tags instanceof Error) {
                    continue;
                }
                const folder = tags.folder;
                let lines = tags.data.split(/\r?\n/);
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i];
                    if (line.startsWith(`${word}\t`)) {
                        matches.push({ line, folder });
                    }
                    else if (line.startsWith(`${pkg}\t`)) {
                        let split = line.split("\t");
                        if (split[3] === "p") {
                            fileName = split[1];
                        }
                    }
                    else if (line.startsWith(`${pkg}::${word}\t`)) {
                        pkgMatch = line;
                        pkgMatchFolder = tags.folder;
                    }
                }
            }
            const workspace = vscode.workspace.getWorkspaceFolder(document.uri);
            if (workspace !== undefined) {
                fileName = fileName.replace(workspace.uri.fsPath, ".");
            }
            if (pkgMatch) {
                return utils.getMatchLocation(pkgMatch, pkgMatchFolder);
            }
            for (let i = 0; i < matches.length; i++) {
                let match = matches[i];
                let split = match.line.split("\t");
                if (fileName === split[1] || i + 1 === matches.length) {
                    return utils.getMatchLocation(match.line, match.folder);
                }
            }
            return;
        });
    }
    provideHover(document, position, token) {
        return __awaiter(this, void 0, void 0, function* () {
            let location = yield this.provideDefinition(document, position, token);
            if (location === undefined) {
                return;
            }
            let workspace = vscode.workspace.getWorkspaceFolder(document.uri);
            let data = yield this.tags.readFile(location.uri.fsPath);
            if (data instanceof Error) {
                console.error(data);
                return;
            }
            let lines = data.split(/\r?\n/);
            let value = "";
            let end = Math.max(0, location.range.end.line - 5);
            let index = location.range.start.line;
            while (index > end) {
                let line = lines[index];
                if (line.match(/^\s*#/) && line !== "##") {
                    value = line.trim() + "\n" + value;
                }
                index--;
            }
            if (value === "") {
                return;
            }
            let hover = new vscode.Hover({ language: "perl", value: value });
            return hover;
        });
    }
    provideSignatureHelp(document, position, token) {
        return __awaiter(this, void 0, void 0, function* () {
            let callRange = new vscode.Range(position.line, 0, position.line, position.character);
            let callText = document.getText(callRange);
            let offset = position.character - 1;
            let externalCount = 0;
            let internalCount = 0;
            let callIndex = callText.lastIndexOf("(");
            if (callIndex < 0) {
                return;
            }
            while (offset > -1) {
                let char = callText[offset];
                switch (char) {
                    case ",":
                        externalCount++;
                        internalCount++;
                        break;
                    case "[":
                        externalCount = externalCount - internalCount;
                        internalCount = 0;
                        break;
                    case "]":
                        internalCount = 0;
                        break;
                    case "(":
                        callIndex = offset;
                        if (callText.substr(offset - 2, 2) !== "qw") {
                            offset = 0;
                        }
                        break;
                    default:
                        break;
                }
                offset--;
            }
            let callPosition = new vscode.Position(position.line, callIndex);
            let location = yield this.provideDefinition(document, callPosition, token);
            if (location === undefined) {
                return;
            }
            let data = yield this.tags.readFile(location.uri.fsPath);
            if (data instanceof Error) {
                console.error(data);
                return;
            }
            let lines = data.toString().split(/\r?\n/);
            let lastLine = Math.min(lines.length, location.range.end.line + 5);
            let i = location.range.start.line;
            let signature = "";
            while (i < lastLine) {
                let line = lines[i];
                if (line.match("@_")) {
                    signature = line;
                }
                i++;
            }
            // TODO handle fn(['asd', 'omg']) and fn({asd => 'omg'})
            let params = signature
                .substring(signature.indexOf("(") + 1, signature.indexOf(")"))
                .split(",");
            let info = new vscode.SignatureInformation(signature);
            for (let param of params) {
                info.parameters.push(new vscode.ParameterInformation(param.trim()));
            }
            let help = new vscode.SignatureHelp();
            help.activeParameter = externalCount;
            help.activeSignature = 0;
            help.signatures.push(info);
            return help;
        });
    }
}
exports.PerlDefinitionProvider = PerlDefinitionProvider;
//# sourceMappingURL=definitions.js.map