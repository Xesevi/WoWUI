local AS = unpack(AddOnSkins)

function AS:WorldStateScoreFrame()
	AS:SkinFrame(WorldStateScoreFrame)
	AS:StripTextures(WorldStateScoreFrameInset)

	AS:StripTextures(WorldStateScoreScrollFrame)
	AS:SkinScrollBar(WorldStateScoreScrollFrameScrollBar)

	AS:SkinCloseButton(WorldStateScoreFrameCloseButton)
	AS:SkinButton(WorldStateScoreFrameLeaveButton)

	for i = 1, WorldStateScoreScrollFrameScrollChildFrame:GetNumChildren() do
		local Button = _G["WorldStateScoreButton"..i]
		AS:SkinFrame(Button, nil, nil, true)
		AS:StyleButton(Button)
	end

	for i = 1, 3 do 
		AS:SkinTab(_G["WorldStateScoreFrameTab"..i])
	end
end

AS:RegisterSkin("Blizzard_WorldStateScoreFrame", AS.WorldStateScoreFrame)