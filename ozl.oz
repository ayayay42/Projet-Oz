declare

%stores the content of the file who's path is FilePath in the variable Save
fun {ReadFile FilePath} 
   Save
   F = {New Open.file init(name:FilePath flags:[read])}
   {F read(list:Save size:all)}
   {F close}
in
   Save 
end

%concat two strings 
fun {Concat S1 S2}  
   case S1 of H|T then H|{Concat T S2} [] nil then S2 end
end

%Transforms a string in a list
fun {StringToList Sentence String Temporary} 
   case String
   of nil then {Append Sentence [{StringToAtom  Temporary}]}
   [] H|T then
      case {Char.type H}
      of lower then {StringToList Sentence T {Concat Temporary [H]}}
      [] upper then {StringToList Sentence T {Concat Temporary [{Char.toLower H}]}}
      [] digit then {StringToList Sentence T {Concat Temporary [H]}}
      [] punct then
	 if Temporary == nil then {StringToList Sentence T nil}
	 else {StringToList {Append Sentence [{StringToAtom  Temporary}]} T nil} end
      [] space then
	 if Temporary == nil then {StringToList Sentence T nil}
	 else {StringToList {Append Sentence [{StringToAtom  Temporary}]} T nil} end
      else {StringToList Sentence T nil} end
      
   end
end

%TO COMMENT
fun {ParseBetter Parsed List}
   case Parsed
   of nil then List
   [] H|T then
      if T == nil then List
      else {ParseBetter T {Append List [{Concat [H] [T.1]}]}} end
   end
end
 
fun {GetFollowingWordList Following}
   body
end
%Gets the words that follow the two words passed as an argument
fun {GetFollowingWord Words Looking Following} 
   %Words: liste de liste avec chaque paire de mots
   %Looking: mot qu'on recherche (input)
   %Following: liste vide qu'on remplira avec les mots qui suivent l'input
   case Words
   of nil then Following
   [] H|T then
      if H == Looking then
	 {Browse T.1.2.1}
	 {GetFollowingWord T Looking {ParcourValueAux Following T.1.2.1 nil}}
      else {GetFollowingWord T Looking Following} end
   end
end

%incrémente le score d'un mot de 1 (List est sous la forme: [Mot Score] avec Score en Int)
fun {IncrScore List} 
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

%parcoure les valeurs de la liste L pour voir si Mot est déjà dedans 
%si Mot est déjà dans la liste, on incrémente sa valeur de 1
%sinon on l'ajoute à la liste avec comme valeur initiale 1
%dans les deux cas on retourne la liste modifiée (soir +1 soit mot ajouté)
fun {ParcourValueAux L Mot Acc}
	case L
	of nil then {Append Acc (Mot|1|nil)|nil}
	[] Mot1|Suite then
		if Mot1.1==Mot then {Append {Append Acc {IncrScore Mot1}|nil} Suite}
		else {ParcourValueAux Suite Mot {Append Acc Mot1|nil}} end
	end
end

L = {ReadFile "Documents/Projet-Oz/tweets/part_1.txt"}
M = {StringToList nil L nil}
N =  {ParseBetter M nil}
{Browse N}
{Browse {GetFollowingWord N [must go] nil}}

%TO COMMENT
fun {ThroughAllFiles N Looking List} A B C in
   if N == 209 then
      List
   else
      if N == 1 then
         A = {ReadFile "Documents/Projet-Oz/tweets/part_"#N#".txt"}
	 B = {StringToList nil A nil}
	 C = {ParseBetter B nil}
	 {ThroughAllFiles N+1 Looking {GetFollowingWord C Looking nil}}
      else
	 A = {ReadFile "Documents/Projet-Oz/tweets/part_"#N#".txt"}
	 B = {StringToList nil A nil}
	 C = {ParseBetter B nil}
	 {ThroughAllFiles N+1 Looking {GetFollowingWord C Looking List}}
      end
   end
end

%TO COMMENT
fun {Sort Xs}
   fun {BubbleSort Xs}
      case Xs
      of X1|X2|Xr andthen X2.2.1 > X1.2.1 then
	 X2|{BubbleSort X1|Xr}
      [] X1|X2|Xr andthen X1.2.1 >= X2.2.1 then
	 X1|{BubbleSort X2|Xr}
      [] X|nil then X|nil
      end
   end
%verif si les fun sont bien identées et nommées
   fun {Sort Xs I}
      if I > 0 then {Sort {BubbleSort Xs} I-1}
      else Xs
      end
   end
in
   {Sort Xs {Length Xs}}
end

{Browse {Sort {ThroughAllFiles 1 ['of' it] nil}}}



%{Browse {Sort [[1 2] [5 8] [3 5]]}}

%{Browse {Sort [[a 3] [c 4] [g 2] [f 1] [l 5]]}}

%L = {ReadFile "Documents/Projet-Oz/tweets/part_1.txt"}
%M = {StringToList nil L nil}
%N =  {ParseBetter M nil}
%{Browse M}
%{Browse {GetFollowingWord N [must go] nil}}



%{Browse {StringToList "My name is Nouha" nil nil}}

%{Browse {StringToList "My name is nouha" nil nil }}
%{Browse {StringToAtom {StringToList {ReadFile "Documents/Projet-Oz/tweets/part_1.txt"} nil nil}}}


%{Browse {ParcourValueAux [[is 1] [oui 2]] lo nil}}


%{Browse {GetFollowingWord [[my name] [name is] [is nouha]] [my name] nil}}

%fun {InitializeStruct Words List}
%   case Words
%   of nil then List
%   [] H|T then
%      case T
%     of nil then List
%	 [] 
%L= {ReadFile "Documents/GitHub/Projet-Oz/tweets/part_2.txt"}
%M = {StringToList nil L nil}
%{Browse {ParseBetter M nil}}

%{Browse tree(key:horse value:cheval)}