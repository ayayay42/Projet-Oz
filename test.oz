declare 

fun {Insert K T} 
	case T
	of leaf then tree(key:K value:1 leaf leaf)
	[] tree(key:Y value:V T1 T2) andthen K==Y then tree(key:K value:V+1 T1 T2)
	[] tree(key:Y value:V T1 T2) andthen K<Y then tree(key:Y value:V {Insert K T1} T2)
	[] tree(key:Y value:V T1 T2) andthen K>Y then tree(key:Y value:V T1 {Insert K T2})
	end
 end

fun {StringToAtom Mot}
	if {Atom.is Mot} then
		Mot
	else {String.toAtom Mot}
	end 
end

%Words est le resultat de {ParseBetter}
fun {GetFollowingWord Words Looking Following} 
    case Words
    of nil then Following
    [] H|T then
       if H == Looking then
      {GetFollowingWord T Looking {Append Following T.1.2.1}}
       else {GetFollowingWord T Looking Following} end
    end
 end

%MotSuiv est le resultat de {GetFollowingWord}
fun {AddInTree Tree MotSuiv}
	case MotSuiv 
	of nil then Tree
	[] H|T then
		{Insert {StringToAtom H} Tree}
		{AddInTree Tree T}
	end
end