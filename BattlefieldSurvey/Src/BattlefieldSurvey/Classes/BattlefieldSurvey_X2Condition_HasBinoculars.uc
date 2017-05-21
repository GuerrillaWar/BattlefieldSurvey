class BattlefieldSurvey_X2Condition_HasBinoculars extends X2Condition;

var bool bFailIfCarrying;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;
  local int NumCarried;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

  NumCarried = UnitState.GetNumItemsByTemplateName('BS_Binoculars');

  if (NumCarried > 0 && bFailIfCarrying)
  {
    return 'AA_HasBinoculars';
  }
  else if (NumCarried == 0 && !bFailIfCarrying)
  {
    return 'AA_HasNoBinoculars';
  }

	return 'AA_Success';
}
