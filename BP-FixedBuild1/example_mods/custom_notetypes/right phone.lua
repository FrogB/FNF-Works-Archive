function onCreate()
  for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'right phone' and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_phone')
  		setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
  		setPropertyFromGroup('unspawnNotes', i, 'offset.x', -4)
		end
	end
end
function opponentNoteHit(id, data, type, sus)
  if type == 'right phone' then
    playAnim('dad', 'singSHIT', true)
    setProperty('dad.specialAnim', true)
  end
end