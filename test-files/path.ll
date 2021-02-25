; ModuleID = lib/texp-path-driver.bb
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; (lib/texp-path-driver.bb (decl @malloc (types u64) i8*) (decl @free (types i8*) void) (decl @realloc (types i8* u64) i8*) (decl @calloc (types u64 u64) i8*) (decl @printf (types i8* ...) i32) (decl @puts (types i8*) i32) (decl @fflush (types i32) i32) (decl @write (types i32 i8* u64) i64) (decl @read (types i32 i8* u64) i64) (decl @memcpy (types i8* i8* u64) i8*) (decl @memmove (types i8* i8* u64) i8*) (decl @open (types i8* i32 ...) i32) (decl @lseek (types i32 i64 i32) i64) (decl @mmap (types i8* u64 i32 i32 i32 i64) i8*) (decl @munmap (types i8* u64) i32) (decl @close (types i32) i32) (decl @exit (types i32) void) (decl @perror (types i8*) void) (def @i8$ptr.length_ (params (%this i8*) (%acc u64)) u64 (do (let %$1 (load i8 %this)) (let %$0 (== i8 %$1 0)) (if %$0 (do (return %acc u64))) (let %$5 (ptrtoint i8* u64 %this)) (let %$4 (+ u64 1 %$5)) (let %$3 (inttoptr u64 i8* %$4)) (let %$6 (+ u64 %acc 1)) (let %$2 (call-tail @i8$ptr.length_ (types i8* u64) u64 (args %$3 %$6))) (return %$2 u64))) (def @i8$ptr.length (params (%this i8*)) u64 (do (let %$0 (call-tail @i8$ptr.length_ (types i8* u64) u64 (args %this 0))) (return %$0 u64))) (def @i8$ptr.printn (params (%this i8*) (%n u64)) void (do (let %FD_STDOUT (+ i32 1 0)) (call @write (types i32 i8* u64) i64 (args %FD_STDOUT %this %n)) return-void)) (def @i8$ptr.unsafe-print (params (%this i8*)) void (do (let %length (call @i8$ptr.length (types i8*) u64 (args %this))) (call @i8$ptr.printn (types i8* u64) void (args %this %length)) return-void)) (def @i8$ptr.unsafe-println (params (%this i8*)) void (do (call @i8$ptr.unsafe-print (types i8*) void (args %this)) (call @println types void args) return-void)) (def @i8$ptr.copyalloc (params (%this i8*)) i8* (do (let %length (call @i8$ptr.length (types i8*) u64 (args %this))) (let %$0 (+ u64 %length 1)) (let %allocated (call @malloc (types u64) i8* (args %$0))) (let %$3 (ptrtoint i8* u64 %allocated)) (let %$2 (+ u64 %length %$3)) (let %$1 (inttoptr u64 i8* %$2)) (store 0 i8 %$1) (call @memcpy (types i8* i8* u64) i8* (args %allocated %this %length)) (return %allocated i8*))) (def @i8.print (params (%this i8)) void (do (auto %c i8) (store %this i8 %c) (let %FD_STDOUT (+ i32 1 0)) (call @write (types i32 i8* u64) i64 (args %FD_STDOUT %c 1)) return-void)) (def @i8$ptr.swap (params (%this i8*) (%other i8*)) void (do (let %this_value (load i8 %this)) (let %other_value (load i8 %other)) (store %this_value i8 %other) (store %other_value i8 %this) return-void)) (def @i8$ptr.eqn (params (%this i8*) (%other i8*) (%len u64)) i1 (do (let %$0 (== u64 0 %len)) (if %$0 (do (return true i1))) (let %$2 (load i8 %this)) (let %$3 (load i8 %other)) (let %$1 (!= i8 %$2 %$3)) (if %$1 (do (return false i1))) (let %$5 (ptrtoint i8* u64 %this)) (let %$4 (+ u64 1 %$5)) (let %next-this (inttoptr u64 i8* %$4)) (let %$7 (ptrtoint i8* u64 %other)) (let %$6 (+ u64 1 %$7)) (let %next-other (inttoptr u64 i8* %$6)) (let %$9 (- u64 %len 1)) (let %$8 (call @i8$ptr.eqn (types i8* i8* u64) i1 (args %next-this %next-other %$9))) (return %$8 i1))) (def @println params void (do (let %NEWLINE (+ i8 10 0)) (call @i8.print (types i8) void (args %NEWLINE)) return-void)) (def @test.i8$ptr-eqn params void (do (auto %a %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %a) (auto %b %struct.String) (let %$1 (call @String.makeEmpty types %struct.String args)) (store %$1 %struct.String %b) (call @String$ptr.pushChar (types %struct.String* i8) void (args %a 65)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %a 66)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %a 67)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %a 68)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %b 65)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %b 66)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %b 67)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %b 68)) (let %a-cstr (bitcast %struct.String* i8* %a)) (let %b-cstr (bitcast %struct.String* i8* %b)) (let %$4 (call @i8$ptr.eqn (types i8* i8* u64) i1 (args %a-cstr %b-cstr 5))) (let %$3 (sext i1 i8 %$4)) (let %$2 (+ i8 48 %$3)) (call @i8.print (types i8) void (args %$2)) return-void)) (struct %struct.StringView (%ptr i8*) (%size u64)) (def @StringView.makeEmpty params %struct.StringView (do (auto %result %struct.StringView) (let %$0 (inttoptr i64 i8* 0)) (let %$1 (index %result %struct.StringView 0)) (store %$0 i8* %$1) (let %$2 (index %result %struct.StringView 1)) (store 0 u64 %$2) (let %$3 (load %struct.StringView %result)) (return %$3 %struct.StringView))) (def @StringView$ptr.set (params (%this %struct.StringView*) (%charptr i8*)) void (do (let %$0 (index %this %struct.StringView 0)) (store %charptr i8* %$0) (let %$1 (call @i8$ptr.length (types i8*) u64 (args %charptr))) (let %$2 (index %this %struct.StringView 1)) (store %$1 u64 %$2) return-void)) (def @StringView.make (params (%charptr i8*) (%size u64)) %struct.StringView (do (auto %result %struct.StringView) (let %$0 (index %result %struct.StringView 0)) (store %charptr i8* %$0) (let %$1 (index %result %struct.StringView 1)) (store %size u64 %$1) (let %$2 (load %struct.StringView %result)) (return %$2 %struct.StringView))) (def @StringView.makeFromi8$ptr (params (%charptr i8*)) %struct.StringView (do (auto %result %struct.StringView) (let %$0 (index %result %struct.StringView 0)) (store %charptr i8* %$0) (let %$1 (call @i8$ptr.length (types i8*) u64 (args %charptr))) (let %$2 (index %result %struct.StringView 1)) (store %$1 u64 %$2) (let %$3 (load %struct.StringView %result)) (return %$3 %struct.StringView))) (def @StringView$ptr.print (params (%this %struct.StringView*)) void (do (let %$1 (index %this %struct.StringView 0)) (let %$0 (load i8* %$1)) (let %$3 (index %this %struct.StringView 1)) (let %$2 (load u64 %$3)) (call @i8$ptr.printn (types i8* u64) void (args %$0 %$2)) return-void)) (def @StringView$ptr.println (params (%this %struct.StringView*)) void (do (call @StringView$ptr.print (types %struct.StringView*) void (args %this)) (call @println types void args) return-void)) (def @StringView.print (params (%this %struct.StringView)) void (do (auto %local %struct.StringView) (store %this %struct.StringView %local) (let %$1 (index %local %struct.StringView 0)) (let %$0 (load i8* %$1)) (let %$3 (index %local %struct.StringView 1)) (let %$2 (load u64 %$3)) (call @i8$ptr.printn (types i8* u64) void (args %$0 %$2)) return-void)) (def @StringView.println (params (%this %struct.StringView)) void (do (call @StringView.print (types %struct.StringView) void (args %this)) (call @println types void args) return-void)) (def @StringView$ptr.eq (params (%this %struct.StringView*) (%other %struct.StringView*)) i1 (do (let %$0 (index %this %struct.StringView 1)) (let %len (load u64 %$0)) (let %$1 (index %other %struct.StringView 1)) (let %olen (load u64 %$1)) (let %$2 (!= u64 %len %olen)) (if %$2 (do (return false i1))) (let %$5 (index %this %struct.StringView 0)) (let %$4 (load i8* %$5)) (let %$7 (index %other %struct.StringView 0)) (let %$6 (load i8* %$7)) (let %$3 (call @i8$ptr.eqn (types i8* i8* u64) i1 (args %$4 %$6 %len))) (return %$3 i1))) (def @StringView.eq (params (%this-value %struct.StringView) (%other-value %struct.StringView)) i1 (do (auto %this %struct.StringView) (store %this-value %struct.StringView %this) (auto %other %struct.StringView) (store %other-value %struct.StringView %other) (let %$0 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %this %other))) (return %$0 i1))) (struct %struct.String (%ptr i8*) (%size u64)) (def @String.makeEmpty params %struct.String (do (auto %result %struct.String) (let %$0 (inttoptr i64 i8* 0)) (let %$1 (index %result %struct.String 0)) (store %$0 i8* %$1) (let %$2 (index %result %struct.String 1)) (store 0 u64 %$2) (let %$3 (load %struct.String %result)) (return %$3 %struct.String))) (def @String$ptr.set (params (%this %struct.String*) (%charptr i8*)) void (do (let %$0 (call @i8$ptr.copyalloc (types i8*) i8* (args %charptr))) (let %$1 (index %this %struct.String 0)) (store %$0 i8* %$1) (let %$3 (call @i8$ptr.length (types i8*) u64 (args %charptr))) (let %$2 (- u64 %$3 1)) (let %$4 (index %this %struct.String 1)) (store %$2 u64 %$4) return-void)) (def @String.makeFromi8$ptr (params (%charptr i8*)) %struct.String (do (auto %this %struct.String) (let %$0 (call @i8$ptr.copyalloc (types i8*) i8* (args %charptr))) (let %$1 (index %this %struct.String 0)) (store %$0 i8* %$1) (let %$2 (call @i8$ptr.length (types i8*) u64 (args %charptr))) (let %$3 (index %this %struct.String 1)) (store %$2 u64 %$3) (let %$4 (load %struct.String %this)) (return %$4 %struct.String))) (def @String$ptr.copyalloc (params (%this %struct.String*)) %struct.String (do (auto %result %struct.String) (let %$2 (index %this %struct.String 0)) (let %$1 (load i8* %$2)) (let %$0 (call @i8$ptr.copyalloc (types i8*) i8* (args %$1))) (let %$3 (index %result %struct.String 0)) (store %$0 i8* %$3) (let %$5 (index %this %struct.String 1)) (let %$4 (load u64 %$5)) (let %$6 (index %result %struct.String 1)) (store %$4 u64 %$6) (let %$7 (load %struct.String %result)) (return %$7 %struct.String))) (def @String.makeFromStringView (params (%other %struct.StringView*)) %struct.String (do (let %$0 (index %other %struct.StringView 1)) (let %len (load u64 %$0)) (auto %result %struct.String) (let %$2 (+ u64 1 %len)) (let %$1 (call @malloc (types u64) i8* (args %$2))) (let %$3 (index %result %struct.String 0)) (store %$1 i8* %$3) (let %$5 (index %result %struct.String 0)) (let %$4 (load i8* %$5)) (let %$7 (index %other %struct.StringView 0)) (let %$6 (load i8* %$7)) (call @memcpy (types i8* i8* u64) i8* (args %$4 %$6 %len)) (let %$12 (index %result %struct.String 0)) (let %$11 (load i8* %$12)) (let %$10 (ptrtoint i8* u64 %$11)) (let %$9 (+ u64 %len %$10)) (let %$8 (inttoptr u64 i8* %$9)) (store 0 i8 %$8) (let %$13 (index %result %struct.String 1)) (store %len u64 %$13) (let %$14 (load %struct.String %result)) (return %$14 %struct.String))) (def @String$ptr.is-empty (params (%this %struct.String*)) i1 (do (let %$2 (index %this %struct.String 1)) (let %$1 (load u64 %$2)) (let %$0 (== u64 0 %$1)) (return %$0 i1))) (def @String$ptr.view (params (%this %struct.String*)) %struct.StringView (do (let %$1 (bitcast %struct.String* %struct.StringView* %this)) (let %$0 (load %struct.StringView %$1)) (return %$0 %struct.StringView))) (def @String$ptr.free (params (%this %struct.String*)) void (do (let %$1 (index %this %struct.String 0)) (let %$0 (load i8* %$1)) (call @free (types i8*) void (args %$0)) return-void)) (def @String$ptr.setFromChar (params (%this %struct.String*) (%c i8)) void (do (let %ptr-ref (index %this %struct.String 0)) (let %size-ref (index %this %struct.String 1)) (let %ptr (call @malloc (types u64) i8* (args 2))) (store %c i8 %ptr) (let %$2 (ptrtoint i8* u64 %ptr)) (let %$1 (+ u64 1 %$2)) (let %$0 (inttoptr u64 i8* %$1)) (store 0 i8 %$0) (store %ptr i8* %ptr-ref) (store 1 u64 %size-ref) return-void)) (def @String$ptr.append (params (%this %struct.String*) (%other %struct.String*)) void (do (let %same-string (== %struct.String* %this %other)) (if %same-string (do (auto %temp-copy %struct.String) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %other))) (store %$0 %struct.String %temp-copy) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %this %temp-copy)) (let %$2 (index %temp-copy %struct.String 0)) (let %$1 (load i8* %$2)) (call @free (types i8*) void (args %$1)) return-void)) (let %$3 (index %this %struct.String 1)) (let %old-length (load u64 %$3)) (let %$5 (index %other %struct.String 1)) (let %$4 (load u64 %$5)) (let %new-length (+ u64 %old-length %$4)) (let %$8 (index %this %struct.String 0)) (let %$7 (load i8* %$8)) (let %$9 (+ u64 1 %new-length)) (let %$6 (call @realloc (types i8* u64) i8* (args %$7 %$9))) (let %$10 (index %this %struct.String 0)) (store %$6 i8* %$10) (let %end-of-this-string (call @String$ptr.end (types %struct.String*) i8* (args %this))) (let %$11 (index %this %struct.String 1)) (store %new-length u64 %$11) (let %$13 (index %other %struct.String 0)) (let %$12 (load i8* %$13)) (let %$15 (index %other %struct.String 1)) (let %$14 (load u64 %$15)) (call @memcpy (types i8* i8* u64) i8* (args %end-of-this-string %$12 %$14)) return-void)) (def @String$ptr.prepend (params (%this %struct.String*) (%other %struct.String*)) void (do (let %same-string (== %struct.String* %this %other)) (if %same-string (do (auto %temp-copy %struct.String) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %other))) (store %$0 %struct.String %temp-copy) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %this %temp-copy)) (let %$2 (index %temp-copy %struct.String 0)) (let %$1 (load i8* %$2)) (call @free (types i8*) void (args %$1)) return-void)) (let %$3 (index %this %struct.String 1)) (let %old-length (load u64 %$3)) (let %$4 (index %other %struct.String 1)) (let %other-length (load u64 %$4)) (let %new-length (+ u64 %old-length %other-length)) (let %$5 (index %this %struct.String 1)) (store %new-length u64 %$5) (let %$8 (index %this %struct.String 0)) (let %$7 (load i8* %$8)) (let %$9 (+ u64 1 %new-length)) (let %$6 (call @realloc (types i8* u64) i8* (args %$7 %$9))) (let %$10 (index %this %struct.String 0)) (store %$6 i8* %$10) (let %$11 (index %this %struct.String 0)) (let %new-start (load i8* %$11)) (let %$12 (index %other %struct.String 0)) (let %other-start (load i8* %$12)) (let %$14 (ptrtoint i8* u64 %new-start)) (let %$13 (+ u64 %other-length %$14)) (let %midpoint (inttoptr u64 i8* %$13)) (call @memmove (types i8* i8* u64) i8* (args %midpoint %new-start %old-length)) (call @memcpy (types i8* i8* u64) i8* (args %new-start %other-start %other-length)) return-void)) (def @String.add (params (%left %struct.String*) (%right %struct.String*)) %struct.String (do (auto %result %struct.String) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %left))) (store %$0 %struct.String %result) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %result %right)) (let %$1 (load %struct.String %result)) (return %$1 %struct.String))) (def @String$ptr.end (params (%this %struct.String*)) i8* (do (let %$0 (index %this %struct.String 0)) (let %begin (load i8* %$0)) (let %$1 (index %this %struct.String 1)) (let %length (load u64 %$1)) (let %$3 (ptrtoint i8* u64 %begin)) (let %$2 (+ u64 %$3 %length)) (let %one-past-last (inttoptr u64 i8* %$2)) (return %one-past-last i8*))) (def @String$ptr.pushChar (params (%this %struct.String*) (%c i8)) void (do (let %ptr-ref (index %this %struct.String 0)) (let %size-ref (index %this %struct.String 1)) (let %$2 (load i8* %ptr-ref)) (let %$1 (ptrtoint i8* u64 %$2)) (let %$0 (== u64 0 %$1)) (if %$0 (do (call-tail @String$ptr.setFromChar (types %struct.String* i8) void (args %this %c)) return-void)) (let %old-size (load u64 %size-ref)) (let %$4 (load i8* %ptr-ref)) (let %$5 (+ u64 2 %old-size)) (let %$3 (call @realloc (types i8* u64) i8* (args %$4 %$5))) (store %$3 i8* %ptr-ref) (let %$6 (+ u64 1 %old-size)) (store %$6 u64 %size-ref) (let %$9 (load i8* %ptr-ref)) (let %$8 (ptrtoint i8* u64 %$9)) (let %$7 (+ u64 %old-size %$8)) (let %new-char-loc (inttoptr u64 i8* %$7)) (store %c i8 %new-char-loc) return-void)) (def @reverse-pair (params (%begin i8*) (%end i8*)) void (do (let %$1 (ptrtoint i8* u64 %begin)) (let %$2 (ptrtoint i8* u64 %end)) (let %$0 (>= u64 %$1 %$2)) (if %$0 (do return-void)) (call @i8$ptr.swap (types i8* i8*) void (args %begin %end)) (let %$4 (ptrtoint i8* u64 %begin)) (let %$3 (+ u64 %$4 1)) (let %next-begin (inttoptr u64 i8* %$3)) (let %$6 (ptrtoint i8* u64 %end)) (let %$5 (- u64 %$6 1)) (let %next-end (inttoptr u64 i8* %$5)) (call-tail @reverse-pair (types i8* i8*) void (args %next-begin %next-end)) return-void)) (def @String$ptr.reverse-in-place (params (%this %struct.String*)) void (do (let %$0 (index %this %struct.String 0)) (let %begin (load i8* %$0)) (let %$1 (index %this %struct.String 1)) (let %size (load u64 %$1)) (let %$2 (== u64 0 %size)) (if %$2 (do return-void)) (let %$4 (- u64 %size 1)) (let %$5 (ptrtoint i8* u64 %begin)) (let %$3 (+ u64 %$4 %$5)) (let %end (inttoptr u64 i8* %$3)) (call-tail @reverse-pair (types i8* i8*) void (args %begin %end)) return-void)) (def @String$ptr.char-at-unsafe (params (%this %struct.String*) (%i u64)) i8 (do (let %$0 (index %this %struct.String 0)) (let %begin (load i8* %$0)) (let %$4 (ptrtoint i8* u64 %begin)) (let %$3 (+ u64 %i %$4)) (let %$2 (inttoptr u64 i8* %$3)) (let %$1 (load i8 %$2)) (return %$1 i8))) (def @String$ptr.print (params (%this %struct.String*)) void (do (let %$1 (index %this %struct.String 0)) (let %$0 (load i8* %$1)) (let %$3 (index %this %struct.String 1)) (let %$2 (load u64 %$3)) (call @i8$ptr.printn (types i8* u64) void (args %$0 %$2)) return-void)) (def @String$ptr.println (params (%this %struct.String*)) void (do (let %$1 (index %this %struct.String 0)) (let %$0 (load i8* %$1)) (let %$3 (index %this %struct.String 1)) (let %$2 (load u64 %$3)) (call @i8$ptr.printn (types i8* u64) void (args %$0 %$2)) (call @println types void args) return-void)) (def @test.strlen params void (do (let %str-example (str-get 0)) (let %$0 (call @i8$ptr.length (types i8*) u64 (args (str-get 3)))) (call-vargs @printf (types i8* i8* u64) i32 (args (str-get 1) (str-get 2) %$0)) return-void)) (def @test.strview params void (do (auto %string-view %struct.StringView) (let %$0 (call @StringView.makeEmpty types %struct.StringView args)) (store %$0 %struct.StringView %string-view) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %string-view (str-get 4))) (let %$2 (index %string-view %struct.StringView 0)) (let %$1 (load i8* %$2)) (let %$4 (index %string-view %struct.StringView 1)) (let %$3 (load u64 %$4)) (call-vargs @printf (types i8* i8* u64) i32 (args (str-get 5) %$1 %$3)) return-void)) (def @test.basic-string params void (do (auto %string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %string (str-get 6))) (let %$1 (index %string %struct.String 0)) (let %$0 (load i8* %$1)) (let %$3 (index %string %struct.String 1)) (let %$2 (load u64 %$3)) (call-vargs @printf (types i8* i8* u64) i32 (args (str-get 7) %$0 %$2)) return-void)) (def @test.string-self-append params void (do (auto %string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %string (str-get 8))) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %string %string)) (let %$1 (index %string %struct.String 0)) (let %$0 (load i8* %$1)) (call @puts (types i8*) i32 (args %$0)) return-void)) (def @test.string-append-helloworld params void (do (auto %hello %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello (str-get 9))) (auto %world %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %world (str-get 10))) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %hello %world)) (let %$1 (index %hello %struct.String 0)) (let %$0 (load i8* %$1)) (call @puts (types i8*) i32 (args %$0)) return-void)) (def @test.string-pushchar params void (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (let %A (+ i8 65 0)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %A)) (let %$2 (index %acc %struct.String 0)) (let %$1 (load i8* %$2)) (call @puts (types i8*) i32 (args %$1)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %A)) (let %$4 (index %acc %struct.String 0)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %A)) (let %$6 (index %acc %struct.String 0)) (let %$5 (load i8* %$6)) (call @puts (types i8*) i32 (args %$5)) return-void)) (def @test.string-reverse-in-place params void (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (let %A (+ i8 65 0)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %A)) (let %$2 (index %acc %struct.String 0)) (let %$1 (load i8* %$2)) (call @puts (types i8*) i32 (args %$1)) (let %$3 (+ i8 1 %A)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %$3)) (let %$5 (index %acc %struct.String 0)) (let %$4 (load i8* %$5)) (call @puts (types i8*) i32 (args %$4)) (let %$6 (+ i8 2 %A)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %$6)) (let %$8 (index %acc %struct.String 0)) (let %$7 (load i8* %$8)) (call @puts (types i8*) i32 (args %$7)) (let %$9 (index %acc %struct.String 0)) (let %begin (load i8* %$9)) (let %$10 (index %acc %struct.String 1)) (let %size (load u64 %$10)) (let %$12 (- u64 %size 1)) (let %$13 (ptrtoint i8* u64 %begin)) (let %$11 (+ u64 %$12 %$13)) (let %end (inttoptr u64 i8* %$11)) (call @u64.print (types u64) void (args %size)) (let %$14 (load i8 %begin)) (call @i8.print (types i8) void (args %$14)) (let %$15 (load i8 %end)) (call @i8.print (types i8) void (args %$15)) (call @println types void args) (call @i8$ptr.swap (types i8* i8*) void (args %begin %end)) (let %$17 (index %acc %struct.String 0)) (let %$16 (load i8* %$17)) (call @puts (types i8*) i32 (args %$16)) (call @String$ptr.reverse-in-place (types %struct.String*) void (args %acc)) (let %$19 (index %acc %struct.String 0)) (let %$18 (load i8* %$19)) (call @puts (types i8*) i32 (args %$18)) return-void)) (def @test.stringview-nonpointer-eq params void (do (let %$0 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 11)))) (let %$1 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 12)))) (let %passed (call @StringView.eq (types %struct.StringView %struct.StringView) i1 (args %$0 %$1))) (if %passed (do (call @puts (types i8*) i32 (args (str-get 13))) return-void)) (call @puts (types i8*) i32 (args (str-get 14))) return-void)) (def @test.string-prepend-helloworld params void (do (auto %hello %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello (str-get 15))) (auto %world %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %world (str-get 16))) (call @String$ptr.prepend (types %struct.String* %struct.String*) void (args %world %hello)) (call @String$ptr.println (types %struct.String*) void (args %world)) (call @String$ptr.free (types %struct.String*) void (args %world)) (call @String$ptr.free (types %struct.String*) void (args %hello)) return-void)) (struct %struct.File (%name %struct.String) (%file_descriptor i32)) (def @File._open (params (%filename-view %struct.StringView*) (%flags i32)) %struct.File (do (auto %result %struct.File) (let %$0 (index %filename-view %struct.StringView 0)) (let %filename (load i8* %$0)) (let %$1 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %filename-view))) (let %$2 (index %result %struct.File 0)) (store %$1 %struct.String %$2) (let %fd (call-vargs @open (types i8* i32) i32 (args %filename %flags))) (let %$4 (- i32 0 1)) (let %$3 (== i32 %fd %$4)) (if %$3 (do (call-vargs @printf (types i8* i8*) i32 (args (str-get 17) %filename)) (call @exit (types i32) void (args 1)))) (let %$5 (index %result %struct.File 1)) (store %fd i32 %$5) (let %$6 (load %struct.File %result)) (return %$6 %struct.File))) (def @File.open (params (%filename-view %struct.StringView*)) %struct.File (do (let %O_RDONLY (+ i32 0 0)) (let %$0 (call @File._open (types %struct.StringView* i32) %struct.File (args %filename-view %O_RDONLY))) (return %$0 %struct.File))) (def @File.openrw (params (%filename-view %struct.StringView*)) %struct.File (do (let %O_RDWR (+ i32 2 0)) (let %$0 (call @File._open (types %struct.StringView* i32) %struct.File (args %filename-view %O_RDWR))) (return %$0 %struct.File))) (def @File$ptr.getSize (params (%this %struct.File*)) i64 (do (let %SEEK_END (+ i32 2 0)) (let %$2 (index %this %struct.File 1)) (let %$1 (load i32 %$2)) (let %$0 (call @lseek (types i32 i64 i32) i64 (args %$1 0 %SEEK_END))) (return %$0 i64))) (def @File$ptr._mmap (params (%this %struct.File*) (%addr i8*) (%file-length i64) (%prot i32) (%flags i32) (%offset i64)) i8* (do (let %$1 (index %this %struct.File 1)) (let %$0 (load i32 %$1)) (let %result (call @mmap (types i8* u64 i32 i32 i32 i64) i8* (args %addr %file-length %prot %flags %$0 %offset))) (let %$3 (- u64 0 1)) (let %$4 (ptrtoint i8* u64 %result)) (let %$2 (== u64 %$3 %$4)) (if %$2 (do (call @perror (types i8*) void (args (str-get 18))) (call @exit (types i32) void (args 0)))) (return %result i8*))) (def @File$ptr.read (params (%this %struct.File*)) %struct.StringView (do (let %PROT_READ (+ i32 1 0)) (let %MAP_PRIVATE (+ i32 2 0)) (let %file-length (call @File$ptr.getSize (types %struct.File*) i64 (args %this))) (let %$0 (inttoptr u64 i8* 0)) (let %char-ptr (call @File$ptr._mmap (types %struct.File* i8* i64 i32 i32 i64) i8* (args %this %$0 %file-length %PROT_READ %MAP_PRIVATE 0))) (let %$1 (call @StringView.make (types i8* u64) %struct.StringView (args %char-ptr %file-length))) (return %$1 %struct.StringView))) (def @File$ptr.readwrite (params (%this %struct.File*)) %struct.StringView (do (let %PROT_RDWR (+ i32 3 0)) (let %MAP_PRIVATE (+ i32 2 0)) (let %file-length (call @File$ptr.getSize (types %struct.File*) i64 (args %this))) (let %$0 (inttoptr u64 i8* 0)) (let %char-ptr (call @File$ptr._mmap (types %struct.File* i8* i64 i32 i32 i64) i8* (args %this %$0 %file-length %PROT_RDWR %MAP_PRIVATE 0))) (let %$1 (call @StringView.make (types i8* u64) %struct.StringView (args %char-ptr %file-length))) (return %$1 %struct.StringView))) (def @File.unread (params (%view %struct.StringView*)) void (do (let %$1 (index %view %struct.StringView 0)) (let %$0 (load i8* %$1)) (let %$3 (index %view %struct.StringView 1)) (let %$2 (load u64 %$3)) (call @munmap (types i8* u64) i32 (args %$0 %$2)) return-void)) (def @File$ptr.close (params (%this %struct.File*)) void (do (let %$1 (index %this %struct.File 1)) (let %$0 (load i32 %$1)) (call @close (types i32) i32 (args %$0)) return-void)) (def @test.file-cat params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 19))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %$1 (index %file %struct.File 0)) (call @String$ptr.println (types %struct.String*) void (args %$1)) (auto %content %struct.StringView) (let %$2 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$2 %struct.StringView %content) (call @StringView$ptr.print (types %struct.StringView*) void (args %content)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.file-size params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 20))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %size (call @File$ptr.getSize (types %struct.File*) i64 (args %file))) (call-vargs @printf (types i8* i64) i32 (args (str-get 21) %size)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.bad-file-open params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 22))) (call @File.open (types %struct.StringView*) %struct.File (args %filename)) return-void)) (struct %struct.Reader (%content %struct.StringView) (%iter i8*) (%prev i8) (%line u64) (%col u64)) (def @Reader$ptr.set (params (%this %struct.Reader*) (%string-view %struct.StringView*)) void (do (let %$0 (load %struct.StringView %string-view)) (let %$1 (index %this %struct.Reader 0)) (store %$0 %struct.StringView %$1) (let %content (index %this %struct.Reader 0)) (let %$3 (index %string-view %struct.StringView 0)) (let %$2 (load i8* %$3)) (let %$4 (index %this %struct.Reader 1)) (store %$2 i8* %$4) (let %$5 (index %this %struct.Reader 2)) (store 0 i8 %$5) (let %$6 (index %this %struct.Reader 3)) (store 0 u64 %$6) (let %$7 (index %this %struct.Reader 4)) (store 0 u64 %$7) return-void)) (def @Reader$ptr.peek (params (%this %struct.Reader*)) i8 (do (let %$2 (index %this %struct.Reader 1)) (let %$1 (load i8* %$2)) (let %$0 (load i8 %$1)) (return %$0 i8))) (def @Reader$ptr.get (params (%this %struct.Reader*)) i8 (do (let %iter-ref (index %this %struct.Reader 1)) (let %$0 (load i8* %iter-ref)) (let %char (load i8 %$0)) (let %$1 (index %this %struct.Reader 2)) (store %char i8 %$1) (let %$5 (load i8* %iter-ref)) (let %$4 (ptrtoint i8* u64 %$5)) (let %$3 (+ u64 1 %$4)) (let %$2 (inttoptr u64 i8* %$3)) (store %$2 i8* %iter-ref) (let %NEWLINE (+ i8 10 0)) (let %$6 (== i8 %char %NEWLINE)) (if %$6 (do (let %$9 (index %this %struct.Reader 3)) (let %$8 (load u64 %$9)) (let %$7 (+ u64 1 %$8)) (let %$10 (index %this %struct.Reader 3)) (store %$7 u64 %$10) (let %$11 (index %this %struct.Reader 4)) (store 0 u64 %$11) (return %char i8))) (let %$14 (index %this %struct.Reader 4)) (let %$13 (load u64 %$14)) (let %$12 (+ u64 1 %$13)) (let %$15 (index %this %struct.Reader 4)) (store %$12 u64 %$15) (return %char i8))) (def @Reader$ptr.seek-backwards-on-line (params (%this %struct.Reader*) (%line u64) (%col u64)) void (do (let %col-ref (index %this %struct.Reader 4)) (let %$0 (index %this %struct.Reader 4)) (let %curr-col (load u64 %$0)) (let %anti-offset (- u64 %curr-col %col)) (let %$5 (index %this %struct.Reader 1)) (let %$4 (load i8* %$5)) (let %$3 (ptrtoint i8* u64 %$4)) (let %$2 (- u64 %$3 %anti-offset)) (let %$1 (inttoptr u64 i8* %$2)) (let %$6 (index %this %struct.Reader 1)) (store %$1 i8* %$6) (let %$7 (index %this %struct.Reader 4)) (store %col u64 %$7) return-void)) (def @Reader$ptr.seek-forwards.fail (params (%this %struct.Reader*) (%line u64) (%col u64) (%msg i8*)) void (do (call @i8$ptr.unsafe-print (types i8*) void (args %msg)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 23))) (let %$1 (index %this %struct.Reader 3)) (let %$0 (load u64 %$1)) (call @u64.print (types u64) void (args %$0)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 24))) (let %$3 (index %this %struct.Reader 4)) (let %$2 (load u64 %$3)) (call @u64.print (types u64) void (args %$2)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 25))) (call @u64.print (types u64) void (args %line)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 26))) (call @u64.print (types u64) void (args %col)) (call @println types void args) (call @exit (types i32) void (args 1)) return-void)) (def @Reader$ptr.seek-forwards (params (%this %struct.Reader*) (%line u64) (%col u64)) void (do (let %curr-line (index %this %struct.Reader 3)) (let %curr-col (index %this %struct.Reader 4)) (let %$1 (load u64 %curr-line)) (let %$0 (== u64 %line %$1)) (if %$0 (do (let %$3 (load u64 %curr-col)) (let %$2 (== u64 %col %$3)) (if %$2 (do return-void)) (let %$5 (load u64 %curr-col)) (let %$4 (< u64 %col %$5)) (if %$4 (do (call @Reader$ptr.seek-forwards.fail (types %struct.Reader* u64 u64 i8*) void (args %this %line %col (str-get 27))))) (let %$7 (load u64 %curr-col)) (let %$6 (> u64 %col %$7)) (if %$6 (do (call @Reader$ptr.get (types %struct.Reader*) i8 (args %this)) (let %$9 (load u64 %curr-line)) (let %$8 (< u64 %line %$9)) (if %$8 (do (call @Reader$ptr.seek-forwards.fail (types %struct.Reader* u64 u64 i8*) void (args %this %line %col (str-get 28))))) (call @Reader$ptr.seek-forwards (types %struct.Reader* u64 u64) void (args %this %line %col)) return-void)))) (let %$10 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %this))) (if %$10 (do (call @Reader$ptr.seek-forwards.fail (types %struct.Reader* u64 u64 i8*) void (args %this %line %col (str-get 29))))) (let %$12 (load u64 %curr-line)) (let %$11 (< u64 %line %$12)) (if %$11 (do (call @Reader$ptr.seek-forwards.fail (types %struct.Reader* u64 u64 i8*) void (args %this %line %col (str-get 30))))) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %this)) (call @Reader$ptr.seek-forwards (types %struct.Reader* u64 u64) void (args %this %line %col)) return-void)) (def @Reader$ptr.find-next (params (%this %struct.Reader*) (%char i8)) void (do (let %$0 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %this))) (if %$0 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 31))) (call @exit (types i32) void (args 1)))) (let %peeked (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %this))) (let %$1 (== i8 %char %peeked)) (if %$1 (do return-void)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %this)) (call @Reader$ptr.find-next (types %struct.Reader* i8) void (args %this %char)) return-void)) (def @Reader$ptr.pos (params (%this %struct.Reader*)) u64 (do (let %$0 (index %this %struct.Reader 1)) (let %iter (load i8* %$0)) (let %$2 (index %this %struct.Reader 0)) (let %$1 (index %$2 %struct.StringView 0)) (let %start (load i8* %$1)) (let %$3 (ptrtoint i8* u64 %iter)) (let %$4 (ptrtoint i8* u64 %start)) (let %result (- u64 %$3 %$4)) (return %result u64))) (def @Reader$ptr.done (params (%this %struct.Reader*)) i1 (do (let %content (index %this %struct.Reader 0)) (let %$3 (index %content %struct.StringView 0)) (let %$2 (load i8* %$3)) (let %$1 (ptrtoint i8* u64 %$2)) (let %$5 (index %content %struct.StringView 1)) (let %$4 (load u64 %$5)) (let %$0 (+ u64 %$1 %$4)) (let %content-end (inttoptr u64 i8* %$0)) (let %$6 (index %this %struct.Reader 1)) (let %iter (load i8* %$6)) (let %$7 (== i8* %iter %content-end)) (return %$7 i1))) (def @Reader$ptr.reset (params (%this %struct.Reader*)) void (do (let %string-view (index %this %struct.Reader 0)) (let %$1 (index %string-view %struct.StringView 0)) (let %$0 (load i8* %$1)) (let %$2 (index %this %struct.Reader 1)) (store %$0 i8* %$2) (let %$3 (index %this %struct.Reader 2)) (store 0 i8 %$3) (let %$4 (index %this %struct.Reader 3)) (store 0 u64 %$4) (let %$5 (index %this %struct.Reader 4)) (store 0 u64 %$5) return-void)) (def @test.Reader-get$lambda0 (params (%reader %struct.Reader*) (%i i32)) void (do (let %$0 (== i32 %i 0)) (if %$0 (do return-void)) (let %$1 (call @Reader$ptr.get (types %struct.Reader*) i8 (args %reader))) (call @i8.print (types i8) void (args %$1)) (let %$2 (- i32 %i 1)) (call-tail @test.Reader-get$lambda0 (types %struct.Reader* i32) void (args %reader %$2)) return-void)) (def @test.Reader-get params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 32))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %$1 (index %file %struct.File 0)) (call @String$ptr.println (types %struct.String*) void (args %$1)) (auto %content %struct.StringView) (let %$2 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$2 %struct.StringView %content) (auto %reader %struct.Reader) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %reader %content)) (call @test.Reader-get$lambda0 (types %struct.Reader* i32) void (args %reader 50)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.Reader-done$lambda0 (params (%reader %struct.Reader*)) void (do (let %$0 (call @Reader$ptr.get (types %struct.Reader*) i8 (args %reader))) (call @i8.print (types i8) void (args %$0)) (let %$2 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %reader))) (let %$1 (- i1 1 %$2)) (if %$1 (do (call-tail @test.Reader-done$lambda0 (types %struct.Reader*) void (args %reader)))) return-void)) (def @test.Reader-done params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 33))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %$1 (index %file %struct.File 0)) (call @String$ptr.println (types %struct.String*) void (args %$1)) (auto %content %struct.StringView) (let %$2 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$2 %struct.StringView %content) (auto %reader %struct.Reader) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %reader %content)) (call @test.Reader-done$lambda0 (types %struct.Reader*) void (args %reader)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @u64.string_ (params (%this u64) (%acc %struct.String*)) void (do (let %$0 (== u64 0 %this)) (if %$0 (do return-void)) (let %ZERO (+ i8 48 0)) (let %top (% u64 %this 10)) (let %$1 (trunc u64 i8 %top)) (let %c (+ i8 %ZERO %$1)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %c)) (let %rest (/ u64 %this 10)) (call-tail @u64.string_ (types u64 %struct.String*) void (args %rest %acc)) return-void)) (def @u64.string (params (%this u64)) %struct.String (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (let %ZERO (+ i8 48 0)) (let %$1 (== u64 0 %this)) (if %$1 (do (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %ZERO)) (let %$2 (load %struct.String %acc)) (return %$2 %struct.String))) (call @u64.string_ (types u64 %struct.String*) void (args %this %acc)) (call @String$ptr.reverse-in-place (types %struct.String*) void (args %acc)) (let %$3 (load %struct.String %acc)) (return %$3 %struct.String))) (def @u64.print (params (%this u64)) void (do (auto %string %struct.String) (let %$0 (call @u64.string (types u64) %struct.String (args %this))) (store %$0 %struct.String %string) (call @String$ptr.print (types %struct.String*) void (args %string)) return-void)) (def @u64.println (params (%this u64)) void (do (call @u64.print (types u64) void (args %this)) (call @println types void args) return-void)) (def @test.u64-print params void (do (call @u64.print (types u64) void (args 12408124)) (call @println types void args) return-void)) (struct %struct.u64-vector (%data u64*) (%len u64) (%cap u64)) (def @u64-vector.make params %struct.u64-vector (do (auto %result %struct.u64-vector) (let %$0 (inttoptr u64 u64* 0)) (let %$1 (index %result %struct.u64-vector 0)) (store %$0 u64* %$1) (let %$2 (index %result %struct.u64-vector 1)) (store 0 u64 %$2) (let %$3 (index %result %struct.u64-vector 2)) (store 0 u64 %$3) (let %$4 (load %struct.u64-vector %result)) (return %$4 %struct.u64-vector))) (def @u64-vector$ptr.push (params (%this %struct.u64-vector*) (%item u64)) void (do (let %SIZEOF-u64 (+ u64 8 0)) (let %data-ref (index %this %struct.u64-vector 0)) (let %length-ref (index %this %struct.u64-vector 1)) (let %cap-ref (index %this %struct.u64-vector 2)) (let %$1 (load u64 %length-ref)) (let %$2 (load u64 %cap-ref)) (let %$0 (== u64 %$1 %$2)) (if %$0 (do (let %old-capacity (load u64 %cap-ref)) (let %$3 (== u64 0 %old-capacity)) (if %$3 (do (store 1 u64 %cap-ref))) (let %$4 (!= u64 0 %old-capacity)) (if %$4 (do (let %$5 (* u64 2 %old-capacity)) (store %$5 u64 %cap-ref))) (let %new-capacity (load u64 %cap-ref)) (let %old-data (load u64* %data-ref)) (let %$7 (bitcast u64* i8* %old-data)) (let %$8 (* u64 %SIZEOF-u64 %new-capacity)) (let %$6 (call @realloc (types i8* u64) i8* (args %$7 %$8))) (let %new-data (bitcast i8* u64* %$6)) (let %$9 (index %this %struct.u64-vector 0)) (store %new-data u64* %$9))) (let %$10 (load u64* %data-ref)) (let %data-base (ptrtoint u64* u64 %$10)) (let %$14 (load u64 %length-ref)) (let %$13 (bitcast u64 u64 %$14)) (let %$12 (* u64 %SIZEOF-u64 %$13)) (let %$11 (+ u64 %data-base %$12)) (let %new-child-loc (inttoptr u64 u64* %$11)) (store %item u64 %new-child-loc) (let %$16 (load u64 %length-ref)) (let %$15 (+ u64 1 %$16)) (store %$15 u64 %length-ref) return-void)) (def @u64-vector$ptr.print_ (params (%this %struct.u64-vector*) (%i u64)) void (do (let %$2 (index %this %struct.u64-vector 1)) (let %$1 (load u64 %$2)) (let %$0 (== u64 %$1 %i)) (if %$0 (do return-void)) (let %COMMA (+ i8 44 0)) (let %SPACE (+ i8 32 0)) (call @i8.print (types i8) void (args %COMMA)) (call @i8.print (types i8) void (args %SPACE)) (let %curr (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %this %i))) (call @u64.print (types u64) void (args %curr)) (let %$3 (+ u64 1 %i)) (call-tail @u64-vector$ptr.print_ (types %struct.u64-vector* u64) void (args %this %$3)) return-void)) (def @u64-vector$ptr.print (params (%this %struct.u64-vector*)) void (do (let %LBRACKET (+ i8 91 0)) (let %RBRACKET (+ i8 93 0)) (let %COMMA (+ i8 44 0)) (let %SPACE (+ i8 32 0)) (call @i8.print (types i8) void (args %LBRACKET)) (let %$2 (index %this %struct.u64-vector 1)) (let %$1 (load u64 %$2)) (let %$0 (!= u64 0 %$1)) (if %$0 (do (let %$5 (index %this %struct.u64-vector 0)) (let %$4 (load u64* %$5)) (let %$3 (load u64 %$4)) (call @u64.print (types u64) void (args %$3)))) (let %$8 (index %this %struct.u64-vector 1)) (let %$7 (load u64 %$8)) (let %$6 (!= u64 0 %$7)) (if %$6 (do (call @u64-vector$ptr.print_ (types %struct.u64-vector* u64) void (args %this 1)))) (call @i8.print (types i8) void (args %RBRACKET)) return-void)) (def @u64-vector$ptr.println (params (%this %struct.u64-vector*)) void (do (call @u64-vector$ptr.print (types %struct.u64-vector*) void (args %this)) (call @println types void args) return-void)) (def @u64-vector$ptr.unsafe-get (params (%this %struct.u64-vector*) (%i u64)) u64 (do (let %SIZEOF-u64 (+ u64 8 0)) (let %$3 (* u64 %SIZEOF-u64 %i)) (let %$6 (index %this %struct.u64-vector 0)) (let %$5 (load u64* %$6)) (let %$4 (ptrtoint u64* u64 %$5)) (let %$2 (+ u64 %$3 %$4)) (let %$1 (inttoptr u64 u64* %$2)) (let %$0 (load u64 %$1)) (return %$0 u64))) (def @u64-vector$ptr.unsafe-put (params (%this %struct.u64-vector*) (%i u64) (%value u64)) void (do (let %SIZEOF-u64 (+ u64 8 0)) (let %$2 (* u64 %SIZEOF-u64 %i)) (let %$5 (index %this %struct.u64-vector 0)) (let %$4 (load u64* %$5)) (let %$3 (ptrtoint u64* u64 %$4)) (let %$1 (+ u64 %$2 %$3)) (let %$0 (inttoptr u64 u64* %$1)) (store %value u64 %$0) return-void)) (def @test.u64-vector-basic params void (do (auto %vec %struct.u64-vector) (let %$0 (call @u64-vector.make types %struct.u64-vector args)) (store %$0 %struct.u64-vector %vec) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 0)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 2)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 3)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 4)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 5)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 6)) (call @u64-vector$ptr.println (types %struct.u64-vector*) void (args %vec)) return-void)) (def @test.u64-vector-one params void (do (auto %vec %struct.u64-vector) (let %$0 (call @u64-vector.make types %struct.u64-vector args)) (store %$0 %struct.u64-vector %vec) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 0)) (call @u64-vector$ptr.println (types %struct.u64-vector*) void (args %vec)) return-void)) (def @test.u64-vector-empty params void (do (auto %vec %struct.u64-vector) (let %$0 (call @u64-vector.make types %struct.u64-vector args)) (store %$0 %struct.u64-vector %vec) (call @u64-vector$ptr.println (types %struct.u64-vector*) void (args %vec)) return-void)) (def @test.u64-vector-put params void (do (auto %vec %struct.u64-vector) (let %$0 (call @u64-vector.make types %struct.u64-vector args)) (store %$0 %struct.u64-vector %vec) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 0)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 2)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 3)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 4)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 5)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 6)) (call @u64-vector$ptr.unsafe-put (types %struct.u64-vector* u64 u64) void (args %vec 3 10)) (call @u64-vector$ptr.println (types %struct.u64-vector*) void (args %vec)) return-void)) (def @Result.success (params (%texp %struct.Texp*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 34)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Result.success-from-i8$ptr (params (%cstr i8*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 35)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args %cstr))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Result.error (params (%texp %struct.Texp*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 36)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Result.error-from-view (params (%view %struct.StringView*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 37)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp.makeFromStringView (types %struct.StringView*) %struct.Texp (args %view))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Result.error-from-i8$ptr (params (%cstr i8*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 38)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args %cstr))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Optional.some (params (%texp %struct.Texp*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 39)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Optional.none params %struct.Texp (do (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 40)))) (return %$0 %struct.Texp))) (struct %struct.Texp (%value %struct.String) (%children %struct.Texp*) (%length u64) (%capacity u64)) (def @Texp$ptr.setFromString (params (%this %struct.Texp*) (%value %struct.String*)) void (do (let %$0 (load %struct.String %value)) (let %$1 (index %this %struct.Texp 0)) (store %$0 %struct.String %$1) (let %$2 (inttoptr u64 %struct.Texp* 0)) (let %$3 (index %this %struct.Texp 1)) (store %$2 %struct.Texp* %$3) (let %$4 (index %this %struct.Texp 2)) (store 0 u64 %$4) (let %$5 (index %this %struct.Texp 3)) (store 0 u64 %$5) return-void)) (def @Texp.makeEmpty params %struct.Texp (do (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 41)))) (return %$0 %struct.Texp))) (def @Texp.makeFromi8$ptr (params (%value-cstr i8*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @String.makeFromi8$ptr (types i8*) %struct.String (args %value-cstr))) (let %$1 (index %result %struct.Texp 0)) (store %$0 %struct.String %$1) (let %$2 (inttoptr u64 %struct.Texp* 0)) (let %$3 (index %result %struct.Texp 1)) (store %$2 %struct.Texp* %$3) (let %$4 (index %result %struct.Texp 2)) (store 0 u64 %$4) (let %$5 (index %result %struct.Texp 3)) (store 0 u64 %$5) (let %$6 (load %struct.Texp %result)) (return %$6 %struct.Texp))) (def @Texp.makeFromString (params (%value %struct.String*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %value))) (let %$1 (index %result %struct.Texp 0)) (store %$0 %struct.String %$1) (let %$2 (inttoptr u64 %struct.Texp* 0)) (let %$3 (index %result %struct.Texp 1)) (store %$2 %struct.Texp* %$3) (let %$4 (index %result %struct.Texp 2)) (store 0 u64 %$4) (let %$5 (index %result %struct.Texp 3)) (store 0 u64 %$5) (let %$6 (load %struct.Texp %result)) (return %$6 %struct.Texp))) (def @Texp.makeFromStringView (params (%value-view %struct.StringView*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %value-view))) (let %$1 (index %result %struct.Texp 0)) (store %$0 %struct.String %$1) (let %$2 (inttoptr u64 %struct.Texp* 0)) (let %$3 (index %result %struct.Texp 1)) (store %$2 %struct.Texp* %$3) (let %$4 (index %result %struct.Texp 2)) (store 0 u64 %$4) (let %$5 (index %result %struct.Texp 3)) (store 0 u64 %$5) (let %$6 (load %struct.Texp %result)) (return %$6 %struct.Texp))) (def @Texp$ptr.push$ptr (params (%this %struct.Texp*) (%item %struct.Texp*)) void (do (let %SIZEOF-Texp (+ u64 40 0)) (let %children-ref (index %this %struct.Texp 1)) (let %length-ref (index %this %struct.Texp 2)) (let %cap-ref (index %this %struct.Texp 3)) (let %$1 (load u64 %length-ref)) (let %$2 (load u64 %cap-ref)) (let %$0 (== u64 %$1 %$2)) (if %$0 (do (let %old-capacity (load u64 %cap-ref)) (let %$3 (== u64 0 %old-capacity)) (if %$3 (do (store 1 u64 %cap-ref))) (let %$4 (!= u64 0 %old-capacity)) (if %$4 (do (let %$5 (* u64 2 %old-capacity)) (store %$5 u64 %cap-ref))) (let %new-capacity (load u64 %cap-ref)) (let %old-children (load %struct.Texp* %children-ref)) (let %$7 (bitcast %struct.Texp* i8* %old-children)) (let %$8 (* u64 %SIZEOF-Texp %new-capacity)) (let %$6 (call @realloc (types i8* u64) i8* (args %$7 %$8))) (let %new-children (bitcast i8* %struct.Texp* %$6)) (let %$9 (index %this %struct.Texp 1)) (store %new-children %struct.Texp* %$9))) (let %$10 (load %struct.Texp* %children-ref)) (let %children-base (ptrtoint %struct.Texp* u64 %$10)) (let %$14 (load u64 %length-ref)) (let %$13 (bitcast u64 u64 %$14)) (let %$12 (* u64 %SIZEOF-Texp %$13)) (let %$11 (+ u64 %$12 %children-base)) (let %new-child-loc (inttoptr u64 %struct.Texp* %$11)) (let %$15 (load %struct.Texp %item)) (store %$15 %struct.Texp %new-child-loc) (let %$17 (load u64 %length-ref)) (let %$16 (+ u64 1 %$17)) (store %$16 u64 %length-ref) return-void)) (def @Texp$ptr.push (params (%this %struct.Texp*) (%item %struct.Texp)) void (do (auto %local-item %struct.Texp) (store %item %struct.Texp %local-item) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %this %local-item)) return-void)) (def @Texp$ptr.free$lambda.child-iter (params (%this %struct.Texp*) (%child-index u64)) void (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %this %struct.Texp 1)) (let %children (load %struct.Texp* %$0)) (let %$1 (index %this %struct.Texp 2)) (let %length (load u64 %$1)) (let %$2 (== u64 %child-index %length)) (if %$2 (do return-void)) (let %$4 (* u64 %SIZEOF-Texp %child-index)) (let %$5 (ptrtoint %struct.Texp* u64 %children)) (let %$3 (+ u64 %$4 %$5)) (let %curr (inttoptr u64 %struct.Texp* %$3)) (call @Texp$ptr.free (types %struct.Texp*) void (args %curr)) (let %$6 (+ u64 1 %child-index)) (call-tail @Texp$ptr.free$lambda.child-iter (types %struct.Texp* u64) void (args %this %$6)) return-void)) (def @Texp$ptr.free (params (%this %struct.Texp*)) void (do (let %$0 (index %this %struct.Texp 0)) (call @String$ptr.free (types %struct.String*) void (args %$0)) (let %$3 (index %this %struct.Texp 1)) (let %$2 (load %struct.Texp* %$3)) (let %$1 (bitcast %struct.Texp* i8* %$2)) (call @free (types i8*) void (args %$1)) (call @Texp$ptr.free$lambda.child-iter (types %struct.Texp* u64) void (args %this 0)) return-void)) (def @Texp$ptr.demote-free (params (%this %struct.Texp*)) void (do (let %$0 (index %this %struct.Texp 0)) (call @String$ptr.free (types %struct.String*) void (args %$0)) (let %$1 (index %this %struct.Texp 1)) (let %child-ref (load %struct.Texp* %$1)) (let %$2 (load %struct.Texp %child-ref)) (store %$2 %struct.Texp %this) (let %$3 (bitcast %struct.Texp* i8* %child-ref)) (call @free (types i8*) void (args %$3)) return-void)) (def @Texp$ptr.shallow-free (params (%this %struct.Texp*)) void (do return-void)) (def @Texp$ptr.clone_ (params (%acc %struct.Texp*) (%curr %struct.Texp*) (%last %struct.Texp*)) void (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %curr))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %acc %$0)) (let %$1 (== %struct.Texp* %last %curr)) (if %$1 (do return-void)) (let %$3 (ptrtoint %struct.Texp* u64 %curr)) (let %$2 (+ u64 %SIZEOF-Texp %$3)) (let %next (inttoptr u64 %struct.Texp* %$2)) (call @Texp$ptr.clone_ (types %struct.Texp* %struct.Texp* %struct.Texp*) void (args %acc %next %last)) return-void)) (def @Texp$ptr.clone (params (%this %struct.Texp*)) %struct.Texp (do (auto %result %struct.Texp) (let %$1 (index %this %struct.Texp 0)) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %$1))) (let %$2 (index %result %struct.Texp 0)) (store %$0 %struct.String %$2) (let %$4 (index %result %struct.Texp 1)) (let %$3 (bitcast %struct.Texp** u64* %$4)) (store 0 u64 %$3) (let %$5 (index %result %struct.Texp 2)) (store 0 u64 %$5) (let %$6 (index %result %struct.Texp 3)) (store 0 u64 %$6) (let %$9 (index %this %struct.Texp 2)) (let %$8 (load u64 %$9)) (let %$7 (!= u64 0 %$8)) (if %$7 (do (let %$11 (index %this %struct.Texp 1)) (let %$10 (load %struct.Texp* %$11)) (let %$12 (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %this))) (call @Texp$ptr.clone_ (types %struct.Texp* %struct.Texp* %struct.Texp*) void (args %result %$10 %$12)))) (let %$13 (load %struct.Texp %result)) (return %$13 %struct.Texp))) (def @Texp$ptr.parenPrint$lambda.child-iter (params (%this %struct.Texp*) (%child-index u64)) void (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %this %struct.Texp 1)) (let %children (load %struct.Texp* %$0)) (let %$1 (index %this %struct.Texp 2)) (let %length (load u64 %$1)) (let %$2 (== u64 %child-index %length)) (if %$2 (do return-void)) (let %$4 (* u64 %SIZEOF-Texp %child-index)) (let %$5 (ptrtoint %struct.Texp* u64 %children)) (let %$3 (+ u64 %$4 %$5)) (let %curr (inttoptr u64 %struct.Texp* %$3)) (let %$6 (!= u64 0 %child-index)) (if %$6 (do (let %SPACE (+ i8 32 0)) (call @i8.print (types i8) void (args %SPACE)))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %curr)) (let %$7 (+ u64 1 %child-index)) (call-tail @Texp$ptr.parenPrint$lambda.child-iter (types %struct.Texp* u64) void (args %this %$7)) return-void)) (def @Texp$ptr.parenPrint (params (%this %struct.Texp*)) void (do (let %$1 (ptrtoint %struct.Texp* u64 %this)) (let %$0 (== u64 0 %$1)) (if %$0 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 42))) return-void)) (let %value-ref (index %this %struct.Texp 0)) (let %$2 (index %this %struct.Texp 2)) (let %length (load u64 %$2)) (let %$3 (== u64 0 %length)) (if %$3 (do (call @String$ptr.print (types %struct.String*) void (args %value-ref)) return-void)) (let %LPAREN (+ i8 40 0)) (let %RPAREN (+ i8 41 0)) (let %SPACE (+ i8 32 0)) (call @i8.print (types i8) void (args %LPAREN)) (call @String$ptr.print (types %struct.String*) void (args %value-ref)) (call @i8.print (types i8) void (args %SPACE)) (call @Texp$ptr.parenPrint$lambda.child-iter (types %struct.Texp* u64) void (args %this 0)) (call @i8.print (types i8) void (args %RPAREN)) return-void)) (def @Texp$ptr.shallow-dump (params (%this %struct.Texp*)) void (do (let %$1 (ptrtoint %struct.Texp* u64 %this)) (let %$0 (!= u64 0 %$1)) (if %$0 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 43))) (let %$2 (index %this %struct.Texp 0)) (call @String$ptr.print (types %struct.String*) void (args %$2)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 44))) (let %$4 (index %this %struct.Texp 2)) (let %$3 (load u64 %$4)) (call @u64.print (types u64) void (args %$3)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 45))) (let %$6 (index %this %struct.Texp 3)) (let %$5 (load u64 %$6)) (call @u64.print (types u64) void (args %$5)))) (let %$8 (ptrtoint %struct.Texp* u64 %this)) (let %$7 (== u64 0 %$8)) (if %$7 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 46))))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 47))) (let %$9 (ptrtoint %struct.Texp* u64 %this)) (call @u64.println (types u64) void (args %$9)) return-void)) (def @Texp$ptr.last (params (%this %struct.Texp*)) %struct.Texp* (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %this %struct.Texp 2)) (let %len (load u64 %$0)) (let %$1 (index %this %struct.Texp 1)) (let %first-child (load %struct.Texp* %$1)) (let %$3 (ptrtoint %struct.Texp* u64 %first-child)) (let %$5 (- u64 %len 1)) (let %$4 (* u64 %SIZEOF-Texp %$5)) (let %$2 (+ u64 %$3 %$4)) (let %last (inttoptr u64 %struct.Texp* %$2)) (return %last %struct.Texp*))) (def @Texp$ptr.child (params (%this %struct.Texp*) (%i u64)) %struct.Texp* (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %this %struct.Texp 1)) (let %first-child (load %struct.Texp* %$0)) (let %$2 (ptrtoint %struct.Texp* u64 %first-child)) (let %$3 (* u64 %SIZEOF-Texp %i)) (let %$1 (+ u64 %$2 %$3)) (let %child (inttoptr u64 %struct.Texp* %$1)) (return %child %struct.Texp*))) (def @Texp$ptr.find_ (params (%this %struct.Texp*) (%last %struct.Texp*) (%key %struct.StringView*)) %struct.Texp* (do (let %SIZEOF-Texp (+ u64 40 0)) (let %view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %this))) (let %$0 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %view %key))) (if %$0 (do (return %this %struct.Texp*))) (let %$1 (== %struct.Texp* %this %last)) (if %$1 (do (let %$2 (inttoptr u64 %struct.Texp* 0)) (return %$2 %struct.Texp*))) (let %$4 (ptrtoint %struct.Texp* u64 %this)) (let %$3 (+ u64 %SIZEOF-Texp %$4)) (let %next (inttoptr u64 %struct.Texp* %$3)) (let %$5 (call @Texp$ptr.find_ (types %struct.Texp* %struct.Texp* %struct.StringView*) %struct.Texp* (args %next %last %key))) (return %$5 %struct.Texp*))) (def @Texp$ptr.find (params (%this %struct.Texp*) (%key %struct.StringView*)) %struct.Texp* (do (let %$0 (index %this %struct.Texp 1)) (let %first (load %struct.Texp* %$0)) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %this))) (let %$1 (call @Texp$ptr.find_ (types %struct.Texp* %struct.Texp* %struct.StringView*) %struct.Texp* (args %first %last %key))) (return %$1 %struct.Texp*))) (def @Texp$ptr.is-empty (params (%this %struct.Texp*)) i1 (do (let %$2 (index %this %struct.Texp 2)) (let %$1 (load u64 %$2)) (let %$0 (== u64 0 %$1)) (return %$0 i1))) (def @Texp$ptr.value-check (params (%this %struct.Texp*) (%check i8*)) i1 (do (let %check-view (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args %check))) (let %$0 (index %this %struct.Texp 0)) (let %value-view (call @String$ptr.view (types %struct.String*) %struct.StringView (args %$0))) (let %$1 (call @StringView.eq (types %struct.StringView %struct.StringView) i1 (args %check-view %value-view))) (return %$1 i1))) (def @Texp$ptr.value-view (params (%this %struct.Texp*)) %struct.StringView* (do (let %$1 (index %this %struct.Texp 0)) (let %$0 (bitcast %struct.String* %struct.StringView* %$1)) (return %$0 %struct.StringView*))) (def @Texp$ptr.value-get (params (%this %struct.Texp*) (%i u64)) i8 (do (let %$1 (index %this %struct.Texp 0)) (let %$0 (index %$1 %struct.String 0)) (let %value (load i8* %$0)) (let %$3 (ptrtoint i8* u64 %value)) (let %$2 (+ u64 %i %$3)) (let %cptr (inttoptr u64 i8* %$2)) (let %$4 (load i8 %cptr)) (return %$4 i8))) (def @test.Texp-basic$lamdba.dump (params (%texp %struct.Texp*)) void (do (call @println types void args) (let %$1 (index %texp %struct.Texp 2)) (let %$0 (load u64 %$1)) (call @u64.print (types u64) void (args %$0)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) return-void)) (def @test.Texp-basic params void (do (auto %hello-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello-string (str-get 48))) (auto %child0-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child0-string (str-get 49))) (auto %child1-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child1-string (str-get 50))) (auto %child2-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child2-string (str-get 51))) (auto %texp %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %hello-string)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (auto %texp-child %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child0-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child1-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child2-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.free (types %struct.Texp*) void (args %texp)) return-void)) (def @test.Texp-clone params void (do (auto %hello-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello-string (str-get 52))) (auto %child0-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child0-string (str-get 53))) (auto %child1-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child1-string (str-get 54))) (auto %child2-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child2-string (str-get 55))) (auto %texp %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %hello-string)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (auto %texp-child %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child0-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child1-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child2-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.free (types %struct.Texp*) void (args %texp)) return-void)) (def @test.Texp-clone-atom params void (do (auto %texp %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 56)))) (store %$0 %struct.Texp %texp) (auto %clone %struct.Texp) (let %$1 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (store %$1 %struct.Texp %clone) (let %$4 (index %texp %struct.Texp 0)) (let %$3 (index %$4 %struct.String 0)) (let %$2 (ptrtoint i8** u64 %$3)) (call @u64.print (types u64) void (args %$2)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 57))) (call @Texp$ptr.shallow-dump (types %struct.Texp*) void (args %texp)) (call @println types void args) (let %$7 (index %clone %struct.Texp 0)) (let %$6 (index %$7 %struct.String 0)) (let %$5 (ptrtoint i8** u64 %$6)) (call @u64.print (types u64) void (args %$5)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 58))) (call @Texp$ptr.shallow-dump (types %struct.Texp*) void (args %clone)) (call @println types void args) return-void)) (def @test.Texp-clone-hard params void (do (auto %content-view %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %content-view (str-get 59))) (auto %parser %struct.Parser) (let %$0 (bitcast %struct.Parser* %struct.Reader* %parser)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$0 %content-view)) (auto %result %struct.Texp) (let %$1 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %parser))) (store %$1 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) (auto %clone %struct.Texp) (let %$2 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %result))) (store %$2 %struct.Texp %clone) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %clone)) (call @println types void args) return-void)) (def @test.Texp-value-get params void (do (auto %hello-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello-string (str-get 60))) (auto %texp %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %hello-string)) (let %E_CHAR (+ i8 101 0)) (let %$0 (call @Texp$ptr.value-get (types %struct.Texp* u64) i8 (args %texp 1))) (let %success (== i8 %E_CHAR %$0)) (if %success (do (call @puts (types i8*) i32 (args (str-get 61))))) (let %$1 (- i1 1 %success)) (if %$1 (do (call @puts (types i8*) i32 (args (str-get 62))))) (call @Texp$ptr.free (types %struct.Texp*) void (args %texp)) return-void)) (def @test.Texp-program-grammar-eq params void (do (auto %grammar-texp %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 63)))) (store %$0 %struct.Texp %grammar-texp) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %grammar-texp)) (auto %start-production %struct.StringView) (let %$1 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 64)))) (store %$1 %struct.StringView %start-production) (let %first-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %grammar-texp 0))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %first-child)) (call @println types void args) (let %view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %first-child))) (let %$2 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %view %start-production))) (if %$2 (do (call @puts (types i8*) i32 (args (str-get 65))) return-void)) (call @puts (types i8*) i32 (args (str-get 66))) return-void)) (def @test.Texp-find-program-grammar params void (do (auto %grammar-texp %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 67)))) (store %$0 %struct.Texp %grammar-texp) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %grammar-texp)) (auto %start-production %struct.StringView) (let %$1 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 68)))) (store %$1 %struct.StringView %start-production) (let %found-texp (call @Texp$ptr.find (types %struct.Texp* %struct.StringView*) %struct.Texp* (args %grammar-texp %start-production))) (let %$3 (ptrtoint %struct.Texp* u64 %found-texp)) (let %$2 (== u64 0 %$3)) (if %$2 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 69))))) (let %$5 (ptrtoint %struct.Texp* u64 %found-texp)) (let %$4 (!= u64 0 %$5)) (if %$4 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 70))))) return-void)) (def @test.Texp-makeFromi8$ptr params void (do (auto %string %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 71)))) (store %$0 %struct.Texp %string) (let %$4 (index %string %struct.Texp 0)) (let %$3 (index %$4 %struct.String 1)) (let %$2 (load u64 %$3)) (let %$1 (== u64 10 %$2)) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 72))) return-void)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 73))) return-void)) (def @test.Texp-value-view params void (do (auto %string %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 74)))) (store %$0 %struct.Texp %string) (let %value-view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %string))) (let %$3 (index %value-view %struct.StringView 1)) (let %$2 (load u64 %$3)) (let %$1 (== u64 10 %$2)) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 75))) return-void)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 76))) return-void)) (def @i8.isspace (params (%this i8)) i1 (do (let %$0 (== i8 %this 32)) (if %$0 (do (return true i1))) (let %$1 (== i8 %this 12)) (if %$1 (do (return true i1))) (let %$2 (== i8 %this 10)) (if %$2 (do (return true i1))) (let %$3 (== i8 %this 13)) (if %$3 (do (return true i1))) (let %$4 (== i8 %this 9)) (if %$4 (do (return true i1))) (let %$5 (== i8 %this 11)) (if %$5 (do (return true i1))) (return false i1))) (struct %struct.Parser (%reader %struct.Reader) (%lines %struct.u64-vector) (%cols %struct.u64-vector) (%types %struct.u64-vector) (%filename %struct.StringView)) (def @Parser.make (params (%content %struct.StringView*)) %struct.Parser (do (auto %result %struct.Parser) (let %$0 (index %result %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$0 %content)) (let %$1 (call @u64-vector.make types %struct.u64-vector args)) (let %$2 (index %result %struct.Parser 1)) (store %$1 %struct.u64-vector %$2) (let %$3 (call @u64-vector.make types %struct.u64-vector args)) (let %$4 (index %result %struct.Parser 2)) (store %$3 %struct.u64-vector %$4) (let %$5 (call @u64-vector.make types %struct.u64-vector args)) (let %$6 (index %result %struct.Parser 3)) (store %$5 %struct.u64-vector %$6) (let %$7 (call @StringView.makeEmpty types %struct.StringView args)) (let %$8 (index %result %struct.Parser 4)) (store %$7 %struct.StringView %$8) (let %$9 (load %struct.Parser %result)) (return %$9 %struct.Parser))) (def @Parser$ptr.unmake (params (%this %struct.Parser*)) void (do return-void)) (def @Parser$ptr.add-coord (params (%this %struct.Parser*) (%type u64)) void (do (let %reader (index %this %struct.Parser 0)) (let %$0 (index %reader %struct.Reader 3)) (let %line (load u64 %$0)) (let %$1 (index %reader %struct.Reader 4)) (let %col (load u64 %$1)) (let %$2 (index %this %struct.Parser 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$2 %line)) (let %$3 (index %this %struct.Parser 2)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$3 %col)) (let %$4 (index %this %struct.Parser 3)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$4 %type)) return-void)) (def @Parser$ptr.add-open-coord (params (%this %struct.Parser*)) void (do (call @Parser$ptr.add-coord (types %struct.Parser* u64) void (args %this 0)) return-void)) (def @Parser$ptr.add-close-coord (params (%this %struct.Parser*)) void (do (call @Parser$ptr.add-coord (types %struct.Parser* u64) void (args %this 1)) return-void)) (def @Parser$ptr.add-value-coord (params (%this %struct.Parser*)) void (do (call @Parser$ptr.add-coord (types %struct.Parser* u64) void (args %this 2)) return-void)) (def @Parser$ptr.add-comment-coord (params (%this %struct.Parser*)) void (do (let %reader (index %this %struct.Parser 0)) (let %$0 (index %reader %struct.Reader 3)) (let %line (load u64 %$0)) (let %$1 (index %reader %struct.Reader 4)) (let %col (load u64 %$1)) (let %$2 (index %this %struct.Parser 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$2 %line)) (let %$3 (index %this %struct.Parser 2)) (let %$4 (- u64 %col 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$3 %$4)) (let %$5 (index %this %struct.Parser 3)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$5 3)) return-void)) (def @Parser$ptr.whitespace (params (%this %struct.Parser*)) void (do (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (call @i8.isspace (types i8) i1 (args %$1))) (if %$0 (do (let %$3 (index %this %struct.Parser 0)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$3)) (call-tail @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) return-void)) return-void)) (def @Parser$ptr.word_ (params (%this %struct.Parser*) (%acc %struct.String*)) void (do (let %reader (index %this %struct.Parser 0)) (let %$0 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %reader))) (if %$0 (do return-void)) (let %LPAREN (+ i8 40 0)) (let %RPAREN (+ i8 41 0)) (let %c (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %reader))) (let %$1 (== i8 %LPAREN %c)) (if %$1 (do return-void)) (let %$2 (== i8 %RPAREN %c)) (if %$2 (do return-void)) (let %$3 (call @i8.isspace (types i8) i1 (args %c))) (if %$3 (do return-void)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %reader)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %c)) (call-tail @Parser$ptr.word_ (types %struct.Parser* %struct.String*) void (args %this %acc)) return-void)) (def @Parser$ptr.word (params (%this %struct.Parser*)) %struct.String (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (call @Parser$ptr.word_ (types %struct.Parser* %struct.String*) void (args %this %acc)) (let %$1 (load %struct.String %acc)) (return %$1 %struct.String))) (def @Parser$ptr.string_ (params (%this %struct.Parser*) (%acc %struct.String*)) void (do (let %QUOTE (+ i8 34 0)) (let %BACKSLASH (+ i8 92 0)) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (== i8 %QUOTE %$1)) (if %$0 (do (let %$4 (index %this %struct.Parser 0)) (let %$3 (index %$4 %struct.Reader 2)) (let %prev (load i8 %$3)) (let %$5 (!= i8 %BACKSLASH %prev)) (if %$5 (do return-void)))) (let %$6 (index %this %struct.Parser 0)) (let %c (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$6))) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %c)) (call-tail @Parser$ptr.string_ (types %struct.Parser* %struct.String*) void (args %this %acc)) return-void)) (def @Parser$ptr.string (params (%this %struct.Parser*)) %struct.Texp (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$2))) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %$1)) (call @Parser$ptr.string_ (types %struct.Parser* %struct.String*) void (args %this %acc)) (let %$4 (index %this %struct.Parser 0)) (let %$3 (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$4))) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %$3)) (auto %texp %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %acc)) (let %$5 (load %struct.Texp %texp)) (return %$5 %struct.Texp))) (def @Parser$ptr.atom (params (%this %struct.Parser*)) %struct.Texp (do (call @Parser$ptr.add-value-coord (types %struct.Parser*) void (args %this)) (let %QUOTE (+ i8 34 0)) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (== i8 %QUOTE %$1)) (if %$0 (do (let %$3 (call @Parser$ptr.string (types %struct.Parser*) %struct.Texp (args %this))) (return %$3 %struct.Texp))) (auto %texp %struct.Texp) (auto %word %struct.String) (let %$4 (call @Parser$ptr.word (types %struct.Parser*) %struct.String (args %this))) (store %$4 %struct.String %word) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %word)) (let %$5 (load %struct.Texp %texp)) (return %$5 %struct.Texp))) (def @Parser$ptr.list_ (params (%this %struct.Parser*) (%acc %struct.Texp*)) void (do (let %RPAREN (+ i8 41 0)) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (!= i8 %RPAREN %$1)) (if %$0 (do (auto %texp %struct.Texp) (let %$3 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %this))) (store %$3 %struct.Texp %texp) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %acc %texp)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (call @Parser$ptr.list_ (types %struct.Parser* %struct.Texp*) void (args %this %acc)))) return-void)) (def @Parser$ptr.list (params (%this %struct.Parser*)) %struct.Texp (do (call @Parser$ptr.add-open-coord (types %struct.Parser*) void (args %this)) (let %$0 (index %this %struct.Parser 0)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$0)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (call @Parser$ptr.add-value-coord (types %struct.Parser*) void (args %this)) (auto %curr %struct.Texp) (auto %word %struct.String) (let %$1 (call @Parser$ptr.word (types %struct.Parser*) %struct.String (args %this))) (store %$1 %struct.String %word) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %curr %word)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (call @Parser$ptr.list_ (types %struct.Parser* %struct.Texp*) void (args %this %curr)) (call @Parser$ptr.add-close-coord (types %struct.Parser*) void (args %this)) (let %$2 (index %this %struct.Parser 0)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$2)) (let %$3 (load %struct.Texp %curr)) (return %$3 %struct.Texp))) (def @Parser$ptr.texp (params (%this %struct.Parser*)) %struct.Texp (do (let %LPAREN (+ i8 40 0)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (== i8 %LPAREN %$1)) (if %$0 (do (let %$3 (call @Parser$ptr.list (types %struct.Parser*) %struct.Texp (args %this))) (return %$3 %struct.Texp))) (let %$4 (call @Parser$ptr.atom (types %struct.Parser*) %struct.Texp (args %this))) (return %$4 %struct.Texp))) (def @Parser$ptr.collect (params (%this %struct.Parser*) (%parent %struct.Texp*)) void (do (let %$1 (index %this %struct.Parser 0)) (let %$0 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %$1))) (if %$0 (do return-void)) (auto %child %struct.Texp) (let %$2 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %this))) (store %$2 %struct.Texp %child) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %parent %child)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (call @Parser$ptr.collect (types %struct.Parser* %struct.Texp*) void (args %this %parent)) return-void)) (def @Parser$ptr.remove-comments_ (params (%this %struct.Parser*) (%state i8)) void (do (let %NEWLINE (+ i8 10 0)) (let %SPACE (+ i8 32 0)) (let %QUOTE (+ i8 34 0)) (let %SEMICOLON (+ i8 59 0)) (let %BACKSLASH (+ i8 92 0)) (let %COMMENT_STATE (- i8 0 1)) (let %START_STATE (+ i8 0 0)) (let %STRING_STATE (+ i8 1 0)) (let %CHAR_STATE (+ i8 2 0)) (let %reader (index %this %struct.Parser 0)) (let %done (call @Reader$ptr.done (types %struct.Reader*) i1 (args %reader))) (if %done (do (call @Reader$ptr.reset (types %struct.Reader*) void (args %reader)) return-void)) (let %c (call @Reader$ptr.get (types %struct.Reader*) i8 (args %reader))) (let %$0 (== i8 %COMMENT_STATE %state)) (if %$0 (do (let %$1 (== i8 %NEWLINE %c)) (if %$1 (do (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %START_STATE)) return-void)) (let %$6 (index %reader %struct.Reader 1)) (let %$5 (load i8* %$6)) (let %$4 (ptrtoint i8* u64 %$5)) (let %$3 (- u64 %$4 1)) (let %$2 (inttoptr u64 i8* %$3)) (store %SPACE i8 %$2) (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %state)) return-void)) (let %$7 (== i8 %START_STATE %state)) (if %$7 (do (let %$8 (== i8 %QUOTE %c)) (if %$8 (do (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %STRING_STATE)) return-void)) (let %$9 (== i8 %SEMICOLON %c)) (if %$9 (do (call @Parser$ptr.add-comment-coord (types %struct.Parser*) void (args %this)) (let %$14 (index %reader %struct.Reader 1)) (let %$13 (load i8* %$14)) (let %$12 (ptrtoint i8* u64 %$13)) (let %$11 (- u64 %$12 1)) (let %$10 (inttoptr u64 i8* %$11)) (store %SPACE i8 %$10) (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %COMMENT_STATE)) return-void)) (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %state)) return-void)) (let %$15 (== i8 %STRING_STATE %state)) (if %$15 (do (let %$16 (== i8 %QUOTE %c)) (if %$16 (do (let %$17 (index %reader %struct.Reader 2)) (let %prev (load i8 %$17)) (let %$18 (!= i8 %BACKSLASH %prev)) (if %$18 (do (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %START_STATE)) return-void)))) (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %state)) return-void)) return-void)) (def @Parser$ptr.remove-comments (params (%this %struct.Parser*)) void (do (call @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this 0)) return-void)) (def @Parser.parse-file.intro (params (%filename %struct.StringView*) (%file %struct.File*) (%content %struct.StringView*) (%parser %struct.Parser*)) %struct.Texp (do (let %$0 (call @File.openrw (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %$1 (call @File$ptr.readwrite (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (let %$2 (call @Parser.make (types %struct.StringView*) %struct.Parser (args %content))) (store %$2 %struct.Parser %parser) (let %$3 (load %struct.StringView %filename)) (let %$4 (index %parser %struct.Parser 4)) (store %$3 %struct.StringView %$4) (call @Parser$ptr.remove-comments (types %struct.Parser*) void (args %parser)) (auto %prog %struct.Texp) (auto %filename-string %struct.String) (let %$5 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %filename))) (store %$5 %struct.String %filename-string) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %prog %filename-string)) (call @Parser$ptr.collect (types %struct.Parser* %struct.Texp*) void (args %parser %prog)) (let %$6 (load %struct.Texp %prog)) (return %$6 %struct.Texp))) (def @Parser.parse-file.outro (params (%file %struct.File*) (%content %struct.StringView*) (%parser %struct.Parser*)) void (do (call @Parser$ptr.unmake (types %struct.Parser*) void (args %parser)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @Parser.parse-file (params (%filename %struct.StringView*)) %struct.Texp (do (auto %file %struct.File) (auto %content %struct.StringView) (auto %parser %struct.Parser) (let %prog (call @Parser.parse-file.intro (types %struct.StringView* %struct.File* %struct.StringView* %struct.Parser*) %struct.Texp (args %filename %file %content %parser))) (call @Parser.parse-file.outro (types %struct.File* %struct.StringView* %struct.Parser*) void (args %file %content %parser)) (return %prog %struct.Texp))) (def @Parser.parse-file-i8$ptr (params (%filename i8*)) %struct.Texp (do (auto %fn-view %struct.StringView) (let %$0 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args %filename))) (store %$0 %struct.StringView %fn-view) (let %$1 (call @Parser.parse-file (types %struct.StringView*) %struct.Texp (args %fn-view))) (return %$1 %struct.Texp))) (def @test.parser-whitespace params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 77))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %parser)) (let %$8 (index %parser %struct.Parser 0)) (let %$7 (index %$8 %struct.Reader 1)) (let %$6 (load i8* %$7)) (call @puts (types i8*) i32 (args %$6)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %parser)) (let %$11 (index %parser %struct.Parser 0)) (let %$10 (index %$11 %struct.Reader 1)) (let %$9 (load i8* %$10)) (call @puts (types i8*) i32 (args %$9)) (let %$12 (index %parser %struct.Parser 0)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$12)) (let %$15 (index %parser %struct.Parser 0)) (let %$14 (index %$15 %struct.Reader 1)) (let %$13 (load i8* %$14)) (call @puts (types i8*) i32 (args %$13)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %parser)) (let %$18 (index %parser %struct.Parser 0)) (let %$17 (index %$18 %struct.Reader 1)) (let %$16 (load i8* %$17)) (call @puts (types i8*) i32 (args %$16)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-atom params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 78))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (auto %texp %struct.Texp) (let %$6 (call @Parser$ptr.atom (types %struct.Parser*) %struct.Texp (args %parser))) (store %$6 %struct.Texp %texp) (let %$9 (index %parser %struct.Parser 0)) (let %$8 (index %$9 %struct.Reader 1)) (let %$7 (load i8* %$8)) (call @puts (types i8*) i32 (args %$7)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) (auto %texp2 %struct.Texp) (let %$10 (call @Parser$ptr.atom (types %struct.Parser*) %struct.Texp (args %parser))) (store %$10 %struct.Texp %texp2) (let %$13 (index %parser %struct.Parser 0)) (let %$12 (index %$13 %struct.Reader 1)) (let %$11 (load i8* %$12)) (call @puts (types i8*) i32 (args %$11)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp2)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-texp params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 79))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (auto %texp %struct.Texp) (let %$6 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %parser))) (store %$6 %struct.Texp %texp) (let %$9 (index %parser %struct.Parser 0)) (let %$8 (index %$9 %struct.Reader 1)) (let %$7 (load i8* %$8)) (call @puts (types i8*) i32 (args %$7)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-string params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 80))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (auto %texp %struct.Texp) (let %$6 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %parser))) (store %$6 %struct.Texp %texp) (let %$9 (index %parser %struct.Parser 0)) (let %$8 (index %$9 %struct.Reader 1)) (let %$7 (load i8* %$8)) (call @puts (types i8*) i32 (args %$7)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) (let %$11 (index %texp %struct.Texp 2)) (let %$10 (load u64 %$11)) (call @u64.print (types u64) void (args %$10)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-comments params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 81))) (auto %file %struct.File) (let %$0 (call @File.openrw (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.readwrite (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (call @Parser$ptr.remove-comments (types %struct.Parser*) void (args %parser)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (auto %texp %struct.Texp) (let %$6 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %parser))) (store %$6 %struct.Texp %texp) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-file params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 82))) (auto %file %struct.File) (let %$0 (call @File.openrw (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.readwrite (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (call @Parser$ptr.remove-comments (types %struct.Parser*) void (args %parser)) (auto %prog %struct.Texp) (auto %filename-string %struct.String) (let %$3 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %filename))) (store %$3 %struct.String %filename-string) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %prog %filename-string)) (call @Parser$ptr.collect (types %struct.Parser* %struct.Texp*) void (args %parser %prog)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %prog)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @Texp$ptr.pretty-print$lambda.do (params (%this %struct.Texp*)) void (do return-void)) (def @Texp$ptr.pretty-print$lambda.toplevel (params (%this %struct.Texp*) (%last %struct.Texp*)) void (do (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %this)) (call @println types void args) (let %$0 (!= %struct.Texp* %this %last)) (if %$0 (do (let %$2 (ptrtoint %struct.Texp* u64 %this)) (let %$1 (+ u64 40 %$2)) (let %next (inttoptr u64 %struct.Texp* %$1)) (call @Texp$ptr.pretty-print$lambda.toplevel (types %struct.Texp* %struct.Texp*) void (args %next %last)))) return-void)) (def @Texp$ptr.pretty-print (params (%this %struct.Texp*)) void (do (let %LPAREN (+ i8 40 0)) (let %RPAREN (+ i8 41 0)) (call @i8.print (types i8) void (args %LPAREN)) (let %$0 (index %this %struct.Texp 0)) (call @String$ptr.println (types %struct.String*) void (args %$0)) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %this))) (let %$1 (index %this %struct.Texp 1)) (let %first-child (load %struct.Texp* %$1)) (call @Texp$ptr.pretty-print$lambda.toplevel (types %struct.Texp* %struct.Texp*) void (args %first-child %last)) (call @i8.print (types i8) void (args %RPAREN)) (call @println types void args) return-void)) (def @test.texp-pretty-print params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 83))) (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file (types %struct.StringView*) %struct.Texp (args %filename))) (store %$0 %struct.Texp %prog) (call @Texp$ptr.pretty-print (types %struct.Texp*) void (args %prog)) return-void)) (struct %struct.Grammar (%texp %struct.Texp)) (def @Grammar.make (params (%texp %struct.Texp)) %struct.Grammar (do (auto %grammar %struct.Grammar) (let %$0 (index %grammar %struct.Grammar 0)) (store %texp %struct.Texp %$0) (let %$1 (index %grammar %struct.Grammar 0)) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %$1)) (let %$2 (load %struct.Grammar %grammar)) (return %$2 %struct.Grammar))) (def @Grammar$ptr.getProduction (params (%this %struct.Grammar*) (%type-name %struct.StringView*)) %struct.Texp* (do (let %$0 (index %this %struct.Grammar 0)) (let %maybe-prod (call @Texp$ptr.find (types %struct.Texp* %struct.StringView*) %struct.Texp* (args %$0 %type-name))) (let %$2 (ptrtoint %struct.Texp* u64 %maybe-prod)) (let %$1 (== u64 0 %$2)) (if %$1 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 84))) (call @StringView$ptr.print (types %struct.StringView*) void (args %type-name)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 85))) (call @exit (types i32) void (args 1)))) (return %maybe-prod %struct.Texp*))) (def @Grammar$ptr.get-keyword (params (%this %struct.Grammar*) (%type-name %struct.StringView*)) %struct.Texp (do (let %prod (call @Grammar$ptr.getProduction (types %struct.Grammar* %struct.StringView*) %struct.Texp* (args %this %type-name))) (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %$1 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 86)))) (if %$1 (do (let %$2 (call @Optional.none types %struct.Texp args)) (return %$2 %struct.Texp))) (let %rule-value (index %rule %struct.Texp 0)) (let %$3 (call @String$ptr.is-empty (types %struct.String*) i1 (args %rule-value))) (if %$3 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 87))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (call @exit (types i32) void (args 1)))) (let %HASH (+ i8 35 0)) (let %$5 (call @String$ptr.char-at-unsafe (types %struct.String* u64) i8 (args %rule-value 0))) (let %$4 (== i8 %HASH %$5)) (if %$4 (do (let %$6 (call @Optional.none types %struct.Texp args)) (return %$6 %struct.Texp))) (let %$7 (call @Texp.makeFromString (types %struct.String*) %struct.Texp (args %rule-value))) (return %$7 %struct.Texp))) (struct %struct.Matcher (%grammar %struct.Grammar)) (def @Matcher$ptr.is (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%type-name %struct.StringView*)) %struct.Texp (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 88))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 89))) (call @StringView$ptr.print (types %struct.StringView*) void (args %type-name)) (let %grammar (index %this %struct.Matcher 0)) (let %prod (call @Grammar$ptr.getProduction (types %struct.Grammar* %struct.StringView*) %struct.Texp* (args %grammar %type-name))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 90))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %prod)) (call @println types void args) (auto %result %struct.Texp) (let %$0 (call @Matcher$ptr.match (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %result (str-get 91)))) (if %$1 (do (let %$2 (index %result %struct.Texp 1)) (let %child (load %struct.Texp* %$2)) (let %proof-value (index %child %struct.Texp 0)) (auto %new-proof-value %struct.String) (let %$3 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %type-name))) (store %$3 %struct.String %new-proof-value) (let %FORWARD_SLASH (+ i8 47 0)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %new-proof-value %FORWARD_SLASH)) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %new-proof-value %proof-value)) (call @String$ptr.free (types %struct.String*) void (args %proof-value)) (let %$4 (load %struct.String %new-proof-value)) (store %$4 %struct.String %proof-value))) (let %$5 (load %struct.Texp %result)) (return %$5 %struct.Texp))) (def @Matcher$ptr.atom (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 92))) (let %$2 (index %texp %struct.Texp 2)) (let %$1 (load u64 %$2)) (let %$0 (!= u64 0 %$1)) (if %$0 (do (auto %error-result %struct.Texp) (let %$3 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 93)))) (store %$3 %struct.Texp %error-result) (let %$4 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %prod))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %error-result %$4)) (let %$5 (load %struct.Texp %error-result)) (return %$5 %struct.Texp))) (let %$6 (call @Result.success-from-i8$ptr (types i8*) %struct.Texp (args (str-get 94)))) (return %$6 %struct.Texp))) (def @Matcher$ptr.match (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %$1 (index %rule %struct.Texp 2)) (let %rule-length (load u64 %$1)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 95))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (let %$2 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 96)))) (if %$2 (do (call @println types void args) (let %$3 (call @Matcher$ptr.choice (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (return %$3 %struct.Texp))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 97))) (call @u64.print (types u64) void (args %rule-length)) (call @println types void args) (auto %value-result %struct.Texp) (let %$4 (call @Matcher$ptr.value (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (store %$4 %struct.Texp %value-result) (let %$5 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %value-result (str-get 98)))) (if %$5 (do (let %$6 (load %struct.Texp %value-result)) (return %$6 %struct.Texp))) (let %$7 (!= u64 %rule-length 0)) (if %$7 (do (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %rule))) (let %$8 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %last (str-get 99)))) (if %$8 (do (let %$9 (call @Matcher$ptr.kleene (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (return %$9 %struct.Texp))) (let %$10 (call @Matcher$ptr.exact (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (return %$10 %struct.Texp))) (let %$11 (call @Matcher$ptr.atom (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (return %$11 %struct.Texp))) (def @Matcher$ptr.kleene-seq (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*) (%acc %struct.Texp*) (%curr-index u64) (%last-index u64)) void (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 100))) (call @u64.print (types u64) void (args %curr-index)) (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %rule))) (let %texp-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %texp %curr-index))) (let %rule-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %rule %curr-index))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 101))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp-child)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 102))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule-child)) (call @println types void args) (auto %result %struct.Texp) (let %$2 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule-child))) (let %$1 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %this %texp-child %$2))) (store %$1 %struct.Texp %result) (let %$3 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %result (str-get 103)))) (if %$3 (do (call @Texp$ptr.free (types %struct.Texp*) void (args %acc)) (let %$4 (load %struct.Texp %result)) (store %$4 %struct.Texp %acc) return-void)) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %result)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %acc %result)) (let %$5 (== u64 %curr-index %last-index)) (if %$5 (do return-void)) (let %next-index (+ u64 1 %curr-index)) (call @Matcher$ptr.kleene-seq (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %acc %next-index %last-index)) return-void)) (def @Matcher$ptr.kleene-many (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*) (%acc %struct.Texp*) (%curr-index u64) (%last-index u64)) void (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 104))) (call @u64.print (types u64) void (args %curr-index)) (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %rule))) (let %texp-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %texp %curr-index))) (let %rule-child (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %last))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 105))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp-child)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 106))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule-child)) (call @println types void args) (auto %result %struct.Texp) (let %$2 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule-child))) (let %$1 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %this %texp-child %$2))) (store %$1 %struct.Texp %result) (let %$3 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %result (str-get 107)))) (if %$3 (do (call @Texp$ptr.free (types %struct.Texp*) void (args %acc)) (let %$4 (load %struct.Texp %result)) (store %$4 %struct.Texp %acc) return-void)) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %result)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %acc %result)) (let %$5 (== u64 %curr-index %last-index)) (if %$5 (do return-void)) (let %next-index (+ u64 1 %curr-index)) (call @Matcher$ptr.kleene-many (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %acc %next-index %last-index)) return-void)) (def @Matcher$ptr.kleene (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 108))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 109))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (call @println types void args) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %rule))) (let %$1 (index %last %struct.Texp 0)) (let %kleene-prod-view (call @String$ptr.view (types %struct.String*) %struct.StringView (args %$1))) (let %$2 (index %rule %struct.Texp 2)) (let %rule-length (load u64 %$2)) (let %$3 (index %texp %struct.Texp 2)) (let %texp-length (load u64 %$3)) (auto %proof %struct.Texp) (let %$4 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 110)))) (store %$4 %struct.Texp %proof) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 111))) (call @u64.print (types u64) void (args %rule-length)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 112))) (call @u64.print (types u64) void (args %texp-length)) (call @println types void args) (let %seq-length (- u64 %rule-length 1)) (let %last-texp-i (- u64 %texp-length 1)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 113))) (call @u64.print (types u64) void (args %seq-length)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 114))) (call @u64.print (types u64) void (args %last-texp-i)) (call @println types void args) (let %$5 (< u64 %texp-length %seq-length)) (if %$5 (do (auto %failure-result %struct.Texp) (let %$6 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 115)))) (store %$6 %struct.Texp %failure-result) (let %$7 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 116)))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %failure-result %$7)) (let %$8 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %rule))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %failure-result %$8)) (let %$9 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %failure-result %$9)) (let %$10 (load %struct.Texp %failure-result)) (return %$10 %struct.Texp))) (let %$11 (!= u64 0 %seq-length)) (if %$11 (do (let %$12 (- u64 %seq-length 1)) (call @Matcher$ptr.kleene-seq (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %proof 0 %$12)) (let %$13 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %proof (str-get 117)))) (if %$13 (do (let %$14 (load %struct.Texp %proof)) (return %$14 %struct.Texp))))) (let %$15 (!= u64 %seq-length %texp-length)) (if %$15 (do (let %$16 (- u64 %texp-length 1)) (call @Matcher$ptr.kleene-many (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %proof %seq-length %$16)) (let %$17 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %proof (str-get 118)))) (if %$17 (do (let %$18 (load %struct.Texp %proof)) (return %$18 %struct.Texp))))) (let %$19 (call @Result.success (types %struct.Texp*) %struct.Texp (args %proof))) (return %$19 %struct.Texp))) (def @Matcher$ptr.exact_ (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*) (%acc %struct.Texp*) (%curr-index u64) (%last-index u64)) void (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %texp-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %texp %curr-index))) (let %rule-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %rule %curr-index))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 119))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp-child)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 120))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule-child)) (call @println types void args) (auto %result %struct.Texp) (let %$2 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule-child))) (let %$1 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %this %texp-child %$2))) (store %$1 %struct.Texp %result) (let %$3 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %result (str-get 121)))) (if %$3 (do (call @Texp$ptr.free (types %struct.Texp*) void (args %acc)) (let %$4 (load %struct.Texp %result)) (store %$4 %struct.Texp %acc) return-void)) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %result)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %acc %result)) (let %$5 (== u64 %curr-index %last-index)) (if %$5 (do return-void)) (let %next-index (+ u64 1 %curr-index)) (call @Matcher$ptr.exact_ (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %acc %next-index %last-index)) return-void)) (def @Matcher$ptr.exact (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %$3 (index %texp %struct.Texp 2)) (let %$2 (load u64 %$3)) (let %$5 (index %rule %struct.Texp 2)) (let %$4 (load u64 %$5)) (let %$1 (!= u64 %$2 %$4)) (if %$1 (do (auto %len-result %struct.Texp) (let %$6 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 122)))) (store %$6 %struct.Texp %len-result) (let %$7 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %len-result %$7)) (let %$8 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %rule))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %len-result %$8)) (let %$9 (load %struct.Texp %len-result)) (return %$9 %struct.Texp))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 123))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 124))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (call @println types void args) (auto %proof %struct.Texp) (let %$10 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 125)))) (store %$10 %struct.Texp %proof) (let %$12 (index %texp %struct.Texp 2)) (let %$11 (load u64 %$12)) (let %last (- u64 %$11 1)) (call @Matcher$ptr.exact_ (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %proof 0 %last)) (auto %proof-success-wrapper %struct.Texp) (let %$13 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 126)))) (store %$13 %struct.Texp %proof-success-wrapper) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %proof-success-wrapper %proof)) (let %$14 (load %struct.Texp %proof-success-wrapper)) (return %$14 %struct.Texp))) (def @Matcher$ptr.choice_ (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*) (%i u64) (%attempts %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %rule-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %rule %i))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 127))) (call @u64.print (types u64) void (args %i)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 128))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 129))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule-child)) (call @println types void args) (let %rule-child-view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule-child))) (auto %is-result %struct.Texp) (let %$1 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %this %texp %rule-child-view))) (store %$1 %struct.Texp %is-result) (let %$2 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %is-result (str-get 130)))) (if %$2 (do (let %$4 (index %is-result %struct.Texp 1)) (let %$3 (load %struct.Texp* %$4)) (let %proof-value-ref (index %$3 %struct.Texp 0)) (auto %choice-marker %struct.String) (let %$5 (call @String.makeFromi8$ptr (types i8*) %struct.String (args (str-get 131)))) (store %$5 %struct.String %choice-marker) (call @String$ptr.prepend (types %struct.String* %struct.String*) void (args %proof-value-ref %choice-marker)) (let %$6 (load %struct.Texp %is-result)) (return %$6 %struct.Texp))) (auto %keyword-result %struct.Texp) (let %$8 (index %this %struct.Matcher 0)) (let %$7 (call @Grammar$ptr.get-keyword (types %struct.Grammar* %struct.StringView*) %struct.Texp (args %$8 %rule-child-view))) (store %$7 %struct.Texp %keyword-result) (let %$10 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %texp))) (let %$11 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %keyword-result))) (let %$9 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %$10 %$11))) (if %$9 (do (auto %keyword-error-result %struct.Texp) (let %$12 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 132)))) (store %$12 %struct.Texp %keyword-error-result) (let %$13 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %prod))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-error-result %$13)) (let %$14 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-error-result %$14)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %keyword-error-result %is-result)) (let %$15 (load %struct.Texp %keyword-error-result)) (return %$15 %struct.Texp))) (let %$17 (index %rule %struct.Texp 2)) (let %$16 (load u64 %$17)) (let %last-rule-index (- u64 %$16 1)) (let %$18 (== u64 %i %last-rule-index)) (if %$18 (do (auto %choice-match-error-result %struct.Texp) (let %$19 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 133)))) (store %$19 %struct.Texp %choice-match-error-result) (let %$20 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %prod))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %choice-match-error-result %$20)) (let %$21 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %choice-match-error-result %$21)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %choice-match-error-result %attempts)) (let %$22 (load %struct.Texp %choice-match-error-result)) (return %$22 %struct.Texp))) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %attempts %is-result)) (let %$24 (+ u64 1 %i)) (let %$23 (call @Matcher$ptr.choice_ (types %struct.Matcher* %struct.Texp* %struct.Texp* u64 %struct.Texp*) %struct.Texp (args %this %texp %prod %$24 %attempts))) (return %$23 %struct.Texp))) (def @Matcher$ptr.choice (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 134))) (let %$0 (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %prod))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %$0)) (call @println types void args) (auto %proof %struct.Texp) (let %$1 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 135)))) (store %$1 %struct.Texp %proof) (auto %attempts %struct.Texp) (let %$2 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 136)))) (store %$2 %struct.Texp %attempts) (let %$3 (call @Matcher$ptr.choice_ (types %struct.Matcher* %struct.Texp* %struct.Texp* u64 %struct.Texp*) %struct.Texp (args %this %texp %prod 0 %attempts))) (return %$3 %struct.Texp))) (def @Matcher.regexInt_ (params (%curr i8*) (%len u64)) i1 (do (let %$0 (== u64 0 %len)) (if %$0 (do (return true i1))) (let %ZERO (+ i8 48 0)) (let %$1 (load i8 %curr)) (let %offset (- i8 %$1 %ZERO)) (let %$2 (< i8 %offset 0)) (if %$2 (do (return false i1))) (let %$3 (>= i8 %offset 10)) (if %$3 (do (return false i1))) (let %$7 (ptrtoint i8* u64 %curr)) (let %$6 (+ u64 1 %$7)) (let %$5 (inttoptr u64 i8* %$6)) (let %$8 (- u64 %len 1)) (let %$4 (call @Matcher.regexInt_ (types i8* u64) i1 (args %$5 %$8))) (return %$4 i1))) (def @Matcher.regexInt (params (%texp %struct.Texp*)) i1 (do (let %view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %texp))) (let %$2 (index %view %struct.StringView 0)) (let %$1 (load i8* %$2)) (let %$4 (index %view %struct.StringView 1)) (let %$3 (load u64 %$4)) (let %$0 (call @Matcher.regexInt_ (types i8* u64) i1 (args %$1 %$3))) (return %$0 i1))) (def @Matcher.regexString_ (params (%curr i8*) (%len u64)) i1 (do (return true i1))) (def @Matcher.regexString (params (%texp %struct.Texp*)) i1 (do (let %view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %texp))) (let %$0 (index %view %struct.StringView 0)) (let %curr (load i8* %$0)) (let %$1 (index %view %struct.StringView 1)) (let %len (load u64 %$1)) (let %$2 (< u64 %len 2)) (if %$2 (do (return false i1))) (let %$4 (- u64 %len 1)) (let %$5 (ptrtoint i8* u64 %curr)) (let %$3 (+ u64 %$4 %$5)) (let %last (inttoptr u64 i8* %$3)) (let %QUOTE (+ i8 34 0)) (let %$7 (load i8 %curr)) (let %$6 (!= i8 %QUOTE %$7)) (if %$6 (do (return false i1))) (let %$9 (load i8 %last)) (let %$8 (!= i8 %QUOTE %$9)) (if %$8 (do (return false i1))) (let %$11 (ptrtoint i8* u64 %curr)) (let %$10 (+ u64 1 %$11)) (let %next (inttoptr u64 i8* %$10)) (let %$13 (- u64 %len 2)) (let %$12 (call @Matcher.regexString_ (types i8* u64) i1 (args %next %$13))) (return %$12 i1))) (def @Matcher.regexBool (params (%texp %struct.Texp*)) i1 (do (let %$0 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %texp (str-get 137)))) (if %$0 (do (return true i1))) (let %$1 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %texp (str-get 138)))) (if %$1 (do (return true i1))) (return false i1))) (def @Matcher$ptr.value (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %texp-value-view-ref (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %texp))) (let %rule-value-view-ref (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 139))) (call @StringView$ptr.print (types %struct.StringView*) void (args %texp-value-view-ref)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 140))) (call @StringView$ptr.print (types %struct.StringView*) void (args %rule-value-view-ref)) (call @println types void args) (auto %rule-value-texp %struct.Texp) (let %$1 (call @Texp.makeFromStringView (types %struct.StringView*) %struct.Texp (args %rule-value-view-ref))) (store %$1 %struct.Texp %rule-value-texp) (auto %texp-value-texp %struct.Texp) (let %$2 (call @Texp.makeFromStringView (types %struct.StringView*) %struct.Texp (args %texp-value-view-ref))) (store %$2 %struct.Texp %texp-value-texp) (let %default-success (call @Result.success (types %struct.Texp*) %struct.Texp (args %rule-value-texp))) (let %HASH (+ i8 35 0)) (let %$3 (call @Texp$ptr.value-get (types %struct.Texp* u64) i8 (args %rule 0))) (let %cond (== i8 %HASH %$3)) (auto %error-result %struct.Texp) (let %$4 (call @Texp.makeEmpty types %struct.Texp args)) (store %$4 %struct.Texp %error-result) (if %cond (do (let %$5 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 141)))) (if %$5 (do (let %$6 (call @Matcher.regexInt (types %struct.Texp*) i1 (args %texp))) (if %$6 (do (return %default-success %struct.Texp))) (let %$7 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 142)))) (store %$7 %struct.Texp %error-result))) (let %$8 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 143)))) (if %$8 (do (let %$9 (call @Matcher.regexString (types %struct.Texp*) i1 (args %texp))) (if %$9 (do (return %default-success %struct.Texp))) (let %$10 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 144)))) (store %$10 %struct.Texp %error-result))) (let %$11 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 145)))) (if %$11 (do (let %$12 (call @Matcher.regexBool (types %struct.Texp*) i1 (args %texp))) (if %$12 (do (return %default-success %struct.Texp))) (let %$13 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 146)))) (store %$13 %struct.Texp %error-result))) (let %$14 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 147)))) (if %$14 (do (return %default-success %struct.Texp))) (let %$15 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 148)))) (if %$15 (do (return %default-success %struct.Texp))) (let %$16 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %error-result (str-get 149)))) (if %$16 (do (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %error-result %texp)) (let %$17 (load %struct.Texp %error-result)) (return %$17 %struct.Texp))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 150))) (call @StringView$ptr.print (types %struct.StringView*) void (args %rule-value-view-ref)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 151))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 152))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %error-result)) (call @println types void args) (call @exit (types i32) void (args 1)))) (let %$18 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %rule-value-view-ref %texp-value-view-ref))) (if %$18 (do (return %default-success %struct.Texp))) (auto %keyword-match-error %struct.Texp) (let %$19 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 153)))) (store %$19 %struct.Texp %keyword-match-error) (let %$20 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 154)))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-match-error %$20)) (let %$21 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %rule-value-texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-match-error %$21)) (let %$22 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp-value-texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-match-error %$22)) (let %$23 (load %struct.Texp %keyword-match-error)) (return %$23 %struct.Texp))) (def @test.matcher-simple params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 155)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 156)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 157)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-choice params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 158)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 159)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 160)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-kleene-seq params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 161)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 162)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 163)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-exact params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 164)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 165)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 166)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-value params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 167)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 168)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 169)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-empty-kleene params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 170)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 171)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 172)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-self params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 173))) (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file (types %struct.StringView*) %struct.Texp (args %filename))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 174)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 175)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-regexString params void (do (auto %string %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 176)))) (store %$0 %struct.Texp %string) (let %$1 (call @Matcher.regexString (types %struct.Texp*) i1 (args %string))) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 177))) return-void)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 178))) return-void)) (def @test.matcher-regexInt params void (do (auto %string %struct.Texp) (let %actual (+ u64 1234567890 0)) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 179)))) (store %$0 %struct.Texp %string) (let %$1 (call @Matcher.regexInt (types %struct.Texp*) i1 (args %string))) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 180))) return-void)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 181))) return-void)) (def @TextCoord.vector-print (params (%L-line u64) (%L-col u64) (%R-line u64) (%R-col u64)) void (do (call @u64.print (types u64) void (args %L-line)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 182))) (call @u64.print (types u64) void (args %L-col)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 183))) (call @u64.print (types u64) void (args %R-line)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 184))) (call @u64.print (types u64) void (args %R-col)) return-void)) (def @TextCoord.vector-println (params (%L-line u64) (%L-col u64) (%R-line u64) (%R-col u64)) void (do (call @TextCoord.vector-print (types u64 u64 u64 u64) void (args %L-line %L-col %R-line %R-col)) (call @println types void args) return-void)) (def @TextCoord.lexically-compare (params (%L-line u64) (%L-col u64) (%R-line u64) (%R-col u64)) i1 (do (let %$0 (< u64 %L-line %R-line)) (if %$0 (do (return true i1))) (let %$1 (> u64 %L-line %R-line)) (if %$1 (do (return false i1))) (let %$2 (< u64 %L-col %R-col)) (if %$2 (do (return true i1))) (let %$3 (> u64 %L-col %R-col)) (if %$3 (do (return false i1))) (return false i1))) (struct %struct.Unparser (%line u64) (%col u64) (%parser-readref %struct.Parser*) (%syntax-i u64) (%file %struct.File) (%reader %struct.Reader) (%comment-i u64) (%comment-count u64)) (def @Unparser.make.count-comments (params (%unparser %struct.Unparser*) (%curr-i u64)) u64 (do (let %$0 (index %unparser %struct.Unparser 2)) (let %parser (load %struct.Parser* %$0)) (let %$1 (index %parser %struct.Parser 3)) (let %type (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %$1 %curr-i))) (let %$2 (!= u64 %type 3)) (if %$2 (do (return %curr-i u64))) (let %$4 (+ u64 1 %curr-i)) (let %$3 (call @Unparser.make.count-comments (types %struct.Unparser* u64) u64 (args %unparser %$4))) (return %$3 u64))) (def @Unparser.make (params (%parser %struct.Parser*)) %struct.Unparser (do (auto %unparser %struct.Unparser) (let %$0 (index %unparser %struct.Unparser 0)) (store 0 u64 %$0) (let %$1 (index %unparser %struct.Unparser 1)) (store 0 u64 %$1) (let %$2 (index %unparser %struct.Unparser 2)) (store %parser %struct.Parser* %$2) (let %$3 (index %unparser %struct.Unparser 6)) (store 0 u64 %$3) (let %comment-count (call @Unparser.make.count-comments (types %struct.Unparser* u64) u64 (args %unparser 0))) (let %$4 (index %unparser %struct.Unparser 7)) (store %comment-count u64 %$4) (let %$5 (index %unparser %struct.Unparser 3)) (store %comment-count u64 %$5) (let %filename (index %parser %struct.Parser 4)) (let %file (index %unparser %struct.Unparser 4)) (let %$6 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$6 %struct.File %file) (auto %content %struct.StringView) (let %$7 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$7 %struct.StringView %content) (let %$8 (index %unparser %struct.Unparser 5)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$8 %content)) (let %$9 (load %struct.Unparser %unparser)) (return %$9 %struct.Unparser))) (def @Unparser$ptr.increment-col (params (%unparser %struct.Unparser*) (%col-delta u64)) void (do (let %$2 (index %unparser %struct.Unparser 1)) (let %$1 (load u64 %$2)) (let %$0 (+ u64 %col-delta %$1)) (let %$3 (index %unparser %struct.Unparser 1)) (store %$0 u64 %$3) return-void)) (def @Unparser$ptr.print-comment (params (%unparser %struct.Unparser*)) void (do (let %NEWLINE (+ i8 10 0)) (let %reader (index %unparser %struct.Unparser 5)) (let %$0 (index %reader %struct.Reader 3)) (let %save-line (load u64 %$0)) (let %$1 (index %reader %struct.Reader 4)) (let %save-col (load u64 %$1)) (call @Reader$ptr.find-next (types %struct.Reader* i8) void (args %reader %NEWLINE)) (let %$2 (index %reader %struct.Reader 3)) (let %end-line (load u64 %$2)) (let %$3 (index %reader %struct.Reader 4)) (let %end-col (load u64 %$3)) (call @Reader$ptr.seek-backwards-on-line (types %struct.Reader* u64 u64) void (args %reader %save-line %save-col)) (let %comment-length (- u64 %end-col %save-col)) (let %$4 (index %reader %struct.Reader 1)) (let %comment-begin (load i8* %$4)) (call @i8$ptr.printn (types i8* u64) void (args %comment-begin %comment-length)) (call @Unparser$ptr.increment-col (types %struct.Unparser* u64) void (args %unparser %comment-length)) return-void)) (def @Unparser$ptr.navigate (params (%unparser %struct.Unparser*) (%line u64) (%col u64)) void (do (let %SPACE (+ i8 32 0)) (let %NEWLINE (+ i8 10 0)) (let %line-ref (index %unparser %struct.Unparser 0)) (let %col-ref (index %unparser %struct.Unparser 1)) (let %$1 (load u64 %line-ref)) (let %$2 (load u64 %col-ref)) (let %$0 (call @TextCoord.lexically-compare (types u64 u64 u64 u64) i1 (args %line %col %$1 %$2))) (if %$0 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 185))) (let %$3 (load u64 %line-ref)) (let %$4 (load u64 %col-ref)) (call @TextCoord.vector-println (types u64 u64 u64 u64) void (args %$3 %$4 %line %col)) (call @exit (types i32) void (args 1)))) (let %$6 (load u64 %line-ref)) (let %$5 (< u64 %line %$6)) (if %$5 (do (let %$7 (load u64 %line-ref)) (let %$8 (load u64 %col-ref)) (call @TextCoord.vector-println (types u64 u64 u64 u64) void (args %$7 %$8 %line %col)))) (let %$10 (load u64 %line-ref)) (let %$9 (== u64 %line %$10)) (if %$9 (do (let %$12 (load u64 %col-ref)) (let %$11 (== u64 %col %$12)) (if %$11 (do return-void)) (call @i8.print (types i8) void (args %SPACE)) (call @Unparser$ptr.increment-col (types %struct.Unparser* u64) void (args %unparser 1)) (call @Unparser$ptr.navigate (types %struct.Unparser* u64 u64) void (args %unparser %line %col)) return-void)) (call @i8.print (types i8) void (args %NEWLINE)) (let %$15 (index %unparser %struct.Unparser 0)) (let %$14 (load u64 %$15)) (let %$13 (+ u64 1 %$14)) (let %$16 (index %unparser %struct.Unparser 0)) (store %$13 u64 %$16) (let %$17 (index %unparser %struct.Unparser 1)) (store 0 u64 %$17) (call @Unparser$ptr.navigate (types %struct.Unparser* u64 u64) void (args %unparser %line %col)) return-void)) (def @Unparser$ptr.pop (params (%unparser %struct.Unparser*) (%index-out u64*) (%exhausted i1*)) void (do (store false i1 %exhausted) (store 0 u64 %index-out) (let %$0 (index %unparser %struct.Unparser 2)) (let %parser (load %struct.Parser* %$0)) (let %syntax-i (index %unparser %struct.Unparser 3)) (let %comment-i (index %unparser %struct.Unparser 6)) (let %lines (index %parser %struct.Parser 1)) (let %cols (index %parser %struct.Parser 2)) (let %types (index %parser %struct.Parser 3)) (let %$1 (index %unparser %struct.Unparser 7)) (let %comment-count (load u64 %$1)) (let %$2 (index %lines %struct.u64-vector 1)) (let %syntax-count (load u64 %$2)) (let %$3 (load u64 %comment-i)) (let %comment-exhausted (== u64 %comment-count %$3)) (let %$4 (load u64 %syntax-i)) (let %syntax-exhausted (== u64 %syntax-count %$4)) (if %syntax-exhausted (do (if %comment-exhausted (do (store true i1 %exhausted) return-void)))) (if %syntax-exhausted (do (let %$5 (== i1 false %comment-exhausted)) (if %$5 (do (let %$6 (load u64 %comment-i)) (store %$6 u64 %index-out) (let %$8 (load u64 %comment-i)) (let %$7 (+ u64 1 %$8)) (store %$7 u64 %comment-i) return-void)))) (if %comment-exhausted (do (let %$9 (== i1 false %syntax-exhausted)) (if %$9 (do (let %$10 (load u64 %syntax-i)) (store %$10 u64 %index-out) (let %$12 (load u64 %syntax-i)) (let %$11 (+ u64 1 %$12)) (store %$11 u64 %syntax-i) return-void)))) (let %$13 (load u64 %syntax-i)) (let %s-line (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %lines %$13))) (let %$14 (load u64 %syntax-i)) (let %s-col (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %cols %$14))) (let %$15 (load u64 %comment-i)) (let %c-line (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %lines %$15))) (let %$16 (load u64 %comment-i)) (let %c-col (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %cols %$16))) (let %syntax-is-less-than (call @TextCoord.lexically-compare (types u64 u64 u64 u64) i1 (args %s-line %s-col %c-line %c-col))) (if %syntax-is-less-than (do (let %$17 (load u64 %syntax-i)) (store %$17 u64 %index-out) (let %$19 (load u64 %syntax-i)) (let %$18 (+ u64 1 %$19)) (store %$18 u64 %syntax-i))) (let %$20 (== i1 false %syntax-is-less-than)) (if %$20 (do (let %$21 (load u64 %comment-i)) (store %$21 u64 %index-out) (let %$23 (load u64 %comment-i)) (let %$22 (+ u64 1 %$23)) (store %$22 u64 %comment-i))) return-void)) (def @Unparser$ptr.pop-to-value (params (%unparser %struct.Unparser*)) void (do (let %$0 (index %unparser %struct.Unparser 2)) (let %parser (load %struct.Parser* %$0)) (auto %current-index u64) (auto %exhausted i1) (call @Unparser$ptr.pop (types %struct.Unparser* u64* i1*) void (args %unparser %current-index %exhausted)) (let %$1 (load i1 %exhausted)) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 186))) (call @exit (types i32) void (args 1)))) (let %$2 (index %parser %struct.Parser 1)) (let %$3 (load u64 %current-index)) (let %line (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %$2 %$3))) (let %$4 (index %parser %struct.Parser 2)) (let %$5 (load u64 %current-index)) (let %col (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %$4 %$5))) (let %$6 (index %parser %struct.Parser 3)) (let %$7 (load u64 %current-index)) (let %type (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %$6 %$7))) (call @Unparser$ptr.navigate (types %struct.Unparser* u64 u64) void (args %unparser %line %col)) (let %LPAREN (+ i8 40 0)) (let %RPAREN (+ i8 41 0)) (let %SPACE (+ i8 32 0)) (let %$8 (== u64 %type 3)) (if %$8 (do (let %$9 (index %unparser %struct.Unparser 5)) (call @Reader$ptr.reset (types %struct.Reader*) void (args %$9)) (let %$10 (index %unparser %struct.Unparser 5)) (call @Reader$ptr.seek-forwards (types %struct.Reader* u64 u64) void (args %$10 %line %col)) (call @Unparser$ptr.print-comment (types %struct.Unparser*) void (args %unparser)) (call @Unparser$ptr.pop-to-value (types %struct.Unparser*) void (args %unparser)) return-void)) (let %$11 (== u64 %type 0)) (if %$11 (do (call @i8.print (types i8) void (args %LPAREN)) (call @Unparser$ptr.increment-col (types %struct.Unparser* u64) void (args %unparser 1)) (call @Unparser$ptr.pop-to-value (types %struct.Unparser*) void (args %unparser)) return-void)) (let %$12 (== u64 %type 1)) (if %$12 (do (call @i8.print (types i8) void (args %RPAREN)) (call @Unparser$ptr.increment-col (types %struct.Unparser* u64) void (args %unparser 1)) (call @Unparser$ptr.pop-to-value (types %struct.Unparser*) void (args %unparser)) return-void)) return-void)) (def @unparse-children (params (%unparser %struct.Unparser*) (%texp %struct.Texp*) (%child-index u64)) void (do (let %SPACE (+ i8 32 0)) (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %texp %struct.Texp 2)) (let %length (load u64 %$0)) (let %$1 (== u64 %child-index %length)) (if %$1 (do return-void)) (let %$2 (index %texp %struct.Texp 1)) (let %children (load %struct.Texp* %$2)) (let %$4 (* u64 %SIZEOF-Texp %child-index)) (let %$5 (ptrtoint %struct.Texp* u64 %children)) (let %$3 (+ u64 %$4 %$5)) (let %curr (inttoptr u64 %struct.Texp* %$3)) (call @unparse-texp (types %struct.Unparser* %struct.Texp*) void (args %unparser %curr)) (let %$6 (+ u64 1 %child-index)) (call-tail @unparse-children (types %struct.Unparser* %struct.Texp* u64) void (args %unparser %texp %$6)) return-void)) (def @unparse-texp (params (%unparser %struct.Unparser*) (%texp %struct.Texp*)) void (do (let %$1 (ptrtoint %struct.Texp* u64 %texp)) (let %$0 (== u64 0 %$1)) (if %$0 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 187))) (call @exit (types i32) void (args 1)))) (let %value-ref (index %texp %struct.Texp 0)) (let %$2 (index %value-ref %struct.String 1)) (let %value-length (load u64 %$2)) (let %$3 (index %texp %struct.Texp 2)) (let %length (load u64 %$3)) (call @Unparser$ptr.pop-to-value (types %struct.Unparser*) void (args %unparser)) (call @String$ptr.print (types %struct.String*) void (args %value-ref)) (call @Unparser$ptr.increment-col (types %struct.Unparser* u64) void (args %unparser %value-length)) (call @unparse-children (types %struct.Unparser* %struct.Texp* u64) void (args %unparser %texp 0)) return-void)) (def @Unparser$ptr.exhaust-after-words (params (%unparser %struct.Unparser*)) void (do (let %$0 (index %unparser %struct.Unparser 2)) (let %parser (load %struct.Parser* %$0)) (auto %current-index u64) (auto %exhausted i1) (call @Unparser$ptr.pop (types %struct.Unparser* u64* i1*) void (args %unparser %current-index %exhausted)) (let %$1 (load i1 %exhausted)) (if %$1 (do return-void)) (let %$2 (index %parser %struct.Parser 1)) (let %$3 (load u64 %current-index)) (let %line (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %$2 %$3))) (let %$4 (index %parser %struct.Parser 2)) (let %$5 (load u64 %current-index)) (let %col (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %$4 %$5))) (let %$6 (index %parser %struct.Parser 3)) (let %$7 (load u64 %current-index)) (let %type (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %$6 %$7))) (call @Unparser$ptr.navigate (types %struct.Unparser* u64 u64) void (args %unparser %line %col)) (let %LPAREN (+ i8 40 0)) (let %RPAREN (+ i8 41 0)) (let %SPACE (+ i8 32 0)) (let %$8 (== u64 %type 3)) (if %$8 (do (let %$9 (index %unparser %struct.Unparser 5)) (call @Reader$ptr.reset (types %struct.Reader*) void (args %$9)) (let %$10 (index %unparser %struct.Unparser 5)) (call @Reader$ptr.seek-forwards (types %struct.Reader* u64 u64) void (args %$10 %line %col)) (call @Unparser$ptr.print-comment (types %struct.Unparser*) void (args %unparser)) (call @Unparser$ptr.exhaust-after-words (types %struct.Unparser*) void (args %unparser)) return-void)) (let %$11 (== u64 %type 0)) (if %$11 (do (call @i8.print (types i8) void (args %LPAREN)) (call @Unparser$ptr.increment-col (types %struct.Unparser* u64) void (args %unparser 1)) (call @Unparser$ptr.exhaust-after-words (types %struct.Unparser*) void (args %unparser)) return-void)) (let %$12 (== u64 %type 1)) (if %$12 (do (call @i8.print (types i8) void (args %RPAREN)) (call @Unparser$ptr.increment-col (types %struct.Unparser* u64) void (args %unparser 1)) (call @Unparser$ptr.exhaust-after-words (types %struct.Unparser*) void (args %unparser)) return-void)) return-void)) (def @unparse (params (%parser %struct.Parser*) (%texp %struct.Texp*)) void (do (auto %unparser %struct.Unparser) (let %$0 (call @Unparser.make (types %struct.Parser*) %struct.Unparser (args %parser))) (store %$0 %struct.Unparser %unparser) (call @unparse-children (types %struct.Unparser* %struct.Texp* u64) void (args %unparser %texp 0)) (call @Unparser$ptr.exhaust-after-words (types %struct.Unparser*) void (args %unparser)) return-void)) (def @dump-parser_ (params (%parser %struct.Parser*) (%row u64)) void (do (let %texp-lines (index %parser %struct.Parser 2)) (let %$2 (index %texp-lines %struct.u64-vector 1)) (let %$1 (load u64 %$2)) (let %$0 (== u64 %row %$1)) (if %$0 (do return-void)) (let %lines (index %parser %struct.Parser 1)) (let %cols (index %parser %struct.Parser 2)) (let %types (index %parser %struct.Parser 3)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 188))) (let %$3 (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %lines %row))) (call @u64.print (types u64) void (args %$3)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 189))) (let %$4 (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %cols %row))) (call @u64.print (types u64) void (args %$4)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 190))) (let %$5 (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %types %row))) (call @u64.print (types u64) void (args %$5)) (call @println types void args) (let %$6 (+ u64 1 %row)) (call @dump-parser_ (types %struct.Parser* u64) void (args %parser %$6)) return-void)) (def @dump-parser (params (%parser %struct.Parser*)) void (do (let %lines (index %parser %struct.Parser 1)) (let %cols (index %parser %struct.Parser 2)) (let %types (index %parser %struct.Parser 3)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 191))) (let %$1 (index %lines %struct.u64-vector 1)) (let %$0 (load u64 %$1)) (call @u64.print (types u64) void (args %$0)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 192))) (let %$3 (index %cols %struct.u64-vector 1)) (let %$2 (load u64 %$3)) (call @u64.print (types u64) void (args %$2)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 193))) (let %$5 (index %types %struct.u64-vector 1)) (let %$4 (load u64 %$5)) (call @u64.print (types u64) void (args %$4)) (call @println types void args) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 194))) (call @dump-parser_ (types %struct.Parser* u64) void (args %parser 0)) return-void)) (def @main (params (%argc i32) (%argv i8**)) i32 (do (let %$0 (!= i32 2 %argc)) (if %$0 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 195))) (call @exit (types i32) void (args 1)))) (let %$2 (ptrtoint i8** u64 %argv)) (let %$1 (+ u64 8 %$2)) (let %arg (inttoptr u64 i8** %$1)) (auto %filename %struct.StringView) (let %$4 (load i8* %arg)) (let %$3 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args %$4))) (store %$3 %struct.StringView %filename) (auto %file %struct.File) (let %$5 (call @File.openrw (types %struct.StringView*) %struct.File (args %filename))) (store %$5 %struct.File %file) (auto %content %struct.StringView) (let %$6 (call @File$ptr.readwrite (types %struct.File*) %struct.StringView (args %file))) (store %$6 %struct.StringView %content) (auto %parser %struct.Parser) (let %$7 (call @Parser.make (types %struct.StringView*) %struct.Parser (args %content))) (store %$7 %struct.Parser %parser) (let %$8 (load %struct.StringView %filename)) (let %$9 (index %parser %struct.Parser 4)) (store %$8 %struct.StringView %$9) (call @Parser$ptr.remove-comments (types %struct.Parser*) void (args %parser)) (auto %prog %struct.Texp) (auto %filename-string %struct.String) (let %$10 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %filename))) (store %$10 %struct.String %filename-string) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %prog %filename-string)) (call @Parser$ptr.collect (types %struct.Parser* %struct.Texp*) void (args %parser %prog)) (call @dump-parser (types %struct.Parser*) void (args %parser)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) (return 0 i32))) (str-table (0 "global string example\00") (1 "'%s' has length %lu.\0A\00") (2 "global string example\00") (3 "global string example\00") (4 "global string example\00") (5 "'%s' has length %lu.\0A\00") (6 "basic-string test\00") (7 "'%s' has length %lu.\0A\00") (8 "string-self-append test\00") (9 "hello, \00") (10 "world\00") (11 "this is a comparison string\00") (12 "this is a comparison string\00") (13 "PASSED\00") (14 "FAILED\00") (15 "hello, \00") (16 "world\00") (17 "error opening file at '%s'\0A\00") (18 "backbone-core: mmap\00") (19 "todo.json\00") (20 "lib2/core.bb.type.tall\00") (21 "%ul\0A\00") (22 "lib2/core.bb.type.tall\00") (23 " \00") (24 ",\00") (25 " -> \00") (26 ",\00") (27 "Error: Seeking before cursor column\00") (28 "Error: Seeking past end of column\00") (29 "Error: Seeking past end of file\00") (30 "Error: Seeking before cursor line\00") (31 "Error: Finding character past end of file") (32 "lib2/core.bb.type.tall\00") (33 "todo.json\00") (34 "success\00") (35 "success\00") (36 "error\00") (37 "error\00") (38 "error\00") (39 "some\00") (40 "none\00") (41 "empty\00") (42 "(null texp)\00") (43 "value: '\00") (44 "', length: \00") (45 ", capacity: \00") (46 "(null texp)\00") (47 "    at \00") (48 "hello\00") (49 "child-0\00") (50 "child-1\00") (51 "child-2\00") (52 "hello\00") (53 "child-0\00") (54 "child-1\00") (55 "child-2\00") (56 "atom\00") (57 " \00") (58 " \00") (59 "(kleene (success atom) (success atom))\00") (60 "hello\00") (61 "pass\00") (62 "fail\00") (63 "docs/bb-type-tall-str-include-grammar.texp\00") (64 "Program\00") (65 "PASSED\00") (66 "FAILED\00") (67 "docs/bb-type-tall-str-include-grammar.texp\00") (68 "Program\00") (69 "FAILED: Program not found in grammar\0Agrammar:\00") (70 "PASSED\00") (71 "0123456789\00") (72 "PASSED\00") (73 "FAILED\00") (74 "0123456789\00") (75 "PASSED\00") (76 "FAILED\00") (77 "") (78 "huh\00") (79 "lib2/core.bb.type.tall\00") (80 "../backbone-test/texp-parser/string.texp\00") (81 "lib2/core.bb.type.tall\00") (82 "lib2/core.bb.type.tall\00") (83 "lib/pprint.bb\00") (84 "\0Aproduction \00") (85 " not found\00") (86 "|\00") (87 "rule value should not be empty for rule:\00") (88 " [.is           ]  \00") (89 " -> \00") (90 " @ \00") (91 "success\00") (92 " [.atom         ]\00") (93 "\22texp is not an atom\22\00") (94 "atom\00") (95 " [.match        ]  -> \00") (96 "|\00") (97 ", rule-length: \00") (98 "error\00") (99 "*\00") (100 " [.kleene-seq   ]  i: \00") (101 ", \00") (102 " -> :\00") (103 "error\00") (104 " [.kleene-many  ]  i: \00") (105 ", \00") (106 " -> :\00") (107 "error\00") (108 " [.kleene       ]  texp: \00") (109 ", rule: \00") (110 "kleene\00") (111 " [.kleene       ]  rule-length: \00") (112 ", texp-length: \00") (113 " [.kleene       ]  seq-length: \00") (114 ", last-texp-i: \00") (115 "error\00") (116 "texp length not less than for rule.len - 1\00") (117 "error\00") (118 "error\00") (119 " [.exact_       ]  \00") (120 " -> \00") (121 "error\00") (122 "\22texp has incorrect length for exact sequence\22\00") (123 " [.exact        ]  \00") (124 " -> \00") (125 "exact\00") (126 "success\00") (127 " [.choice_      ]  i: \00") (128 ", \00") (129 " -> :\00") (130 "success\00") (131 "choice->\00") (132 "keyword-choice-match\00") (133 "choice-match\00") (134 " [.choice       ]  -> \00") (135 "choice\00") (136 "choice-attempts\00") (137 "true\00") (138 "false\00") (139 " [.value        ]  \00") (140 " -> \00") (141 "#int\00") (142 "failed to match #int\22\00") (143 "#string\00") (144 "\22failed to match #string\22\00") (145 "#bool\00") (146 "\22failed to match #bool\22\00") (147 "#type\00") (148 "#name\00") (149 "error\00") (150 "unmatched regex check for rule value: \00") (151 ", rule: \00") (152 ", \00") (153 "error\00") (154 "keyword-match\00") (155 "/home/kasra/projects/backbone-test/matcher/program.texp\00") (156 "/home/kasra/projects/backbone-test/matcher/program.grammar\00") (157 "Program\00") (158 "/home/kasra/projects/backbone-test/matcher/choice.texp\00") (159 "/home/kasra/projects/backbone-test/matcher/choice.grammar\00") (160 "Program\00") (161 "/home/kasra/projects/backbone-test/matcher/seq-kleene.texp\00") (162 "/home/kasra/projects/backbone-test/matcher/seq-kleene.grammar\00") (163 "Program\00") (164 "/home/kasra/projects/backbone-test/matcher/exact.texp\00") (165 "/home/kasra/projects/backbone-test/matcher/exact.grammar\00") (166 "Program\00") (167 "/home/kasra/projects/backbone-test/matcher/value.texp\00") (168 "/home/kasra/projects/backbone-test/matcher/value.grammar\00") (169 "Program\00") (170 "/home/kasra/projects/backbone-test/matcher/empty-kleene.texp\00") (171 "/home/kasra/projects/backbone-test/matcher/empty-kleene.grammar\00") (172 "Program\00") (173 "lib2/matcher.bb\00") (174 "docs/bb-type-tall-str-include-grammar.texp\00") (175 "Program\00") (176 "\22hello, world\22\00") (177 "PASSED\00") (178 "FAILED\00") (179 "0123456789\00") (180 "PASSED\00") (181 "FAILED\00") (182 ",\00") (183 " -> \00") (184 ",\00") (185 "error: cannot navigate backwards from the cursor: ") (186 "error: pop-to-value: iterators exhausted\00") (187 "cannot unparse null-texp\00") (188 "(\00") (189 ", \00") (190 ")  \00") (191 "lengths:\00") (192 " \00") (193 " \00") (194 "---------------------------------\00") (195 "usage: unparser <file.bb>\00")))
declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @realloc(i8*, i64)
declare i8* @calloc(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare i32 @fflush(i32)
declare i64 @write(i32, i8*, i64)
declare i64 @read(i32, i8*, i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i8* @memmove(i8*, i8*, i64)
declare i32 @open(i8*, i32, ...)
declare i64 @lseek(i32, i64, i32)
declare i8* @mmap(i8*, i64, i32, i32, i32, i64)
declare i32 @munmap(i8*, i64)
declare i32 @close(i32)
declare void @exit(i32)
declare void @perror(i8*)
define i64 @i8$ptr.length_(i8* %this, i64 %acc) {
entry:
  %$1 = load i8, i8* %this
  %$0 = icmp eq i8 %$1, 0
  br i1 %$0, label %then0, label %post0
then0:
  ret i64 %acc
  br label %post0
post0:
  %$5 = ptrtoint i8* %this to i64
  %$4 = add i64 1, %$5
  %$3 = inttoptr i64 %$4 to i8*
  %$6 = add i64 %acc, 1
  %$2 = tail call i64 (i8*, i64) @i8$ptr.length_(i8* %$3, i64 %$6)
  ret i64 %$2
}

define i64 @i8$ptr.length(i8* %this) {
entry:
  %$0 = tail call i64 (i8*, i64) @i8$ptr.length_(i8* %this, i64 0)
  ret i64 %$0
}

define void @i8$ptr.printn(i8* %this, i64 %n) {
entry:
  %FD_STDOUT = add i32 1, 0
  call i64 (i32, i8*, i64) @write(i32 %FD_STDOUT, i8* %this, i64 %n)
  ret void
}

define void @i8$ptr.unsafe-print(i8* %this) {
entry:
  %length = call i64 (i8*) @i8$ptr.length(i8* %this)
  call void (i8*, i64) @i8$ptr.printn(i8* %this, i64 %length)
  ret void
}

define void @i8$ptr.unsafe-println(i8* %this) {
entry:
  call void (i8*) @i8$ptr.unsafe-print(i8* %this)
  call void () @println()
  ret void
}

define i8* @i8$ptr.copyalloc(i8* %this) {
entry:
  %length = call i64 (i8*) @i8$ptr.length(i8* %this)
  %$0 = add i64 %length, 1
  %allocated = call i8* (i64) @malloc(i64 %$0)
  %$3 = ptrtoint i8* %allocated to i64
  %$2 = add i64 %length, %$3
  %$1 = inttoptr i64 %$2 to i8*
  store i8 0, i8* %$1
  call i8* (i8*, i8*, i64) @memcpy(i8* %allocated, i8* %this, i64 %length)
  ret i8* %allocated
}

define void @i8.print(i8 %this) {
entry:
  %c = alloca i8
  store i8 %this, i8* %c
  %FD_STDOUT = add i32 1, 0
  call i64 (i32, i8*, i64) @write(i32 %FD_STDOUT, i8* %c, i64 1)
  ret void
}

define void @i8$ptr.swap(i8* %this, i8* %other) {
entry:
  %this_value = load i8, i8* %this
  %other_value = load i8, i8* %other
  store i8 %this_value, i8* %other
  store i8 %other_value, i8* %this
  ret void
}

define i1 @i8$ptr.eqn(i8* %this, i8* %other, i64 %len) {
entry:
  %$0 = icmp eq i64 0, %len
  br i1 %$0, label %then0, label %post0
then0:
  ret i1 true
  br label %post0
post0:
  %$2 = load i8, i8* %this
  %$3 = load i8, i8* %other
  %$1 = icmp ne i8 %$2, %$3
  br i1 %$1, label %then1, label %post1
then1:
  ret i1 false
  br label %post1
post1:
  %$5 = ptrtoint i8* %this to i64
  %$4 = add i64 1, %$5
  %next-this = inttoptr i64 %$4 to i8*
  %$7 = ptrtoint i8* %other to i64
  %$6 = add i64 1, %$7
  %next-other = inttoptr i64 %$6 to i8*
  %$9 = sub i64 %len, 1
  %$8 = call i1 (i8*, i8*, i64) @i8$ptr.eqn(i8* %next-this, i8* %next-other, i64 %$9)
  ret i1 %$8
}

define void @println() {
entry:
  %NEWLINE = add i8 10, 0
  call void (i8) @i8.print(i8 %NEWLINE)
  ret void
}

define void @test.i8$ptr-eqn() {
entry:
  %a = alloca %struct.String
  %$0 = call %struct.String () @String.makeEmpty()
  store %struct.String %$0, %struct.String* %a
  %b = alloca %struct.String
  %$1 = call %struct.String () @String.makeEmpty()
  store %struct.String %$1, %struct.String* %b
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %a, i8 65)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %a, i8 66)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %a, i8 67)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %a, i8 68)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %b, i8 65)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %b, i8 66)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %b, i8 67)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %b, i8 68)
  %a-cstr = bitcast %struct.String* %a to i8*
  %b-cstr = bitcast %struct.String* %b to i8*
  %$4 = call i1 (i8*, i8*, i64) @i8$ptr.eqn(i8* %a-cstr, i8* %b-cstr, i64 5)
  %$3 = sext i1 %$4 to i8
  %$2 = add i8 48, %$3
  call void (i8) @i8.print(i8 %$2)
  ret void
}

