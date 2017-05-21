class BattlefieldSurvey_X2Item_Binoculars extends X2Item config(BattlefieldSurvey);

var const config bool BinocularsAvailable;
var const config int BinocularsSupplyCost;
var const config int BinocularsBlackMarketCost;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

  if (default.BinocularsAvailable)
  {
    Items.AddItem(CreateBinoculars());
  }

	return Items;
}

static function X2DataTemplate CreateBinoculars()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'BS_Binoculars');
	Template.ItemCat = 'tech';
	Template.WeaponCat = 'utility';

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_OpticB_inv";
	Template.EquipSound = "StrategyUI_Medkit_Equip";

	Template.Abilities.AddItem('BS_BinocularsSurvey');

	Template.GameArchetype = "WP_Medikit.WP_Medikit";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = default.BinocularsBlackMarketCost;
	Template.PointsToComplete = 0;
	Template.Tier = 0;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.BinocularsSupplyCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
