(*Wiktor Lewicki*)
let alpha_num = 3
let alpha_denom = 4
  
let max x y = (*wybiera większą wartość z x i y*)
  if x < y then y
  else x
    
type 'a tree =  (*struktura naszego drzewa*)
  | Leaf
  | Node of 'a tree * 'a * 'a tree 
              
type 'a sgtree = { tree : 'a tree; size : int; max_size : int } (*nasze drzewo, rozmiar naszego drzewa i parametr maxsize*)
                                                                
let alpha_height x = (*obliczamy a-wysokość*)
  if x = 0 then 0
  else int_of_float (log (float_of_int x) /. log (4.0 /. 3.0))
      
let empty = { tree = Leaf; size = 0; max_size = 0 }
            
            
let find key sg = (*zwraca true jeśli element jest w drzewie i false w przeciwnym wypadku, używa compare ze standardowej biblioteki ocamla*)
  let rec find_rec drzewo = 
    match drzewo with
    | Leaf -> false
    | Node(l, x, r) -> let cr = compare key x in
        if cr = 0 then true
        else if cr < 0 then find_rec l
        else find_rec r
  in find_rec sg.tree
  
  
let rec to_list drzewo = (*reprezentujemy drzewo w formie listy, lista będzie posortowana ze względu na strukture bst i moją implementacje*) 
  let rec list_rec poddrzewo acc =
    match poddrzewo with
    | Leaf -> acc
    | Node(l, x, r) ->  list_rec l (x :: list_rec r acc)
                         
  in list_rec drzewo []

                       
let rebuild_balanced drzewo = (*tworzymy z listy idealnie zbalansowane drzewo*)
  let drzewo_na_liscie = to_list drzewo in 
  let (result, _) = 
    let rec przebudowanie_z_listy rozm lista = (*funkcja rekurencyjna która pomaga nam w zbudowaniu naszego drzewa z naszej listy*)
      if rozm = 0 then (Leaf, lista)
      else
        let lewy_rozm = rozm/2 in
        let (lewe_poddrzewo, lst1) = przebudowanie_z_listy lewy_rozm lista in
        match lst1 with
        | [] -> (Leaf, [])
        | elm :: rest ->
            let (prawe_poddrzewo, lst2) = przebudowanie_z_listy (rozm - lewy_rozm - 1) rest in
            (Node(lewe_poddrzewo, elm, prawe_poddrzewo), lst2) 
    in przebudowanie_z_listy (List.length drzewo_na_liscie) drzewo_na_liscie 
  in result
      
      
      
let czy_zbalansowane lewy_rozm prawy_rozm = (*sprawdzamy czy w danym wierzchołku jesteśmy dobrze zbalansowani, 
                                           używam tu też tricku że zamiast dzielić, mnoże drugą stronę*)
  let rozm = 1 + lewy_rozm + prawy_rozm in
  lewy_rozm * alpha_denom <= (alpha_num * rozm) &&
  prawy_rozm * alpha_denom <= (alpha_num * rozm)
  
                              
let rec drzewo_rozm t = (*podaje ilość elementów w danym drzewie*)
  match t with
  | Leaf -> 0
  | Node(l, _, r) -> 1 + drzewo_rozm l + drzewo_rozm r
                    
(* Poniżej funkcja pomocnicza która modyfikuje nam drzewo, nie używamy zippera, rekurencyjnie trzymamy informacje takie jak poddrzewo, głębokość i czy drzewo
nie zostało już przebudowane w przypadku niezbalansowania. Jak wracamy z rekurencji i okaże się, że drzewo jest niezbalansowane i nie przebudowane to wtedy balansujemy*)
let rec insert_pom key drzewo gleb =
  match drzewo with
  | Leaf -> (Node(Leaf, key, Leaf), gleb, false)
  | Node(l, x, r) ->
      let cmp = compare key x in 
      if cmp < 0 then
        let (n_lewy, ins_gleb, przebudowany) = insert_pom key l (gleb + 1) in
        let new_node = Node(n_lewy, x, r) in
        if not przebudowany then
          let lewy_rozm = drzewo_rozm n_lewy and right_size = drzewo_rozm r in
          if not (czy_zbalansowane lewy_rozm right_size) then
            (rebuild_balanced new_node, ins_gleb, true)
          else
            (new_node, ins_gleb, false)
        else
          (new_node, ins_gleb, true)
      else
        let (n_prawy, ins_gleb, przebudowany) = insert_pom key r (gleb + 1) in
        let new_node = Node(l, x, n_prawy) in
        if not przebudowany then
          let lewy_rozm = drzewo_rozm l and right_size = drzewo_rozm n_prawy in
          if not (czy_zbalansowane lewy_rozm right_size) then
            (rebuild_balanced new_node, ins_gleb, true)
          else
            (new_node, ins_gleb, false)
        else
          (new_node, ins_gleb, true)
      
  

let insert key sg = (*sprawdzenie czy key istnieje już w drzewie i jeżeli nie to dodanie go tam*)
  if find key sg then failwith "Element już jest w drzewie"
  else
    let (new_tree, _, _) = insert_pom key sg.tree 0 in
    {tree = new_tree; size = sg.size + 1; max_size = max sg.max_size (sg.size + 1)}
      
  
let rec remove_pom key t = (*Usuwamy wierzchołek i na jego miejsce wstawiamy najmniejszy element z prawego poddrzewa*)
  match t with
  | Leaf -> failwith "debug1"
  | Node(l, x, r) ->
      let cmp = compare key x in
      if cmp < 0 then Node(remove_pom key l, x, r)
      else if cmp > 0 then Node(l, x, remove_pom key r)
      else
        match (l, r) with 
        | (Leaf, _) -> r
        | (_, Leaf) -> l
        | _ ->
            let rec remove_nw t =
              match t with
              | Leaf -> failwith "debug2"
              | Node(Leaf, y, r2) -> (y, r2)
              | Node(l, y, r2) ->
                  let (nw, copy_r) = remove_nw l in
                  (nw, Node(copy_r, y, r2))
            in
            let (nw, copy_r) = remove_nw r in
            Node(l, nw, copy_r)
  
              
(*Usuwamy element z drzewa, wstawiamy w jego miejsce najmniejszy element z prawego poddrzewa i ewentualnie balansujemy całe drzewo*)
let remove key sg =
  if not (find key sg) then failwith "Elementu nie ma w drzewie"
  else
    let nowe_drzewo = remove_pom key sg.tree in 
    let nowy_sg = { tree = nowe_drzewo; size = (sg.size - 1); max_size = sg.max_size } in
    if (sg.size - 1) * alpha_denom < (alpha_num * sg.max_size) then
      { nowy_sg with tree = rebuild_balanced nowe_drzewo; max_size = sg.size - 1}
    else
      nowy_sg