%struct.StringView = type { i8*, i64 };
define %struct.StringView @StringView.makeEmpty() {
entry:
  %result = alloca %struct.StringView
  %$0 = inttoptr i64 0 to i8*
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %result, i32 0, i32 0
  store i8* %$0, i8** %$1
  %$2 = getelementptr inbounds %struct.StringView, %struct.StringView* %result, i32 0, i32 1
  store i64 0, i64* %$2
  %$3 = load %struct.StringView, %struct.StringView* %result
  ret %struct.StringView %$3
}

define void @StringView$ptr.set(%struct.StringView* %this, i8* %charptr) {
entry:
  %$0 = getelementptr inbounds %struct.StringView, %struct.StringView* %this, i32 0, i32 0
  store i8* %charptr, i8** %$0
  %$1 = call i64 (i8*) @i8$ptr.length(i8* %charptr)
  %$2 = getelementptr inbounds %struct.StringView, %struct.StringView* %this, i32 0, i32 1
  store i64 %$1, i64* %$2
  ret void
}

define %struct.StringView @StringView.make(i8* %charptr, i64 %size) {
entry:
  %result = alloca %struct.StringView
  %$0 = getelementptr inbounds %struct.StringView, %struct.StringView* %result, i32 0, i32 0
  store i8* %charptr, i8** %$0
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %result, i32 0, i32 1
  store i64 %size, i64* %$1
  %$2 = load %struct.StringView, %struct.StringView* %result
  ret %struct.StringView %$2
}

