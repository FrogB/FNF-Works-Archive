function onEvent(name, v1, v2)
	if name == 'Toggle Thorns Effect' then
		if v1 == '1' then
			addVCREffect('camgame')
			addScanlineEffect('camgame')
			addGreyscaleEffect('camgame')
			addGrayscaleEffect('camgame')
		end
		else if v1 == '0' then
			clearShadersFromCamera('camgame')
			clearEffects('camgame')
		end
	end
end
