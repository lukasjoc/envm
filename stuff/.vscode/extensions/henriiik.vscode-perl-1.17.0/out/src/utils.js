"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const path = require("path");
function getPointBefore(range, delta) {
    let character = range.start.character - delta;
    character = character > 0 ? character : 0;
    return new vscode.Position(range.start.line, character);
}
exports.getPointBefore = getPointBefore;
function getRangeBefore(range, delta) {
    let point = getPointBefore(range, delta);
    return new vscode.Range(point, range.start);
}
exports.getRangeBefore = getRangeBefore;
function getPackageBefore(document, range) {
    let separatorRange = getRangeBefore(range, 2);
    let separator = document.getText(separatorRange);
    let pkg = "";
    while (separator === "::") {
        const newRange = document.getWordRangeAtPosition(getPointBefore(separatorRange, 1));
        if (newRange) {
            range = newRange;
            pkg = document.getText(range) + separator + pkg;
            separatorRange = getRangeBefore(range, 2);
            separator = document.getText(separatorRange);
        }
        else {
            // break loop
            separator = "";
        }
    }
    return pkg.replace(/::$/, "");
}
exports.getPackageBefore = getPackageBefore;
function getMatchLocation(line, rootPath) {
    let match = line.split("\t");
    let name = match[0];
    let lineNo = parseInt(match[2].replace(/[^\d]/g, "")) - 1;
    let filePath = path.join(rootPath || "", match[1]);
    let uri = vscode.Uri.file(filePath);
    let pos = new vscode.Position(lineNo, 0);
    return new vscode.Location(uri, pos);
}
exports.getMatchLocation = getMatchLocation;
//# sourceMappingURL=utils.js.map