/*
 * #78 Humans don't recognise orcs as monsters
 */
func int G1CP_078_HumanAttackOrc() {
    var int funcId;   funcId   = MEM_GetSymbolIndex("C_NpcIsDangerousMonster");
    var int needleId; needleId = MEM_GetSymbolIndex("C_NpcIsMonster");
    var int isOrcId;  isOrcId  = MEM_GetSymbolIndex("C_NpcIsOrc");
    var int replacId; replacId = MEM_GetFuncId(G1CP_078_IsMonsterOrOrc);

    if (funcId != -1) && (needleId != -1) && (isOrcId != -1) {
        var int count; count = G1CP_ReplaceCall(funcId, needleId, replacId);
        return (count > 0);
    } else {
        return FALSE;
    };
};

/*
 * This function intercepts all calls to "C_NpcIsMonster" in "C_NpcIsDangerousMonster"
 */
func int G1CP_078_IsMonsterOrOrc(var C_Npc slf) {
    G1CP_ReportFuncToSpy();

    // These functions are confirmed to exist by the above function

    // Original function call
    var int cond1;
    MEM_PushInstParam(slf);
    MEM_CallByString("C_NpcIsMonster");
    cond1 = MEM_PopIntResult();

    // Additional condition
    var int cond2;
    MEM_PushInstParam(slf);
    MEM_CallByString("C_NpcIsOrc");
    cond2 = MEM_PopIntResult();

    // Sneak in an additional condition
    return (cond1) || (cond2);
};
