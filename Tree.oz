declare

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


fun {Insert K W T}
	case T
	of leaf then tree(key:Y value:W leaf leaf)
	[] nil then tree(key:Y value:W nil nil)
	[] tree(key:Y value:V T1 T2) andthen K==Y then 
		tree(key:K value:W T1 T2)
	[] tree(key:Y value:V T1 T2) andthen K<Y then 
		tree(key:Y value:V {Insert K W T1} T2)
	[] tree(key:Y value:V T1 T2) andthen K>Y then 
		tree(key:Y value:V T1 {Insert K W T2})
	end
end

% Correct version of delete
% Uses helper function RemoveSmallest

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

fun {StringToAtom Mot}
	if {Atom.is Mot} then
		Mot
	else {String.toAtom Mot}
	end 
end

fun {IntToAtom I}
	case I
	of 0 then '0'
	[] 1 then '1'
	[] 2 then '2'
	[] 3 then '3'
	[] 4 then '4'
	[] 5 then '5'
	[] 6 then '6'
	[] 7 then '7'
	[] 8 then '8'
	[] 9 then '9'
	[] _ then {IntToAtom I div 10}#{Char.toAtom {Char.fromInt (I mod 10)}}
	end
end

fun {IncrScore List} NewScore in
	case List
	of nil then ['1']
	[] Mot|Score then 
		case Score
		of nil then Mot|'2'|nil
		[] Diz|Unit then 
			NewScore = {IntToAtom {StringToInt Diz} + 1}
			Mot|NewScore|nil 
		end
	end
end

proc {AddInTree Tree Mot MotSuiv ?R}
	fun {P Tree Mot MotSuiv}
		if Mot==nil then Tree
		elseif MotSuiv ==nil then Tree
		else case {Lookup Mot Tree}
			of notfound then
				{Insert Mot {IncrScore MotSuiv} Tree}
			[] found then  %si le mot est déjà dans l'arbre on regarde sa veleur 
				case value
				of nil then {Insert Mot {IncrScore MotSuiv|nil} Tree}
				[]H|T then  %si c'est une liste on vérifie si le mot suivant est aussi déjà là
					case H.1 %on regarde le premier mot de chaque sous-liste
					of MotSuiv then %si c'est le même mot, on augmente son score de 1
						{Insert Mot {IncrScore MotSuiv} Tree}
						%si c'est pas le bon mot faut parcourir toute la liste
					end 
				end 
			end
		end
	end
in
	R = {P Tree {StringToAtom Mot} {StringToAtom MotSuiv}}
end

fun {AddSentenceinTree List Tree}
	case List
	of nil then nil
	[] Mot|T then 
		case T 
		of nil then List
		[] MotSuiv|_ then {Insert {StringToAtom H} T.1 Tree} end 
end