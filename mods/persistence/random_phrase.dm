var/global/list/eng_adjectives
var/global/list/eng_nouns

/datum/uniqueness_generator/phrase/Generate()
	if(!eng_adjectives)
		eng_adjectives = file2list('mods/persistence/english-adjectives.txt')
	if(!eng_nouns)
		eng_nouns = file2list('mods/persistence/english-nouns.txt')

	var/phrase = "[pick(eng_adjectives)] [pick(eng_nouns)]"
	return phrase