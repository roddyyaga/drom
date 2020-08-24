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

let cmd_name = "run"

let action ~switch ~args =
  let p = Build.build ~switch () in
  let args = !args in
  let args = match p.kind with
    | Library -> args
    | Both | Program -> p.name :: args
  in
  Misc.call
    ( Array.of_list (
          "opam" :: "exec" :: "--" ::
          "dune"  :: "exec" :: "-p" :: p.name :: "--" ::
          args )
    )

let cmd =
  let args = ref [] in
  let switch = ref None in
  {
    cmd_name ;
    cmd_action = (fun () -> action ~switch ~args);
    cmd_args = [
      [], Arg.Anons (fun list -> args := list ),
      Ezcmd.info "Arguments to the command";
    ] @
      Build.switch_args switch;
    cmd_man = [];
    cmd_doc = "Execute the project";
  }