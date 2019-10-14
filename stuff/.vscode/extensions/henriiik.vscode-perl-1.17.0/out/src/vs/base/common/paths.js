"use strict";
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
Object.defineProperty(exports, "__esModule", { value: true });
const platform_1 = require("./platform");
const strings_1 = require("./strings");
/**
 * The forward slash path separator.
 */
exports.sep = '/';
/**
 * The native path separator depending on the OS.
 */
exports.nativeSep = platform_1.isWindows ? '\\' : '/';
/**
 * @param path the path to get the dirname from
 * @param separator the separator to use
 * @returns the directory name of a path.
 *
 */
function dirname(path, separator = exports.nativeSep) {
    const idx = ~path.lastIndexOf('/') || ~path.lastIndexOf('\\');
    if (idx === 0) {
        return '.';
    }
    else if (~idx === 0) {
        return path[0];
    }
    else if (~idx === path.length - 1) {
        return dirname(path.substring(0, path.length - 1));
    }
    else {
        let res = path.substring(0, ~idx);
        if (platform_1.isWindows && res[res.length - 1] === ':') {
            res += separator; // make sure drive letters end with backslash
        }
        return res;
    }
}
exports.dirname = dirname;
/**
 * @returns the base name of a path.
 */
function basename(path) {
    const idx = ~path.lastIndexOf('/') || ~path.lastIndexOf('\\');
    if (idx === 0) {
        return path;
    }
    else if (~idx === path.length - 1) {
        return basename(path.substring(0, path.length - 1));
    }
    else {
        return path.substr(~idx + 1);
    }
}
exports.basename = basename;
/**
 * @returns `.far` from `boo.far` or the empty string.
 */
function extname(path) {
    path = basename(path);
    const idx = ~path.lastIndexOf('.');
    return idx ? path.substring(~idx) : '';
}
exports.extname = extname;
const _posixBadPath = /(\/\.\.?\/)|(\/\.\.?)$|^(\.\.?\/)|(\/\/+)|(\\)/;
const _winBadPath = /(\\\.\.?\\)|(\\\.\.?)$|^(\.\.?\\)|(\\\\+)|(\/)/;
function _isNormal(path, win) {
    return win
        ? !_winBadPath.test(path)
        : !_posixBadPath.test(path);
}
function normalize(path, toOSPath) {
    if (path === null || path === void 0) {
        return path;
    }
    const len = path.length;
    if (len === 0) {
        return '.';
    }
    const wantsBackslash = !!(platform_1.isWindows && toOSPath);
    if (_isNormal(path, wantsBackslash)) {
        return path;
    }
    const sep = wantsBackslash ? '\\' : '/';
    const root = getRoot(path, sep);
    // skip the root-portion of the path
    let start = root.length;
    let skip = false;
    let res = '';
    for (let end = root.length; end <= len; end++) {
        // either at the end or at a path-separator character
        if (end === len || path.charCodeAt(end) === 47 /* Slash */ || path.charCodeAt(end) === 92 /* Backslash */) {
            if (streql(path, start, end, '..')) {
                // skip current and remove parent (if there is already something)
                let prev_start = res.lastIndexOf(sep);
                let prev_part = res.slice(prev_start + 1);
                if ((root || prev_part.length > 0) && prev_part !== '..') {
                    res = prev_start === -1 ? '' : res.slice(0, prev_start);
                    skip = true;
                }
            }
            else if (streql(path, start, end, '.') && (root || res || end < len - 1)) {
                // skip current (if there is already something or if there is more to come)
                skip = true;
            }
            if (!skip) {
                let part = path.slice(start, end);
                if (res !== '' && res[res.length - 1] !== sep) {
                    res += sep;
                }
                res += part;
            }
            start = end + 1;
            skip = false;
        }
    }
    return root + res;
}
exports.normalize = normalize;
function streql(value, start, end, other) {
    return start + other.length === end && value.indexOf(other, start) === start;
}
/**
 * Computes the _root_ this path, like `getRoot('c:\files') === c:\`,
 * `getRoot('files:///files/path') === files:///`,
 * or `getRoot('\\server\shares\path') === \\server\shares\`
 */
