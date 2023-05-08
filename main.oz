functor
import 
   QTk at 'x-oz://system/wp/QTk.ozf'
   System
   Application
   Open
   OS
   Property
   Browser
define
   %%% Pour ouvrir les fichiers
   class TextFile
      from Open.file Open.text
   end

   proc {Browse Buf}
      {Browser.browse Buf}
   end
   
   %%% /!\ Fonction testee /!\
   %%% @pre : les threads sont "ready"
   %%% @post: Fonction appellee lorsqu on appuie sur le bouton de prediction
   %%%        Affiche la prediction la plus probable du prochain mot selon les deux derniers mots entres
   %%% @return: Retourne une liste contenant la liste du/des mot(s) le(s) plus probable(s) accompagnee de 
   %%%          la probabilite/frequence la plus elevee. 
   %%%          La valeur de retour doit prendre la forme:
   %%%                  <return_val> := <most_probable_words> '|' <probability/frequence> '|' nil
   %%%                  <most_probable_words> := <atom> '|' <most_probable_words> 
   %%%                                           | nil
   %%%                  <probability/frequence> := <int> | <float>
   fun {Press}
      0
   end
   
    %%% Lance les N threads de lecture et de parsing qui liront et traiteront tous les fichiers
    %%% Les threads de parsing envoient leur resultat au port Port
   proc {LaunchThreads Port N}
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%     Added    %%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      skip
   end
   
   fun {Clear}
      0
   end

   %%% Ajouter vos fonctions et procédures auxiliaires ici
   

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%    READER.OZ       %%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
   
   %Gets the words that follow the two words passed as an argument
   fun {GetFollowingWord Words Looking Following}
      case Words
      of nil then Following
      [] H|T then
         if H == Looking then
       %{Browse T.1.2.1}
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

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%    READER.OZ       %%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%     THREADEDREADERPARSER.OZ    %%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%     THREADEDREADERPARSER.OZ    %%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   %%% Fetch Tweets Folder from CLI Arguments
   %%% See the Makefile for an example of how it is called
   fun {GetSentenceFolder}
      Args = {Application.getArgs record('folder'(single type:string optional:false))}
   in
      Args.'folder'
   end

   %%% Decomnentez moi si besoin
   %proc {ListAllFiles L}
   %   case L of nil then skip
   %   [] H|T then {Browse {String.toAtom H}} {ListAllFiles T}
   %   end
   %end
    
   %%% Procedure principale qui cree la fenetre et appelle les differentes procedures et fonctions
   proc {Main}
      TweetsFolder = {GetSentenceFolder}
   in
      %% Fonction d'exemple qui liste tous les fichiers
      %% contenus dans le dossier passe en Argument.
      %% Inspirez vous en pour lire le contenu des fichiers
      %% se trouvant dans le dossier
      %%% N'appelez PAS cette fonction lors de la phase de
      %%% soumission !!!
      %{ListAllFiles {OS.getDir TweetsFolder}}
       
      local NbThreads InputText OutputText Historique Description Window SeparatedWordsStream SeparatedWordsPort in
	 {Property.put print foo(width:1000 depth:1000)}  % for stdout siz
	 
            % TODO
	 
            % Creation de l interface graphique
	 Description=td(
			title: "Prédicteur de texte"
			lr(
         td(text(handle:InputText tdscrollbar:true width:74 height:10 background:white foreground:black glue:nswe wrap:word)
			text(handle:OutputText tdscrollbar:true width:74 height:10 background:orange foreground:white glue:nswe wrap:word))
         text(handle:Historique tdscrollbar:true width:22 height:20 background:white foreground:black glue:nswe wrap:word))

         lr(button(text:"Montre moi la suite" width:32 height: 4 foreground:white glue:nswe action:Press) button(text:"Effacer l'historique" width:32 height: 4 foreground:white glue:nswe action:Clear) button(text:"Quit" width:32 height: 4 foreground:white glue:nswe action:proc{$} {Application.exit 0} end))
			action:proc{$}{Application.exit 0} end % quitte le programme quand la fenetre est fermee
			)
	 
            % Creation de la fenetre
	 Window={QTk.build Description}
	 {Window show}
	 
	 {InputText tk(insert 'end' "Loading... Please wait.")}
	 {InputText bind(event:"<Control-s>" action:Press)} % You can also bind events
	 
            % On lance les threads de lecture et de parsing
	 SeparatedWordsPort = {NewPort SeparatedWordsStream}
	 NbThreads = 4
	 {LaunchThreads SeparatedWordsPort NbThreads}
	 
	 {InputText set(1:"")}
      end
   end
    % Appelle la procedure principale
   {Main}
end
