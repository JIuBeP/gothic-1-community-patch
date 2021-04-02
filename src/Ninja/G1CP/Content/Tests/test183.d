/*
 * #183 Corristo sells High Robe multiple times
 *
 * The hero is given the heavy robe and the KDF guild and the condition function of the dialog is called.
 *
 * Expected behavior: The condition function will return FALSE.
 */
func int G1CP_Test_183() {
    // Check status of the test
    var int passed; passed = TRUE;

    // Find the dialog condition function
    var int funcId; funcId = MEM_GetSymbolIndex("KDF_402_Corristo_HEAVYARMOR_Condition");
    if (funcId == -1) {
        G1CP_TestsuiteErrorDetail("Dialog condition 'KDF_402_Corristo_HEAVYARMOR_Condition' not found");
        passed = FALSE;
    };

    // Find the symbol
    var int robeId; robeId = MEM_GetSymbolIndex("KDF_ARMOR_H");
    if (robeId == -1) {
        G1CP_TestsuiteErrorDetail("Item 'KDF_ARMOR_H' not found");
        passed = FALSE;
    };

    // Find the guild
    var int symbPtr; symbPtr = MEM_GetSymbol("GIL_KDF");
    if (!symbPtr) {
        G1CP_TestsuiteErrorDetail("Variable 'GIL_KDF' not found");
        passed = FALSE;
    };

    // Obtain guild value
    var int GIL_KDF; GIL_KDF = MEM_ReadInt(symbPtr + zCParSymbol_content_offset);

    // Backup hero guild
    var int guildBak; guildBak = hero.guild;
    var int guildTrueBak; guildTrueBak = Npc_GetTrueGuild(hero);

    // At the latest now, we need to stop if there are fails already
    if (!passed) {
        return FALSE;
    };

    // Set guild
    Npc_SetTrueGuild(hero, GIL_KDF);
    hero.guild = GIL_KDF;

    // Give the robe to the hero
    CreateInvItem(hero, robeId);

    // Backup self and other
    var C_Npc slfBak; slfBak = MEM_CpyInst(self);
    var C_Npc othBak; othBak = MEM_CpyInst(other);

    // Set self and other
    self  = MEM_CpyInst(hero);
    other = MEM_CpyInst(hero);

    // Call dialog condition function
    MEM_CallByID(funcId);
    var int ret; ret = MEM_PopIntResult();

    // Restore self and other
    self  = MEM_CpyInst(slfBak);
    other = MEM_CpyInst(othBak);

    // Remove the robe again
    Npc_RemoveInvItems(hero, robeId, 1);

    // Restore guild
    Npc_SetTrueGuild(hero, guildTrueBak);
    hero.guild = guildBak;

    // Check return value
    if (ret) {
        G1CP_TestsuiteErrorDetail("Dialog condition failed");
        return FALSE;
    } else {
        return TRUE;
    };
};