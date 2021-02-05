/*
 * #79 Wolf teaches guards dexterity instead of bandits/mercs
 */
func int Ninja_G1CP_079_WolfDexDialog() {
    var int applied; applied = FALSE;

    // Find all necessary symbols
    var int funcId; funcId = MEM_FindParserSymbol("ORG_855_Wolf_Teach_Condition");
    var int cond1Id; cond1Id = MEM_FindParserSymbol("GIL_GRD");
    var int cond2Id; cond2Id = MEM_GetSymbol("C_NpcBelongsToNewCamp");
    var int funcExt; funcExt = MEM_FindParserSymbol("Npc_GetTrueGuild");

    // Check if all needed functions exist
    if (funcId != -1) && (cond1Id != -1) && (cond2Id) {

        // Get symbol content of GIL_GRD
        var int symbPtr; symbPtr = MEM_GetSymbolByIndex(cond1Id);
        if (!symbPtr) {
            return FALSE;
        };
        var int GIL_GRD; GIL_GRD = MEM_ReadInt(symbPtr + zCParSymbol_content_offset);

        // Get the byte code of the dialog condition function
        var int tokens; tokens = MEM_ArrayCreate();
        var int params; params = MEM_ArrayCreate();
        var int positions; positions = MEM_ArrayCreate();
        MEMINT_TokenizeFunction(funcID, tokens, params, positions);
        var int len; len = MEM_ArraySize(tokens);

        // Iterate over the tokens
        repeat(i, len); var int i;

            var int tok; tok = MEM_ArrayRead(tokens, i);
            var int par; par = MEM_ArrayRead(params, i);

            // Find "GIL_GRD"
            if (((par == cond1Id) && (tok  == zPAR_TOK_PUSHVAR))  // GIL_GRD (constant)
            ||  ((par == GIL_GRD) && (tok  == zPAR_TOK_PUSHINT))) // GIL_GRD (literal integer)
            && (i+3 < len) { // Prevent error below

                // Verify the context: (Npc_GetTrueGuild(xxxx) == GIL_GRD)
                if (MEM_ArrayRead(tokens, i+1) == zPAR_TOK_PUSHINST)
                && (MEM_ArrayRead(tokens, i+2) == zPAR_TOK_CALLEXTERN)
                && (MEM_ArrayRead(params, i+2) == funcExt)
                && (MEM_ArrayRead(tokens, i+3) == zPAR_OP_EQUAL) {

                    /* Overwrite the entire condition: (C_NpcBelongsToNewCamp(xxxx) == TRUE)

                        Pos  Original                                       Overwrite to
                         0   zPAR_TOK_PUSHVAR/INT   GIL_GRD                 zPAR_TOK_PUSHVAR   TRUE
                         5   zPAR_TOK_PUSHINST      xxxx
                        10   zPAR_TOK_CALLEXTERN    Npc_GetTrueGuild        zPAR_TOK_CALL      C_NpcBelongsToNewCamp
                        15   zPAR_OP_EQUAL
                    */
                    var int pos; pos = MEM_ArrayRead(positions, i);
                    MEM_WriteByte(pos,    zPAR_TOK_PUSHVAR);
                    MEM_WriteInt( pos+1,  MEM_FindParserSymbol("TRUE"));
                    MEM_WriteByte(pos+10, zPAR_TOK_CALL);
                    MEM_WriteInt( pos+11, MEM_ReadInt(cond2Id + zCParSymbol_content_offset));

                    // That's all
                    applied = TRUE;
                    break;
                };
            };
        end;

        // Free all the arrays
        MEM_ArrayFree(tokens);
        MEM_ArrayFree(params);
        MEM_ArrayFree(positions);
    };

    return applied;
};