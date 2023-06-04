/decl/cultural_info/culture/other
	name = "Other Culture"
	description = "You are from one of the many small, relatively unknown cultures scattered across the galaxy."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/cultural_info/culture/human
	name = "Human Culture"
	description = "You are from one of various planetary cultures of humankind."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/cultural_info/culture/synthetic
	name = "Artificial Intelligence"
	description = "You are a simple artificial intelligence created by humanity to serve a menial purpose."
	secondary_langs = list(
		/decl/language/machine,
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/cultural_info/culture/human_retro
	name = "Human Retrodoxy"
	description = "Many humans across the galaxy have an extreme facination with the past. You love all things retro and want to bring the past back into style."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)
/decl/cultural_info/culture/human_futurist
	name = "Human Futurism"
	description = "Humans never stoped dreaming of a sleeker, better life and neither have you. You're not stuck in the past, you want to create the lifestyle and aesthetic of the future!"
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)
/decl/cultural_info/culture/human_pragmatist
	name = "Human Pragmatist"
	description = "Some people are more focused on the immediate requirements for survival rather than aesthetic facinations or technocratic dreams. The hard lifestyle of your childhood has robbed you of any decadent culture."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign

	)
/decl/cultural_info/culture/synthetic/sanitize_cultural_name(new_name)
	return sanitize_name(new_name, allow_numbers = TRUE)
