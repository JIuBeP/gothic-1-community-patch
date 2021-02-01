/*
 * #38 Snaf's Nek dialog disappears
 *
 * The quest "Snaf's Recipe" is set to successful and the condition function of the dialog is called.
 *
 * Expected behavior: The condition function will return TRUE.
 */
func int Ninja_G1CP_Test_038() {
    // Check status of the test
    var int passed; passed = TRUE;

    // Define possibly missing symbols locally
    const int LOG_SUCCESS = 2;

    // Check if the dialog exists
    var int funcId; funcId = MEM_FindParserSymbol("DIA_Snaf_WhereNek_Condition");
    if (funcId == -1) {
        Ninja_G1CP_TestsuiteErrorDetail("Dialog function 'DIA_Snaf_WhereNek_Condition' not found");
        passed = FALSE;
    };

    // Find Snaf
    var int symbId; symbId = MEM_FindParserSymbol("VLK_581_Snaf");
    if (symbId == -1) {
        Ninja_G1CP_TestsuiteErrorDetail("Npc 'VLK_581_Snaf' not found");
        passed = FALSE;
    };

    // Check if Snaf exists in the world
    var C_Npc snaf; snaf = Hlp_GetNpc(symbId);
    if (!Hlp_IsValidNpc(snaf)) {
        Ninja_G1CP_TestsuiteErrorDetail("Npc 'VLK_581_Snaf' is not a valid NPC");
        passed = FALSE;
    };

    // Check if variable exists
    var int questPtr; questPtr = MEM_GetSymbol("Snaf_Zutaten");
    if (!questPtr) {
        Ninja_G1CP_TestsuiteErrorDetail("Variable 'Snaf_Zutaten' not found");
        passed = FALSE;
    };
    questPtr += zCParSymbol_content_offset;

    // At the latest now, we need to stop if there are fails already
    if (!passed) {
        return FALSE;
    };

    // Backup values
    var int questBak; questBak = MEM_ReadInt(questPtr); // Variable
    var C_Npc slfBak; slfBak = MEM_CpyInst(self);       // Self
    var C_Npc othBak; othBak = MEM_CpyInst(other);      // Other

    // Set new values
    MEM_WriteInt(questPtr, LOG_SUCCESS);                // Variable
    self  = MEM_CpyInst(snaf);                          // Self
    other = MEM_CpyInst(hero);                          // Other

    // Call dialog condition function
    MEM_CallByID(funcId);
    var int ret; ret = MEM_PopIntResult();

    // Restore values
    self  = MEM_CpyInst(slfBak);                        // Self
    other = MEM_CpyInst(othBak);                        // Other
    MEM_WriteInt(questPtr, questBak);                   // Variable

    // Check return value
    if (ret) {
        return TRUE;
    } else {
        Ninja_G1CP_TestsuiteErrorDetail("Dialog condition failed");
        return FALSE;
    };
};
