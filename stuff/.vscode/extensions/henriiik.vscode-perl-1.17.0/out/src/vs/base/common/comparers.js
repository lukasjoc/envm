"use strict";
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
Object.defineProperty(exports, "__esModule", { value: true });
const strings = require("./strings");
const paths = require("./paths");
let intlFileNameCollator;
let intlFileNameCollatorIsNumeric;
function setFileNameComparer(collator) {
    intlFileNameCollator = collator;
    intlFileNameCollatorIsNumeric = collator.resolvedOptions().numeric;
}
exports.setFileNameComparer = setFileNameComparer;
function compareFileNames(one, other, caseSensitive = false) {
    if (intlFileNameCollator) {
        const a = one || '';
        const b = other || '';
        const result = intlFileNameCollator.compare(a, b);
        // Using the numeric option in the collator will
        // make compare(`foo1`, `foo01`) === 0. We must disambiguate.
        if (intlFileNameCollatorIsNumeric && result === 0 && a !== b) {
            return a < b ? -1 : 1;
        }
        return result;
    }
    return noIntlCompareFileNames(one, other, caseSensitive);
}
exports.compareFileNames = compareFileNames;
const FileNameMatch = /^(.*?)(\.([^.]*))?$/;
function noIntlCompareFileNames(one, other, caseSensitive = false) {
    if (!caseSensitive) {
        one = one && one.toLowerCase();
        other = other && other.toLowerCase();
    }
    const [oneName, oneExtension] = extractNameAndExtension(one);
    const [otherName, otherExtension] = extractNameAndExtension(other);
    if (oneName !== otherName) {
        return oneName < otherName ? -1 : 1;
    }
    if (oneExtension === otherExtension) {
        return 0;
    }
    return oneExtension < otherExtension ? -1 : 1;
}
exports.noIntlCompareFileNames = noIntlCompareFileNames;
function compareFileExtensions(one, other) {
    if (intlFileNameCollator) {
        const [oneName, oneExtension] = extractNameAndExtension(one);
        const [otherName, otherExtension] = extractNameAndExtension(other);
        let result = intlFileNameCollator.compare(oneExtension, otherExtension);
        if (result === 0) {
            // Using the numeric option in the collator will
            // make compare(`foo1`, `foo01`) === 0. We must disambiguate.
            if (intlFileNameCollatorIsNumeric && oneExtension !== otherExtension) {
                return oneExtension < otherExtension ? -1 : 1;
            }
            // Extensions are equal, compare filenames
            result = intlFileNameCollator.compare(oneName, otherName);
            if (intlFileNameCollatorIsNumeric && result === 0 && oneName !== otherName) {
                return oneName < otherName ? -1 : 1;
            }
        }
        return result;
    }
    return noIntlCompareFileExtensions(one, other);
}
exports.compareFileExtensions = compareFileExtensions;
function noIntlCompareFileExtensions(one, other) {
    const [oneName, oneExtension] = extractNameAndExtension(one && one.toLowerCase());
    const [otherName, otherExtension] = extractNameAndExtension(other && other.toLowerCase());
    if (oneExtension !== otherExtension) {
        return oneExtension < otherExtension ? -1 : 1;
    }
    if (oneName === otherName) {
        return 0;
    }
    return oneName < otherName ? -1 : 1;
}
function extractNameAndExtension(str) {
    const match = str ? FileNameMatch.exec(str) : [];
    return [(match && match[1]) || '', (match && match[3]) || ''];
}
function comparePathComponents(one, other, caseSensitive = false) {
    if (!caseSensitive) {
        one = one && one.toLowerCase();
        other = other && other.toLowerCase();
    }
    if (one === other) {
        return 0;
    }
    return one < other ? -1 : 1;
}
function comparePaths(one, other, caseSensitive = false) {
    const oneParts = one.split(paths.nativeSep);
    const otherParts = other.split(paths.nativeSep);
    const lastOne = oneParts.length - 1;
    const lastOther = otherParts.length - 1;
    let endOne, endOther;
    for (let i = 0;; i++) {
        endOne = lastOne === i;
        endOther = lastOther === i;
        if (endOne && endOther) {
            return compareFileNames(oneParts[i], otherParts[i], caseSensitive);
        }
        else if (endOne) {
            return -1;
        }
        else if (endOther) {
            return 1;
        }
        const result = comparePathComponents(oneParts[i], otherParts[i], caseSensitive);
        if (result !== 0) {
            return result;
        }
    }
}
exports.comparePaths = comparePaths;
function compareAnything(one, other, lookFor) {
    let elementAName = one.toLowerCase();
    let elementBName = other.toLowerCase();
    // Sort prefix matches over non prefix matches
    const prefixCompare = compareByPrefix(one, other, lookFor);
    if (prefixCompare) {
        return prefixCompare;
    }
    // Sort suffix matches over non suffix matches
    let elementASuffixMatch = strings.endsWith(elementAName, lookFor);
    let elementBSuffixMatch = strings.endsWith(elementBName, lookFor);
    if (elementASuffixMatch !== elementBSuffixMatch) {
        return elementASuffixMatch ? -1 : 1;
    }
    // Understand file names
    let r = compareFileNames(elementAName, elementBName);
    if (r !== 0) {
        return r;
    }
    // Compare by name
    return elementAName.localeCompare(elementBName);
}
exports.compareAnything = compareAnything;
function compareByPrefix(one, other, lookFor) {
    let elementAName = one.toLowerCase();
    let elementBName = other.toLowerCase();
    // Sort prefix matches over non prefix matches
    let elementAPrefixMatch = strings.startsWith(elementAName, lookFor);
    let elementBPrefixMatch = strings.startsWith(elementBName, lookFor);
    if (elementAPrefixMatch !== elementBPrefixMatch) {
        return elementAPrefixMatch ? -1 : 1;
    }
    // Same prefix: Sort shorter matches to the top to have those on top that match more precisely
    else if (elementAPrefixMatch && elementBPrefixMatch) {
        if (elementAName.length < elementBName.length) {
            return -1;
        }
        if (elementAName.length > elementBName.length) {
            return 1;
        }
    }
    return 0;
}
exports.compareByPrefix = compareByPrefix;
//# sourceMappingURL=comparers.js.map