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
const ctags_1 = require("./ctags");
const perl = require("./perl");
const utils = require("./utils");
function addCompletions(items, words, completions, kind, detail) {
    for (let i = 0; i < completions.length; i++) {
        let word = completions[i];
        delete words[word];
        let item = new vscode.CompletionItem(word, kind);
        item.detail = detail;
        items.push(item);
    }
}
function addLanguageCompletions(items, words) {
    addCompletions(items, words, perl.KEYWORDS, vscode.CompletionItemKind.Keyword, "perl keyword");
    addCompletions(items, words, perl.FUNCTIONS, vscode.CompletionItemKind.Function, "perl function");
    addCompletions(items, words, perl.VARIABLES, vscode.CompletionItemKind.Variable, "perl variable");
}
class PerlCompletionProvider {
    constructor(tags) {
        this.tags = tags;
    }
    provideCompletionItems(document, position, token) {
        return __awaiter(this, void 0, void 0, function* () {
            let text = document.getText();
            let words = {};
            let word;
            while ((word = perl.CONFIG.wordPattern.exec(text))) {
                words[word[0]] = true;
            }
            let currentWordRange = document.getWordRangeAtPosition(position);
            let currentWord = document.getText(currentWordRange);
            delete words[currentWord];
            let items = [];
            addLanguageCompletions(items, words);
            const useData = yield this.tags.generateFileUseTags(document);
            const dataz = yield this.tags.projectOrFileTags(document);
            if (useData instanceof Error) {
                return [];
            }
            let usedPackages = [];
            let currentPackage = "";
            let useLines = useData.split("\n");
            for (let i = 0; i < useLines.length; i++) {
                let match = useLines[i].split("\t");
                if (match.length === 4) {
                    let kind = match[3].replace(/[^\w]/g, "");
                    if (kind === "u") {
                        usedPackages.push(match[0]);
                    }
                    else if (kind === "p") {
                        usedPackages.push(match[0]);
                        currentPackage = match[0];
                    }
                }
            }
            let methodFiles = {};
            let filePackage = {};
            let fileItems = {};
            let packageItems = [];
            for (const tags of dataz) {
                if (tags instanceof Error) {
                    continue;
                }
                let lines = tags.data.split("\n");
                for (let i = 0; i < lines.length; i++) {
                    let match = lines[i].split("\t");
                    if (match.length === 4) {
                        fileItems[match[1]] = fileItems[match[1]] || [];
                        let item = new vscode.CompletionItem(match[0]);
                        item.kind = ctags_1.ITEM_KINDS[match[3].replace(/[^\w]/g, "")];
                        item.detail = match[1];
                        if (match[3].replace(/[^\w]/g, "") === "p") {
                            filePackage[match[0]] = match[1];
                            packageItems.push(item);
                        }
                        else {
                            fileItems[match[1]].push(item);
                            if (match[0] === "new") {
                                methodFiles[match[1]] = "1";
                            }
                        }
                    }
                }
            }
            let pkg = currentWordRange ? utils.getPackageBefore(document, currentWordRange) : "";
            let separator = currentWordRange
                ? document.getText(utils.getRangeBefore(currentWordRange, 2))
                : "";
            let isMethod = separator === "->";
            if (filePackage[pkg]) {
                let file = filePackage[pkg];
                if (fileItems[file]) {
                    fileItems[file].forEach(item => {
                        delete words[item.label];
                        item.insertText = item.label;
                        item.label = `${pkg}::${item.label}`;
                        items.push(item);
                    });
                }
            }
            else if (isMethod) {
                let keys = Object.keys(methodFiles);
                for (let i = 0; i < keys.length; i++) {
                    fileItems[keys[i]].forEach(item => {
                        delete words[item.label];
                        items.push(item);
                    });
                }
            }
            else {
                packageItems.forEach(item => {
                    delete words[item.label];
                    items.push(item);
                });
                usedPackages.forEach(usedPkg => {
                    let file = filePackage[usedPkg];
                    if (fileItems[file]) {
                        fileItems[file].forEach(item => {
                            delete words[item.label];
                            if (item.label.startsWith("_") && usedPkg === currentPackage) {
                                item.insertText = item.label;
                            }
                            item.label = `${usedPkg}::${item.label}`;
                            items.push(item);
                        });
                    }
                });
            }
            let keys = Object.keys(words);
            for (let i = 0; i < keys.length; i++) {
                let item = new vscode.CompletionItem(keys[i]);
                item.kind = vscode.CompletionItemKind.Text;
                items.push(item);
            }
            return items;
        });
    }
}
exports.PerlCompletionProvider = PerlCompletionProvider;
//# sourceMappingURL=completions.js.map