define %struct.StringView @StringView.makeFromi8$ptr(i8* %charptr) {
entry:
  %result = alloca %struct.StringView
  %$0 = getelementptr inbounds %struct.StringView, %struct.StringView* %result, i32 0, i32 0
  store i8* %charptr, i8** %$0
  %$1 = call i64 (i8*) @i8$ptr.length(i8* %charptr)
  %$2 = getelementptr inbounds %struct.StringView, %struct.StringView* %result, i32 0, i32 1
  store i64 %$1, i64* %$2
  %$3 = load %struct.StringView, %struct.StringView* %result
  ret %struct.StringView %$3
}

define void @StringView$ptr.print(%struct.StringView* %this) {
entry:
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %this, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  %$3 = getelementptr inbounds %struct.StringView, %struct.StringView* %this, i32 0, i32 1
  %$2 = load i64, i64* %$3
  call void (i8*, i64) @i8$ptr.printn(i8* %$0, i64 %$2)
  ret void
}

define void @StringView$ptr.println(%struct.StringView* %this) {
entry:
  call void (%struct.StringView*) @StringView$ptr.print(%struct.StringView* %this)
  call void () @println()
  ret void
}

define void @StringView.print(%struct.StringView %this) {
entry:
  %local = alloca %struct.StringView
  store %struct.StringView %this, %struct.StringView* %local
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %local, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  %$3 = getelementptr inbounds %struct.StringView, %struct.StringView* %local, i32 0, i32 1
  %$2 = load i64, i64* %$3
  call void (i8*, i64) @i8$ptr.printn(i8* %$0, i64 %$2)
  ret void
}

