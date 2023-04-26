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
      proc {ThreadsCreator }
   end
   

   %%% Ajouter vos fonctions et procédures auxiliaires ici
   

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%    READER.OZ       %%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {ReadLine InFile N}
      % Cette fonction va chercher la N-ième ligne du fichier passé en argument
      % @pre: - InFile: un fichier txt
      %       - N : the number of the line that we're trying to fetch.
      % @post: Returns the N-th line tat we're trying to fetch.
      if N==1 then
         {InFile close}
         Line
      else
         {ReadLine InFile N-1}
      end
   end

   fun{ReadLineFromFile File_name Line_N}
   % Clean function of  ReadLine
      {ReadLine {New TextFile init(name:"tweets/part_"#File_name#".txt")} Line_N}
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%    READER.OZ       %%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%     THREADEDREADERPARSER.OZ    %%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   proc {Parse tweet ?R}
      % This function takes in a tweet and splits it into elements that would go into a tree/dictionnary (à voir)
      fun {F String List MotAdditionner}
         case String
         of nil then
            if MotAdditionner == nil then List
            else {Append List [MotAdditionner]}
            end

         [] H|T then 
            case {Char.type H}
            of lower then {F T List {Append MotAdditionner [H]}} % Le case de base càd le cas ou cùest une lettre
            [] upper then {F T List {Append MotAdditionner [{Char.toLower H}]}} % We set uppercase letters to lower case
            [] digit then {F T List {Append MotAdditionner [H]}} % Le cas ou c'est un chiffre
            % Should i treat punctutaion at this stage too, or should i add this as an extention ???????????????
            else 
               if MotAdditionner == nil then {F T List nil}
               else 
                  {F T {Append list [MotAdditionner]} nil}
               end
            end
         end
      R = {F Sentence nil nil}
      end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
   end





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
       
      local NbThreads InputText OutputText Description Window SeparatedWordsStream SeparatedWordsPort in
	 {Property.put print foo(width:1000 depth:1000)}  % for stdout siz
	 
            % TODO
	 
            % Creation de l interface graphique
	 Description=td(
			title: "Prédicteur de texte"
			td(text(handle:InputText tdscrollbar:true width:74 height:10 background:white foreground:black glue:nswe wrap:word)
			text(handle:OutputText tdscrollbar:true width:74 height:10 background:black foreground:white glue:nswe wrap:word)
         lr(button(text:"Montre moi la suite" width:37 height: 4 foreground:black glue:nswe action:Press) button(text:"Quit" width:37 height: 4 foreground:black glue:nswe action:proc{$} {Application.exit 0} end)))
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
