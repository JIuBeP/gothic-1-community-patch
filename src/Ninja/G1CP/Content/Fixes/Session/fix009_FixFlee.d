/*
 * #9 NPCs freeze when fleeing
 */
func void Ninja_G1CP_009_FixFlee() {
    HookDaedalusFuncS("ZS_Flee_Loop", "Ninja_G1CP_009_FixFlee_Hook");
};

/*
 * This function intercepts the NPC state to introduce more conditions
 */
func int Ninja_G1CP_009_FixFlee_Hook() {
    // Temporarily disable AI_Wait
    const int AI_Wait_popped = 6644536; //0x656338
    const int once = 0;
    if (!once) {
        MemoryProtectionOverride(AI_Wait_popped, 4);
        once = 1;
    };
    const int orig = 3296983179; /*8B F8 83 C4*/
    const int newb = 3296984881; /*31 FF 83 C4*/
    if (MEM_ReadInt(AI_Wait_popped) == orig) {
        MEM_WriteInt(AI_Wait_popped, newb);
    };

    // Call the original function (There might be other important changes that we do not want to overwrite!)
    ContinueCall();
    var int ret; ret = MEM_PopIntResult();

    // Re-enable the AI_Wait
    if (MEM_ReadInt(AI_Wait_popped) == newb) {
        MEM_WriteInt(AI_Wait_popped, orig);
    };

    // Return original return value
    return ret;
};