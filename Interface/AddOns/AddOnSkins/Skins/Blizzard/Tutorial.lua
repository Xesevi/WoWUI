local AS = unpack(AddOnSkins)

function AS:Blizzard_Tutorial()
	AS:SkinFrame(TutorialFrame)
	AS:SkinCloseButton(TutorialFrameCloseButton)
	AS:SkinNextPrevButton(TutorialFramePrevButton)
	AS:SkinNextPrevButton(TutorialFrameNextButton)
	AS:SkinButton(TutorialFrameOkayButton)
	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:Point("LEFT", TutorialFrameNextButton,"RIGHT", 10, 0)
end

AS:RegisterSkin('Blizzard_Tutorial', AS.Blizzard_Tutorial)