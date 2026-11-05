//============================================================================
// 1.27a polyfills for symbols Wurst may emit (not present as natives on 1.27a).
// Safe here: Wurst only uses BlzBitOr to OR disjoint power-of-two masks.
//============================================================================
function BlzBitOr takes integer x, integer y returns integer
	return x + y
endfunction
