instance TPL_1452_Templer (Npc_Default)
{
	//-------- primary data --------
	name 	=	NAME_MadTemplar2;
	npctype	=	NPCTYPE_GUARD;
	guild 	=	GIL_GUR;
	level 	=	100;

	voice 	=	8;
	id 		=	1452;

	//-------- abilities --------
	attribute[ATR_STRENGTH] =		70;
	attribute[ATR_DEXTERITY] =		65;
	attribute[ATR_MANA_MAX] =		0;
	attribute[ATR_MANA] =			0;
	attribute[ATR_HITPOINTS_MAX] =	250;
	attribute[ATR_HITPOINTS] =		250;

	//------ Protection -------
	protection	[PROT_BLUNT]		=	1000;
	protection	[PROT_EDGE]			=	1000;
	protection	[PROT_POINT]		=	1000;
	protection	[PROT_FIRE]			=	80;
	protection	[PROT_FLY]			=	80;
	protection	[PROT_MAGIC]		=	70;

	//-------- visuals --------
	// 				animations
	Mdl_SetVisual		(self,"HUMANS.MDS");
	Mdl_ApplyOverlayMds	(self,"Humans_Mage.mds");
	//			body mesh     ,bdytex,skin,head mesh     ,headtex,teethtex,ruestung
	Mdl_SetVisualBody (self,"hum_body_Naked0", 1, 1 ,"Hum_Head_Bald", 117,  2, TPL_ARMOR_M);

	B_Scale (self);
	Mdl_SetModelFatness(self,-1);

	fight_tactic	=	FAI_HUMAN_STRONG;

	//-------- Talente --------

	Npc_SetTalentSkill (self, NPC_TALENT_2H,1);

	//-------- inventory --------

	CreateInvItem (self, ItMw_2H_Sword_Light_02);
	CreateInvItem (self, ItFoSoup);
	CreateInvItem (self, ItMiJoint_1);
	CreateInvItem (self, ItFo_Potion_Health_02 );


	//-------------Daily Routine-------------
	daily_routine = Rtn_OT_1452;
};

FUNC VOID Rtn_start_1452 ()
{
     	TA_HostileGuard	(08,00,22,00,"TPL_408");
  	TA_HostileGuard	(22,00,08,00,"TPL_408");
};

FUNC VOID Rtn_OT_1452 ()
{
     	TA_HostileGuard	(08,00,22,00,"TPL_379");
  	TA_HostileGuard	(22,00,08,00,"TPL_379");
};
