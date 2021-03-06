(**************************************************************************)
(*                                                                        *)
(*    Copyright 2020 OCamlPro & Origin Labs                               *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

open Ezcmd.TYPES

let cmd_name = "sphinx"

let make_sphinx p =
  let dir = Misc.sphinx_target p in
  let sphinx_target = Format.sprintf "_drom/docs/%s" dir in
  Misc.call [| "sphinx-build"; "sphinx"; sphinx_target |];
  sphinx_target

let action ~args ~open_www () =
  let (p : Types.project) = Build.build ~dev_deps:true ~args () in
  let sphinx_target = make_sphinx p in
  if !open_www then
    Misc.call [| "xdg-open";
                 Filename.concat sphinx_target "index.html" |]

let cmd =
  let args, specs = Build.build_args () in
  let open_www = ref false in
  { cmd_name;
    cmd_action = (fun () -> action ~args ~open_www ());
    cmd_args =
      [ ( [ "view" ],
          Arg.Set open_www,
          Ezcmd.info "Open a browser on the sphinx documentation" )
      ]
      @ specs;
    cmd_man = [];
    cmd_doc = "Generate documentation using sphinx"
  }
