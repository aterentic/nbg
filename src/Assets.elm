module Assets exposing (description, document, headline, photos)

import Data exposing (Photo)


document : String
document =
    "NBG"


headline : String
headline =
    "NBG KOLAŽ"


description : String
description =
    "Blokovi, Sava, i poneki opis..."


photos : List Photo
photos =
    [ { headline = "Međublokovski prostor"
      , text = "Zapravo, zato smo se i doselili ovde. Automobili samo kod garaža, sa jedne strane klinci muljaju po pesku, igraju fudbal na male goliće, platani ih hlade kad je 37 stepeni, kad otvoriš prozor, neko se dere \"Maaaaaamaaaaa\", uveče klinci vare na klupi, i, jebi ga, malo se deru kad treba da se spava. Gomila nedovršenog zelenila i prostora, vidiš komšijin prozor, ali u daljini. Između zapravo možeš da sediš na klupi u hladu, da čekaš klince dok voze bajs, da čekaš klince dok se zimi sankaju niz brdašce od atomskog skloništa. Čak i sneška možeš da praviš jer je površina dovoljno velika da sneg ne upropasti masa ljudi i vozila. A ima i baštica, uvek ima nekog ko bi da se petlja sa tim."
      , image = "assets/01.jpg"
      }
    , { headline = "Savski kej"
      , text = "Predivan pogled na divlju gradnju često kvare zalasci sunca na Savi."
      , image = "assets/02.jpg"
      }
    , { headline = "Savski kej II"
      , text = "Sa pogledom na stari..."
      , image = "assets/03.jpg"
      }
    , { headline = "Gazela"
      , text = "Sa pogledaom na očaj..."
      , image = "assets/04.jpg"
      }
    , { headline = "Jesen"
      , text = "Lepo i opasno (ispod jesenjeg lišća)"
      , image = "assets/05.jpg"
      }
    ]
