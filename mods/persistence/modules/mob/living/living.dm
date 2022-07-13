/mob/living/Move(a, b, flag)
	if(SSautosave.saving)
		return
	. = ..()

SAVED_VAR(/mob/living, pronoun_gender)
SAVED_VAR(/mob/living, pronouns)