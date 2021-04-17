/*
 * Check if item exists
 */
func void G1CP_Testsuite_CheckItem(var string name) {
    if (!G1CP_IsItemInst(name)) {
        G1CP_TestsuiteErrorDetailSSS("Item instance '", name, "' not found");
        G1CP_TestsuiteStatusPassed = FALSE;
    };
};

/*
 * Check if item exists and return its symbol index
 */
func int G1CP_Testsuite_GetItemId(var string name) {
    // Check if item instance exists
    G1CP_Testsuite_CheckItem(name);

    // Return the item's symbol index
    return MEM_GetSymbolIndex(name);
};

/*
 * Check if integer variable exists
 */
func void G1CP_Testsuite_CheckIntVar(var string name, var int arrIdx) {
    if (!G1CP_IsIntVar(name, arrIdx)) {
        G1CP_TestsuiteErrorDetailSSS("Integer variable '", name, "' not found");
        G1CP_TestsuiteStatusPassed = FALSE;
    };
};

/*
 * Check if integer constant exists
 */
func void G1CP_Testsuite_CheckIntConst(var string name, var int arrIdx) {
    if (!G1CP_IsIntConst(name, arrIdx)) {
        G1CP_TestsuiteErrorDetailSSS("Integer constant '", name, "' not found");
        G1CP_TestsuiteStatusPassed = FALSE;
    };
};

/*
 * Check if string variable exists
 */
func void G1CP_Testsuite_CheckStringVar(var string name, var int arrIdx) {
    if (!G1CP_IsStringVar(name, arrIdx)) {
        G1CP_TestsuiteErrorDetailSSS("String variable '", name, "' not found");
        G1CP_TestsuiteStatusPassed = FALSE;
    };
};

/*
 * Check if string constant exists
 */
func void G1CP_Testsuite_CheckStringConst(var string name, var int arrIdx) {
    if (!G1CP_IsStringConst(name, arrIdx)) {
        G1CP_TestsuiteErrorDetailSSS("String constant '", name, "' not found");
        G1CP_TestsuiteStatusPassed = FALSE;
    };
};

/*
 * Check if info instance exists
 */
func void G1CP_Testsuite_CheckInfo(var string name) {
    // Check if info instance exists
    if (!G1CP_IsInfoInst(name)) {
        G1CP_TestsuiteErrorDetailSSS("Info instance '", name, "' not found");
        G1CP_TestsuiteStatusPassed = FALSE;
    };

    // Check if info instance is available in info manager
    if (!G1CP_GetInfo(name)) {
        G1CP_TestsuiteErrorDetailSSS("Info instance '", name, "' not available");
        G1CP_TestsuiteStatusPassed = FALSE;
    };
};

/*
 * Check if info instance exists and return its symbol index
 */
func int G1CP_Testsuite_GetInfoId(var string name) {
    // Check if info instance exists
    G1CP_Testsuite_CheckInfo(name);

    // Return the info instance's symbol index
    return MEM_GetSymbolIndex(name);
};

/*
 * Check if function exists
 */
func void G1CP_Testsuite_CheckFunc(var string name, var string signature, var string funcType) {
    if (Hlp_StrCmp(funcType, "")) {
        funcType = "Function";
    };
    if (!G1CP_IsFunc(name, signature)) {
        G1CP_TestsuiteErrorDetailSSSS(funcType, " '", name, "' not found");
        G1CP_TestsuiteStatusPassed = FALSE;
    };
};

/*
 * Check if dialog function exists
 */
func void G1CP_Testsuite_CheckDialogFunc(var string name) {
    G1CP_Testsuite_CheckFunc(name, "void|none", "Dialog function");
};

/*
 * Check if dialog function exists and return its symbol index
 */
func int G1CP_Testsuite_GetDialogFuncId(var string name) {
    // Check if dialog function exists
    G1CP_Testsuite_CheckDialogFunc(name);

    // Return the dialog function's symbol index
    return MEM_GetSymbolIndex(name);
};

/*
 * Check if dialog condition function exists
 */
func void G1CP_Testsuite_CheckDialogConditionFunc(var string name) {
    G1CP_Testsuite_CheckFunc(name, "int|none", "Dialog condition function");
};

/*
 * Check if dialog condition function exists and return its symbol index
 */
func int G1CP_Testsuite_GetDialogConditionFuncId(var string name) {
    // Check if dialog condition function exists
    G1CP_Testsuite_CheckDialogConditionFunc(name);

    // Return the dialog condition function's symbol index
    return MEM_GetSymbolIndex(name);
};

/*
 * Check if NPC exists and return it
 */
func MEMINT_HelperClass G1CP_Testsuite_GetNpc(var string name) {
    // Check if NPC instance exists
    if (!G1CP_IsNpcInst(name)) {
        G1CP_TestsuiteErrorDetailSSS("NPC instance '", name, "' not found");
        G1CP_TestsuiteStatusPassed = FALSE;
        MEM_NullToInst();
    } else {
        // Find NPC
        var int symbId; symbId = MEM_GetSymbolIndex(name);
        var C_Npc npc; npc = Hlp_GetNpc(symbId);
        if (!Hlp_IsValidNpc(npc)) {
            G1CP_TestsuiteErrorDetailSSS("NPC '", name, "' not valid");
            G1CP_TestsuiteStatusPassed = FALSE;
            MEM_NullToInst();
        } else {
            // Return NPC
            MEMINT_StackPushInst(npc);
        };
    };
};

/*
 * Check if item instance exists, create an item of that instance and return it
 */
func MEMINT_HelperClass G1CP_Testsuite_GetItem(var string name) {
    // Check if item instance exists
    if (!G1CP_IsItemInst(name)) {
        G1CP_Testsuite_CheckItem(name); // Does not return anything
        MEM_NullToInst();
    } else {
        // Backup global symbol
        var C_Item itemBak; itemBak = MEM_CpyInst(item);

        // Create the item locally using the Item_Helper
        var C_Item itm; // Need an intermediate instance
        var int symbId; symbId = MEM_GetSymbolIndex(name);
        if (Itm_GetPtr(symbId)) {
            itm = MEM_CpyInst(item); // Item_Helper assigns global symbol
            MEMINT_StackPushInst(itm);
        } else {
            G1CP_TestsuiteErrorDetailSSS("Item of instance '", name, "' could not be created");
            G1CP_TestsuiteStatusPassed = FALSE;
            MEM_NullToInst();
        };

        // Restore global symbol
        item = MEM_CpyInst(itemBak);
    };
};