define void @StringView.println(%struct.StringView %this) {
entry:
  call void (%struct.StringView) @StringView.print(%struct.StringView %this)
  call void () @println()
  ret void
}

define i1 @StringView$ptr.eq(%struct.StringView* %this, %struct.StringView* %other) {
entry:
  %$0 = getelementptr inbounds %struct.StringView, %struct.StringView* %this, i32 0, i32 1
  %len = load i64, i64* %$0
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %other, i32 0, i32 1
  %olen = load i64, i64* %$1
  %$2 = icmp ne i64 %len, %olen
  br i1 %$2, label %then0, label %post0
then0:
  ret i1 false
  br label %post0
post0:
  %$5 = getelementptr inbounds %struct.StringView, %struct.StringView* %this, i32 0, i32 0
  %$4 = load i8*, i8** %$5
  %$7 = getelementptr inbounds %struct.StringView, %struct.StringView* %other, i32 0, i32 0
  %$6 = load i8*, i8** %$7
  %$3 = call i1 (i8*, i8*, i64) @i8$ptr.eqn(i8* %$4, i8* %$6, i64 %len)
  ret i1 %$3
}

define i1 @StringView.eq(%struct.StringView %this-value, %struct.StringView %other-value) {
entry:
  %this = alloca %struct.StringView
  store %struct.StringView %this-value, %struct.StringView* %this
  %other = alloca %struct.StringView
  store %struct.StringView %other-value, %struct.StringView* %other
  %$0 = call i1 (%struct.StringView*, %struct.StringView*) @StringView$ptr.eq(%struct.StringView* %this, %struct.StringView* %other)
  ret i1 %$0
}

%struct.String = type { i8*, i64 };
define %struct.String @String.makeEmpty() {
entry:
  %result = alloca %struct.String
  %$0 = inttoptr i64 0 to i8*
  %$1 = getelementptr inbounds %struct.String, %struct.String* %result, i32 0, i32 0
  store i8* %$0, i8** %$1
  %$2 = getelementptr inbounds %struct.String, %struct.String* %result, i32 0, i32 1
  store i64 0, i64* %$2
  %$3 = load %struct.String, %struct.String* %result
  ret %struct.String %$3
}

define void @String$ptr.set(%struct.String* %this, i8* %charptr) {
entry:
  %$0 = call i8* (i8*) @i8$ptr.copyalloc(i8* %charptr)
  %$1 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  store i8* %$0, i8** %$1
  %$3 = call i64 (i8*) @i8$ptr.length(i8* %charptr)
  %$2 = sub i64 %$3, 1
  %$4 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  store i64 %$2, i64* %$4
  ret void
}

define %struct.String @String.makeFromi8$ptr(i8* %charptr) {
entry:
  %this = alloca %struct.String
  %$0 = call i8* (i8*) @i8$ptr.copyalloc(i8* %charptr)
  %$1 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  store i8* %$0, i8** %$1
  %$2 = call i64 (i8*) @i8$ptr.length(i8* %charptr)
  %$3 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  store i64 %$2, i64* %$3
  %$4 = load %struct.String, %struct.String* %this
  ret %struct.String %$4
}

define %struct.String @String$ptr.copyalloc(%struct.String* %this) {
entry:
  %result = alloca %struct.String
  %$2 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %$1 = load i8*, i8** %$2
  %$0 = call i8* (i8*) @i8$ptr.copyalloc(i8* %$1)
  %$3 = getelementptr inbounds %struct.String, %struct.String* %result, i32 0, i32 0
  store i8* %$0, i8** %$3
  %$5 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %$4 = load i64, i64* %$5
  %$6 = getelementptr inbounds %struct.String, %struct.String* %result, i32 0, i32 1
  store i64 %$4, i64* %$6
  %$7 = load %struct.String, %struct.String* %result
  ret %struct.String %$7
}

define %struct.String @String.makeFromStringView(%struct.StringView* %other) {
entry:
  %$0 = getelementptr inbounds %struct.StringView, %struct.StringView* %other, i32 0, i32 1
  %len = load i64, i64* %$0
  %result = alloca %struct.String
  %$2 = add i64 1, %len
  %$1 = call i8* (i64) @malloc(i64 %$2)
  %$3 = getelementptr inbounds %struct.String, %struct.String* %result, i32 0, i32 0
  store i8* %$1, i8** %$3
  %$5 = getelementptr inbounds %struct.String, %struct.String* %result, i32 0, i32 0
  %$4 = load i8*, i8** %$5
  %$7 = getelementptr inbounds %struct.StringView, %struct.StringView* %other, i32 0, i32 0
  %$6 = load i8*, i8** %$7
  call i8* (i8*, i8*, i64) @memcpy(i8* %$4, i8* %$6, i64 %len)
  %$12 = getelementptr inbounds %struct.String, %struct.String* %result, i32 0, i32 0
  %$11 = load i8*, i8** %$12
  %$10 = ptrtoint i8* %$11 to i64
  %$9 = add i64 %len, %$10
  %$8 = inttoptr i64 %$9 to i8*
  store i8 0, i8* %$8
  %$13 = getelementptr inbounds %struct.String, %struct.String* %result, i32 0, i32 1
  store i64 %len, i64* %$13
  %$14 = load %struct.String, %struct.String* %result
  ret %struct.String %$14
}

define i1 @String$ptr.is-empty(%struct.String* %this) {
entry:
  %$2 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %$1 = load i64, i64* %$2
  %$0 = icmp eq i64 0, %$1
  ret i1 %$0
}

define %struct.StringView @String$ptr.view(%struct.String* %this) {
entry:
  %$1 = bitcast %struct.String* %this to %struct.StringView*
  %$0 = load %struct.StringView, %struct.StringView* %$1
  ret %struct.StringView %$0
}

define void @String$ptr.free(%struct.String* %this) {
entry:
  %$1 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  call void (i8*) @free(i8* %$0)
  ret void
}

define void @String$ptr.setFromChar(%struct.String* %this, i8 %c) {
entry:
  %ptr-ref = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %size-ref = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %ptr = call i8* (i64) @malloc(i64 2)
  store i8 %c, i8* %ptr
  %$2 = ptrtoint i8* %ptr to i64
  %$1 = add i64 1, %$2
  %$0 = inttoptr i64 %$1 to i8*
  store i8 0, i8* %$0
  store i8* %ptr, i8** %ptr-ref
  store i64 1, i64* %size-ref
  ret void
}

define void @String$ptr.append(%struct.String* %this, %struct.String* %other) {
entry:
  %same-string = icmp eq %struct.String* %this, %other
  br i1 %same-string, label %then0, label %post0
then0:
  %temp-copy = alloca %struct.String
  %$0 = call %struct.String (%struct.String*) @String$ptr.copyalloc(%struct.String* %other)
  store %struct.String %$0, %struct.String* %temp-copy
  call void (%struct.String*, %struct.String*) @String$ptr.append(%struct.String* %this, %struct.String* %temp-copy)
  %$2 = getelementptr inbounds %struct.String, %struct.String* %temp-copy, i32 0, i32 0
  %$1 = load i8*, i8** %$2
  call void (i8*) @free(i8* %$1)
  ret void
  br label %post0
post0:
  %$3 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %old-length = load i64, i64* %$3
  %$5 = getelementptr inbounds %struct.String, %struct.String* %other, i32 0, i32 1
  %$4 = load i64, i64* %$5
  %new-length = add i64 %old-length, %$4
  %$8 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %$7 = load i8*, i8** %$8
  %$9 = add i64 1, %new-length
  %$6 = call i8* (i8*, i64) @realloc(i8* %$7, i64 %$9)
  %$10 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  store i8* %$6, i8** %$10
  %end-of-this-string = call i8* (%struct.String*) @String$ptr.end(%struct.String* %this)
  %$11 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  store i64 %new-length, i64* %$11
  %$13 = getelementptr inbounds %struct.String, %struct.String* %other, i32 0, i32 0
  %$12 = load i8*, i8** %$13
  %$15 = getelementptr inbounds %struct.String, %struct.String* %other, i32 0, i32 1
  %$14 = load i64, i64* %$15
  call i8* (i8*, i8*, i64) @memcpy(i8* %end-of-this-string, i8* %$12, i64 %$14)
  ret void
}

define void @String$ptr.prepend(%struct.String* %this, %struct.String* %other) {
entry:
  %same-string = icmp eq %struct.String* %this, %other
  br i1 %same-string, label %then0, label %post0
then0:
  %temp-copy = alloca %struct.String
  %$0 = call %struct.String (%struct.String*) @String$ptr.copyalloc(%struct.String* %other)
  store %struct.String %$0, %struct.String* %temp-copy
  call void (%struct.String*, %struct.String*) @String$ptr.append(%struct.String* %this, %struct.String* %temp-copy)
  %$2 = getelementptr inbounds %struct.String, %struct.String* %temp-copy, i32 0, i32 0
  %$1 = load i8*, i8** %$2
  call void (i8*) @free(i8* %$1)
  ret void
  br label %post0
post0:
  %$3 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %old-length = load i64, i64* %$3
  %$4 = getelementptr inbounds %struct.String, %struct.String* %other, i32 0, i32 1
  %other-length = load i64, i64* %$4
  %new-length = add i64 %old-length, %other-length
  %$5 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  store i64 %new-length, i64* %$5
  %$8 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %$7 = load i8*, i8** %$8
  %$9 = add i64 1, %new-length
  %$6 = call i8* (i8*, i64) @realloc(i8* %$7, i64 %$9)
  %$10 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  store i8* %$6, i8** %$10
  %$11 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %new-start = load i8*, i8** %$11
  %$12 = getelementptr inbounds %struct.String, %struct.String* %other, i32 0, i32 0
  %other-start = load i8*, i8** %$12
  %$14 = ptrtoint i8* %new-start to i64
  %$13 = add i64 %other-length, %$14
  %midpoint = inttoptr i64 %$13 to i8*
  call i8* (i8*, i8*, i64) @memmove(i8* %midpoint, i8* %new-start, i64 %old-length)
  call i8* (i8*, i8*, i64) @memcpy(i8* %new-start, i8* %other-start, i64 %other-length)
  ret void
}

define %struct.String @String.add(%struct.String* %left, %struct.String* %right) {
entry:
  %result = alloca %struct.String
  %$0 = call %struct.String (%struct.String*) @String$ptr.copyalloc(%struct.String* %left)
  store %struct.String %$0, %struct.String* %result
  call void (%struct.String*, %struct.String*) @String$ptr.append(%struct.String* %result, %struct.String* %right)
  %$1 = load %struct.String, %struct.String* %result
  ret %struct.String %$1
}

define i8* @String$ptr.end(%struct.String* %this) {
entry:
  %$0 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %begin = load i8*, i8** %$0
  %$1 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %length = load i64, i64* %$1
  %$3 = ptrtoint i8* %begin to i64
  %$2 = add i64 %$3, %length
  %one-past-last = inttoptr i64 %$2 to i8*
  ret i8* %one-past-last
}

define void @String$ptr.pushChar(%struct.String* %this, i8 %c) {
entry:
  %ptr-ref = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %size-ref = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %$2 = load i8*, i8** %ptr-ref
  %$1 = ptrtoint i8* %$2 to i64
  %$0 = icmp eq i64 0, %$1
  br i1 %$0, label %then0, label %post0
then0:
  tail call void (%struct.String*, i8) @String$ptr.setFromChar(%struct.String* %this, i8 %c)
  ret void
  br label %post0
post0:
  %old-size = load i64, i64* %size-ref
  %$4 = load i8*, i8** %ptr-ref
  %$5 = add i64 2, %old-size
  %$3 = call i8* (i8*, i64) @realloc(i8* %$4, i64 %$5)
  store i8* %$3, i8** %ptr-ref
  %$6 = add i64 1, %old-size
  store i64 %$6, i64* %size-ref
  %$9 = load i8*, i8** %ptr-ref
  %$8 = ptrtoint i8* %$9 to i64
  %$7 = add i64 %old-size, %$8
  %new-char-loc = inttoptr i64 %$7 to i8*
  store i8 %c, i8* %new-char-loc
  ret void
}

define void @reverse-pair(i8* %begin, i8* %end) {
entry:
  %$1 = ptrtoint i8* %begin to i64
  %$2 = ptrtoint i8* %end to i64
  %$0 = icmp uge i64 %$1, %$2
  br i1 %$0, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  call void (i8*, i8*) @i8$ptr.swap(i8* %begin, i8* %end)
  %$4 = ptrtoint i8* %begin to i64
  %$3 = add i64 %$4, 1
  %next-begin = inttoptr i64 %$3 to i8*
  %$6 = ptrtoint i8* %end to i64
  %$5 = sub i64 %$6, 1
  %next-end = inttoptr i64 %$5 to i8*
  tail call void (i8*, i8*) @reverse-pair(i8* %next-begin, i8* %next-end)
  ret void
}

define void @String$ptr.reverse-in-place(%struct.String* %this) {
entry:
  %$0 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %begin = load i8*, i8** %$0
  %$1 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %size = load i64, i64* %$1
  %$2 = icmp eq i64 0, %size
  br i1 %$2, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %$4 = sub i64 %size, 1
  %$5 = ptrtoint i8* %begin to i64
  %$3 = add i64 %$4, %$5
  %end = inttoptr i64 %$3 to i8*
  tail call void (i8*, i8*) @reverse-pair(i8* %begin, i8* %end)
  ret void
}

define i8 @String$ptr.char-at-unsafe(%struct.String* %this, i64 %i) {
entry:
  %$0 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %begin = load i8*, i8** %$0
  %$4 = ptrtoint i8* %begin to i64
  %$3 = add i64 %i, %$4
  %$2 = inttoptr i64 %$3 to i8*
  %$1 = load i8, i8* %$2
  ret i8 %$1
}

define void @String$ptr.print(%struct.String* %this) {
entry:
  %$1 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  %$3 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %$2 = load i64, i64* %$3
  call void (i8*, i64) @i8$ptr.printn(i8* %$0, i64 %$2)
  ret void
}

define void @String$ptr.println(%struct.String* %this) {
entry:
  %$1 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  %$3 = getelementptr inbounds %struct.String, %struct.String* %this, i32 0, i32 1
  %$2 = load i64, i64* %$3
  call void (i8*, i64) @i8$ptr.printn(i8* %$0, i64 %$2)
  call void () @println()
  ret void
}

define void @test.strlen() {
entry:
  %str-example = getelementptr inbounds [22 x i8], [22 x i8]* @str.0, i64 0, i64 0
  %$0 = call i64 (i8*) @i8$ptr.length(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.3, i64 0, i64 0))
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.1, i64 0, i64 0), i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.2, i64 0, i64 0), i64 %$0)
  ret void
}

define void @test.strview() {
entry:
  %string-view = alloca %struct.StringView
  %$0 = call %struct.StringView () @StringView.makeEmpty()
  store %struct.StringView %$0, %struct.StringView* %string-view
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %string-view, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.4, i64 0, i64 0))
  %$2 = getelementptr inbounds %struct.StringView, %struct.StringView* %string-view, i32 0, i32 0
  %$1 = load i8*, i8** %$2
  %$4 = getelementptr inbounds %struct.StringView, %struct.StringView* %string-view, i32 0, i32 1
  %$3 = load i64, i64* %$4
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.5, i64 0, i64 0), i8* %$1, i64 %$3)
  ret void
}

define void @test.basic-string() {
entry:
  %string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %string, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.6, i64 0, i64 0))
  %$1 = getelementptr inbounds %struct.String, %struct.String* %string, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  %$3 = getelementptr inbounds %struct.String, %struct.String* %string, i32 0, i32 1
  %$2 = load i64, i64* %$3
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.7, i64 0, i64 0), i8* %$0, i64 %$2)
  ret void
}

define void @test.string-self-append() {
entry:
  %string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %string, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str.8, i64 0, i64 0))
  call void (%struct.String*, %struct.String*) @String$ptr.append(%struct.String* %string, %struct.String* %string)
  %$1 = getelementptr inbounds %struct.String, %struct.String* %string, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  call i32 (i8*) @puts(i8* %$0)
  ret void
}

