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
const cp = require("child_process");
class PerlFormattingProvider {
    provideDocumentRangeFormattingEdits(document, range, options, token) {
        return __awaiter(this, void 0, void 0, function* () {
            // if perltidy is not defined, then skip the formatting
            if (!vscode.workspace.getConfiguration("perl").get("perltidy")) {
                return [];
            }
            return new Promise((resolve, reject) => {
                if (range.start.line !== range.end.line) {
                    range = range.with(range.start.with(range.start.line, 0), range.end.with(range.end.line, Number.MAX_VALUE));
                }
                let config = vscode.workspace.getConfiguration("perl");
                let executable = config.get("perltidy", "perltidy");
                let args = config.get("perltidyArgs", [
                    "-q",
                    "-et=4",
                    "-t",
                    "-ce",
                    "-l=0",
                    "-bar",
                    "-naws",
                    "-blbs=2",
                    "-mbl=2",
                ]);
                let container = config.get("perltidyContainer", "");
                if (container !== "") {
                    args = ["exec", "-i", container, executable].concat(args);
                    executable = "docker";
                }
                let text = document.getText(range);
                let child = cp.spawn(executable, args);
                child.stdin.write(text);
                child.stdin.end();
                let stdout = "";
                child.stdout.on("data", (out) => {
                    stdout += out.toString();
                });
                let stderr = "";
                child.stderr.on("data", (out) => {
                    stderr += out.toString();
                });
                let error;
                child.on("error", (err) => {
                    error = err;
                });
                child.on("close", (code, signal) => {
                    let message = "";
                    if (error) {
                        message = error.message;
                    }
                    else if (stderr) {
                        message = stderr;
                    }
                    else if (code !== 0) {
                        message = stdout;
                    }
                    if (code !== 0) {
                        message = message.trim();
                        let formatted = `Could not format, code: ${code}, error: ${message}`;
                        reject(formatted);
                    }
                    else {
                        if (!text.endsWith("\n")) {
                            stdout = stdout.slice(0, -1); // remove trailing newline
                        }
                        resolve([new vscode.TextEdit(range, stdout)]);
                    }
                });
            }).catch(reason => {
                console.error(reason);
                return [];
            });
        });
    }
}
exports.PerlFormattingProvider = PerlFormattingProvider;
//# sourceMappingURL=format.js.map