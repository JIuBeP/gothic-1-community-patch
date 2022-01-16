/*
 * #173 Spelling - Gomez' Key: "Gomez' Truhen" (DE)
 */
func int G1CP_Test_173() {
    G1CP_Testsuite_CheckLang(G1CP_Lang_DE);
    var C_Item itm; itm = G1CP_Testsuite_CreateItem("ItKe_Gomez_01");
    G1CP_Testsuite_CheckPassed();

    return G1CP_Testsuite_InspectItemString(itm, "text[0]", "�ffnet Gomez' Truhen");
};