define void @test.string-append-helloworld() {
entry:
  %hello = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %hello, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.9, i64 0, i64 0))
  %world = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %world, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.10, i64 0, i64 0))
  call void (%struct.String*, %struct.String*) @String$ptr.append(%struct.String* %hello, %struct.String* %world)
  %$1 = getelementptr inbounds %struct.String, %struct.String* %hello, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  call i32 (i8*) @puts(i8* %$0)
  ret void
}

define void @test.string-pushchar() {
entry:
  %acc = alloca %struct.String
  %$0 = call %struct.String () @String.makeEmpty()
  store %struct.String %$0, %struct.String* %acc
  %A = add i8 65, 0
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %A)
  %$2 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %$1 = load i8*, i8** %$2
  call i32 (i8*) @puts(i8* %$1)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %A)
  %$4 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %$3 = load i8*, i8** %$4
  call i32 (i8*) @puts(i8* %$3)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %A)
  %$6 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %$5 = load i8*, i8** %$6
  call i32 (i8*) @puts(i8* %$5)
  ret void
}

define void @test.string-reverse-in-place() {
entry:
  %acc = alloca %struct.String
  %$0 = call %struct.String () @String.makeEmpty()
  store %struct.String %$0, %struct.String* %acc
  %A = add i8 65, 0
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %A)
  %$2 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %$1 = load i8*, i8** %$2
  call i32 (i8*) @puts(i8* %$1)
  %$3 = add i8 1, %A
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %$3)
  %$5 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %$4 = load i8*, i8** %$5
  call i32 (i8*) @puts(i8* %$4)
  %$6 = add i8 2, %A
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %$6)
  %$8 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %$7 = load i8*, i8** %$8
  call i32 (i8*) @puts(i8* %$7)
  %$9 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %begin = load i8*, i8** %$9
  %$10 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 1
  %size = load i64, i64* %$10
  %$12 = sub i64 %size, 1
  %$13 = ptrtoint i8* %begin to i64
  %$11 = add i64 %$12, %$13
  %end = inttoptr i64 %$11 to i8*
  call void (i64) @u64.print(i64 %size)
  %$14 = load i8, i8* %begin
  call void (i8) @i8.print(i8 %$14)
  %$15 = load i8, i8* %end
  call void (i8) @i8.print(i8 %$15)
  call void () @println()
  call void (i8*, i8*) @i8$ptr.swap(i8* %begin, i8* %end)
  %$17 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %$16 = load i8*, i8** %$17
  call i32 (i8*) @puts(i8* %$16)
  call void (%struct.String*) @String$ptr.reverse-in-place(%struct.String* %acc)
  %$19 = getelementptr inbounds %struct.String, %struct.String* %acc, i32 0, i32 0
  %$18 = load i8*, i8** %$19
  call i32 (i8*) @puts(i8* %$18)
  ret void
}

define void @test.stringview-nonpointer-eq() {
entry:
  %$0 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @str.11, i64 0, i64 0))
  %$1 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @str.12, i64 0, i64 0))
  %passed = call i1 (%struct.StringView, %struct.StringView) @StringView.eq(%struct.StringView %$0, %struct.StringView %$1)
  br i1 %passed, label %then0, label %post0
then0:
  call i32 (i8*) @puts(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.13, i64 0, i64 0))
  ret void
  br label %post0
post0:
  call i32 (i8*) @puts(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.14, i64 0, i64 0))
  ret void
}

define void @test.string-prepend-helloworld() {
entry:
  %hello = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %hello, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.15, i64 0, i64 0))
  %world = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %world, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.16, i64 0, i64 0))
  call void (%struct.String*, %struct.String*) @String$ptr.prepend(%struct.String* %world, %struct.String* %hello)
  call void (%struct.String*) @String$ptr.println(%struct.String* %world)
  call void (%struct.String*) @String$ptr.free(%struct.String* %world)
  call void (%struct.String*) @String$ptr.free(%struct.String* %hello)
  ret void
}

%struct.File = type { %struct.String, i32 };
define %struct.File @File._open(%struct.StringView* %filename-view, i32 %flags) {
entry:
  %result = alloca %struct.File
  %$0 = getelementptr inbounds %struct.StringView, %struct.StringView* %filename-view, i32 0, i32 0
  %filename = load i8*, i8** %$0
  %$1 = call %struct.String (%struct.StringView*) @String.makeFromStringView(%struct.StringView* %filename-view)
  %$2 = getelementptr inbounds %struct.File, %struct.File* %result, i32 0, i32 0
  store %struct.String %$1, %struct.String* %$2
  %fd = call i32 (i8*, i32, ...) @open(i8* %filename, i32 %flags)
  %$4 = sub i32 0, 1
  %$3 = icmp eq i32 %fd, %$4
  br i1 %$3, label %then0, label %post0
then0:
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @str.17, i64 0, i64 0), i8* %filename)
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  %$5 = getelementptr inbounds %struct.File, %struct.File* %result, i32 0, i32 1
  store i32 %fd, i32* %$5
  %$6 = load %struct.File, %struct.File* %result
  ret %struct.File %$6
}

define %struct.File @File.open(%struct.StringView* %filename-view) {
entry:
  %O_RDONLY = add i32 0, 0
  %$0 = call %struct.File (%struct.StringView*, i32) @File._open(%struct.StringView* %filename-view, i32 %O_RDONLY)
  ret %struct.File %$0
}

define %struct.File @File.openrw(%struct.StringView* %filename-view) {
entry:
  %O_RDWR = add i32 2, 0
  %$0 = call %struct.File (%struct.StringView*, i32) @File._open(%struct.StringView* %filename-view, i32 %O_RDWR)
  ret %struct.File %$0
}

define i64 @File$ptr.getSize(%struct.File* %this) {
entry:
  %SEEK_END = add i32 2, 0
  %$2 = getelementptr inbounds %struct.File, %struct.File* %this, i32 0, i32 1
  %$1 = load i32, i32* %$2
  %$0 = call i64 (i32, i64, i32) @lseek(i32 %$1, i64 0, i32 %SEEK_END)
  ret i64 %$0
}

define i8* @File$ptr._mmap(%struct.File* %this, i8* %addr, i64 %file-length, i32 %prot, i32 %flags, i64 %offset) {
entry:
  %$1 = getelementptr inbounds %struct.File, %struct.File* %this, i32 0, i32 1
  %$0 = load i32, i32* %$1
  %result = call i8* (i8*, i64, i32, i32, i32, i64) @mmap(i8* %addr, i64 %file-length, i32 %prot, i32 %flags, i32 %$0, i64 %offset)
  %$3 = sub i64 0, 1
  %$4 = ptrtoint i8* %result to i64
  %$2 = icmp eq i64 %$3, %$4
  br i1 %$2, label %then0, label %post0
then0:
  call void (i8*) @perror(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.18, i64 0, i64 0))
  call void (i32) @exit(i32 0)
  br label %post0
post0:
  ret i8* %result
}

define %struct.StringView @File$ptr.read(%struct.File* %this) {
entry:
  %PROT_READ = add i32 1, 0
  %MAP_PRIVATE = add i32 2, 0
  %file-length = call i64 (%struct.File*) @File$ptr.getSize(%struct.File* %this)
  %$0 = inttoptr i64 0 to i8*
  %char-ptr = call i8* (%struct.File*, i8*, i64, i32, i32, i64) @File$ptr._mmap(%struct.File* %this, i8* %$0, i64 %file-length, i32 %PROT_READ, i32 %MAP_PRIVATE, i64 0)
  %$1 = call %struct.StringView (i8*, i64) @StringView.make(i8* %char-ptr, i64 %file-length)
  ret %struct.StringView %$1
}

define %struct.StringView @File$ptr.readwrite(%struct.File* %this) {
entry:
  %PROT_RDWR = add i32 3, 0
  %MAP_PRIVATE = add i32 2, 0
  %file-length = call i64 (%struct.File*) @File$ptr.getSize(%struct.File* %this)
  %$0 = inttoptr i64 0 to i8*
  %char-ptr = call i8* (%struct.File*, i8*, i64, i32, i32, i64) @File$ptr._mmap(%struct.File* %this, i8* %$0, i64 %file-length, i32 %PROT_RDWR, i32 %MAP_PRIVATE, i64 0)
  %$1 = call %struct.StringView (i8*, i64) @StringView.make(i8* %char-ptr, i64 %file-length)
  ret %struct.StringView %$1
}

define void @File.unread(%struct.StringView* %view) {
entry:
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %view, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  %$3 = getelementptr inbounds %struct.StringView, %struct.StringView* %view, i32 0, i32 1
  %$2 = load i64, i64* %$3
  call i32 (i8*, i64) @munmap(i8* %$0, i64 %$2)
  ret void
}

define void @File$ptr.close(%struct.File* %this) {
entry:
  %$1 = getelementptr inbounds %struct.File, %struct.File* %this, i32 0, i32 1
  %$0 = load i32, i32* %$1
  call i32 (i32) @close(i32 %$0)
  ret void
}

define void @test.file-cat() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.19, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %$1 = getelementptr inbounds %struct.File, %struct.File* %file, i32 0, i32 0
  call void (%struct.String*) @String$ptr.println(%struct.String* %$1)
  %content = alloca %struct.StringView
  %$2 = call %struct.StringView (%struct.File*) @File$ptr.read(%struct.File* %file)
  store %struct.StringView %$2, %struct.StringView* %content
  call void (%struct.StringView*) @StringView$ptr.print(%struct.StringView* %content)
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @test.file-size() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.20, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %size = call i64 (%struct.File*) @File$ptr.getSize(%struct.File* %file)
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.21, i64 0, i64 0), i64 %size)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @test.bad-file-open() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.22, i64 0, i64 0))
  call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  ret void
}

%struct.Reader = type { %struct.StringView, i8*, i8, i64, i64 };
define void @Reader$ptr.set(%struct.Reader* %this, %struct.StringView* %string-view) {
entry:
  %$0 = load %struct.StringView, %struct.StringView* %string-view
  %$1 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 0
  store %struct.StringView %$0, %struct.StringView* %$1
  %content = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 0
  %$3 = getelementptr inbounds %struct.StringView, %struct.StringView* %string-view, i32 0, i32 0
  %$2 = load i8*, i8** %$3
  %$4 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 1
  store i8* %$2, i8** %$4
  %$5 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 2
  store i8 0, i8* %$5
  %$6 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 3
  store i64 0, i64* %$6
  %$7 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  store i64 0, i64* %$7
  ret void
}

define i8 @Reader$ptr.peek(%struct.Reader* %this) {
entry:
  %$2 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 1
  %$1 = load i8*, i8** %$2
  %$0 = load i8, i8* %$1
  ret i8 %$0
}

define i8 @Reader$ptr.get(%struct.Reader* %this) {
entry:
  %iter-ref = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 1
  %$0 = load i8*, i8** %iter-ref
  %char = load i8, i8* %$0
  %$1 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 2
  store i8 %char, i8* %$1
  %$5 = load i8*, i8** %iter-ref
  %$4 = ptrtoint i8* %$5 to i64
  %$3 = add i64 1, %$4
  %$2 = inttoptr i64 %$3 to i8*
  store i8* %$2, i8** %iter-ref
  %NEWLINE = add i8 10, 0
  %$6 = icmp eq i8 %char, %NEWLINE
  br i1 %$6, label %then0, label %post0
then0:
  %$9 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 3
  %$8 = load i64, i64* %$9
  %$7 = add i64 1, %$8
  %$10 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 3
  store i64 %$7, i64* %$10
  %$11 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  store i64 0, i64* %$11
  ret i8 %char
  br label %post0
post0:
  %$14 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  %$13 = load i64, i64* %$14
  %$12 = add i64 1, %$13
  %$15 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  store i64 %$12, i64* %$15
  ret i8 %char
}

define void @Reader$ptr.seek-backwards-on-line(%struct.Reader* %this, i64 %line, i64 %col) {
entry:
  %col-ref = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  %$0 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  %curr-col = load i64, i64* %$0
  %anti-offset = sub i64 %curr-col, %col
  %$5 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 1
  %$4 = load i8*, i8** %$5
  %$3 = ptrtoint i8* %$4 to i64
  %$2 = sub i64 %$3, %anti-offset
  %$1 = inttoptr i64 %$2 to i8*
  %$6 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 1
  store i8* %$1, i8** %$6
  %$7 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  store i64 %col, i64* %$7
  ret void
}

define void @Reader$ptr.seek-forwards.fail(%struct.Reader* %this, i64 %line, i64 %col, i8* %msg) {
entry:
  call void (i8*) @i8$ptr.unsafe-print(i8* %msg)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.23, i64 0, i64 0))
  %$1 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 3
  %$0 = load i64, i64* %$1
  call void (i64) @u64.print(i64 %$0)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.24, i64 0, i64 0))
  %$3 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  %$2 = load i64, i64* %$3
  call void (i64) @u64.print(i64 %$2)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.25, i64 0, i64 0))
  call void (i64) @u64.print(i64 %line)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.26, i64 0, i64 0))
  call void (i64) @u64.print(i64 %col)
  call void () @println()
  call void (i32) @exit(i32 1)
  ret void
}

define void @Reader$ptr.seek-forwards(%struct.Reader* %this, i64 %line, i64 %col) {
entry:
  %curr-line = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 3
  %curr-col = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  %$1 = load i64, i64* %curr-line
  %$0 = icmp eq i64 %line, %$1
  br i1 %$0, label %then0, label %post0
then0:
  %$3 = load i64, i64* %curr-col
  %$2 = icmp eq i64 %col, %$3
  br i1 %$2, label %then1, label %post1
then1:
  ret void
  br label %post1
post1:
  %$5 = load i64, i64* %curr-col
  %$4 = icmp ult i64 %col, %$5
  br i1 %$4, label %then2, label %post2
then2:
  call void (%struct.Reader*, i64, i64, i8*) @Reader$ptr.seek-forwards.fail(%struct.Reader* %this, i64 %line, i64 %col, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @str.27, i64 0, i64 0))
  br label %post2
post2:
  %$7 = load i64, i64* %curr-col
  %$6 = icmp ugt i64 %col, %$7
  br i1 %$6, label %then3, label %post3
then3:
  call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %this)
  %$9 = load i64, i64* %curr-line
  %$8 = icmp ult i64 %line, %$9
  br i1 %$8, label %then4, label %post4
then4:
  call void (%struct.Reader*, i64, i64, i8*) @Reader$ptr.seek-forwards.fail(%struct.Reader* %this, i64 %line, i64 %col, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @str.28, i64 0, i64 0))
  br label %post4
post4:
  call void (%struct.Reader*, i64, i64) @Reader$ptr.seek-forwards(%struct.Reader* %this, i64 %line, i64 %col)
  ret void
  br label %post3
post3:
  br label %post0
post0:
  %$10 = call i1 (%struct.Reader*) @Reader$ptr.done(%struct.Reader* %this)
  br i1 %$10, label %then5, label %post5
then5:
  call void (%struct.Reader*, i64, i64, i8*) @Reader$ptr.seek-forwards.fail(%struct.Reader* %this, i64 %line, i64 %col, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @str.29, i64 0, i64 0))
  br label %post5
post5:
  %$12 = load i64, i64* %curr-line
  %$11 = icmp ult i64 %line, %$12
  br i1 %$11, label %then6, label %post6
then6:
  call void (%struct.Reader*, i64, i64, i8*) @Reader$ptr.seek-forwards.fail(%struct.Reader* %this, i64 %line, i64 %col, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @str.30, i64 0, i64 0))
  br label %post6
post6:
  call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %this)
  call void (%struct.Reader*, i64, i64) @Reader$ptr.seek-forwards(%struct.Reader* %this, i64 %line, i64 %col)
  ret void
}

define void @Reader$ptr.find-next(%struct.Reader* %this, i8 %char) {
entry:
  %$0 = call i1 (%struct.Reader*) @Reader$ptr.done(%struct.Reader* %this)
  br i1 %$0, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @str.31, i64 0, i64 0))
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  %peeked = call i8 (%struct.Reader*) @Reader$ptr.peek(%struct.Reader* %this)
  %$1 = icmp eq i8 %char, %peeked
  br i1 %$1, label %then1, label %post1
then1:
  ret void
  br label %post1
post1:
  call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %this)
  call void (%struct.Reader*, i8) @Reader$ptr.find-next(%struct.Reader* %this, i8 %char)
  ret void
}

define i64 @Reader$ptr.pos(%struct.Reader* %this) {
entry:
  %$0 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 1
  %iter = load i8*, i8** %$0
  %$2 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 0
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %$2, i32 0, i32 0
  %start = load i8*, i8** %$1
  %$3 = ptrtoint i8* %iter to i64
  %$4 = ptrtoint i8* %start to i64
  %result = sub i64 %$3, %$4
  ret i64 %result
}

define i1 @Reader$ptr.done(%struct.Reader* %this) {
entry:
  %content = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 0
  %$3 = getelementptr inbounds %struct.StringView, %struct.StringView* %content, i32 0, i32 0
  %$2 = load i8*, i8** %$3
  %$1 = ptrtoint i8* %$2 to i64
  %$5 = getelementptr inbounds %struct.StringView, %struct.StringView* %content, i32 0, i32 1
  %$4 = load i64, i64* %$5
  %$0 = add i64 %$1, %$4
  %content-end = inttoptr i64 %$0 to i8*
  %$6 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 1
  %iter = load i8*, i8** %$6
  %$7 = icmp eq i8* %iter, %content-end
  ret i1 %$7
}

define void @Reader$ptr.reset(%struct.Reader* %this) {
entry:
  %string-view = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 0
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %string-view, i32 0, i32 0
  %$0 = load i8*, i8** %$1
  %$2 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 1
  store i8* %$0, i8** %$2
  %$3 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 2
  store i8 0, i8* %$3
  %$4 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 3
  store i64 0, i64* %$4
  %$5 = getelementptr inbounds %struct.Reader, %struct.Reader* %this, i32 0, i32 4
  store i64 0, i64* %$5
  ret void
}

define void @test.Reader-get$lambda0(%struct.Reader* %reader, i32 %i) {
entry:
  %$0 = icmp eq i32 %i, 0
  br i1 %$0, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %$1 = call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %reader)
  call void (i8) @i8.print(i8 %$1)
  %$2 = sub i32 %i, 1
  tail call void (%struct.Reader*, i32) @test.Reader-get$lambda0(%struct.Reader* %reader, i32 %$2)
  ret void
}

define void @test.Reader-get() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.32, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %$1 = getelementptr inbounds %struct.File, %struct.File* %file, i32 0, i32 0
  call void (%struct.String*) @String$ptr.println(%struct.String* %$1)
  %content = alloca %struct.StringView
  %$2 = call %struct.StringView (%struct.File*) @File$ptr.read(%struct.File* %file)
  store %struct.StringView %$2, %struct.StringView* %content
  %reader = alloca %struct.Reader
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %reader, %struct.StringView* %content)
  call void (%struct.Reader*, i32) @test.Reader-get$lambda0(%struct.Reader* %reader, i32 50)
  call void () @println()
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @test.Reader-done$lambda0(%struct.Reader* %reader) {
entry:
  %$0 = call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %reader)
  call void (i8) @i8.print(i8 %$0)
  %$2 = call i1 (%struct.Reader*) @Reader$ptr.done(%struct.Reader* %reader)
  %$1 = sub i1 1, %$2
  br i1 %$1, label %then0, label %post0
then0:
  tail call void (%struct.Reader*) @test.Reader-done$lambda0(%struct.Reader* %reader)
  br label %post0
post0:
  ret void
}

define void @test.Reader-done() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.33, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %$1 = getelementptr inbounds %struct.File, %struct.File* %file, i32 0, i32 0
  call void (%struct.String*) @String$ptr.println(%struct.String* %$1)
  %content = alloca %struct.StringView
  %$2 = call %struct.StringView (%struct.File*) @File$ptr.read(%struct.File* %file)
  store %struct.StringView %$2, %struct.StringView* %content
  %reader = alloca %struct.Reader
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %reader, %struct.StringView* %content)
  call void (%struct.Reader*) @test.Reader-done$lambda0(%struct.Reader* %reader)
  call void () @println()
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @u64.string_(i64 %this, %struct.String* %acc) {
entry:
  %$0 = icmp eq i64 0, %this
  br i1 %$0, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %ZERO = add i8 48, 0
  %top = urem i64 %this, 10
  %$1 = trunc i64 %top to i8
  %c = add i8 %ZERO, %$1
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %c)
  %rest = udiv i64 %this, 10
  tail call void (i64, %struct.String*) @u64.string_(i64 %rest, %struct.String* %acc)
  ret void
}

define %struct.String @u64.string(i64 %this) {
entry:
  %acc = alloca %struct.String
  %$0 = call %struct.String () @String.makeEmpty()
  store %struct.String %$0, %struct.String* %acc
  %ZERO = add i8 48, 0
  %$1 = icmp eq i64 0, %this
  br i1 %$1, label %then0, label %post0
then0:
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %ZERO)
  %$2 = load %struct.String, %struct.String* %acc
  ret %struct.String %$2
  br label %post0
post0:
  call void (i64, %struct.String*) @u64.string_(i64 %this, %struct.String* %acc)
  call void (%struct.String*) @String$ptr.reverse-in-place(%struct.String* %acc)
  %$3 = load %struct.String, %struct.String* %acc
  ret %struct.String %$3
}

define void @u64.print(i64 %this) {
entry:
  %string = alloca %struct.String
  %$0 = call %struct.String (i64) @u64.string(i64 %this)
  store %struct.String %$0, %struct.String* %string
  call void (%struct.String*) @String$ptr.print(%struct.String* %string)
  ret void
}

define void @u64.println(i64 %this) {
entry:
  call void (i64) @u64.print(i64 %this)
  call void () @println()
  ret void
}

define void @test.u64-print() {
entry:
  call void (i64) @u64.print(i64 12408124)
  call void () @println()
  ret void
}

%struct.u64-vector = type { i64*, i64, i64 };
define %struct.u64-vector @u64-vector.make() {
entry:
  %result = alloca %struct.u64-vector
  %$0 = inttoptr i64 0 to i64*
  %$1 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %result, i32 0, i32 0
  store i64* %$0, i64** %$1
  %$2 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %result, i32 0, i32 1
  store i64 0, i64* %$2
  %$3 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %result, i32 0, i32 2
  store i64 0, i64* %$3
  %$4 = load %struct.u64-vector, %struct.u64-vector* %result
  ret %struct.u64-vector %$4
}

define void @u64-vector$ptr.push(%struct.u64-vector* %this, i64 %item) {
entry:
  %SIZEOF-u64 = add i64 8, 0
  %data-ref = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 0
  %length-ref = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 1
  %cap-ref = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 2
  %$1 = load i64, i64* %length-ref
  %$2 = load i64, i64* %cap-ref
  %$0 = icmp eq i64 %$1, %$2
  br i1 %$0, label %then0, label %post0
then0:
  %old-capacity = load i64, i64* %cap-ref
  %$3 = icmp eq i64 0, %old-capacity
  br i1 %$3, label %then1, label %post1
then1:
  store i64 1, i64* %cap-ref
  br label %post1
post1:
  %$4 = icmp ne i64 0, %old-capacity
  br i1 %$4, label %then2, label %post2
then2:
  %$5 = mul i64 2, %old-capacity
  store i64 %$5, i64* %cap-ref
  br label %post2
post2:
  %new-capacity = load i64, i64* %cap-ref
  %old-data = load i64*, i64** %data-ref
  %$7 = bitcast i64* %old-data to i8*
  %$8 = mul i64 %SIZEOF-u64, %new-capacity
  %$6 = call i8* (i8*, i64) @realloc(i8* %$7, i64 %$8)
  %new-data = bitcast i8* %$6 to i64*
  %$9 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 0
  store i64* %new-data, i64** %$9
  br label %post0
post0:
  %$10 = load i64*, i64** %data-ref
  %data-base = ptrtoint i64* %$10 to i64
  %$14 = load i64, i64* %length-ref
  %$13 = bitcast i64 %$14 to i64
  %$12 = mul i64 %SIZEOF-u64, %$13
  %$11 = add i64 %data-base, %$12
  %new-child-loc = inttoptr i64 %$11 to i64*
  store i64 %item, i64* %new-child-loc
  %$16 = load i64, i64* %length-ref
  %$15 = add i64 1, %$16
  store i64 %$15, i64* %length-ref
  ret void
}

define void @u64-vector$ptr.print_(%struct.u64-vector* %this, i64 %i) {
entry:
  %$2 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 1
  %$1 = load i64, i64* %$2
  %$0 = icmp eq i64 %$1, %i
  br i1 %$0, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %COMMA = add i8 44, 0
  %SPACE = add i8 32, 0
  call void (i8) @i8.print(i8 %COMMA)
  call void (i8) @i8.print(i8 %SPACE)
  %curr = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %this, i64 %i)
  call void (i64) @u64.print(i64 %curr)
  %$3 = add i64 1, %i
  tail call void (%struct.u64-vector*, i64) @u64-vector$ptr.print_(%struct.u64-vector* %this, i64 %$3)
  ret void
}

define void @u64-vector$ptr.print(%struct.u64-vector* %this) {
entry:
  %LBRACKET = add i8 91, 0
  %RBRACKET = add i8 93, 0
  %COMMA = add i8 44, 0
  %SPACE = add i8 32, 0
  call void (i8) @i8.print(i8 %LBRACKET)
  %$2 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 1
  %$1 = load i64, i64* %$2
  %$0 = icmp ne i64 0, %$1
  br i1 %$0, label %then0, label %post0
then0:
  %$5 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 0
  %$4 = load i64*, i64** %$5
  %$3 = load i64, i64* %$4
  call void (i64) @u64.print(i64 %$3)
  br label %post0
post0:
  %$8 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 1
  %$7 = load i64, i64* %$8
  %$6 = icmp ne i64 0, %$7
  br i1 %$6, label %then1, label %post1
then1:
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.print_(%struct.u64-vector* %this, i64 1)
  br label %post1
post1:
  call void (i8) @i8.print(i8 %RBRACKET)
  ret void
}

define void @u64-vector$ptr.println(%struct.u64-vector* %this) {
entry:
  call void (%struct.u64-vector*) @u64-vector$ptr.print(%struct.u64-vector* %this)
  call void () @println()
  ret void
}

define i64 @u64-vector$ptr.unsafe-get(%struct.u64-vector* %this, i64 %i) {
entry:
  %SIZEOF-u64 = add i64 8, 0
  %$3 = mul i64 %SIZEOF-u64, %i
  %$6 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 0
  %$5 = load i64*, i64** %$6
  %$4 = ptrtoint i64* %$5 to i64
  %$2 = add i64 %$3, %$4
  %$1 = inttoptr i64 %$2 to i64*
  %$0 = load i64, i64* %$1
  ret i64 %$0
}

define void @u64-vector$ptr.unsafe-put(%struct.u64-vector* %this, i64 %i, i64 %value) {
entry:
  %SIZEOF-u64 = add i64 8, 0
  %$2 = mul i64 %SIZEOF-u64, %i
  %$5 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %this, i32 0, i32 0
  %$4 = load i64*, i64** %$5
  %$3 = ptrtoint i64* %$4 to i64
  %$1 = add i64 %$2, %$3
  %$0 = inttoptr i64 %$1 to i64*
  store i64 %value, i64* %$0
  ret void
}

define void @test.u64-vector-basic() {
entry:
  %vec = alloca %struct.u64-vector
  %$0 = call %struct.u64-vector () @u64-vector.make()
  store %struct.u64-vector %$0, %struct.u64-vector* %vec
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 0)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 1)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 2)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 3)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 4)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 5)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 6)
  call void (%struct.u64-vector*) @u64-vector$ptr.println(%struct.u64-vector* %vec)
  ret void
}

define void @test.u64-vector-one() {
entry:
  %vec = alloca %struct.u64-vector
  %$0 = call %struct.u64-vector () @u64-vector.make()
  store %struct.u64-vector %$0, %struct.u64-vector* %vec
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 0)
  call void (%struct.u64-vector*) @u64-vector$ptr.println(%struct.u64-vector* %vec)
  ret void
}

define void @test.u64-vector-empty() {
entry:
  %vec = alloca %struct.u64-vector
  %$0 = call %struct.u64-vector () @u64-vector.make()
  store %struct.u64-vector %$0, %struct.u64-vector* %vec
  call void (%struct.u64-vector*) @u64-vector$ptr.println(%struct.u64-vector* %vec)
  ret void
}

define void @test.u64-vector-put() {
entry:
  %vec = alloca %struct.u64-vector
  %$0 = call %struct.u64-vector () @u64-vector.make()
  store %struct.u64-vector %$0, %struct.u64-vector* %vec
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 0)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 1)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 2)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 3)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 4)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 5)
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %vec, i64 6)
  call void (%struct.u64-vector*, i64, i64) @u64-vector$ptr.unsafe-put(%struct.u64-vector* %vec, i64 3, i64 10)
  call void (%struct.u64-vector*) @u64-vector$ptr.println(%struct.u64-vector* %vec)
  ret void
}

define %struct.Texp @Result.success(%struct.Texp* %texp) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.34, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %result
  %$1 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %result, %struct.Texp %$1)
  %$2 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$2
}

define %struct.Texp @Result.success-from-i8$ptr(i8* %cstr) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.35, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %result
  %$1 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* %cstr)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %result, %struct.Texp %$1)
  %$2 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$2
}

define %struct.Texp @Result.error(%struct.Texp* %texp) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.36, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %result
  %$1 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %result, %struct.Texp %$1)
  %$2 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$2
}

define %struct.Texp @Result.error-from-view(%struct.StringView* %view) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.37, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %result
  %$1 = call %struct.Texp (%struct.StringView*) @Texp.makeFromStringView(%struct.StringView* %view)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %result, %struct.Texp %$1)
  %$2 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$2
}

define %struct.Texp @Result.error-from-i8$ptr(i8* %cstr) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.38, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %result
  %$1 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* %cstr)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %result, %struct.Texp %$1)
  %$2 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$2
}

define %struct.Texp @Optional.some(%struct.Texp* %texp) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.39, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %result
  %$1 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %result, %struct.Texp %$1)
  %$2 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$2
}

define %struct.Texp @Optional.none() {
entry:
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.40, i64 0, i64 0))
  ret %struct.Texp %$0
}

%struct.Texp = type { %struct.String, %struct.Texp*, i64, i64 };
define void @Texp$ptr.setFromString(%struct.Texp* %this, %struct.String* %value) {
entry:
  %$0 = load %struct.String, %struct.String* %value
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  store %struct.String %$0, %struct.String* %$1
  %$2 = inttoptr i64 0 to %struct.Texp*
  %$3 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  store %struct.Texp* %$2, %struct.Texp** %$3
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  store i64 0, i64* %$4
  %$5 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 3
  store i64 0, i64* %$5
  ret void
}

define %struct.Texp @Texp.makeEmpty() {
entry:
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.41, i64 0, i64 0))
  ret %struct.Texp %$0
}

define %struct.Texp @Texp.makeFromi8$ptr(i8* %value-cstr) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.String (i8*) @String.makeFromi8$ptr(i8* %value-cstr)
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 0
  store %struct.String %$0, %struct.String* %$1
  %$2 = inttoptr i64 0 to %struct.Texp*
  %$3 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 1
  store %struct.Texp* %$2, %struct.Texp** %$3
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 2
  store i64 0, i64* %$4
  %$5 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 3
  store i64 0, i64* %$5
  %$6 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$6
}

define %struct.Texp @Texp.makeFromString(%struct.String* %value) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.String (%struct.String*) @String$ptr.copyalloc(%struct.String* %value)
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 0
  store %struct.String %$0, %struct.String* %$1
  %$2 = inttoptr i64 0 to %struct.Texp*
  %$3 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 1
  store %struct.Texp* %$2, %struct.Texp** %$3
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 2
  store i64 0, i64* %$4
  %$5 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 3
  store i64 0, i64* %$5
  %$6 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$6
}

define %struct.Texp @Texp.makeFromStringView(%struct.StringView* %value-view) {
entry:
  %result = alloca %struct.Texp
  %$0 = call %struct.String (%struct.StringView*) @String.makeFromStringView(%struct.StringView* %value-view)
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 0
  store %struct.String %$0, %struct.String* %$1
  %$2 = inttoptr i64 0 to %struct.Texp*
  %$3 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 1
  store %struct.Texp* %$2, %struct.Texp** %$3
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 2
  store i64 0, i64* %$4
  %$5 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 3
  store i64 0, i64* %$5
  %$6 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$6
}

define void @Texp$ptr.push$ptr(%struct.Texp* %this, %struct.Texp* %item) {
entry:
  %SIZEOF-Texp = add i64 40, 0
  %children-ref = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %length-ref = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  %cap-ref = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 3
  %$1 = load i64, i64* %length-ref
  %$2 = load i64, i64* %cap-ref
  %$0 = icmp eq i64 %$1, %$2
  br i1 %$0, label %then0, label %post0
then0:
  %old-capacity = load i64, i64* %cap-ref
  %$3 = icmp eq i64 0, %old-capacity
  br i1 %$3, label %then1, label %post1
then1:
  store i64 1, i64* %cap-ref
  br label %post1
post1:
  %$4 = icmp ne i64 0, %old-capacity
  br i1 %$4, label %then2, label %post2
then2:
  %$5 = mul i64 2, %old-capacity
  store i64 %$5, i64* %cap-ref
  br label %post2
post2:
  %new-capacity = load i64, i64* %cap-ref
  %old-children = load %struct.Texp*, %struct.Texp** %children-ref
  %$7 = bitcast %struct.Texp* %old-children to i8*
  %$8 = mul i64 %SIZEOF-Texp, %new-capacity
  %$6 = call i8* (i8*, i64) @realloc(i8* %$7, i64 %$8)
  %new-children = bitcast i8* %$6 to %struct.Texp*
  %$9 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  store %struct.Texp* %new-children, %struct.Texp** %$9
  br label %post0
post0:
  %$10 = load %struct.Texp*, %struct.Texp** %children-ref
  %children-base = ptrtoint %struct.Texp* %$10 to i64
  %$14 = load i64, i64* %length-ref
  %$13 = bitcast i64 %$14 to i64
  %$12 = mul i64 %SIZEOF-Texp, %$13
  %$11 = add i64 %$12, %children-base
  %new-child-loc = inttoptr i64 %$11 to %struct.Texp*
  %$15 = load %struct.Texp, %struct.Texp* %item
  store %struct.Texp %$15, %struct.Texp* %new-child-loc
  %$17 = load i64, i64* %length-ref
  %$16 = add i64 1, %$17
  store i64 %$16, i64* %length-ref
  ret void
}

define void @Texp$ptr.push(%struct.Texp* %this, %struct.Texp %item) {
entry:
  %local-item = alloca %struct.Texp
  store %struct.Texp %item, %struct.Texp* %local-item
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %this, %struct.Texp* %local-item)
  ret void
}

define void @Texp$ptr.free$lambda.child-iter(%struct.Texp* %this, i64 %child-index) {
entry:
  %SIZEOF-Texp = add i64 40, 0
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %children = load %struct.Texp*, %struct.Texp** %$0
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  %length = load i64, i64* %$1
  %$2 = icmp eq i64 %child-index, %length
  br i1 %$2, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %$4 = mul i64 %SIZEOF-Texp, %child-index
  %$5 = ptrtoint %struct.Texp* %children to i64
  %$3 = add i64 %$4, %$5
  %curr = inttoptr i64 %$3 to %struct.Texp*
  call void (%struct.Texp*) @Texp$ptr.free(%struct.Texp* %curr)
  %$6 = add i64 1, %child-index
  tail call void (%struct.Texp*, i64) @Texp$ptr.free$lambda.child-iter(%struct.Texp* %this, i64 %$6)
  ret void
}

define void @Texp$ptr.free(%struct.Texp* %this) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  call void (%struct.String*) @String$ptr.free(%struct.String* %$0)
  %$3 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %$2 = load %struct.Texp*, %struct.Texp** %$3
  %$1 = bitcast %struct.Texp* %$2 to i8*
  call void (i8*) @free(i8* %$1)
  call void (%struct.Texp*, i64) @Texp$ptr.free$lambda.child-iter(%struct.Texp* %this, i64 0)
  ret void
}

define void @Texp$ptr.demote-free(%struct.Texp* %this) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  call void (%struct.String*) @String$ptr.free(%struct.String* %$0)
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %child-ref = load %struct.Texp*, %struct.Texp** %$1
  %$2 = load %struct.Texp, %struct.Texp* %child-ref
  store %struct.Texp %$2, %struct.Texp* %this
  %$3 = bitcast %struct.Texp* %child-ref to i8*
  call void (i8*) @free(i8* %$3)
  ret void
}

define void @Texp$ptr.shallow-free(%struct.Texp* %this) {
entry:
  ret void
}

define void @Texp$ptr.clone_(%struct.Texp* %acc, %struct.Texp* %curr, %struct.Texp* %last) {
entry:
  %SIZEOF-Texp = add i64 40, 0
  %$0 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %curr)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %acc, %struct.Texp %$0)
  %$1 = icmp eq %struct.Texp* %last, %curr
  br i1 %$1, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %$3 = ptrtoint %struct.Texp* %curr to i64
  %$2 = add i64 %SIZEOF-Texp, %$3
  %next = inttoptr i64 %$2 to %struct.Texp*
  call void (%struct.Texp*, %struct.Texp*, %struct.Texp*) @Texp$ptr.clone_(%struct.Texp* %acc, %struct.Texp* %next, %struct.Texp* %last)
  ret void
}

define %struct.Texp @Texp$ptr.clone(%struct.Texp* %this) {
entry:
  %result = alloca %struct.Texp
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  %$0 = call %struct.String (%struct.String*) @String$ptr.copyalloc(%struct.String* %$1)
  %$2 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 0
  store %struct.String %$0, %struct.String* %$2
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 1
  %$3 = bitcast %struct.Texp** %$4 to i64*
  store i64 0, i64* %$3
  %$5 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 2
  store i64 0, i64* %$5
  %$6 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 3
  store i64 0, i64* %$6
  %$9 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  %$8 = load i64, i64* %$9
  %$7 = icmp ne i64 0, %$8
  br i1 %$7, label %then0, label %post0
then0:
  %$11 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %$10 = load %struct.Texp*, %struct.Texp** %$11
  %$12 = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %this)
  call void (%struct.Texp*, %struct.Texp*, %struct.Texp*) @Texp$ptr.clone_(%struct.Texp* %result, %struct.Texp* %$10, %struct.Texp* %$12)
  br label %post0
post0:
  %$13 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$13
}

define void @Texp$ptr.parenPrint$lambda.child-iter(%struct.Texp* %this, i64 %child-index) {
entry:
  %SIZEOF-Texp = add i64 40, 0
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %children = load %struct.Texp*, %struct.Texp** %$0
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  %length = load i64, i64* %$1
  %$2 = icmp eq i64 %child-index, %length
  br i1 %$2, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %$4 = mul i64 %SIZEOF-Texp, %child-index
  %$5 = ptrtoint %struct.Texp* %children to i64
  %$3 = add i64 %$4, %$5
  %curr = inttoptr i64 %$3 to %struct.Texp*
  %$6 = icmp ne i64 0, %child-index
  br i1 %$6, label %then1, label %post1
then1:
  %SPACE = add i8 32, 0
  call void (i8) @i8.print(i8 %SPACE)
  br label %post1
post1:
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %curr)
  %$7 = add i64 1, %child-index
  tail call void (%struct.Texp*, i64) @Texp$ptr.parenPrint$lambda.child-iter(%struct.Texp* %this, i64 %$7)
  ret void
}

