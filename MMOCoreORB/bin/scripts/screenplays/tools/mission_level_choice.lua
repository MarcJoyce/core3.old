--Allows players to select a mission level range, regardless of their own combat level

mission_level_choice = ScreenPlay:new {
    numberOfActs = 1,

    levels = {
        {levelRange = "Reset Level Range", levelSelect = 0},
        {levelRange = "Easiest", levelSelect = 1},
        {levelRange = "Mid 1", levelSelect = 2},
        {levelRange = "Mid 2", levelSelect = 12},
        {levelRange = "Mid 3", levelSelect = 25},
        {levelRange = "High 1", levelSelect = 35},
        {levelRange = "High 2", levelSelect = 45},
        {levelRange = "High 3", levelSelect = 60},
        {levelRange = "Hard", levelSelect = 135},
        {levelRange = "Hardest", levelSelect = 200},
    }
}

function mission_level_choice:start()

end

function mission_level_choice:openWindow(pPlayer)
    if (pPlayer == nil) then
        return
    end

    self:showLevels(pPlayer)

end

function mission_level_choice:showLevels(pPlayer)
    local cancelPressed = (eventIndex == 1)

    if (cancelPressed) then
        return
    end

    local sui = SuiListBox.new("mission_level_choice", "levelSelection") -- calls level selection on a SUI window event

    sui.setTargetNetworkId(SceneObject(pPlayer):getObjectID())

    sui.setTitle("Mission level selection")

    local text = "Use this menu to select a mission level range to aim for. After you have chosen a range, use the mission terminal to get a selection of missions.\n\nIf no missions are shown, it is because no missions in that level range exist for this planet. You will need to choose another range.\n\nWhen you want to back to 'normal' offering of missions for your skill level, just choose Reset Level Range."

    sui.setPrompt(text)

    for i = 1, #self.levels, 1 do
        sui.add(Self.levels[i].levelRange, "")
    end

    sui.sendTo(pPlayer)
end

function  mission_level_choice:levelSelection(pPlayer, pSui, eventIndex, args)

	local cancelPressed = (eventIndex == 1)

	if (cancelPressed) then
		return 
	end

	if (args == "-1") then
		CreatureObject(pPlayer):sendSystemMessage("No level selected...")
		return
	end

	local selectedLevelIndex = tonumber(args)+1

	local selectedLevel = self.levels[selectedLevelIndex].levelSelect
	local selectedRange = self.levels[selectedLevelIndex].levelRange

	writeScreenPlayData(pPlayer, "mission_level_choice", "levelChoice", selectedLevel) 

	if (tonumber(selectedLevel) == 0) then
		CreatureObject(pPlayer):sendSystemMessage("You have selected: " .. selectedRange .. ".  You may now choose missions suited to your own skill/group level.")
	else	
		CreatureObject(pPlayer):sendSystemMessage("You have selected: " .. selectedRange .. ".  These missions would be considered suitable for a player or group of level " .. selectedLevel .. ".")

	end

end