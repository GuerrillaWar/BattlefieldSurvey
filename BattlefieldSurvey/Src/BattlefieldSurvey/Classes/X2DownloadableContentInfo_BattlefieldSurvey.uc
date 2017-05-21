class X2DownloadableContentInfo_BattlefieldSurvey extends X2DownloadableContentInfo Config(Game);

static event OnPostTemplatesCreated()
{
  `log("BattlefieldSurvey :: Present And Correct");
  AddSoldierAbilities();
}



static function AddSoldierAbilities ()
{
  local array<X2DataTemplate> CharTemplates;
  local X2DataTemplate CharTemplate;
  local X2CharacterTemplate CharacterTemplate;
  local X2CharacterTemplateManager Manager;

  Manager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

  CharTemplates.Length = 0;
  Manager.FindDataTemplateAllDifficulties('Soldier', CharTemplates);
  foreach CharTemplates(CharTemplate)
  {
    CharacterTemplate = X2CharacterTemplate(CharTemplate);
    if (class'BattlefieldSurvey_X2Ability_Survey'.default.SurveyWithoutBinocularsAvailable)
    {
      CharacterTemplate.Abilities.AddItem('BS_Survey');
    }
  }
}

