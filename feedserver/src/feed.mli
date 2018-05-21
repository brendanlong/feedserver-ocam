open Base

type t = Feed_t.feed =
  { id : int
  ; created_at : Ptime.t
  ; title : string
  ; feed_uri : Uri.t }
[@@deriving compare, sexp_of]

val to_string : t -> string
val list_to_string : t list -> string