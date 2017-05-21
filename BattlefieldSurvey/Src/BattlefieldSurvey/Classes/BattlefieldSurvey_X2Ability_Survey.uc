class BattlefieldSurvey_X2Ability_Survey extends X2Ability config(BattlefieldSurvey);

var config bool SurveyWithoutBinocularsAvailable;
var config int SurveySightRadiusBoost;
var config int SurveyBinocularsSightRadiusBoost;

var localized string SurveyEffectName;
var localized string SurveyEffectDescription;

static function array<X2DataTemplate> CreateTemplates()
{
  local array<X2DataTemplate> Templates;

  if (default.SurveyWithoutBinocularsAvailable)
  {
    Templates.AddItem(AddSurvey(false));
  }
  if (class'BattlefieldSurvey_X2Item_Binoculars'.default.BinocularsAvailable)
  {
    Templates.AddItem(AddSurvey(true));
  }

  return Templates;
}


static function X2AbilityTemplate AddSurvey(bool bBinoculars) {
  local X2AbilityTemplate                 Template;	
  local X2AbilityCost_ActionPoints        ActionPointCost;
  local X2Effect_PersistentStatChange     StatChange;
	local BattlefieldSurvey_X2Condition_HasBinoculars         UnitInventoryCondition;

  // Macro to do localisation and stuffs
  `CREATE_X2ABILITY_TEMPLATE(Template, bBinoculars ? 'BS_BinocularsSurvey' : 'BS_Survey');

  // Icon Properties
  Template.bDontDisplayInAbilitySummary = true;
  Template.IconImage = bBinoculars
    ? "img:///UILibrary_PerkIcons.UIPerk_evervigilant"
    : "img:///UILibrary_PerkIcons.UIPerk_overwatch";
  Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.EVAC_PRIORITY + 10;

  if (bBinoculars)
  {
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
  }
  else
  {
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
    Template.HideIfAvailable.AddItem('SUT_BinocularsSurvey');
  }

  Template.DisplayTargetHitChance = true;
  Template.AbilitySourceName = 'eAbilitySource_Standard';    // color of the icon
  // Activated by a button press; additionally, tells the AI this is an activatable
  Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
  Template.Hostility = eHostility_Neutral;

  Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
  // Only at single targets that are in range.
	Template.AbilityToHitCalc = default.DeadEye;
  Template.AbilityTargetStyle = default.SelfTarget;

  // Action Point
  ActionPointCost = new class'X2AbilityCost_ActionPoints';
  ActionPointCost.iNumPoints = 1;
  ActionPointCost.bConsumeAllPoints = true;
  Template.AbilityCosts.AddItem(ActionPointCost);	

  StatChange = new class'X2Effect_PersistentStatChange';
  StatChange.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
  StatChange.AddPersistentStatChange(
    eStat_SightRadius,
    bBinoculars
      ? default.SurveyBinocularsSightRadiusBoost
      : default.SurveySightRadiusBoost
  );
  StatChange.bRemoveWhenTargetDies = true;
  StatChange.bRemoveWhenSourceDamaged = true;
  StatChange.SetSourceDisplayInfo(ePerkBuff_Bonus, default.SurveyEffectName, default.SurveyEffectDescription, Template.IconImage);
  Template.AddShooterEffect(StatChange);

  if (!bBinoculars)
  {
    UnitInventoryCondition = new class'BattlefieldSurvey_X2Condition_HasBinoculars';
    UnitInventoryCondition.bFailIfCarrying = true;
    Template.AbilityShooterConditions.AddItem(UnitInventoryCondition);
  }

  // Targeting Method
  Template.TargetingMethod = class'X2TargetingMethod_TopDown';

  // MAKE IT LIVE!
  Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
  Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
  Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

  Template.bDisplayInUITooltip = false;
  Template.bDisplayInUITacticalText = false;

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bSkipPerkActivationActions = true;

  return Template;	
}


