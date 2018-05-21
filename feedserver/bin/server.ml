open Base

let () =
  Lwt_main.run @@ Feedserver.start ()
