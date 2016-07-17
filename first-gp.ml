type var = string

exception Length_error of string;;
  
type exp =
  | Plus of exp * exp
  | Minus of exp * exp
  | Times of exp * exp
  | Div of exp * exp
  | Int of int
  | Var of var

let term_set = [Int 2; Int 5; Var "x"; Var "y"]
let func_set = ["Plus"; "Minus"; "Times"; "Div"]

let rec nth n list = match (n, list) with
  | (_,[]) -> raise (Length_error "cannot get nth value from empty list")
  | (0, h :: t) -> h
  | (n, h :: t) -> nth (n-1) t
    
let rec length list = match list with
  | [] -> 0
  | h :: t -> 1 + (length t)

let choose_random_element list = nth (Random.int (length list)) list
				   		 
let rec gen_rnd_expr func_set term_set max_d methd =
  if (methd = "grow" &&
	((Random.float 1.0) < (float_of_int(length term_set) /. float_of_int((length term_set) + (length func_set)))))
  then choose_random_element(term_set)
  else match max_d with
       | 0 -> choose_random_element(term_set)
       | x -> let func = choose_random_element(func_set) in
	      match func with
	      | "Plus" -> Plus(gen_rnd_expr func_set term_set (x-1) methd,gen_rnd_expr func_set term_set (x-1) methd)
	      | "Minus"-> Minus(gen_rnd_expr func_set term_set (x-1) methd,gen_rnd_expr func_set term_set (x-1) methd)
	      | "Times"-> Times(gen_rnd_expr func_set term_set (x-1) methd,gen_rnd_expr func_set term_set (x-1) methd)
	      | "Div"  -> Div(gen_rnd_expr func_set term_set (x-1) methd,gen_rnd_expr func_set term_set (x-1) methd)

let rec subst (e,x : exp * var) (e' : exp) : exp = match e' with
  | Plus(e1, e2) -> Plus(subst (e,x) e1, subst (e,x) e2)
  | Minus(e1, e2) -> Minus(subst (e,x) e1, subst (e,x) e2)
  | Times(e1, e2) -> Times(subst (e,x) e1, subst (e,x) e2)
  | Div(e1, e2) -> Div(subst (e,x) e1, subst (e,x) e2)
  | Var y -> if y = x then e else Var y

let rec eval (e : exp) : exp = match e with
  | Int n -> Int n
  | Plus(e1, e2) -> (let v1 = eval e1 in
		       let v2 = eval e2 in
		       combineInts v1 v2 (+)
		    )
  | Minus(e1, e2) -> (let v1 = eval e1 in
			let v2 = eval e2 in
			combineInts v1 v2 (-)
		     )
  | Times(e1, e2) -> (let v1 = eval e1 in
			let v2 = eval e2 in
			combineInts v1 v2 ( * )
		     )
  | Div(e1, e2) ->  (let v1 = eval e1 in
		       let v2 = eval e2 in
		       combineInts v1 v2 ( / )
		    )
  | Var x -> raise (Error "unbound variable")
		     


			
	 
		  
				 
					   
	 
	 
							    
	   
			  
