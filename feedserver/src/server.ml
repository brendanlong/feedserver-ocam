open Base
open Lwt.Infix

open Graphql_lwt

let datetime =
  Schema.scalar "Datetime" ~doc:"An RFC3339 datetime (always UTC)"
    ~coerce:(fun datetime ->
        `String Ptime.(to_rfc3339 ~tz_offset_s:0 datetime))

let uri =
  Schema.scalar "Datetime" ~doc:"An RFC3339 datetime (always UTC)"
    ~coerce:(fun uri ->
        `String (Uri.to_string uri))

let feed =
  let open Feed in
  Schema.(obj "feed"
            ~fields:(fun fee -> [
                  field "id"
                    ~args:Arg.[]
                    ~typ:(non_null int)
                    ~resolve:(fun _ p -> p.id)
                  ;
                  field "created_at"
                    ~args:Arg.[]
                    ~typ:(non_null datetime)
                    ~resolve:(fun _ p -> p.created_at)
                  ;
                  field "title"
                    ~args:Arg.[]
                    ~typ:(non_null string)
                    ~resolve:(fun _ p -> p.title)
                  ;
                  field "feed_uri"
                    ~args:Arg.[]
                    ~typ:(non_null uri)
                    ~resolve:(fun _ p -> p.feed_uri)
                ])
         )

let schema =
  Schema.(schema
            [ io_field "feeds"
                ~args:Arg.[]
                ~typ:(non_null (list (non_null feed)))
                ~resolve:(fun ctx () -> Lwt.return ctx) ])

let start () =
  let ctx =
    [{ Feed.id = 1
    ; created_at = Ptime_clock.now ()
     ; title = "Example"
     ; feed_uri = Uri.of_string "https://www.example.com/atom.xml" }]
  in
  Server.start ~ctx:(fun req -> ctx) schema