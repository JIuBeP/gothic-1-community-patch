/*
 * #278 Female SVM subtitles don't match the audio (EN)
 */
func int G1CP_278_EN_WomanSvmOuMismatch() {
    return G1CP_ReplaceOuText("SVM_16_NotNow", "Just go! You're not supposed to talk to me!",
                                               "Shh, you're not allowed to talk to us.");
};