define void @Texp$ptr.parenPrint(%struct.Texp* %this) {
entry:
  %$1 = ptrtoint %struct.Texp* %this to i64
  %$0 = icmp eq i64 0, %$1
  br i1 %$0, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.42, i64 0, i64 0))
  ret void
  br label %post0
post0:
  %value-ref = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  %$2 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  %length = load i64, i64* %$2
  %$3 = icmp eq i64 0, %length
  br i1 %$3, label %then1, label %post1
then1:
  call void (%struct.String*) @String$ptr.print(%struct.String* %value-ref)
  ret void
  br label %post1
post1:
  %LPAREN = add i8 40, 0
  %RPAREN = add i8 41, 0
  %SPACE = add i8 32, 0
  call void (i8) @i8.print(i8 %LPAREN)
  call void (%struct.String*) @String$ptr.print(%struct.String* %value-ref)
  call void (i8) @i8.print(i8 %SPACE)
  call void (%struct.Texp*, i64) @Texp$ptr.parenPrint$lambda.child-iter(%struct.Texp* %this, i64 0)
  call void (i8) @i8.print(i8 %RPAREN)
  ret void
}

define void @Texp$ptr.shallow-dump(%struct.Texp* %this) {
entry:
  %$1 = ptrtoint %struct.Texp* %this to i64
  %$0 = icmp ne i64 0, %$1
  br i1 %$0, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.43, i64 0, i64 0))
  %$2 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  call void (%struct.String*) @String$ptr.print(%struct.String* %$2)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.44, i64 0, i64 0))
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  %$3 = load i64, i64* %$4
  call void (i64) @u64.print(i64 %$3)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.45, i64 0, i64 0))
  %$6 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 3
  %$5 = load i64, i64* %$6
  call void (i64) @u64.print(i64 %$5)
  br label %post0
post0:
  %$8 = ptrtoint %struct.Texp* %this to i64
  %$7 = icmp eq i64 0, %$8
  br i1 %$7, label %then1, label %post1
then1:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.46, i64 0, i64 0))
  br label %post1
post1:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.47, i64 0, i64 0))
  %$9 = ptrtoint %struct.Texp* %this to i64
  call void (i64) @u64.println(i64 %$9)
  ret void
}

define %struct.Texp* @Texp$ptr.last(%struct.Texp* %this) {
entry:
  %SIZEOF-Texp = add i64 40, 0
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  %len = load i64, i64* %$0
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %first-child = load %struct.Texp*, %struct.Texp** %$1
  %$3 = ptrtoint %struct.Texp* %first-child to i64
  %$5 = sub i64 %len, 1
  %$4 = mul i64 %SIZEOF-Texp, %$5
  %$2 = add i64 %$3, %$4
  %last = inttoptr i64 %$2 to %struct.Texp*
  ret %struct.Texp* %last
}

define %struct.Texp* @Texp$ptr.child(%struct.Texp* %this, i64 %i) {
entry:
  %SIZEOF-Texp = add i64 40, 0
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %first-child = load %struct.Texp*, %struct.Texp** %$0
  %$2 = ptrtoint %struct.Texp* %first-child to i64
  %$3 = mul i64 %SIZEOF-Texp, %i
  %$1 = add i64 %$2, %$3
  %child = inttoptr i64 %$1 to %struct.Texp*
  ret %struct.Texp* %child
}

define %struct.Texp* @Texp$ptr.find_(%struct.Texp* %this, %struct.Texp* %last, %struct.StringView* %key) {
entry:
  %SIZEOF-Texp = add i64 40, 0
  %view = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %this)
  %$0 = call i1 (%struct.StringView*, %struct.StringView*) @StringView$ptr.eq(%struct.StringView* %view, %struct.StringView* %key)
  br i1 %$0, label %then0, label %post0
then0:
  ret %struct.Texp* %this
  br label %post0
post0:
  %$1 = icmp eq %struct.Texp* %this, %last
  br i1 %$1, label %then1, label %post1
then1:
  %$2 = inttoptr i64 0 to %struct.Texp*
  ret %struct.Texp* %$2
  br label %post1
post1:
  %$4 = ptrtoint %struct.Texp* %this to i64
  %$3 = add i64 %SIZEOF-Texp, %$4
  %next = inttoptr i64 %$3 to %struct.Texp*
  %$5 = call %struct.Texp* (%struct.Texp*, %struct.Texp*, %struct.StringView*) @Texp$ptr.find_(%struct.Texp* %next, %struct.Texp* %last, %struct.StringView* %key)
  ret %struct.Texp* %$5
}

define %struct.Texp* @Texp$ptr.find(%struct.Texp* %this, %struct.StringView* %key) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %first = load %struct.Texp*, %struct.Texp** %$0
  %last = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %this)
  %$1 = call %struct.Texp* (%struct.Texp*, %struct.Texp*, %struct.StringView*) @Texp$ptr.find_(%struct.Texp* %first, %struct.Texp* %last, %struct.StringView* %key)
  ret %struct.Texp* %$1
}

define i1 @Texp$ptr.is-empty(%struct.Texp* %this) {
entry:
  %$2 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 2
  %$1 = load i64, i64* %$2
  %$0 = icmp eq i64 0, %$1
  ret i1 %$0
}

define i1 @Texp$ptr.value-check(%struct.Texp* %this, i8* %check) {
entry:
  %check-view = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* %check)
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  %value-view = call %struct.StringView (%struct.String*) @String$ptr.view(%struct.String* %$0)
  %$1 = call i1 (%struct.StringView, %struct.StringView) @StringView.eq(%struct.StringView %check-view, %struct.StringView %value-view)
  ret i1 %$1
}

define %struct.StringView* @Texp$ptr.value-view(%struct.Texp* %this) {
entry:
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  %$0 = bitcast %struct.String* %$1 to %struct.StringView*
  ret %struct.StringView* %$0
}

define i8 @Texp$ptr.value-get(%struct.Texp* %this, i64 %i) {
entry:
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  %$0 = getelementptr inbounds %struct.String, %struct.String* %$1, i32 0, i32 0
  %value = load i8*, i8** %$0
  %$3 = ptrtoint i8* %value to i64
  %$2 = add i64 %i, %$3
  %cptr = inttoptr i64 %$2 to i8*
  %$4 = load i8, i8* %cptr
  ret i8 %$4
}

define void @test.Texp-basic$lamdba.dump(%struct.Texp* %texp) {
entry:
  call void () @println()
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 2
  %$0 = load i64, i64* %$1
  call void (i64) @u64.print(i64 %$0)
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void () @println()
  ret void
}

define void @test.Texp-basic() {
entry:
  %hello-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %hello-string, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.48, i64 0, i64 0))
  %child0-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %child0-string, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.49, i64 0, i64 0))
  %child1-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %child1-string, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.50, i64 0, i64 0))
  %child2-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %child2-string, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.51, i64 0, i64 0))
  %texp = alloca %struct.Texp
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp, %struct.String* %hello-string)
  call void (%struct.Texp*) @test.Texp-basic$lamdba.dump(%struct.Texp* %texp)
  %texp-child = alloca %struct.Texp
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp-child, %struct.String* %child0-string)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %texp, %struct.Texp* %texp-child)
  call void (%struct.Texp*) @test.Texp-basic$lamdba.dump(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp-child, %struct.String* %child1-string)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %texp, %struct.Texp* %texp-child)
  call void (%struct.Texp*) @test.Texp-basic$lamdba.dump(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp-child, %struct.String* %child2-string)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %texp, %struct.Texp* %texp-child)
  call void (%struct.Texp*) @test.Texp-basic$lamdba.dump(%struct.Texp* %texp)
  call void (%struct.Texp*) @Texp$ptr.free(%struct.Texp* %texp)
  ret void
}

define void @test.Texp-clone() {
entry:
  %hello-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %hello-string, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.52, i64 0, i64 0))
  %child0-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %child0-string, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.53, i64 0, i64 0))
  %child1-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %child1-string, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.54, i64 0, i64 0))
  %child2-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %child2-string, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.55, i64 0, i64 0))
  %texp = alloca %struct.Texp
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp, %struct.String* %hello-string)
  call void (%struct.Texp*) @test.Texp-basic$lamdba.dump(%struct.Texp* %texp)
  %texp-child = alloca %struct.Texp
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp-child, %struct.String* %child0-string)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %texp, %struct.Texp* %texp-child)
  call void (%struct.Texp*) @test.Texp-basic$lamdba.dump(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp-child, %struct.String* %child1-string)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %texp, %struct.Texp* %texp-child)
  call void (%struct.Texp*) @test.Texp-basic$lamdba.dump(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp-child, %struct.String* %child2-string)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %texp, %struct.Texp* %texp-child)
  call void (%struct.Texp*) @test.Texp-basic$lamdba.dump(%struct.Texp* %texp)
  call void (%struct.Texp*) @Texp$ptr.free(%struct.Texp* %texp)
  ret void
}

define void @test.Texp-clone-atom() {
entry:
  %texp = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.56, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %texp
  %clone = alloca %struct.Texp
  %$1 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp)
  store %struct.Texp %$1, %struct.Texp* %clone
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 0
  %$3 = getelementptr inbounds %struct.String, %struct.String* %$4, i32 0, i32 0
  %$2 = ptrtoint i8** %$3 to i64
  call void (i64) @u64.print(i64 %$2)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.57, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.shallow-dump(%struct.Texp* %texp)
  call void () @println()
  %$7 = getelementptr inbounds %struct.Texp, %struct.Texp* %clone, i32 0, i32 0
  %$6 = getelementptr inbounds %struct.String, %struct.String* %$7, i32 0, i32 0
  %$5 = ptrtoint i8** %$6 to i64
  call void (i64) @u64.print(i64 %$5)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.58, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.shallow-dump(%struct.Texp* %clone)
  call void () @println()
  ret void
}

define void @test.Texp-clone-hard() {
entry:
  %content-view = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %content-view, i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.59, i64 0, i64 0))
  %parser = alloca %struct.Parser
  %$0 = bitcast %struct.Parser* %parser to %struct.Reader*
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$0, %struct.StringView* %content-view)
  %result = alloca %struct.Texp
  %$1 = call %struct.Texp (%struct.Parser*) @Parser$ptr.texp(%struct.Parser* %parser)
  store %struct.Texp %$1, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
  %clone = alloca %struct.Texp
  %$2 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %result)
  store %struct.Texp %$2, %struct.Texp* %clone
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %clone)
  call void () @println()
  ret void
}

define void @test.Texp-value-get() {
entry:
  %hello-string = alloca %struct.String
  call void (%struct.String*, i8*) @String$ptr.set(%struct.String* %hello-string, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.60, i64 0, i64 0))
  %texp = alloca %struct.Texp
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp, %struct.String* %hello-string)
  %E_CHAR = add i8 101, 0
  %$0 = call i8 (%struct.Texp*, i64) @Texp$ptr.value-get(%struct.Texp* %texp, i64 1)
  %success = icmp eq i8 %E_CHAR, %$0
  br i1 %success, label %then0, label %post0
then0:
  call i32 (i8*) @puts(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.61, i64 0, i64 0))
  br label %post0
post0:
  %$1 = sub i1 1, %success
  br i1 %$1, label %then1, label %post1
then1:
  call i32 (i8*) @puts(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.62, i64 0, i64 0))
  br label %post1
post1:
  call void (%struct.Texp*) @Texp$ptr.free(%struct.Texp* %texp)
  ret void
}

define void @test.Texp-program-grammar-eq() {
entry:
  %grammar-texp = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @str.63, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %grammar-texp
  call void (%struct.Texp*) @Texp$ptr.demote-free(%struct.Texp* %grammar-texp)
  %start-production = alloca %struct.StringView
  %$1 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.64, i64 0, i64 0))
  store %struct.StringView %$1, %struct.StringView* %start-production
  %first-child = call %struct.Texp* (%struct.Texp*, i64) @Texp$ptr.child(%struct.Texp* %grammar-texp, i64 0)
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %first-child)
  call void () @println()
  %view = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %first-child)
  %$2 = call i1 (%struct.StringView*, %struct.StringView*) @StringView$ptr.eq(%struct.StringView* %view, %struct.StringView* %start-production)
  br i1 %$2, label %then0, label %post0
then0:
  call i32 (i8*) @puts(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.65, i64 0, i64 0))
  ret void
  br label %post0
post0:
  call i32 (i8*) @puts(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.66, i64 0, i64 0))
  ret void
}

define void @test.Texp-find-program-grammar() {
entry:
  %grammar-texp = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @str.67, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %grammar-texp
  call void (%struct.Texp*) @Texp$ptr.demote-free(%struct.Texp* %grammar-texp)
  %start-production = alloca %struct.StringView
  %$1 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.68, i64 0, i64 0))
  store %struct.StringView %$1, %struct.StringView* %start-production
  %found-texp = call %struct.Texp* (%struct.Texp*, %struct.StringView*) @Texp$ptr.find(%struct.Texp* %grammar-texp, %struct.StringView* %start-production)
  %$3 = ptrtoint %struct.Texp* %found-texp to i64
  %$2 = icmp eq i64 0, %$3
  br i1 %$2, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([46 x i8], [46 x i8]* @str.69, i64 0, i64 0))
  br label %post0
post0:
  %$5 = ptrtoint %struct.Texp* %found-texp to i64
  %$4 = icmp ne i64 0, %$5
  br i1 %$4, label %then1, label %post1
then1:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.70, i64 0, i64 0))
  br label %post1
post1:
  ret void
}

define void @test.Texp-makeFromi8$ptr() {
entry:
  %string = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.71, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %string
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %string, i32 0, i32 0
  %$3 = getelementptr inbounds %struct.String, %struct.String* %$4, i32 0, i32 1
  %$2 = load i64, i64* %$3
  %$1 = icmp eq i64 10, %$2
  br i1 %$1, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.72, i64 0, i64 0))
  ret void
  br label %post0
post0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.73, i64 0, i64 0))
  ret void
}

define void @test.Texp-value-view() {
entry:
  %string = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.74, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %string
  %value-view = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %string)
  %$3 = getelementptr inbounds %struct.StringView, %struct.StringView* %value-view, i32 0, i32 1
  %$2 = load i64, i64* %$3
  %$1 = icmp eq i64 10, %$2
  br i1 %$1, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.75, i64 0, i64 0))
  ret void
  br label %post0
post0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.76, i64 0, i64 0))
  ret void
}

define i1 @i8.isspace(i8 %this) {
entry:
  %$0 = icmp eq i8 %this, 32
  br i1 %$0, label %then0, label %post0
then0:
  ret i1 true
  br label %post0
post0:
  %$1 = icmp eq i8 %this, 12
  br i1 %$1, label %then1, label %post1
then1:
  ret i1 true
  br label %post1
post1:
  %$2 = icmp eq i8 %this, 10
  br i1 %$2, label %then2, label %post2
then2:
  ret i1 true
  br label %post2
post2:
  %$3 = icmp eq i8 %this, 13
  br i1 %$3, label %then3, label %post3
then3:
  ret i1 true
  br label %post3
post3:
  %$4 = icmp eq i8 %this, 9
  br i1 %$4, label %then4, label %post4
then4:
  ret i1 true
  br label %post4
post4:
  %$5 = icmp eq i8 %this, 11
  br i1 %$5, label %then5, label %post5
then5:
  ret i1 true
  br label %post5
post5:
  ret i1 false
}

%struct.Parser = type { %struct.Reader, %struct.u64-vector, %struct.u64-vector, %struct.u64-vector, %struct.StringView };
define %struct.Parser @Parser.make(%struct.StringView* %content) {
entry:
  %result = alloca %struct.Parser
  %$0 = getelementptr inbounds %struct.Parser, %struct.Parser* %result, i32 0, i32 0
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$0, %struct.StringView* %content)
  %$1 = call %struct.u64-vector () @u64-vector.make()
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %result, i32 0, i32 1
  store %struct.u64-vector %$1, %struct.u64-vector* %$2
  %$3 = call %struct.u64-vector () @u64-vector.make()
  %$4 = getelementptr inbounds %struct.Parser, %struct.Parser* %result, i32 0, i32 2
  store %struct.u64-vector %$3, %struct.u64-vector* %$4
  %$5 = call %struct.u64-vector () @u64-vector.make()
  %$6 = getelementptr inbounds %struct.Parser, %struct.Parser* %result, i32 0, i32 3
  store %struct.u64-vector %$5, %struct.u64-vector* %$6
  %$7 = call %struct.StringView () @StringView.makeEmpty()
  %$8 = getelementptr inbounds %struct.Parser, %struct.Parser* %result, i32 0, i32 4
  store %struct.StringView %$7, %struct.StringView* %$8
  %$9 = load %struct.Parser, %struct.Parser* %result
  ret %struct.Parser %$9
}

define void @Parser$ptr.unmake(%struct.Parser* %this) {
entry:
  ret void
}

define void @Parser$ptr.add-coord(%struct.Parser* %this, i64 %type) {
entry:
  %reader = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$0 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 3
  %line = load i64, i64* %$0
  %$1 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 4
  %col = load i64, i64* %$1
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 1
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %$2, i64 %line)
  %$3 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 2
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %$3, i64 %col)
  %$4 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 3
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %$4, i64 %type)
  ret void
}

define void @Parser$ptr.add-open-coord(%struct.Parser* %this) {
entry:
  call void (%struct.Parser*, i64) @Parser$ptr.add-coord(%struct.Parser* %this, i64 0)
  ret void
}

define void @Parser$ptr.add-close-coord(%struct.Parser* %this) {
entry:
  call void (%struct.Parser*, i64) @Parser$ptr.add-coord(%struct.Parser* %this, i64 1)
  ret void
}

define void @Parser$ptr.add-value-coord(%struct.Parser* %this) {
entry:
  call void (%struct.Parser*, i64) @Parser$ptr.add-coord(%struct.Parser* %this, i64 2)
  ret void
}

define void @Parser$ptr.add-comment-coord(%struct.Parser* %this) {
entry:
  %reader = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$0 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 3
  %line = load i64, i64* %$0
  %$1 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 4
  %col = load i64, i64* %$1
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 1
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %$2, i64 %line)
  %$3 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 2
  %$4 = sub i64 %col, 1
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %$3, i64 %$4)
  %$5 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 3
  call void (%struct.u64-vector*, i64) @u64-vector$ptr.push(%struct.u64-vector* %$5, i64 3)
  ret void
}

define void @Parser$ptr.whitespace(%struct.Parser* %this) {
entry:
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$1 = call i8 (%struct.Reader*) @Reader$ptr.peek(%struct.Reader* %$2)
  %$0 = call i1 (i8) @i8.isspace(i8 %$1)
  br i1 %$0, label %then0, label %post0
then0:
  %$3 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %$3)
  tail call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %this)
  ret void
  br label %post0
post0:
  ret void
}

define void @Parser$ptr.word_(%struct.Parser* %this, %struct.String* %acc) {
entry:
  %reader = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$0 = call i1 (%struct.Reader*) @Reader$ptr.done(%struct.Reader* %reader)
  br i1 %$0, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %LPAREN = add i8 40, 0
  %RPAREN = add i8 41, 0
  %c = call i8 (%struct.Reader*) @Reader$ptr.peek(%struct.Reader* %reader)
  %$1 = icmp eq i8 %LPAREN, %c
  br i1 %$1, label %then1, label %post1
then1:
  ret void
  br label %post1
post1:
  %$2 = icmp eq i8 %RPAREN, %c
  br i1 %$2, label %then2, label %post2
then2:
  ret void
  br label %post2
post2:
  %$3 = call i1 (i8) @i8.isspace(i8 %c)
  br i1 %$3, label %then3, label %post3
then3:
  ret void
  br label %post3
post3:
  call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %reader)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %c)
  tail call void (%struct.Parser*, %struct.String*) @Parser$ptr.word_(%struct.Parser* %this, %struct.String* %acc)
  ret void
}

define %struct.String @Parser$ptr.word(%struct.Parser* %this) {
entry:
  %acc = alloca %struct.String
  %$0 = call %struct.String () @String.makeEmpty()
  store %struct.String %$0, %struct.String* %acc
  call void (%struct.Parser*, %struct.String*) @Parser$ptr.word_(%struct.Parser* %this, %struct.String* %acc)
  %$1 = load %struct.String, %struct.String* %acc
  ret %struct.String %$1
}

define void @Parser$ptr.string_(%struct.Parser* %this, %struct.String* %acc) {
entry:
  %QUOTE = add i8 34, 0
  %BACKSLASH = add i8 92, 0
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$1 = call i8 (%struct.Reader*) @Reader$ptr.peek(%struct.Reader* %$2)
  %$0 = icmp eq i8 %QUOTE, %$1
  br i1 %$0, label %then0, label %post0
then0:
  %$4 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$3 = getelementptr inbounds %struct.Reader, %struct.Reader* %$4, i32 0, i32 2
  %prev = load i8, i8* %$3
  %$5 = icmp ne i8 %BACKSLASH, %prev
  br i1 %$5, label %then1, label %post1
then1:
  ret void
  br label %post1
post1:
  br label %post0
post0:
  %$6 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %c = call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %$6)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %c)
  tail call void (%struct.Parser*, %struct.String*) @Parser$ptr.string_(%struct.Parser* %this, %struct.String* %acc)
  ret void
}

define %struct.Texp @Parser$ptr.string(%struct.Parser* %this) {
entry:
  %acc = alloca %struct.String
  %$0 = call %struct.String () @String.makeEmpty()
  store %struct.String %$0, %struct.String* %acc
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$1 = call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %$2)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %$1)
  call void (%struct.Parser*, %struct.String*) @Parser$ptr.string_(%struct.Parser* %this, %struct.String* %acc)
  %$4 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$3 = call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %$4)
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %acc, i8 %$3)
  %texp = alloca %struct.Texp
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp, %struct.String* %acc)
  %$5 = load %struct.Texp, %struct.Texp* %texp
  ret %struct.Texp %$5
}

define %struct.Texp @Parser$ptr.atom(%struct.Parser* %this) {
entry:
  call void (%struct.Parser*) @Parser$ptr.add-value-coord(%struct.Parser* %this)
  %QUOTE = add i8 34, 0
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$1 = call i8 (%struct.Reader*) @Reader$ptr.peek(%struct.Reader* %$2)
  %$0 = icmp eq i8 %QUOTE, %$1
  br i1 %$0, label %then0, label %post0
then0:
  %$3 = call %struct.Texp (%struct.Parser*) @Parser$ptr.string(%struct.Parser* %this)
  ret %struct.Texp %$3
  br label %post0
post0:
  %texp = alloca %struct.Texp
  %word = alloca %struct.String
  %$4 = call %struct.String (%struct.Parser*) @Parser$ptr.word(%struct.Parser* %this)
  store %struct.String %$4, %struct.String* %word
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %texp, %struct.String* %word)
  %$5 = load %struct.Texp, %struct.Texp* %texp
  ret %struct.Texp %$5
}

define void @Parser$ptr.list_(%struct.Parser* %this, %struct.Texp* %acc) {
entry:
  %RPAREN = add i8 41, 0
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$1 = call i8 (%struct.Reader*) @Reader$ptr.peek(%struct.Reader* %$2)
  %$0 = icmp ne i8 %RPAREN, %$1
  br i1 %$0, label %then0, label %post0
then0:
  %texp = alloca %struct.Texp
  %$3 = call %struct.Texp (%struct.Parser*) @Parser$ptr.texp(%struct.Parser* %this)
  store %struct.Texp %$3, %struct.Texp* %texp
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %acc, %struct.Texp* %texp)
  call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %this)
  call void (%struct.Parser*, %struct.Texp*) @Parser$ptr.list_(%struct.Parser* %this, %struct.Texp* %acc)
  br label %post0
post0:
  ret void
}

define %struct.Texp @Parser$ptr.list(%struct.Parser* %this) {
entry:
  call void (%struct.Parser*) @Parser$ptr.add-open-coord(%struct.Parser* %this)
  %$0 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %$0)
  call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %this)
  call void (%struct.Parser*) @Parser$ptr.add-value-coord(%struct.Parser* %this)
  %curr = alloca %struct.Texp
  %word = alloca %struct.String
  %$1 = call %struct.String (%struct.Parser*) @Parser$ptr.word(%struct.Parser* %this)
  store %struct.String %$1, %struct.String* %word
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %curr, %struct.String* %word)
  call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %this)
  call void (%struct.Parser*, %struct.Texp*) @Parser$ptr.list_(%struct.Parser* %this, %struct.Texp* %curr)
  call void (%struct.Parser*) @Parser$ptr.add-close-coord(%struct.Parser* %this)
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %$2)
  %$3 = load %struct.Texp, %struct.Texp* %curr
  ret %struct.Texp %$3
}

define %struct.Texp @Parser$ptr.texp(%struct.Parser* %this) {
entry:
  %LPAREN = add i8 40, 0
  call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %this)
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$1 = call i8 (%struct.Reader*) @Reader$ptr.peek(%struct.Reader* %$2)
  %$0 = icmp eq i8 %LPAREN, %$1
  br i1 %$0, label %then0, label %post0
then0:
  %$3 = call %struct.Texp (%struct.Parser*) @Parser$ptr.list(%struct.Parser* %this)
  ret %struct.Texp %$3
  br label %post0
post0:
  %$4 = call %struct.Texp (%struct.Parser*) @Parser$ptr.atom(%struct.Parser* %this)
  ret %struct.Texp %$4
}

define void @Parser$ptr.collect(%struct.Parser* %this, %struct.Texp* %parent) {
entry:
  %$1 = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %$0 = call i1 (%struct.Reader*) @Reader$ptr.done(%struct.Reader* %$1)
  br i1 %$0, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %child = alloca %struct.Texp
  %$2 = call %struct.Texp (%struct.Parser*) @Parser$ptr.texp(%struct.Parser* %this)
  store %struct.Texp %$2, %struct.Texp* %child
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %parent, %struct.Texp* %child)
  call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %this)
  call void (%struct.Parser*, %struct.Texp*) @Parser$ptr.collect(%struct.Parser* %this, %struct.Texp* %parent)
  ret void
}

define void @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 %state) {
entry:
  %NEWLINE = add i8 10, 0
  %SPACE = add i8 32, 0
  %QUOTE = add i8 34, 0
  %SEMICOLON = add i8 59, 0
  %BACKSLASH = add i8 92, 0
  %COMMENT_STATE = sub i8 0, 1
  %START_STATE = add i8 0, 0
  %STRING_STATE = add i8 1, 0
  %CHAR_STATE = add i8 2, 0
  %reader = getelementptr inbounds %struct.Parser, %struct.Parser* %this, i32 0, i32 0
  %done = call i1 (%struct.Reader*) @Reader$ptr.done(%struct.Reader* %reader)
  br i1 %done, label %then0, label %post0
then0:
  call void (%struct.Reader*) @Reader$ptr.reset(%struct.Reader* %reader)
  ret void
  br label %post0
post0:
  %c = call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %reader)
  %$0 = icmp eq i8 %COMMENT_STATE, %state
  br i1 %$0, label %then1, label %post1
then1:
  %$1 = icmp eq i8 %NEWLINE, %c
  br i1 %$1, label %then2, label %post2
then2:
  tail call void (%struct.Parser*, i8) @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 %START_STATE)
  ret void
  br label %post2
post2:
  %$6 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 1
  %$5 = load i8*, i8** %$6
  %$4 = ptrtoint i8* %$5 to i64
  %$3 = sub i64 %$4, 1
  %$2 = inttoptr i64 %$3 to i8*
  store i8 %SPACE, i8* %$2
  tail call void (%struct.Parser*, i8) @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 %state)
  ret void
  br label %post1
post1:
  %$7 = icmp eq i8 %START_STATE, %state
  br i1 %$7, label %then3, label %post3
then3:
  %$8 = icmp eq i8 %QUOTE, %c
  br i1 %$8, label %then4, label %post4
then4:
  tail call void (%struct.Parser*, i8) @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 %STRING_STATE)
  ret void
  br label %post4
post4:
  %$9 = icmp eq i8 %SEMICOLON, %c
  br i1 %$9, label %then5, label %post5
then5:
  call void (%struct.Parser*) @Parser$ptr.add-comment-coord(%struct.Parser* %this)
  %$14 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 1
  %$13 = load i8*, i8** %$14
  %$12 = ptrtoint i8* %$13 to i64
  %$11 = sub i64 %$12, 1
  %$10 = inttoptr i64 %$11 to i8*
  store i8 %SPACE, i8* %$10
  tail call void (%struct.Parser*, i8) @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 %COMMENT_STATE)
  ret void
  br label %post5
post5:
  tail call void (%struct.Parser*, i8) @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 %state)
  ret void
  br label %post3
post3:
  %$15 = icmp eq i8 %STRING_STATE, %state
  br i1 %$15, label %then6, label %post6
then6:
  %$16 = icmp eq i8 %QUOTE, %c
  br i1 %$16, label %then7, label %post7
then7:
  %$17 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 2
  %prev = load i8, i8* %$17
  %$18 = icmp ne i8 %BACKSLASH, %prev
  br i1 %$18, label %then8, label %post8
then8:
  tail call void (%struct.Parser*, i8) @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 %START_STATE)
  ret void
  br label %post8
post8:
  br label %post7
post7:
  tail call void (%struct.Parser*, i8) @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 %state)
  ret void
  br label %post6
post6:
  ret void
}

define void @Parser$ptr.remove-comments(%struct.Parser* %this) {
entry:
  call void (%struct.Parser*, i8) @Parser$ptr.remove-comments_(%struct.Parser* %this, i8 0)
  ret void
}

define %struct.Texp @Parser.parse-file.intro(%struct.StringView* %filename, %struct.File* %file, %struct.StringView* %content, %struct.Parser* %parser) {
entry:
  %$0 = call %struct.File (%struct.StringView*) @File.openrw(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %$1 = call %struct.StringView (%struct.File*) @File$ptr.readwrite(%struct.File* %file)
  store %struct.StringView %$1, %struct.StringView* %content
  %$2 = call %struct.Parser (%struct.StringView*) @Parser.make(%struct.StringView* %content)
  store %struct.Parser %$2, %struct.Parser* %parser
  %$3 = load %struct.StringView, %struct.StringView* %filename
  %$4 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 4
  store %struct.StringView %$3, %struct.StringView* %$4
  call void (%struct.Parser*) @Parser$ptr.remove-comments(%struct.Parser* %parser)
  %prog = alloca %struct.Texp
  %filename-string = alloca %struct.String
  %$5 = call %struct.String (%struct.StringView*) @String.makeFromStringView(%struct.StringView* %filename)
  store %struct.String %$5, %struct.String* %filename-string
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %prog, %struct.String* %filename-string)
  call void (%struct.Parser*, %struct.Texp*) @Parser$ptr.collect(%struct.Parser* %parser, %struct.Texp* %prog)
  %$6 = load %struct.Texp, %struct.Texp* %prog
  ret %struct.Texp %$6
}

define void @Parser.parse-file.outro(%struct.File* %file, %struct.StringView* %content, %struct.Parser* %parser) {
entry:
  call void (%struct.Parser*) @Parser$ptr.unmake(%struct.Parser* %parser)
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define %struct.Texp @Parser.parse-file(%struct.StringView* %filename) {
entry:
  %file = alloca %struct.File
  %content = alloca %struct.StringView
  %parser = alloca %struct.Parser
  %prog = call %struct.Texp (%struct.StringView*, %struct.File*, %struct.StringView*, %struct.Parser*) @Parser.parse-file.intro(%struct.StringView* %filename, %struct.File* %file, %struct.StringView* %content, %struct.Parser* %parser)
  call void (%struct.File*, %struct.StringView*, %struct.Parser*) @Parser.parse-file.outro(%struct.File* %file, %struct.StringView* %content, %struct.Parser* %parser)
  ret %struct.Texp %prog
}

define %struct.Texp @Parser.parse-file-i8$ptr(i8* %filename) {
entry:
  %fn-view = alloca %struct.StringView
  %$0 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* %filename)
  store %struct.StringView %$0, %struct.StringView* %fn-view
  %$1 = call %struct.Texp (%struct.StringView*) @Parser.parse-file(%struct.StringView* %fn-view)
  ret %struct.Texp %$1
}

define void @test.parser-whitespace() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @str.77, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %content = alloca %struct.StringView
  %$1 = call %struct.StringView (%struct.File*) @File$ptr.read(%struct.File* %file)
  store %struct.StringView %$1, %struct.StringView* %content
  %parser = alloca %struct.Parser
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$2, %struct.StringView* %content)
  %$5 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$4 = getelementptr inbounds %struct.Reader, %struct.Reader* %$5, i32 0, i32 1
  %$3 = load i8*, i8** %$4
  call i32 (i8*) @puts(i8* %$3)
  call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %parser)
  %$8 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$7 = getelementptr inbounds %struct.Reader, %struct.Reader* %$8, i32 0, i32 1
  %$6 = load i8*, i8** %$7
  call i32 (i8*) @puts(i8* %$6)
  call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %parser)
  %$11 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$10 = getelementptr inbounds %struct.Reader, %struct.Reader* %$11, i32 0, i32 1
  %$9 = load i8*, i8** %$10
  call i32 (i8*) @puts(i8* %$9)
  %$12 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  call i8 (%struct.Reader*) @Reader$ptr.get(%struct.Reader* %$12)
  %$15 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$14 = getelementptr inbounds %struct.Reader, %struct.Reader* %$15, i32 0, i32 1
  %$13 = load i8*, i8** %$14
  call i32 (i8*) @puts(i8* %$13)
  call void (%struct.Parser*) @Parser$ptr.whitespace(%struct.Parser* %parser)
  %$18 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$17 = getelementptr inbounds %struct.Reader, %struct.Reader* %$18, i32 0, i32 1
  %$16 = load i8*, i8** %$17
  call i32 (i8*) @puts(i8* %$16)
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @test.parser-atom() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.78, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %content = alloca %struct.StringView
  %$1 = call %struct.StringView (%struct.File*) @File$ptr.read(%struct.File* %file)
  store %struct.StringView %$1, %struct.StringView* %content
  %parser = alloca %struct.Parser
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$2, %struct.StringView* %content)
  %$5 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$4 = getelementptr inbounds %struct.Reader, %struct.Reader* %$5, i32 0, i32 1
  %$3 = load i8*, i8** %$4
  call i32 (i8*) @puts(i8* %$3)
  %texp = alloca %struct.Texp
  %$6 = call %struct.Texp (%struct.Parser*) @Parser$ptr.atom(%struct.Parser* %parser)
  store %struct.Texp %$6, %struct.Texp* %texp
  %$9 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$8 = getelementptr inbounds %struct.Reader, %struct.Reader* %$9, i32 0, i32 1
  %$7 = load i8*, i8** %$8
  call i32 (i8*) @puts(i8* %$7)
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void () @println()
  %texp2 = alloca %struct.Texp
  %$10 = call %struct.Texp (%struct.Parser*) @Parser$ptr.atom(%struct.Parser* %parser)
  store %struct.Texp %$10, %struct.Texp* %texp2
  %$13 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$12 = getelementptr inbounds %struct.Reader, %struct.Reader* %$13, i32 0, i32 1
  %$11 = load i8*, i8** %$12
  call i32 (i8*) @puts(i8* %$11)
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp2)
  call void () @println()
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @test.parser-texp() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.79, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %content = alloca %struct.StringView
  %$1 = call %struct.StringView (%struct.File*) @File$ptr.read(%struct.File* %file)
  store %struct.StringView %$1, %struct.StringView* %content
  %parser = alloca %struct.Parser
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$2, %struct.StringView* %content)
  %$5 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$4 = getelementptr inbounds %struct.Reader, %struct.Reader* %$5, i32 0, i32 1
  %$3 = load i8*, i8** %$4
  call i32 (i8*) @puts(i8* %$3)
  %texp = alloca %struct.Texp
  %$6 = call %struct.Texp (%struct.Parser*) @Parser$ptr.texp(%struct.Parser* %parser)
  store %struct.Texp %$6, %struct.Texp* %texp
  %$9 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$8 = getelementptr inbounds %struct.Reader, %struct.Reader* %$9, i32 0, i32 1
  %$7 = load i8*, i8** %$8
  call i32 (i8*) @puts(i8* %$7)
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void () @println()
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @test.parser-string() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @str.80, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %content = alloca %struct.StringView
  %$1 = call %struct.StringView (%struct.File*) @File$ptr.read(%struct.File* %file)
  store %struct.StringView %$1, %struct.StringView* %content
  %parser = alloca %struct.Parser
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$2, %struct.StringView* %content)
  %$5 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$4 = getelementptr inbounds %struct.Reader, %struct.Reader* %$5, i32 0, i32 1
  %$3 = load i8*, i8** %$4
  call i32 (i8*) @puts(i8* %$3)
  %texp = alloca %struct.Texp
  %$6 = call %struct.Texp (%struct.Parser*) @Parser$ptr.texp(%struct.Parser* %parser)
  store %struct.Texp %$6, %struct.Texp* %texp
  %$9 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$8 = getelementptr inbounds %struct.Reader, %struct.Reader* %$9, i32 0, i32 1
  %$7 = load i8*, i8** %$8
  call i32 (i8*) @puts(i8* %$7)
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void () @println()
  %$11 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 2
  %$10 = load i64, i64* %$11
  call void (i64) @u64.print(i64 %$10)
  call void () @println()
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @test.parser-comments() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.81, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.openrw(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %content = alloca %struct.StringView
  %$1 = call %struct.StringView (%struct.File*) @File$ptr.readwrite(%struct.File* %file)
  store %struct.StringView %$1, %struct.StringView* %content
  %parser = alloca %struct.Parser
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$2, %struct.StringView* %content)
  call void (%struct.Parser*) @Parser$ptr.remove-comments(%struct.Parser* %parser)
  %$5 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  %$4 = getelementptr inbounds %struct.Reader, %struct.Reader* %$5, i32 0, i32 1
  %$3 = load i8*, i8** %$4
  call i32 (i8*) @puts(i8* %$3)
  %texp = alloca %struct.Texp
  %$6 = call %struct.Texp (%struct.Parser*) @Parser$ptr.texp(%struct.Parser* %parser)
  store %struct.Texp %$6, %struct.Texp* %texp
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void () @println()
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @test.parser-file() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.82, i64 0, i64 0))
  %file = alloca %struct.File
  %$0 = call %struct.File (%struct.StringView*) @File.openrw(%struct.StringView* %filename)
  store %struct.File %$0, %struct.File* %file
  %content = alloca %struct.StringView
  %$1 = call %struct.StringView (%struct.File*) @File$ptr.readwrite(%struct.File* %file)
  store %struct.StringView %$1, %struct.StringView* %content
  %parser = alloca %struct.Parser
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 0
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$2, %struct.StringView* %content)
  call void (%struct.Parser*) @Parser$ptr.remove-comments(%struct.Parser* %parser)
  %prog = alloca %struct.Texp
  %filename-string = alloca %struct.String
  %$3 = call %struct.String (%struct.StringView*) @String.makeFromStringView(%struct.StringView* %filename)
  store %struct.String %$3, %struct.String* %filename-string
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %prog, %struct.String* %filename-string)
  call void (%struct.Parser*, %struct.Texp*) @Parser$ptr.collect(%struct.Parser* %parser, %struct.Texp* %prog)
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %prog)
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret void
}

define void @Texp$ptr.pretty-print$lambda.do(%struct.Texp* %this) {
entry:
  ret void
}

define void @Texp$ptr.pretty-print$lambda.toplevel(%struct.Texp* %this, %struct.Texp* %last) {
entry:
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %this)
  call void () @println()
  %$0 = icmp ne %struct.Texp* %this, %last
  br i1 %$0, label %then0, label %post0
