"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/*
  The core functionality of the autocomplete is work done by Stanislav Sysoev (@d4rkr00t)
  in his stylus extension and been adjusted to account for the slight differences between
  the languages.

  Original stylus version: https://github.com/d4rkr00t/language-stylus
*/
const vscode_1 = require("vscode");
const cssSchema = require("./schemas/cssSchema");
const sassSchema_1 = require("./schemas/sassSchema");
/**
 * Naive check whether currentWord is class, id or placeholder
 * @param {String} currentWord
 * @return {Boolean}
 */
function isClassOrId(currentWord) {
    return (currentWord.startsWith('.') ||
        currentWord.startsWith('#') ||
        currentWord.startsWith('%'));
}
exports.isClassOrId = isClassOrId;
function isSelector(currentWord) {
    return currentWord === 'section' || currentWord === 'div';
}
exports.isSelector = isSelector;
/**
 * Naive check whether currentWord is at rule
 * @param {String} currentWord
 * @return {Boolean}
 */
function isAtRule(currentWord) {
    return currentWord.startsWith('@');
}
exports.isAtRule = isAtRule;
/**
 * Naive check whether currentWord is value for given property
 * @param {Object} cssSchema
 * @param {String} currentWord
 * @return {Boolean}
 */
function isValue(cssSchema, currentWord) {
    const property = getPropertyName(currentWord);
    return property && Boolean(findPropertySchema(cssSchema, property));
}
exports.isValue = isValue;
/**
 * Formats property name
 * @param {String} currentWord
 * @return {String}
 */
function getPropertyName(currentWord) {
    return currentWord
        .trim()
        .replace(':', ' ')
        .split(' ')[0];
}
exports.getPropertyName = getPropertyName;
/**
 * Search for property in cssSchema
 * @param {Object} cssSchema
 * @param {String} property
 * @return {Object}
 */
function findPropertySchema(cssSchema, property) {
    return cssSchema.data.css.properties.find(item => item.name === property);
}
exports.findPropertySchema = findPropertySchema;
/**
 * Returns at rules list for completion
 * @param {Object} cssSchema
 * @param {String} currentWord
 * @return {CompletionItem}
 */
function getAtRules(cssSchema, currentWord) {
    if (!isAtRule(currentWord)) {
        return [];
    }
    return cssSchema.data.css.atdirectives.map(property => {
        const completionItem = new vscode_1.CompletionItem(property.name);
        completionItem.detail = property.desc;
        completionItem.kind = vscode_1.CompletionItemKind.Keyword;
        return completionItem;
    });
}
exports.getAtRules = getAtRules;
/**
 * Returns property list for completion
 * @param {Object} cssSchema
 * @param {String} currentWord
 * @return {CompletionItem}
 */
function getProperties(cssSchema, currentWord, useSeparator) {
    if (isClassOrId(currentWord) ||
        isAtRule(currentWord) ||
        isSelector(currentWord)) {
        return [];
    }
    return cssSchema.data.css.properties.map(property => {
        const completionItem = new vscode_1.CompletionItem(property.name);
        completionItem.insertText = property.name + (useSeparator ? ': ' : ' ');
        completionItem.detail = property.desc;
        completionItem.kind = vscode_1.CompletionItemKind.Property;
        return completionItem;
    });
}
exports.getProperties = getProperties;
/**
 * Returns values for current property for completion list
 * @param {Object} cssSchema
 * @param {String} currentWord
 * @return {CompletionItem}
 */
function getValues(cssSchema, currentWord) {
    const property = getPropertyName(currentWord);
    const values = findPropertySchema(cssSchema, property).values;
    if (!values) {
        return [];
    }
    return values.map(property => {
        const completionItem = new vscode_1.CompletionItem(property.name);
        completionItem.detail = property.desc;
        completionItem.kind = vscode_1.CompletionItemKind.Value;
        return completionItem;
    });
}
exports.getValues = getValues;
class SassCompletion {
    provideCompletionItems(document, position, token) {
        const start = new vscode_1.Position(position.line, 0);
        const range = new vscode_1.Range(start, position);
        const currentWord = document.getText(range).trim();
        const text = document.getText();
        const value = isValue(cssSchema, currentWord);
        const config = vscode_1.workspace.getConfiguration('sass-indented');
        let atRules = [], properties = [], values = [];
        if (value) {
            values = getValues(cssSchema, currentWord);
        }
        else {
            atRules = getAtRules(cssSchema, currentWord);
            properties = getProperties(cssSchema, currentWord, config.get('useSeparator', true));
        }
        const completions = [].concat(atRules, properties, values, sassSchema_1.default);
        return completions;
    }
}
exports.default = SassCompletion;
//# sourceMappingURL=sassAutocomplete.js.map