function getRoot(path, sep = '/') {
    if (!path) {
        return '';
    }
    let len = path.length;
    let code = path.charCodeAt(0);
    if (code === 47 /* Slash */ || code === 92 /* Backslash */) {
        code = path.charCodeAt(1);
        if (code === 47 /* Slash */ || code === 92 /* Backslash */) {
            // UNC candidate \\localhost\shares\ddd
            //               ^^^^^^^^^^^^^^^^^^^
            code = path.charCodeAt(2);
            if (code !== 47 /* Slash */ && code !== 92 /* Backslash */) {
                let pos = 3;
                let start = pos;
                for (; pos < len; pos++) {
                    code = path.charCodeAt(pos);
                    if (code === 47 /* Slash */ || code === 92 /* Backslash */) {
                        break;
                    }
                }
                code = path.charCodeAt(pos + 1);
                if (start !== pos && code !== 47 /* Slash */ && code !== 92 /* Backslash */) {
                    pos += 1;
                    for (; pos < len; pos++) {
                        code = path.charCodeAt(pos);
                        if (code === 47 /* Slash */ || code === 92 /* Backslash */) {
                            return path.slice(0, pos + 1) // consume this separator
                                .replace(/[\\/]/g, sep);
                        }
                    }
                }
            }
        }
        // /user/far
        // ^
        return sep;
    }
    else if ((code >= 65 /* A */ && code <= 90 /* Z */) || (code >= 97 /* a */ && code <= 122 /* z */)) {
        // check for windows drive letter c:\ or c:
        if (path.charCodeAt(1) === 58 /* Colon */) {
            code = path.charCodeAt(2);
            if (code === 47 /* Slash */ || code === 92 /* Backslash */) {
                // C:\fff
                // ^^^
                return path.slice(0, 2) + sep;
            }
            else {
                // C:
                // ^^
                return path.slice(0, 2);
            }
        }
    }
    // check for URI
    // scheme://authority/path
    // ^^^^^^^^^^^^^^^^^^^
    let pos = path.indexOf('://');
    if (pos !== -1) {
        pos += 3; // 3 -> "://".length
        for (; pos < len; pos++) {
            code = path.charCodeAt(pos);
            if (code === 47 /* Slash */ || code === 92 /* Backslash */) {
                return path.slice(0, pos + 1); // consume this separator
            }
        }
    }
    return '';
}
exports.getRoot = getRoot;
exports.join = function () {
    // Not using a function with var-args because of how TS compiles
    // them to JS - it would result in 2*n runtime cost instead
    // of 1*n, where n is parts.length.
    let value = '';
    for (let i = 0; i < arguments.length; i++) {
        let part = arguments[i];
        if (i > 0) {
            // add the separater between two parts unless
            // there already is one
            let last = value.charCodeAt(value.length - 1);
            if (last !== 47 /* Slash */ && last !== 92 /* Backslash */) {
                let next = part.charCodeAt(0);
                if (next !== 47 /* Slash */ && next !== 92 /* Backslash */) {
                    value += exports.sep;
                }
            }
        }
        value += part;
    }
    return normalize(value);
};
/**
 * Check if the path follows this pattern: `\\hostname\sharename`.
 *
 * @see https://msdn.microsoft.com/en-us/library/gg465305.aspx
 * @return A boolean indication if the path is a UNC path, on none-windows
 * always false.
 */
