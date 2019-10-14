"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const comparers_1 = require("./vs/base/common/comparers");
let IDS = 0;
class SymbolEntry {
    constructor(symbol) {
        this.labelHighlights = [];
        this.id = (IDS++).toString();
        this.bearing = symbol;
    }
    getSymbol() {
        return this.bearing;
    }
    getLabel() {
        return this.bearing.name;
    }
    getResource() {
        return this.bearing.location.uri;
    }
    /**
     * A unique identifier for the entry
     */
    getId() {
        return this.id;
    }
    /**
     * Allows to set highlight ranges that should show up for the entry label and optionally description if set.
     */
    setHighlights(labelHighlights) {
        this.labelHighlights = labelHighlights;
    }
    /**
     * Allows to return highlight ranges that should show up for the entry label and description.
     */
    getHighlights() {
        return this.labelHighlights;
    }
    static compare(elementA, elementB, searchValue) {
        const elementAName = elementA.getLabel().toLowerCase();
        const elementBName = elementB.getLabel().toLowerCase();
        if (elementAName === elementBName) {
            return 0;
        }
        return compareEntries(elementA, elementB, searchValue);
    }
}
exports.SymbolEntry = SymbolEntry;
/**
 * A good default sort implementation for quick open entries respecting highlight information
 * as well as associated resources.
 */
function compareEntries(elementA, elementB, lookFor) {
    // Give matches with label highlights higher priority over
    // those with only description highlights
    const labelHighlightsA = elementA.getHighlights() || [];
    const labelHighlightsB = elementB.getHighlights() || [];
    if (labelHighlightsA.length && !labelHighlightsB.length) {
        return -1;
    }
    if (!labelHighlightsA.length && labelHighlightsB.length) {
        return 1;
    }
    // Fallback to the full path if labels are identical and we have associated resources
    let nameA = elementA.getLabel();
    let nameB = elementB.getLabel();
    if (nameA === nameB) {
        const resourceA = elementA.getResource();
        const resourceB = elementB.getResource();
        if (resourceA && resourceB) {
            nameA = resourceA.fsPath;
            nameB = resourceB.fsPath;
        }
    }
    return comparers_1.compareAnything(nameA, nameB, lookFor);
}
//# sourceMappingURL=sorting.js.map