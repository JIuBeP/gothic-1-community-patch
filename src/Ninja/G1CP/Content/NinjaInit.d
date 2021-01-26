/*
 * Menu initialization function called by Ninja every time a menu is opened
 */
func void Ninja_G1CP_Menu(var int menuPtr) {
    MEM_InitAll();

    // // Version check
    // if (NINJA_VERSION < 2308) {
    //     MEM_SendToSpy(zERR_TYPE_FATAL, "G1CP requires at least Ninja 2.3.08 or higher");
    // };

    // Initialize one-time-per-session fixes
    const int once = 0;
    if (!once) {
        Ninja_G1CP_MenuVersionNumber();
        Ninja_G1CP_TestSuite();
        Ninja_G1CP_001_FixNpcSleep();                                   // #1
        Ninja_G1CP_002_FixDoor();                                       // #2
        Ninja_G1CP_003_RegainDroppedWeapon();                           // #3
        Ninja_G1CP_007_PracticeSwordWithWeapon();                       // #7
        Ninja_G1CP_009_FixFlee();                                       // #9
        Ninja_G1CP_010_FollowWalkMode();                                // #10
        Ninja_G1CP_015_HoratioStrength();                               // #15
        Ninja_G1CP_016_ThorusBribeDialog();                             // #16
        Ninja_G1CP_017_JackalProtectionMoney();                         // #17
        Ninja_G1CP_018_BloodwynProtectionMoney();                       // #18
        Ninja_G1CP_019_ScorpioFightDialog();                            // #19
        Ninja_G1CP_020_KirgoGivesBeer();                                // #20
        Ninja_G1CP_024_CorKalomWrongQuest();                            // #24
        Ninja_G1CP_059_FixEquipBestWeapons();                           // #59

        once = 1;
    };
};


/*
 * Initialization function called by Ninja after "Init_Global" (G2) / "Init_<Levelname>" (G1)
 */
func void Ninja_G1CP_Init() {
    // Wrapper for "LeGo_Init" to ensure correct LeGo initialization without breaking the mod
    LeGo_MergeFlags(LeGo_ConsoleCommands | LeGo_AI_Function);

};
