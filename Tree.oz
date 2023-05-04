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

fun {Insert K W T}
	case T
	of leaf then tree(key:Y value:W leaf leaf)
	[] nil then tree(key:Y value:W nil nil)
	[] tree(key:Y value:V T1 T2) andthen K==Y then %remplace l'ancienne valeur par la nouvelle
		tree(key:K value:W T1 T2)
	[] tree(key:Y value:V T1 T2) andthen K<Y then 
		tree(key:Y value:V {Insert K W T1} T2)
	[] tree(key:Y value:V T1 T2) andthen K>Y then 
		tree(key:Y value:V T1 {Insert K W T2})
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun {StringToAtom Mot}
	if {Atom.is Mot} then
		Mot
	else {String.toAtom Mot}
	end 
end

declare 

fun {IncrScore List} %incrémente le score d'un mot de 1 (List est sous la forme: [Mot Score] avec Score en Int)
	NewScore in  
	case List
	of nil then nil
	[] Mot|Score then 
		case Score
		of nil then Mot|'2'|nil
		[] Diz|Unit then 
            case Unit
            of nil then 
                NewScore = {StringToInt Diz} + 1
                Mot|NewScore|nil
            end
		end
	end
end

fun {ParcourValueAux L Mot Acc} %parcoure les valeurs de la liste L pour voir si Mot est déjà dedans 
	%si Mot est déjà dans la liste, on incrémente sa valeur de 1
	%sinon on l'ajoute à la liste avec comme valeur initiale 1
	%dans les deux cas on retourne la liste modifiée (soir +1 soit mot ajouté)
	case L
	of nil then {Append Acc (Mot|1|nil)|nil}
	[] Mot1|Suite then
		if Mot1.1==Mot then {Append {Append Acc {IncrScore Mot1}|nil} Suite}
		else {ParcourValueAux Suite Mot {Append Acc Mot1|nil}} end
	end
end

L4 = [['non' 1] ['nope' 9] ['test' 99]]
{Browse {ParcourValueAux L4 {StringToAtom "nope"} nil}}
{Browse {ParcourValueAux L4 {StringToAtom "non"} nil}}
{Browse {ParcourValueAux L4 {StringToAtom "test"} nil}}
{Browse {ParcourValueAux L4 {StringToAtom "ttest"} nil}}

proc {AddInTree Tree Mots MotSuiv ?R}
	fun {P Tree Mots MotSuiv}
		if Mots==nil then Tree
		elseif MotSuiv==nil then Tree
		else case {Lookup Mots Tree}
			of notfound then 
				{Browse 42}{Insert Mots (MotSuiv|1|nil)|nil Tree} %si la key n'existe pas on l'ajoute
			[] found then %si la key existe on doit voir si le MotSuiv est déjà dans la value et si oui l'incrémenter si non l'ajouter
				case value
				of H|T then 
					{Browse 42}{Insert Mots {ParcourValueAux value MotSuiv nil} Tree}
				end
			end
		end
	end
in
	R = {P Tree {StringToAtom Mots} {StringToAtom MotSuiv}}
end

T = t(nil nil) %initialiser un arbre vide 

fun {AddSentenceinTree Tree List} %List = liste contenant tous les mots d'un fichier ou d'une phrase
	case List
	of Mot|T then 
		case T 
		of nil then List
		[] MotSuiv|_ then {AddSentenceinTree {AddInTree Tree Mot MotSuiv} T}
end