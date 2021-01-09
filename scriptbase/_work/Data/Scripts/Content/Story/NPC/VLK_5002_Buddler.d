instance VLK_5002_Buddler (Npc_Default)
{
    //-------- primary data --------

    name =                          Name_Buddler;
    npctype =                       npctype_mine_ambient;
    guild =                         GIL_VLK;
    level =                         3;


    voice =                         3;
    id =                            5002;


    //-------- abilities --------

    attribute[ATR_STRENGTH] =       15;
    attribute[ATR_STRENGTH] =       10;
    attribute[ATR_MANA_MAX] =       0;
    attribute[ATR_MANA] =           0;
    attribute[ATR_HITPOINTS_MAX] =  76;
    attribute[ATR_HITPOINTS] =      76;

    //-------- visuals --------
    //              animations
    Mdl_SetVisual       (self,"HUMANS.MDS");
    Mdl_ApplyOverlayMds (self,"Humans_Tired.mds");
    //              body mesh,              head mesh,              hairmesh,   face-tex,   hair-tex,   skin
    Mdl_SetVisualBody (self,"hum_body_Naked0",2,1,"Hum_Head_Bald", 69,  3, -1);

    B_Scale (self);
    Mdl_SetModelFatness (self, 0);

    fight_tactic    =   FAI_HUMAN_COWARD;

    //-------- Talents --------


    //-------- inventory --------

    EquipItem (self, ItMw_1h_Club_01);
    CreateInvItem (self, ItFoApple);


    //-------------Daily Routine-------------
    daily_routine = Rtn_FMstart_5002;

    //------------ //MISSIONs------------------

};

FUNC VOID Rtn_FMstart_5002 ()   //FM
{
    TA_PickOre      (00,00,23,00,"FM_105");
    TA_PickOre      (23,00,24,00,"FM_105");
};












