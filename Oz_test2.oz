declare
fun {Concat S1 S2} 
  case S1 of H|T then H|{Concat T S2} [] nil then S2 end
end

fun {StringToList Sentence String Temporary}
   case String
   of nil then Sentence
   [] H|T then
      %{Browse {StringToAtom  Temporary}}
      case {Char.type H}
      of lower then {StringToList Sentence T {Concat Temporary [H]}}
      [] upper then {StringToList Sentence T {Concat Temporary [{Char.toLower H}]}}
      [] digit then {StringToList Sentence T {Concat Temporary [H]}}
      [] punct then {StringToList Sentence T Temporary}
      [] space then {StringToList {Append Sentence [{StringToAtom  Temporary}]} T nil}
      end
   end
end


{Browse {StringToList nil "Hello my name is nouha" nil}}
