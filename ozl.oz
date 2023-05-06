declare

fun {ReadFile FilePath}
   Save
   F = {New Open.file init(name:FilePath flags:[read])}
   {F read(list:Save size:all)}
   {F close}
in
   Save 
end

fun {Concat S1 S2} 
  case S1 of H|T then H|{Concat T S2} [] nil then S2 end
end

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

fun {ParseBetter Parsed List}
   case Parsed
   of nil then List
   [] H|T then
      if T == nil then List
      else {ParseBetter T {Append List [{Concat [H] [T.1]}]}} end
   end
end

%Gets the words that follow the two words passed as an argument
fun {GetFollowingWord Words Looking Following}
   case Words
   of nil then Following
   [] H|T then
      if H == Looking then {GetFollowingWord T Looking {IncrScoreWord T.1.2.1 {Append Following [[T.1.2.1 0]]} nil}}
      else {GetFollowingWord T Looking Following} end
   end
end
%Checks if a word is already in the following word list, increments if it's the case and adds it if not
fun {IncrScoreWord Word Following FollowingUpdated}
   case Following
   of nil then FollowingUpdated
   [] H|T then if H.1 == Word then
          {Browse "here"}
          {Append FollowingUpdated [H.1 {StringToInt H.2.1}+1]|T}
	       else
		  {IncrScoreWord Word T {Append FollowingUpdated [H]}}
           end
   end
end


{Browse {GetFollowingWord [[my name] [name is] [is nouha] [nouha lo] [lo nil] [nil my] [my name] [name is]] [my name] nil}}
%{Browse {IncrScoreWord is [[my 1] [name 1] [is 1] [nouha 5]] nil}}
%{Browse {GetFollowingWord [[my name] [name is] [my name] [is nouha]] [my name] nil}}

%{Browse {StringToAtom{Concat "hey" "you"}}}



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