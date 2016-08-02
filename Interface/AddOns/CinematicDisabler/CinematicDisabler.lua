MovieFrame:SetScript("OnEvent", function() GameMovieFinished() end)
hooksecurefunc(CinematicFrame,"Show", function() CinematicFrame.closeDialog:Hide(); CinematicFrame_CancelCinematic(); end)