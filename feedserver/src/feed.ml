open Base
open Lwt.Infix

type t = Feed_j.feed =
  { id : int
  ; created_at : Datetime.t
  ; title : string
  ; feed_uri : Uri.t }
[@@deriving compare, sexp_of]

let to_string t = Feed_j.string_of_feed t

let list_to_string ts = Feed_j.string_of_feeds ts