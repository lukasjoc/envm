"use strict";
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
Object.defineProperty(exports, "__esModule", { value: true });
const map_1 = require("./map");
const strings = require("./strings");
// Combined filters
/**
 * @returns A filter which combines the provided set
 * of filters with an or. The *first* filters that
 * matches defined the return value of the returned
 * filter.
 */
function or(...filter) {
    return function (word, wordToMatchAgainst) {
        for (let i = 0, len = filter.length; i < len; i++) {
            let match = filter[i](word, wordToMatchAgainst);
            if (match) {
                return match;
            }
        }
        return null;
    };
}
exports.or = or;
// Prefix
exports.matchesStrictPrefix = _matchesPrefix.bind(undefined, false);
exports.matchesPrefix = _matchesPrefix.bind(undefined, true);
function _matchesPrefix(ignoreCase, word, wordToMatchAgainst) {
    if (!wordToMatchAgainst || wordToMatchAgainst.length < word.length) {
        return null;
    }
    let matches;
    if (ignoreCase) {
        matches = strings.startsWithIgnoreCase(wordToMatchAgainst, word);
    }
    else {
        matches = wordToMatchAgainst.indexOf(word) === 0;
    }
    if (!matches) {
        return null;
    }
    return word.length > 0 ? [{ start: 0, end: word.length }] : [];
}
// Contiguous Substring
function matchesContiguousSubString(word, wordToMatchAgainst) {
    let index = wordToMatchAgainst.toLowerCase().indexOf(word.toLowerCase());
    if (index === -1) {
        return null;
    }
    return [{ start: index, end: index + word.length }];
}
exports.matchesContiguousSubString = matchesContiguousSubString;
// Substring
function matchesSubString(word, wordToMatchAgainst) {
    return _matchesSubString(word.toLowerCase(), wordToMatchAgainst.toLowerCase(), 0, 0);
}
exports.matchesSubString = matchesSubString;
function _matchesSubString(word, wordToMatchAgainst, i, j) {
    if (i === word.length) {
        return [];
    }
    else if (j === wordToMatchAgainst.length) {
        return null;
    }
    else {
        if (word[i] === wordToMatchAgainst[j]) {
            let result = null;
            if (result = _matchesSubString(word, wordToMatchAgainst, i + 1, j + 1)) {
                return join({ start: j, end: j + 1 }, result);
            }
            return null;
        }
        return _matchesSubString(word, wordToMatchAgainst, i, j + 1);
    }
}
// CamelCase
function isLower(code) {
    return 97 /* a */ <= code && code <= 122 /* z */;
}
function isUpper(code) {
    return 65 /* A */ <= code && code <= 90 /* Z */;
}
exports.isUpper = isUpper;
function isNumber(code) {
    return 48 /* Digit0 */ <= code && code <= 57 /* Digit9 */;
}
function isWhitespace(code) {
    return (code === 32 /* Space */
        || code === 9 /* Tab */
        || code === 10 /* LineFeed */
        || code === 13 /* CarriageReturn */);
}
function isAlphanumeric(code) {
    return isLower(code) || isUpper(code) || isNumber(code);
}
function join(head, tail) {
    if (tail.length === 0) {
        tail = [head];
    }
    else if (head.end === tail[0].start) {
        tail[0].start = head.start;
    }
    else {
        tail.unshift(head);
    }
    return tail;
}
function nextAnchor(camelCaseWord, start) {
    for (let i = start; i < camelCaseWord.length; i++) {
        let c = camelCaseWord.charCodeAt(i);
        if (isUpper(c) || isNumber(c) || (i > 0 && !isAlphanumeric(camelCaseWord.charCodeAt(i - 1)))) {
            return i;
        }
    }
    return camelCaseWord.length;
}
function _matchesCamelCase(word, camelCaseWord, i, j) {
    if (i === word.length) {
        return [];
    }
    else if (j === camelCaseWord.length) {
        return null;
    }
    else if (word[i] !== camelCaseWord[j].toLowerCase()) {
        return null;
    }
    else {
        let result = null;
        let nextUpperIndex = j + 1;
        result = _matchesCamelCase(word, camelCaseWord, i + 1, j + 1);
        while (!result && (nextUpperIndex = nextAnchor(camelCaseWord, nextUpperIndex)) < camelCaseWord.length) {
            result = _matchesCamelCase(word, camelCaseWord, i + 1, nextUpperIndex);
            nextUpperIndex++;
        }
        return result === null ? null : join({ start: j, end: j + 1 }, result);
    }
}
// Heuristic to avoid computing camel case matcher for words that don't
// look like camelCaseWords.
function analyzeCamelCaseWord(word) {
    let upper = 0, lower = 0, alpha = 0, numeric = 0, code = 0;
    for (let i = 0; i < word.length; i++) {
        code = word.charCodeAt(i);
        if (isUpper(code)) {
            upper++;
        }
        if (isLower(code)) {
            lower++;
        }
        if (isAlphanumeric(code)) {
            alpha++;
        }
        if (isNumber(code)) {
            numeric++;
        }
    }
    let upperPercent = upper / word.length;
    let lowerPercent = lower / word.length;
    let alphaPercent = alpha / word.length;
    let numericPercent = numeric / word.length;
    return { upperPercent, lowerPercent, alphaPercent, numericPercent };
}
function isUpperCaseWord(analysis) {
    const { upperPercent, lowerPercent } = analysis;
    return lowerPercent === 0 && upperPercent > 0.6;
}
function isCamelCaseWord(analysis) {
    const { upperPercent, lowerPercent, alphaPercent, numericPercent } = analysis;
    return lowerPercent > 0.2 && upperPercent < 0.8 && alphaPercent > 0.6 && numericPercent < 0.2;
}
// Heuristic to avoid computing camel case matcher for words that don't
// look like camel case patterns.
function isCamelCasePattern(word) {
    let upper = 0, lower = 0, code = 0, whitespace = 0;
    for (let i = 0; i < word.length; i++) {
        code = word.charCodeAt(i);
        if (isUpper(code)) {
            upper++;
        }
        if (isLower(code)) {
            lower++;
        }
        if (isWhitespace(code)) {
            whitespace++;
        }
    }
    if ((upper === 0 || lower === 0) && whitespace === 0) {
        return word.length <= 30;
    }
    else {
        return upper <= 5;
    }
}
function matchesCamelCase(word, camelCaseWord) {
    if (!camelCaseWord) {
        return null;
    }
    camelCaseWord = camelCaseWord.trim();
    if (camelCaseWord.length === 0) {
        return null;
    }
    if (!isCamelCasePattern(word)) {
        return null;
    }
    if (camelCaseWord.length > 60) {
        return null;
    }
    const analysis = analyzeCamelCaseWord(camelCaseWord);
    if (!isCamelCaseWord(analysis)) {
        if (!isUpperCaseWord(analysis)) {
            return null;
        }
        camelCaseWord = camelCaseWord.toLowerCase();
    }
    let result = null;
    let i = 0;
    word = word.toLowerCase();
    while (i < camelCaseWord.length && (result = _matchesCamelCase(word, camelCaseWord, 0, i)) === null) {
        i = nextAnchor(camelCaseWord, i + 1);
    }
    return result;
}
exports.matchesCamelCase = matchesCamelCase;
// Matches beginning of words supporting non-ASCII languages
// If `contiguous` is true then matches word with beginnings of the words in the target. E.g. "pul" will match "Git: Pull"
// Otherwise also matches sub string of the word with beginnings of the words in the target. E.g. "gp" or "g p" will match "Git: Pull"
// Useful in cases where the target is words (e.g. command labels)
function matchesWords(word, target, contiguous = false) {
    if (!target || target.length === 0) {
        return null;
    }
    let result = null;
    let i = 0;
    word = word.toLowerCase();
    target = target.toLowerCase();
    while (i < target.length && (result = _matchesWords(word, target, 0, i, contiguous)) === null) {
        i = nextWord(target, i + 1);
    }
    return result;
}
exports.matchesWords = matchesWords;
function _matchesWords(word, target, i, j, contiguous) {
    if (i === word.length) {
        return [];
    }
    else if (j === target.length) {
        return null;
    }
    else if (word[i] !== target[j]) {
        return null;
    }
    else {
        let result = null;
        let nextWordIndex = j + 1;
        result = _matchesWords(word, target, i + 1, j + 1, contiguous);
        if (!contiguous) {
            while (!result && (nextWordIndex = nextWord(target, nextWordIndex)) < target.length) {
                result = _matchesWords(word, target, i + 1, nextWordIndex, contiguous);
                nextWordIndex++;
            }
        }
        return result === null ? null : join({ start: j, end: j + 1 }, result);
    }
}
function nextWord(word, start) {
    for (let i = start; i < word.length; i++) {
        let c = word.charCodeAt(i);
        if (isWhitespace(c) || (i > 0 && isWhitespace(word.charCodeAt(i - 1)))) {
            return i;
        }
    }
    return word.length;
}
// Fuzzy
exports.fuzzyContiguousFilter = or(exports.matchesPrefix, matchesCamelCase, matchesContiguousSubString);
const fuzzySeparateFilter = or(exports.matchesPrefix, matchesCamelCase, matchesSubString);
const fuzzyRegExpCache = new map_1.LRUCache(10000); // bounded to 10000 elements
function matchesFuzzy(word, wordToMatchAgainst, enableSeparateSubstringMatching = false) {
    if (typeof word !== 'string' || typeof wordToMatchAgainst !== 'string') {
        return null; // return early for invalid input
    }
    // Form RegExp for wildcard matches
    let regexp = fuzzyRegExpCache.get(word);
    if (!regexp) {
        regexp = new RegExp(strings.convertSimple2RegExpPattern(word), 'i');
        fuzzyRegExpCache.set(word, regexp);
    }
    // RegExp Filter
    let match = regexp.exec(wordToMatchAgainst);
    if (match) {
        return [{ start: match.index, end: match.index + match[0].length }];
    }
    // Default Filter
    return enableSeparateSubstringMatching ? fuzzySeparateFilter(word, wordToMatchAgainst) : exports.fuzzyContiguousFilter(word, wordToMatchAgainst);
}
exports.matchesFuzzy = matchesFuzzy;
function anyScore(pattern, word, patternMaxWhitespaceIgnore) {
    pattern = pattern.toLowerCase();
    word = word.toLowerCase();
    const matches = [];
    let idx = 0;
    for (let pos = 0; pos < pattern.length; ++pos) {
        const thisIdx = word.indexOf(pattern.charAt(pos), idx);
        if (thisIdx >= 0) {
            matches.push(thisIdx);
            idx = thisIdx + 1;
        }
    }
    return [matches.length, matches];
}
exports.anyScore = anyScore;
//#region --- fuzzyScore ---
function createMatches(offsetOrScore) {
    let ret = [];
    if (!offsetOrScore) {
        return ret;
    }
    let offsets;
    if (Array.isArray(offsetOrScore[1])) {
        offsets = offsetOrScore[1];
    }
    else {
        offsets = offsetOrScore;
    }
    let last;
    for (const pos of offsets) {
        if (last && last.end === pos) {
            last.end += 1;
        }
        else {
            last = { start: pos, end: pos + 1 };
            ret.push(last);
        }
    }
    return ret;
}
exports.createMatches = createMatches;
function initTable() {
    const table = [];
    const row = [0];
    for (let i = 1; i <= 100; i++) {
        row.push(-i);
    }
    for (let i = 0; i <= 100; i++) {
        let thisRow = row.slice(0);
        thisRow[0] = -i;
        table.push(thisRow);
    }
    return table;
}
const _table = initTable();
const _scores = initTable();
const _arrows = initTable();
const _debug = false;
function printTable(table, pattern, patternLen, word, wordLen) {
    function pad(s, n, pad = ' ') {
        while (s.length < n) {
            s = pad + s;
        }
        return s;
    }
    let ret = ` |   |${word.split('').map(c => pad(c, 3)).join('|')}\n`;
    for (let i = 0; i <= patternLen; i++) {
        if (i === 0) {
            ret += ' |';
        }
        else {
            ret += `${pattern[i - 1]}|`;
        }
        ret += table[i].slice(0, wordLen + 1).map(n => pad(n.toString(), 3)).join('|') + '\n';
    }
    return ret;
}
function isSeparatorAtPos(value, index) {
    if (index < 0 || index >= value.length) {
        return false;
    }
    const code = value.charCodeAt(index);
    switch (code) {
        case 95 /* Underline */:
        case 45 /* Dash */:
        case 46 /* Period */:
        case 32 /* Space */:
        case 47 /* Slash */:
        case 92 /* Backslash */:
        case 39 /* SingleQuote */:
        case 34 /* DoubleQuote */:
        case 58 /* Colon */:
            return true;
        default:
            return false;
    }
}
function isWhitespaceAtPos(value, index) {
    if (index < 0 || index >= value.length) {
        return false;
    }
    const code = value.charCodeAt(index);
    switch (code) {
        case 32 /* Space */:
        case 9 /* Tab */:
            return true;
        default:
            return false;
    }
}
function fuzzyScore(pattern, lowPattern, patternPos, word, lowWord, wordPos, firstMatchCanBeWeak) {
    const patternLen = pattern.length > 100 ? 100 : pattern.length;
    const wordLen = word.length > 100 ? 100 : word.length;
    if (patternPos >= patternLen || wordPos >= wordLen || patternLen > wordLen) {
        return undefined;
    }
    // Run a simple check if the characters of pattern occur
    // (in order) at all in word. If that isn't the case we
    // stop because no match will be possible
    const patternStartPos = patternPos;
    const wordStartPos = wordPos;
    while (patternPos < patternLen && wordPos < wordLen) {
        if (lowPattern[patternPos] === lowWord[wordPos]) {
            patternPos += 1;
        }
        wordPos += 1;
    }
    if (patternPos !== patternLen) {
        return undefined;
    }
    patternPos = patternStartPos;
    wordPos = wordStartPos;
    // There will be a mach, fill in tables
    for (patternPos = patternStartPos + 1; patternPos <= patternLen; patternPos++) {
        for (wordPos = 1; wordPos <= wordLen; wordPos++) {
            let score = -1;
            let lowWordChar = lowWord[wordPos - 1];
            if (lowPattern[patternPos - 1] === lowWordChar) {
                if (wordPos === (patternPos - patternStartPos)) {
                    // common prefix: `foobar <-> foobaz`
                    if (pattern[patternPos - 1] === word[wordPos - 1]) {
                        score = 7;
                    }
                    else {
                        score = 5;
                    }
                }
                else if (lowWordChar !== word[wordPos - 1] && (wordPos === 1 || lowWord[wordPos - 2] === word[wordPos - 2])) {
                    // hitting upper-case: `foo <-> forOthers`
                    if (pattern[patternPos - 1] === word[wordPos - 1]) {
                        score = 7;
                    }
                    else {
                        score = 5;
                    }
                }
                else if (isSeparatorAtPos(lowWord, wordPos - 2) || isWhitespaceAtPos(lowWord, wordPos - 2)) {
                    // post separator: `foo <-> bar_foo`
                    score = 5;
                }
                else {
                    score = 1;
                }
            }
            _scores[patternPos][wordPos] = score;
            let diag = _table[patternPos - 1][wordPos - 1] + (score > 1 ? 1 : score);
            let top = _table[patternPos - 1][wordPos] + -1;
            let left = _table[patternPos][wordPos - 1] + -1;
            if (left >= top) {
                // left or diag
                if (left > diag) {
                    _table[patternPos][wordPos] = left;
                    _arrows[patternPos][wordPos] = 4 /* Left */;
                }
                else if (left === diag) {
                    _table[patternPos][wordPos] = left;
                    _arrows[patternPos][wordPos] = 4 /* Left */ | 2 /* Diag */;
                }
                else {
                    _table[patternPos][wordPos] = diag;
                    _arrows[patternPos][wordPos] = 2 /* Diag */;
                }
            }
            else {
                // top or diag
                if (top > diag) {
                    _table[patternPos][wordPos] = top;
                    _arrows[patternPos][wordPos] = 1 /* Top */;
                }
                else if (top === diag) {
                    _table[patternPos][wordPos] = top;
                    _arrows[patternPos][wordPos] = 1 /* Top */ | 2 /* Diag */;
                }
                else {
                    _table[patternPos][wordPos] = diag;
                    _arrows[patternPos][wordPos] = 2 /* Diag */;
                }
            }
        }
    }
    if (_debug) {
        console.log(printTable(_table, pattern, patternLen, word, wordLen));
        console.log(printTable(_arrows, pattern, patternLen, word, wordLen));
        console.log(printTable(_scores, pattern, patternLen, word, wordLen));
    }
    // _bucket is an array of [PrefixArray] we use to keep
    // track of scores and matches. After calling `_findAllMatches`
    // the best match (if available) is the first item in the array
    _matchesCount = 0;
    _topScore = -100;
    _patternStartPos = patternStartPos;
    _firstMatchCanBeWeak = firstMatchCanBeWeak;
    _findAllMatches(patternLen, wordLen, patternLen === wordLen ? 1 : 0, new LazyArray(), false);
    if (_matchesCount === 0) {
        return undefined;
    }
    return [_topScore, _topMatch.toArray()];
}
exports.fuzzyScore = fuzzyScore;
let _matchesCount = 0;
let _topMatch;
let _topScore = 0;
let _patternStartPos = 0;
let _firstMatchCanBeWeak = false;
function _findAllMatches(patternPos, wordPos, total, matches, lastMatched) {
    if (_matchesCount >= 10 || total < -25) {
        // stop when having already 10 results, or
        // when a potential alignment as already 5 gaps
        return;
    }
    let simpleMatchCount = 0;
    while (patternPos > _patternStartPos && wordPos > 0) {
        let score = _scores[patternPos][wordPos];
        let arrow = _arrows[patternPos][wordPos];
        if (arrow === 4 /* Left */) {
            // left
            wordPos -= 1;
            if (lastMatched) {
                total -= 5; // new gap penalty
            }
            else if (!matches.isEmpty()) {
                total -= 1; // gap penalty after first match
            }
            lastMatched = false;
            simpleMatchCount = 0;
        }
        else if (arrow & 2 /* Diag */) {
            if (arrow & 4 /* Left */) {
                // left
                _findAllMatches(patternPos, wordPos - 1, !matches.isEmpty() ? total - 1 : total, // gap penalty after first match
                matches.slice(), lastMatched);
            }
            // diag
            total += score;
            patternPos -= 1;
            wordPos -= 1;
            matches.unshift(wordPos);
            lastMatched = true;
            // count simple matches and boost a row of
            // simple matches when they yield in a
            // strong match.
            if (score === 1) {
                simpleMatchCount += 1;
                if (patternPos === _patternStartPos && !_firstMatchCanBeWeak) {
                    // when the first match is a weak
                    // match we discard it
                    return undefined;
                }
            }
            else {
                // boost
                total += 1 + (simpleMatchCount * (score - 1));
                simpleMatchCount = 0;
            }
        }
        else {
            return undefined;
        }
    }
    total -= wordPos >= 3 ? 9 : wordPos * 3; // late start penalty
    // dynamically keep track of the current top score
    // and insert the current best score at head, the rest at tail
    _matchesCount += 1;
    if (total > _topScore) {
        _topScore = total;
        _topMatch = matches;
    }
}
class LazyArray {
    constructor() {
        this._parent = new LazyArray;
        this._parentLen = 0;
        this._data = [];
    }
    isEmpty() {
        return (!this._data || this._data.length === 0) && (!this._parent || this._parent.isEmpty());
    }
    unshift(n) {
        if (!this._data) {
            this._data = [n];
        }
        else {
            this._data.unshift(n);
        }
    }
    slice() {
        const ret = new LazyArray();
        ret._parent = this;
        ret._parentLen = this._data ? this._data.length : 0;
        return ret;
    }
    toArray() {
        if (!this._data || this._data.length === 0) {
            return this._parent.toArray();
        }
        const bucket = [];
        let element = this;
        while (element) {
            if (element._parent && element._parent._data) {
                bucket.push(element._parent._data.slice(element._parent._data.length - element._parentLen));
            }
            element = element._parent;
        }
        return Array.prototype.concat.apply(this._data, bucket);
    }
}
//#endregion
//#region --- graceful ---
function fuzzyScoreGracefulAggressive(pattern, lowPattern, patternPos, word, lowWord, wordPos, firstMatchCanBeWeak) {
    return fuzzyScoreWithPermutations(pattern, lowPattern, patternPos, word, lowWord, wordPos, true, firstMatchCanBeWeak);
}
exports.fuzzyScoreGracefulAggressive = fuzzyScoreGracefulAggressive;
function fuzzyScoreGraceful(pattern, lowPattern, patternPos, word, lowWord, wordPos, firstMatchCanBeWeak) {
    return fuzzyScoreWithPermutations(pattern, lowPattern, patternPos, word, lowWord, wordPos, false, firstMatchCanBeWeak);
}
exports.fuzzyScoreGraceful = fuzzyScoreGraceful;
function fuzzyScoreWithPermutations(pattern, lowPattern, patternPos, word, lowWord, wordPos, aggressive, firstMatchCanBeWeak) {
    let top = fuzzyScore(pattern, lowPattern, patternPos, word, lowWord, wordPos, firstMatchCanBeWeak);
    if (top && !aggressive) {
        // when using the original pattern yield a result we`
        // return it unless we are aggressive and try to find
        // a better alignment, e.g. `cno` -> `^co^ns^ole` or `^c^o^nsole`.
        return top;
    }
    if (pattern.length >= 3) {
        // When the pattern is long enough then try a few (max 7)
        // permutations of the pattern to find a better match. The
        // permutations only swap neighbouring characters, e.g
        // `cnoso` becomes `conso`, `cnsoo`, `cnoos`.
        let tries = Math.min(7, pattern.length - 1);
        for (let movingPatternPos = patternPos + 1; movingPatternPos < tries; movingPatternPos++) {
            let newPattern = nextTypoPermutation(pattern, movingPatternPos);
            if (newPattern) {
                let candidate = fuzzyScore(newPattern, newPattern.toLowerCase(), patternPos, word, lowWord, wordPos, firstMatchCanBeWeak);
                if (candidate) {
                    candidate[0] -= 3; // permutation penalty
                    if (!top || candidate[0] > top[0]) {
                        top = candidate;
                    }
                }
            }
        }
    }
    return top;
}
function nextTypoPermutation(pattern, patternPos) {
    if (patternPos + 1 >= pattern.length) {
        return undefined;
    }
    let swap1 = pattern[patternPos];
    let swap2 = pattern[patternPos + 1];
    if (swap1 === swap2) {
        return undefined;
    }
    return pattern.slice(0, patternPos)
        + swap2
        + swap1
        + pattern.slice(patternPos + 2);
}
//#endregion
//# sourceMappingURL=filters.js.map