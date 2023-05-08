declare

%%%Fonctions de base pour manipuler les arbres%%%

fun {Lookup K T}
	case T
	of leaf then notfound
	[] tree(key:Y value:V T1 T2) andthen K==Y then
		found(V)
	[] tree(key:Y value:V T1 T2) andthen K<Y then
		{Lookup K T1}
	[] tree(key:Y value:V T1 T2) andthen K>Y then
		{Lookup K T2}
	end
end

fun {RemoveSmallest T}
	case T
	of leaf then none
	[] tree(key:X value:V T1 T2) then
		case {RemoveSmallest T1}
		of none then triple(T2 X V)
		[] triple(Tp Xp Vp) then
			triple(tree(key:X value:V Tp T2) Xp Vp)
		end
	end
end

fun {Delete K T}
	case T
	of leaf then leaf
	[] tree(key:Y value:W T1 T2) andthen K==Y then
		case {RemoveSmallest T2}
		of none then T1
		[]triple(Tp Yp Vp) then tree(key:Yp value:Vp T1 Tp) end
	[] tree(key:Y value:W T1 T2) andthen K<Y then
		tree(key:Y value W {Delete K T1} T2)
	[] tree(key:Y value:W T1 T2) andthen K>Y then
		tree(key:Y valueW T1 {Delete K T2})
	end
end

fun {Insert K T} 
	case T
	of leaf then tree(key:K value:1 leaf leaf)
	[] tree(key:Y value:V T1 T2) andthen K==Y then tree(key:K value:V+1 T1 T2)
	[] tree(key:Y value:V T1 T2) andthen K<Y then tree(key:Y value:V {Insert K T1} T2)
	[] tree(key:Y value:V T1 T2) andthen K>Y then tree(key:Y value:V T1 {Insert K T2})
	end
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun {StringToAtom Mot}
	if {Atom.is Mot} then
		Mot
	else {String.toAtom Mot}
	end 
end

fun {AddInTree Tree MotSuiv}
	case MotSuiv 
	of nil then Tree
	[] H|T then
		{Insert {StringToAtom H} Tree}
		{AddInTree Tree T}
	end
end