let () =
  let read_int () =
    match In_channel.input_line stdin with
    | Some line -> int_of_string_opt line
    | _ -> None
  in
  let rec read_all acc =
    match read_int () with None -> acc | Some i -> read_all (i :: acc)
  in
  read_all [] |> Mergesort.sort
  |> List.iter (fun n ->
         print_int n;
         print_newline ())
