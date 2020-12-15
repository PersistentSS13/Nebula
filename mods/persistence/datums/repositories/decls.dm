/repository/decls/get_decl(decl_type)
	if(istype(decl_type, /decl))
		var/decl/D = decl_type
		return ..(D.type)
	
	return ..(decl_type)