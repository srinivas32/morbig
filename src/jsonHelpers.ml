(**************************************************************************)
(*  -*- tuareg -*-                                                        *)
(*                                                                        *)
(*  Copyright (C) 2017,2018 Yann Régis-Gianas, Nicolas Jeannerod,         *)
(*  Ralf Treinen.                                                         *)
(*                                                                        *)
(*  This is free software: you can redistribute it and/or modify it       *)
(*  under the terms of the GNU General Public License, version 3.         *)
(*                                                                        *)
(*  Additional terms apply, due to the reproduction of portions of        *)
(*  the POSIX standard. Please refer to the file COPYING for details.     *)
(**************************************************************************)

let rec json_filter_positions =
  let open Yojson.Safe in
  function
  | `Assoc sjl ->
     if List.for_all (fun (s, j) -> s = "value" || s = "position") sjl then
       let (_, j) = List.find (fun (s, _) -> s = "value") sjl in
       json_filter_positions j
     else
       `Assoc (List.map (fun (s, j) ->
           Format.printf "%s@." s; (s, json_filter_positions j)) sjl
         )
  | `Bool b -> `Bool b
  | `Float f -> `Float f
  | `Int i -> `Int i
  | `Intlit s -> `Intlit s
  | `List jl -> `List (List.map json_filter_positions jl)
  | `Null -> `Null
  | `String s -> `String s
  | `Tuple jl -> `Tuple (List.map json_filter_positions jl)
  | `Variant (s, None) -> `Variant (s, None)
  | `Variant (s, Some j) -> `Variant (s, Some (json_filter_positions j))

let save_as_json simplified cout csts =
  CSTHelpers.complete_command_list_to_json csts
  |> (if simplified then json_filter_positions else function x-> x)
  |> Yojson.Safe.pretty_to_channel cout
