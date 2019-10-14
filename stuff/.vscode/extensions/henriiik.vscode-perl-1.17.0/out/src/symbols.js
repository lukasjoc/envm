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
const path = require("path");
const ctags_1 = require("./ctags");
const filters = require("./vs/base/common/filters");
const sorting_1 = require("./sorting");
class PerlSymbolProvider {
    constructor(tags) {
        this.tags = tags;
    }
    getMaxSymbolResults() {
        let config = vscode.workspace.getConfiguration("perl");
        return config.get("maxSymbolResults", 500);
    }
    provideDocumentSymbols(document, token) {
        return __awaiter(this, void 0, void 0, function* () {
            let result = yield this.tags.generateFileTags(document);
            if (result instanceof Error) {
                console.error("error", result);
                throw result;
            }
            let lines = result.data.split("\n");
            let symbols = [];
            for (let i = 0; i < lines.length; i++) {
                let match = lines[i].split("\t");
                if (match.length === 4) {
                    let name = match[0];
                    let kind = ctags_1.SYMBOL_KINDS[match[3].replace(/[^\w]/g, "")];
                    if (typeof kind === "undefined") {
                        console.error("Unknown symbol kind:", match[3]);
                        kind = vscode.SymbolKind.Variable;
                    }
                    let lineNo = parseInt(match[2].replace(/[^\d]/g, "")) - 1;
                    let range = document.lineAt(lineNo).range;
                    let info = new vscode.SymbolInformation(name, kind, range);
                    symbols.push(info);
                }
            }
            return symbols;
        });
    }
    provideWorkspaceSymbols(query, token) {
        return __awaiter(this, void 0, void 0, function* () {
            if (query.length < 2) {
                return [];
            }
            var validSymbols = [];
            let regxQuery = new RegExp(query.split("").join(".*?"), "gi");
            let projectTags = yield this.tags.readProjectTags();
            for (const tags of projectTags) {
                if (tags instanceof Error) {
                    vscode.window.showErrorMessage(`An error occured while reading tags: '${tags}'`);
                    continue;
                }
                let lines = tags.data.split("\n");
                let last = lines.length - 1;
                let match;
                for (let i = 0; i <= last; i++) {
                    match = lines[i].split("\t");
                    if (match.length === 4 && match[0] !== "") {
                        let name = match[0];
                        let kind = ctags_1.SYMBOL_KINDS[match[3].replace(/[^\w]/g, "")];
                        if (typeof kind === "undefined") {
                            console.error("Unknown symbol kind:", match[3]);
                            kind = vscode.SymbolKind.Variable;
                        }
                        if (regxQuery.test(name)) {
                            let lineNo = parseInt(match[2].replace(/[^\d]/g, "")) - 1;
                            let range = new vscode.Range(lineNo, 0, lineNo, 0);
                            let file = match[1].replace(/^\.\\/, "");
                            let filePath = path.join(vscode.workspace.rootPath || "", file);
                            let uri = vscode.Uri.file(filePath);
                            let info = new vscode.SymbolInformation(name, kind, range, uri);
                            validSymbols.push(info);
                        }
                    }
                }
            }
            let fuzzyMatches = validSymbols.map(symbol => {
                let entry = new sorting_1.SymbolEntry(symbol);
                let highlights = filters.matchesFuzzy(query, entry.getLabel()) || [];
                entry.setHighlights(highlights);
                return entry;
            });
            fuzzyMatches.sort((a, b) => sorting_1.SymbolEntry.compare(a, b, query));
            const maxResults = this.getMaxSymbolResults();
            let symbols = [];
            fuzzyMatches.forEach(entry => {
                if (symbols.length < maxResults) {
                    symbols.push(entry.getSymbol());
                }
                else {
                    return;
                }
            });
            return symbols;
        });
    }
}
exports.PerlSymbolProvider = PerlSymbolProvider;
//# sourceMappingURL=symbols.js.map