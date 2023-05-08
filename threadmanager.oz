declare

fun {NbLignes File}
    if File == 208 then 72 
    else 100 end
end

proc {ReaderThread P NbThreads NbFichiers}
    proc {CreateThread P NbThreads ThreadActuel NbFichiers}
        proc {ReaderFiles FichierAct MaxFichier ?R}
            
        end
    end
end

proc {SendToStream S NbThreads ?R}
    fun {SendToStreamAux S List NbThreads NbThreadDone}
        %List: Liste avec tout les mots suivants
        %NbThreads: nombre de thread au total
        %NbThreadDone: nmbre de threads finis
        case S 
        of H|T then 
            if H == done then
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