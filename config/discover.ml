module C = Configurator.V1

let ppc64_lines c =
  let arch = C.ocaml_config_var_exn c "architecture" in
  let model = C.ocaml_config_var_exn c "model" in
  match arch, model with
  | "power", "ppc64le" -> ["-mcmodel=small"]
  | _ -> []

let () =
  let cstubs = ref "" in
  let args = Arg.["-cstubs",Set_string cstubs,"cstubs loc"] in
  C.main ~args ~name:"morbig" (fun c ->
    C.Flags.write_lines "cflags" ppc64_lines)
