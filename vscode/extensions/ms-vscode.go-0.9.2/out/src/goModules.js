"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const util_1 = require("./util");
const path = require("path");
const cp = require("child_process");
const vscode = require("vscode");
const stateUtils_1 = require("./stateUtils");
const goInstallTools_1 = require("./goInstallTools");
const goPath_1 = require("./goPath");
function runGoModEnv(folderPath) {
    let goExecutable = util_1.getBinPath('go');
    if (!goExecutable) {
        return Promise.reject(new Error('Cannot find "go" binary. Update PATH or GOROOT appropriately.'));
    }
    return new Promise(resolve => {
        cp.execFile(goExecutable, ['env', 'GOMOD'], { cwd: folderPath, env: util_1.getToolsEnvVars() }, (err, stdout) => {
            if (err) {
                console.warn(`Error when running go env GOMOD: ${err}`);
                return resolve();
            }
            let [goMod] = stdout.split('\n');
            resolve(goMod);
        });
    });
}
function isModSupported(fileuri) {
    return getModFolderPath(fileuri).then(modPath => !!modPath);
}
exports.isModSupported = isModSupported;
const packageModCache = new Map();
function getModFolderPath(fileuri) {
    const pkgPath = path.dirname(fileuri.fsPath);
    if (packageModCache.has(pkgPath)) {
        return Promise.resolve(packageModCache.get(pkgPath));
    }
    // We never would be using the path under module cache for anything
    // So, dont bother finding where exactly is the go.mod file
    const moduleCache = util_1.getModuleCache();
    if (goPath_1.fixDriveCasingInWindows(fileuri.fsPath).startsWith(moduleCache)) {
        return Promise.resolve(moduleCache);
    }
    return util_1.getGoVersion().then(value => {
        if (value && (value.major !== 1 || value.minor < 11)) {
            return;
        }
        return runGoModEnv(pkgPath).then(result => {
            if (result) {
                logModuleUsage();
                result = path.dirname(result);
                const goConfig = vscode.workspace.getConfiguration('go', fileuri);
                if (goConfig['inferGopath'] === true) {
                    goConfig.update('inferGopath', false, vscode.ConfigurationTarget.WorkspaceFolder);
                    alertDisablingInferGopath();
                }
            }
            packageModCache.set(pkgPath, result);
            return result;
        });
    });
}
exports.getModFolderPath = getModFolderPath;
function alertDisablingInferGopath() {
    vscode.window.showInformationMessage('The "inferGopath" setting is disabled for this workspace because Go modules are being used.');
}
let moduleUsageLogged = false;
function logModuleUsage() {
    if (moduleUsageLogged) {
        return;
    }
    moduleUsageLogged = true;
    /* __GDPR__
        "modules" : {}
    */
    util_1.sendTelemetryEvent('modules');
}
const promptedToolsForCurrentSession = new Set();
function promptToUpdateToolForModules(tool, promptMsg) {
    if (promptedToolsForCurrentSession.has(tool)) {
        return;
    }
    const promptedToolsForModules = stateUtils_1.getFromGlobalState('promptedToolsForModules', {});
    if (promptedToolsForModules[tool]) {
        return;
    }
    util_1.getGoVersion().then(goVersion => {
        vscode.window.showInformationMessage(promptMsg, 'Update', 'Later', `Don't show again`)
            .then(selected => {
            switch (selected) {
                case 'Update':
                    goInstallTools_1.installTools([tool], goVersion);
                    promptedToolsForModules[tool] = true;
                    stateUtils_1.updateGlobalState('promptedToolsForModules', promptedToolsForModules);
                    break;
                case `Don't show again`:
                    promptedToolsForModules[tool] = true;
                    stateUtils_1.updateGlobalState('promptedToolsForModules', promptedToolsForModules);
                    break;
                case 'Later':
                default:
                    promptedToolsForCurrentSession.add(tool);
                    break;
            }
        });
    });
}
exports.promptToUpdateToolForModules = promptToUpdateToolForModules;
const folderToPackageMapping = {};
function getCurrentPackage(cwd) {
    if (folderToPackageMapping[cwd]) {
        return Promise.resolve(folderToPackageMapping[cwd]);
    }
    const moduleCache = util_1.getModuleCache();
    if (cwd.startsWith(moduleCache)) {
        let importPath = cwd.substr(moduleCache.length + 1);
        const matches = /@v\d+(\.\d+)?(\.\d+)?/.exec(importPath);
        if (matches) {
            importPath = importPath.substr(0, matches.index);
        }
        folderToPackageMapping[cwd] = importPath;
        return Promise.resolve(importPath);
    }
    let goRuntimePath = util_1.getBinPath('go');
    if (!goRuntimePath) {
        vscode.window.showInformationMessage('Cannot find "go" binary. Update PATH or GOROOT appropriately');
        return Promise.resolve(null);
    }
    return new Promise(resolve => {
        let childProcess = cp.spawn(goRuntimePath, ['list'], { cwd, env: util_1.getToolsEnvVars() });
        let chunks = [];
        childProcess.stdout.on('data', (stdout) => {
            chunks.push(stdout);
        });
        childProcess.on('close', () => {
            // Ignore lines that are empty or those that have logs about updating the module cache
            let pkgs = chunks.join('').toString().split('\n').filter(line => line && line.indexOf(' ') === -1);
            if (pkgs.length !== 1) {
                resolve();
                return;
            }
            folderToPackageMapping[cwd] = pkgs[0];
            resolve(pkgs[0]);
        });
    });
}
exports.getCurrentPackage = getCurrentPackage;
//# sourceMappingURL=goModules.js.map