then0:
  %$2 = ptrtoint %struct.Texp* %this to i64
  %$1 = add i64 40, %$2
  %next = inttoptr i64 %$1 to %struct.Texp*
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.pretty-print$lambda.toplevel(%struct.Texp* %next, %struct.Texp* %last)
  br label %post0
post0:
  ret void
}

define void @Texp$ptr.pretty-print(%struct.Texp* %this) {
entry:
  %LPAREN = add i8 40, 0
  %RPAREN = add i8 41, 0
  call void (i8) @i8.print(i8 %LPAREN)
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 0
  call void (%struct.String*) @String$ptr.println(%struct.String* %$0)
  %last = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %this)
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %this, i32 0, i32 1
  %first-child = load %struct.Texp*, %struct.Texp** %$1
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.pretty-print$lambda.toplevel(%struct.Texp* %first-child, %struct.Texp* %last)
  call void (i8) @i8.print(i8 %RPAREN)
  call void () @println()
  ret void
}

define void @test.texp-pretty-print() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.83, i64 0, i64 0))
  %prog = alloca %struct.Texp
  %$0 = call %struct.Texp (%struct.StringView*) @Parser.parse-file(%struct.StringView* %filename)
  store %struct.Texp %$0, %struct.Texp* %prog
  call void (%struct.Texp*) @Texp$ptr.pretty-print(%struct.Texp* %prog)
  ret void
}

%struct.Grammar = type { %struct.Texp };
define %struct.Grammar @Grammar.make(%struct.Texp %texp) {
entry:
  %grammar = alloca %struct.Grammar
  %$0 = getelementptr inbounds %struct.Grammar, %struct.Grammar* %grammar, i32 0, i32 0
  store %struct.Texp %texp, %struct.Texp* %$0
  %$1 = getelementptr inbounds %struct.Grammar, %struct.Grammar* %grammar, i32 0, i32 0
  call void (%struct.Texp*) @Texp$ptr.demote-free(%struct.Texp* %$1)
  %$2 = load %struct.Grammar, %struct.Grammar* %grammar
  ret %struct.Grammar %$2
}

define %struct.Texp* @Grammar$ptr.getProduction(%struct.Grammar* %this, %struct.StringView* %type-name) {
entry:
  %$0 = getelementptr inbounds %struct.Grammar, %struct.Grammar* %this, i32 0, i32 0
  %maybe-prod = call %struct.Texp* (%struct.Texp*, %struct.StringView*) @Texp$ptr.find(%struct.Texp* %$0, %struct.StringView* %type-name)
  %$2 = ptrtoint %struct.Texp* %maybe-prod to i64
  %$1 = icmp eq i64 0, %$2
  br i1 %$1, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.84, i64 0, i64 0))
  call void (%struct.StringView*) @StringView$ptr.print(%struct.StringView* %type-name)
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.85, i64 0, i64 0))
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  ret %struct.Texp* %maybe-prod
}

define %struct.Texp @Grammar$ptr.get-keyword(%struct.Grammar* %this, %struct.StringView* %type-name) {
entry:
  %prod = call %struct.Texp* (%struct.Grammar*, %struct.StringView*) @Grammar$ptr.getProduction(%struct.Grammar* %this, %struct.StringView* %type-name)
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  %$1 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %rule, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.86, i64 0, i64 0))
  br i1 %$1, label %then0, label %post0
then0:
  %$2 = call %struct.Texp () @Optional.none()
  ret %struct.Texp %$2
  br label %post0
post0:
  %rule-value = getelementptr inbounds %struct.Texp, %struct.Texp* %rule, i32 0, i32 0
  %$3 = call i1 (%struct.String*) @String$ptr.is-empty(%struct.String* %rule-value)
  br i1 %$3, label %then1, label %post1
then1:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @str.87, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule)
  call void (i32) @exit(i32 1)
  br label %post1
post1:
  %HASH = add i8 35, 0
  %$5 = call i8 (%struct.String*, i64) @String$ptr.char-at-unsafe(%struct.String* %rule-value, i64 0)
  %$4 = icmp eq i8 %HASH, %$5
  br i1 %$4, label %then2, label %post2
then2:
  %$6 = call %struct.Texp () @Optional.none()
  ret %struct.Texp %$6
  br label %post2
post2:
  %$7 = call %struct.Texp (%struct.String*) @Texp.makeFromString(%struct.String* %rule-value)
  ret %struct.Texp %$7
}

%struct.Matcher = type { %struct.Grammar };
define %struct.Texp @Matcher$ptr.is(%struct.Matcher* %this, %struct.Texp* %texp, %struct.StringView* %type-name) {
entry:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.88, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.89, i64 0, i64 0))
  call void (%struct.StringView*) @StringView$ptr.print(%struct.StringView* %type-name)
  %grammar = getelementptr inbounds %struct.Matcher, %struct.Matcher* %this, i32 0, i32 0
  %prod = call %struct.Texp* (%struct.Grammar*, %struct.StringView*) @Grammar$ptr.getProduction(%struct.Grammar* %grammar, %struct.StringView* %type-name)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.90, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %prod)
  call void () @println()
  %result = alloca %struct.Texp
  %$0 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.Texp*) @Matcher$ptr.match(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod)
  store %struct.Texp %$0, %struct.Texp* %result
  %$1 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %result, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.91, i64 0, i64 0))
  br i1 %$1, label %then0, label %post0
then0:
  %$2 = getelementptr inbounds %struct.Texp, %struct.Texp* %result, i32 0, i32 1
  %child = load %struct.Texp*, %struct.Texp** %$2
  %proof-value = getelementptr inbounds %struct.Texp, %struct.Texp* %child, i32 0, i32 0
  %new-proof-value = alloca %struct.String
  %$3 = call %struct.String (%struct.StringView*) @String.makeFromStringView(%struct.StringView* %type-name)
  store %struct.String %$3, %struct.String* %new-proof-value
  %FORWARD_SLASH = add i8 47, 0
  call void (%struct.String*, i8) @String$ptr.pushChar(%struct.String* %new-proof-value, i8 %FORWARD_SLASH)
  call void (%struct.String*, %struct.String*) @String$ptr.append(%struct.String* %new-proof-value, %struct.String* %proof-value)
  call void (%struct.String*) @String$ptr.free(%struct.String* %proof-value)
  %$4 = load %struct.String, %struct.String* %new-proof-value
  store %struct.String %$4, %struct.String* %proof-value
  br label %post0
post0:
  %$5 = load %struct.Texp, %struct.Texp* %result
  ret %struct.Texp %$5
}

define %struct.Texp @Matcher$ptr.atom(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod) {
entry:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.92, i64 0, i64 0))
  %$2 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 2
  %$1 = load i64, i64* %$2
  %$0 = icmp ne i64 0, %$1
  br i1 %$0, label %then0, label %post0
then0:
  %error-result = alloca %struct.Texp
  %$3 = call %struct.Texp (i8*) @Result.error-from-i8$ptr(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.93, i64 0, i64 0))
  store %struct.Texp %$3, %struct.Texp* %error-result
  %$4 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %prod)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %error-result, %struct.Texp %$4)
  %$5 = load %struct.Texp, %struct.Texp* %error-result
  ret %struct.Texp %$5
  br label %post0
post0:
  %$6 = call %struct.Texp (i8*) @Result.success-from-i8$ptr(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.94, i64 0, i64 0))
  ret %struct.Texp %$6
}

define %struct.Texp @Matcher$ptr.match(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %rule, i32 0, i32 2
  %rule-length = load i64, i64* %$1
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.95, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule)
  %$2 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %rule, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.96, i64 0, i64 0))
  br i1 %$2, label %then0, label %post0
then0:
  call void () @println()
  %$3 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.Texp*) @Matcher$ptr.choice(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod)
  ret %struct.Texp %$3
  br label %post0
post0:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.97, i64 0, i64 0))
  call void (i64) @u64.print(i64 %rule-length)
  call void () @println()
  %value-result = alloca %struct.Texp
  %$4 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.Texp*) @Matcher$ptr.value(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod)
  store %struct.Texp %$4, %struct.Texp* %value-result
  %$5 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %value-result, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.98, i64 0, i64 0))
  br i1 %$5, label %then1, label %post1
then1:
  %$6 = load %struct.Texp, %struct.Texp* %value-result
  ret %struct.Texp %$6
  br label %post1
post1:
  %$7 = icmp ne i64 %rule-length, 0
  br i1 %$7, label %then2, label %post2
then2:
  %last = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %rule)
  %$8 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %last, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.99, i64 0, i64 0))
  br i1 %$8, label %then3, label %post3
then3:
  %$9 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.Texp*) @Matcher$ptr.kleene(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod)
  ret %struct.Texp %$9
  br label %post3
post3:
  %$10 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.Texp*) @Matcher$ptr.exact(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod)
  ret %struct.Texp %$10
  br label %post2
post2:
  %$11 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.Texp*) @Matcher$ptr.atom(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod)
  ret %struct.Texp %$11
}

define void @Matcher$ptr.kleene-seq(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %acc, i64 %curr-index, i64 %last-index) {
entry:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.100, i64 0, i64 0))
  call void (i64) @u64.print(i64 %curr-index)
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  %last = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %rule)
  %texp-child = call %struct.Texp* (%struct.Texp*, i64) @Texp$ptr.child(%struct.Texp* %texp, i64 %curr-index)
  %rule-child = call %struct.Texp* (%struct.Texp*, i64) @Texp$ptr.child(%struct.Texp* %rule, i64 %curr-index)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.101, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp-child)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.102, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule-child)
  call void () @println()
  %result = alloca %struct.Texp
  %$2 = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %rule-child)
  %$1 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %this, %struct.Texp* %texp-child, %struct.StringView* %$2)
  store %struct.Texp %$1, %struct.Texp* %result
  %$3 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %result, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.103, i64 0, i64 0))
  br i1 %$3, label %then0, label %post0
then0:
  call void (%struct.Texp*) @Texp$ptr.free(%struct.Texp* %acc)
  %$4 = load %struct.Texp, %struct.Texp* %result
  store %struct.Texp %$4, %struct.Texp* %acc
  ret void
  br label %post0
post0:
  call void (%struct.Texp*) @Texp$ptr.demote-free(%struct.Texp* %result)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %acc, %struct.Texp* %result)
  %$5 = icmp eq i64 %curr-index, %last-index
  br i1 %$5, label %then1, label %post1
then1:
  ret void
  br label %post1
post1:
  %next-index = add i64 1, %curr-index
  call void (%struct.Matcher*, %struct.Texp*, %struct.Texp*, %struct.Texp*, i64, i64) @Matcher$ptr.kleene-seq(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %acc, i64 %next-index, i64 %last-index)
  ret void
}

define void @Matcher$ptr.kleene-many(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %acc, i64 %curr-index, i64 %last-index) {
entry:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.104, i64 0, i64 0))
  call void (i64) @u64.print(i64 %curr-index)
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  %last = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %rule)
  %texp-child = call %struct.Texp* (%struct.Texp*, i64) @Texp$ptr.child(%struct.Texp* %texp, i64 %curr-index)
  %rule-child = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %last)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.105, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp-child)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.106, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule-child)
  call void () @println()
  %result = alloca %struct.Texp
  %$2 = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %rule-child)
  %$1 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %this, %struct.Texp* %texp-child, %struct.StringView* %$2)
  store %struct.Texp %$1, %struct.Texp* %result
  %$3 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %result, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.107, i64 0, i64 0))
  br i1 %$3, label %then0, label %post0
then0:
  call void (%struct.Texp*) @Texp$ptr.free(%struct.Texp* %acc)
  %$4 = load %struct.Texp, %struct.Texp* %result
  store %struct.Texp %$4, %struct.Texp* %acc
  ret void
  br label %post0
post0:
  call void (%struct.Texp*) @Texp$ptr.demote-free(%struct.Texp* %result)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %acc, %struct.Texp* %result)
  %$5 = icmp eq i64 %curr-index, %last-index
  br i1 %$5, label %then1, label %post1
then1:
  ret void
  br label %post1
post1:
  %next-index = add i64 1, %curr-index
  call void (%struct.Matcher*, %struct.Texp*, %struct.Texp*, %struct.Texp*, i64, i64) @Matcher$ptr.kleene-many(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %acc, i64 %next-index, i64 %last-index)
  ret void
}

define %struct.Texp @Matcher$ptr.kleene(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @str.108, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.109, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule)
  call void () @println()
  %last = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %rule)
  %$1 = getelementptr inbounds %struct.Texp, %struct.Texp* %last, i32 0, i32 0
  %kleene-prod-view = call %struct.StringView (%struct.String*) @String$ptr.view(%struct.String* %$1)
  %$2 = getelementptr inbounds %struct.Texp, %struct.Texp* %rule, i32 0, i32 2
  %rule-length = load i64, i64* %$2
  %$3 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 2
  %texp-length = load i64, i64* %$3
  %proof = alloca %struct.Texp
  %$4 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.110, i64 0, i64 0))
  store %struct.Texp %$4, %struct.Texp* %proof
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @str.111, i64 0, i64 0))
  call void (i64) @u64.print(i64 %rule-length)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.112, i64 0, i64 0))
  call void (i64) @u64.print(i64 %texp-length)
  call void () @println()
  %seq-length = sub i64 %rule-length, 1
  %last-texp-i = sub i64 %texp-length, 1
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([32 x i8], [32 x i8]* @str.113, i64 0, i64 0))
  call void (i64) @u64.print(i64 %seq-length)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.114, i64 0, i64 0))
  call void (i64) @u64.print(i64 %last-texp-i)
  call void () @println()
  %$5 = icmp ult i64 %texp-length, %seq-length
  br i1 %$5, label %then0, label %post0
then0:
  %failure-result = alloca %struct.Texp
  %$6 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.115, i64 0, i64 0))
  store %struct.Texp %$6, %struct.Texp* %failure-result
  %$7 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @str.116, i64 0, i64 0))
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %failure-result, %struct.Texp %$7)
  %$8 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %rule)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %failure-result, %struct.Texp %$8)
  %$9 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %failure-result, %struct.Texp %$9)
  %$10 = load %struct.Texp, %struct.Texp* %failure-result
  ret %struct.Texp %$10
  br label %post0
post0:
  %$11 = icmp ne i64 0, %seq-length
  br i1 %$11, label %then1, label %post1
then1:
  %$12 = sub i64 %seq-length, 1
  call void (%struct.Matcher*, %struct.Texp*, %struct.Texp*, %struct.Texp*, i64, i64) @Matcher$ptr.kleene-seq(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %proof, i64 0, i64 %$12)
  %$13 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %proof, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.117, i64 0, i64 0))
  br i1 %$13, label %then2, label %post2
then2:
  %$14 = load %struct.Texp, %struct.Texp* %proof
  ret %struct.Texp %$14
  br label %post2
post2:
  br label %post1
post1:
  %$15 = icmp ne i64 %seq-length, %texp-length
  br i1 %$15, label %then3, label %post3
then3:
  %$16 = sub i64 %texp-length, 1
  call void (%struct.Matcher*, %struct.Texp*, %struct.Texp*, %struct.Texp*, i64, i64) @Matcher$ptr.kleene-many(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %proof, i64 %seq-length, i64 %$16)
  %$17 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %proof, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.118, i64 0, i64 0))
  br i1 %$17, label %then4, label %post4
then4:
  %$18 = load %struct.Texp, %struct.Texp* %proof
  ret %struct.Texp %$18
  br label %post4
post4:
  br label %post3
post3:
  %$19 = call %struct.Texp (%struct.Texp*) @Result.success(%struct.Texp* %proof)
  ret %struct.Texp %$19
}

define void @Matcher$ptr.exact_(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %acc, i64 %curr-index, i64 %last-index) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  %texp-child = call %struct.Texp* (%struct.Texp*, i64) @Texp$ptr.child(%struct.Texp* %texp, i64 %curr-index)
  %rule-child = call %struct.Texp* (%struct.Texp*, i64) @Texp$ptr.child(%struct.Texp* %rule, i64 %curr-index)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.119, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp-child)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.120, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule-child)
  call void () @println()
  %result = alloca %struct.Texp
  %$2 = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %rule-child)
  %$1 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %this, %struct.Texp* %texp-child, %struct.StringView* %$2)
  store %struct.Texp %$1, %struct.Texp* %result
  %$3 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %result, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.121, i64 0, i64 0))
  br i1 %$3, label %then0, label %post0
then0:
  call void (%struct.Texp*) @Texp$ptr.free(%struct.Texp* %acc)
  %$4 = load %struct.Texp, %struct.Texp* %result
  store %struct.Texp %$4, %struct.Texp* %acc
  ret void
  br label %post0
post0:
  call void (%struct.Texp*) @Texp$ptr.demote-free(%struct.Texp* %result)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %acc, %struct.Texp* %result)
  %$5 = icmp eq i64 %curr-index, %last-index
  br i1 %$5, label %then1, label %post1
then1:
  ret void
  br label %post1
post1:
  %next-index = add i64 1, %curr-index
  call void (%struct.Matcher*, %struct.Texp*, %struct.Texp*, %struct.Texp*, i64, i64) @Matcher$ptr.exact_(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %acc, i64 %next-index, i64 %last-index)
  ret void
}

define %struct.Texp @Matcher$ptr.exact(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  %$3 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 2
  %$2 = load i64, i64* %$3
  %$5 = getelementptr inbounds %struct.Texp, %struct.Texp* %rule, i32 0, i32 2
  %$4 = load i64, i64* %$5
  %$1 = icmp ne i64 %$2, %$4
  br i1 %$1, label %then0, label %post0
then0:
  %len-result = alloca %struct.Texp
  %$6 = call %struct.Texp (i8*) @Result.error-from-i8$ptr(i8* getelementptr inbounds ([47 x i8], [47 x i8]* @str.122, i64 0, i64 0))
  store %struct.Texp %$6, %struct.Texp* %len-result
  %$7 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %len-result, %struct.Texp %$7)
  %$8 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %rule)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %len-result, %struct.Texp %$8)
  %$9 = load %struct.Texp, %struct.Texp* %len-result
  ret %struct.Texp %$9
  br label %post0
post0:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.123, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.124, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule)
  call void () @println()
  %proof = alloca %struct.Texp
  %$10 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.125, i64 0, i64 0))
  store %struct.Texp %$10, %struct.Texp* %proof
  %$12 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 2
  %$11 = load i64, i64* %$12
  %last = sub i64 %$11, 1
  call void (%struct.Matcher*, %struct.Texp*, %struct.Texp*, %struct.Texp*, i64, i64) @Matcher$ptr.exact_(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, %struct.Texp* %proof, i64 0, i64 %last)
  %proof-success-wrapper = alloca %struct.Texp
  %$13 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.126, i64 0, i64 0))
  store %struct.Texp %$13, %struct.Texp* %proof-success-wrapper
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %proof-success-wrapper, %struct.Texp* %proof)
  %$14 = load %struct.Texp, %struct.Texp* %proof-success-wrapper
  ret %struct.Texp %$14
}

define %struct.Texp @Matcher$ptr.choice_(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, i64 %i, %struct.Texp* %attempts) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  %rule-child = call %struct.Texp* (%struct.Texp*, i64) @Texp$ptr.child(%struct.Texp* %rule, i64 %i)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.127, i64 0, i64 0))
  call void (i64) @u64.print(i64 %i)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.128, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %texp)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.129, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule-child)
  call void () @println()
  %rule-child-view = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %rule-child)
  %is-result = alloca %struct.Texp
  %$1 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %this, %struct.Texp* %texp, %struct.StringView* %rule-child-view)
  store %struct.Texp %$1, %struct.Texp* %is-result
  %$2 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %is-result, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.130, i64 0, i64 0))
  br i1 %$2, label %then0, label %post0
then0:
  %$4 = getelementptr inbounds %struct.Texp, %struct.Texp* %is-result, i32 0, i32 1
  %$3 = load %struct.Texp*, %struct.Texp** %$4
  %proof-value-ref = getelementptr inbounds %struct.Texp, %struct.Texp* %$3, i32 0, i32 0
  %choice-marker = alloca %struct.String
  %$5 = call %struct.String (i8*) @String.makeFromi8$ptr(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.131, i64 0, i64 0))
  store %struct.String %$5, %struct.String* %choice-marker
  call void (%struct.String*, %struct.String*) @String$ptr.prepend(%struct.String* %proof-value-ref, %struct.String* %choice-marker)
  %$6 = load %struct.Texp, %struct.Texp* %is-result
  ret %struct.Texp %$6
  br label %post0
post0:
  %keyword-result = alloca %struct.Texp
  %$8 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %this, i32 0, i32 0
  %$7 = call %struct.Texp (%struct.Grammar*, %struct.StringView*) @Grammar$ptr.get-keyword(%struct.Grammar* %$8, %struct.StringView* %rule-child-view)
  store %struct.Texp %$7, %struct.Texp* %keyword-result
  %$10 = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %texp)
  %$11 = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %keyword-result)
  %$9 = call i1 (%struct.StringView*, %struct.StringView*) @StringView$ptr.eq(%struct.StringView* %$10, %struct.StringView* %$11)
  br i1 %$9, label %then1, label %post1
then1:
  %keyword-error-result = alloca %struct.Texp
  %$12 = call %struct.Texp (i8*) @Result.error-from-i8$ptr(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @str.132, i64 0, i64 0))
  store %struct.Texp %$12, %struct.Texp* %keyword-error-result
  %$13 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %prod)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %keyword-error-result, %struct.Texp %$13)
  %$14 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %keyword-error-result, %struct.Texp %$14)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %keyword-error-result, %struct.Texp* %is-result)
  %$15 = load %struct.Texp, %struct.Texp* %keyword-error-result
  ret %struct.Texp %$15
  br label %post1
post1:
  %$17 = getelementptr inbounds %struct.Texp, %struct.Texp* %rule, i32 0, i32 2
  %$16 = load i64, i64* %$17
  %last-rule-index = sub i64 %$16, 1
  %$18 = icmp eq i64 %i, %last-rule-index
  br i1 %$18, label %then2, label %post2
then2:
  %choice-match-error-result = alloca %struct.Texp
  %$19 = call %struct.Texp (i8*) @Result.error-from-i8$ptr(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.133, i64 0, i64 0))
  store %struct.Texp %$19, %struct.Texp* %choice-match-error-result
  %$20 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %prod)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %choice-match-error-result, %struct.Texp %$20)
  %$21 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %choice-match-error-result, %struct.Texp %$21)
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %choice-match-error-result, %struct.Texp* %attempts)
  %$22 = load %struct.Texp, %struct.Texp* %choice-match-error-result
  ret %struct.Texp %$22
  br label %post2
post2:
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %attempts, %struct.Texp* %is-result)
  %$24 = add i64 1, %i
  %$23 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.Texp*, i64, %struct.Texp*) @Matcher$ptr.choice_(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, i64 %$24, %struct.Texp* %attempts)
  ret %struct.Texp %$23
}

define %struct.Texp @Matcher$ptr.choice(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod) {
entry:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.134, i64 0, i64 0))
  %$0 = call %struct.Texp* (%struct.Texp*) @Texp$ptr.last(%struct.Texp* %prod)
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %$0)
  call void () @println()
  %proof = alloca %struct.Texp
  %$1 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.135, i64 0, i64 0))
  store %struct.Texp %$1, %struct.Texp* %proof
  %attempts = alloca %struct.Texp
  %$2 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.136, i64 0, i64 0))
  store %struct.Texp %$2, %struct.Texp* %attempts
  %$3 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.Texp*, i64, %struct.Texp*) @Matcher$ptr.choice_(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod, i64 0, %struct.Texp* %attempts)
  ret %struct.Texp %$3
}

define i1 @Matcher.regexInt_(i8* %curr, i64 %len) {
entry:
  %$0 = icmp eq i64 0, %len
  br i1 %$0, label %then0, label %post0
then0:
  ret i1 true
  br label %post0
post0:
  %ZERO = add i8 48, 0
  %$1 = load i8, i8* %curr
  %offset = sub i8 %$1, %ZERO
  %$2 = icmp slt i8 %offset, 0
  br i1 %$2, label %then1, label %post1
then1:
  ret i1 false
  br label %post1
post1:
  %$3 = icmp sge i8 %offset, 10
  br i1 %$3, label %then2, label %post2
then2:
  ret i1 false
  br label %post2
post2:
  %$7 = ptrtoint i8* %curr to i64
  %$6 = add i64 1, %$7
  %$5 = inttoptr i64 %$6 to i8*
  %$8 = sub i64 %len, 1
  %$4 = call i1 (i8*, i64) @Matcher.regexInt_(i8* %$5, i64 %$8)
  ret i1 %$4
}

define i1 @Matcher.regexInt(%struct.Texp* %texp) {
entry:
  %view = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %texp)
  %$2 = getelementptr inbounds %struct.StringView, %struct.StringView* %view, i32 0, i32 0
  %$1 = load i8*, i8** %$2
  %$4 = getelementptr inbounds %struct.StringView, %struct.StringView* %view, i32 0, i32 1
  %$3 = load i64, i64* %$4
  %$0 = call i1 (i8*, i64) @Matcher.regexInt_(i8* %$1, i64 %$3)
  ret i1 %$0
}

define i1 @Matcher.regexString_(i8* %curr, i64 %len) {
entry:
  ret i1 true
}

define i1 @Matcher.regexString(%struct.Texp* %texp) {
entry:
  %view = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %texp)
  %$0 = getelementptr inbounds %struct.StringView, %struct.StringView* %view, i32 0, i32 0
  %curr = load i8*, i8** %$0
  %$1 = getelementptr inbounds %struct.StringView, %struct.StringView* %view, i32 0, i32 1
  %len = load i64, i64* %$1
  %$2 = icmp ult i64 %len, 2
  br i1 %$2, label %then0, label %post0
then0:
  ret i1 false
  br label %post0
post0:
  %$4 = sub i64 %len, 1
  %$5 = ptrtoint i8* %curr to i64
  %$3 = add i64 %$4, %$5
  %last = inttoptr i64 %$3 to i8*
  %QUOTE = add i8 34, 0
  %$7 = load i8, i8* %curr
  %$6 = icmp ne i8 %QUOTE, %$7
  br i1 %$6, label %then1, label %post1
then1:
  ret i1 false
  br label %post1
post1:
  %$9 = load i8, i8* %last
  %$8 = icmp ne i8 %QUOTE, %$9
  br i1 %$8, label %then2, label %post2
then2:
  ret i1 false
  br label %post2
post2:
  %$11 = ptrtoint i8* %curr to i64
  %$10 = add i64 1, %$11
  %next = inttoptr i64 %$10 to i8*
  %$13 = sub i64 %len, 2
  %$12 = call i1 (i8*, i64) @Matcher.regexString_(i8* %next, i64 %$13)
  ret i1 %$12
}

define i1 @Matcher.regexBool(%struct.Texp* %texp) {
entry:
  %$0 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %texp, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.137, i64 0, i64 0))
  br i1 %$0, label %then0, label %post0
then0:
  ret i1 true
  br label %post0
post0:
  %$1 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %texp, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.138, i64 0, i64 0))
  br i1 %$1, label %then1, label %post1
then1:
  ret i1 true
  br label %post1
post1:
  ret i1 false
}

define %struct.Texp @Matcher$ptr.value(%struct.Matcher* %this, %struct.Texp* %texp, %struct.Texp* %prod) {
entry:
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %prod, i32 0, i32 1
  %rule = load %struct.Texp*, %struct.Texp** %$0
  %texp-value-view-ref = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %texp)
  %rule-value-view-ref = call %struct.StringView* (%struct.Texp*) @Texp$ptr.value-view(%struct.Texp* %rule)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.139, i64 0, i64 0))
  call void (%struct.StringView*) @StringView$ptr.print(%struct.StringView* %texp-value-view-ref)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.140, i64 0, i64 0))
  call void (%struct.StringView*) @StringView$ptr.print(%struct.StringView* %rule-value-view-ref)
  call void () @println()
  %rule-value-texp = alloca %struct.Texp
  %$1 = call %struct.Texp (%struct.StringView*) @Texp.makeFromStringView(%struct.StringView* %rule-value-view-ref)
  store %struct.Texp %$1, %struct.Texp* %rule-value-texp
  %texp-value-texp = alloca %struct.Texp
  %$2 = call %struct.Texp (%struct.StringView*) @Texp.makeFromStringView(%struct.StringView* %texp-value-view-ref)
  store %struct.Texp %$2, %struct.Texp* %texp-value-texp
  %default-success = call %struct.Texp (%struct.Texp*) @Result.success(%struct.Texp* %rule-value-texp)
  %HASH = add i8 35, 0
  %$3 = call i8 (%struct.Texp*, i64) @Texp$ptr.value-get(%struct.Texp* %rule, i64 0)
  %cond = icmp eq i8 %HASH, %$3
  %error-result = alloca %struct.Texp
  %$4 = call %struct.Texp () @Texp.makeEmpty()
  store %struct.Texp %$4, %struct.Texp* %error-result
  br i1 %cond, label %then0, label %post0
then0:
  %$5 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %rule, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.141, i64 0, i64 0))
  br i1 %$5, label %then1, label %post1
then1:
  %$6 = call i1 (%struct.Texp*) @Matcher.regexInt(%struct.Texp* %texp)
  br i1 %$6, label %then2, label %post2
then2:
  ret %struct.Texp %default-success
  br label %post2
post2:
  %$7 = call %struct.Texp (i8*) @Result.error-from-i8$ptr(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.142, i64 0, i64 0))
  store %struct.Texp %$7, %struct.Texp* %error-result
  br label %post1
post1:
  %$8 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %rule, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.143, i64 0, i64 0))
  br i1 %$8, label %then3, label %post3
then3:
  %$9 = call i1 (%struct.Texp*) @Matcher.regexString(%struct.Texp* %texp)
  br i1 %$9, label %then4, label %post4
then4:
  ret %struct.Texp %default-success
  br label %post4
post4:
  %$10 = call %struct.Texp (i8*) @Result.error-from-i8$ptr(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @str.144, i64 0, i64 0))
  store %struct.Texp %$10, %struct.Texp* %error-result
  br label %post3
post3:
  %$11 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %rule, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.145, i64 0, i64 0))
  br i1 %$11, label %then5, label %post5
then5:
  %$12 = call i1 (%struct.Texp*) @Matcher.regexBool(%struct.Texp* %texp)
  br i1 %$12, label %then6, label %post6
then6:
  ret %struct.Texp %default-success
  br label %post6
post6:
  %$13 = call %struct.Texp (i8*) @Result.error-from-i8$ptr(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str.146, i64 0, i64 0))
  store %struct.Texp %$13, %struct.Texp* %error-result
  br label %post5
post5:
  %$14 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %rule, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.147, i64 0, i64 0))
  br i1 %$14, label %then7, label %post7
then7:
  ret %struct.Texp %default-success
  br label %post7
post7:
  %$15 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %rule, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.148, i64 0, i64 0))
  br i1 %$15, label %then8, label %post8
then8:
  ret %struct.Texp %default-success
  br label %post8
post8:
  %$16 = call i1 (%struct.Texp*, i8*) @Texp$ptr.value-check(%struct.Texp* %error-result, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.149, i64 0, i64 0))
  br i1 %$16, label %then9, label %post9
then9:
  call void (%struct.Texp*, %struct.Texp*) @Texp$ptr.push$ptr(%struct.Texp* %error-result, %struct.Texp* %texp)
  %$17 = load %struct.Texp, %struct.Texp* %error-result
  ret %struct.Texp %$17
  br label %post9
post9:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.150, i64 0, i64 0))
  call void (%struct.StringView*) @StringView$ptr.print(%struct.StringView* %rule-value-view-ref)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.151, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %rule)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.152, i64 0, i64 0))
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %error-result)
  call void () @println()
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  %$18 = call i1 (%struct.StringView*, %struct.StringView*) @StringView$ptr.eq(%struct.StringView* %rule-value-view-ref, %struct.StringView* %texp-value-view-ref)
  br i1 %$18, label %then10, label %post10
then10:
  ret %struct.Texp %default-success
  br label %post10
post10:
  %keyword-match-error = alloca %struct.Texp
  %$19 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.153, i64 0, i64 0))
  store %struct.Texp %$19, %struct.Texp* %keyword-match-error
  %$20 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.154, i64 0, i64 0))
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %keyword-match-error, %struct.Texp %$20)
  %$21 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %rule-value-texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %keyword-match-error, %struct.Texp %$21)
  %$22 = call %struct.Texp (%struct.Texp*) @Texp$ptr.clone(%struct.Texp* %texp-value-texp)
  call void (%struct.Texp*, %struct.Texp) @Texp$ptr.push(%struct.Texp* %keyword-match-error, %struct.Texp %$22)
  %$23 = load %struct.Texp, %struct.Texp* %keyword-match-error
  ret %struct.Texp %$23
}

define void @test.matcher-simple() {
entry:
  %prog = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([56 x i8], [56 x i8]* @str.155, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %prog
  %matcher = alloca %struct.Matcher
  %$2 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([59 x i8], [59 x i8]* @str.156, i64 0, i64 0))
  %$1 = call %struct.Grammar (%struct.Texp) @Grammar.make(%struct.Texp %$2)
  %$3 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %matcher, i32 0, i32 0
  store %struct.Grammar %$1, %struct.Grammar* %$3
  %start-production = alloca %struct.StringView
  %$4 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.157, i64 0, i64 0))
  store %struct.StringView %$4, %struct.StringView* %start-production
  %result = alloca %struct.Texp
  %$5 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %matcher, %struct.Texp* %prog, %struct.StringView* %start-production)
  store %struct.Texp %$5, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
  ret void
}

define void @test.matcher-choice() {
entry:
  %prog = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([55 x i8], [55 x i8]* @str.158, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %prog
  %matcher = alloca %struct.Matcher
  %$2 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([58 x i8], [58 x i8]* @str.159, i64 0, i64 0))
  %$1 = call %struct.Grammar (%struct.Texp) @Grammar.make(%struct.Texp %$2)
  %$3 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %matcher, i32 0, i32 0
  store %struct.Grammar %$1, %struct.Grammar* %$3
  %start-production = alloca %struct.StringView
  %$4 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.160, i64 0, i64 0))
  store %struct.StringView %$4, %struct.StringView* %start-production
  %result = alloca %struct.Texp
  %$5 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %matcher, %struct.Texp* %prog, %struct.StringView* %start-production)
  store %struct.Texp %$5, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
  ret void
}

define void @test.matcher-kleene-seq() {
entry:
  %prog = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([59 x i8], [59 x i8]* @str.161, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %prog
  %matcher = alloca %struct.Matcher
  %$2 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([62 x i8], [62 x i8]* @str.162, i64 0, i64 0))
  %$1 = call %struct.Grammar (%struct.Texp) @Grammar.make(%struct.Texp %$2)
  %$3 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %matcher, i32 0, i32 0
  store %struct.Grammar %$1, %struct.Grammar* %$3
  %start-production = alloca %struct.StringView
  %$4 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.163, i64 0, i64 0))
  store %struct.StringView %$4, %struct.StringView* %start-production
  %result = alloca %struct.Texp
  %$5 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %matcher, %struct.Texp* %prog, %struct.StringView* %start-production)
  store %struct.Texp %$5, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
  ret void
}

define void @test.matcher-exact() {
entry:
  %prog = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @str.164, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %prog
  %matcher = alloca %struct.Matcher
  %$2 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([57 x i8], [57 x i8]* @str.165, i64 0, i64 0))
  %$1 = call %struct.Grammar (%struct.Texp) @Grammar.make(%struct.Texp %$2)
  %$3 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %matcher, i32 0, i32 0
  store %struct.Grammar %$1, %struct.Grammar* %$3
  %start-production = alloca %struct.StringView
  %$4 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.166, i64 0, i64 0))
  store %struct.StringView %$4, %struct.StringView* %start-production
  %result = alloca %struct.Texp
  %$5 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %matcher, %struct.Texp* %prog, %struct.StringView* %start-production)
  store %struct.Texp %$5, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
  ret void
}

define void @test.matcher-value() {
entry:
  %prog = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @str.167, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %prog
  %matcher = alloca %struct.Matcher
  %$2 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([57 x i8], [57 x i8]* @str.168, i64 0, i64 0))
  %$1 = call %struct.Grammar (%struct.Texp) @Grammar.make(%struct.Texp %$2)
  %$3 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %matcher, i32 0, i32 0
  store %struct.Grammar %$1, %struct.Grammar* %$3
  %start-production = alloca %struct.StringView
  %$4 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.169, i64 0, i64 0))
  store %struct.StringView %$4, %struct.StringView* %start-production
  %result = alloca %struct.Texp
  %$5 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %matcher, %struct.Texp* %prog, %struct.StringView* %start-production)
  store %struct.Texp %$5, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
  ret void
}

define void @test.matcher-empty-kleene() {
entry:
  %prog = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([61 x i8], [61 x i8]* @str.170, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %prog
  %matcher = alloca %struct.Matcher
  %$2 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([64 x i8], [64 x i8]* @str.171, i64 0, i64 0))
  %$1 = call %struct.Grammar (%struct.Texp) @Grammar.make(%struct.Texp %$2)
  %$3 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %matcher, i32 0, i32 0
  store %struct.Grammar %$1, %struct.Grammar* %$3
  %start-production = alloca %struct.StringView
  %$4 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.172, i64 0, i64 0))
  store %struct.StringView %$4, %struct.StringView* %start-production
  %result = alloca %struct.Texp
  %$5 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %matcher, %struct.Texp* %prog, %struct.StringView* %start-production)
  store %struct.Texp %$5, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
  ret void
}

define void @test.matcher-self() {
entry:
  %filename = alloca %struct.StringView
  call void (%struct.StringView*, i8*) @StringView$ptr.set(%struct.StringView* %filename, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.173, i64 0, i64 0))
  %prog = alloca %struct.Texp
  %$0 = call %struct.Texp (%struct.StringView*) @Parser.parse-file(%struct.StringView* %filename)
  store %struct.Texp %$0, %struct.Texp* %prog
  %matcher = alloca %struct.Matcher
  %$2 = call %struct.Texp (i8*) @Parser.parse-file-i8$ptr(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @str.174, i64 0, i64 0))
  %$1 = call %struct.Grammar (%struct.Texp) @Grammar.make(%struct.Texp %$2)
  %$3 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %matcher, i32 0, i32 0
  store %struct.Grammar %$1, %struct.Grammar* %$3
  %start-production = alloca %struct.StringView
  %$4 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.175, i64 0, i64 0))
  store %struct.StringView %$4, %struct.StringView* %start-production
  %result = alloca %struct.Texp
  %$5 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %matcher, %struct.Texp* %prog, %struct.StringView* %start-production)
  store %struct.Texp %$5, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
  ret void
}

define void @test.matcher-regexString() {
entry:
  %string = alloca %struct.Texp
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.176, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %string
  %$1 = call i1 (%struct.Texp*) @Matcher.regexString(%struct.Texp* %string)
  br i1 %$1, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.177, i64 0, i64 0))
  ret void
  br label %post0
post0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.178, i64 0, i64 0))
  ret void
}

define void @test.matcher-regexInt() {
entry:
  %string = alloca %struct.Texp
  %actual = add i64 1234567890, 0
  %$0 = call %struct.Texp (i8*) @Texp.makeFromi8$ptr(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.179, i64 0, i64 0))
  store %struct.Texp %$0, %struct.Texp* %string
  %$1 = call i1 (%struct.Texp*) @Matcher.regexInt(%struct.Texp* %string)
  br i1 %$1, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.180, i64 0, i64 0))
  ret void
  br label %post0
