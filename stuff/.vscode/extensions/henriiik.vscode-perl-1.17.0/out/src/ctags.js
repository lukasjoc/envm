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
const cp = require("child_process");
const fs = require("fs");
const path = require("path");
const vscode = require("vscode");
const vscode_1 = require("vscode");
const DEFAULT_ARGS = ["--languages=perl", "-n", "--fields=k"];
const EXTRA = {
    use: "--regex-perl=/^[ \\t]*use[ \\t]+['\"]*([A-Za-z][A-Za-z0-9:]+)['\" \\t]*;/\\1/u,use,uses/",
    require: "--regex-perl=/^[ \\t]*require[ \\t]+['\"]*([A-Za-z][A-Za-z0-9:]+)['\" \\t]*/\\1/r,require,requires/",
    variable: "--regex-perl=/^[ \\t]*my[ \\t(]+([$@%][A-Za-z][A-Za-z0-9:]+)[ \\t)]*/\\1/v,variable/",
};
exports.ITEM_KINDS = {
    p: vscode_1.CompletionItemKind.Module,
    s: vscode_1.CompletionItemKind.Function,
    r: vscode_1.CompletionItemKind.Reference,
    v: vscode_1.CompletionItemKind.Variable,
    c: vscode_1.CompletionItemKind.Value,
};
exports.SYMBOL_KINDS = {
    p: vscode_1.SymbolKind.Package,
    s: vscode_1.SymbolKind.Function,
    l: vscode_1.SymbolKind.Constant,
    c: vscode_1.SymbolKind.Constant,
};
class Ctags {
    constructor() {
        this.versionOk = false;
        this.generatingProjectTags = false;
    }
    getConfiguration(resource) {
        return vscode.workspace.getConfiguration("perl", resource);
    }
    getTagsFileName(resource) {
        return this.getConfiguration(resource).get("ctagsFile", ".vstags");
    }
    getExecutablePath() {
        return this.getConfiguration().get("ctagsPath", "ctags");
    }
    getExtraProjectCtagsArgs() {
        return this.getConfiguration().get("extraProjectCtagsArgs", []);
    }
    checkVersion() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.versionOk) {
                return undefined;
            }
            const result = yield this.run(["--version"]);
            if (result instanceof Error) {
                return Error("Could not find a compatible version of Ctags, check extension log for more info.");
            }
            this.versionOk = true;
            return;
        });
    }
    // running ctags
    run(args, cwd) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => {
                const file = this.getExecutablePath();
                let callback = (error, stdout, stderr) => {
                    if (error) {
                        console.error(`command failed: '${file} ${args.join(" ")}'`);
                        console.error(`cwd: '${cwd}'`);
                        console.error(`error message: '${error.message}'`);
                        console.error(`stderr: '${stderr}'`);
                        resolve(error);
                    }
                    resolve(stdout);
                };
                let options = {};
                if (cwd !== undefined) {
                    options.cwd = cwd;
                }
                cp.execFile(this.getExecutablePath(), args, options, callback);
            });
        });
    }
    generateProjectTagsFile() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.generatingProjectTags) {
                return [];
            }
            this.generatingProjectTags = true;
            const folders = vscode.workspace.workspaceFolders;
            if (folders === undefined) {
                return [];
            }
            let error = yield this.checkVersion();
            if (error !== undefined) {
                return [error];
            }
            const jobs = folders.map(folder => this.generateProjectFolderTagsFile(folder));
            try {
                return yield Promise.all(jobs);
            }
            catch (e) {
                if (e instanceof Error) {
                    return [e];
                }
                console.error(e);
                return [Error("unknown error when generating project tags.")];
            }
            finally {
                this.generatingProjectTags = false;
            }
        });
    }
    generateProjectFolderTagsFile(folder) {
        return __awaiter(this, void 0, void 0, function* () {
            let filename = this.getTagsFileName(folder.uri);
            let args = DEFAULT_ARGS.concat(this.getExtraProjectCtagsArgs()).concat(["-R", "--perl-kinds=psc", "-f", filename]);
            let res = yield this.run(args, folder.uri.fsPath);
            if (!(res instanceof Error) ||
                !res.message.match(/doesn't look like a tag file; I refuse to overwrite it./)) {
                return res;
            }
            let remove = yield asyncUnlink(path.join(folder.uri.fsPath, filename));
            if (remove instanceof Error) {
                return res;
            }
            return this.run(args, folder.uri.fsPath);
        });
    }
    generateFileTags(document) {
        return __awaiter(this, void 0, void 0, function* () {
            let args = DEFAULT_ARGS.concat(["-f", "-", document.fileName]);
            let workspace = vscode.workspace.getWorkspaceFolder(document.uri);
            let folder = workspace ? workspace.uri.fsPath : document.uri.fsPath;
            const data = yield this.checkVersion().then(() => this.run(args, folder));
            if (data instanceof Error) {
                return data;
            }
            return { folder, data };
        });
    }
    generateFileUseTags(document) {
        let args = DEFAULT_ARGS.concat([EXTRA["use"], "-f", "-", document.fileName]);
        let workspace = vscode.workspace.getWorkspaceFolder(document.uri);
        let cwd = workspace ? workspace.uri.fsPath : document.uri.fsPath;
        return this.checkVersion().then(() => this.run(args, cwd));
    }
    // reading tags (and other) files
    readFile(filename) {
        return new Promise((resolve, reject) => {
            fs.readFile(filename, (error, data) => {
                if (error) {
                    console.error(`could not read file: ${filename}`);
                    console.error(`error message: ${error.message}`);
                    resolve(error);
                    return;
                }
                resolve(data.toString());
            });
        });
    }
    readProjectTags() {
        return __awaiter(this, void 0, void 0, function* () {
            const folders = vscode.workspace.workspaceFolders;
            if (folders === undefined) {
                return [];
            }
            return Promise.all(folders.map(folder => {
                let filename = path.join(folder.uri.fsPath, this.getTagsFileName(folder.uri));
                return this.readFile(filename).then(data => {
                    if (data instanceof Error) {
                        return data;
                    }
                    return { folder: folder.uri.fsPath, data };
                });
            }));
        });
    }
    projectOrFileTags(document) {
        return __awaiter(this, void 0, void 0, function* () {
            const results = yield this.readProjectTags();
            if (results.length !== 0) {
                return results;
            }
            const result = yield this.generateFileTags(document);
            return [result];
        });
    }
}
exports.Ctags = Ctags;
function asyncUnlink(filename) {
    return __awaiter(this, void 0, void 0, function* () {
        return new Promise((resolve, reject) => {
            fs.unlink(filename, err => {
                if (err) {
                    resolve(err);
                }
                resolve(null);
            });
        });
    });
}
//# sourceMappingURL=ctags.js.map