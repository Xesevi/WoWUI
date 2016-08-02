local AS = unpack(AddOnSkins)

function AS:Blizzard_GarrisonCapacitiveDisplayFrame(event, addon)
	if addon == 'Blizzard_GarrisonUI' or IsAddOnLoaded('Blizzard_GarrisonUI') then
		AS:StripTextures(GarrisonCapacitiveDisplayFrame, nil, nil, true)
		AS:CreateBackdrop(GarrisonCapacitiveDisplayFrame)
		AS:StripTextures(GarrisonCapacitiveDisplayFrameInset)
		AS:SkinCloseButton(GarrisonCapacitiveDisplayFrame.CloseButton)
		AS:SkinButton(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton, true)
		AS:UnregisterSkinEvent('Blizzard_Garrison', 'ADDON_LOADED')
	end
end

AS:RegisterSkin('Blizzard_Garrison', AS.Blizzard_GarrisonCapacitiveDisplayFrame, 'ADDON_LOADED')