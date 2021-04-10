/*
 * Retrieve function bytecode start address. If invalid symbol index, it returns zero.
 */
func int G1CP_GetFuncStart(var int funcId) {
    // Assert that it's a function or prototype or instance function
    if (funcId < 0)  || (funcId >= MEM_Parser.symtab_table_numInArray) {
        return 0;
    };

    // Only allow non-external functions, prototypes and constant instances (instance functions)
    var zCPar_Symbol symb; symb = _^(MEM_GetSymbolByIndex(funcId));
    var int type; type = symb.bitfield & zCPar_Symbol_bitfield_type;
    if ((symb.bitfield & zPAR_FLAG_CONST) && (!(symb.bitfield & zPAR_FLAG_EXTERNAL))
    &&  ((type == zPAR_TYPE_FUNC) || (type == zPAR_TYPE_INSTANCE)))
    ||  (type == zPAR_TYPE_PROTOTYPE) { // Not constant
        return symb.content + MEM_Parser.stack_stack;
    } else {
        return 0;
    };
};

/*
 * Retrieve function bytecode end address (i.e. address of last byte). If invalid symbol index, it returns zero.
 * This function works on the same principle and is largely copied from "MEM_GetFuncIDByOffset" in Ikarus.
 */
func int G1CP_GetFuncEnd(var int funcId) {
    const int funcStartsArray = 0;
    if (!funcStartsArray) {
        MEM_InitAll(); // Make sure it was created
        funcStartsArray = G1CP_GetIntVar("MEM_GetFuncIDByOffset.funcStartsArray", 0, 0);
    };

    // Assert that it's a function or prototype or instance function
    var int offset; offset = G1CP_GetFuncStart(funcId) - MEM_Parser.stack_stack;
    if (offset < 0) {
        return 0;
    };

    var zCArray array; array = _^(funcStartsArray);

    // Binary search
    var int res;  res  = -1;
    var int low;  low  =  0;
    var int high; high = array.numInArray / 2 - 1;

    while(1);
        /* invariant: array[low] <= offset <= array[high]
                      low < high                          */

        var int med; med = (low + high) / 2; // low <= med < high
        var int medOffset; medOffset = MEM_ReadIntArray(array.array, 2*med);

        if (medOffset >= offset) {
            high = med; // Progress because med < high
        } else {
            if (low == med) {
                // Can only occur if low == high - 1
                if (MEM_ReadIntArray(array.array, 2*high) <= offset) {
                    res = high;
                } else {
                    res = low;
                };
            } else {
                low = med; // Progress because low < med
            };
        };

        if (low == high) {
            res = low;
        };

        if (res != -1) {
            if (2 * (res+1) < array.numInArray) {
                // Instead of in "MEM_GetFuncIDByOffset", return here the offset of the next function
                return MEM_ReadIntArray(array.array, 2 * (res+1)) + MEM_Parser.stack_stack - 1;
            } else {
                return MEM_Parser.stack_stacklast - 1;
            };
        };
    end;
};