function isUNC(path) {
    if (!platform_1.isWindows) {
        // UNC is a windows concept
        return false;
    }
    if (!path || path.length < 5) {
        // at least \\a\b
        return false;
    }
    let code = path.charCodeAt(0);
    if (code !== 92 /* Backslash */) {
        return false;
    }
    code = path.charCodeAt(1);
    if (code !== 92 /* Backslash */) {
        return false;
    }
    let pos = 2;
    let start = pos;
    for (; pos < path.length; pos++) {
        code = path.charCodeAt(pos);
        if (code === 92 /* Backslash */) {
            break;
        }
    }
    if (start === pos) {
        return false;
    }
    code = path.charCodeAt(pos + 1);
    if (isNaN(code) || code === 92 /* Backslash */) {
        return false;
    }
    return true;
}
exports.isUNC = isUNC;
// Reference: https://en.wikipedia.org/wiki/Filename
const INVALID_FILE_CHARS = platform_1.isWindows ? /[\\/:\*\?"<>\|]/g : /[\\/]/g;
const WINDOWS_FORBIDDEN_NAMES = /^(con|prn|aux|clock\$|nul|lpt[0-9]|com[0-9])$/i;
function isValidBasename(name) {
    if (!name || name.length === 0 || /^\s+$/.test(name)) {
        return false; // require a name that is not just whitespace
    }
    INVALID_FILE_CHARS.lastIndex = 0; // the holy grail of software development
    if (INVALID_FILE_CHARS.test(name)) {
        return false; // check for certain invalid file characters
    }
    if (platform_1.isWindows && WINDOWS_FORBIDDEN_NAMES.test(name)) {
        return false; // check for certain invalid file names
    }
    if (name === '.' || name === '..') {
        return false; // check for reserved values
    }
    if (platform_1.isWindows && name[name.length - 1] === '.') {
        return false; // Windows: file cannot end with a "."
    }
    if (platform_1.isWindows && name.length !== name.trim().length) {
        return false; // Windows: file cannot end with a whitespace
    }
    return true;
}
exports.isValidBasename = isValidBasename;
function isEqual(pathA, pathB, ignoreCase) {
    const identityEquals = (pathA === pathB);
    if (!ignoreCase || identityEquals) {
        return identityEquals;
    }
    if (!pathA || !pathB) {
        return false;
    }
    return strings_1.equalsIgnoreCase(pathA, pathB);
}
exports.isEqual = isEqual;
function isEqualOrParent(path, candidate, ignoreCase, separator = exports.nativeSep) {
    if (path === candidate) {
        return true;
    }
    if (!path || !candidate) {
        return false;
    }
    if (candidate.length > path.length) {
        return false;
    }
    if (ignoreCase) {
        const beginsWith = strings_1.startsWithIgnoreCase(path, candidate);
        if (!beginsWith) {
            return false;
        }
        if (candidate.length === path.length) {
            return true; // same path, different casing
        }
        let sepOffset = candidate.length;
        if (candidate.charAt(candidate.length - 1) === separator) {
            sepOffset--; // adjust the expected sep offset in case our candidate already ends in separator character
        }
        return path.charAt(sepOffset) === separator;
    }
    if (candidate.charAt(candidate.length - 1) !== separator) {
        candidate += separator;
    }
    return path.indexOf(candidate) === 0;
}
exports.isEqualOrParent = isEqualOrParent;
/**
 * Adapted from Node's path.isAbsolute functions
 */
function isAbsolute(path) {
    return platform_1.isWindows ?
        isAbsolute_win32(path) :
        isAbsolute_posix(path);
}
exports.isAbsolute = isAbsolute;
function isAbsolute_win32(path) {
    if (!path) {
        return false;
    }
    const char0 = path.charCodeAt(0);
    if (char0 === 47 /* Slash */ || char0 === 92 /* Backslash */) {
        return true;
    }
    else if ((char0 >= 65 /* A */ && char0 <= 90 /* Z */) || (char0 >= 97 /* a */ && char0 <= 122 /* z */)) {
        if (path.length > 2 && path.charCodeAt(1) === 58 /* Colon */) {
            const char2 = path.charCodeAt(2);
            if (char2 === 47 /* Slash */ || char2 === 92 /* Backslash */) {
                return true;
            }
        }
    }
    return false;
}
exports.isAbsolute_win32 = isAbsolute_win32;
function isAbsolute_posix(path) {
    return !!(path && path.charCodeAt(0) === 47 /* Slash */);
}
exports.isAbsolute_posix = isAbsolute_posix;
//# sourceMappingURL=paths.js.map