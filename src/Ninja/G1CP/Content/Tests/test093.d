/*
 * #93 Spelling - Horatio: "zuzuschlagen" (DE)
 *
 * The faulty log topic entry will be temporarily created and the fix is called, then the dialog function will be
 * called to check if the entry was correctly created there, too.
 *
 * Expected behavior: The wording of the log topic entry will be correct in both cases.
 */
func int G1CP_Test_093() {
    var int passed; passed = TRUE;

    // Define possibly missing symbols locally
    const int LOG_MISSION = 0;
    const int LOG_RUNNING = 1;

    // Define variables for specific test
    // I'm sorry for not breaking the line at 120 characters
    const string wrongLogEntry = "Horatio, ein Bauer auf den Reisfeldern des Neuen Lagers will mir beibringen, st�rker zuzuschalgen. Doch irgendwie habe ich noch nicht die richtige Antwort auf seine Frage WOZU gefunden.";
    const string rightLogEntry = "Horatio, ein Bauer auf den Reisfeldern des Neuen Lagers will mir beibringen, st�rker zuzuschlagen. Doch irgendwie habe ich noch nicht die richtige Antwort auf seine Frage WOZU gefunden.";
    const string logTopicName = "CH1_HoratiosTeachings";
    const string dialogFunctionName = "DIA_Horatio_PleaseTeachSTR_Info";
    const int fixNumber = 93;

    // Define variables for concatenated strings
    var string msg;
    var string newName;

    // Check language first
    if (G1CP_Lang != G1CP_Lang_DE) {
        G1CP_TestsuiteErrorDetail("Test applicable for German localization only");
        return TRUE; // True?
    };

    // Check if the constant exists
    if (MEM_GetSymbolIndex(logTopicName) == -1) {
        msg = ConcatStrings("Variable '", logTopicName);
        msg = ConcatStrings(msg, "' not found");
        G1CP_TestsuiteErrorDetail(msg);
        passed = FALSE;
    };

    // Check if the dialog function exists
    var int funcId; funcId = MEM_GetSymbolIndex(dialogFunctionName);
    if (funcId == -1) {
        msg = ConcatStrings("Dialog function '", dialogFunctionName);
        msg = ConcatStrings(msg, "' not found");
        G1CP_TestsuiteErrorDetail(msg);
        passed = FALSE;
    };

    // At the latest now, we need to stop if there are fails already
    if (!passed) {
        return FALSE;
    };

    // Retrieve the content of the log topic string constant
    var string topic; topic = G1CP_GetStringConst(logTopicName, "G1CP invalid string");

    // Backup the status of the log topic if it exists already
    newName = ConcatStrings("G1CP test ", IntToString(fixNumber));
    newName = ConcatStrings(newName, " temporary");
    G1CP_LogRenameTopic(topic, newName);

    // First pass: Create the log topic with the faulty entry and see if the fix will update it

    // Create the topic
    Log_CreateTopic(topic, LOG_MISSION);
    Log_SetTopicStatus(topic, LOG_RUNNING);
    Log_AddEntry(topic, wrongLogEntry);

    // Trigger the fix (careful now, don't overwrite the fix status!)
    var int r; r = G1CP_093_DE_LogEntryHoratio();

    // Check if it was updated
    if (G1CP_LogHasEntry(topic, wrongLogEntry)) {
        G1CP_TestsuiteErrorDetail("Log topic entry (incorrect) remained unchanged");
        passed = FALSE;
    };
    if (!G1CP_LogHasEntry(topic, rightLogEntry)) {
        G1CP_TestsuiteErrorDetail("Log topic entry (correct) does not exist");
        passed = FALSE;
    };
    G1CP_LogRemoveTopic(topic);

    // Second pass: Call the dialog function and observe if it creates the corrected entry

    // Backup self and other
    var C_Npc slfBak; slfBak = MEM_CpyInst(self);
    var C_Npc othBak; othBak = MEM_CpyInst(other);

    // Set self and other
    self  = MEM_CpyInst(hero);
    other = MEM_CpyInst(hero);

    MEM_CallByID(funcId);

    // Restore self and other
    self  = MEM_CpyInst(slfBak);
    other = MEM_CpyInst(othBak);

    // Stop the output units
    Npc_ClearAIQueue(hero);
    AI_StandUpQuick(hero);

    // Check if it was updated
    if (G1CP_LogHasEntry(topic, wrongLogEntry)) {
        G1CP_TestsuiteErrorDetail("Log topic entry was created with incorrect wording");
        passed = FALSE;
    };
    if (!G1CP_LogHasEntry(topic, rightLogEntry)) {
        G1CP_TestsuiteErrorDetail("Log topic entry was not added by the dialog function");
        passed = FALSE;
    };
    G1CP_LogRemoveTopic(topic);

    // Restore the topic to how it was before
    G1CP_LogRenameTopic(newName, topic);

    // Return success
    return passed;
};