post0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.181, i64 0, i64 0))
  ret void
}

define void @TextCoord.vector-print(i64 %L-line, i64 %L-col, i64 %R-line, i64 %R-col) {
entry:
  call void (i64) @u64.print(i64 %L-line)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.182, i64 0, i64 0))
  call void (i64) @u64.print(i64 %L-col)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.183, i64 0, i64 0))
  call void (i64) @u64.print(i64 %R-line)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.184, i64 0, i64 0))
  call void (i64) @u64.print(i64 %R-col)
  ret void
}

define void @TextCoord.vector-println(i64 %L-line, i64 %L-col, i64 %R-line, i64 %R-col) {
entry:
  call void (i64, i64, i64, i64) @TextCoord.vector-print(i64 %L-line, i64 %L-col, i64 %R-line, i64 %R-col)
  call void () @println()
  ret void
}

define i1 @TextCoord.lexically-compare(i64 %L-line, i64 %L-col, i64 %R-line, i64 %R-col) {
entry:
  %$0 = icmp ult i64 %L-line, %R-line
  br i1 %$0, label %then0, label %post0
then0:
  ret i1 true
  br label %post0
post0:
  %$1 = icmp ugt i64 %L-line, %R-line
  br i1 %$1, label %then1, label %post1
then1:
  ret i1 false
  br label %post1
post1:
  %$2 = icmp ult i64 %L-col, %R-col
  br i1 %$2, label %then2, label %post2
then2:
  ret i1 true
  br label %post2
post2:
  %$3 = icmp ugt i64 %L-col, %R-col
  br i1 %$3, label %then3, label %post3
then3:
  ret i1 false
  br label %post3
post3:
  ret i1 false
}

%struct.Unparser = type { i64, i64, %struct.Parser*, i64, %struct.File, %struct.Reader, i64, i64 };
define i64 @Unparser.make.count-comments(%struct.Unparser* %unparser, i64 %curr-i) {
entry:
  %$0 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 2
  %parser = load %struct.Parser*, %struct.Parser** %$0
  %$1 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 3
  %type = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %$1, i64 %curr-i)
  %$2 = icmp ne i64 %type, 3
  br i1 %$2, label %then0, label %post0
then0:
  ret i64 %curr-i
  br label %post0
post0:
  %$4 = add i64 1, %curr-i
  %$3 = call i64 (%struct.Unparser*, i64) @Unparser.make.count-comments(%struct.Unparser* %unparser, i64 %$4)
  ret i64 %$3
}

define %struct.Unparser @Unparser.make(%struct.Parser* %parser) {
entry:
  %unparser = alloca %struct.Unparser
  %$0 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 0
  store i64 0, i64* %$0
  %$1 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 1
  store i64 0, i64* %$1
  %$2 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 2
  store %struct.Parser* %parser, %struct.Parser** %$2
  %$3 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 6
  store i64 0, i64* %$3
  %comment-count = call i64 (%struct.Unparser*, i64) @Unparser.make.count-comments(%struct.Unparser* %unparser, i64 0)
  %$4 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 7
  store i64 %comment-count, i64* %$4
  %$5 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 3
  store i64 %comment-count, i64* %$5
  %filename = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 4
  %file = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 4
  %$6 = call %struct.File (%struct.StringView*) @File.open(%struct.StringView* %filename)
  store %struct.File %$6, %struct.File* %file
  %content = alloca %struct.StringView
  %$7 = call %struct.StringView (%struct.File*) @File$ptr.read(%struct.File* %file)
  store %struct.StringView %$7, %struct.StringView* %content
  %$8 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 5
  call void (%struct.Reader*, %struct.StringView*) @Reader$ptr.set(%struct.Reader* %$8, %struct.StringView* %content)
  %$9 = load %struct.Unparser, %struct.Unparser* %unparser
  ret %struct.Unparser %$9
}

define void @Unparser$ptr.increment-col(%struct.Unparser* %unparser, i64 %col-delta) {
entry:
  %$2 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 1
  %$1 = load i64, i64* %$2
  %$0 = add i64 %col-delta, %$1
  %$3 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 1
  store i64 %$0, i64* %$3
  ret void
}

define void @Unparser$ptr.print-comment(%struct.Unparser* %unparser) {
entry:
  %NEWLINE = add i8 10, 0
  %reader = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 5
  %$0 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 3
  %save-line = load i64, i64* %$0
  %$1 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 4
  %save-col = load i64, i64* %$1
  call void (%struct.Reader*, i8) @Reader$ptr.find-next(%struct.Reader* %reader, i8 %NEWLINE)
  %$2 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 3
  %end-line = load i64, i64* %$2
  %$3 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 4
  %end-col = load i64, i64* %$3
  call void (%struct.Reader*, i64, i64) @Reader$ptr.seek-backwards-on-line(%struct.Reader* %reader, i64 %save-line, i64 %save-col)
  %comment-length = sub i64 %end-col, %save-col
  %$4 = getelementptr inbounds %struct.Reader, %struct.Reader* %reader, i32 0, i32 1
  %comment-begin = load i8*, i8** %$4
  call void (i8*, i64) @i8$ptr.printn(i8* %comment-begin, i64 %comment-length)
  call void (%struct.Unparser*, i64) @Unparser$ptr.increment-col(%struct.Unparser* %unparser, i64 %comment-length)
  ret void
}

define void @Unparser$ptr.navigate(%struct.Unparser* %unparser, i64 %line, i64 %col) {
entry:
  %SPACE = add i8 32, 0
  %NEWLINE = add i8 10, 0
  %line-ref = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 0
  %col-ref = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 1
  %$1 = load i64, i64* %line-ref
  %$2 = load i64, i64* %col-ref
  %$0 = call i1 (i64, i64, i64, i64) @TextCoord.lexically-compare(i64 %line, i64 %col, i64 %$1, i64 %$2)
  br i1 %$0, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([50 x i8], [50 x i8]* @str.185, i64 0, i64 0))
  %$3 = load i64, i64* %line-ref
  %$4 = load i64, i64* %col-ref
  call void (i64, i64, i64, i64) @TextCoord.vector-println(i64 %$3, i64 %$4, i64 %line, i64 %col)
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  %$6 = load i64, i64* %line-ref
  %$5 = icmp ult i64 %line, %$6
  br i1 %$5, label %then1, label %post1
then1:
  %$7 = load i64, i64* %line-ref
  %$8 = load i64, i64* %col-ref
  call void (i64, i64, i64, i64) @TextCoord.vector-println(i64 %$7, i64 %$8, i64 %line, i64 %col)
  br label %post1
post1:
  %$10 = load i64, i64* %line-ref
  %$9 = icmp eq i64 %line, %$10
  br i1 %$9, label %then2, label %post2
then2:
  %$12 = load i64, i64* %col-ref
  %$11 = icmp eq i64 %col, %$12
  br i1 %$11, label %then3, label %post3
then3:
  ret void
  br label %post3
post3:
  call void (i8) @i8.print(i8 %SPACE)
  call void (%struct.Unparser*, i64) @Unparser$ptr.increment-col(%struct.Unparser* %unparser, i64 1)
  call void (%struct.Unparser*, i64, i64) @Unparser$ptr.navigate(%struct.Unparser* %unparser, i64 %line, i64 %col)
  ret void
  br label %post2
post2:
  call void (i8) @i8.print(i8 %NEWLINE)
  %$15 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 0
  %$14 = load i64, i64* %$15
  %$13 = add i64 1, %$14
  %$16 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 0
  store i64 %$13, i64* %$16
  %$17 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 1
  store i64 0, i64* %$17
  call void (%struct.Unparser*, i64, i64) @Unparser$ptr.navigate(%struct.Unparser* %unparser, i64 %line, i64 %col)
  ret void
}

define void @Unparser$ptr.pop(%struct.Unparser* %unparser, i64* %index-out, i1* %exhausted) {
entry:
  store i1 false, i1* %exhausted
  store i64 0, i64* %index-out
  %$0 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 2
  %parser = load %struct.Parser*, %struct.Parser** %$0
  %syntax-i = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 3
  %comment-i = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 6
  %lines = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 1
  %cols = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 2
  %types = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 3
  %$1 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 7
  %comment-count = load i64, i64* %$1
  %$2 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %lines, i32 0, i32 1
  %syntax-count = load i64, i64* %$2
  %$3 = load i64, i64* %comment-i
  %comment-exhausted = icmp eq i64 %comment-count, %$3
  %$4 = load i64, i64* %syntax-i
  %syntax-exhausted = icmp eq i64 %syntax-count, %$4
  br i1 %syntax-exhausted, label %then0, label %post0
then0:
  br i1 %comment-exhausted, label %then1, label %post1
then1:
  store i1 true, i1* %exhausted
  ret void
  br label %post1
post1:
  br label %post0
post0:
  br i1 %syntax-exhausted, label %then2, label %post2
then2:
  %$5 = icmp eq i1 false, %comment-exhausted
  br i1 %$5, label %then3, label %post3
then3:
  %$6 = load i64, i64* %comment-i
  store i64 %$6, i64* %index-out
  %$8 = load i64, i64* %comment-i
  %$7 = add i64 1, %$8
  store i64 %$7, i64* %comment-i
  ret void
  br label %post3
post3:
  br label %post2
post2:
  br i1 %comment-exhausted, label %then4, label %post4
then4:
  %$9 = icmp eq i1 false, %syntax-exhausted
  br i1 %$9, label %then5, label %post5
then5:
  %$10 = load i64, i64* %syntax-i
  store i64 %$10, i64* %index-out
  %$12 = load i64, i64* %syntax-i
  %$11 = add i64 1, %$12
  store i64 %$11, i64* %syntax-i
  ret void
  br label %post5
post5:
  br label %post4
post4:
  %$13 = load i64, i64* %syntax-i
  %s-line = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %lines, i64 %$13)
  %$14 = load i64, i64* %syntax-i
  %s-col = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %cols, i64 %$14)
  %$15 = load i64, i64* %comment-i
  %c-line = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %lines, i64 %$15)
  %$16 = load i64, i64* %comment-i
  %c-col = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %cols, i64 %$16)
  %syntax-is-less-than = call i1 (i64, i64, i64, i64) @TextCoord.lexically-compare(i64 %s-line, i64 %s-col, i64 %c-line, i64 %c-col)
  br i1 %syntax-is-less-than, label %then6, label %post6
then6:
  %$17 = load i64, i64* %syntax-i
  store i64 %$17, i64* %index-out
  %$19 = load i64, i64* %syntax-i
  %$18 = add i64 1, %$19
  store i64 %$18, i64* %syntax-i
  br label %post6
post6:
  %$20 = icmp eq i1 false, %syntax-is-less-than
  br i1 %$20, label %then7, label %post7
then7:
  %$21 = load i64, i64* %comment-i
  store i64 %$21, i64* %index-out
  %$23 = load i64, i64* %comment-i
  %$22 = add i64 1, %$23
  store i64 %$22, i64* %comment-i
  br label %post7
post7:
  ret void
}

define void @Unparser$ptr.pop-to-value(%struct.Unparser* %unparser) {
entry:
  %$0 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 2
  %parser = load %struct.Parser*, %struct.Parser** %$0
  %current-index = alloca i64
  %exhausted = alloca i1
  call void (%struct.Unparser*, i64*, i1*) @Unparser$ptr.pop(%struct.Unparser* %unparser, i64* %current-index, i1* %exhausted)
  %$1 = load i1, i1* %exhausted
  br i1 %$1, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @str.186, i64 0, i64 0))
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 1
  %$3 = load i64, i64* %current-index
  %line = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %$2, i64 %$3)
  %$4 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 2
  %$5 = load i64, i64* %current-index
  %col = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %$4, i64 %$5)
  %$6 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 3
  %$7 = load i64, i64* %current-index
  %type = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %$6, i64 %$7)
  call void (%struct.Unparser*, i64, i64) @Unparser$ptr.navigate(%struct.Unparser* %unparser, i64 %line, i64 %col)
  %LPAREN = add i8 40, 0
  %RPAREN = add i8 41, 0
  %SPACE = add i8 32, 0
  %$8 = icmp eq i64 %type, 3
  br i1 %$8, label %then1, label %post1
then1:
  %$9 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 5
  call void (%struct.Reader*) @Reader$ptr.reset(%struct.Reader* %$9)
  %$10 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 5
  call void (%struct.Reader*, i64, i64) @Reader$ptr.seek-forwards(%struct.Reader* %$10, i64 %line, i64 %col)
  call void (%struct.Unparser*) @Unparser$ptr.print-comment(%struct.Unparser* %unparser)
  call void (%struct.Unparser*) @Unparser$ptr.pop-to-value(%struct.Unparser* %unparser)
  ret void
  br label %post1
post1:
  %$11 = icmp eq i64 %type, 0
  br i1 %$11, label %then2, label %post2
then2:
  call void (i8) @i8.print(i8 %LPAREN)
  call void (%struct.Unparser*, i64) @Unparser$ptr.increment-col(%struct.Unparser* %unparser, i64 1)
  call void (%struct.Unparser*) @Unparser$ptr.pop-to-value(%struct.Unparser* %unparser)
  ret void
  br label %post2
post2:
  %$12 = icmp eq i64 %type, 1
  br i1 %$12, label %then3, label %post3
then3:
  call void (i8) @i8.print(i8 %RPAREN)
  call void (%struct.Unparser*, i64) @Unparser$ptr.increment-col(%struct.Unparser* %unparser, i64 1)
  call void (%struct.Unparser*) @Unparser$ptr.pop-to-value(%struct.Unparser* %unparser)
  ret void
  br label %post3
post3:
  ret void
}

define void @unparse-children(%struct.Unparser* %unparser, %struct.Texp* %texp, i64 %child-index) {
entry:
  %SPACE = add i8 32, 0
  %SIZEOF-Texp = add i64 40, 0
  %$0 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 2
  %length = load i64, i64* %$0
  %$1 = icmp eq i64 %child-index, %length
  br i1 %$1, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %$2 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 1
  %children = load %struct.Texp*, %struct.Texp** %$2
  %$4 = mul i64 %SIZEOF-Texp, %child-index
  %$5 = ptrtoint %struct.Texp* %children to i64
  %$3 = add i64 %$4, %$5
  %curr = inttoptr i64 %$3 to %struct.Texp*
  call void (%struct.Unparser*, %struct.Texp*) @unparse-texp(%struct.Unparser* %unparser, %struct.Texp* %curr)
  %$6 = add i64 1, %child-index
  tail call void (%struct.Unparser*, %struct.Texp*, i64) @unparse-children(%struct.Unparser* %unparser, %struct.Texp* %texp, i64 %$6)
  ret void
}

define void @unparse-texp(%struct.Unparser* %unparser, %struct.Texp* %texp) {
entry:
  %$1 = ptrtoint %struct.Texp* %texp to i64
  %$0 = icmp eq i64 0, %$1
  br i1 %$0, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @str.187, i64 0, i64 0))
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  %value-ref = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 0
  %$2 = getelementptr inbounds %struct.String, %struct.String* %value-ref, i32 0, i32 1
  %value-length = load i64, i64* %$2
  %$3 = getelementptr inbounds %struct.Texp, %struct.Texp* %texp, i32 0, i32 2
  %length = load i64, i64* %$3
  call void (%struct.Unparser*) @Unparser$ptr.pop-to-value(%struct.Unparser* %unparser)
  call void (%struct.String*) @String$ptr.print(%struct.String* %value-ref)
  call void (%struct.Unparser*, i64) @Unparser$ptr.increment-col(%struct.Unparser* %unparser, i64 %value-length)
  call void (%struct.Unparser*, %struct.Texp*, i64) @unparse-children(%struct.Unparser* %unparser, %struct.Texp* %texp, i64 0)
  ret void
}

define void @Unparser$ptr.exhaust-after-words(%struct.Unparser* %unparser) {
entry:
  %$0 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 2
  %parser = load %struct.Parser*, %struct.Parser** %$0
  %current-index = alloca i64
  %exhausted = alloca i1
  call void (%struct.Unparser*, i64*, i1*) @Unparser$ptr.pop(%struct.Unparser* %unparser, i64* %current-index, i1* %exhausted)
  %$1 = load i1, i1* %exhausted
  br i1 %$1, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %$2 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 1
  %$3 = load i64, i64* %current-index
  %line = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %$2, i64 %$3)
  %$4 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 2
  %$5 = load i64, i64* %current-index
  %col = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %$4, i64 %$5)
  %$6 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 3
  %$7 = load i64, i64* %current-index
  %type = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %$6, i64 %$7)
  call void (%struct.Unparser*, i64, i64) @Unparser$ptr.navigate(%struct.Unparser* %unparser, i64 %line, i64 %col)
  %LPAREN = add i8 40, 0
  %RPAREN = add i8 41, 0
  %SPACE = add i8 32, 0
  %$8 = icmp eq i64 %type, 3
  br i1 %$8, label %then1, label %post1
then1:
  %$9 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 5
  call void (%struct.Reader*) @Reader$ptr.reset(%struct.Reader* %$9)
  %$10 = getelementptr inbounds %struct.Unparser, %struct.Unparser* %unparser, i32 0, i32 5
  call void (%struct.Reader*, i64, i64) @Reader$ptr.seek-forwards(%struct.Reader* %$10, i64 %line, i64 %col)
  call void (%struct.Unparser*) @Unparser$ptr.print-comment(%struct.Unparser* %unparser)
  call void (%struct.Unparser*) @Unparser$ptr.exhaust-after-words(%struct.Unparser* %unparser)
  ret void
  br label %post1
post1:
  %$11 = icmp eq i64 %type, 0
  br i1 %$11, label %then2, label %post2
then2:
  call void (i8) @i8.print(i8 %LPAREN)
  call void (%struct.Unparser*, i64) @Unparser$ptr.increment-col(%struct.Unparser* %unparser, i64 1)
  call void (%struct.Unparser*) @Unparser$ptr.exhaust-after-words(%struct.Unparser* %unparser)
  ret void
  br label %post2
post2:
  %$12 = icmp eq i64 %type, 1
  br i1 %$12, label %then3, label %post3
then3:
  call void (i8) @i8.print(i8 %RPAREN)
  call void (%struct.Unparser*, i64) @Unparser$ptr.increment-col(%struct.Unparser* %unparser, i64 1)
  call void (%struct.Unparser*) @Unparser$ptr.exhaust-after-words(%struct.Unparser* %unparser)
  ret void
  br label %post3
post3:
  ret void
}

define void @unparse(%struct.Parser* %parser, %struct.Texp* %texp) {
entry:
  %unparser = alloca %struct.Unparser
  %$0 = call %struct.Unparser (%struct.Parser*) @Unparser.make(%struct.Parser* %parser)
  store %struct.Unparser %$0, %struct.Unparser* %unparser
  call void (%struct.Unparser*, %struct.Texp*, i64) @unparse-children(%struct.Unparser* %unparser, %struct.Texp* %texp, i64 0)
  call void (%struct.Unparser*) @Unparser$ptr.exhaust-after-words(%struct.Unparser* %unparser)
  ret void
}

define void @dump-parser_(%struct.Parser* %parser, i64 %row) {
entry:
  %texp-lines = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 2
  %$2 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %texp-lines, i32 0, i32 1
  %$1 = load i64, i64* %$2
  %$0 = icmp eq i64 %row, %$1
  br i1 %$0, label %then0, label %post0
then0:
  ret void
  br label %post0
post0:
  %lines = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 1
  %cols = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 2
  %types = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 3
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.188, i64 0, i64 0))
  %$3 = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %lines, i64 %row)
  call void (i64) @u64.print(i64 %$3)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.189, i64 0, i64 0))
  %$4 = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %cols, i64 %row)
  call void (i64) @u64.print(i64 %$4)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.190, i64 0, i64 0))
  %$5 = call i64 (%struct.u64-vector*, i64) @u64-vector$ptr.unsafe-get(%struct.u64-vector* %types, i64 %row)
  call void (i64) @u64.print(i64 %$5)
  call void () @println()
  %$6 = add i64 1, %row
  call void (%struct.Parser*, i64) @dump-parser_(%struct.Parser* %parser, i64 %$6)
  ret void
}

define void @dump-parser(%struct.Parser* %parser) {
entry:
  %lines = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 1
  %cols = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 2
  %types = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 3
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.191, i64 0, i64 0))
  %$1 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %lines, i32 0, i32 1
  %$0 = load i64, i64* %$1
  call void (i64) @u64.print(i64 %$0)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.192, i64 0, i64 0))
  %$3 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %cols, i32 0, i32 1
  %$2 = load i64, i64* %$3
  call void (i64) @u64.print(i64 %$2)
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.193, i64 0, i64 0))
  %$5 = getelementptr inbounds %struct.u64-vector, %struct.u64-vector* %types, i32 0, i32 1
  %$4 = load i64, i64* %$5
  call void (i64) @u64.print(i64 %$4)
  call void () @println()
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([34 x i8], [34 x i8]* @str.194, i64 0, i64 0))
  call void (%struct.Parser*, i64) @dump-parser_(%struct.Parser* %parser, i64 0)
  ret void
}

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %$0 = icmp ne i32 2, %argc
  br i1 %$0, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @str.195, i64 0, i64 0))
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  %$2 = ptrtoint i8** %argv to i64
  %$1 = add i64 8, %$2
  %arg = inttoptr i64 %$1 to i8**
  %filename = alloca %struct.StringView
  %$4 = load i8*, i8** %arg
  %$3 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* %$4)
  store %struct.StringView %$3, %struct.StringView* %filename
  %file = alloca %struct.File
  %$5 = call %struct.File (%struct.StringView*) @File.openrw(%struct.StringView* %filename)
  store %struct.File %$5, %struct.File* %file
  %content = alloca %struct.StringView
  %$6 = call %struct.StringView (%struct.File*) @File$ptr.readwrite(%struct.File* %file)
  store %struct.StringView %$6, %struct.StringView* %content
  %parser = alloca %struct.Parser
  %$7 = call %struct.Parser (%struct.StringView*) @Parser.make(%struct.StringView* %content)
  store %struct.Parser %$7, %struct.Parser* %parser
  %$8 = load %struct.StringView, %struct.StringView* %filename
  %$9 = getelementptr inbounds %struct.Parser, %struct.Parser* %parser, i32 0, i32 4
  store %struct.StringView %$8, %struct.StringView* %$9
  call void (%struct.Parser*) @Parser$ptr.remove-comments(%struct.Parser* %parser)
  %prog = alloca %struct.Texp
  %filename-string = alloca %struct.String
  %$10 = call %struct.String (%struct.StringView*) @String.makeFromStringView(%struct.StringView* %filename)
  store %struct.String %$10, %struct.String* %filename-string
  call void (%struct.Texp*, %struct.String*) @Texp$ptr.setFromString(%struct.Texp* %prog, %struct.String* %filename-string)
  call void (%struct.Parser*, %struct.Texp*) @Parser$ptr.collect(%struct.Parser* %parser, %struct.Texp* %prog)
  call void (%struct.Parser*) @dump-parser(%struct.Parser* %parser)
  call void (%struct.StringView*) @File.unread(%struct.StringView* %content)
  call void (%struct.File*) @File$ptr.close(%struct.File* %file)
  ret i32 0
}

@str.0 = private unnamed_addr constant [22 x i8] c"global string example\00", align 1
@str.1 = private unnamed_addr constant [22 x i8] c"'%s' has length %lu.\0A\00", align 1
@str.2 = private unnamed_addr constant [22 x i8] c"global string example\00", align 1
@str.3 = private unnamed_addr constant [22 x i8] c"global string example\00", align 1
@str.4 = private unnamed_addr constant [22 x i8] c"global string example\00", align 1
@str.5 = private unnamed_addr constant [22 x i8] c"'%s' has length %lu.\0A\00", align 1
@str.6 = private unnamed_addr constant [18 x i8] c"basic-string test\00", align 1
@str.7 = private unnamed_addr constant [22 x i8] c"'%s' has length %lu.\0A\00", align 1
@str.8 = private unnamed_addr constant [24 x i8] c"string-self-append test\00", align 1
@str.9 = private unnamed_addr constant [8 x i8] c"hello, \00", align 1
@str.10 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@str.11 = private unnamed_addr constant [28 x i8] c"this is a comparison string\00", align 1
@str.12 = private unnamed_addr constant [28 x i8] c"this is a comparison string\00", align 1
@str.13 = private unnamed_addr constant [7 x i8] c"PASSED\00", align 1
@str.14 = private unnamed_addr constant [7 x i8] c"FAILED\00", align 1
@str.15 = private unnamed_addr constant [8 x i8] c"hello, \00", align 1
@str.16 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@str.17 = private unnamed_addr constant [28 x i8] c"error opening file at '%s'\0A\00", align 1
@str.18 = private unnamed_addr constant [20 x i8] c"backbone-core: mmap\00", align 1
@str.19 = private unnamed_addr constant [10 x i8] c"todo.json\00", align 1
@str.20 = private unnamed_addr constant [23 x i8] c"lib2/core.bb.type.tall\00", align 1
@str.21 = private unnamed_addr constant [5 x i8] c"%ul\0A\00", align 1
@str.22 = private unnamed_addr constant [23 x i8] c"lib2/core.bb.type.tall\00", align 1
@str.23 = private unnamed_addr constant [2 x i8] c" \00", align 1
@str.24 = private unnamed_addr constant [2 x i8] c",\00", align 1
@str.25 = private unnamed_addr constant [5 x i8] c" -> \00", align 1
@str.26 = private unnamed_addr constant [2 x i8] c",\00", align 1
@str.27 = private unnamed_addr constant [36 x i8] c"Error: Seeking before cursor column\00", align 1
@str.28 = private unnamed_addr constant [34 x i8] c"Error: Seeking past end of column\00", align 1
@str.29 = private unnamed_addr constant [32 x i8] c"Error: Seeking past end of file\00", align 1
@str.30 = private unnamed_addr constant [34 x i8] c"Error: Seeking before cursor line\00", align 1
@str.31 = private unnamed_addr constant [41 x i8] c"Error: Finding character past end of file", align 1
@str.32 = private unnamed_addr constant [23 x i8] c"lib2/core.bb.type.tall\00", align 1
@str.33 = private unnamed_addr constant [10 x i8] c"todo.json\00", align 1
@str.34 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@str.35 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@str.36 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.37 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.38 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.39 = private unnamed_addr constant [5 x i8] c"some\00", align 1
@str.40 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@str.41 = private unnamed_addr constant [6 x i8] c"empty\00", align 1
@str.42 = private unnamed_addr constant [12 x i8] c"(null texp)\00", align 1
@str.43 = private unnamed_addr constant [9 x i8] c"value: '\00", align 1
@str.44 = private unnamed_addr constant [12 x i8] c"', length: \00", align 1
@str.45 = private unnamed_addr constant [13 x i8] c", capacity: \00", align 1
@str.46 = private unnamed_addr constant [12 x i8] c"(null texp)\00", align 1
@str.47 = private unnamed_addr constant [8 x i8] c"    at \00", align 1
@str.48 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.49 = private unnamed_addr constant [8 x i8] c"child-0\00", align 1
@str.50 = private unnamed_addr constant [8 x i8] c"child-1\00", align 1
@str.51 = private unnamed_addr constant [8 x i8] c"child-2\00", align 1
@str.52 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.53 = private unnamed_addr constant [8 x i8] c"child-0\00", align 1
@str.54 = private unnamed_addr constant [8 x i8] c"child-1\00", align 1
@str.55 = private unnamed_addr constant [8 x i8] c"child-2\00", align 1
@str.56 = private unnamed_addr constant [5 x i8] c"atom\00", align 1
@str.57 = private unnamed_addr constant [2 x i8] c" \00", align 1
@str.58 = private unnamed_addr constant [2 x i8] c" \00", align 1
@str.59 = private unnamed_addr constant [39 x i8] c"(kleene (success atom) (success atom))\00", align 1
@str.60 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.61 = private unnamed_addr constant [5 x i8] c"pass\00", align 1
@str.62 = private unnamed_addr constant [5 x i8] c"fail\00", align 1
@str.63 = private unnamed_addr constant [43 x i8] c"docs/bb-type-tall-str-include-grammar.texp\00", align 1
@str.64 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.65 = private unnamed_addr constant [7 x i8] c"PASSED\00", align 1
@str.66 = private unnamed_addr constant [7 x i8] c"FAILED\00", align 1
@str.67 = private unnamed_addr constant [43 x i8] c"docs/bb-type-tall-str-include-grammar.texp\00", align 1
@str.68 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.69 = private unnamed_addr constant [46 x i8] c"FAILED: Program not found in grammar\0Agrammar:\00", align 1
@str.70 = private unnamed_addr constant [7 x i8] c"PASSED\00", align 1
@str.71 = private unnamed_addr constant [11 x i8] c"0123456789\00", align 1
@str.72 = private unnamed_addr constant [7 x i8] c"PASSED\00", align 1
@str.73 = private unnamed_addr constant [7 x i8] c"FAILED\00", align 1
@str.74 = private unnamed_addr constant [11 x i8] c"0123456789\00", align 1
@str.75 = private unnamed_addr constant [7 x i8] c"PASSED\00", align 1
@str.76 = private unnamed_addr constant [7 x i8] c"FAILED\00", align 1
@str.77 = private unnamed_addr constant [0 x i8] c"", align 1
@str.78 = private unnamed_addr constant [4 x i8] c"huh\00", align 1
@str.79 = private unnamed_addr constant [23 x i8] c"lib2/core.bb.type.tall\00", align 1
@str.80 = private unnamed_addr constant [41 x i8] c"../backbone-test/texp-parser/string.texp\00", align 1
@str.81 = private unnamed_addr constant [23 x i8] c"lib2/core.bb.type.tall\00", align 1
@str.82 = private unnamed_addr constant [23 x i8] c"lib2/core.bb.type.tall\00", align 1
@str.83 = private unnamed_addr constant [14 x i8] c"lib/pprint.bb\00", align 1
@str.84 = private unnamed_addr constant [13 x i8] c"\0Aproduction \00", align 1
@str.85 = private unnamed_addr constant [11 x i8] c" not found\00", align 1
@str.86 = private unnamed_addr constant [2 x i8] c"|\00", align 1
@str.87 = private unnamed_addr constant [41 x i8] c"rule value should not be empty for rule:\00", align 1
@str.88 = private unnamed_addr constant [20 x i8] c" [.is           ]  \00", align 1
@str.89 = private unnamed_addr constant [5 x i8] c" -> \00", align 1
@str.90 = private unnamed_addr constant [4 x i8] c" @ \00", align 1
@str.91 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@str.92 = private unnamed_addr constant [18 x i8] c" [.atom         ]\00", align 1
@str.93 = private unnamed_addr constant [22 x i8] c"\22texp is not an atom\22\00", align 1
@str.94 = private unnamed_addr constant [5 x i8] c"atom\00", align 1
@str.95 = private unnamed_addr constant [23 x i8] c" [.match        ]  -> \00", align 1
@str.96 = private unnamed_addr constant [2 x i8] c"|\00", align 1
@str.97 = private unnamed_addr constant [16 x i8] c", rule-length: \00", align 1
@str.98 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.99 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@str.100 = private unnamed_addr constant [23 x i8] c" [.kleene-seq   ]  i: \00", align 1
@str.101 = private unnamed_addr constant [3 x i8] c", \00", align 1
@str.102 = private unnamed_addr constant [6 x i8] c" -> :\00", align 1
@str.103 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.104 = private unnamed_addr constant [23 x i8] c" [.kleene-many  ]  i: \00", align 1
@str.105 = private unnamed_addr constant [3 x i8] c", \00", align 1
@str.106 = private unnamed_addr constant [6 x i8] c" -> :\00", align 1
@str.107 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.108 = private unnamed_addr constant [26 x i8] c" [.kleene       ]  texp: \00", align 1
@str.109 = private unnamed_addr constant [9 x i8] c", rule: \00", align 1
@str.110 = private unnamed_addr constant [7 x i8] c"kleene\00", align 1
@str.111 = private unnamed_addr constant [33 x i8] c" [.kleene       ]  rule-length: \00", align 1
@str.112 = private unnamed_addr constant [16 x i8] c", texp-length: \00", align 1
@str.113 = private unnamed_addr constant [32 x i8] c" [.kleene       ]  seq-length: \00", align 1
@str.114 = private unnamed_addr constant [16 x i8] c", last-texp-i: \00", align 1
@str.115 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.116 = private unnamed_addr constant [43 x i8] c"texp length not less than for rule.len - 1\00", align 1
@str.117 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.118 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.119 = private unnamed_addr constant [20 x i8] c" [.exact_       ]  \00", align 1
@str.120 = private unnamed_addr constant [5 x i8] c" -> \00", align 1
@str.121 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.122 = private unnamed_addr constant [47 x i8] c"\22texp has incorrect length for exact sequence\22\00", align 1
@str.123 = private unnamed_addr constant [20 x i8] c" [.exact        ]  \00", align 1
@str.124 = private unnamed_addr constant [5 x i8] c" -> \00", align 1
@str.125 = private unnamed_addr constant [6 x i8] c"exact\00", align 1
@str.126 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@str.127 = private unnamed_addr constant [23 x i8] c" [.choice_      ]  i: \00", align 1
@str.128 = private unnamed_addr constant [3 x i8] c", \00", align 1
@str.129 = private unnamed_addr constant [6 x i8] c" -> :\00", align 1
@str.130 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@str.131 = private unnamed_addr constant [9 x i8] c"choice->\00", align 1
@str.132 = private unnamed_addr constant [21 x i8] c"keyword-choice-match\00", align 1
@str.133 = private unnamed_addr constant [13 x i8] c"choice-match\00", align 1
@str.134 = private unnamed_addr constant [23 x i8] c" [.choice       ]  -> \00", align 1
@str.135 = private unnamed_addr constant [7 x i8] c"choice\00", align 1
@str.136 = private unnamed_addr constant [16 x i8] c"choice-attempts\00", align 1
@str.137 = private unnamed_addr constant [5 x i8] c"true\00", align 1
@str.138 = private unnamed_addr constant [6 x i8] c"false\00", align 1
@str.139 = private unnamed_addr constant [20 x i8] c" [.value        ]  \00", align 1
@str.140 = private unnamed_addr constant [5 x i8] c" -> \00", align 1
@str.141 = private unnamed_addr constant [5 x i8] c"#int\00", align 1
@str.142 = private unnamed_addr constant [22 x i8] c"failed to match #int\22\00", align 1
@str.143 = private unnamed_addr constant [8 x i8] c"#string\00", align 1
@str.144 = private unnamed_addr constant [26 x i8] c"\22failed to match #string\22\00", align 1
@str.145 = private unnamed_addr constant [6 x i8] c"#bool\00", align 1
@str.146 = private unnamed_addr constant [24 x i8] c"\22failed to match #bool\22\00", align 1
@str.147 = private unnamed_addr constant [6 x i8] c"#type\00", align 1
@str.148 = private unnamed_addr constant [6 x i8] c"#name\00", align 1
@str.149 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.150 = private unnamed_addr constant [39 x i8] c"unmatched regex check for rule value: \00", align 1
@str.151 = private unnamed_addr constant [9 x i8] c", rule: \00", align 1
@str.152 = private unnamed_addr constant [3 x i8] c", \00", align 1
@str.153 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@str.154 = private unnamed_addr constant [14 x i8] c"keyword-match\00", align 1
@str.155 = private unnamed_addr constant [56 x i8] c"/home/kasra/projects/backbone-test/matcher/program.texp\00", align 1
@str.156 = private unnamed_addr constant [59 x i8] c"/home/kasra/projects/backbone-test/matcher/program.grammar\00", align 1
@str.157 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.158 = private unnamed_addr constant [55 x i8] c"/home/kasra/projects/backbone-test/matcher/choice.texp\00", align 1
@str.159 = private unnamed_addr constant [58 x i8] c"/home/kasra/projects/backbone-test/matcher/choice.grammar\00", align 1
@str.160 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.161 = private unnamed_addr constant [59 x i8] c"/home/kasra/projects/backbone-test/matcher/seq-kleene.texp\00", align 1
@str.162 = private unnamed_addr constant [62 x i8] c"/home/kasra/projects/backbone-test/matcher/seq-kleene.grammar\00", align 1
@str.163 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.164 = private unnamed_addr constant [54 x i8] c"/home/kasra/projects/backbone-test/matcher/exact.texp\00", align 1
@str.165 = private unnamed_addr constant [57 x i8] c"/home/kasra/projects/backbone-test/matcher/exact.grammar\00", align 1
@str.166 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.167 = private unnamed_addr constant [54 x i8] c"/home/kasra/projects/backbone-test/matcher/value.texp\00", align 1
@str.168 = private unnamed_addr constant [57 x i8] c"/home/kasra/projects/backbone-test/matcher/value.grammar\00", align 1
@str.169 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.170 = private unnamed_addr constant [61 x i8] c"/home/kasra/projects/backbone-test/matcher/empty-kleene.texp\00", align 1
@str.171 = private unnamed_addr constant [64 x i8] c"/home/kasra/projects/backbone-test/matcher/empty-kleene.grammar\00", align 1
@str.172 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.173 = private unnamed_addr constant [16 x i8] c"lib2/matcher.bb\00", align 1
@str.174 = private unnamed_addr constant [43 x i8] c"docs/bb-type-tall-str-include-grammar.texp\00", align 1
@str.175 = private unnamed_addr constant [8 x i8] c"Program\00", align 1
@str.176 = private unnamed_addr constant [15 x i8] c"\22hello, world\22\00", align 1
@str.177 = private unnamed_addr constant [7 x i8] c"PASSED\00", align 1
@str.178 = private unnamed_addr constant [7 x i8] c"FAILED\00", align 1
@str.179 = private unnamed_addr constant [11 x i8] c"0123456789\00", align 1
@str.180 = private unnamed_addr constant [7 x i8] c"PASSED\00", align 1
@str.181 = private unnamed_addr constant [7 x i8] c"FAILED\00", align 1
@str.182 = private unnamed_addr constant [2 x i8] c",\00", align 1
@str.183 = private unnamed_addr constant [5 x i8] c" -> \00", align 1
@str.184 = private unnamed_addr constant [2 x i8] c",\00", align 1
@str.185 = private unnamed_addr constant [50 x i8] c"error: cannot navigate backwards from the cursor: ", align 1
@str.186 = private unnamed_addr constant [41 x i8] c"error: pop-to-value: iterators exhausted\00", align 1
@str.187 = private unnamed_addr constant [25 x i8] c"cannot unparse null-texp\00", align 1
@str.188 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@str.189 = private unnamed_addr constant [3 x i8] c", \00", align 1
@str.190 = private unnamed_addr constant [4 x i8] c")  \00", align 1
@str.191 = private unnamed_addr constant [9 x i8] c"lengths:\00", align 1
@str.192 = private unnamed_addr constant [2 x i8] c" \00", align 1
@str.193 = private unnamed_addr constant [2 x i8] c" \00", align 1
@str.194 = private unnamed_addr constant [34 x i8] c"---------------------------------\00", align 1
@str.195 = private unnamed_addr constant [26 x i8] c"usage: unparser <file.bb>\00", align 1

; (Program/kleene (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->Sext/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->GE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Value/choice->StrGet/exact IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->GT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Rem/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->Trunc/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Div/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->GE/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->GT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->GT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Store/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Store/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->BoolLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->BoolLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->BoolLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom))) (TopLevel/choice->StrTable/kleene (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom)))
