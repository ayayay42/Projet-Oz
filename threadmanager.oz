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

fun {CreateTree} %Doit return l'arbre avec toutes les poss pour l'input
    proc {CreateTreeProc NbThreads NbFichiers ?Tree} S P in
        {NewPort S P}
        {ReaderThread P NbThreads NbFichiers}
    end
in
    {CreateTreeProc 4 208}
end