declare

PathTweet = {OS.getDir TweetsFolder}

proc {ReaderThread P NbThreads NbFichiers}
    proc {CreateThread P NbThreads ThreadActuel NbFichiers}
        proc {ReaderFiles FichierAct MaxFichier}
            if FichierAct > MaxFichier then nil
            else {ReadFile PathTweet#"part_"#FichierAct#".txt"}|{ReaderFiles FichierAct+1 MaxFichier} end
        end
        proc {FileParser P S}
            case S 
            of nil then {Send P finished}
            [] H|T then
                {Send P {ParseBetter {StringToList H}}} {FileParser P T}
            end
        end
        Part = (NbFichiers div NbThreads)
        S 
    in
        if ThreadActuel =< NbThreadDone then
            thread S = {ReaderFiles ((Part)*(ThreadActuel -1))+1 ((Part)*ThreadActuel)} end
            thread {FileParser P S} end
            {CreateThread P NbThreads ThreadActuel+1 NbFichiers}
        end 
    end
in 
    {CreateThread P NbThreads 1 NbFichiers}
end

proc {SendToStream S NbThreads ?R}
    fun {SendToStreamAux S List NbThreads NbThreadDone}
        %List: Liste avec tout les mots suivants
        %NbThreads: nombre de thread au total
        %NbThreadDone: nmbre de threads finis
        case S 
        of H|T then 
            if H == finished then
                if NbThreadDone == NbThreads then List
                else {SendToStreamAux T List NbThreads NbThreadDone+1} end
            else {SendToStreamAux T {Funct List H} NbThreads NbThreadDone} end
        end 
    end
end


fun {CreateList} %Doit return la liste avec toute les valeurs pour l'input
    proc {CreateListProc NbThreads NbFichiers ?List} S P in
        {NewPort S P}
        %{ParseFiles with threads P NbThreads NbFichiers}
        List = {SendToStreamAux S NbThreads}
    end
in
    {CreateListProc 4 208}
end