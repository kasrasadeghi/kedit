; def @i8$ptr.length_ env
; %this -> i8*
; %acc -> u64
; (let %$1 (load %this))
; %$1 -> i8
; (let %$0 (== %$1 0))
; %$0 -> i1
; (if %$0 (do (return %acc)))
; (return %acc)
; (let %$5 (cast u64 %this))
; value: (type-value i8* %this)
; %$5 -> u64
; (let %$4 (+ 1 %$5))
; %$4 -> u64
; (let %$3 (cast i8* %$4))
; value: (type-value u64 %$4)
; %$3 -> i8*
; (let %$6 (+ %acc 1))
; %$6 -> u64
; (let %$2 (call-tail @i8$ptr.length_ (args %$3 %$6)))
; %$2 -> u64
; (return %$2)
; def @i8$ptr.length env
; %this -> i8*
; (let %$0 (call-tail @i8$ptr.length_ (args %this 0)))
; %$0 -> u64
; (return %$0)
; def @i8$ptr.printn env
; %this -> i8*
; %n -> u64
; (let %FD_STDOUT (+ 1 (0 i32)))
; %FD_STDOUT -> i32
; (call @write (args %FD_STDOUT %this %n))
; return-void
; def @i8$ptr.unsafe-print env
; %this -> i8*
; (let %length (call @i8$ptr.length (args %this)))
; %length -> u64
; (call @i8$ptr.printn (args %this %length))
; return-void
; def @i8$ptr.unsafe-println env
; %this -> i8*
; (call @i8$ptr.unsafe-print (args %this))
; (call @println args)
; return-void
; def @i8$ptr.copyalloc env
; %this -> i8*
; (let %length (call @i8$ptr.length (args %this)))
; %length -> u64
; (let %$0 (+ %length 1))
; %$0 -> u64
; (let %allocated (call @malloc (args %$0)))
; %allocated -> i8*
; (let %$3 (cast u64 %allocated))
; value: (type-value i8* %allocated)
; %$3 -> u64
; (let %$2 (+ %length %$3))
; %$2 -> u64
; (let %$1 (cast i8* %$2))
; value: (type-value u64 %$2)
; %$1 -> i8*
; (store 0 %$1)
; (call @memcpy (args %allocated %this %length))
; (return %allocated)
; def @i8.print env
; %this -> i8
; (auto %c i8)
; %c -> i8*
; (store %this %c)
; (let %FD_STDOUT (+ 1 (0 i32)))
; %FD_STDOUT -> i32
; (call @write (args %FD_STDOUT %c 1))
; return-void
; def @i8$ptr.swap env
; %this -> i8*
; %other -> i8*
; (let %this_value (load %this))
; %this_value -> i8
; (let %other_value (load %other))
; %other_value -> i8
; (store %this_value %other)
; (store %other_value %this)
; return-void
; def @i8$ptr.eqn env
; %this -> i8*
; %other -> i8*
; %len -> u64
; (let %$0 (== 0 %len))
; %$0 -> i1
; (if %$0 (do (return true)))
; (return true)
; (let %$2 (load %this))
; %$2 -> i8
; (let %$3 (load %other))
; %$3 -> i8
; (let %$1 (!= %$2 %$3))
; %$1 -> i1
; (if %$1 (do (return false)))
; (return false)
; (let %$5 (cast u64 %this))
; value: (type-value i8* %this)
; %$5 -> u64
; (let %$4 (+ 1 %$5))
; %$4 -> u64
; (let %next-this (cast i8* %$4))
; value: (type-value u64 %$4)
; %next-this -> i8*
; (let %$7 (cast u64 %other))
; value: (type-value i8* %other)
; %$7 -> u64
; (let %$6 (+ 1 %$7))
; %$6 -> u64
; (let %next-other (cast i8* %$6))
; value: (type-value u64 %$6)
; %next-other -> i8*
; (let %$9 (- %len 1))
; %$9 -> u64
; (let %$8 (call @i8$ptr.eqn (args %next-this %next-other %$9)))
; %$8 -> i1
; (return %$8)
; def @println env
; (let %NEWLINE (+ 10 (0 i8)))
; %NEWLINE -> i8
; (call @i8.print (args %NEWLINE))
; return-void
; def @test.i8$ptr-eqn env
; (auto %a %struct.String)
; %a -> %struct.String*
; (let %$0 (call @String.makeEmpty args))
; %$0 -> %struct.String
; (store %$0 %a)
; (auto %b %struct.String)
; %b -> %struct.String*
; (let %$1 (call @String.makeEmpty args))
; %$1 -> %struct.String
; (store %$1 %b)
; (call @String$ptr.pushChar (args %a 65))
; (call @String$ptr.pushChar (args %a 66))
; (call @String$ptr.pushChar (args %a 67))
; (call @String$ptr.pushChar (args %a 68))
; (call @String$ptr.pushChar (args %b 65))
; (call @String$ptr.pushChar (args %b 66))
; (call @String$ptr.pushChar (args %b 67))
; (call @String$ptr.pushChar (args %b 68))
; (let %a-cstr (cast i8* %a))
; value: (type-value %struct.String* %a)
; %a-cstr -> i8*
; (let %b-cstr (cast i8* %b))
; value: (type-value %struct.String* %b)
; %b-cstr -> i8*
; (let %$4 (call @i8$ptr.eqn (args %a-cstr %b-cstr 5)))
; %$4 -> i1
; (let %$3 (cast i8 %$4))
; value: (type-value i1 %$4)
; %$3 -> i8
; (let %$2 (+ 48 %$3))
; %$2 -> i8
; (call @i8.print (args %$2))
; return-void
; def @StringView.makeEmpty env
; (auto %result %struct.StringView)
; %result -> %struct.StringView*
; (let %$0 (cast i8* (0 i64)))
; value: (type-value i64 0)
; %$0 -> i8*
; (let %$1 (index %result 0))
; %$1 -> i8**
; (store %$0 %$1)
; (let %$2 (index %result 1))
; %$2 -> u64*
; (store 0 %$2)
; (let %$3 (load %result))
; %$3 -> %struct.StringView
; (return %$3)
; def @StringView$ptr.set env
; %this -> %struct.StringView*
; %charptr -> i8*
; (let %$0 (index %this 0))
; %$0 -> i8**
; (store %charptr %$0)
; (let %$1 (call @i8$ptr.length (args %charptr)))
; %$1 -> u64
; (let %$2 (index %this 1))
; %$2 -> u64*
; (store %$1 %$2)
; return-void
; def @StringView.make env
; %charptr -> i8*
; %size -> u64
; (auto %result %struct.StringView)
; %result -> %struct.StringView*
; (let %$0 (index %result 0))
; %$0 -> i8**
; (store %charptr %$0)
; (let %$1 (index %result 1))
; %$1 -> u64*
; (store %size %$1)
; (let %$2 (load %result))
; %$2 -> %struct.StringView
; (return %$2)
; def @StringView.makeFromi8$ptr env
; %charptr -> i8*
; (auto %result %struct.StringView)
; %result -> %struct.StringView*
; (let %$0 (index %result 0))
; %$0 -> i8**
; (store %charptr %$0)
; (let %$1 (call @i8$ptr.length (args %charptr)))
; %$1 -> u64
; (let %$2 (index %result 1))
; %$2 -> u64*
; (store %$1 %$2)
; (let %$3 (load %result))
; %$3 -> %struct.StringView
; (return %$3)
; def @StringView$ptr.print env
; %this -> %struct.StringView*
; (let %$1 (index %this 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (let %$3 (index %this 1))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (call @i8$ptr.printn (args %$0 %$2))
; return-void
; def @StringView$ptr.println env
; %this -> %struct.StringView*
; (call @StringView$ptr.print (args %this))
; (call @println args)
; return-void
; def @StringView.print env
; %this -> %struct.StringView
; (auto %local %struct.StringView)
; %local -> %struct.StringView*
; (store %this %local)
; (let %$1 (index %local 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (let %$3 (index %local 1))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (call @i8$ptr.printn (args %$0 %$2))
; return-void
; def @StringView.println env
; %this -> %struct.StringView
; (call @StringView.print (args %this))
; (call @println args)
; return-void
; def @StringView$ptr.eq env
; %this -> %struct.StringView*
; %other -> %struct.StringView*
; (let %$0 (index %this 1))
; %$0 -> u64*
; (let %len (load %$0))
; %len -> u64
; (let %$1 (index %other 1))
; %$1 -> u64*
; (let %olen (load %$1))
; %olen -> u64
; (let %$2 (!= %len %olen))
; %$2 -> i1
; (if %$2 (do (return false)))
; (return false)
; (let %$5 (index %this 0))
; %$5 -> i8**
; (let %$4 (load %$5))
; %$4 -> i8*
; (let %$7 (index %other 0))
; %$7 -> i8**
; (let %$6 (load %$7))
; %$6 -> i8*
; (let %$3 (call @i8$ptr.eqn (args %$4 %$6 %len)))
; %$3 -> i1
; (return %$3)
; def @StringView.eq env
; %this-value -> %struct.StringView
; %other-value -> %struct.StringView
; (auto %this %struct.StringView)
; %this -> %struct.StringView*
; (store %this-value %this)
; (auto %other %struct.StringView)
; %other -> %struct.StringView*
; (store %other-value %other)
; (let %$0 (call @StringView$ptr.eq (args %this %other)))
; %$0 -> i1
; (return %$0)
; def @String.makeEmpty env
; (auto %result %struct.String)
; %result -> %struct.String*
; (let %$0 (cast i8* (0 i64)))
; value: (type-value i64 0)
; %$0 -> i8*
; (let %$1 (index %result 0))
; %$1 -> i8**
; (store %$0 %$1)
; (let %$2 (index %result 1))
; %$2 -> u64*
; (store 0 %$2)
; (let %$3 (load %result))
; %$3 -> %struct.String
; (return %$3)
; def @String$ptr.set env
; %this -> %struct.String*
; %charptr -> i8*
; (let %$0 (call @i8$ptr.copyalloc (args %charptr)))
; %$0 -> i8*
; (let %$1 (index %this 0))
; %$1 -> i8**
; (store %$0 %$1)
; (let %$3 (call @i8$ptr.length (args %charptr)))
; %$3 -> u64
; (let %$2 (- %$3 1))
; %$2 -> u64
; (let %$4 (index %this 1))
; %$4 -> u64*
; (store %$2 %$4)
; return-void
; def @String.makeFromi8$ptr env
; %charptr -> i8*
; (auto %this %struct.String)
; %this -> %struct.String*
; (let %$0 (call @i8$ptr.copyalloc (args %charptr)))
; %$0 -> i8*
; (let %$1 (index %this 0))
; %$1 -> i8**
; (store %$0 %$1)
; (let %$2 (call @i8$ptr.length (args %charptr)))
; %$2 -> u64
; (let %$3 (index %this 1))
; %$3 -> u64*
; (store %$2 %$3)
; (let %$4 (load %this))
; %$4 -> %struct.String
; (return %$4)
; def @String$ptr.copyalloc env
; %this -> %struct.String*
; (auto %result %struct.String)
; %result -> %struct.String*
; (let %$2 (index %this 0))
; %$2 -> i8**
; (let %$1 (load %$2))
; %$1 -> i8*
; (let %$0 (call @i8$ptr.copyalloc (args %$1)))
; %$0 -> i8*
; (let %$3 (index %result 0))
; %$3 -> i8**
; (store %$0 %$3)
; (let %$5 (index %this 1))
; %$5 -> u64*
; (let %$4 (load %$5))
; %$4 -> u64
; (let %$6 (index %result 1))
; %$6 -> u64*
; (store %$4 %$6)
; (let %$7 (load %result))
; %$7 -> %struct.String
; (return %$7)
; def @String.makeFromStringView env
; %other -> %struct.StringView*
; (let %$0 (index %other 1))
; %$0 -> u64*
; (let %len (load %$0))
; %len -> u64
; (auto %result %struct.String)
; %result -> %struct.String*
; (let %$2 (+ 1 %len))
; %$2 -> u64
; (let %$1 (call @malloc (args %$2)))
; %$1 -> i8*
; (let %$3 (index %result 0))
; %$3 -> i8**
; (store %$1 %$3)
; (let %$5 (index %result 0))
; %$5 -> i8**
; (let %$4 (load %$5))
; %$4 -> i8*
; (let %$7 (index %other 0))
; %$7 -> i8**
; (let %$6 (load %$7))
; %$6 -> i8*
; (call @memcpy (args %$4 %$6 %len))
; (let %$12 (index %result 0))
; %$12 -> i8**
; (let %$11 (load %$12))
; %$11 -> i8*
; (let %$10 (cast u64 %$11))
; value: (type-value i8* %$11)
; %$10 -> u64
; (let %$9 (+ %len %$10))
; %$9 -> u64
; (let %$8 (cast i8* %$9))
; value: (type-value u64 %$9)
; %$8 -> i8*
; (store 0 %$8)
; (let %$13 (index %result 1))
; %$13 -> u64*
; (store %len %$13)
; (let %$14 (load %result))
; %$14 -> %struct.String
; (return %$14)
; def @String$ptr.is-empty env
; %this -> %struct.String*
; (let %$2 (index %this 1))
; %$2 -> u64*
; (let %$1 (load %$2))
; %$1 -> u64
; (let %$0 (== 0 %$1))
; %$0 -> i1
; (return %$0)
; def @String$ptr.view env
; %this -> %struct.String*
; (let %$1 (cast %struct.StringView* %this))
; value: (type-value %struct.String* %this)
; %$1 -> %struct.StringView*
; (let %$0 (load %$1))
; %$0 -> %struct.StringView
; (return %$0)
; def @String$ptr.free env
; %this -> %struct.String*
; (let %$1 (index %this 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (call @free (args %$0))
; return-void
; def @String$ptr.setFromChar env
; %this -> %struct.String*
; %c -> i8
; (let %ptr-ref (index %this 0))
; %ptr-ref -> i8**
; (let %size-ref (index %this 1))
; %size-ref -> u64*
; (let %ptr (call @malloc (args 2)))
; %ptr -> i8*
; (store %c %ptr)
; (let %$2 (cast u64 %ptr))
; value: (type-value i8* %ptr)
; %$2 -> u64
; (let %$1 (+ 1 %$2))
; %$1 -> u64
; (let %$0 (cast i8* %$1))
; value: (type-value u64 %$1)
; %$0 -> i8*
; (store 0 %$0)
; (store %ptr %ptr-ref)
; (store 1 %size-ref)
; return-void
; def @String$ptr.append env
; %this -> %struct.String*
; %other -> %struct.String*
; (let %same-string (== %this %other))
; %same-string -> i1
; (if %same-string (do (auto %temp-copy %struct.String) (let %$0 (call @String$ptr.copyalloc (args %other))) (store %$0 %temp-copy) (call @String$ptr.append (args %this %temp-copy)) (let %$2 (index %temp-copy 0)) (let %$1 (load %$2)) (call @free (args %$1)) return-void))
; (auto %temp-copy %struct.String)
; %temp-copy -> %struct.String*
; (let %$0 (call @String$ptr.copyalloc (args %other)))
; %$0 -> %struct.String
; (store %$0 %temp-copy)
; (call @String$ptr.append (args %this %temp-copy))
; (let %$2 (index %temp-copy 0))
; %$2 -> i8**
; (let %$1 (load %$2))
; %$1 -> i8*
; (call @free (args %$1))
; return-void
; (let %$3 (index %this 1))
; %$3 -> u64*
; (let %old-length (load %$3))
; %old-length -> u64
; (let %$5 (index %other 1))
; %$5 -> u64*
; (let %$4 (load %$5))
; %$4 -> u64
; (let %new-length (+ %old-length %$4))
; %new-length -> u64
; (let %$8 (index %this 0))
; %$8 -> i8**
; (let %$7 (load %$8))
; %$7 -> i8*
; (let %$9 (+ 1 %new-length))
; %$9 -> u64
; (let %$6 (call @realloc (args %$7 %$9)))
; %$6 -> i8*
; (let %$10 (index %this 0))
; %$10 -> i8**
; (store %$6 %$10)
; (let %end-of-this-string (call @String$ptr.end (args %this)))
; %end-of-this-string -> i8*
; (let %$11 (index %this 1))
; %$11 -> u64*
; (store %new-length %$11)
; (let %$13 (index %other 0))
; %$13 -> i8**
; (let %$12 (load %$13))
; %$12 -> i8*
; (let %$15 (index %other 1))
; %$15 -> u64*
; (let %$14 (load %$15))
; %$14 -> u64
; (call @memcpy (args %end-of-this-string %$12 %$14))
; return-void
; def @String$ptr.prepend env
; %this -> %struct.String*
; %other -> %struct.String*
; (let %same-string (== %this %other))
; %same-string -> i1
; (if %same-string (do (auto %temp-copy %struct.String) (let %$0 (call @String$ptr.copyalloc (args %other))) (store %$0 %temp-copy) (call @String$ptr.append (args %this %temp-copy)) (let %$2 (index %temp-copy 0)) (let %$1 (load %$2)) (call @free (args %$1)) return-void))
; (auto %temp-copy %struct.String)
; %temp-copy -> %struct.String*
; (let %$0 (call @String$ptr.copyalloc (args %other)))
; %$0 -> %struct.String
; (store %$0 %temp-copy)
; (call @String$ptr.append (args %this %temp-copy))
; (let %$2 (index %temp-copy 0))
; %$2 -> i8**
; (let %$1 (load %$2))
; %$1 -> i8*
; (call @free (args %$1))
; return-void
; (let %$3 (index %this 1))
; %$3 -> u64*
; (let %old-length (load %$3))
; %old-length -> u64
; (let %$4 (index %other 1))
; %$4 -> u64*
; (let %other-length (load %$4))
; %other-length -> u64
; (let %new-length (+ %old-length %other-length))
; %new-length -> u64
; (let %$5 (index %this 1))
; %$5 -> u64*
; (store %new-length %$5)
; (let %$8 (index %this 0))
; %$8 -> i8**
; (let %$7 (load %$8))
; %$7 -> i8*
; (let %$9 (+ 1 %new-length))
; %$9 -> u64
; (let %$6 (call @realloc (args %$7 %$9)))
; %$6 -> i8*
; (let %$10 (index %this 0))
; %$10 -> i8**
; (store %$6 %$10)
; (let %$11 (index %this 0))
; %$11 -> i8**
; (let %new-start (load %$11))
; %new-start -> i8*
; (let %$12 (index %other 0))
; %$12 -> i8**
; (let %other-start (load %$12))
; %other-start -> i8*
; (let %$14 (cast u64 %new-start))
; value: (type-value i8* %new-start)
; %$14 -> u64
; (let %$13 (+ %other-length %$14))
; %$13 -> u64
; (let %midpoint (cast i8* %$13))
; value: (type-value u64 %$13)
; %midpoint -> i8*
; (call @memmove (args %midpoint %new-start %old-length))
; (call @memcpy (args %new-start %other-start %other-length))
; return-void
; def @String.add env
; %left -> %struct.String*
; %right -> %struct.String*
; (auto %result %struct.String)
; %result -> %struct.String*
; (let %$0 (call @String$ptr.copyalloc (args %left)))
; %$0 -> %struct.String
; (store %$0 %result)
; (call @String$ptr.append (args %result %right))
; (let %$1 (load %result))
; %$1 -> %struct.String
; (return %$1)
; def @String$ptr.end env
; %this -> %struct.String*
; (let %$0 (index %this 0))
; %$0 -> i8**
; (let %begin (load %$0))
; %begin -> i8*
; (let %$1 (index %this 1))
; %$1 -> u64*
; (let %length (load %$1))
; %length -> u64
; (let %$3 (cast u64 %begin))
; value: (type-value i8* %begin)
; %$3 -> u64
; (let %$2 (+ %$3 %length))
; %$2 -> u64
; (let %one-past-last (cast i8* %$2))
; value: (type-value u64 %$2)
; %one-past-last -> i8*
; (return %one-past-last)
; def @String$ptr.pushChar env
; %this -> %struct.String*
; %c -> i8
; (let %ptr-ref (index %this 0))
; %ptr-ref -> i8**
; (let %size-ref (index %this 1))
; %size-ref -> u64*
; (let %$2 (load %ptr-ref))
; %$2 -> i8*
; (let %$1 (cast u64 %$2))
; value: (type-value i8* %$2)
; %$1 -> u64
; (let %$0 (== 0 %$1))
; %$0 -> i1
; (if %$0 (do (call-tail @String$ptr.setFromChar (args %this %c)) return-void))
; (call-tail @String$ptr.setFromChar (args %this %c))
; return-void
; (let %old-size (load %size-ref))
; %old-size -> u64
; (let %$4 (load %ptr-ref))
; %$4 -> i8*
; (let %$5 (+ 2 %old-size))
; %$5 -> u64
; (let %$3 (call @realloc (args %$4 %$5)))
; %$3 -> i8*
; (store %$3 %ptr-ref)
; (let %$6 (+ 1 %old-size))
; %$6 -> u64
; (store %$6 %size-ref)
; (let %$9 (load %ptr-ref))
; %$9 -> i8*
; (let %$8 (cast u64 %$9))
; value: (type-value i8* %$9)
; %$8 -> u64
; (let %$7 (+ %old-size %$8))
; %$7 -> u64
; (let %new-char-loc (cast i8* %$7))
; value: (type-value u64 %$7)
; %new-char-loc -> i8*
; (store %c %new-char-loc)
; return-void
; def @reverse-pair env
; %begin -> i8*
; %end -> i8*
; (let %$1 (cast u64 %begin))
; value: (type-value i8* %begin)
; %$1 -> u64
; (let %$2 (cast u64 %end))
; value: (type-value i8* %end)
; %$2 -> u64
; (let %$0 (>= %$1 %$2))
; %$0 -> i1
; (if %$0 (do return-void))
; return-void
; (call @i8$ptr.swap (args %begin %end))
; (let %$4 (cast u64 %begin))
; value: (type-value i8* %begin)
; %$4 -> u64
; (let %$3 (+ %$4 1))
; %$3 -> u64
; (let %next-begin (cast i8* %$3))
; value: (type-value u64 %$3)
; %next-begin -> i8*
; (let %$6 (cast u64 %end))
; value: (type-value i8* %end)
; %$6 -> u64
; (let %$5 (- %$6 1))
; %$5 -> u64
; (let %next-end (cast i8* %$5))
; value: (type-value u64 %$5)
; %next-end -> i8*
; (call-tail @reverse-pair (args %next-begin %next-end))
; return-void
; def @String$ptr.reverse-in-place env
; %this -> %struct.String*
; (let %$0 (index %this 0))
; %$0 -> i8**
; (let %begin (load %$0))
; %begin -> i8*
; (let %$1 (index %this 1))
; %$1 -> u64*
; (let %size (load %$1))
; %size -> u64
; (let %$2 (== 0 %size))
; %$2 -> i1
; (if %$2 (do return-void))
; return-void
; (let %$4 (- %size 1))
; %$4 -> u64
; (let %$5 (cast u64 %begin))
; value: (type-value i8* %begin)
; %$5 -> u64
; (let %$3 (+ %$4 %$5))
; %$3 -> u64
; (let %end (cast i8* %$3))
; value: (type-value u64 %$3)
; %end -> i8*
; (call-tail @reverse-pair (args %begin %end))
; return-void
; def @String$ptr.char-at-unsafe env
; %this -> %struct.String*
; %i -> u64
; (let %$0 (index %this 0))
; %$0 -> i8**
; (let %begin (load %$0))
; %begin -> i8*
; (let %$4 (cast u64 %begin))
; value: (type-value i8* %begin)
; %$4 -> u64
; (let %$3 (+ %i %$4))
; %$3 -> u64
; (let %$2 (cast i8* %$3))
; value: (type-value u64 %$3)
; %$2 -> i8*
; (let %$1 (load %$2))
; %$1 -> i8
; (return %$1)
; def @String$ptr.print env
; %this -> %struct.String*
; (let %$1 (index %this 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (let %$3 (index %this 1))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (call @i8$ptr.printn (args %$0 %$2))
; return-void
; def @String$ptr.println env
; %this -> %struct.String*
; (let %$1 (index %this 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (let %$3 (index %this 1))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (call @i8$ptr.printn (args %$0 %$2))
; (call @println args)
; return-void
; def @test.strlen env
; (let %str-example (str-get 0))
; %str-example -> i8*
; (let %$0 (call @i8$ptr.length (args (str-get 3))))
; %$0 -> u64
; (call-vargs @printf (args (str-get 1) (str-get 2) %$0))
; return-void
; def @test.strview env
; (auto %string-view %struct.StringView)
; %string-view -> %struct.StringView*
; (let %$0 (call @StringView.makeEmpty args))
; %$0 -> %struct.StringView
; (store %$0 %string-view)
; (call @StringView$ptr.set (args %string-view (str-get 4)))
; (let %$2 (index %string-view 0))
; %$2 -> i8**
; (let %$1 (load %$2))
; %$1 -> i8*
; (let %$4 (index %string-view 1))
; %$4 -> u64*
; (let %$3 (load %$4))
; %$3 -> u64
; (call-vargs @printf (args (str-get 5) %$1 %$3))
; return-void
; def @test.basic-string env
; (auto %string %struct.String)
; %string -> %struct.String*
; (call @String$ptr.set (args %string (str-get 6)))
; (let %$1 (index %string 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (let %$3 (index %string 1))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (call-vargs @printf (args (str-get 7) %$0 %$2))
; return-void
; def @test.string-self-append env
; (auto %string %struct.String)
; %string -> %struct.String*
; (call @String$ptr.set (args %string (str-get 8)))
; (call @String$ptr.append (args %string %string))
; (let %$1 (index %string 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (call @puts (args %$0))
; return-void
; def @test.string-append-helloworld env
; (auto %hello %struct.String)
; %hello -> %struct.String*
; (call @String$ptr.set (args %hello (str-get 9)))
; (auto %world %struct.String)
; %world -> %struct.String*
; (call @String$ptr.set (args %world (str-get 10)))
; (call @String$ptr.append (args %hello %world))
; (let %$1 (index %hello 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (call @puts (args %$0))
; return-void
; def @test.string-pushchar env
; (auto %acc %struct.String)
; %acc -> %struct.String*
; (let %$0 (call @String.makeEmpty args))
; %$0 -> %struct.String
; (store %$0 %acc)
; (let %A (+ 65 (0 i8)))
; %A -> i8
; (call @String$ptr.pushChar (args %acc %A))
; (let %$2 (index %acc 0))
; %$2 -> i8**
; (let %$1 (load %$2))
; %$1 -> i8*
; (call @puts (args %$1))
; (call @String$ptr.pushChar (args %acc %A))
; (let %$4 (index %acc 0))
; %$4 -> i8**
; (let %$3 (load %$4))
; %$3 -> i8*
; (call @puts (args %$3))
; (call @String$ptr.pushChar (args %acc %A))
; (let %$6 (index %acc 0))
; %$6 -> i8**
; (let %$5 (load %$6))
; %$5 -> i8*
; (call @puts (args %$5))
; return-void
; def @test.string-reverse-in-place env
; (auto %acc %struct.String)
; %acc -> %struct.String*
; (let %$0 (call @String.makeEmpty args))
; %$0 -> %struct.String
; (store %$0 %acc)
; (let %A (+ 65 (0 i8)))
; %A -> i8
; (call @String$ptr.pushChar (args %acc %A))
; (let %$2 (index %acc 0))
; %$2 -> i8**
; (let %$1 (load %$2))
; %$1 -> i8*
; (call @puts (args %$1))
; (let %$3 (+ 1 %A))
; %$3 -> i8
; (call @String$ptr.pushChar (args %acc %$3))
; (let %$5 (index %acc 0))
; %$5 -> i8**
; (let %$4 (load %$5))
; %$4 -> i8*
; (call @puts (args %$4))
; (let %$6 (+ 2 %A))
; %$6 -> i8
; (call @String$ptr.pushChar (args %acc %$6))
; (let %$8 (index %acc 0))
; %$8 -> i8**
; (let %$7 (load %$8))
; %$7 -> i8*
; (call @puts (args %$7))
; (let %$9 (index %acc 0))
; %$9 -> i8**
; (let %begin (load %$9))
; %begin -> i8*
; (let %$10 (index %acc 1))
; %$10 -> u64*
; (let %size (load %$10))
; %size -> u64
; (let %$12 (- %size 1))
; %$12 -> u64
; (let %$13 (cast u64 %begin))
; value: (type-value i8* %begin)
; %$13 -> u64
; (let %$11 (+ %$12 %$13))
; %$11 -> u64
; (let %end (cast i8* %$11))
; value: (type-value u64 %$11)
; %end -> i8*
; (call @u64.print (args %size))
; (let %$14 (load %begin))
; %$14 -> i8
; (call @i8.print (args %$14))
; (let %$15 (load %end))
; %$15 -> i8
; (call @i8.print (args %$15))
; (call @println args)
; (call @i8$ptr.swap (args %begin %end))
; (let %$17 (index %acc 0))
; %$17 -> i8**
; (let %$16 (load %$17))
; %$16 -> i8*
; (call @puts (args %$16))
; (call @String$ptr.reverse-in-place (args %acc))
; (let %$19 (index %acc 0))
; %$19 -> i8**
; (let %$18 (load %$19))
; %$18 -> i8*
; (call @puts (args %$18))
; return-void
; def @test.stringview-nonpointer-eq env
; (let %$0 (call @StringView.makeFromi8$ptr (args (str-get 11))))
; %$0 -> %struct.StringView
; (let %$1 (call @StringView.makeFromi8$ptr (args (str-get 12))))
; %$1 -> %struct.StringView
; (let %passed (call @StringView.eq (args %$0 %$1)))
; %passed -> i1
; (if %passed (do (call @puts (args (str-get 13))) return-void))
; (call @puts (args (str-get 13)))
; return-void
; (call @puts (args (str-get 14)))
; return-void
; def @test.string-prepend-helloworld env
; (auto %hello %struct.String)
; %hello -> %struct.String*
; (call @String$ptr.set (args %hello (str-get 15)))
; (auto %world %struct.String)
; %world -> %struct.String*
; (call @String$ptr.set (args %world (str-get 16)))
; (call @String$ptr.prepend (args %world %hello))
; (call @String$ptr.println (args %world))
; (call @String$ptr.free (args %world))
; (call @String$ptr.free (args %hello))
; return-void
; def @File._open env
; %filename-view -> %struct.StringView*
; %flags -> i32
; (auto %result %struct.File)
; %result -> %struct.File*
; (let %$0 (index %filename-view 0))
; %$0 -> i8**
; (let %filename (load %$0))
; %filename -> i8*
; (let %$1 (call @String.makeFromStringView (args %filename-view)))
; %$1 -> %struct.String
; (let %$2 (index %result 0))
; %$2 -> %struct.String*
; (store %$1 %$2)
; (let %fd (call-vargs @open (args %filename %flags)))
; %fd -> i32
; (let %$4 (- (0 i32) 1))
; %$4 -> i32
; (let %$3 (== %fd %$4))
; %$3 -> i1
; (if %$3 (do (call-vargs @printf (args (str-get 17) %filename)) (call @exit (args 1))))
; (call-vargs @printf (args (str-get 17) %filename))
; (call @exit (args 1))
; (let %$5 (index %result 1))
; %$5 -> i32*
; (store %fd %$5)
; (let %$6 (load %result))
; %$6 -> %struct.File
; (return %$6)
; def @File.open env
; %filename-view -> %struct.StringView*
; (let %O_RDONLY (+ 0 (0 i32)))
; %O_RDONLY -> i32
; (let %$0 (call @File._open (args %filename-view %O_RDONLY)))
; %$0 -> %struct.File
; (return %$0)
; def @File.openrw env
; %filename-view -> %struct.StringView*
; (let %O_RDWR (+ 2 (0 i32)))
; %O_RDWR -> i32
; (let %$0 (call @File._open (args %filename-view %O_RDWR)))
; %$0 -> %struct.File
; (return %$0)
; def @File$ptr.getSize env
; %this -> %struct.File*
; (let %SEEK_END (+ 2 (0 i32)))
; %SEEK_END -> i32
; (let %$2 (index %this 1))
; %$2 -> i32*
; (let %$1 (load %$2))
; %$1 -> i32
; (let %$0 (call @lseek (args %$1 0 %SEEK_END)))
; %$0 -> i64
; (return %$0)
; def @File$ptr._mmap env
; %this -> %struct.File*
; %addr -> i8*
; %file-length -> i64
; %prot -> i32
; %flags -> i32
; %offset -> i64
; (let %$1 (index %this 1))
; %$1 -> i32*
; (let %$0 (load %$1))
; %$0 -> i32
; (let %result (call @mmap (args %addr %file-length %prot %flags %$0 %offset)))
; %result -> i8*
; (let %$3 (- (0 u64) 1))
; %$3 -> u64
; (let %$4 (cast u64 %result))
; value: (type-value i8* %result)
; %$4 -> u64
; (let %$2 (== %$3 %$4))
; %$2 -> i1
; (if %$2 (do (call @perror (args (str-get 18))) (call @exit (args 0))))
; (call @perror (args (str-get 18)))
; (call @exit (args 0))
; (return %result)
; def @File$ptr.read env
; %this -> %struct.File*
; (let %PROT_READ (+ 1 (0 i32)))
; %PROT_READ -> i32
; (let %MAP_PRIVATE (+ 2 (0 i32)))
; %MAP_PRIVATE -> i32
; (let %file-length (call @File$ptr.getSize (args %this)))
; %file-length -> i64
; (let %$0 (cast i8* (0 u64)))
; value: (type-value u64 0)
; %$0 -> i8*
; (let %char-ptr (call @File$ptr._mmap (args %this %$0 %file-length %PROT_READ %MAP_PRIVATE 0)))
; %char-ptr -> i8*
; (let %$1 (call @StringView.make (args %char-ptr %file-length)))
; %$1 -> %struct.StringView
; (return %$1)
; def @File$ptr.readwrite env
; %this -> %struct.File*
; (let %PROT_RDWR (+ 3 (0 i32)))
; %PROT_RDWR -> i32
; (let %MAP_PRIVATE (+ 2 (0 i32)))
; %MAP_PRIVATE -> i32
; (let %file-length (call @File$ptr.getSize (args %this)))
; %file-length -> i64
; (let %$0 (cast i8* (0 u64)))
; value: (type-value u64 0)
; %$0 -> i8*
; (let %char-ptr (call @File$ptr._mmap (args %this %$0 %file-length %PROT_RDWR %MAP_PRIVATE 0)))
; %char-ptr -> i8*
; (let %$1 (call @StringView.make (args %char-ptr %file-length)))
; %$1 -> %struct.StringView
; (return %$1)
; def @File.unread env
; %view -> %struct.StringView*
; (let %$1 (index %view 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (let %$3 (index %view 1))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (call @munmap (args %$0 %$2))
; return-void
; def @File$ptr.close env
; %this -> %struct.File*
; (let %$1 (index %this 1))
; %$1 -> i32*
; (let %$0 (load %$1))
; %$0 -> i32
; (call @close (args %$0))
; return-void
; def @test.file-cat env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 19)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.open (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (let %$1 (index %file 0))
; %$1 -> %struct.String*
; (call @String$ptr.println (args %$1))
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$2 (call @File$ptr.read (args %file)))
; %$2 -> %struct.StringView
; (store %$2 %content)
; (call @StringView$ptr.print (args %content))
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @test.file-size env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 20)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.open (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (let %size (call @File$ptr.getSize (args %file)))
; %size -> i64
; (call-vargs @printf (args (str-get 21) %size))
; (call @File$ptr.close (args %file))
; return-void
; def @test.bad-file-open env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 22)))
; (call @File.open (args %filename))
; return-void
; def @Reader$ptr.set env
; %this -> %struct.Reader*
; %string-view -> %struct.StringView*
; (let %$0 (load %string-view))
; %$0 -> %struct.StringView
; (let %$1 (index %this 0))
; %$1 -> %struct.StringView*
; (store %$0 %$1)
; (let %content (index %this 0))
; %content -> %struct.StringView*
; (let %$3 (index %string-view 0))
; %$3 -> i8**
; (let %$2 (load %$3))
; %$2 -> i8*
; (let %$4 (index %this 1))
; %$4 -> i8**
; (store %$2 %$4)
; (let %$5 (index %this 2))
; %$5 -> i8*
; (store 0 %$5)
; (let %$6 (index %this 3))
; %$6 -> u64*
; (store 0 %$6)
; (let %$7 (index %this 4))
; %$7 -> u64*
; (store 0 %$7)
; return-void
; def @Reader$ptr.peek env
; %this -> %struct.Reader*
; (let %$2 (index %this 1))
; %$2 -> i8**
; (let %$1 (load %$2))
; %$1 -> i8*
; (let %$0 (load %$1))
; %$0 -> i8
; (return %$0)
; def @Reader$ptr.get env
; %this -> %struct.Reader*
; (let %iter-ref (index %this 1))
; %iter-ref -> i8**
; (let %$0 (load %iter-ref))
; %$0 -> i8*
; (let %char (load %$0))
; %char -> i8
; (let %$1 (index %this 2))
; %$1 -> i8*
; (store %char %$1)
; (let %$5 (load %iter-ref))
; %$5 -> i8*
; (let %$4 (cast u64 %$5))
; value: (type-value i8* %$5)
; %$4 -> u64
; (let %$3 (+ 1 %$4))
; %$3 -> u64
; (let %$2 (cast i8* %$3))
; value: (type-value u64 %$3)
; %$2 -> i8*
; (store %$2 %iter-ref)
; (let %NEWLINE (+ 10 (0 i8)))
; %NEWLINE -> i8
; (let %$6 (== %char %NEWLINE))
; %$6 -> i1
; (if %$6 (do (let %$9 (index %this 3)) (let %$8 (load %$9)) (let %$7 (+ 1 %$8)) (let %$10 (index %this 3)) (store %$7 %$10) (let %$11 (index %this 4)) (store 0 %$11) (return %char)))
; (let %$9 (index %this 3))
; %$9 -> u64*
; (let %$8 (load %$9))
; %$8 -> u64
; (let %$7 (+ 1 %$8))
; %$7 -> u64
; (let %$10 (index %this 3))
; %$10 -> u64*
; (store %$7 %$10)
; (let %$11 (index %this 4))
; %$11 -> u64*
; (store 0 %$11)
; (return %char)
; (let %$14 (index %this 4))
; %$14 -> u64*
; (let %$13 (load %$14))
; %$13 -> u64
; (let %$12 (+ 1 %$13))
; %$12 -> u64
; (let %$15 (index %this 4))
; %$15 -> u64*
; (store %$12 %$15)
; (return %char)
; def @Reader$ptr.seek-backwards-on-line env
; %this -> %struct.Reader*
; %line -> u64
; %col -> u64
; (let %col-ref (index %this 4))
; %col-ref -> u64*
; (let %$0 (index %this 4))
; %$0 -> u64*
; (let %curr-col (load %$0))
; %curr-col -> u64
; (let %anti-offset (- %curr-col %col))
; %anti-offset -> u64
; (let %$5 (index %this 1))
; %$5 -> i8**
; (let %$4 (load %$5))
; %$4 -> i8*
; (let %$3 (cast u64 %$4))
; value: (type-value i8* %$4)
; %$3 -> u64
; (let %$2 (- %$3 %anti-offset))
; %$2 -> u64
; (let %$1 (cast i8* %$2))
; value: (type-value u64 %$2)
; %$1 -> i8*
; (let %$6 (index %this 1))
; %$6 -> i8**
; (store %$1 %$6)
; (let %$7 (index %this 4))
; %$7 -> u64*
; (store %col %$7)
; return-void
; def @Reader$ptr.seek-forwards.fail env
; %this -> %struct.Reader*
; %line -> u64
; %col -> u64
; %msg -> i8*
; (call @i8$ptr.unsafe-print (args %msg))
; (call @i8$ptr.unsafe-print (args (str-get 23)))
; (let %$1 (index %this 3))
; %$1 -> u64*
; (let %$0 (load %$1))
; %$0 -> u64
; (call @u64.print (args %$0))
; (call @i8$ptr.unsafe-print (args (str-get 24)))
; (let %$3 (index %this 4))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (call @u64.print (args %$2))
; (call @i8$ptr.unsafe-print (args (str-get 25)))
; (call @u64.print (args %line))
; (call @i8$ptr.unsafe-print (args (str-get 26)))
; (call @u64.print (args %col))
; (call @println args)
; (call @exit (args 1))
; return-void
; def @Reader$ptr.seek-forwards env
; %this -> %struct.Reader*
; %line -> u64
; %col -> u64
; (let %curr-line (index %this 3))
; %curr-line -> u64*
; (let %curr-col (index %this 4))
; %curr-col -> u64*
; (let %$1 (load %curr-line))
; %$1 -> u64
; (let %$0 (== %line %$1))
; %$0 -> i1
; (if %$0 (do (let %$3 (load %curr-col)) (let %$2 (== %col %$3)) (if %$2 (do return-void)) (let %$5 (load %curr-col)) (let %$4 (< %col %$5)) (if %$4 (do (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 27))))) (let %$7 (load %curr-col)) (let %$6 (> %col %$7)) (if %$6 (do (call @Reader$ptr.get (args %this)) (let %$9 (load %curr-line)) (let %$8 (< %line %$9)) (if %$8 (do (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 28))))) (call @Reader$ptr.seek-forwards (args %this %line %col)) return-void))))
; (let %$3 (load %curr-col))
; %$3 -> u64
; (let %$2 (== %col %$3))
; %$2 -> i1
; (if %$2 (do return-void))
; return-void
; (let %$5 (load %curr-col))
; %$5 -> u64
; (let %$4 (< %col %$5))
; %$4 -> i1
; (if %$4 (do (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 27)))))
; (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 27)))
; (let %$7 (load %curr-col))
; %$7 -> u64
; (let %$6 (> %col %$7))
; %$6 -> i1
; (if %$6 (do (call @Reader$ptr.get (args %this)) (let %$9 (load %curr-line)) (let %$8 (< %line %$9)) (if %$8 (do (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 28))))) (call @Reader$ptr.seek-forwards (args %this %line %col)) return-void))
; (call @Reader$ptr.get (args %this))
; (let %$9 (load %curr-line))
; %$9 -> u64
; (let %$8 (< %line %$9))
; %$8 -> i1
; (if %$8 (do (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 28)))))
; (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 28)))
; (call @Reader$ptr.seek-forwards (args %this %line %col))
; return-void
; (let %$10 (call @Reader$ptr.done (args %this)))
; %$10 -> i1
; (if %$10 (do (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 29)))))
; (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 29)))
; (let %$12 (load %curr-line))
; %$12 -> u64
; (let %$11 (< %line %$12))
; %$11 -> i1
; (if %$11 (do (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 30)))))
; (call @Reader$ptr.seek-forwards.fail (args %this %line %col (str-get 30)))
; (call @Reader$ptr.get (args %this))
; (call @Reader$ptr.seek-forwards (args %this %line %col))
; return-void
; def @Reader$ptr.find-next env
; %this -> %struct.Reader*
; %char -> i8
; (let %$0 (call @Reader$ptr.done (args %this)))
; %$0 -> i1
; (if %$0 (do (call @i8$ptr.unsafe-println (args (str-get 31))) (call @exit (args 1))))
; (call @i8$ptr.unsafe-println (args (str-get 31)))
; (call @exit (args 1))
; (let %peeked (call @Reader$ptr.peek (args %this)))
; %peeked -> i8
; (let %$1 (== %char %peeked))
; %$1 -> i1
; (if %$1 (do return-void))
; return-void
; (call @Reader$ptr.get (args %this))
; (call @Reader$ptr.find-next (args %this %char))
; return-void
; def @Reader$ptr.pos env
; %this -> %struct.Reader*
; (let %$0 (index %this 1))
; %$0 -> i8**
; (let %iter (load %$0))
; %iter -> i8*
; (let %$2 (index %this 0))
; %$2 -> %struct.StringView*
; (let %$1 (index %$2 0))
; %$1 -> i8**
; (let %start (load %$1))
; %start -> i8*
; (let %$3 (cast u64 %iter))
; value: (type-value i8* %iter)
; %$3 -> u64
; (let %$4 (cast u64 %start))
; value: (type-value i8* %start)
; %$4 -> u64
; (let %result (- %$3 %$4))
; %result -> u64
; (return %result)
; def @Reader$ptr.done env
; %this -> %struct.Reader*
; (let %content (index %this 0))
; %content -> %struct.StringView*
; (let %$3 (index %content 0))
; %$3 -> i8**
; (let %$2 (load %$3))
; %$2 -> i8*
; (let %$1 (cast u64 %$2))
; value: (type-value i8* %$2)
; %$1 -> u64
; (let %$5 (index %content 1))
; %$5 -> u64*
; (let %$4 (load %$5))
; %$4 -> u64
; (let %$0 (+ %$1 %$4))
; %$0 -> u64
; (let %content-end (cast i8* %$0))
; value: (type-value u64 %$0)
; %content-end -> i8*
; (let %$6 (index %this 1))
; %$6 -> i8**
; (let %iter (load %$6))
; %iter -> i8*
; (let %$7 (== %iter %content-end))
; %$7 -> i1
; (return %$7)
; def @Reader$ptr.reset env
; %this -> %struct.Reader*
; (let %string-view (index %this 0))
; %string-view -> %struct.StringView*
; (let %$1 (index %string-view 0))
; %$1 -> i8**
; (let %$0 (load %$1))
; %$0 -> i8*
; (let %$2 (index %this 1))
; %$2 -> i8**
; (store %$0 %$2)
; (let %$3 (index %this 2))
; %$3 -> i8*
; (store 0 %$3)
; (let %$4 (index %this 3))
; %$4 -> u64*
; (store 0 %$4)
; (let %$5 (index %this 4))
; %$5 -> u64*
; (store 0 %$5)
; return-void
; def @test.Reader-get$lambda0 env
; %reader -> %struct.Reader*
; %i -> i32
; (let %$0 (== %i 0))
; %$0 -> i1
; (if %$0 (do return-void))
; return-void
; (let %$1 (call @Reader$ptr.get (args %reader)))
; %$1 -> i8
; (call @i8.print (args %$1))
; (let %$2 (- %i 1))
; %$2 -> i32
; (call-tail @test.Reader-get$lambda0 (args %reader %$2))
; return-void
; def @test.Reader-get env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 32)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.open (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (let %$1 (index %file 0))
; %$1 -> %struct.String*
; (call @String$ptr.println (args %$1))
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$2 (call @File$ptr.read (args %file)))
; %$2 -> %struct.StringView
; (store %$2 %content)
; (auto %reader %struct.Reader)
; %reader -> %struct.Reader*
; (call @Reader$ptr.set (args %reader %content))
; (call @test.Reader-get$lambda0 (args %reader 50))
; (call @println args)
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @test.Reader-done$lambda0 env
; %reader -> %struct.Reader*
; (let %$0 (call @Reader$ptr.get (args %reader)))
; %$0 -> i8
; (call @i8.print (args %$0))
; (let %$2 (call @Reader$ptr.done (args %reader)))
; %$2 -> i1
; (let %$1 (- 1 %$2))
; %$1 -> i1
; (if %$1 (do (call-tail @test.Reader-done$lambda0 (args %reader))))
; (call-tail @test.Reader-done$lambda0 (args %reader))
; return-void
; def @test.Reader-done env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 33)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.open (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (let %$1 (index %file 0))
; %$1 -> %struct.String*
; (call @String$ptr.println (args %$1))
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$2 (call @File$ptr.read (args %file)))
; %$2 -> %struct.StringView
; (store %$2 %content)
; (auto %reader %struct.Reader)
; %reader -> %struct.Reader*
; (call @Reader$ptr.set (args %reader %content))
; (call @test.Reader-done$lambda0 (args %reader))
; (call @println args)
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @u64.string_ env
; %this -> u64
; %acc -> %struct.String*
; (let %$0 (== 0 %this))
; %$0 -> i1
; (if %$0 (do return-void))
; return-void
; (let %ZERO (+ 48 (0 i8)))
; %ZERO -> i8
; (let %top (% %this 10))
; %top -> u64
; (let %$1 (cast i8 %top))
; value: (type-value u64 %top)
; %$1 -> i8
; (let %c (+ %ZERO %$1))
; %c -> i8
; (call @String$ptr.pushChar (args %acc %c))
; (let %rest (/ %this 10))
; %rest -> u64
; (call-tail @u64.string_ (args %rest %acc))
; return-void
; def @u64.string env
; %this -> u64
; (auto %acc %struct.String)
; %acc -> %struct.String*
; (let %$0 (call @String.makeEmpty args))
; %$0 -> %struct.String
; (store %$0 %acc)
; (let %ZERO (+ 48 (0 i8)))
; %ZERO -> i8
; (let %$1 (== 0 %this))
; %$1 -> i1
; (if %$1 (do (call @String$ptr.pushChar (args %acc %ZERO)) (let %$2 (load %acc)) (return %$2)))
; (call @String$ptr.pushChar (args %acc %ZERO))
; (let %$2 (load %acc))
; %$2 -> %struct.String
; (return %$2)
; (call @u64.string_ (args %this %acc))
; (call @String$ptr.reverse-in-place (args %acc))
; (let %$3 (load %acc))
; %$3 -> %struct.String
; (return %$3)
; def @u64.print env
; %this -> u64
; (auto %string %struct.String)
; %string -> %struct.String*
; (let %$0 (call @u64.string (args %this)))
; %$0 -> %struct.String
; (store %$0 %string)
; (call @String$ptr.print (args %string))
; return-void
; def @u64.println env
; %this -> u64
; (call @u64.print (args %this))
; (call @println args)
; return-void
; def @test.u64-print env
; (call @u64.print (args 12408124))
; (call @println args)
; return-void
; def @u64-vector.make env
; (auto %result %struct.u64-vector)
; %result -> %struct.u64-vector*
; (let %$0 (cast u64* (0 u64)))
; value: (type-value u64 0)
; %$0 -> u64*
; (let %$1 (index %result 0))
; %$1 -> u64**
; (store %$0 %$1)
; (let %$2 (index %result 1))
; %$2 -> u64*
; (store 0 %$2)
; (let %$3 (index %result 2))
; %$3 -> u64*
; (store 0 %$3)
; (let %$4 (load %result))
; %$4 -> %struct.u64-vector
; (return %$4)
; def @u64-vector$ptr.push env
; %this -> %struct.u64-vector*
; %item -> u64
; (let %SIZEOF-u64 (+ 8 (0 u64)))
; %SIZEOF-u64 -> u64
; (let %data-ref (index %this 0))
; %data-ref -> u64**
; (let %length-ref (index %this 1))
; %length-ref -> u64*
; (let %cap-ref (index %this 2))
; %cap-ref -> u64*
; (let %$1 (load %length-ref))
; %$1 -> u64
; (let %$2 (load %cap-ref))
; %$2 -> u64
; (let %$0 (== %$1 %$2))
; %$0 -> i1
; (if %$0 (do (let %old-capacity (load %cap-ref)) (let %$3 (== 0 %old-capacity)) (if %$3 (do (store 1 %cap-ref))) (let %$4 (!= 0 %old-capacity)) (if %$4 (do (let %$5 (* 2 %old-capacity)) (store %$5 %cap-ref))) (let %new-capacity (load %cap-ref)) (let %old-data (load %data-ref)) (let %$7 (cast i8* %old-data)) (let %$8 (* %SIZEOF-u64 %new-capacity)) (let %$6 (call @realloc (args %$7 %$8))) (let %new-data (cast u64* %$6)) (let %$9 (index %this 0)) (store %new-data %$9)))
; (let %old-capacity (load %cap-ref))
; %old-capacity -> u64
; (let %$3 (== 0 %old-capacity))
; %$3 -> i1
; (if %$3 (do (store 1 %cap-ref)))
; (store 1 %cap-ref)
; (let %$4 (!= 0 %old-capacity))
; %$4 -> i1
; (if %$4 (do (let %$5 (* 2 %old-capacity)) (store %$5 %cap-ref)))
; (let %$5 (* 2 %old-capacity))
; %$5 -> u64
; (store %$5 %cap-ref)
; (let %new-capacity (load %cap-ref))
; %new-capacity -> u64
; (let %old-data (load %data-ref))
; %old-data -> u64*
; (let %$7 (cast i8* %old-data))
; value: (type-value u64* %old-data)
; %$7 -> i8*
; (let %$8 (* %SIZEOF-u64 %new-capacity))
; %$8 -> u64
; (let %$6 (call @realloc (args %$7 %$8)))
; %$6 -> i8*
; (let %new-data (cast u64* %$6))
; value: (type-value i8* %$6)
; %new-data -> u64*
; (let %$9 (index %this 0))
; %$9 -> u64**
; (store %new-data %$9)
; (let %$10 (load %data-ref))
; %$10 -> u64*
; (let %data-base (cast u64 %$10))
; value: (type-value u64* %$10)
; %data-base -> u64
; (let %$14 (load %length-ref))
; %$14 -> u64
; (let %$13 (cast u64 %$14))
; value: (type-value u64 %$14)
; %$13 -> u64
; (let %$12 (* %SIZEOF-u64 %$13))
; %$12 -> u64
; (let %$11 (+ %data-base %$12))
; %$11 -> u64
; (let %new-child-loc (cast u64* %$11))
; value: (type-value u64 %$11)
; %new-child-loc -> u64*
; (store %item %new-child-loc)
; (let %$16 (load %length-ref))
; %$16 -> u64
; (let %$15 (+ 1 %$16))
; %$15 -> u64
; (store %$15 %length-ref)
; return-void
; def @u64-vector$ptr.print_ env
; %this -> %struct.u64-vector*
; %i -> u64
; (let %$2 (index %this 1))
; %$2 -> u64*
; (let %$1 (load %$2))
; %$1 -> u64
; (let %$0 (== %$1 %i))
; %$0 -> i1
; (if %$0 (do return-void))
; return-void
; (let %COMMA (+ 44 (0 i8)))
; %COMMA -> i8
; (let %SPACE (+ 32 (0 i8)))
; %SPACE -> i8
; (call @i8.print (args %COMMA))
; (call @i8.print (args %SPACE))
; (let %curr (call @u64-vector$ptr.unsafe-get (args %this %i)))
; %curr -> u64
; (call @u64.print (args %curr))
; (let %$3 (+ 1 %i))
; %$3 -> u64
; (call-tail @u64-vector$ptr.print_ (args %this %$3))
; return-void
; def @u64-vector$ptr.print env
; %this -> %struct.u64-vector*
; (let %LBRACKET (+ 91 (0 i8)))
; %LBRACKET -> i8
; (let %RBRACKET (+ 93 (0 i8)))
; %RBRACKET -> i8
; (let %COMMA (+ 44 (0 i8)))
; %COMMA -> i8
; (let %SPACE (+ 32 (0 i8)))
; %SPACE -> i8
; (call @i8.print (args %LBRACKET))
; (let %$2 (index %this 1))
; %$2 -> u64*
; (let %$1 (load %$2))
; %$1 -> u64
; (let %$0 (!= 0 %$1))
; %$0 -> i1
; (if %$0 (do (let %$5 (index %this 0)) (let %$4 (load %$5)) (let %$3 (load %$4)) (call @u64.print (args %$3))))
; (let %$5 (index %this 0))
; %$5 -> u64**
; (let %$4 (load %$5))
; %$4 -> u64*
; (let %$3 (load %$4))
; %$3 -> u64
; (call @u64.print (args %$3))
; (let %$8 (index %this 1))
; %$8 -> u64*
; (let %$7 (load %$8))
; %$7 -> u64
; (let %$6 (!= 0 %$7))
; %$6 -> i1
; (if %$6 (do (call @u64-vector$ptr.print_ (args %this 1))))
; (call @u64-vector$ptr.print_ (args %this 1))
; (call @i8.print (args %RBRACKET))
; return-void
; def @u64-vector$ptr.println env
; %this -> %struct.u64-vector*
; (call @u64-vector$ptr.print (args %this))
; (call @println args)
; return-void
; def @u64-vector$ptr.unsafe-get env
; %this -> %struct.u64-vector*
; %i -> u64
; (let %SIZEOF-u64 (+ 8 (0 u64)))
; %SIZEOF-u64 -> u64
; (let %$3 (* %SIZEOF-u64 %i))
; %$3 -> u64
; (let %$6 (index %this 0))
; %$6 -> u64**
; (let %$5 (load %$6))
; %$5 -> u64*
; (let %$4 (cast u64 %$5))
; value: (type-value u64* %$5)
; %$4 -> u64
; (let %$2 (+ %$3 %$4))
; %$2 -> u64
; (let %$1 (cast u64* %$2))
; value: (type-value u64 %$2)
; %$1 -> u64*
; (let %$0 (load %$1))
; %$0 -> u64
; (return %$0)
; def @u64-vector$ptr.unsafe-put env
; %this -> %struct.u64-vector*
; %i -> u64
; %value -> u64
; (let %SIZEOF-u64 (+ 8 (0 u64)))
; %SIZEOF-u64 -> u64
; (let %$2 (* %SIZEOF-u64 %i))
; %$2 -> u64
; (let %$5 (index %this 0))
; %$5 -> u64**
; (let %$4 (load %$5))
; %$4 -> u64*
; (let %$3 (cast u64 %$4))
; value: (type-value u64* %$4)
; %$3 -> u64
; (let %$1 (+ %$2 %$3))
; %$1 -> u64
; (let %$0 (cast u64* %$1))
; value: (type-value u64 %$1)
; %$0 -> u64*
; (store %value %$0)
; return-void
; def @test.u64-vector-basic env
; (auto %vec %struct.u64-vector)
; %vec -> %struct.u64-vector*
; (let %$0 (call @u64-vector.make args))
; %$0 -> %struct.u64-vector
; (store %$0 %vec)
; (call @u64-vector$ptr.push (args %vec 0))
; (call @u64-vector$ptr.push (args %vec 1))
; (call @u64-vector$ptr.push (args %vec 2))
; (call @u64-vector$ptr.push (args %vec 3))
; (call @u64-vector$ptr.push (args %vec 4))
; (call @u64-vector$ptr.push (args %vec 5))
; (call @u64-vector$ptr.push (args %vec 6))
; (call @u64-vector$ptr.println (args %vec))
; return-void
; def @test.u64-vector-one env
; (auto %vec %struct.u64-vector)
; %vec -> %struct.u64-vector*
; (let %$0 (call @u64-vector.make args))
; %$0 -> %struct.u64-vector
; (store %$0 %vec)
; (call @u64-vector$ptr.push (args %vec 0))
; (call @u64-vector$ptr.println (args %vec))
; return-void
; def @test.u64-vector-empty env
; (auto %vec %struct.u64-vector)
; %vec -> %struct.u64-vector*
; (let %$0 (call @u64-vector.make args))
; %$0 -> %struct.u64-vector
; (store %$0 %vec)
; (call @u64-vector$ptr.println (args %vec))
; return-void
; def @test.u64-vector-put env
; (auto %vec %struct.u64-vector)
; %vec -> %struct.u64-vector*
; (let %$0 (call @u64-vector.make args))
; %$0 -> %struct.u64-vector
; (store %$0 %vec)
; (call @u64-vector$ptr.push (args %vec 0))
; (call @u64-vector$ptr.push (args %vec 1))
; (call @u64-vector$ptr.push (args %vec 2))
; (call @u64-vector$ptr.push (args %vec 3))
; (call @u64-vector$ptr.push (args %vec 4))
; (call @u64-vector$ptr.push (args %vec 5))
; (call @u64-vector$ptr.push (args %vec 6))
; (call @u64-vector$ptr.unsafe-put (args %vec 3 10))
; (call @u64-vector$ptr.println (args %vec))
; return-void
; def @Result.success env
; %texp -> %struct.Texp*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 34))))
; %$0 -> %struct.Texp
; (store %$0 %result)
; (let %$1 (call @Texp$ptr.clone (args %texp)))
; %$1 -> %struct.Texp
; (call @Texp$ptr.push (args %result %$1))
; (let %$2 (load %result))
; %$2 -> %struct.Texp
; (return %$2)
; def @Result.success-from-i8$ptr env
; %cstr -> i8*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 35))))
; %$0 -> %struct.Texp
; (store %$0 %result)
; (let %$1 (call @Texp.makeFromi8$ptr (args %cstr)))
; %$1 -> %struct.Texp
; (call @Texp$ptr.push (args %result %$1))
; (let %$2 (load %result))
; %$2 -> %struct.Texp
; (return %$2)
; def @Result.error env
; %texp -> %struct.Texp*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 36))))
; %$0 -> %struct.Texp
; (store %$0 %result)
; (let %$1 (call @Texp$ptr.clone (args %texp)))
; %$1 -> %struct.Texp
; (call @Texp$ptr.push (args %result %$1))
; (let %$2 (load %result))
; %$2 -> %struct.Texp
; (return %$2)
; def @Result.error-from-view env
; %view -> %struct.StringView*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 37))))
; %$0 -> %struct.Texp
; (store %$0 %result)
; (let %$1 (call @Texp.makeFromStringView (args %view)))
; %$1 -> %struct.Texp
; (call @Texp$ptr.push (args %result %$1))
; (let %$2 (load %result))
; %$2 -> %struct.Texp
; (return %$2)
; def @Result.error-from-i8$ptr env
; %cstr -> i8*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 38))))
; %$0 -> %struct.Texp
; (store %$0 %result)
; (let %$1 (call @Texp.makeFromi8$ptr (args %cstr)))
; %$1 -> %struct.Texp
; (call @Texp$ptr.push (args %result %$1))
; (let %$2 (load %result))
; %$2 -> %struct.Texp
; (return %$2)
; def @Optional.some env
; %texp -> %struct.Texp*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 39))))
; %$0 -> %struct.Texp
; (store %$0 %result)
; (let %$1 (call @Texp$ptr.clone (args %texp)))
; %$1 -> %struct.Texp
; (call @Texp$ptr.push (args %result %$1))
; (let %$2 (load %result))
; %$2 -> %struct.Texp
; (return %$2)
; def @Optional.none env
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 40))))
; %$0 -> %struct.Texp
; (return %$0)
; def @Texp$ptr.setFromString env
; %this -> %struct.Texp*
; %value -> %struct.String*
; (let %$0 (load %value))
; %$0 -> %struct.String
; (let %$1 (index %this 0))
; %$1 -> %struct.String*
; (store %$0 %$1)
; (let %$2 (cast %struct.Texp* (0 u64)))
; value: (type-value u64 0)
; %$2 -> %struct.Texp*
; (let %$3 (index %this 1))
; %$3 -> %struct.Texp**
; (store %$2 %$3)
; (let %$4 (index %this 2))
; %$4 -> u64*
; (store 0 %$4)
; (let %$5 (index %this 3))
; %$5 -> u64*
; (store 0 %$5)
; return-void
; def @Texp.makeEmpty env
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 41))))
; %$0 -> %struct.Texp
; (return %$0)
; def @Texp.makeFromi8$ptr env
; %value-cstr -> i8*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @String.makeFromi8$ptr (args %value-cstr)))
; %$0 -> %struct.String
; (let %$1 (index %result 0))
; %$1 -> %struct.String*
; (store %$0 %$1)
; (let %$2 (cast %struct.Texp* (0 u64)))
; value: (type-value u64 0)
; %$2 -> %struct.Texp*
; (let %$3 (index %result 1))
; %$3 -> %struct.Texp**
; (store %$2 %$3)
; (let %$4 (index %result 2))
; %$4 -> u64*
; (store 0 %$4)
; (let %$5 (index %result 3))
; %$5 -> u64*
; (store 0 %$5)
; (let %$6 (load %result))
; %$6 -> %struct.Texp
; (return %$6)
; def @Texp.makeFromString env
; %value -> %struct.String*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @String$ptr.copyalloc (args %value)))
; %$0 -> %struct.String
; (let %$1 (index %result 0))
; %$1 -> %struct.String*
; (store %$0 %$1)
; (let %$2 (cast %struct.Texp* (0 u64)))
; value: (type-value u64 0)
; %$2 -> %struct.Texp*
; (let %$3 (index %result 1))
; %$3 -> %struct.Texp**
; (store %$2 %$3)
; (let %$4 (index %result 2))
; %$4 -> u64*
; (store 0 %$4)
; (let %$5 (index %result 3))
; %$5 -> u64*
; (store 0 %$5)
; (let %$6 (load %result))
; %$6 -> %struct.Texp
; (return %$6)
; def @Texp.makeFromStringView env
; %value-view -> %struct.StringView*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @String.makeFromStringView (args %value-view)))
; %$0 -> %struct.String
; (let %$1 (index %result 0))
; %$1 -> %struct.String*
; (store %$0 %$1)
; (let %$2 (cast %struct.Texp* (0 u64)))
; value: (type-value u64 0)
; %$2 -> %struct.Texp*
; (let %$3 (index %result 1))
; %$3 -> %struct.Texp**
; (store %$2 %$3)
; (let %$4 (index %result 2))
; %$4 -> u64*
; (store 0 %$4)
; (let %$5 (index %result 3))
; %$5 -> u64*
; (store 0 %$5)
; (let %$6 (load %result))
; %$6 -> %struct.Texp
; (return %$6)
; def @Texp$ptr.push$ptr env
; %this -> %struct.Texp*
; %item -> %struct.Texp*
; (let %SIZEOF-Texp (+ 40 (0 u64)))
; %SIZEOF-Texp -> u64
; (let %children-ref (index %this 1))
; %children-ref -> %struct.Texp**
; (let %length-ref (index %this 2))
; %length-ref -> u64*
; (let %cap-ref (index %this 3))
; %cap-ref -> u64*
; (let %$1 (load %length-ref))
; %$1 -> u64
; (let %$2 (load %cap-ref))
; %$2 -> u64
; (let %$0 (== %$1 %$2))
; %$0 -> i1
; (if %$0 (do (let %old-capacity (load %cap-ref)) (let %$3 (== 0 %old-capacity)) (if %$3 (do (store 1 %cap-ref))) (let %$4 (!= 0 %old-capacity)) (if %$4 (do (let %$5 (* 2 %old-capacity)) (store %$5 %cap-ref))) (let %new-capacity (load %cap-ref)) (let %old-children (load %children-ref)) (let %$7 (cast i8* %old-children)) (let %$8 (* %SIZEOF-Texp %new-capacity)) (let %$6 (call @realloc (args %$7 %$8))) (let %new-children (cast %struct.Texp* %$6)) (let %$9 (index %this 1)) (store %new-children %$9)))
; (let %old-capacity (load %cap-ref))
; %old-capacity -> u64
; (let %$3 (== 0 %old-capacity))
; %$3 -> i1
; (if %$3 (do (store 1 %cap-ref)))
; (store 1 %cap-ref)
; (let %$4 (!= 0 %old-capacity))
; %$4 -> i1
; (if %$4 (do (let %$5 (* 2 %old-capacity)) (store %$5 %cap-ref)))
; (let %$5 (* 2 %old-capacity))
; %$5 -> u64
; (store %$5 %cap-ref)
; (let %new-capacity (load %cap-ref))
; %new-capacity -> u64
; (let %old-children (load %children-ref))
; %old-children -> %struct.Texp*
; (let %$7 (cast i8* %old-children))
; value: (type-value %struct.Texp* %old-children)
; %$7 -> i8*
; (let %$8 (* %SIZEOF-Texp %new-capacity))
; %$8 -> u64
; (let %$6 (call @realloc (args %$7 %$8)))
; %$6 -> i8*
; (let %new-children (cast %struct.Texp* %$6))
; value: (type-value i8* %$6)
; %new-children -> %struct.Texp*
; (let %$9 (index %this 1))
; %$9 -> %struct.Texp**
; (store %new-children %$9)
; (let %$10 (load %children-ref))
; %$10 -> %struct.Texp*
; (let %children-base (cast u64 %$10))
; value: (type-value %struct.Texp* %$10)
; %children-base -> u64
; (let %$14 (load %length-ref))
; %$14 -> u64
; (let %$13 (cast u64 %$14))
; value: (type-value u64 %$14)
; %$13 -> u64
; (let %$12 (* %SIZEOF-Texp %$13))
; %$12 -> u64
; (let %$11 (+ %$12 %children-base))
; %$11 -> u64
; (let %new-child-loc (cast %struct.Texp* %$11))
; value: (type-value u64 %$11)
; %new-child-loc -> %struct.Texp*
; (let %$15 (load %item))
; %$15 -> %struct.Texp
; (store %$15 %new-child-loc)
; (let %$17 (load %length-ref))
; %$17 -> u64
; (let %$16 (+ 1 %$17))
; %$16 -> u64
; (store %$16 %length-ref)
; return-void
; def @Texp$ptr.push env
; %this -> %struct.Texp*
; %item -> %struct.Texp
; (auto %local-item %struct.Texp)
; %local-item -> %struct.Texp*
; (store %item %local-item)
; (call @Texp$ptr.push$ptr (args %this %local-item))
; return-void
; def @Texp$ptr.free$lambda.child-iter env
; %this -> %struct.Texp*
; %child-index -> u64
; (let %SIZEOF-Texp (+ 40 (0 u64)))
; %SIZEOF-Texp -> u64
; (let %$0 (index %this 1))
; %$0 -> %struct.Texp**
; (let %children (load %$0))
; %children -> %struct.Texp*
; (let %$1 (index %this 2))
; %$1 -> u64*
; (let %length (load %$1))
; %length -> u64
; (let %$2 (== %child-index %length))
; %$2 -> i1
; (if %$2 (do return-void))
; return-void
; (let %$4 (* %SIZEOF-Texp %child-index))
; %$4 -> u64
; (let %$5 (cast u64 %children))
; value: (type-value %struct.Texp* %children)
; %$5 -> u64
; (let %$3 (+ %$4 %$5))
; %$3 -> u64
; (let %curr (cast %struct.Texp* %$3))
; value: (type-value u64 %$3)
; %curr -> %struct.Texp*
; (call @Texp$ptr.free (args %curr))
; (let %$6 (+ 1 %child-index))
; %$6 -> u64
; (call-tail @Texp$ptr.free$lambda.child-iter (args %this %$6))
; return-void
; def @Texp$ptr.free env
; %this -> %struct.Texp*
; (let %$0 (index %this 0))
; %$0 -> %struct.String*
; (call @String$ptr.free (args %$0))
; (let %$3 (index %this 1))
; %$3 -> %struct.Texp**
; (let %$2 (load %$3))
; %$2 -> %struct.Texp*
; (let %$1 (cast i8* %$2))
; value: (type-value %struct.Texp* %$2)
; %$1 -> i8*
; (call @free (args %$1))
; (call @Texp$ptr.free$lambda.child-iter (args %this 0))
; return-void
; def @Texp$ptr.demote-free env
; %this -> %struct.Texp*
; (let %$0 (index %this 0))
; %$0 -> %struct.String*
; (call @String$ptr.free (args %$0))
; (let %$1 (index %this 1))
; %$1 -> %struct.Texp**
; (let %child-ref (load %$1))
; %child-ref -> %struct.Texp*
; (let %$2 (load %child-ref))
; %$2 -> %struct.Texp
; (store %$2 %this)
; (let %$3 (cast i8* %child-ref))
; value: (type-value %struct.Texp* %child-ref)
; %$3 -> i8*
; (call @free (args %$3))
; return-void
; def @Texp$ptr.shallow-free env
; %this -> %struct.Texp*
; return-void
; def @Texp$ptr.clone_ env
; %acc -> %struct.Texp*
; %curr -> %struct.Texp*
; %last -> %struct.Texp*
; (let %SIZEOF-Texp (+ 40 (0 u64)))
; %SIZEOF-Texp -> u64
; (let %$0 (call @Texp$ptr.clone (args %curr)))
; %$0 -> %struct.Texp
; (call @Texp$ptr.push (args %acc %$0))
; (let %$1 (== %last %curr))
; %$1 -> i1
; (if %$1 (do return-void))
; return-void
; (let %$3 (cast u64 %curr))
; value: (type-value %struct.Texp* %curr)
; %$3 -> u64
; (let %$2 (+ %SIZEOF-Texp %$3))
; %$2 -> u64
; (let %next (cast %struct.Texp* %$2))
; value: (type-value u64 %$2)
; %next -> %struct.Texp*
; (call @Texp$ptr.clone_ (args %acc %next %last))
; return-void
; def @Texp$ptr.clone env
; %this -> %struct.Texp*
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$1 (index %this 0))
; %$1 -> %struct.String*
; (let %$0 (call @String$ptr.copyalloc (args %$1)))
; %$0 -> %struct.String
; (let %$2 (index %result 0))
; %$2 -> %struct.String*
; (store %$0 %$2)
; (let %$4 (index %result 1))
; %$4 -> %struct.Texp**
; (let %$3 (cast u64* %$4))
; value: (type-value %struct.Texp** %$4)
; %$3 -> u64*
; (store 0 %$3)
; (let %$5 (index %result 2))
; %$5 -> u64*
; (store 0 %$5)
; (let %$6 (index %result 3))
; %$6 -> u64*
; (store 0 %$6)
; (let %$9 (index %this 2))
; %$9 -> u64*
; (let %$8 (load %$9))
; %$8 -> u64
; (let %$7 (!= 0 %$8))
; %$7 -> i1
; (if %$7 (do (let %$11 (index %this 1)) (let %$10 (load %$11)) (let %$12 (call @Texp$ptr.last (args %this))) (call @Texp$ptr.clone_ (args %result %$10 %$12))))
; (let %$11 (index %this 1))
; %$11 -> %struct.Texp**
; (let %$10 (load %$11))
; %$10 -> %struct.Texp*
; (let %$12 (call @Texp$ptr.last (args %this)))
; %$12 -> %struct.Texp*
; (call @Texp$ptr.clone_ (args %result %$10 %$12))
; (let %$13 (load %result))
; %$13 -> %struct.Texp
; (return %$13)
; def @Texp$ptr.parenPrint$lambda.child-iter env
; %this -> %struct.Texp*
; %child-index -> u64
; (let %SIZEOF-Texp (+ 40 (0 u64)))
; %SIZEOF-Texp -> u64
; (let %$0 (index %this 1))
; %$0 -> %struct.Texp**
; (let %children (load %$0))
; %children -> %struct.Texp*
; (let %$1 (index %this 2))
; %$1 -> u64*
; (let %length (load %$1))
; %length -> u64
; (let %$2 (== %child-index %length))
; %$2 -> i1
; (if %$2 (do return-void))
; return-void
; (let %$4 (* %SIZEOF-Texp %child-index))
; %$4 -> u64
; (let %$5 (cast u64 %children))
; value: (type-value %struct.Texp* %children)
; %$5 -> u64
; (let %$3 (+ %$4 %$5))
; %$3 -> u64
; (let %curr (cast %struct.Texp* %$3))
; value: (type-value u64 %$3)
; %curr -> %struct.Texp*
; (let %$6 (!= 0 %child-index))
; %$6 -> i1
; (if %$6 (do (let %SPACE (+ 32 (0 i8))) (call @i8.print (args %SPACE))))
; (let %SPACE (+ 32 (0 i8)))
; %SPACE -> i8
; (call @i8.print (args %SPACE))
; (call @Texp$ptr.parenPrint (args %curr))
; (let %$7 (+ 1 %child-index))
; %$7 -> u64
; (call-tail @Texp$ptr.parenPrint$lambda.child-iter (args %this %$7))
; return-void
; def @Texp$ptr.parenPrint env
; %this -> %struct.Texp*
; (let %$1 (cast u64 %this))
; value: (type-value %struct.Texp* %this)
; %$1 -> u64
; (let %$0 (== 0 %$1))
; %$0 -> i1
; (if %$0 (do (call @i8$ptr.unsafe-print (args (str-get 42))) return-void))
; (call @i8$ptr.unsafe-print (args (str-get 42)))
; return-void
; (let %value-ref (index %this 0))
; %value-ref -> %struct.String*
; (let %$2 (index %this 2))
; %$2 -> u64*
; (let %length (load %$2))
; %length -> u64
; (let %$3 (== 0 %length))
; %$3 -> i1
; (if %$3 (do (call @String$ptr.print (args %value-ref)) return-void))
; (call @String$ptr.print (args %value-ref))
; return-void
; (let %LPAREN (+ 40 (0 i8)))
; %LPAREN -> i8
; (let %RPAREN (+ 41 (0 i8)))
; %RPAREN -> i8
; (let %SPACE (+ 32 (0 i8)))
; %SPACE -> i8
; (call @i8.print (args %LPAREN))
; (call @String$ptr.print (args %value-ref))
; (call @i8.print (args %SPACE))
; (call @Texp$ptr.parenPrint$lambda.child-iter (args %this 0))
; (call @i8.print (args %RPAREN))
; return-void
; def @Texp$ptr.shallow-dump env
; %this -> %struct.Texp*
; (let %$1 (cast u64 %this))
; value: (type-value %struct.Texp* %this)
; %$1 -> u64
; (let %$0 (!= 0 %$1))
; %$0 -> i1
; (if %$0 (do (call @i8$ptr.unsafe-print (args (str-get 43))) (let %$2 (index %this 0)) (call @String$ptr.print (args %$2)) (call @i8$ptr.unsafe-print (args (str-get 44))) (let %$4 (index %this 2)) (let %$3 (load %$4)) (call @u64.print (args %$3)) (call @i8$ptr.unsafe-print (args (str-get 45))) (let %$6 (index %this 3)) (let %$5 (load %$6)) (call @u64.print (args %$5))))
; (call @i8$ptr.unsafe-print (args (str-get 43)))
; (let %$2 (index %this 0))
; %$2 -> %struct.String*
; (call @String$ptr.print (args %$2))
; (call @i8$ptr.unsafe-print (args (str-get 44)))
; (let %$4 (index %this 2))
; %$4 -> u64*
; (let %$3 (load %$4))
; %$3 -> u64
; (call @u64.print (args %$3))
; (call @i8$ptr.unsafe-print (args (str-get 45)))
; (let %$6 (index %this 3))
; %$6 -> u64*
; (let %$5 (load %$6))
; %$5 -> u64
; (call @u64.print (args %$5))
; (let %$8 (cast u64 %this))
; value: (type-value %struct.Texp* %this)
; %$8 -> u64
; (let %$7 (== 0 %$8))
; %$7 -> i1
; (if %$7 (do (call @i8$ptr.unsafe-print (args (str-get 46)))))
; (call @i8$ptr.unsafe-print (args (str-get 46)))
; (call @i8$ptr.unsafe-print (args (str-get 47)))
; (let %$9 (cast u64 %this))
; value: (type-value %struct.Texp* %this)
; %$9 -> u64
; (call @u64.println (args %$9))
; return-void
; def @Texp$ptr.last env
; %this -> %struct.Texp*
; (let %SIZEOF-Texp (+ 40 (0 u64)))
; %SIZEOF-Texp -> u64
; (let %$0 (index %this 2))
; %$0 -> u64*
; (let %len (load %$0))
; %len -> u64
; (let %$1 (index %this 1))
; %$1 -> %struct.Texp**
; (let %first-child (load %$1))
; %first-child -> %struct.Texp*
; (let %$3 (cast u64 %first-child))
; value: (type-value %struct.Texp* %first-child)
; %$3 -> u64
; (let %$5 (- %len 1))
; %$5 -> u64
; (let %$4 (* %SIZEOF-Texp %$5))
; %$4 -> u64
; (let %$2 (+ %$3 %$4))
; %$2 -> u64
; (let %last (cast %struct.Texp* %$2))
; value: (type-value u64 %$2)
; %last -> %struct.Texp*
; (return %last)
; def @Texp$ptr.child env
; %this -> %struct.Texp*
; %i -> u64
; (let %SIZEOF-Texp (+ 40 (0 u64)))
; %SIZEOF-Texp -> u64
; (let %$0 (index %this 1))
; %$0 -> %struct.Texp**
; (let %first-child (load %$0))
; %first-child -> %struct.Texp*
; (let %$2 (cast u64 %first-child))
; value: (type-value %struct.Texp* %first-child)
; %$2 -> u64
; (let %$3 (* %SIZEOF-Texp %i))
; %$3 -> u64
; (let %$1 (+ %$2 %$3))
; %$1 -> u64
; (let %child (cast %struct.Texp* %$1))
; value: (type-value u64 %$1)
; %child -> %struct.Texp*
; (return %child)
; def @Texp$ptr.find_ env
; %this -> %struct.Texp*
; %last -> %struct.Texp*
; %key -> %struct.StringView*
; (let %SIZEOF-Texp (+ 40 (0 u64)))
; %SIZEOF-Texp -> u64
; (let %view (call @Texp$ptr.value-view (args %this)))
; %view -> %struct.StringView*
; (let %$0 (call @StringView$ptr.eq (args %view %key)))
; %$0 -> i1
; (if %$0 (do (return %this)))
; (return %this)
; (let %$1 (== %this %last))
; %$1 -> i1
; (if %$1 (do (let %$2 (cast %struct.Texp* (0 u64))) (return %$2)))
; (let %$2 (cast %struct.Texp* (0 u64)))
; value: (type-value u64 0)
; %$2 -> %struct.Texp*
; (return %$2)
; (let %$4 (cast u64 %this))
; value: (type-value %struct.Texp* %this)
; %$4 -> u64
; (let %$3 (+ %SIZEOF-Texp %$4))
; %$3 -> u64
; (let %next (cast %struct.Texp* %$3))
; value: (type-value u64 %$3)
; %next -> %struct.Texp*
; (let %$5 (call @Texp$ptr.find_ (args %next %last %key)))
; %$5 -> %struct.Texp*
; (return %$5)
; def @Texp$ptr.find env
; %this -> %struct.Texp*
; %key -> %struct.StringView*
; (let %$0 (index %this 1))
; %$0 -> %struct.Texp**
; (let %first (load %$0))
; %first -> %struct.Texp*
; (let %last (call @Texp$ptr.last (args %this)))
; %last -> %struct.Texp*
; (let %$1 (call @Texp$ptr.find_ (args %first %last %key)))
; %$1 -> %struct.Texp*
; (return %$1)
; def @Texp$ptr.is-empty env
; %this -> %struct.Texp*
; (let %$2 (index %this 2))
; %$2 -> u64*
; (let %$1 (load %$2))
; %$1 -> u64
; (let %$0 (== 0 %$1))
; %$0 -> i1
; (return %$0)
; def @Texp$ptr.value-check env
; %this -> %struct.Texp*
; %check -> i8*
; (let %check-view (call @StringView.makeFromi8$ptr (args %check)))
; %check-view -> %struct.StringView
; (let %$0 (index %this 0))
; %$0 -> %struct.String*
; (let %value-view (call @String$ptr.view (args %$0)))
; %value-view -> %struct.StringView
; (let %$1 (call @StringView.eq (args %check-view %value-view)))
; %$1 -> i1
; (return %$1)
; def @Texp$ptr.value-view env
; %this -> %struct.Texp*
; (let %$1 (index %this 0))
; %$1 -> %struct.String*
; (let %$0 (cast %struct.StringView* %$1))
; value: (type-value %struct.String* %$1)
; %$0 -> %struct.StringView*
; (return %$0)
; def @Texp$ptr.value-get env
; %this -> %struct.Texp*
; %i -> u64
; (let %$1 (index %this 0))
; %$1 -> %struct.String*
; (let %$0 (index %$1 0))
; %$0 -> i8**
; (let %value (load %$0))
; %value -> i8*
; (let %$3 (cast u64 %value))
; value: (type-value i8* %value)
; %$3 -> u64
; (let %$2 (+ %i %$3))
; %$2 -> u64
; (let %cptr (cast i8* %$2))
; value: (type-value u64 %$2)
; %cptr -> i8*
; (let %$4 (load %cptr))
; %$4 -> i8
; (return %$4)
; def @test.Texp-basic$lamdba.dump env
; %texp -> %struct.Texp*
; (call @println args)
; (let %$1 (index %texp 2))
; %$1 -> u64*
; (let %$0 (load %$1))
; %$0 -> u64
; (call @u64.print (args %$0))
; (call @Texp$ptr.parenPrint (args %texp))
; (call @println args)
; return-void
; def @test.Texp-basic env
; (auto %hello-string %struct.String)
; %hello-string -> %struct.String*
; (call @String$ptr.set (args %hello-string (str-get 48)))
; (auto %child0-string %struct.String)
; %child0-string -> %struct.String*
; (call @String$ptr.set (args %child0-string (str-get 49)))
; (auto %child1-string %struct.String)
; %child1-string -> %struct.String*
; (call @String$ptr.set (args %child1-string (str-get 50)))
; (auto %child2-string %struct.String)
; %child2-string -> %struct.String*
; (call @String$ptr.set (args %child2-string (str-get 51)))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (call @Texp$ptr.setFromString (args %texp %hello-string))
; (call @test.Texp-basic$lamdba.dump (args %texp))
; (auto %texp-child %struct.Texp)
; %texp-child -> %struct.Texp*
; (call @Texp$ptr.setFromString (args %texp-child %child0-string))
; (call @Texp$ptr.push$ptr (args %texp %texp-child))
; (call @test.Texp-basic$lamdba.dump (args %texp))
; (call @Texp$ptr.setFromString (args %texp-child %child1-string))
; (call @Texp$ptr.push$ptr (args %texp %texp-child))
; (call @test.Texp-basic$lamdba.dump (args %texp))
; (call @Texp$ptr.setFromString (args %texp-child %child2-string))
; (call @Texp$ptr.push$ptr (args %texp %texp-child))
; (call @test.Texp-basic$lamdba.dump (args %texp))
; (call @Texp$ptr.free (args %texp))
; return-void
; def @test.Texp-clone env
; (auto %hello-string %struct.String)
; %hello-string -> %struct.String*
; (call @String$ptr.set (args %hello-string (str-get 52)))
; (auto %child0-string %struct.String)
; %child0-string -> %struct.String*
; (call @String$ptr.set (args %child0-string (str-get 53)))
; (auto %child1-string %struct.String)
; %child1-string -> %struct.String*
; (call @String$ptr.set (args %child1-string (str-get 54)))
; (auto %child2-string %struct.String)
; %child2-string -> %struct.String*
; (call @String$ptr.set (args %child2-string (str-get 55)))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (call @Texp$ptr.setFromString (args %texp %hello-string))
; (call @test.Texp-basic$lamdba.dump (args %texp))
; (auto %texp-child %struct.Texp)
; %texp-child -> %struct.Texp*
; (call @Texp$ptr.setFromString (args %texp-child %child0-string))
; (call @Texp$ptr.push$ptr (args %texp %texp-child))
; (call @test.Texp-basic$lamdba.dump (args %texp))
; (call @Texp$ptr.setFromString (args %texp-child %child1-string))
; (call @Texp$ptr.push$ptr (args %texp %texp-child))
; (call @test.Texp-basic$lamdba.dump (args %texp))
; (call @Texp$ptr.setFromString (args %texp-child %child2-string))
; (call @Texp$ptr.push$ptr (args %texp %texp-child))
; (call @test.Texp-basic$lamdba.dump (args %texp))
; (call @Texp$ptr.free (args %texp))
; return-void
; def @test.Texp-clone-atom env
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 56))))
; %$0 -> %struct.Texp
; (store %$0 %texp)
; (auto %clone %struct.Texp)
; %clone -> %struct.Texp*
; (let %$1 (call @Texp$ptr.clone (args %texp)))
; %$1 -> %struct.Texp
; (store %$1 %clone)
; (let %$4 (index %texp 0))
; %$4 -> %struct.String*
; (let %$3 (index %$4 0))
; %$3 -> i8**
; (let %$2 (cast u64 %$3))
; value: (type-value i8** %$3)
; %$2 -> u64
; (call @u64.print (args %$2))
; (call @i8$ptr.unsafe-print (args (str-get 57)))
; (call @Texp$ptr.shallow-dump (args %texp))
; (call @println args)
; (let %$7 (index %clone 0))
; %$7 -> %struct.String*
; (let %$6 (index %$7 0))
; %$6 -> i8**
; (let %$5 (cast u64 %$6))
; value: (type-value i8** %$6)
; %$5 -> u64
; (call @u64.print (args %$5))
; (call @i8$ptr.unsafe-print (args (str-get 58)))
; (call @Texp$ptr.shallow-dump (args %clone))
; (call @println args)
; return-void
; def @test.Texp-clone-hard env
; (auto %content-view %struct.StringView)
; %content-view -> %struct.StringView*
; (call @StringView$ptr.set (args %content-view (str-get 59)))
; (auto %parser %struct.Parser)
; %parser -> %struct.Parser*
; (let %$0 (cast %struct.Reader* %parser))
; value: (type-value %struct.Parser* %parser)
; %$0 -> %struct.Reader*
; (call @Reader$ptr.set (args %$0 %content-view))
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$1 (call @Parser$ptr.texp (args %parser)))
; %$1 -> %struct.Texp
; (store %$1 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; (auto %clone %struct.Texp)
; %clone -> %struct.Texp*
; (let %$2 (call @Texp$ptr.clone (args %result)))
; %$2 -> %struct.Texp
; (store %$2 %clone)
; (call @Texp$ptr.parenPrint (args %clone))
; (call @println args)
; return-void
; def @test.Texp-value-get env
; (auto %hello-string %struct.String)
; %hello-string -> %struct.String*
; (call @String$ptr.set (args %hello-string (str-get 60)))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (call @Texp$ptr.setFromString (args %texp %hello-string))
; (let %E_CHAR (+ 101 (0 i8)))
; %E_CHAR -> i8
; (let %$0 (call @Texp$ptr.value-get (args %texp 1)))
; %$0 -> i8
; (let %success (== %E_CHAR %$0))
; %success -> i1
; (if %success (do (call @puts (args (str-get 61)))))
; (call @puts (args (str-get 61)))
; (let %$1 (- 1 %success))
; %$1 -> i1
; (if %$1 (do (call @puts (args (str-get 62)))))
; (call @puts (args (str-get 62)))
; (call @Texp$ptr.free (args %texp))
; return-void
; def @test.Texp-program-grammar-eq env
; (auto %grammar-texp %struct.Texp)
; %grammar-texp -> %struct.Texp*
; (let %$0 (call @Parser.parse-file-i8$ptr (args (str-get 63))))
; %$0 -> %struct.Texp
; (store %$0 %grammar-texp)
; (call @Texp$ptr.demote-free (args %grammar-texp))
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$1 (call @StringView.makeFromi8$ptr (args (str-get 64))))
; %$1 -> %struct.StringView
; (store %$1 %start-production)
; (let %first-child (call @Texp$ptr.child (args %grammar-texp 0)))
; %first-child -> %struct.Texp*
; (call @Texp$ptr.parenPrint (args %first-child))
; (call @println args)
; (let %view (call @Texp$ptr.value-view (args %first-child)))
; %view -> %struct.StringView*
; (let %$2 (call @StringView$ptr.eq (args %view %start-production)))
; %$2 -> i1
; (if %$2 (do (call @puts (args (str-get 65))) return-void))
; (call @puts (args (str-get 65)))
; return-void
; (call @puts (args (str-get 66)))
; return-void
; def @test.Texp-find-program-grammar env
; (auto %grammar-texp %struct.Texp)
; %grammar-texp -> %struct.Texp*
; (let %$0 (call @Parser.parse-file-i8$ptr (args (str-get 67))))
; %$0 -> %struct.Texp
; (store %$0 %grammar-texp)
; (call @Texp$ptr.demote-free (args %grammar-texp))
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$1 (call @StringView.makeFromi8$ptr (args (str-get 68))))
; %$1 -> %struct.StringView
; (store %$1 %start-production)
; (let %found-texp (call @Texp$ptr.find (args %grammar-texp %start-production)))
; %found-texp -> %struct.Texp*
; (let %$3 (cast u64 %found-texp))
; value: (type-value %struct.Texp* %found-texp)
; %$3 -> u64
; (let %$2 (== 0 %$3))
; %$2 -> i1
; (if %$2 (do (call @i8$ptr.unsafe-println (args (str-get 69)))))
; (call @i8$ptr.unsafe-println (args (str-get 69)))
; (let %$5 (cast u64 %found-texp))
; value: (type-value %struct.Texp* %found-texp)
; %$5 -> u64
; (let %$4 (!= 0 %$5))
; %$4 -> i1
; (if %$4 (do (call @i8$ptr.unsafe-println (args (str-get 70)))))
; (call @i8$ptr.unsafe-println (args (str-get 70)))
; return-void
; def @test.Texp-makeFromi8$ptr env
; (auto %string %struct.Texp)
; %string -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 71))))
; %$0 -> %struct.Texp
; (store %$0 %string)
; (let %$4 (index %string 0))
; %$4 -> %struct.String*
; (let %$3 (index %$4 1))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (let %$1 (== 10 %$2))
; %$1 -> i1
; (if %$1 (do (call @i8$ptr.unsafe-println (args (str-get 72))) return-void))
; (call @i8$ptr.unsafe-println (args (str-get 72)))
; return-void
; (call @i8$ptr.unsafe-println (args (str-get 73)))
; return-void
; def @test.Texp-value-view env
; (auto %string %struct.Texp)
; %string -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 74))))
; %$0 -> %struct.Texp
; (store %$0 %string)
; (let %value-view (call @Texp$ptr.value-view (args %string)))
; %value-view -> %struct.StringView*
; (let %$3 (index %value-view 1))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (let %$1 (== 10 %$2))
; %$1 -> i1
; (if %$1 (do (call @i8$ptr.unsafe-println (args (str-get 75))) return-void))
; (call @i8$ptr.unsafe-println (args (str-get 75)))
; return-void
; (call @i8$ptr.unsafe-println (args (str-get 76)))
; return-void
; def @i8.isspace env
; %this -> i8
; (let %$0 (== %this 32))
; %$0 -> i1
; (if %$0 (do (return true)))
; (return true)
; (let %$1 (== %this 12))
; %$1 -> i1
; (if %$1 (do (return true)))
; (return true)
; (let %$2 (== %this 10))
; %$2 -> i1
; (if %$2 (do (return true)))
; (return true)
; (let %$3 (== %this 13))
; %$3 -> i1
; (if %$3 (do (return true)))
; (return true)
; (let %$4 (== %this 9))
; %$4 -> i1
; (if %$4 (do (return true)))
; (return true)
; (let %$5 (== %this 11))
; %$5 -> i1
; (if %$5 (do (return true)))
; (return true)
; (return false)
; def @Parser.make env
; %content -> %struct.StringView*
; (auto %result %struct.Parser)
; %result -> %struct.Parser*
; (let %$0 (index %result 0))
; %$0 -> %struct.Reader*
; (call @Reader$ptr.set (args %$0 %content))
; (let %$1 (call @u64-vector.make args))
; %$1 -> %struct.u64-vector
; (let %$2 (index %result 1))
; %$2 -> %struct.u64-vector*
; (store %$1 %$2)
; (let %$3 (call @u64-vector.make args))
; %$3 -> %struct.u64-vector
; (let %$4 (index %result 2))
; %$4 -> %struct.u64-vector*
; (store %$3 %$4)
; (let %$5 (call @u64-vector.make args))
; %$5 -> %struct.u64-vector
; (let %$6 (index %result 3))
; %$6 -> %struct.u64-vector*
; (store %$5 %$6)
; (let %$7 (call @StringView.makeEmpty args))
; %$7 -> %struct.StringView
; (let %$8 (index %result 4))
; %$8 -> %struct.StringView*
; (store %$7 %$8)
; (let %$9 (load %result))
; %$9 -> %struct.Parser
; (return %$9)
; def @Parser$ptr.unmake env
; %this -> %struct.Parser*
; return-void
; def @Parser$ptr.add-coord env
; %this -> %struct.Parser*
; %type -> u64
; (let %reader (index %this 0))
; %reader -> %struct.Reader*
; (let %$0 (index %reader 3))
; %$0 -> u64*
; (let %line (load %$0))
; %line -> u64
; (let %$1 (index %reader 4))
; %$1 -> u64*
; (let %col (load %$1))
; %col -> u64
; (let %$2 (index %this 1))
; %$2 -> %struct.u64-vector*
; (call @u64-vector$ptr.push (args %$2 %line))
; (let %$3 (index %this 2))
; %$3 -> %struct.u64-vector*
; (call @u64-vector$ptr.push (args %$3 %col))
; (let %$4 (index %this 3))
; %$4 -> %struct.u64-vector*
; (call @u64-vector$ptr.push (args %$4 %type))
; return-void
; def @Parser$ptr.add-open-coord env
; %this -> %struct.Parser*
; (call @Parser$ptr.add-coord (args %this 0))
; return-void
; def @Parser$ptr.add-close-coord env
; %this -> %struct.Parser*
; (call @Parser$ptr.add-coord (args %this 1))
; return-void
; def @Parser$ptr.add-value-coord env
; %this -> %struct.Parser*
; (call @Parser$ptr.add-coord (args %this 2))
; return-void
; def @Parser$ptr.add-comment-coord env
; %this -> %struct.Parser*
; (let %reader (index %this 0))
; %reader -> %struct.Reader*
; (let %$0 (index %reader 3))
; %$0 -> u64*
; (let %line (load %$0))
; %line -> u64
; (let %$1 (index %reader 4))
; %$1 -> u64*
; (let %col (load %$1))
; %col -> u64
; (let %$2 (index %this 1))
; %$2 -> %struct.u64-vector*
; (call @u64-vector$ptr.push (args %$2 %line))
; (let %$3 (index %this 2))
; %$3 -> %struct.u64-vector*
; (let %$4 (- %col 1))
; %$4 -> u64
; (call @u64-vector$ptr.push (args %$3 %$4))
; (let %$5 (index %this 3))
; %$5 -> %struct.u64-vector*
; (call @u64-vector$ptr.push (args %$5 3))
; return-void
; def @Parser$ptr.whitespace env
; %this -> %struct.Parser*
; (let %$2 (index %this 0))
; %$2 -> %struct.Reader*
; (let %$1 (call @Reader$ptr.peek (args %$2)))
; %$1 -> i8
; (let %$0 (call @i8.isspace (args %$1)))
; %$0 -> i1
; (if %$0 (do (let %$3 (index %this 0)) (call @Reader$ptr.get (args %$3)) (call-tail @Parser$ptr.whitespace (args %this)) return-void))
; (let %$3 (index %this 0))
; %$3 -> %struct.Reader*
; (call @Reader$ptr.get (args %$3))
; (call-tail @Parser$ptr.whitespace (args %this))
; return-void
; return-void
; def @Parser$ptr.word_ env
; %this -> %struct.Parser*
; %acc -> %struct.String*
; (let %reader (index %this 0))
; %reader -> %struct.Reader*
; (let %$0 (call @Reader$ptr.done (args %reader)))
; %$0 -> i1
; (if %$0 (do return-void))
; return-void
; (let %LPAREN (+ 40 (0 i8)))
; %LPAREN -> i8
; (let %RPAREN (+ 41 (0 i8)))
; %RPAREN -> i8
; (let %c (call @Reader$ptr.peek (args %reader)))
; %c -> i8
; (let %$1 (== %LPAREN %c))
; %$1 -> i1
; (if %$1 (do return-void))
; return-void
; (let %$2 (== %RPAREN %c))
; %$2 -> i1
; (if %$2 (do return-void))
; return-void
; (let %$3 (call @i8.isspace (args %c)))
; %$3 -> i1
; (if %$3 (do return-void))
; return-void
; (call @Reader$ptr.get (args %reader))
; (call @String$ptr.pushChar (args %acc %c))
; (call-tail @Parser$ptr.word_ (args %this %acc))
; return-void
; def @Parser$ptr.word env
; %this -> %struct.Parser*
; (auto %acc %struct.String)
; %acc -> %struct.String*
; (let %$0 (call @String.makeEmpty args))
; %$0 -> %struct.String
; (store %$0 %acc)
; (call @Parser$ptr.word_ (args %this %acc))
; (let %$1 (load %acc))
; %$1 -> %struct.String
; (return %$1)
; def @Parser$ptr.string_ env
; %this -> %struct.Parser*
; %acc -> %struct.String*
; (let %QUOTE (+ 34 (0 i8)))
; %QUOTE -> i8
; (let %BACKSLASH (+ 92 (0 i8)))
; %BACKSLASH -> i8
; (let %$2 (index %this 0))
; %$2 -> %struct.Reader*
; (let %$1 (call @Reader$ptr.peek (args %$2)))
; %$1 -> i8
; (let %$0 (== %QUOTE %$1))
; %$0 -> i1
; (if %$0 (do (let %$4 (index %this 0)) (let %$3 (index %$4 2)) (let %prev (load %$3)) (let %$5 (!= %BACKSLASH %prev)) (if %$5 (do return-void))))
; (let %$4 (index %this 0))
; %$4 -> %struct.Reader*
; (let %$3 (index %$4 2))
; %$3 -> i8*
; (let %prev (load %$3))
; %prev -> i8
; (let %$5 (!= %BACKSLASH %prev))
; %$5 -> i1
; (if %$5 (do return-void))
; return-void
; (let %$6 (index %this 0))
; %$6 -> %struct.Reader*
; (let %c (call @Reader$ptr.get (args %$6)))
; %c -> i8
; (call @String$ptr.pushChar (args %acc %c))
; (call-tail @Parser$ptr.string_ (args %this %acc))
; return-void
; def @Parser$ptr.string env
; %this -> %struct.Parser*
; (auto %acc %struct.String)
; %acc -> %struct.String*
; (let %$0 (call @String.makeEmpty args))
; %$0 -> %struct.String
; (store %$0 %acc)
; (let %$2 (index %this 0))
; %$2 -> %struct.Reader*
; (let %$1 (call @Reader$ptr.get (args %$2)))
; %$1 -> i8
; (call @String$ptr.pushChar (args %acc %$1))
; (call @Parser$ptr.string_ (args %this %acc))
; (let %$4 (index %this 0))
; %$4 -> %struct.Reader*
; (let %$3 (call @Reader$ptr.get (args %$4)))
; %$3 -> i8
; (call @String$ptr.pushChar (args %acc %$3))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (call @Texp$ptr.setFromString (args %texp %acc))
; (let %$5 (load %texp))
; %$5 -> %struct.Texp
; (return %$5)
; def @Parser$ptr.atom env
; %this -> %struct.Parser*
; (call @Parser$ptr.add-value-coord (args %this))
; (let %QUOTE (+ 34 (0 i8)))
; %QUOTE -> i8
; (let %$2 (index %this 0))
; %$2 -> %struct.Reader*
; (let %$1 (call @Reader$ptr.peek (args %$2)))
; %$1 -> i8
; (let %$0 (== %QUOTE %$1))
; %$0 -> i1
; (if %$0 (do (let %$3 (call @Parser$ptr.string (args %this))) (return %$3)))
; (let %$3 (call @Parser$ptr.string (args %this)))
; %$3 -> %struct.Texp
; (return %$3)
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (auto %word %struct.String)
; %word -> %struct.String*
; (let %$4 (call @Parser$ptr.word (args %this)))
; %$4 -> %struct.String
; (store %$4 %word)
; (call @Texp$ptr.setFromString (args %texp %word))
; (let %$5 (load %texp))
; %$5 -> %struct.Texp
; (return %$5)
; def @Parser$ptr.list_ env
; %this -> %struct.Parser*
; %acc -> %struct.Texp*
; (let %RPAREN (+ 41 (0 i8)))
; %RPAREN -> i8
; (let %$2 (index %this 0))
; %$2 -> %struct.Reader*
; (let %$1 (call @Reader$ptr.peek (args %$2)))
; %$1 -> i8
; (let %$0 (!= %RPAREN %$1))
; %$0 -> i1
; (if %$0 (do (auto %texp %struct.Texp) (let %$3 (call @Parser$ptr.texp (args %this))) (store %$3 %texp) (call @Texp$ptr.push$ptr (args %acc %texp)) (call @Parser$ptr.whitespace (args %this)) (call @Parser$ptr.list_ (args %this %acc))))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (let %$3 (call @Parser$ptr.texp (args %this)))
; %$3 -> %struct.Texp
; (store %$3 %texp)
; (call @Texp$ptr.push$ptr (args %acc %texp))
; (call @Parser$ptr.whitespace (args %this))
; (call @Parser$ptr.list_ (args %this %acc))
; return-void
; def @Parser$ptr.list env
; %this -> %struct.Parser*
; (call @Parser$ptr.add-open-coord (args %this))
; (let %$0 (index %this 0))
; %$0 -> %struct.Reader*
; (call @Reader$ptr.get (args %$0))
; (call @Parser$ptr.whitespace (args %this))
; (call @Parser$ptr.add-value-coord (args %this))
; (auto %curr %struct.Texp)
; %curr -> %struct.Texp*
; (auto %word %struct.String)
; %word -> %struct.String*
; (let %$1 (call @Parser$ptr.word (args %this)))
; %$1 -> %struct.String
; (store %$1 %word)
; (call @Texp$ptr.setFromString (args %curr %word))
; (call @Parser$ptr.whitespace (args %this))
; (call @Parser$ptr.list_ (args %this %curr))
; (call @Parser$ptr.add-close-coord (args %this))
; (let %$2 (index %this 0))
; %$2 -> %struct.Reader*
; (call @Reader$ptr.get (args %$2))
; (let %$3 (load %curr))
; %$3 -> %struct.Texp
; (return %$3)
; def @Parser$ptr.texp env
; %this -> %struct.Parser*
; (let %LPAREN (+ 40 (0 i8)))
; %LPAREN -> i8
; (call @Parser$ptr.whitespace (args %this))
; (let %$2 (index %this 0))
; %$2 -> %struct.Reader*
; (let %$1 (call @Reader$ptr.peek (args %$2)))
; %$1 -> i8
; (let %$0 (== %LPAREN %$1))
; %$0 -> i1
; (if %$0 (do (let %$3 (call @Parser$ptr.list (args %this))) (return %$3)))
; (let %$3 (call @Parser$ptr.list (args %this)))
; %$3 -> %struct.Texp
; (return %$3)
; (let %$4 (call @Parser$ptr.atom (args %this)))
; %$4 -> %struct.Texp
; (return %$4)
; def @Parser$ptr.collect env
; %this -> %struct.Parser*
; %parent -> %struct.Texp*
; (let %$1 (index %this 0))
; %$1 -> %struct.Reader*
; (let %$0 (call @Reader$ptr.done (args %$1)))
; %$0 -> i1
; (if %$0 (do return-void))
; return-void
; (auto %child %struct.Texp)
; %child -> %struct.Texp*
; (let %$2 (call @Parser$ptr.texp (args %this)))
; %$2 -> %struct.Texp
; (store %$2 %child)
; (call @Texp$ptr.push$ptr (args %parent %child))
; (call @Parser$ptr.whitespace (args %this))
; (call @Parser$ptr.collect (args %this %parent))
; return-void
; def @Parser$ptr.remove-comments_ env
; %this -> %struct.Parser*
; %state -> i8
; (let %NEWLINE (+ 10 (0 i8)))
; %NEWLINE -> i8
; (let %SPACE (+ 32 (0 i8)))
; %SPACE -> i8
; (let %QUOTE (+ 34 (0 i8)))
; %QUOTE -> i8
; (let %SEMICOLON (+ 59 (0 i8)))
; %SEMICOLON -> i8
; (let %BACKSLASH (+ 92 (0 i8)))
; %BACKSLASH -> i8
; (let %COMMENT_STATE (- (0 i8) 1))
; %COMMENT_STATE -> i8
; (let %START_STATE (+ 0 (0 i8)))
; %START_STATE -> i8
; (let %STRING_STATE (+ 1 (0 i8)))
; %STRING_STATE -> i8
; (let %CHAR_STATE (+ 2 (0 i8)))
; %CHAR_STATE -> i8
; (let %reader (index %this 0))
; %reader -> %struct.Reader*
; (let %done (call @Reader$ptr.done (args %reader)))
; %done -> i1
; (if %done (do (call @Reader$ptr.reset (args %reader)) return-void))
; (call @Reader$ptr.reset (args %reader))
; return-void
; (let %c (call @Reader$ptr.get (args %reader)))
; %c -> i8
; (let %$0 (== %COMMENT_STATE %state))
; %$0 -> i1
; (if %$0 (do (let %$1 (== %NEWLINE %c)) (if %$1 (do (call-tail @Parser$ptr.remove-comments_ (args %this %START_STATE)) return-void)) (let %$6 (index %reader 1)) (let %$5 (load %$6)) (let %$4 (cast u64 %$5)) (let %$3 (- %$4 1)) (let %$2 (cast i8* %$3)) (store %SPACE %$2) (call-tail @Parser$ptr.remove-comments_ (args %this %state)) return-void))
; (let %$1 (== %NEWLINE %c))
; %$1 -> i1
; (if %$1 (do (call-tail @Parser$ptr.remove-comments_ (args %this %START_STATE)) return-void))
; (call-tail @Parser$ptr.remove-comments_ (args %this %START_STATE))
; return-void
; (let %$6 (index %reader 1))
; %$6 -> i8**
; (let %$5 (load %$6))
; %$5 -> i8*
; (let %$4 (cast u64 %$5))
; value: (type-value i8* %$5)
; %$4 -> u64
; (let %$3 (- %$4 1))
; %$3 -> u64
; (let %$2 (cast i8* %$3))
; value: (type-value u64 %$3)
; %$2 -> i8*
; (store %SPACE %$2)
; (call-tail @Parser$ptr.remove-comments_ (args %this %state))
; return-void
; (let %$7 (== %START_STATE %state))
; %$7 -> i1
; (if %$7 (do (let %$8 (== %QUOTE %c)) (if %$8 (do (call-tail @Parser$ptr.remove-comments_ (args %this %STRING_STATE)) return-void)) (let %$9 (== %SEMICOLON %c)) (if %$9 (do (call @Parser$ptr.add-comment-coord (args %this)) (let %$14 (index %reader 1)) (let %$13 (load %$14)) (let %$12 (cast u64 %$13)) (let %$11 (- %$12 1)) (let %$10 (cast i8* %$11)) (store %SPACE %$10) (call-tail @Parser$ptr.remove-comments_ (args %this %COMMENT_STATE)) return-void)) (call-tail @Parser$ptr.remove-comments_ (args %this %state)) return-void))
; (let %$8 (== %QUOTE %c))
; %$8 -> i1
; (if %$8 (do (call-tail @Parser$ptr.remove-comments_ (args %this %STRING_STATE)) return-void))
; (call-tail @Parser$ptr.remove-comments_ (args %this %STRING_STATE))
; return-void
; (let %$9 (== %SEMICOLON %c))
; %$9 -> i1
; (if %$9 (do (call @Parser$ptr.add-comment-coord (args %this)) (let %$14 (index %reader 1)) (let %$13 (load %$14)) (let %$12 (cast u64 %$13)) (let %$11 (- %$12 1)) (let %$10 (cast i8* %$11)) (store %SPACE %$10) (call-tail @Parser$ptr.remove-comments_ (args %this %COMMENT_STATE)) return-void))
; (call @Parser$ptr.add-comment-coord (args %this))
; (let %$14 (index %reader 1))
; %$14 -> i8**
; (let %$13 (load %$14))
; %$13 -> i8*
; (let %$12 (cast u64 %$13))
; value: (type-value i8* %$13)
; %$12 -> u64
; (let %$11 (- %$12 1))
; %$11 -> u64
; (let %$10 (cast i8* %$11))
; value: (type-value u64 %$11)
; %$10 -> i8*
; (store %SPACE %$10)
; (call-tail @Parser$ptr.remove-comments_ (args %this %COMMENT_STATE))
; return-void
; (call-tail @Parser$ptr.remove-comments_ (args %this %state))
; return-void
; (let %$15 (== %STRING_STATE %state))
; %$15 -> i1
; (if %$15 (do (let %$16 (== %QUOTE %c)) (if %$16 (do (let %$17 (index %reader 2)) (let %prev (load %$17)) (let %$18 (!= %BACKSLASH %prev)) (if %$18 (do (call-tail @Parser$ptr.remove-comments_ (args %this %START_STATE)) return-void)))) (call-tail @Parser$ptr.remove-comments_ (args %this %state)) return-void))
; (let %$16 (== %QUOTE %c))
; %$16 -> i1
; (if %$16 (do (let %$17 (index %reader 2)) (let %prev (load %$17)) (let %$18 (!= %BACKSLASH %prev)) (if %$18 (do (call-tail @Parser$ptr.remove-comments_ (args %this %START_STATE)) return-void))))
; (let %$17 (index %reader 2))
; %$17 -> i8*
; (let %prev (load %$17))
; %prev -> i8
; (let %$18 (!= %BACKSLASH %prev))
; %$18 -> i1
; (if %$18 (do (call-tail @Parser$ptr.remove-comments_ (args %this %START_STATE)) return-void))
; (call-tail @Parser$ptr.remove-comments_ (args %this %START_STATE))
; return-void
; (call-tail @Parser$ptr.remove-comments_ (args %this %state))
; return-void
; return-void
; def @Parser$ptr.remove-comments env
; %this -> %struct.Parser*
; (call @Parser$ptr.remove-comments_ (args %this 0))
; return-void
; def @Parser.parse-file.intro env
; %filename -> %struct.StringView*
; %file -> %struct.File*
; %content -> %struct.StringView*
; %parser -> %struct.Parser*
; (let %$0 (call @File.openrw (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (let %$1 (call @File$ptr.readwrite (args %file)))
; %$1 -> %struct.StringView
; (store %$1 %content)
; (let %$2 (call @Parser.make (args %content)))
; %$2 -> %struct.Parser
; (store %$2 %parser)
; (let %$3 (load %filename))
; %$3 -> %struct.StringView
; (let %$4 (index %parser 4))
; %$4 -> %struct.StringView*
; (store %$3 %$4)
; (call @Parser$ptr.remove-comments (args %parser))
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (auto %filename-string %struct.String)
; %filename-string -> %struct.String*
; (let %$5 (call @String.makeFromStringView (args %filename)))
; %$5 -> %struct.String
; (store %$5 %filename-string)
; (call @Texp$ptr.setFromString (args %prog %filename-string))
; (call @Parser$ptr.collect (args %parser %prog))
; (let %$6 (load %prog))
; %$6 -> %struct.Texp
; (return %$6)
; def @Parser.parse-file.outro env
; %file -> %struct.File*
; %content -> %struct.StringView*
; %parser -> %struct.Parser*
; (call @Parser$ptr.unmake (args %parser))
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @Parser.parse-file env
; %filename -> %struct.StringView*
; (auto %file %struct.File)
; %file -> %struct.File*
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (auto %parser %struct.Parser)
; %parser -> %struct.Parser*
; (let %prog (call @Parser.parse-file.intro (args %filename %file %content %parser)))
; %prog -> %struct.Texp
; (call @Parser.parse-file.outro (args %file %content %parser))
; (return %prog)
; def @Parser.parse-file-i8$ptr env
; %filename -> i8*
; (auto %fn-view %struct.StringView)
; %fn-view -> %struct.StringView*
; (let %$0 (call @StringView.makeFromi8$ptr (args %filename)))
; %$0 -> %struct.StringView
; (store %$0 %fn-view)
; (let %$1 (call @Parser.parse-file (args %fn-view)))
; %$1 -> %struct.Texp
; (return %$1)
; def @test.parser-whitespace env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 77)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.open (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$1 (call @File$ptr.read (args %file)))
; %$1 -> %struct.StringView
; (store %$1 %content)
; (auto %parser %struct.Parser)
; %parser -> %struct.Parser*
; (let %$2 (index %parser 0))
; %$2 -> %struct.Reader*
; (call @Reader$ptr.set (args %$2 %content))
; (let %$5 (index %parser 0))
; %$5 -> %struct.Reader*
; (let %$4 (index %$5 1))
; %$4 -> i8**
; (let %$3 (load %$4))
; %$3 -> i8*
; (call @puts (args %$3))
; (call @Parser$ptr.whitespace (args %parser))
; (let %$8 (index %parser 0))
; %$8 -> %struct.Reader*
; (let %$7 (index %$8 1))
; %$7 -> i8**
; (let %$6 (load %$7))
; %$6 -> i8*
; (call @puts (args %$6))
; (call @Parser$ptr.whitespace (args %parser))
; (let %$11 (index %parser 0))
; %$11 -> %struct.Reader*
; (let %$10 (index %$11 1))
; %$10 -> i8**
; (let %$9 (load %$10))
; %$9 -> i8*
; (call @puts (args %$9))
; (let %$12 (index %parser 0))
; %$12 -> %struct.Reader*
; (call @Reader$ptr.get (args %$12))
; (let %$15 (index %parser 0))
; %$15 -> %struct.Reader*
; (let %$14 (index %$15 1))
; %$14 -> i8**
; (let %$13 (load %$14))
; %$13 -> i8*
; (call @puts (args %$13))
; (call @Parser$ptr.whitespace (args %parser))
; (let %$18 (index %parser 0))
; %$18 -> %struct.Reader*
; (let %$17 (index %$18 1))
; %$17 -> i8**
; (let %$16 (load %$17))
; %$16 -> i8*
; (call @puts (args %$16))
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @test.parser-atom env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 78)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.open (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$1 (call @File$ptr.read (args %file)))
; %$1 -> %struct.StringView
; (store %$1 %content)
; (auto %parser %struct.Parser)
; %parser -> %struct.Parser*
; (let %$2 (index %parser 0))
; %$2 -> %struct.Reader*
; (call @Reader$ptr.set (args %$2 %content))
; (let %$5 (index %parser 0))
; %$5 -> %struct.Reader*
; (let %$4 (index %$5 1))
; %$4 -> i8**
; (let %$3 (load %$4))
; %$3 -> i8*
; (call @puts (args %$3))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (let %$6 (call @Parser$ptr.atom (args %parser)))
; %$6 -> %struct.Texp
; (store %$6 %texp)
; (let %$9 (index %parser 0))
; %$9 -> %struct.Reader*
; (let %$8 (index %$9 1))
; %$8 -> i8**
; (let %$7 (load %$8))
; %$7 -> i8*
; (call @puts (args %$7))
; (call @Texp$ptr.parenPrint (args %texp))
; (call @println args)
; (auto %texp2 %struct.Texp)
; %texp2 -> %struct.Texp*
; (let %$10 (call @Parser$ptr.atom (args %parser)))
; %$10 -> %struct.Texp
; (store %$10 %texp2)
; (let %$13 (index %parser 0))
; %$13 -> %struct.Reader*
; (let %$12 (index %$13 1))
; %$12 -> i8**
; (let %$11 (load %$12))
; %$11 -> i8*
; (call @puts (args %$11))
; (call @Texp$ptr.parenPrint (args %texp2))
; (call @println args)
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @test.parser-texp env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 79)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.open (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$1 (call @File$ptr.read (args %file)))
; %$1 -> %struct.StringView
; (store %$1 %content)
; (auto %parser %struct.Parser)
; %parser -> %struct.Parser*
; (let %$2 (index %parser 0))
; %$2 -> %struct.Reader*
; (call @Reader$ptr.set (args %$2 %content))
; (let %$5 (index %parser 0))
; %$5 -> %struct.Reader*
; (let %$4 (index %$5 1))
; %$4 -> i8**
; (let %$3 (load %$4))
; %$3 -> i8*
; (call @puts (args %$3))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (let %$6 (call @Parser$ptr.texp (args %parser)))
; %$6 -> %struct.Texp
; (store %$6 %texp)
; (let %$9 (index %parser 0))
; %$9 -> %struct.Reader*
; (let %$8 (index %$9 1))
; %$8 -> i8**
; (let %$7 (load %$8))
; %$7 -> i8*
; (call @puts (args %$7))
; (call @Texp$ptr.parenPrint (args %texp))
; (call @println args)
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @test.parser-string env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 80)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.open (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$1 (call @File$ptr.read (args %file)))
; %$1 -> %struct.StringView
; (store %$1 %content)
; (auto %parser %struct.Parser)
; %parser -> %struct.Parser*
; (let %$2 (index %parser 0))
; %$2 -> %struct.Reader*
; (call @Reader$ptr.set (args %$2 %content))
; (let %$5 (index %parser 0))
; %$5 -> %struct.Reader*
; (let %$4 (index %$5 1))
; %$4 -> i8**
; (let %$3 (load %$4))
; %$3 -> i8*
; (call @puts (args %$3))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (let %$6 (call @Parser$ptr.texp (args %parser)))
; %$6 -> %struct.Texp
; (store %$6 %texp)
; (let %$9 (index %parser 0))
; %$9 -> %struct.Reader*
; (let %$8 (index %$9 1))
; %$8 -> i8**
; (let %$7 (load %$8))
; %$7 -> i8*
; (call @puts (args %$7))
; (call @Texp$ptr.parenPrint (args %texp))
; (call @println args)
; (let %$11 (index %texp 2))
; %$11 -> u64*
; (let %$10 (load %$11))
; %$10 -> u64
; (call @u64.print (args %$10))
; (call @println args)
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @test.parser-comments env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 81)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.openrw (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$1 (call @File$ptr.readwrite (args %file)))
; %$1 -> %struct.StringView
; (store %$1 %content)
; (auto %parser %struct.Parser)
; %parser -> %struct.Parser*
; (let %$2 (index %parser 0))
; %$2 -> %struct.Reader*
; (call @Reader$ptr.set (args %$2 %content))
; (call @Parser$ptr.remove-comments (args %parser))
; (let %$5 (index %parser 0))
; %$5 -> %struct.Reader*
; (let %$4 (index %$5 1))
; %$4 -> i8**
; (let %$3 (load %$4))
; %$3 -> i8*
; (call @puts (args %$3))
; (auto %texp %struct.Texp)
; %texp -> %struct.Texp*
; (let %$6 (call @Parser$ptr.texp (args %parser)))
; %$6 -> %struct.Texp
; (store %$6 %texp)
; (call @Texp$ptr.parenPrint (args %texp))
; (call @println args)
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @test.parser-file env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 82)))
; (auto %file %struct.File)
; %file -> %struct.File*
; (let %$0 (call @File.openrw (args %filename)))
; %$0 -> %struct.File
; (store %$0 %file)
; (auto %content %struct.StringView)
; %content -> %struct.StringView*
; (let %$1 (call @File$ptr.readwrite (args %file)))
; %$1 -> %struct.StringView
; (store %$1 %content)
; (auto %parser %struct.Parser)
; %parser -> %struct.Parser*
; (let %$2 (index %parser 0))
; %$2 -> %struct.Reader*
; (call @Reader$ptr.set (args %$2 %content))
; (call @Parser$ptr.remove-comments (args %parser))
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (auto %filename-string %struct.String)
; %filename-string -> %struct.String*
; (let %$3 (call @String.makeFromStringView (args %filename)))
; %$3 -> %struct.String
; (store %$3 %filename-string)
; (call @Texp$ptr.setFromString (args %prog %filename-string))
; (call @Parser$ptr.collect (args %parser %prog))
; (call @Texp$ptr.parenPrint (args %prog))
; (call @File.unread (args %content))
; (call @File$ptr.close (args %file))
; return-void
; def @Texp$ptr.pretty-print$lambda.do env
; %this -> %struct.Texp*
; return-void
; def @Texp$ptr.pretty-print$lambda.toplevel env
; %this -> %struct.Texp*
; %last -> %struct.Texp*
; (call @Texp$ptr.parenPrint (args %this))
; (call @println args)
; (let %$0 (!= %this %last))
; %$0 -> i1
; (if %$0 (do (let %$2 (cast u64 %this)) (let %$1 (+ 40 %$2)) (let %next (cast %struct.Texp* %$1)) (call @Texp$ptr.pretty-print$lambda.toplevel (args %next %last))))
; (let %$2 (cast u64 %this))
; value: (type-value %struct.Texp* %this)
; %$2 -> u64
; (let %$1 (+ 40 %$2))
; %$1 -> u64
; (let %next (cast %struct.Texp* %$1))
; value: (type-value u64 %$1)
; %next -> %struct.Texp*
; (call @Texp$ptr.pretty-print$lambda.toplevel (args %next %last))
; return-void
; def @Texp$ptr.pretty-print env
; %this -> %struct.Texp*
; (let %LPAREN (+ 40 (0 i8)))
; %LPAREN -> i8
; (let %RPAREN (+ 41 (0 i8)))
; %RPAREN -> i8
; (call @i8.print (args %LPAREN))
; (let %$0 (index %this 0))
; %$0 -> %struct.String*
; (call @String$ptr.println (args %$0))
; (let %last (call @Texp$ptr.last (args %this)))
; %last -> %struct.Texp*
; (let %$1 (index %this 1))
; %$1 -> %struct.Texp**
; (let %first-child (load %$1))
; %first-child -> %struct.Texp*
; (call @Texp$ptr.pretty-print$lambda.toplevel (args %first-child %last))
; (call @i8.print (args %RPAREN))
; (call @println args)
; return-void
; def @test.texp-pretty-print env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 83)))
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$0 (call @Parser.parse-file (args %filename)))
; %$0 -> %struct.Texp
; (store %$0 %prog)
; (call @Texp$ptr.pretty-print (args %prog))
; return-void
; def @Grammar.make env
; %texp -> %struct.Texp
; (auto %grammar %struct.Grammar)
; %grammar -> %struct.Grammar*
; (let %$0 (index %grammar 0))
; %$0 -> %struct.Texp*
; (store %texp %$0)
; (let %$1 (index %grammar 0))
; %$1 -> %struct.Texp*
; (call @Texp$ptr.demote-free (args %$1))
; (let %$2 (load %grammar))
; %$2 -> %struct.Grammar
; (return %$2)
; def @Grammar$ptr.getProduction env
; %this -> %struct.Grammar*
; %type-name -> %struct.StringView*
; (let %$0 (index %this 0))
; %$0 -> %struct.Texp*
; (let %maybe-prod (call @Texp$ptr.find (args %$0 %type-name)))
; %maybe-prod -> %struct.Texp*
; (let %$2 (cast u64 %maybe-prod))
; value: (type-value %struct.Texp* %maybe-prod)
; %$2 -> u64
; (let %$1 (== 0 %$2))
; %$1 -> i1
; (if %$1 (do (call @i8$ptr.unsafe-print (args (str-get 84))) (call @StringView$ptr.print (args %type-name)) (call @i8$ptr.unsafe-println (args (str-get 85))) (call @exit (args 1))))
; (call @i8$ptr.unsafe-print (args (str-get 84)))
; (call @StringView$ptr.print (args %type-name))
; (call @i8$ptr.unsafe-println (args (str-get 85)))
; (call @exit (args 1))
; (return %maybe-prod)
; def @Grammar$ptr.get-keyword env
; %this -> %struct.Grammar*
; %type-name -> %struct.StringView*
; (let %prod (call @Grammar$ptr.getProduction (args %this %type-name)))
; %prod -> %struct.Texp*
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (let %$1 (call @Texp$ptr.value-check (args %rule (str-get 86))))
; %$1 -> i1
; (if %$1 (do (let %$2 (call @Optional.none args)) (return %$2)))
; (let %$2 (call @Optional.none args))
; %$2 -> %struct.Texp
; (return %$2)
; (let %rule-value (index %rule 0))
; %rule-value -> %struct.String*
; (let %$3 (call @String$ptr.is-empty (args %rule-value)))
; %$3 -> i1
; (if %$3 (do (call @i8$ptr.unsafe-println (args (str-get 87))) (call @Texp$ptr.parenPrint (args %rule)) (call @exit (args 1))))
; (call @i8$ptr.unsafe-println (args (str-get 87)))
; (call @Texp$ptr.parenPrint (args %rule))
; (call @exit (args 1))
; (let %HASH (+ 35 (0 i8)))
; %HASH -> i8
; (let %$5 (call @String$ptr.char-at-unsafe (args %rule-value 0)))
; %$5 -> i8
; (let %$4 (== %HASH %$5))
; %$4 -> i1
; (if %$4 (do (let %$6 (call @Optional.none args)) (return %$6)))
; (let %$6 (call @Optional.none args))
; %$6 -> %struct.Texp
; (return %$6)
; (let %$7 (call @Texp.makeFromString (args %rule-value)))
; %$7 -> %struct.Texp
; (return %$7)
; def @Matcher$ptr.is env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %type-name -> %struct.StringView*
; (call @i8$ptr.unsafe-print (args (str-get 88)))
; (call @Texp$ptr.parenPrint (args %texp))
; (call @i8$ptr.unsafe-print (args (str-get 89)))
; (call @StringView$ptr.print (args %type-name))
; (let %grammar (index %this 0))
; %grammar -> %struct.Grammar*
; (let %prod (call @Grammar$ptr.getProduction (args %grammar %type-name)))
; %prod -> %struct.Texp*
; (call @i8$ptr.unsafe-print (args (str-get 90)))
; (call @Texp$ptr.parenPrint (args %prod))
; (call @println args)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$0 (call @Matcher$ptr.match (args %this %texp %prod)))
; %$0 -> %struct.Texp
; (store %$0 %result)
; (let %$1 (call @Texp$ptr.value-check (args %result (str-get 91))))
; %$1 -> i1
; (if %$1 (do (let %$2 (index %result 1)) (let %child (load %$2)) (let %proof-value (index %child 0)) (auto %new-proof-value %struct.String) (let %$3 (call @String.makeFromStringView (args %type-name))) (store %$3 %new-proof-value) (let %FORWARD_SLASH (+ 47 (0 i8))) (call @String$ptr.pushChar (args %new-proof-value %FORWARD_SLASH)) (call @String$ptr.append (args %new-proof-value %proof-value)) (call @String$ptr.free (args %proof-value)) (let %$4 (load %new-proof-value)) (store %$4 %proof-value)))
; (let %$2 (index %result 1))
; %$2 -> %struct.Texp**
; (let %child (load %$2))
; %child -> %struct.Texp*
; (let %proof-value (index %child 0))
; %proof-value -> %struct.String*
; (auto %new-proof-value %struct.String)
; %new-proof-value -> %struct.String*
; (let %$3 (call @String.makeFromStringView (args %type-name)))
; %$3 -> %struct.String
; (store %$3 %new-proof-value)
; (let %FORWARD_SLASH (+ 47 (0 i8)))
; %FORWARD_SLASH -> i8
; (call @String$ptr.pushChar (args %new-proof-value %FORWARD_SLASH))
; (call @String$ptr.append (args %new-proof-value %proof-value))
; (call @String$ptr.free (args %proof-value))
; (let %$4 (load %new-proof-value))
; %$4 -> %struct.String
; (store %$4 %proof-value)
; (let %$5 (load %result))
; %$5 -> %struct.Texp
; (return %$5)
; def @Matcher$ptr.atom env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; (call @i8$ptr.unsafe-println (args (str-get 92)))
; (let %$2 (index %texp 2))
; %$2 -> u64*
; (let %$1 (load %$2))
; %$1 -> u64
; (let %$0 (!= 0 %$1))
; %$0 -> i1
; (if %$0 (do (auto %error-result %struct.Texp) (let %$3 (call @Result.error-from-i8$ptr (args (str-get 93)))) (store %$3 %error-result) (let %$4 (call @Texp$ptr.clone (args %prod))) (call @Texp$ptr.push (args %error-result %$4)) (let %$5 (load %error-result)) (return %$5)))
; (auto %error-result %struct.Texp)
; %error-result -> %struct.Texp*
; (let %$3 (call @Result.error-from-i8$ptr (args (str-get 93))))
; %$3 -> %struct.Texp
; (store %$3 %error-result)
; (let %$4 (call @Texp$ptr.clone (args %prod)))
; %$4 -> %struct.Texp
; (call @Texp$ptr.push (args %error-result %$4))
; (let %$5 (load %error-result))
; %$5 -> %struct.Texp
; (return %$5)
; (let %$6 (call @Result.success-from-i8$ptr (args (str-get 94))))
; %$6 -> %struct.Texp
; (return %$6)
; def @Matcher$ptr.match env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (let %$1 (index %rule 2))
; %$1 -> u64*
; (let %rule-length (load %$1))
; %rule-length -> u64
; (call @i8$ptr.unsafe-print (args (str-get 95)))
; (call @Texp$ptr.parenPrint (args %rule))
; (let %$2 (call @Texp$ptr.value-check (args %rule (str-get 96))))
; %$2 -> i1
; (if %$2 (do (call @println args) (let %$3 (call @Matcher$ptr.choice (args %this %texp %prod))) (return %$3)))
; (call @println args)
; (let %$3 (call @Matcher$ptr.choice (args %this %texp %prod)))
; %$3 -> %struct.Texp
; (return %$3)
; (call @i8$ptr.unsafe-print (args (str-get 97)))
; (call @u64.print (args %rule-length))
; (call @println args)
; (auto %value-result %struct.Texp)
; %value-result -> %struct.Texp*
; (let %$4 (call @Matcher$ptr.value (args %this %texp %prod)))
; %$4 -> %struct.Texp
; (store %$4 %value-result)
; (let %$5 (call @Texp$ptr.value-check (args %value-result (str-get 98))))
; %$5 -> i1
; (if %$5 (do (let %$6 (load %value-result)) (return %$6)))
; (let %$6 (load %value-result))
; %$6 -> %struct.Texp
; (return %$6)
; (let %$7 (!= %rule-length 0))
; %$7 -> i1
; (if %$7 (do (let %last (call @Texp$ptr.last (args %rule))) (let %$8 (call @Texp$ptr.value-check (args %last (str-get 99)))) (if %$8 (do (let %$9 (call @Matcher$ptr.kleene (args %this %texp %prod))) (return %$9))) (let %$10 (call @Matcher$ptr.exact (args %this %texp %prod))) (return %$10)))
; (let %last (call @Texp$ptr.last (args %rule)))
; %last -> %struct.Texp*
; (let %$8 (call @Texp$ptr.value-check (args %last (str-get 99))))
; %$8 -> i1
; (if %$8 (do (let %$9 (call @Matcher$ptr.kleene (args %this %texp %prod))) (return %$9)))
; (let %$9 (call @Matcher$ptr.kleene (args %this %texp %prod)))
; %$9 -> %struct.Texp
; (return %$9)
; (let %$10 (call @Matcher$ptr.exact (args %this %texp %prod)))
; %$10 -> %struct.Texp
; (return %$10)
; (let %$11 (call @Matcher$ptr.atom (args %this %texp %prod)))
; %$11 -> %struct.Texp
; (return %$11)
; def @Matcher$ptr.kleene-seq env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; %acc -> %struct.Texp*
; %curr-index -> u64
; %last-index -> u64
; (call @i8$ptr.unsafe-print (args (str-get 100)))
; (call @u64.print (args %curr-index))
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (let %last (call @Texp$ptr.last (args %rule)))
; %last -> %struct.Texp*
; (let %texp-child (call @Texp$ptr.child (args %texp %curr-index)))
; %texp-child -> %struct.Texp*
; (let %rule-child (call @Texp$ptr.child (args %rule %curr-index)))
; %rule-child -> %struct.Texp*
; (call @i8$ptr.unsafe-print (args (str-get 101)))
; (call @Texp$ptr.parenPrint (args %texp-child))
; (call @i8$ptr.unsafe-print (args (str-get 102)))
; (call @Texp$ptr.parenPrint (args %rule-child))
; (call @println args)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$2 (call @Texp$ptr.value-view (args %rule-child)))
; %$2 -> %struct.StringView*
; (let %$1 (call @Matcher$ptr.is (args %this %texp-child %$2)))
; %$1 -> %struct.Texp
; (store %$1 %result)
; (let %$3 (call @Texp$ptr.value-check (args %result (str-get 103))))
; %$3 -> i1
; (if %$3 (do (call @Texp$ptr.free (args %acc)) (let %$4 (load %result)) (store %$4 %acc) return-void))
; (call @Texp$ptr.free (args %acc))
; (let %$4 (load %result))
; %$4 -> %struct.Texp
; (store %$4 %acc)
; return-void
; (call @Texp$ptr.demote-free (args %result))
; (call @Texp$ptr.push$ptr (args %acc %result))
; (let %$5 (== %curr-index %last-index))
; %$5 -> i1
; (if %$5 (do return-void))
; return-void
; (let %next-index (+ 1 %curr-index))
; %next-index -> u64
; (call @Matcher$ptr.kleene-seq (args %this %texp %prod %acc %next-index %last-index))
; return-void
; def @Matcher$ptr.kleene-many env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; %acc -> %struct.Texp*
; %curr-index -> u64
; %last-index -> u64
; (call @i8$ptr.unsafe-print (args (str-get 104)))
; (call @u64.print (args %curr-index))
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (let %last (call @Texp$ptr.last (args %rule)))
; %last -> %struct.Texp*
; (let %texp-child (call @Texp$ptr.child (args %texp %curr-index)))
; %texp-child -> %struct.Texp*
; (let %rule-child (call @Texp$ptr.last (args %last)))
; %rule-child -> %struct.Texp*
; (call @i8$ptr.unsafe-print (args (str-get 105)))
; (call @Texp$ptr.parenPrint (args %texp-child))
; (call @i8$ptr.unsafe-print (args (str-get 106)))
; (call @Texp$ptr.parenPrint (args %rule-child))
; (call @println args)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$2 (call @Texp$ptr.value-view (args %rule-child)))
; %$2 -> %struct.StringView*
; (let %$1 (call @Matcher$ptr.is (args %this %texp-child %$2)))
; %$1 -> %struct.Texp
; (store %$1 %result)
; (let %$3 (call @Texp$ptr.value-check (args %result (str-get 107))))
; %$3 -> i1
; (if %$3 (do (call @Texp$ptr.free (args %acc)) (let %$4 (load %result)) (store %$4 %acc) return-void))
; (call @Texp$ptr.free (args %acc))
; (let %$4 (load %result))
; %$4 -> %struct.Texp
; (store %$4 %acc)
; return-void
; (call @Texp$ptr.demote-free (args %result))
; (call @Texp$ptr.push$ptr (args %acc %result))
; (let %$5 (== %curr-index %last-index))
; %$5 -> i1
; (if %$5 (do return-void))
; return-void
; (let %next-index (+ 1 %curr-index))
; %next-index -> u64
; (call @Matcher$ptr.kleene-many (args %this %texp %prod %acc %next-index %last-index))
; return-void
; def @Matcher$ptr.kleene env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (call @i8$ptr.unsafe-print (args (str-get 108)))
; (call @Texp$ptr.parenPrint (args %texp))
; (call @i8$ptr.unsafe-print (args (str-get 109)))
; (call @Texp$ptr.parenPrint (args %rule))
; (call @println args)
; (let %last (call @Texp$ptr.last (args %rule)))
; %last -> %struct.Texp*
; (let %$1 (index %last 0))
; %$1 -> %struct.String*
; (let %kleene-prod-view (call @String$ptr.view (args %$1)))
; %kleene-prod-view -> %struct.StringView
; (let %$2 (index %rule 2))
; %$2 -> u64*
; (let %rule-length (load %$2))
; %rule-length -> u64
; (let %$3 (index %texp 2))
; %$3 -> u64*
; (let %texp-length (load %$3))
; %texp-length -> u64
; (auto %proof %struct.Texp)
; %proof -> %struct.Texp*
; (let %$4 (call @Texp.makeFromi8$ptr (args (str-get 110))))
; %$4 -> %struct.Texp
; (store %$4 %proof)
; (call @i8$ptr.unsafe-print (args (str-get 111)))
; (call @u64.print (args %rule-length))
; (call @i8$ptr.unsafe-print (args (str-get 112)))
; (call @u64.print (args %texp-length))
; (call @println args)
; (let %seq-length (- %rule-length 1))
; %seq-length -> u64
; (let %last-texp-i (- %texp-length 1))
; %last-texp-i -> u64
; (call @i8$ptr.unsafe-print (args (str-get 113)))
; (call @u64.print (args %seq-length))
; (call @i8$ptr.unsafe-print (args (str-get 114)))
; (call @u64.print (args %last-texp-i))
; (call @println args)
; (let %$5 (< %texp-length %seq-length))
; %$5 -> i1
; (if %$5 (do (auto %failure-result %struct.Texp) (let %$6 (call @Texp.makeFromi8$ptr (args (str-get 115)))) (store %$6 %failure-result) (let %$7 (call @Texp.makeFromi8$ptr (args (str-get 116)))) (call @Texp$ptr.push (args %failure-result %$7)) (let %$8 (call @Texp$ptr.clone (args %rule))) (call @Texp$ptr.push (args %failure-result %$8)) (let %$9 (call @Texp$ptr.clone (args %texp))) (call @Texp$ptr.push (args %failure-result %$9)) (let %$10 (load %failure-result)) (return %$10)))
; (auto %failure-result %struct.Texp)
; %failure-result -> %struct.Texp*
; (let %$6 (call @Texp.makeFromi8$ptr (args (str-get 115))))
; %$6 -> %struct.Texp
; (store %$6 %failure-result)
; (let %$7 (call @Texp.makeFromi8$ptr (args (str-get 116))))
; %$7 -> %struct.Texp
; (call @Texp$ptr.push (args %failure-result %$7))
; (let %$8 (call @Texp$ptr.clone (args %rule)))
; %$8 -> %struct.Texp
; (call @Texp$ptr.push (args %failure-result %$8))
; (let %$9 (call @Texp$ptr.clone (args %texp)))
; %$9 -> %struct.Texp
; (call @Texp$ptr.push (args %failure-result %$9))
; (let %$10 (load %failure-result))
; %$10 -> %struct.Texp
; (return %$10)
; (let %$11 (!= 0 %seq-length))
; %$11 -> i1
; (if %$11 (do (let %$12 (- %seq-length 1)) (call @Matcher$ptr.kleene-seq (args %this %texp %prod %proof 0 %$12)) (let %$13 (call @Texp$ptr.value-check (args %proof (str-get 117)))) (if %$13 (do (let %$14 (load %proof)) (return %$14)))))
; (let %$12 (- %seq-length 1))
; %$12 -> u64
; (call @Matcher$ptr.kleene-seq (args %this %texp %prod %proof 0 %$12))
; (let %$13 (call @Texp$ptr.value-check (args %proof (str-get 117))))
; %$13 -> i1
; (if %$13 (do (let %$14 (load %proof)) (return %$14)))
; (let %$14 (load %proof))
; %$14 -> %struct.Texp
; (return %$14)
; (let %$15 (!= %seq-length %texp-length))
; %$15 -> i1
; (if %$15 (do (let %$16 (- %texp-length 1)) (call @Matcher$ptr.kleene-many (args %this %texp %prod %proof %seq-length %$16)) (let %$17 (call @Texp$ptr.value-check (args %proof (str-get 118)))) (if %$17 (do (let %$18 (load %proof)) (return %$18)))))
; (let %$16 (- %texp-length 1))
; %$16 -> u64
; (call @Matcher$ptr.kleene-many (args %this %texp %prod %proof %seq-length %$16))
; (let %$17 (call @Texp$ptr.value-check (args %proof (str-get 118))))
; %$17 -> i1
; (if %$17 (do (let %$18 (load %proof)) (return %$18)))
; (let %$18 (load %proof))
; %$18 -> %struct.Texp
; (return %$18)
; (let %$19 (call @Result.success (args %proof)))
; %$19 -> %struct.Texp
; (return %$19)
; def @Matcher$ptr.exact_ env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; %acc -> %struct.Texp*
; %curr-index -> u64
; %last-index -> u64
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (let %texp-child (call @Texp$ptr.child (args %texp %curr-index)))
; %texp-child -> %struct.Texp*
; (let %rule-child (call @Texp$ptr.child (args %rule %curr-index)))
; %rule-child -> %struct.Texp*
; (call @i8$ptr.unsafe-print (args (str-get 119)))
; (call @Texp$ptr.parenPrint (args %texp-child))
; (call @i8$ptr.unsafe-print (args (str-get 120)))
; (call @Texp$ptr.parenPrint (args %rule-child))
; (call @println args)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$2 (call @Texp$ptr.value-view (args %rule-child)))
; %$2 -> %struct.StringView*
; (let %$1 (call @Matcher$ptr.is (args %this %texp-child %$2)))
; %$1 -> %struct.Texp
; (store %$1 %result)
; (let %$3 (call @Texp$ptr.value-check (args %result (str-get 121))))
; %$3 -> i1
; (if %$3 (do (call @Texp$ptr.free (args %acc)) (let %$4 (load %result)) (store %$4 %acc) return-void))
; (call @Texp$ptr.free (args %acc))
; (let %$4 (load %result))
; %$4 -> %struct.Texp
; (store %$4 %acc)
; return-void
; (call @Texp$ptr.demote-free (args %result))
; (call @Texp$ptr.push$ptr (args %acc %result))
; (let %$5 (== %curr-index %last-index))
; %$5 -> i1
; (if %$5 (do return-void))
; return-void
; (let %next-index (+ 1 %curr-index))
; %next-index -> u64
; (call @Matcher$ptr.exact_ (args %this %texp %prod %acc %next-index %last-index))
; return-void
; def @Matcher$ptr.exact env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (let %$3 (index %texp 2))
; %$3 -> u64*
; (let %$2 (load %$3))
; %$2 -> u64
; (let %$5 (index %rule 2))
; %$5 -> u64*
; (let %$4 (load %$5))
; %$4 -> u64
; (let %$1 (!= %$2 %$4))
; %$1 -> i1
; (if %$1 (do (auto %len-result %struct.Texp) (let %$6 (call @Result.error-from-i8$ptr (args (str-get 122)))) (store %$6 %len-result) (let %$7 (call @Texp$ptr.clone (args %texp))) (call @Texp$ptr.push (args %len-result %$7)) (let %$8 (call @Texp$ptr.clone (args %rule))) (call @Texp$ptr.push (args %len-result %$8)) (let %$9 (load %len-result)) (return %$9)))
; (auto %len-result %struct.Texp)
; %len-result -> %struct.Texp*
; (let %$6 (call @Result.error-from-i8$ptr (args (str-get 122))))
; %$6 -> %struct.Texp
; (store %$6 %len-result)
; (let %$7 (call @Texp$ptr.clone (args %texp)))
; %$7 -> %struct.Texp
; (call @Texp$ptr.push (args %len-result %$7))
; (let %$8 (call @Texp$ptr.clone (args %rule)))
; %$8 -> %struct.Texp
; (call @Texp$ptr.push (args %len-result %$8))
; (let %$9 (load %len-result))
; %$9 -> %struct.Texp
; (return %$9)
; (call @i8$ptr.unsafe-print (args (str-get 123)))
; (call @Texp$ptr.parenPrint (args %texp))
; (call @i8$ptr.unsafe-print (args (str-get 124)))
; (call @Texp$ptr.parenPrint (args %rule))
; (call @println args)
; (auto %proof %struct.Texp)
; %proof -> %struct.Texp*
; (let %$10 (call @Texp.makeFromi8$ptr (args (str-get 125))))
; %$10 -> %struct.Texp
; (store %$10 %proof)
; (let %$12 (index %texp 2))
; %$12 -> u64*
; (let %$11 (load %$12))
; %$11 -> u64
; (let %last (- %$11 1))
; %last -> u64
; (call @Matcher$ptr.exact_ (args %this %texp %prod %proof 0 %last))
; (auto %proof-success-wrapper %struct.Texp)
; %proof-success-wrapper -> %struct.Texp*
; (let %$13 (call @Texp.makeFromi8$ptr (args (str-get 126))))
; %$13 -> %struct.Texp
; (store %$13 %proof-success-wrapper)
; (call @Texp$ptr.push$ptr (args %proof-success-wrapper %proof))
; (let %$14 (load %proof-success-wrapper))
; %$14 -> %struct.Texp
; (return %$14)
; def @Matcher$ptr.choice_ env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; %i -> u64
; %attempts -> %struct.Texp*
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (let %rule-child (call @Texp$ptr.child (args %rule %i)))
; %rule-child -> %struct.Texp*
; (call @i8$ptr.unsafe-print (args (str-get 127)))
; (call @u64.print (args %i))
; (call @i8$ptr.unsafe-print (args (str-get 128)))
; (call @Texp$ptr.parenPrint (args %texp))
; (call @i8$ptr.unsafe-print (args (str-get 129)))
; (call @Texp$ptr.parenPrint (args %rule-child))
; (call @println args)
; (let %rule-child-view (call @Texp$ptr.value-view (args %rule-child)))
; %rule-child-view -> %struct.StringView*
; (auto %is-result %struct.Texp)
; %is-result -> %struct.Texp*
; (let %$1 (call @Matcher$ptr.is (args %this %texp %rule-child-view)))
; %$1 -> %struct.Texp
; (store %$1 %is-result)
; (let %$2 (call @Texp$ptr.value-check (args %is-result (str-get 130))))
; %$2 -> i1
; (if %$2 (do (let %$4 (index %is-result 1)) (let %$3 (load %$4)) (let %proof-value-ref (index %$3 0)) (auto %choice-marker %struct.String) (let %$5 (call @String.makeFromi8$ptr (args (str-get 131)))) (store %$5 %choice-marker) (call @String$ptr.prepend (args %proof-value-ref %choice-marker)) (let %$6 (load %is-result)) (return %$6)))
; (let %$4 (index %is-result 1))
; %$4 -> %struct.Texp**
; (let %$3 (load %$4))
; %$3 -> %struct.Texp*
; (let %proof-value-ref (index %$3 0))
; %proof-value-ref -> %struct.String*
; (auto %choice-marker %struct.String)
; %choice-marker -> %struct.String*
; (let %$5 (call @String.makeFromi8$ptr (args (str-get 131))))
; %$5 -> %struct.String
; (store %$5 %choice-marker)
; (call @String$ptr.prepend (args %proof-value-ref %choice-marker))
; (let %$6 (load %is-result))
; %$6 -> %struct.Texp
; (return %$6)
; (auto %keyword-result %struct.Texp)
; %keyword-result -> %struct.Texp*
; (let %$8 (index %this 0))
; %$8 -> %struct.Grammar*
; (let %$7 (call @Grammar$ptr.get-keyword (args %$8 %rule-child-view)))
; %$7 -> %struct.Texp
; (store %$7 %keyword-result)
; (let %$10 (call @Texp$ptr.value-view (args %texp)))
; %$10 -> %struct.StringView*
; (let %$11 (call @Texp$ptr.value-view (args %keyword-result)))
; %$11 -> %struct.StringView*
; (let %$9 (call @StringView$ptr.eq (args %$10 %$11)))
; %$9 -> i1
; (if %$9 (do (auto %keyword-error-result %struct.Texp) (let %$12 (call @Result.error-from-i8$ptr (args (str-get 132)))) (store %$12 %keyword-error-result) (let %$13 (call @Texp$ptr.clone (args %prod))) (call @Texp$ptr.push (args %keyword-error-result %$13)) (let %$14 (call @Texp$ptr.clone (args %texp))) (call @Texp$ptr.push (args %keyword-error-result %$14)) (call @Texp$ptr.push$ptr (args %keyword-error-result %is-result)) (let %$15 (load %keyword-error-result)) (return %$15)))
; (auto %keyword-error-result %struct.Texp)
; %keyword-error-result -> %struct.Texp*
; (let %$12 (call @Result.error-from-i8$ptr (args (str-get 132))))
; %$12 -> %struct.Texp
; (store %$12 %keyword-error-result)
; (let %$13 (call @Texp$ptr.clone (args %prod)))
; %$13 -> %struct.Texp
; (call @Texp$ptr.push (args %keyword-error-result %$13))
; (let %$14 (call @Texp$ptr.clone (args %texp)))
; %$14 -> %struct.Texp
; (call @Texp$ptr.push (args %keyword-error-result %$14))
; (call @Texp$ptr.push$ptr (args %keyword-error-result %is-result))
; (let %$15 (load %keyword-error-result))
; %$15 -> %struct.Texp
; (return %$15)
; (let %$17 (index %rule 2))
; %$17 -> u64*
; (let %$16 (load %$17))
; %$16 -> u64
; (let %last-rule-index (- %$16 1))
; %last-rule-index -> u64
; (let %$18 (== %i %last-rule-index))
; %$18 -> i1
; (if %$18 (do (auto %choice-match-error-result %struct.Texp) (let %$19 (call @Result.error-from-i8$ptr (args (str-get 133)))) (store %$19 %choice-match-error-result) (let %$20 (call @Texp$ptr.clone (args %prod))) (call @Texp$ptr.push (args %choice-match-error-result %$20)) (let %$21 (call @Texp$ptr.clone (args %texp))) (call @Texp$ptr.push (args %choice-match-error-result %$21)) (call @Texp$ptr.push$ptr (args %choice-match-error-result %attempts)) (let %$22 (load %choice-match-error-result)) (return %$22)))
; (auto %choice-match-error-result %struct.Texp)
; %choice-match-error-result -> %struct.Texp*
; (let %$19 (call @Result.error-from-i8$ptr (args (str-get 133))))
; %$19 -> %struct.Texp
; (store %$19 %choice-match-error-result)
; (let %$20 (call @Texp$ptr.clone (args %prod)))
; %$20 -> %struct.Texp
; (call @Texp$ptr.push (args %choice-match-error-result %$20))
; (let %$21 (call @Texp$ptr.clone (args %texp)))
; %$21 -> %struct.Texp
; (call @Texp$ptr.push (args %choice-match-error-result %$21))
; (call @Texp$ptr.push$ptr (args %choice-match-error-result %attempts))
; (let %$22 (load %choice-match-error-result))
; %$22 -> %struct.Texp
; (return %$22)
; (call @Texp$ptr.push$ptr (args %attempts %is-result))
; (let %$24 (+ 1 %i))
; %$24 -> u64
; (let %$23 (call @Matcher$ptr.choice_ (args %this %texp %prod %$24 %attempts)))
; %$23 -> %struct.Texp
; (return %$23)
; def @Matcher$ptr.choice env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; (call @i8$ptr.unsafe-print (args (str-get 134)))
; (let %$0 (call @Texp$ptr.last (args %prod)))
; %$0 -> %struct.Texp*
; (call @Texp$ptr.parenPrint (args %$0))
; (call @println args)
; (auto %proof %struct.Texp)
; %proof -> %struct.Texp*
; (let %$1 (call @Texp.makeFromi8$ptr (args (str-get 135))))
; %$1 -> %struct.Texp
; (store %$1 %proof)
; (auto %attempts %struct.Texp)
; %attempts -> %struct.Texp*
; (let %$2 (call @Texp.makeFromi8$ptr (args (str-get 136))))
; %$2 -> %struct.Texp
; (store %$2 %attempts)
; (let %$3 (call @Matcher$ptr.choice_ (args %this %texp %prod 0 %attempts)))
; %$3 -> %struct.Texp
; (return %$3)
; def @Matcher.regexInt_ env
; %curr -> i8*
; %len -> u64
; (let %$0 (== 0 %len))
; %$0 -> i1
; (if %$0 (do (return true)))
; (return true)
; (let %ZERO (+ 48 (0 i8)))
; %ZERO -> i8
; (let %$1 (load %curr))
; %$1 -> i8
; (let %offset (- %$1 %ZERO))
; %offset -> i8
; (let %$2 (< %offset 0))
; %$2 -> i1
; (if %$2 (do (return false)))
; (return false)
; (let %$3 (>= %offset 10))
; %$3 -> i1
; (if %$3 (do (return false)))
; (return false)
; (let %$7 (cast u64 %curr))
; value: (type-value i8* %curr)
; %$7 -> u64
; (let %$6 (+ 1 %$7))
; %$6 -> u64
; (let %$5 (cast i8* %$6))
; value: (type-value u64 %$6)
; %$5 -> i8*
; (let %$8 (- %len 1))
; %$8 -> u64
; (let %$4 (call @Matcher.regexInt_ (args %$5 %$8)))
; %$4 -> i1
; (return %$4)
; def @Matcher.regexInt env
; %texp -> %struct.Texp*
; (let %view (call @Texp$ptr.value-view (args %texp)))
; %view -> %struct.StringView*
; (let %$2 (index %view 0))
; %$2 -> i8**
; (let %$1 (load %$2))
; %$1 -> i8*
; (let %$4 (index %view 1))
; %$4 -> u64*
; (let %$3 (load %$4))
; %$3 -> u64
; (let %$0 (call @Matcher.regexInt_ (args %$1 %$3)))
; %$0 -> i1
; (return %$0)
; def @Matcher.regexString_ env
; %curr -> i8*
; %len -> u64
; (return true)
; def @Matcher.regexString env
; %texp -> %struct.Texp*
; (let %view (call @Texp$ptr.value-view (args %texp)))
; %view -> %struct.StringView*
; (let %$0 (index %view 0))
; %$0 -> i8**
; (let %curr (load %$0))
; %curr -> i8*
; (let %$1 (index %view 1))
; %$1 -> u64*
; (let %len (load %$1))
; %len -> u64
; (let %$2 (< %len 2))
; %$2 -> i1
; (if %$2 (do (return false)))
; (return false)
; (let %$4 (- %len 1))
; %$4 -> u64
; (let %$5 (cast u64 %curr))
; value: (type-value i8* %curr)
; %$5 -> u64
; (let %$3 (+ %$4 %$5))
; %$3 -> u64
; (let %last (cast i8* %$3))
; value: (type-value u64 %$3)
; %last -> i8*
; (let %QUOTE (+ 34 (0 i8)))
; %QUOTE -> i8
; (let %$7 (load %curr))
; %$7 -> i8
; (let %$6 (!= %QUOTE %$7))
; %$6 -> i1
; (if %$6 (do (return false)))
; (return false)
; (let %$9 (load %last))
; %$9 -> i8
; (let %$8 (!= %QUOTE %$9))
; %$8 -> i1
; (if %$8 (do (return false)))
; (return false)
; (let %$11 (cast u64 %curr))
; value: (type-value i8* %curr)
; %$11 -> u64
; (let %$10 (+ 1 %$11))
; %$10 -> u64
; (let %next (cast i8* %$10))
; value: (type-value u64 %$10)
; %next -> i8*
; (let %$13 (- %len 2))
; %$13 -> u64
; (let %$12 (call @Matcher.regexString_ (args %next %$13)))
; %$12 -> i1
; (return %$12)
; def @Matcher.regexBool env
; %texp -> %struct.Texp*
; (let %$0 (call @Texp$ptr.value-check (args %texp (str-get 137))))
; %$0 -> i1
; (if %$0 (do (return true)))
; (return true)
; (let %$1 (call @Texp$ptr.value-check (args %texp (str-get 138))))
; %$1 -> i1
; (if %$1 (do (return true)))
; (return true)
; (return false)
; def @Matcher$ptr.value env
; %this -> %struct.Matcher*
; %texp -> %struct.Texp*
; %prod -> %struct.Texp*
; (let %$0 (index %prod 1))
; %$0 -> %struct.Texp**
; (let %rule (load %$0))
; %rule -> %struct.Texp*
; (let %texp-value-view-ref (call @Texp$ptr.value-view (args %texp)))
; %texp-value-view-ref -> %struct.StringView*
; (let %rule-value-view-ref (call @Texp$ptr.value-view (args %rule)))
; %rule-value-view-ref -> %struct.StringView*
; (call @i8$ptr.unsafe-print (args (str-get 139)))
; (call @StringView$ptr.print (args %texp-value-view-ref))
; (call @i8$ptr.unsafe-print (args (str-get 140)))
; (call @StringView$ptr.print (args %rule-value-view-ref))
; (call @println args)
; (auto %rule-value-texp %struct.Texp)
; %rule-value-texp -> %struct.Texp*
; (let %$1 (call @Texp.makeFromStringView (args %rule-value-view-ref)))
; %$1 -> %struct.Texp
; (store %$1 %rule-value-texp)
; (auto %texp-value-texp %struct.Texp)
; %texp-value-texp -> %struct.Texp*
; (let %$2 (call @Texp.makeFromStringView (args %texp-value-view-ref)))
; %$2 -> %struct.Texp
; (store %$2 %texp-value-texp)
; (let %default-success (call @Result.success (args %rule-value-texp)))
; %default-success -> %struct.Texp
; (let %HASH (+ 35 (0 i8)))
; %HASH -> i8
; (let %$3 (call @Texp$ptr.value-get (args %rule 0)))
; %$3 -> i8
; (let %cond (== %HASH %$3))
; %cond -> i1
; (auto %error-result %struct.Texp)
; %error-result -> %struct.Texp*
; (let %$4 (call @Texp.makeEmpty args))
; %$4 -> %struct.Texp
; (store %$4 %error-result)
; (if %cond (do (let %$5 (call @Texp$ptr.value-check (args %rule (str-get 141)))) (if %$5 (do (let %$6 (call @Matcher.regexInt (args %texp))) (if %$6 (do (return %default-success))) (let %$7 (call @Result.error-from-i8$ptr (args (str-get 142)))) (store %$7 %error-result))) (let %$8 (call @Texp$ptr.value-check (args %rule (str-get 143)))) (if %$8 (do (let %$9 (call @Matcher.regexString (args %texp))) (if %$9 (do (return %default-success))) (let %$10 (call @Result.error-from-i8$ptr (args (str-get 144)))) (store %$10 %error-result))) (let %$11 (call @Texp$ptr.value-check (args %rule (str-get 145)))) (if %$11 (do (let %$12 (call @Matcher.regexBool (args %texp))) (if %$12 (do (return %default-success))) (let %$13 (call @Result.error-from-i8$ptr (args (str-get 146)))) (store %$13 %error-result))) (let %$14 (call @Texp$ptr.value-check (args %rule (str-get 147)))) (if %$14 (do (return %default-success))) (let %$15 (call @Texp$ptr.value-check (args %rule (str-get 148)))) (if %$15 (do (return %default-success))) (let %$16 (call @Texp$ptr.value-check (args %error-result (str-get 149)))) (if %$16 (do (call @Texp$ptr.push$ptr (args %error-result %texp)) (let %$17 (load %error-result)) (return %$17))) (call @i8$ptr.unsafe-print (args (str-get 150))) (call @StringView$ptr.print (args %rule-value-view-ref)) (call @i8$ptr.unsafe-print (args (str-get 151))) (call @Texp$ptr.parenPrint (args %rule)) (call @i8$ptr.unsafe-print (args (str-get 152))) (call @Texp$ptr.parenPrint (args %error-result)) (call @println args) (call @exit (args 1))))
; (let %$5 (call @Texp$ptr.value-check (args %rule (str-get 141))))
; %$5 -> i1
; (if %$5 (do (let %$6 (call @Matcher.regexInt (args %texp))) (if %$6 (do (return %default-success))) (let %$7 (call @Result.error-from-i8$ptr (args (str-get 142)))) (store %$7 %error-result)))
; (let %$6 (call @Matcher.regexInt (args %texp)))
; %$6 -> i1
; (if %$6 (do (return %default-success)))
; (return %default-success)
; (let %$7 (call @Result.error-from-i8$ptr (args (str-get 142))))
; %$7 -> %struct.Texp
; (store %$7 %error-result)
; (let %$8 (call @Texp$ptr.value-check (args %rule (str-get 143))))
; %$8 -> i1
; (if %$8 (do (let %$9 (call @Matcher.regexString (args %texp))) (if %$9 (do (return %default-success))) (let %$10 (call @Result.error-from-i8$ptr (args (str-get 144)))) (store %$10 %error-result)))
; (let %$9 (call @Matcher.regexString (args %texp)))
; %$9 -> i1
; (if %$9 (do (return %default-success)))
; (return %default-success)
; (let %$10 (call @Result.error-from-i8$ptr (args (str-get 144))))
; %$10 -> %struct.Texp
; (store %$10 %error-result)
; (let %$11 (call @Texp$ptr.value-check (args %rule (str-get 145))))
; %$11 -> i1
; (if %$11 (do (let %$12 (call @Matcher.regexBool (args %texp))) (if %$12 (do (return %default-success))) (let %$13 (call @Result.error-from-i8$ptr (args (str-get 146)))) (store %$13 %error-result)))
; (let %$12 (call @Matcher.regexBool (args %texp)))
; %$12 -> i1
; (if %$12 (do (return %default-success)))
; (return %default-success)
; (let %$13 (call @Result.error-from-i8$ptr (args (str-get 146))))
; %$13 -> %struct.Texp
; (store %$13 %error-result)
; (let %$14 (call @Texp$ptr.value-check (args %rule (str-get 147))))
; %$14 -> i1
; (if %$14 (do (return %default-success)))
; (return %default-success)
; (let %$15 (call @Texp$ptr.value-check (args %rule (str-get 148))))
; %$15 -> i1
; (if %$15 (do (return %default-success)))
; (return %default-success)
; (let %$16 (call @Texp$ptr.value-check (args %error-result (str-get 149))))
; %$16 -> i1
; (if %$16 (do (call @Texp$ptr.push$ptr (args %error-result %texp)) (let %$17 (load %error-result)) (return %$17)))
; (call @Texp$ptr.push$ptr (args %error-result %texp))
; (let %$17 (load %error-result))
; %$17 -> %struct.Texp
; (return %$17)
; (call @i8$ptr.unsafe-print (args (str-get 150)))
; (call @StringView$ptr.print (args %rule-value-view-ref))
; (call @i8$ptr.unsafe-print (args (str-get 151)))
; (call @Texp$ptr.parenPrint (args %rule))
; (call @i8$ptr.unsafe-print (args (str-get 152)))
; (call @Texp$ptr.parenPrint (args %error-result))
; (call @println args)
; (call @exit (args 1))
; (let %$18 (call @StringView$ptr.eq (args %rule-value-view-ref %texp-value-view-ref)))
; %$18 -> i1
; (if %$18 (do (return %default-success)))
; (return %default-success)
; (auto %keyword-match-error %struct.Texp)
; %keyword-match-error -> %struct.Texp*
; (let %$19 (call @Texp.makeFromi8$ptr (args (str-get 153))))
; %$19 -> %struct.Texp
; (store %$19 %keyword-match-error)
; (let %$20 (call @Texp.makeFromi8$ptr (args (str-get 154))))
; %$20 -> %struct.Texp
; (call @Texp$ptr.push (args %keyword-match-error %$20))
; (let %$21 (call @Texp$ptr.clone (args %rule-value-texp)))
; %$21 -> %struct.Texp
; (call @Texp$ptr.push (args %keyword-match-error %$21))
; (let %$22 (call @Texp$ptr.clone (args %texp-value-texp)))
; %$22 -> %struct.Texp
; (call @Texp$ptr.push (args %keyword-match-error %$22))
; (let %$23 (load %keyword-match-error))
; %$23 -> %struct.Texp
; (return %$23)
; def @test.matcher-simple env
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$0 (call @Parser.parse-file-i8$ptr (args (str-get 155))))
; %$0 -> %struct.Texp
; (store %$0 %prog)
; (auto %matcher %struct.Matcher)
; %matcher -> %struct.Matcher*
; (let %$2 (call @Parser.parse-file-i8$ptr (args (str-get 156))))
; %$2 -> %struct.Texp
; (let %$1 (call @Grammar.make (args %$2)))
; %$1 -> %struct.Grammar
; (let %$3 (index %matcher 0))
; %$3 -> %struct.Grammar*
; (store %$1 %$3)
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$4 (call @StringView.makeFromi8$ptr (args (str-get 157))))
; %$4 -> %struct.StringView
; (store %$4 %start-production)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$5 (call @Matcher$ptr.is (args %matcher %prog %start-production)))
; %$5 -> %struct.Texp
; (store %$5 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; return-void
; def @test.matcher-choice env
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$0 (call @Parser.parse-file-i8$ptr (args (str-get 158))))
; %$0 -> %struct.Texp
; (store %$0 %prog)
; (auto %matcher %struct.Matcher)
; %matcher -> %struct.Matcher*
; (let %$2 (call @Parser.parse-file-i8$ptr (args (str-get 159))))
; %$2 -> %struct.Texp
; (let %$1 (call @Grammar.make (args %$2)))
; %$1 -> %struct.Grammar
; (let %$3 (index %matcher 0))
; %$3 -> %struct.Grammar*
; (store %$1 %$3)
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$4 (call @StringView.makeFromi8$ptr (args (str-get 160))))
; %$4 -> %struct.StringView
; (store %$4 %start-production)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$5 (call @Matcher$ptr.is (args %matcher %prog %start-production)))
; %$5 -> %struct.Texp
; (store %$5 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; return-void
; def @test.matcher-kleene-seq env
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$0 (call @Parser.parse-file-i8$ptr (args (str-get 161))))
; %$0 -> %struct.Texp
; (store %$0 %prog)
; (auto %matcher %struct.Matcher)
; %matcher -> %struct.Matcher*
; (let %$2 (call @Parser.parse-file-i8$ptr (args (str-get 162))))
; %$2 -> %struct.Texp
; (let %$1 (call @Grammar.make (args %$2)))
; %$1 -> %struct.Grammar
; (let %$3 (index %matcher 0))
; %$3 -> %struct.Grammar*
; (store %$1 %$3)
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$4 (call @StringView.makeFromi8$ptr (args (str-get 163))))
; %$4 -> %struct.StringView
; (store %$4 %start-production)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$5 (call @Matcher$ptr.is (args %matcher %prog %start-production)))
; %$5 -> %struct.Texp
; (store %$5 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; return-void
; def @test.matcher-exact env
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$0 (call @Parser.parse-file-i8$ptr (args (str-get 164))))
; %$0 -> %struct.Texp
; (store %$0 %prog)
; (auto %matcher %struct.Matcher)
; %matcher -> %struct.Matcher*
; (let %$2 (call @Parser.parse-file-i8$ptr (args (str-get 165))))
; %$2 -> %struct.Texp
; (let %$1 (call @Grammar.make (args %$2)))
; %$1 -> %struct.Grammar
; (let %$3 (index %matcher 0))
; %$3 -> %struct.Grammar*
; (store %$1 %$3)
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$4 (call @StringView.makeFromi8$ptr (args (str-get 166))))
; %$4 -> %struct.StringView
; (store %$4 %start-production)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$5 (call @Matcher$ptr.is (args %matcher %prog %start-production)))
; %$5 -> %struct.Texp
; (store %$5 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; return-void
; def @test.matcher-value env
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$0 (call @Parser.parse-file-i8$ptr (args (str-get 167))))
; %$0 -> %struct.Texp
; (store %$0 %prog)
; (auto %matcher %struct.Matcher)
; %matcher -> %struct.Matcher*
; (let %$2 (call @Parser.parse-file-i8$ptr (args (str-get 168))))
; %$2 -> %struct.Texp
; (let %$1 (call @Grammar.make (args %$2)))
; %$1 -> %struct.Grammar
; (let %$3 (index %matcher 0))
; %$3 -> %struct.Grammar*
; (store %$1 %$3)
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$4 (call @StringView.makeFromi8$ptr (args (str-get 169))))
; %$4 -> %struct.StringView
; (store %$4 %start-production)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$5 (call @Matcher$ptr.is (args %matcher %prog %start-production)))
; %$5 -> %struct.Texp
; (store %$5 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; return-void
; def @test.matcher-empty-kleene env
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$0 (call @Parser.parse-file-i8$ptr (args (str-get 170))))
; %$0 -> %struct.Texp
; (store %$0 %prog)
; (auto %matcher %struct.Matcher)
; %matcher -> %struct.Matcher*
; (let %$2 (call @Parser.parse-file-i8$ptr (args (str-get 171))))
; %$2 -> %struct.Texp
; (let %$1 (call @Grammar.make (args %$2)))
; %$1 -> %struct.Grammar
; (let %$3 (index %matcher 0))
; %$3 -> %struct.Grammar*
; (store %$1 %$3)
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$4 (call @StringView.makeFromi8$ptr (args (str-get 172))))
; %$4 -> %struct.StringView
; (store %$4 %start-production)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$5 (call @Matcher$ptr.is (args %matcher %prog %start-production)))
; %$5 -> %struct.Texp
; (store %$5 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; return-void
; def @test.matcher-self env
; (auto %filename %struct.StringView)
; %filename -> %struct.StringView*
; (call @StringView$ptr.set (args %filename (str-get 173)))
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$0 (call @Parser.parse-file (args %filename)))
; %$0 -> %struct.Texp
; (store %$0 %prog)
; (auto %matcher %struct.Matcher)
; %matcher -> %struct.Matcher*
; (let %$2 (call @Parser.parse-file-i8$ptr (args (str-get 174))))
; %$2 -> %struct.Texp
; (let %$1 (call @Grammar.make (args %$2)))
; %$1 -> %struct.Grammar
; (let %$3 (index %matcher 0))
; %$3 -> %struct.Grammar*
; (store %$1 %$3)
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$4 (call @StringView.makeFromi8$ptr (args (str-get 175))))
; %$4 -> %struct.StringView
; (store %$4 %start-production)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$5 (call @Matcher$ptr.is (args %matcher %prog %start-production)))
; %$5 -> %struct.Texp
; (store %$5 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; return-void
; def @test.matcher-regexString env
; (auto %string %struct.Texp)
; %string -> %struct.Texp*
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 176))))
; %$0 -> %struct.Texp
; (store %$0 %string)
; (let %$1 (call @Matcher.regexString (args %string)))
; %$1 -> i1
; (if %$1 (do (call @i8$ptr.unsafe-println (args (str-get 177))) return-void))
; (call @i8$ptr.unsafe-println (args (str-get 177)))
; return-void
; (call @i8$ptr.unsafe-println (args (str-get 178)))
; return-void
; def @test.matcher-regexInt env
; (auto %string %struct.Texp)
; %string -> %struct.Texp*
; (let %actual (+ 1234567890 (0 u64)))
; %actual -> u64
; (let %$0 (call @Texp.makeFromi8$ptr (args (str-get 179))))
; %$0 -> %struct.Texp
; (store %$0 %string)
; (let %$1 (call @Matcher.regexInt (args %string)))
; %$1 -> i1
; (if %$1 (do (call @i8$ptr.unsafe-println (args (str-get 180))) return-void))
; (call @i8$ptr.unsafe-println (args (str-get 180)))
; return-void
; (call @i8$ptr.unsafe-println (args (str-get 181)))
; return-void
; def @main env
; %argc -> i32
; %argv -> i8**
; (let %$0 (!= 2 %argc))
; %$0 -> i1
; (if %$0 (do (call @i8$ptr.unsafe-println (args (str-get 182))) (call @exit (args 1))))
; (call @i8$ptr.unsafe-println (args (str-get 182)))
; (call @exit (args 1))
; (let %$2 (cast u64 %argv))
; value: (type-value i8** %argv)
; %$2 -> u64
; (let %$1 (+ 8 %$2))
; %$1 -> u64
; (let %arg (cast i8** %$1))
; value: (type-value u64 %$1)
; %arg -> i8**
; (auto %test-case %struct.String)
; %test-case -> %struct.String*
; (let %$4 (load %arg))
; %$4 -> i8*
; (let %$3 (call @String.makeFromi8$ptr (args %$4)))
; %$3 -> %struct.String
; (store %$3 %test-case)
; (call @i8$ptr.unsafe-print (args (str-get 183)))
; (call @String$ptr.println (args %test-case))
; (auto %test-dir %struct.String)
; %test-dir -> %struct.String*
; (let %$5 (call @String.makeFromi8$ptr (args (str-get 184))))
; %$5 -> %struct.String
; (store %$5 %test-dir)
; (auto %test-case-path %struct.String)
; %test-case-path -> %struct.String*
; (let %$6 (call @String.add (args %test-dir %test-case)))
; %$6 -> %struct.String
; (store %$6 %test-case-path)
; (auto %grammar-path %struct.String)
; %grammar-path -> %struct.String*
; (let %$7 (call @String.makeFromi8$ptr (args (str-get 185))))
; %$7 -> %struct.String
; (store %$7 %grammar-path)
; (call @String$ptr.prepend (args %grammar-path %test-case-path))
; (auto %texp-file-path %struct.String)
; %texp-file-path -> %struct.String*
; (let %$8 (call @String.makeFromi8$ptr (args (str-get 186))))
; %$8 -> %struct.String
; (store %$8 %texp-file-path)
; (call @String$ptr.prepend (args %texp-file-path %test-case-path))
; (auto %prog %struct.Texp)
; %prog -> %struct.Texp*
; (let %$10 (cast %struct.StringView* %texp-file-path))
; value: (type-value %struct.String* %texp-file-path)
; %$10 -> %struct.StringView*
; (let %$9 (call @Parser.parse-file (args %$10)))
; %$9 -> %struct.Texp
; (store %$9 %prog)
; (auto %matcher %struct.Matcher)
; %matcher -> %struct.Matcher*
; (let %$13 (cast %struct.StringView* %grammar-path))
; value: (type-value %struct.String* %grammar-path)
; %$13 -> %struct.StringView*
; (let %$12 (call @Parser.parse-file (args %$13)))
; %$12 -> %struct.Texp
; (let %$11 (call @Grammar.make (args %$12)))
; %$11 -> %struct.Grammar
; (let %$14 (index %matcher 0))
; %$14 -> %struct.Grammar*
; (store %$11 %$14)
; (auto %start-production %struct.StringView)
; %start-production -> %struct.StringView*
; (let %$15 (call @StringView.makeFromi8$ptr (args (str-get 187))))
; %$15 -> %struct.StringView
; (store %$15 %start-production)
; (auto %result %struct.Texp)
; %result -> %struct.Texp*
; (let %$16 (call @Matcher$ptr.is (args %matcher %prog %start-production)))
; %$16 -> %struct.Texp
; (store %$16 %result)
; (call @Texp$ptr.parenPrint (args %result))
; (call @println args)
; (return 0)
; ModuleID = lib/matcher-driver.bb
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; (lib/matcher-driver.bb (decl @malloc (types u64) i8*) (decl @free (types i8*) void) (decl @realloc (types i8* u64) i8*) (decl @calloc (types u64 u64) i8*) (decl @printf (types i8* ...) i32) (decl @puts (types i8*) i32) (decl @write (types i32 i8* u64) i64) (decl @read (types i32 i8* u64) i64) (decl @fflush (types i32) i32) (decl @memcpy (types i8* i8* u64) i8*) (decl @memmove (types i8* i8* u64) i8*) (decl @open (types i8* i32 ...) i32) (decl @lseek (types i32 i64 i32) i64) (decl @mmap (types i8* u64 i32 i32 i32 i64) i8*) (decl @munmap (types i8* u64) i32) (decl @close (types i32) i32) (decl @exit (types i32) void) (decl @perror (types i8*) void) (def @i8$ptr.length_ (params (%this i8*) (%acc u64)) u64 (do (let %$1 (load i8 %this)) (let %$0 (== i8 %$1 0)) (if %$0 (do (return %acc u64))) (let %$5 (ptrtoint i8* u64 %this)) (let %$4 (+ u64 1 %$5)) (let %$3 (inttoptr u64 i8* %$4)) (let %$6 (+ u64 %acc 1)) (let %$2 (call-tail @i8$ptr.length_ (types i8* u64) u64 (args %$3 %$6))) (return %$2 u64))) (def @i8$ptr.length (params (%this i8*)) u64 (do (let %$0 (call-tail @i8$ptr.length_ (types i8* u64) u64 (args %this 0))) (return %$0 u64))) (def @i8$ptr.printn (params (%this i8*) (%n u64)) void (do (let %FD_STDOUT (+ i32 1 0)) (call @write (types i32 i8* u64) i64 (args %FD_STDOUT %this %n)) return-void)) (def @i8$ptr.unsafe-print (params (%this i8*)) void (do (let %length (call @i8$ptr.length (types i8*) u64 (args %this))) (call @i8$ptr.printn (types i8* u64) void (args %this %length)) return-void)) (def @i8$ptr.unsafe-println (params (%this i8*)) void (do (call @i8$ptr.unsafe-print (types i8*) void (args %this)) (call @println types void args) return-void)) (def @i8$ptr.copyalloc (params (%this i8*)) i8* (do (let %length (call @i8$ptr.length (types i8*) u64 (args %this))) (let %$0 (+ u64 %length 1)) (let %allocated (call @malloc (types u64) i8* (args %$0))) (let %$3 (ptrtoint i8* u64 %allocated)) (let %$2 (+ u64 %length %$3)) (let %$1 (inttoptr u64 i8* %$2)) (store 0 i8 %$1) (call @memcpy (types i8* i8* u64) i8* (args %allocated %this %length)) (return %allocated i8*))) (def @i8.print (params (%this i8)) void (do (auto %c i8) (store %this i8 %c) (let %FD_STDOUT (+ i32 1 0)) (call @write (types i32 i8* u64) i64 (args %FD_STDOUT %c 1)) return-void)) (def @i8$ptr.swap (params (%this i8*) (%other i8*)) void (do (let %this_value (load i8 %this)) (let %other_value (load i8 %other)) (store %this_value i8 %other) (store %other_value i8 %this) return-void)) (def @i8$ptr.eqn (params (%this i8*) (%other i8*) (%len u64)) i1 (do (let %$0 (== u64 0 %len)) (if %$0 (do (return true i1))) (let %$2 (load i8 %this)) (let %$3 (load i8 %other)) (let %$1 (!= i8 %$2 %$3)) (if %$1 (do (return false i1))) (let %$5 (ptrtoint i8* u64 %this)) (let %$4 (+ u64 1 %$5)) (let %next-this (inttoptr u64 i8* %$4)) (let %$7 (ptrtoint i8* u64 %other)) (let %$6 (+ u64 1 %$7)) (let %next-other (inttoptr u64 i8* %$6)) (let %$9 (- u64 %len 1)) (let %$8 (call @i8$ptr.eqn (types i8* i8* u64) i1 (args %next-this %next-other %$9))) (return %$8 i1))) (def @println params void (do (let %NEWLINE (+ i8 10 0)) (call @i8.print (types i8) void (args %NEWLINE)) return-void)) (def @test.i8$ptr-eqn params void (do (auto %a %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %a) (auto %b %struct.String) (let %$1 (call @String.makeEmpty types %struct.String args)) (store %$1 %struct.String %b) (call @String$ptr.pushChar (types %struct.String* i8) void (args %a 65)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %a 66)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %a 67)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %a 68)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %b 65)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %b 66)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %b 67)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %b 68)) (let %a-cstr (bitcast %struct.String* i8* %a)) (let %b-cstr (bitcast %struct.String* i8* %b)) (let %$4 (call @i8$ptr.eqn (types i8* i8* u64) i1 (args %a-cstr %b-cstr 5))) (let %$3 (sext i1 i8 %$4)) (let %$2 (+ i8 48 %$3)) (call @i8.print (types i8) void (args %$2)) return-void)) (struct %struct.StringView (%ptr i8*) (%size u64)) (def @StringView.makeEmpty params %struct.StringView (do (auto %result %struct.StringView) (let %$0 (inttoptr i64 i8* 0)) (let %$1 (index %result %struct.StringView 0)) (store %$0 i8* %$1) (let %$2 (index %result %struct.StringView 1)) (store 0 u64 %$2) (let %$3 (load %struct.StringView %result)) (return %$3 %struct.StringView))) (def @StringView$ptr.set (params (%this %struct.StringView*) (%charptr i8*)) void (do (let %$0 (index %this %struct.StringView 0)) (store %charptr i8* %$0) (let %$1 (call @i8$ptr.length (types i8*) u64 (args %charptr))) (let %$2 (index %this %struct.StringView 1)) (store %$1 u64 %$2) return-void)) (def @StringView.make (params (%charptr i8*) (%size u64)) %struct.StringView (do (auto %result %struct.StringView) (let %$0 (index %result %struct.StringView 0)) (store %charptr i8* %$0) (let %$1 (index %result %struct.StringView 1)) (store %size u64 %$1) (let %$2 (load %struct.StringView %result)) (return %$2 %struct.StringView))) (def @StringView.makeFromi8$ptr (params (%charptr i8*)) %struct.StringView (do (auto %result %struct.StringView) (let %$0 (index %result %struct.StringView 0)) (store %charptr i8* %$0) (let %$1 (call @i8$ptr.length (types i8*) u64 (args %charptr))) (let %$2 (index %result %struct.StringView 1)) (store %$1 u64 %$2) (let %$3 (load %struct.StringView %result)) (return %$3 %struct.StringView))) (def @StringView$ptr.print (params (%this %struct.StringView*)) void (do (let %$1 (index %this %struct.StringView 0)) (let %$0 (load i8* %$1)) (let %$3 (index %this %struct.StringView 1)) (let %$2 (load u64 %$3)) (call @i8$ptr.printn (types i8* u64) void (args %$0 %$2)) return-void)) (def @StringView$ptr.println (params (%this %struct.StringView*)) void (do (call @StringView$ptr.print (types %struct.StringView*) void (args %this)) (call @println types void args) return-void)) (def @StringView.print (params (%this %struct.StringView)) void (do (auto %local %struct.StringView) (store %this %struct.StringView %local) (let %$1 (index %local %struct.StringView 0)) (let %$0 (load i8* %$1)) (let %$3 (index %local %struct.StringView 1)) (let %$2 (load u64 %$3)) (call @i8$ptr.printn (types i8* u64) void (args %$0 %$2)) return-void)) (def @StringView.println (params (%this %struct.StringView)) void (do (call @StringView.print (types %struct.StringView) void (args %this)) (call @println types void args) return-void)) (def @StringView$ptr.eq (params (%this %struct.StringView*) (%other %struct.StringView*)) i1 (do (let %$0 (index %this %struct.StringView 1)) (let %len (load u64 %$0)) (let %$1 (index %other %struct.StringView 1)) (let %olen (load u64 %$1)) (let %$2 (!= u64 %len %olen)) (if %$2 (do (return false i1))) (let %$5 (index %this %struct.StringView 0)) (let %$4 (load i8* %$5)) (let %$7 (index %other %struct.StringView 0)) (let %$6 (load i8* %$7)) (let %$3 (call @i8$ptr.eqn (types i8* i8* u64) i1 (args %$4 %$6 %len))) (return %$3 i1))) (def @StringView.eq (params (%this-value %struct.StringView) (%other-value %struct.StringView)) i1 (do (auto %this %struct.StringView) (store %this-value %struct.StringView %this) (auto %other %struct.StringView) (store %other-value %struct.StringView %other) (let %$0 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %this %other))) (return %$0 i1))) (struct %struct.String (%ptr i8*) (%size u64)) (def @String.makeEmpty params %struct.String (do (auto %result %struct.String) (let %$0 (inttoptr i64 i8* 0)) (let %$1 (index %result %struct.String 0)) (store %$0 i8* %$1) (let %$2 (index %result %struct.String 1)) (store 0 u64 %$2) (let %$3 (load %struct.String %result)) (return %$3 %struct.String))) (def @String$ptr.set (params (%this %struct.String*) (%charptr i8*)) void (do (let %$0 (call @i8$ptr.copyalloc (types i8*) i8* (args %charptr))) (let %$1 (index %this %struct.String 0)) (store %$0 i8* %$1) (let %$3 (call @i8$ptr.length (types i8*) u64 (args %charptr))) (let %$2 (- u64 %$3 1)) (let %$4 (index %this %struct.String 1)) (store %$2 u64 %$4) return-void)) (def @String.makeFromi8$ptr (params (%charptr i8*)) %struct.String (do (auto %this %struct.String) (let %$0 (call @i8$ptr.copyalloc (types i8*) i8* (args %charptr))) (let %$1 (index %this %struct.String 0)) (store %$0 i8* %$1) (let %$2 (call @i8$ptr.length (types i8*) u64 (args %charptr))) (let %$3 (index %this %struct.String 1)) (store %$2 u64 %$3) (let %$4 (load %struct.String %this)) (return %$4 %struct.String))) (def @String$ptr.copyalloc (params (%this %struct.String*)) %struct.String (do (auto %result %struct.String) (let %$2 (index %this %struct.String 0)) (let %$1 (load i8* %$2)) (let %$0 (call @i8$ptr.copyalloc (types i8*) i8* (args %$1))) (let %$3 (index %result %struct.String 0)) (store %$0 i8* %$3) (let %$5 (index %this %struct.String 1)) (let %$4 (load u64 %$5)) (let %$6 (index %result %struct.String 1)) (store %$4 u64 %$6) (let %$7 (load %struct.String %result)) (return %$7 %struct.String))) (def @String.makeFromStringView (params (%other %struct.StringView*)) %struct.String (do (let %$0 (index %other %struct.StringView 1)) (let %len (load u64 %$0)) (auto %result %struct.String) (let %$2 (+ u64 1 %len)) (let %$1 (call @malloc (types u64) i8* (args %$2))) (let %$3 (index %result %struct.String 0)) (store %$1 i8* %$3) (let %$5 (index %result %struct.String 0)) (let %$4 (load i8* %$5)) (let %$7 (index %other %struct.StringView 0)) (let %$6 (load i8* %$7)) (call @memcpy (types i8* i8* u64) i8* (args %$4 %$6 %len)) (let %$12 (index %result %struct.String 0)) (let %$11 (load i8* %$12)) (let %$10 (ptrtoint i8* u64 %$11)) (let %$9 (+ u64 %len %$10)) (let %$8 (inttoptr u64 i8* %$9)) (store 0 i8 %$8) (let %$13 (index %result %struct.String 1)) (store %len u64 %$13) (let %$14 (load %struct.String %result)) (return %$14 %struct.String))) (def @String$ptr.is-empty (params (%this %struct.String*)) i1 (do (let %$2 (index %this %struct.String 1)) (let %$1 (load u64 %$2)) (let %$0 (== u64 0 %$1)) (return %$0 i1))) (def @String$ptr.view (params (%this %struct.String*)) %struct.StringView (do (let %$1 (bitcast %struct.String* %struct.StringView* %this)) (let %$0 (load %struct.StringView %$1)) (return %$0 %struct.StringView))) (def @String$ptr.free (params (%this %struct.String*)) void (do (let %$1 (index %this %struct.String 0)) (let %$0 (load i8* %$1)) (call @free (types i8*) void (args %$0)) return-void)) (def @String$ptr.setFromChar (params (%this %struct.String*) (%c i8)) void (do (let %ptr-ref (index %this %struct.String 0)) (let %size-ref (index %this %struct.String 1)) (let %ptr (call @malloc (types u64) i8* (args 2))) (store %c i8 %ptr) (let %$2 (ptrtoint i8* u64 %ptr)) (let %$1 (+ u64 1 %$2)) (let %$0 (inttoptr u64 i8* %$1)) (store 0 i8 %$0) (store %ptr i8* %ptr-ref) (store 1 u64 %size-ref) return-void)) (def @String$ptr.append (params (%this %struct.String*) (%other %struct.String*)) void (do (let %same-string (== %struct.String* %this %other)) (if %same-string (do (auto %temp-copy %struct.String) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %other))) (store %$0 %struct.String %temp-copy) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %this %temp-copy)) (let %$2 (index %temp-copy %struct.String 0)) (let %$1 (load i8* %$2)) (call @free (types i8*) void (args %$1)) return-void)) (let %$3 (index %this %struct.String 1)) (let %old-length (load u64 %$3)) (let %$5 (index %other %struct.String 1)) (let %$4 (load u64 %$5)) (let %new-length (+ u64 %old-length %$4)) (let %$8 (index %this %struct.String 0)) (let %$7 (load i8* %$8)) (let %$9 (+ u64 1 %new-length)) (let %$6 (call @realloc (types i8* u64) i8* (args %$7 %$9))) (let %$10 (index %this %struct.String 0)) (store %$6 i8* %$10) (let %end-of-this-string (call @String$ptr.end (types %struct.String*) i8* (args %this))) (let %$11 (index %this %struct.String 1)) (store %new-length u64 %$11) (let %$13 (index %other %struct.String 0)) (let %$12 (load i8* %$13)) (let %$15 (index %other %struct.String 1)) (let %$14 (load u64 %$15)) (call @memcpy (types i8* i8* u64) i8* (args %end-of-this-string %$12 %$14)) return-void)) (def @String$ptr.prepend (params (%this %struct.String*) (%other %struct.String*)) void (do (let %same-string (== %struct.String* %this %other)) (if %same-string (do (auto %temp-copy %struct.String) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %other))) (store %$0 %struct.String %temp-copy) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %this %temp-copy)) (let %$2 (index %temp-copy %struct.String 0)) (let %$1 (load i8* %$2)) (call @free (types i8*) void (args %$1)) return-void)) (let %$3 (index %this %struct.String 1)) (let %old-length (load u64 %$3)) (let %$4 (index %other %struct.String 1)) (let %other-length (load u64 %$4)) (let %new-length (+ u64 %old-length %other-length)) (let %$5 (index %this %struct.String 1)) (store %new-length u64 %$5) (let %$8 (index %this %struct.String 0)) (let %$7 (load i8* %$8)) (let %$9 (+ u64 1 %new-length)) (let %$6 (call @realloc (types i8* u64) i8* (args %$7 %$9))) (let %$10 (index %this %struct.String 0)) (store %$6 i8* %$10) (let %$11 (index %this %struct.String 0)) (let %new-start (load i8* %$11)) (let %$12 (index %other %struct.String 0)) (let %other-start (load i8* %$12)) (let %$14 (ptrtoint i8* u64 %new-start)) (let %$13 (+ u64 %other-length %$14)) (let %midpoint (inttoptr u64 i8* %$13)) (call @memmove (types i8* i8* u64) i8* (args %midpoint %new-start %old-length)) (call @memcpy (types i8* i8* u64) i8* (args %new-start %other-start %other-length)) return-void)) (def @String.add (params (%left %struct.String*) (%right %struct.String*)) %struct.String (do (auto %result %struct.String) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %left))) (store %$0 %struct.String %result) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %result %right)) (let %$1 (load %struct.String %result)) (return %$1 %struct.String))) (def @String$ptr.end (params (%this %struct.String*)) i8* (do (let %$0 (index %this %struct.String 0)) (let %begin (load i8* %$0)) (let %$1 (index %this %struct.String 1)) (let %length (load u64 %$1)) (let %$3 (ptrtoint i8* u64 %begin)) (let %$2 (+ u64 %$3 %length)) (let %one-past-last (inttoptr u64 i8* %$2)) (return %one-past-last i8*))) (def @String$ptr.pushChar (params (%this %struct.String*) (%c i8)) void (do (let %ptr-ref (index %this %struct.String 0)) (let %size-ref (index %this %struct.String 1)) (let %$2 (load i8* %ptr-ref)) (let %$1 (ptrtoint i8* u64 %$2)) (let %$0 (== u64 0 %$1)) (if %$0 (do (call-tail @String$ptr.setFromChar (types %struct.String* i8) void (args %this %c)) return-void)) (let %old-size (load u64 %size-ref)) (let %$4 (load i8* %ptr-ref)) (let %$5 (+ u64 2 %old-size)) (let %$3 (call @realloc (types i8* u64) i8* (args %$4 %$5))) (store %$3 i8* %ptr-ref) (let %$6 (+ u64 1 %old-size)) (store %$6 u64 %size-ref) (let %$9 (load i8* %ptr-ref)) (let %$8 (ptrtoint i8* u64 %$9)) (let %$7 (+ u64 %old-size %$8)) (let %new-char-loc (inttoptr u64 i8* %$7)) (store %c i8 %new-char-loc) return-void)) (def @reverse-pair (params (%begin i8*) (%end i8*)) void (do (let %$1 (ptrtoint i8* u64 %begin)) (let %$2 (ptrtoint i8* u64 %end)) (let %$0 (>= u64 %$1 %$2)) (if %$0 (do return-void)) (call @i8$ptr.swap (types i8* i8*) void (args %begin %end)) (let %$4 (ptrtoint i8* u64 %begin)) (let %$3 (+ u64 %$4 1)) (let %next-begin (inttoptr u64 i8* %$3)) (let %$6 (ptrtoint i8* u64 %end)) (let %$5 (- u64 %$6 1)) (let %next-end (inttoptr u64 i8* %$5)) (call-tail @reverse-pair (types i8* i8*) void (args %next-begin %next-end)) return-void)) (def @String$ptr.reverse-in-place (params (%this %struct.String*)) void (do (let %$0 (index %this %struct.String 0)) (let %begin (load i8* %$0)) (let %$1 (index %this %struct.String 1)) (let %size (load u64 %$1)) (let %$2 (== u64 0 %size)) (if %$2 (do return-void)) (let %$4 (- u64 %size 1)) (let %$5 (ptrtoint i8* u64 %begin)) (let %$3 (+ u64 %$4 %$5)) (let %end (inttoptr u64 i8* %$3)) (call-tail @reverse-pair (types i8* i8*) void (args %begin %end)) return-void)) (def @String$ptr.char-at-unsafe (params (%this %struct.String*) (%i u64)) i8 (do (let %$0 (index %this %struct.String 0)) (let %begin (load i8* %$0)) (let %$4 (ptrtoint i8* u64 %begin)) (let %$3 (+ u64 %i %$4)) (let %$2 (inttoptr u64 i8* %$3)) (let %$1 (load i8 %$2)) (return %$1 i8))) (def @String$ptr.print (params (%this %struct.String*)) void (do (let %$1 (index %this %struct.String 0)) (let %$0 (load i8* %$1)) (let %$3 (index %this %struct.String 1)) (let %$2 (load u64 %$3)) (call @i8$ptr.printn (types i8* u64) void (args %$0 %$2)) return-void)) (def @String$ptr.println (params (%this %struct.String*)) void (do (let %$1 (index %this %struct.String 0)) (let %$0 (load i8* %$1)) (let %$3 (index %this %struct.String 1)) (let %$2 (load u64 %$3)) (call @i8$ptr.printn (types i8* u64) void (args %$0 %$2)) (call @println types void args) return-void)) (def @test.strlen params void (do (let %str-example (str-get 0)) (let %$0 (call @i8$ptr.length (types i8*) u64 (args (str-get 3)))) (call-vargs @printf (types i8* i8* u64) i32 (args (str-get 1) (str-get 2) %$0)) return-void)) (def @test.strview params void (do (auto %string-view %struct.StringView) (let %$0 (call @StringView.makeEmpty types %struct.StringView args)) (store %$0 %struct.StringView %string-view) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %string-view (str-get 4))) (let %$2 (index %string-view %struct.StringView 0)) (let %$1 (load i8* %$2)) (let %$4 (index %string-view %struct.StringView 1)) (let %$3 (load u64 %$4)) (call-vargs @printf (types i8* i8* u64) i32 (args (str-get 5) %$1 %$3)) return-void)) (def @test.basic-string params void (do (auto %string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %string (str-get 6))) (let %$1 (index %string %struct.String 0)) (let %$0 (load i8* %$1)) (let %$3 (index %string %struct.String 1)) (let %$2 (load u64 %$3)) (call-vargs @printf (types i8* i8* u64) i32 (args (str-get 7) %$0 %$2)) return-void)) (def @test.string-self-append params void (do (auto %string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %string (str-get 8))) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %string %string)) (let %$1 (index %string %struct.String 0)) (let %$0 (load i8* %$1)) (call @puts (types i8*) i32 (args %$0)) return-void)) (def @test.string-append-helloworld params void (do (auto %hello %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello (str-get 9))) (auto %world %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %world (str-get 10))) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %hello %world)) (let %$1 (index %hello %struct.String 0)) (let %$0 (load i8* %$1)) (call @puts (types i8*) i32 (args %$0)) return-void)) (def @test.string-pushchar params void (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (let %A (+ i8 65 0)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %A)) (let %$2 (index %acc %struct.String 0)) (let %$1 (load i8* %$2)) (call @puts (types i8*) i32 (args %$1)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %A)) (let %$4 (index %acc %struct.String 0)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %A)) (let %$6 (index %acc %struct.String 0)) (let %$5 (load i8* %$6)) (call @puts (types i8*) i32 (args %$5)) return-void)) (def @test.string-reverse-in-place params void (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (let %A (+ i8 65 0)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %A)) (let %$2 (index %acc %struct.String 0)) (let %$1 (load i8* %$2)) (call @puts (types i8*) i32 (args %$1)) (let %$3 (+ i8 1 %A)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %$3)) (let %$5 (index %acc %struct.String 0)) (let %$4 (load i8* %$5)) (call @puts (types i8*) i32 (args %$4)) (let %$6 (+ i8 2 %A)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %$6)) (let %$8 (index %acc %struct.String 0)) (let %$7 (load i8* %$8)) (call @puts (types i8*) i32 (args %$7)) (let %$9 (index %acc %struct.String 0)) (let %begin (load i8* %$9)) (let %$10 (index %acc %struct.String 1)) (let %size (load u64 %$10)) (let %$12 (- u64 %size 1)) (let %$13 (ptrtoint i8* u64 %begin)) (let %$11 (+ u64 %$12 %$13)) (let %end (inttoptr u64 i8* %$11)) (call @u64.print (types u64) void (args %size)) (let %$14 (load i8 %begin)) (call @i8.print (types i8) void (args %$14)) (let %$15 (load i8 %end)) (call @i8.print (types i8) void (args %$15)) (call @println types void args) (call @i8$ptr.swap (types i8* i8*) void (args %begin %end)) (let %$17 (index %acc %struct.String 0)) (let %$16 (load i8* %$17)) (call @puts (types i8*) i32 (args %$16)) (call @String$ptr.reverse-in-place (types %struct.String*) void (args %acc)) (let %$19 (index %acc %struct.String 0)) (let %$18 (load i8* %$19)) (call @puts (types i8*) i32 (args %$18)) return-void)) (def @test.stringview-nonpointer-eq params void (do (let %$0 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 11)))) (let %$1 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 12)))) (let %passed (call @StringView.eq (types %struct.StringView %struct.StringView) i1 (args %$0 %$1))) (if %passed (do (call @puts (types i8*) i32 (args (str-get 13))) return-void)) (call @puts (types i8*) i32 (args (str-get 14))) return-void)) (def @test.string-prepend-helloworld params void (do (auto %hello %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello (str-get 15))) (auto %world %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %world (str-get 16))) (call @String$ptr.prepend (types %struct.String* %struct.String*) void (args %world %hello)) (call @String$ptr.println (types %struct.String*) void (args %world)) (call @String$ptr.free (types %struct.String*) void (args %world)) (call @String$ptr.free (types %struct.String*) void (args %hello)) return-void)) (struct %struct.File (%name %struct.String) (%file_descriptor i32)) (def @File._open (params (%filename-view %struct.StringView*) (%flags i32)) %struct.File (do (auto %result %struct.File) (let %$0 (index %filename-view %struct.StringView 0)) (let %filename (load i8* %$0)) (let %$1 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %filename-view))) (let %$2 (index %result %struct.File 0)) (store %$1 %struct.String %$2) (let %fd (call-vargs @open (types i8* i32) i32 (args %filename %flags))) (let %$4 (- i32 0 1)) (let %$3 (== i32 %fd %$4)) (if %$3 (do (call-vargs @printf (types i8* i8*) i32 (args (str-get 17) %filename)) (call @exit (types i32) void (args 1)))) (let %$5 (index %result %struct.File 1)) (store %fd i32 %$5) (let %$6 (load %struct.File %result)) (return %$6 %struct.File))) (def @File.open (params (%filename-view %struct.StringView*)) %struct.File (do (let %O_RDONLY (+ i32 0 0)) (let %$0 (call @File._open (types %struct.StringView* i32) %struct.File (args %filename-view %O_RDONLY))) (return %$0 %struct.File))) (def @File.openrw (params (%filename-view %struct.StringView*)) %struct.File (do (let %O_RDWR (+ i32 2 0)) (let %$0 (call @File._open (types %struct.StringView* i32) %struct.File (args %filename-view %O_RDWR))) (return %$0 %struct.File))) (def @File$ptr.getSize (params (%this %struct.File*)) i64 (do (let %SEEK_END (+ i32 2 0)) (let %$2 (index %this %struct.File 1)) (let %$1 (load i32 %$2)) (let %$0 (call @lseek (types i32 i64 i32) i64 (args %$1 0 %SEEK_END))) (return %$0 i64))) (def @File$ptr._mmap (params (%this %struct.File*) (%addr i8*) (%file-length i64) (%prot i32) (%flags i32) (%offset i64)) i8* (do (let %$1 (index %this %struct.File 1)) (let %$0 (load i32 %$1)) (let %result (call @mmap (types i8* u64 i32 i32 i32 i64) i8* (args %addr %file-length %prot %flags %$0 %offset))) (let %$3 (- u64 0 1)) (let %$4 (ptrtoint i8* u64 %result)) (let %$2 (== u64 %$3 %$4)) (if %$2 (do (call @perror (types i8*) void (args (str-get 18))) (call @exit (types i32) void (args 0)))) (return %result i8*))) (def @File$ptr.read (params (%this %struct.File*)) %struct.StringView (do (let %PROT_READ (+ i32 1 0)) (let %MAP_PRIVATE (+ i32 2 0)) (let %file-length (call @File$ptr.getSize (types %struct.File*) i64 (args %this))) (let %$0 (inttoptr u64 i8* 0)) (let %char-ptr (call @File$ptr._mmap (types %struct.File* i8* i64 i32 i32 i64) i8* (args %this %$0 %file-length %PROT_READ %MAP_PRIVATE 0))) (let %$1 (call @StringView.make (types i8* u64) %struct.StringView (args %char-ptr %file-length))) (return %$1 %struct.StringView))) (def @File$ptr.readwrite (params (%this %struct.File*)) %struct.StringView (do (let %PROT_RDWR (+ i32 3 0)) (let %MAP_PRIVATE (+ i32 2 0)) (let %file-length (call @File$ptr.getSize (types %struct.File*) i64 (args %this))) (let %$0 (inttoptr u64 i8* 0)) (let %char-ptr (call @File$ptr._mmap (types %struct.File* i8* i64 i32 i32 i64) i8* (args %this %$0 %file-length %PROT_RDWR %MAP_PRIVATE 0))) (let %$1 (call @StringView.make (types i8* u64) %struct.StringView (args %char-ptr %file-length))) (return %$1 %struct.StringView))) (def @File.unread (params (%view %struct.StringView*)) void (do (let %$1 (index %view %struct.StringView 0)) (let %$0 (load i8* %$1)) (let %$3 (index %view %struct.StringView 1)) (let %$2 (load u64 %$3)) (call @munmap (types i8* u64) i32 (args %$0 %$2)) return-void)) (def @File$ptr.close (params (%this %struct.File*)) void (do (let %$1 (index %this %struct.File 1)) (let %$0 (load i32 %$1)) (call @close (types i32) i32 (args %$0)) return-void)) (def @test.file-cat params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 19))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %$1 (index %file %struct.File 0)) (call @String$ptr.println (types %struct.String*) void (args %$1)) (auto %content %struct.StringView) (let %$2 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$2 %struct.StringView %content) (call @StringView$ptr.print (types %struct.StringView*) void (args %content)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.file-size params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 20))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %size (call @File$ptr.getSize (types %struct.File*) i64 (args %file))) (call-vargs @printf (types i8* i64) i32 (args (str-get 21) %size)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.bad-file-open params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 22))) (call @File.open (types %struct.StringView*) %struct.File (args %filename)) return-void)) (struct %struct.Reader (%content %struct.StringView) (%iter i8*) (%prev i8) (%line u64) (%col u64)) (def @Reader$ptr.set (params (%this %struct.Reader*) (%string-view %struct.StringView*)) void (do (let %$0 (load %struct.StringView %string-view)) (let %$1 (index %this %struct.Reader 0)) (store %$0 %struct.StringView %$1) (let %content (index %this %struct.Reader 0)) (let %$3 (index %string-view %struct.StringView 0)) (let %$2 (load i8* %$3)) (let %$4 (index %this %struct.Reader 1)) (store %$2 i8* %$4) (let %$5 (index %this %struct.Reader 2)) (store 0 i8 %$5) (let %$6 (index %this %struct.Reader 3)) (store 0 u64 %$6) (let %$7 (index %this %struct.Reader 4)) (store 0 u64 %$7) return-void)) (def @Reader$ptr.peek (params (%this %struct.Reader*)) i8 (do (let %$2 (index %this %struct.Reader 1)) (let %$1 (load i8* %$2)) (let %$0 (load i8 %$1)) (return %$0 i8))) (def @Reader$ptr.get (params (%this %struct.Reader*)) i8 (do (let %iter-ref (index %this %struct.Reader 1)) (let %$0 (load i8* %iter-ref)) (let %char (load i8 %$0)) (let %$1 (index %this %struct.Reader 2)) (store %char i8 %$1) (let %$5 (load i8* %iter-ref)) (let %$4 (ptrtoint i8* u64 %$5)) (let %$3 (+ u64 1 %$4)) (let %$2 (inttoptr u64 i8* %$3)) (store %$2 i8* %iter-ref) (let %NEWLINE (+ i8 10 0)) (let %$6 (== i8 %char %NEWLINE)) (if %$6 (do (let %$9 (index %this %struct.Reader 3)) (let %$8 (load u64 %$9)) (let %$7 (+ u64 1 %$8)) (let %$10 (index %this %struct.Reader 3)) (store %$7 u64 %$10) (let %$11 (index %this %struct.Reader 4)) (store 0 u64 %$11) (return %char i8))) (let %$14 (index %this %struct.Reader 4)) (let %$13 (load u64 %$14)) (let %$12 (+ u64 1 %$13)) (let %$15 (index %this %struct.Reader 4)) (store %$12 u64 %$15) (return %char i8))) (def @Reader$ptr.seek-backwards-on-line (params (%this %struct.Reader*) (%line u64) (%col u64)) void (do (let %col-ref (index %this %struct.Reader 4)) (let %$0 (index %this %struct.Reader 4)) (let %curr-col (load u64 %$0)) (let %anti-offset (- u64 %curr-col %col)) (let %$5 (index %this %struct.Reader 1)) (let %$4 (load i8* %$5)) (let %$3 (ptrtoint i8* u64 %$4)) (let %$2 (- u64 %$3 %anti-offset)) (let %$1 (inttoptr u64 i8* %$2)) (let %$6 (index %this %struct.Reader 1)) (store %$1 i8* %$6) (let %$7 (index %this %struct.Reader 4)) (store %col u64 %$7) return-void)) (def @Reader$ptr.seek-forwards.fail (params (%this %struct.Reader*) (%line u64) (%col u64) (%msg i8*)) void (do (call @i8$ptr.unsafe-print (types i8*) void (args %msg)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 23))) (let %$1 (index %this %struct.Reader 3)) (let %$0 (load u64 %$1)) (call @u64.print (types u64) void (args %$0)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 24))) (let %$3 (index %this %struct.Reader 4)) (let %$2 (load u64 %$3)) (call @u64.print (types u64) void (args %$2)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 25))) (call @u64.print (types u64) void (args %line)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 26))) (call @u64.print (types u64) void (args %col)) (call @println types void args) (call @exit (types i32) void (args 1)) return-void)) (def @Reader$ptr.seek-forwards (params (%this %struct.Reader*) (%line u64) (%col u64)) void (do (let %curr-line (index %this %struct.Reader 3)) (let %curr-col (index %this %struct.Reader 4)) (let %$1 (load u64 %curr-line)) (let %$0 (== u64 %line %$1)) (if %$0 (do (let %$3 (load u64 %curr-col)) (let %$2 (== u64 %col %$3)) (if %$2 (do return-void)) (let %$5 (load u64 %curr-col)) (let %$4 (< u64 %col %$5)) (if %$4 (do (call @Reader$ptr.seek-forwards.fail (types %struct.Reader* u64 u64 i8*) void (args %this %line %col (str-get 27))))) (let %$7 (load u64 %curr-col)) (let %$6 (> u64 %col %$7)) (if %$6 (do (call @Reader$ptr.get (types %struct.Reader*) i8 (args %this)) (let %$9 (load u64 %curr-line)) (let %$8 (< u64 %line %$9)) (if %$8 (do (call @Reader$ptr.seek-forwards.fail (types %struct.Reader* u64 u64 i8*) void (args %this %line %col (str-get 28))))) (call @Reader$ptr.seek-forwards (types %struct.Reader* u64 u64) void (args %this %line %col)) return-void)))) (let %$10 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %this))) (if %$10 (do (call @Reader$ptr.seek-forwards.fail (types %struct.Reader* u64 u64 i8*) void (args %this %line %col (str-get 29))))) (let %$12 (load u64 %curr-line)) (let %$11 (< u64 %line %$12)) (if %$11 (do (call @Reader$ptr.seek-forwards.fail (types %struct.Reader* u64 u64 i8*) void (args %this %line %col (str-get 30))))) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %this)) (call @Reader$ptr.seek-forwards (types %struct.Reader* u64 u64) void (args %this %line %col)) return-void)) (def @Reader$ptr.find-next (params (%this %struct.Reader*) (%char i8)) void (do (let %$0 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %this))) (if %$0 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 31))) (call @exit (types i32) void (args 1)))) (let %peeked (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %this))) (let %$1 (== i8 %char %peeked)) (if %$1 (do return-void)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %this)) (call @Reader$ptr.find-next (types %struct.Reader* i8) void (args %this %char)) return-void)) (def @Reader$ptr.pos (params (%this %struct.Reader*)) u64 (do (let %$0 (index %this %struct.Reader 1)) (let %iter (load i8* %$0)) (let %$2 (index %this %struct.Reader 0)) (let %$1 (index %$2 %struct.StringView 0)) (let %start (load i8* %$1)) (let %$3 (ptrtoint i8* u64 %iter)) (let %$4 (ptrtoint i8* u64 %start)) (let %result (- u64 %$3 %$4)) (return %result u64))) (def @Reader$ptr.done (params (%this %struct.Reader*)) i1 (do (let %content (index %this %struct.Reader 0)) (let %$3 (index %content %struct.StringView 0)) (let %$2 (load i8* %$3)) (let %$1 (ptrtoint i8* u64 %$2)) (let %$5 (index %content %struct.StringView 1)) (let %$4 (load u64 %$5)) (let %$0 (+ u64 %$1 %$4)) (let %content-end (inttoptr u64 i8* %$0)) (let %$6 (index %this %struct.Reader 1)) (let %iter (load i8* %$6)) (let %$7 (== i8* %iter %content-end)) (return %$7 i1))) (def @Reader$ptr.reset (params (%this %struct.Reader*)) void (do (let %string-view (index %this %struct.Reader 0)) (let %$1 (index %string-view %struct.StringView 0)) (let %$0 (load i8* %$1)) (let %$2 (index %this %struct.Reader 1)) (store %$0 i8* %$2) (let %$3 (index %this %struct.Reader 2)) (store 0 i8 %$3) (let %$4 (index %this %struct.Reader 3)) (store 0 u64 %$4) (let %$5 (index %this %struct.Reader 4)) (store 0 u64 %$5) return-void)) (def @test.Reader-get$lambda0 (params (%reader %struct.Reader*) (%i i32)) void (do (let %$0 (== i32 %i 0)) (if %$0 (do return-void)) (let %$1 (call @Reader$ptr.get (types %struct.Reader*) i8 (args %reader))) (call @i8.print (types i8) void (args %$1)) (let %$2 (- i32 %i 1)) (call-tail @test.Reader-get$lambda0 (types %struct.Reader* i32) void (args %reader %$2)) return-void)) (def @test.Reader-get params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 32))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %$1 (index %file %struct.File 0)) (call @String$ptr.println (types %struct.String*) void (args %$1)) (auto %content %struct.StringView) (let %$2 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$2 %struct.StringView %content) (auto %reader %struct.Reader) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %reader %content)) (call @test.Reader-get$lambda0 (types %struct.Reader* i32) void (args %reader 50)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.Reader-done$lambda0 (params (%reader %struct.Reader*)) void (do (let %$0 (call @Reader$ptr.get (types %struct.Reader*) i8 (args %reader))) (call @i8.print (types i8) void (args %$0)) (let %$2 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %reader))) (let %$1 (- i1 1 %$2)) (if %$1 (do (call-tail @test.Reader-done$lambda0 (types %struct.Reader*) void (args %reader)))) return-void)) (def @test.Reader-done params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 33))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %$1 (index %file %struct.File 0)) (call @String$ptr.println (types %struct.String*) void (args %$1)) (auto %content %struct.StringView) (let %$2 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$2 %struct.StringView %content) (auto %reader %struct.Reader) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %reader %content)) (call @test.Reader-done$lambda0 (types %struct.Reader*) void (args %reader)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @u64.string_ (params (%this u64) (%acc %struct.String*)) void (do (let %$0 (== u64 0 %this)) (if %$0 (do return-void)) (let %ZERO (+ i8 48 0)) (let %top (% u64 %this 10)) (let %$1 (trunc u64 i8 %top)) (let %c (+ i8 %ZERO %$1)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %c)) (let %rest (/ u64 %this 10)) (call-tail @u64.string_ (types u64 %struct.String*) void (args %rest %acc)) return-void)) (def @u64.string (params (%this u64)) %struct.String (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (let %ZERO (+ i8 48 0)) (let %$1 (== u64 0 %this)) (if %$1 (do (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %ZERO)) (let %$2 (load %struct.String %acc)) (return %$2 %struct.String))) (call @u64.string_ (types u64 %struct.String*) void (args %this %acc)) (call @String$ptr.reverse-in-place (types %struct.String*) void (args %acc)) (let %$3 (load %struct.String %acc)) (return %$3 %struct.String))) (def @u64.print (params (%this u64)) void (do (auto %string %struct.String) (let %$0 (call @u64.string (types u64) %struct.String (args %this))) (store %$0 %struct.String %string) (call @String$ptr.print (types %struct.String*) void (args %string)) return-void)) (def @u64.println (params (%this u64)) void (do (call @u64.print (types u64) void (args %this)) (call @println types void args) return-void)) (def @test.u64-print params void (do (call @u64.print (types u64) void (args 12408124)) (call @println types void args) return-void)) (struct %struct.u64-vector (%data u64*) (%len u64) (%cap u64)) (def @u64-vector.make params %struct.u64-vector (do (auto %result %struct.u64-vector) (let %$0 (inttoptr u64 u64* 0)) (let %$1 (index %result %struct.u64-vector 0)) (store %$0 u64* %$1) (let %$2 (index %result %struct.u64-vector 1)) (store 0 u64 %$2) (let %$3 (index %result %struct.u64-vector 2)) (store 0 u64 %$3) (let %$4 (load %struct.u64-vector %result)) (return %$4 %struct.u64-vector))) (def @u64-vector$ptr.push (params (%this %struct.u64-vector*) (%item u64)) void (do (let %SIZEOF-u64 (+ u64 8 0)) (let %data-ref (index %this %struct.u64-vector 0)) (let %length-ref (index %this %struct.u64-vector 1)) (let %cap-ref (index %this %struct.u64-vector 2)) (let %$1 (load u64 %length-ref)) (let %$2 (load u64 %cap-ref)) (let %$0 (== u64 %$1 %$2)) (if %$0 (do (let %old-capacity (load u64 %cap-ref)) (let %$3 (== u64 0 %old-capacity)) (if %$3 (do (store 1 u64 %cap-ref))) (let %$4 (!= u64 0 %old-capacity)) (if %$4 (do (let %$5 (* u64 2 %old-capacity)) (store %$5 u64 %cap-ref))) (let %new-capacity (load u64 %cap-ref)) (let %old-data (load u64* %data-ref)) (let %$7 (bitcast u64* i8* %old-data)) (let %$8 (* u64 %SIZEOF-u64 %new-capacity)) (let %$6 (call @realloc (types i8* u64) i8* (args %$7 %$8))) (let %new-data (bitcast i8* u64* %$6)) (let %$9 (index %this %struct.u64-vector 0)) (store %new-data u64* %$9))) (let %$10 (load u64* %data-ref)) (let %data-base (ptrtoint u64* u64 %$10)) (let %$14 (load u64 %length-ref)) (let %$13 (bitcast u64 u64 %$14)) (let %$12 (* u64 %SIZEOF-u64 %$13)) (let %$11 (+ u64 %data-base %$12)) (let %new-child-loc (inttoptr u64 u64* %$11)) (store %item u64 %new-child-loc) (let %$16 (load u64 %length-ref)) (let %$15 (+ u64 1 %$16)) (store %$15 u64 %length-ref) return-void)) (def @u64-vector$ptr.print_ (params (%this %struct.u64-vector*) (%i u64)) void (do (let %$2 (index %this %struct.u64-vector 1)) (let %$1 (load u64 %$2)) (let %$0 (== u64 %$1 %i)) (if %$0 (do return-void)) (let %COMMA (+ i8 44 0)) (let %SPACE (+ i8 32 0)) (call @i8.print (types i8) void (args %COMMA)) (call @i8.print (types i8) void (args %SPACE)) (let %curr (call @u64-vector$ptr.unsafe-get (types %struct.u64-vector* u64) u64 (args %this %i))) (call @u64.print (types u64) void (args %curr)) (let %$3 (+ u64 1 %i)) (call-tail @u64-vector$ptr.print_ (types %struct.u64-vector* u64) void (args %this %$3)) return-void)) (def @u64-vector$ptr.print (params (%this %struct.u64-vector*)) void (do (let %LBRACKET (+ i8 91 0)) (let %RBRACKET (+ i8 93 0)) (let %COMMA (+ i8 44 0)) (let %SPACE (+ i8 32 0)) (call @i8.print (types i8) void (args %LBRACKET)) (let %$2 (index %this %struct.u64-vector 1)) (let %$1 (load u64 %$2)) (let %$0 (!= u64 0 %$1)) (if %$0 (do (let %$5 (index %this %struct.u64-vector 0)) (let %$4 (load u64* %$5)) (let %$3 (load u64 %$4)) (call @u64.print (types u64) void (args %$3)))) (let %$8 (index %this %struct.u64-vector 1)) (let %$7 (load u64 %$8)) (let %$6 (!= u64 0 %$7)) (if %$6 (do (call @u64-vector$ptr.print_ (types %struct.u64-vector* u64) void (args %this 1)))) (call @i8.print (types i8) void (args %RBRACKET)) return-void)) (def @u64-vector$ptr.println (params (%this %struct.u64-vector*)) void (do (call @u64-vector$ptr.print (types %struct.u64-vector*) void (args %this)) (call @println types void args) return-void)) (def @u64-vector$ptr.unsafe-get (params (%this %struct.u64-vector*) (%i u64)) u64 (do (let %SIZEOF-u64 (+ u64 8 0)) (let %$3 (* u64 %SIZEOF-u64 %i)) (let %$6 (index %this %struct.u64-vector 0)) (let %$5 (load u64* %$6)) (let %$4 (ptrtoint u64* u64 %$5)) (let %$2 (+ u64 %$3 %$4)) (let %$1 (inttoptr u64 u64* %$2)) (let %$0 (load u64 %$1)) (return %$0 u64))) (def @u64-vector$ptr.unsafe-put (params (%this %struct.u64-vector*) (%i u64) (%value u64)) void (do (let %SIZEOF-u64 (+ u64 8 0)) (let %$2 (* u64 %SIZEOF-u64 %i)) (let %$5 (index %this %struct.u64-vector 0)) (let %$4 (load u64* %$5)) (let %$3 (ptrtoint u64* u64 %$4)) (let %$1 (+ u64 %$2 %$3)) (let %$0 (inttoptr u64 u64* %$1)) (store %value u64 %$0) return-void)) (def @test.u64-vector-basic params void (do (auto %vec %struct.u64-vector) (let %$0 (call @u64-vector.make types %struct.u64-vector args)) (store %$0 %struct.u64-vector %vec) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 0)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 2)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 3)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 4)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 5)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 6)) (call @u64-vector$ptr.println (types %struct.u64-vector*) void (args %vec)) return-void)) (def @test.u64-vector-one params void (do (auto %vec %struct.u64-vector) (let %$0 (call @u64-vector.make types %struct.u64-vector args)) (store %$0 %struct.u64-vector %vec) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 0)) (call @u64-vector$ptr.println (types %struct.u64-vector*) void (args %vec)) return-void)) (def @test.u64-vector-empty params void (do (auto %vec %struct.u64-vector) (let %$0 (call @u64-vector.make types %struct.u64-vector args)) (store %$0 %struct.u64-vector %vec) (call @u64-vector$ptr.println (types %struct.u64-vector*) void (args %vec)) return-void)) (def @test.u64-vector-put params void (do (auto %vec %struct.u64-vector) (let %$0 (call @u64-vector.make types %struct.u64-vector args)) (store %$0 %struct.u64-vector %vec) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 0)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 2)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 3)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 4)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 5)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %vec 6)) (call @u64-vector$ptr.unsafe-put (types %struct.u64-vector* u64 u64) void (args %vec 3 10)) (call @u64-vector$ptr.println (types %struct.u64-vector*) void (args %vec)) return-void)) (def @Result.success (params (%texp %struct.Texp*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 34)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Result.success-from-i8$ptr (params (%cstr i8*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 35)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args %cstr))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Result.error (params (%texp %struct.Texp*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 36)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Result.error-from-view (params (%view %struct.StringView*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 37)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp.makeFromStringView (types %struct.StringView*) %struct.Texp (args %view))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Result.error-from-i8$ptr (params (%cstr i8*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 38)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args %cstr))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Optional.some (params (%texp %struct.Texp*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 39)))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %result %$1)) (let %$2 (load %struct.Texp %result)) (return %$2 %struct.Texp))) (def @Optional.none params %struct.Texp (do (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 40)))) (return %$0 %struct.Texp))) (struct %struct.Texp (%value %struct.String) (%children %struct.Texp*) (%length u64) (%capacity u64)) (def @Texp$ptr.setFromString (params (%this %struct.Texp*) (%value %struct.String*)) void (do (let %$0 (load %struct.String %value)) (let %$1 (index %this %struct.Texp 0)) (store %$0 %struct.String %$1) (let %$2 (inttoptr u64 %struct.Texp* 0)) (let %$3 (index %this %struct.Texp 1)) (store %$2 %struct.Texp* %$3) (let %$4 (index %this %struct.Texp 2)) (store 0 u64 %$4) (let %$5 (index %this %struct.Texp 3)) (store 0 u64 %$5) return-void)) (def @Texp.makeEmpty params %struct.Texp (do (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 41)))) (return %$0 %struct.Texp))) (def @Texp.makeFromi8$ptr (params (%value-cstr i8*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @String.makeFromi8$ptr (types i8*) %struct.String (args %value-cstr))) (let %$1 (index %result %struct.Texp 0)) (store %$0 %struct.String %$1) (let %$2 (inttoptr u64 %struct.Texp* 0)) (let %$3 (index %result %struct.Texp 1)) (store %$2 %struct.Texp* %$3) (let %$4 (index %result %struct.Texp 2)) (store 0 u64 %$4) (let %$5 (index %result %struct.Texp 3)) (store 0 u64 %$5) (let %$6 (load %struct.Texp %result)) (return %$6 %struct.Texp))) (def @Texp.makeFromString (params (%value %struct.String*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %value))) (let %$1 (index %result %struct.Texp 0)) (store %$0 %struct.String %$1) (let %$2 (inttoptr u64 %struct.Texp* 0)) (let %$3 (index %result %struct.Texp 1)) (store %$2 %struct.Texp* %$3) (let %$4 (index %result %struct.Texp 2)) (store 0 u64 %$4) (let %$5 (index %result %struct.Texp 3)) (store 0 u64 %$5) (let %$6 (load %struct.Texp %result)) (return %$6 %struct.Texp))) (def @Texp.makeFromStringView (params (%value-view %struct.StringView*)) %struct.Texp (do (auto %result %struct.Texp) (let %$0 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %value-view))) (let %$1 (index %result %struct.Texp 0)) (store %$0 %struct.String %$1) (let %$2 (inttoptr u64 %struct.Texp* 0)) (let %$3 (index %result %struct.Texp 1)) (store %$2 %struct.Texp* %$3) (let %$4 (index %result %struct.Texp 2)) (store 0 u64 %$4) (let %$5 (index %result %struct.Texp 3)) (store 0 u64 %$5) (let %$6 (load %struct.Texp %result)) (return %$6 %struct.Texp))) (def @Texp$ptr.push$ptr (params (%this %struct.Texp*) (%item %struct.Texp*)) void (do (let %SIZEOF-Texp (+ u64 40 0)) (let %children-ref (index %this %struct.Texp 1)) (let %length-ref (index %this %struct.Texp 2)) (let %cap-ref (index %this %struct.Texp 3)) (let %$1 (load u64 %length-ref)) (let %$2 (load u64 %cap-ref)) (let %$0 (== u64 %$1 %$2)) (if %$0 (do (let %old-capacity (load u64 %cap-ref)) (let %$3 (== u64 0 %old-capacity)) (if %$3 (do (store 1 u64 %cap-ref))) (let %$4 (!= u64 0 %old-capacity)) (if %$4 (do (let %$5 (* u64 2 %old-capacity)) (store %$5 u64 %cap-ref))) (let %new-capacity (load u64 %cap-ref)) (let %old-children (load %struct.Texp* %children-ref)) (let %$7 (bitcast %struct.Texp* i8* %old-children)) (let %$8 (* u64 %SIZEOF-Texp %new-capacity)) (let %$6 (call @realloc (types i8* u64) i8* (args %$7 %$8))) (let %new-children (bitcast i8* %struct.Texp* %$6)) (let %$9 (index %this %struct.Texp 1)) (store %new-children %struct.Texp* %$9))) (let %$10 (load %struct.Texp* %children-ref)) (let %children-base (ptrtoint %struct.Texp* u64 %$10)) (let %$14 (load u64 %length-ref)) (let %$13 (bitcast u64 u64 %$14)) (let %$12 (* u64 %SIZEOF-Texp %$13)) (let %$11 (+ u64 %$12 %children-base)) (let %new-child-loc (inttoptr u64 %struct.Texp* %$11)) (let %$15 (load %struct.Texp %item)) (store %$15 %struct.Texp %new-child-loc) (let %$17 (load u64 %length-ref)) (let %$16 (+ u64 1 %$17)) (store %$16 u64 %length-ref) return-void)) (def @Texp$ptr.push (params (%this %struct.Texp*) (%item %struct.Texp)) void (do (auto %local-item %struct.Texp) (store %item %struct.Texp %local-item) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %this %local-item)) return-void)) (def @Texp$ptr.free$lambda.child-iter (params (%this %struct.Texp*) (%child-index u64)) void (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %this %struct.Texp 1)) (let %children (load %struct.Texp* %$0)) (let %$1 (index %this %struct.Texp 2)) (let %length (load u64 %$1)) (let %$2 (== u64 %child-index %length)) (if %$2 (do return-void)) (let %$4 (* u64 %SIZEOF-Texp %child-index)) (let %$5 (ptrtoint %struct.Texp* u64 %children)) (let %$3 (+ u64 %$4 %$5)) (let %curr (inttoptr u64 %struct.Texp* %$3)) (call @Texp$ptr.free (types %struct.Texp*) void (args %curr)) (let %$6 (+ u64 1 %child-index)) (call-tail @Texp$ptr.free$lambda.child-iter (types %struct.Texp* u64) void (args %this %$6)) return-void)) (def @Texp$ptr.free (params (%this %struct.Texp*)) void (do (let %$0 (index %this %struct.Texp 0)) (call @String$ptr.free (types %struct.String*) void (args %$0)) (let %$3 (index %this %struct.Texp 1)) (let %$2 (load %struct.Texp* %$3)) (let %$1 (bitcast %struct.Texp* i8* %$2)) (call @free (types i8*) void (args %$1)) (call @Texp$ptr.free$lambda.child-iter (types %struct.Texp* u64) void (args %this 0)) return-void)) (def @Texp$ptr.demote-free (params (%this %struct.Texp*)) void (do (let %$0 (index %this %struct.Texp 0)) (call @String$ptr.free (types %struct.String*) void (args %$0)) (let %$1 (index %this %struct.Texp 1)) (let %child-ref (load %struct.Texp* %$1)) (let %$2 (load %struct.Texp %child-ref)) (store %$2 %struct.Texp %this) (let %$3 (bitcast %struct.Texp* i8* %child-ref)) (call @free (types i8*) void (args %$3)) return-void)) (def @Texp$ptr.shallow-free (params (%this %struct.Texp*)) void (do return-void)) (def @Texp$ptr.clone_ (params (%acc %struct.Texp*) (%curr %struct.Texp*) (%last %struct.Texp*)) void (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %curr))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %acc %$0)) (let %$1 (== %struct.Texp* %last %curr)) (if %$1 (do return-void)) (let %$3 (ptrtoint %struct.Texp* u64 %curr)) (let %$2 (+ u64 %SIZEOF-Texp %$3)) (let %next (inttoptr u64 %struct.Texp* %$2)) (call @Texp$ptr.clone_ (types %struct.Texp* %struct.Texp* %struct.Texp*) void (args %acc %next %last)) return-void)) (def @Texp$ptr.clone (params (%this %struct.Texp*)) %struct.Texp (do (auto %result %struct.Texp) (let %$1 (index %this %struct.Texp 0)) (let %$0 (call @String$ptr.copyalloc (types %struct.String*) %struct.String (args %$1))) (let %$2 (index %result %struct.Texp 0)) (store %$0 %struct.String %$2) (let %$4 (index %result %struct.Texp 1)) (let %$3 (bitcast %struct.Texp** u64* %$4)) (store 0 u64 %$3) (let %$5 (index %result %struct.Texp 2)) (store 0 u64 %$5) (let %$6 (index %result %struct.Texp 3)) (store 0 u64 %$6) (let %$9 (index %this %struct.Texp 2)) (let %$8 (load u64 %$9)) (let %$7 (!= u64 0 %$8)) (if %$7 (do (let %$11 (index %this %struct.Texp 1)) (let %$10 (load %struct.Texp* %$11)) (let %$12 (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %this))) (call @Texp$ptr.clone_ (types %struct.Texp* %struct.Texp* %struct.Texp*) void (args %result %$10 %$12)))) (let %$13 (load %struct.Texp %result)) (return %$13 %struct.Texp))) (def @Texp$ptr.parenPrint$lambda.child-iter (params (%this %struct.Texp*) (%child-index u64)) void (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %this %struct.Texp 1)) (let %children (load %struct.Texp* %$0)) (let %$1 (index %this %struct.Texp 2)) (let %length (load u64 %$1)) (let %$2 (== u64 %child-index %length)) (if %$2 (do return-void)) (let %$4 (* u64 %SIZEOF-Texp %child-index)) (let %$5 (ptrtoint %struct.Texp* u64 %children)) (let %$3 (+ u64 %$4 %$5)) (let %curr (inttoptr u64 %struct.Texp* %$3)) (let %$6 (!= u64 0 %child-index)) (if %$6 (do (let %SPACE (+ i8 32 0)) (call @i8.print (types i8) void (args %SPACE)))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %curr)) (let %$7 (+ u64 1 %child-index)) (call-tail @Texp$ptr.parenPrint$lambda.child-iter (types %struct.Texp* u64) void (args %this %$7)) return-void)) (def @Texp$ptr.parenPrint (params (%this %struct.Texp*)) void (do (let %$1 (ptrtoint %struct.Texp* u64 %this)) (let %$0 (== u64 0 %$1)) (if %$0 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 42))) return-void)) (let %value-ref (index %this %struct.Texp 0)) (let %$2 (index %this %struct.Texp 2)) (let %length (load u64 %$2)) (let %$3 (== u64 0 %length)) (if %$3 (do (call @String$ptr.print (types %struct.String*) void (args %value-ref)) return-void)) (let %LPAREN (+ i8 40 0)) (let %RPAREN (+ i8 41 0)) (let %SPACE (+ i8 32 0)) (call @i8.print (types i8) void (args %LPAREN)) (call @String$ptr.print (types %struct.String*) void (args %value-ref)) (call @i8.print (types i8) void (args %SPACE)) (call @Texp$ptr.parenPrint$lambda.child-iter (types %struct.Texp* u64) void (args %this 0)) (call @i8.print (types i8) void (args %RPAREN)) return-void)) (def @Texp$ptr.shallow-dump (params (%this %struct.Texp*)) void (do (let %$1 (ptrtoint %struct.Texp* u64 %this)) (let %$0 (!= u64 0 %$1)) (if %$0 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 43))) (let %$2 (index %this %struct.Texp 0)) (call @String$ptr.print (types %struct.String*) void (args %$2)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 44))) (let %$4 (index %this %struct.Texp 2)) (let %$3 (load u64 %$4)) (call @u64.print (types u64) void (args %$3)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 45))) (let %$6 (index %this %struct.Texp 3)) (let %$5 (load u64 %$6)) (call @u64.print (types u64) void (args %$5)))) (let %$8 (ptrtoint %struct.Texp* u64 %this)) (let %$7 (== u64 0 %$8)) (if %$7 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 46))))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 47))) (let %$9 (ptrtoint %struct.Texp* u64 %this)) (call @u64.println (types u64) void (args %$9)) return-void)) (def @Texp$ptr.last (params (%this %struct.Texp*)) %struct.Texp* (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %this %struct.Texp 2)) (let %len (load u64 %$0)) (let %$1 (index %this %struct.Texp 1)) (let %first-child (load %struct.Texp* %$1)) (let %$3 (ptrtoint %struct.Texp* u64 %first-child)) (let %$5 (- u64 %len 1)) (let %$4 (* u64 %SIZEOF-Texp %$5)) (let %$2 (+ u64 %$3 %$4)) (let %last (inttoptr u64 %struct.Texp* %$2)) (return %last %struct.Texp*))) (def @Texp$ptr.child (params (%this %struct.Texp*) (%i u64)) %struct.Texp* (do (let %SIZEOF-Texp (+ u64 40 0)) (let %$0 (index %this %struct.Texp 1)) (let %first-child (load %struct.Texp* %$0)) (let %$2 (ptrtoint %struct.Texp* u64 %first-child)) (let %$3 (* u64 %SIZEOF-Texp %i)) (let %$1 (+ u64 %$2 %$3)) (let %child (inttoptr u64 %struct.Texp* %$1)) (return %child %struct.Texp*))) (def @Texp$ptr.find_ (params (%this %struct.Texp*) (%last %struct.Texp*) (%key %struct.StringView*)) %struct.Texp* (do (let %SIZEOF-Texp (+ u64 40 0)) (let %view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %this))) (let %$0 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %view %key))) (if %$0 (do (return %this %struct.Texp*))) (let %$1 (== %struct.Texp* %this %last)) (if %$1 (do (let %$2 (inttoptr u64 %struct.Texp* 0)) (return %$2 %struct.Texp*))) (let %$4 (ptrtoint %struct.Texp* u64 %this)) (let %$3 (+ u64 %SIZEOF-Texp %$4)) (let %next (inttoptr u64 %struct.Texp* %$3)) (let %$5 (call @Texp$ptr.find_ (types %struct.Texp* %struct.Texp* %struct.StringView*) %struct.Texp* (args %next %last %key))) (return %$5 %struct.Texp*))) (def @Texp$ptr.find (params (%this %struct.Texp*) (%key %struct.StringView*)) %struct.Texp* (do (let %$0 (index %this %struct.Texp 1)) (let %first (load %struct.Texp* %$0)) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %this))) (let %$1 (call @Texp$ptr.find_ (types %struct.Texp* %struct.Texp* %struct.StringView*) %struct.Texp* (args %first %last %key))) (return %$1 %struct.Texp*))) (def @Texp$ptr.is-empty (params (%this %struct.Texp*)) i1 (do (let %$2 (index %this %struct.Texp 2)) (let %$1 (load u64 %$2)) (let %$0 (== u64 0 %$1)) (return %$0 i1))) (def @Texp$ptr.value-check (params (%this %struct.Texp*) (%check i8*)) i1 (do (let %check-view (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args %check))) (let %$0 (index %this %struct.Texp 0)) (let %value-view (call @String$ptr.view (types %struct.String*) %struct.StringView (args %$0))) (let %$1 (call @StringView.eq (types %struct.StringView %struct.StringView) i1 (args %check-view %value-view))) (return %$1 i1))) (def @Texp$ptr.value-view (params (%this %struct.Texp*)) %struct.StringView* (do (let %$1 (index %this %struct.Texp 0)) (let %$0 (bitcast %struct.String* %struct.StringView* %$1)) (return %$0 %struct.StringView*))) (def @Texp$ptr.value-get (params (%this %struct.Texp*) (%i u64)) i8 (do (let %$1 (index %this %struct.Texp 0)) (let %$0 (index %$1 %struct.String 0)) (let %value (load i8* %$0)) (let %$3 (ptrtoint i8* u64 %value)) (let %$2 (+ u64 %i %$3)) (let %cptr (inttoptr u64 i8* %$2)) (let %$4 (load i8 %cptr)) (return %$4 i8))) (def @test.Texp-basic$lamdba.dump (params (%texp %struct.Texp*)) void (do (call @println types void args) (let %$1 (index %texp %struct.Texp 2)) (let %$0 (load u64 %$1)) (call @u64.print (types u64) void (args %$0)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) return-void)) (def @test.Texp-basic params void (do (auto %hello-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello-string (str-get 48))) (auto %child0-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child0-string (str-get 49))) (auto %child1-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child1-string (str-get 50))) (auto %child2-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child2-string (str-get 51))) (auto %texp %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %hello-string)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (auto %texp-child %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child0-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child1-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child2-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.free (types %struct.Texp*) void (args %texp)) return-void)) (def @test.Texp-clone params void (do (auto %hello-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello-string (str-get 52))) (auto %child0-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child0-string (str-get 53))) (auto %child1-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child1-string (str-get 54))) (auto %child2-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %child2-string (str-get 55))) (auto %texp %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %hello-string)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (auto %texp-child %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child0-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child1-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp-child %child2-string)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %texp %texp-child)) (call @test.Texp-basic$lamdba.dump (types %struct.Texp*) void (args %texp)) (call @Texp$ptr.free (types %struct.Texp*) void (args %texp)) return-void)) (def @test.Texp-clone-atom params void (do (auto %texp %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 56)))) (store %$0 %struct.Texp %texp) (auto %clone %struct.Texp) (let %$1 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (store %$1 %struct.Texp %clone) (let %$4 (index %texp %struct.Texp 0)) (let %$3 (index %$4 %struct.String 0)) (let %$2 (ptrtoint i8** u64 %$3)) (call @u64.print (types u64) void (args %$2)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 57))) (call @Texp$ptr.shallow-dump (types %struct.Texp*) void (args %texp)) (call @println types void args) (let %$7 (index %clone %struct.Texp 0)) (let %$6 (index %$7 %struct.String 0)) (let %$5 (ptrtoint i8** u64 %$6)) (call @u64.print (types u64) void (args %$5)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 58))) (call @Texp$ptr.shallow-dump (types %struct.Texp*) void (args %clone)) (call @println types void args) return-void)) (def @test.Texp-clone-hard params void (do (auto %content-view %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %content-view (str-get 59))) (auto %parser %struct.Parser) (let %$0 (bitcast %struct.Parser* %struct.Reader* %parser)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$0 %content-view)) (auto %result %struct.Texp) (let %$1 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %parser))) (store %$1 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) (auto %clone %struct.Texp) (let %$2 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %result))) (store %$2 %struct.Texp %clone) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %clone)) (call @println types void args) return-void)) (def @test.Texp-value-get params void (do (auto %hello-string %struct.String) (call @String$ptr.set (types %struct.String* i8*) void (args %hello-string (str-get 60))) (auto %texp %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %hello-string)) (let %E_CHAR (+ i8 101 0)) (let %$0 (call @Texp$ptr.value-get (types %struct.Texp* u64) i8 (args %texp 1))) (let %success (== i8 %E_CHAR %$0)) (if %success (do (call @puts (types i8*) i32 (args (str-get 61))))) (let %$1 (- i1 1 %success)) (if %$1 (do (call @puts (types i8*) i32 (args (str-get 62))))) (call @Texp$ptr.free (types %struct.Texp*) void (args %texp)) return-void)) (def @test.Texp-program-grammar-eq params void (do (auto %grammar-texp %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 63)))) (store %$0 %struct.Texp %grammar-texp) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %grammar-texp)) (auto %start-production %struct.StringView) (let %$1 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 64)))) (store %$1 %struct.StringView %start-production) (let %first-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %grammar-texp 0))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %first-child)) (call @println types void args) (let %view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %first-child))) (let %$2 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %view %start-production))) (if %$2 (do (call @puts (types i8*) i32 (args (str-get 65))) return-void)) (call @puts (types i8*) i32 (args (str-get 66))) return-void)) (def @test.Texp-find-program-grammar params void (do (auto %grammar-texp %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 67)))) (store %$0 %struct.Texp %grammar-texp) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %grammar-texp)) (auto %start-production %struct.StringView) (let %$1 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 68)))) (store %$1 %struct.StringView %start-production) (let %found-texp (call @Texp$ptr.find (types %struct.Texp* %struct.StringView*) %struct.Texp* (args %grammar-texp %start-production))) (let %$3 (ptrtoint %struct.Texp* u64 %found-texp)) (let %$2 (== u64 0 %$3)) (if %$2 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 69))))) (let %$5 (ptrtoint %struct.Texp* u64 %found-texp)) (let %$4 (!= u64 0 %$5)) (if %$4 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 70))))) return-void)) (def @test.Texp-makeFromi8$ptr params void (do (auto %string %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 71)))) (store %$0 %struct.Texp %string) (let %$4 (index %string %struct.Texp 0)) (let %$3 (index %$4 %struct.String 1)) (let %$2 (load u64 %$3)) (let %$1 (== u64 10 %$2)) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 72))) return-void)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 73))) return-void)) (def @test.Texp-value-view params void (do (auto %string %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 74)))) (store %$0 %struct.Texp %string) (let %value-view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %string))) (let %$3 (index %value-view %struct.StringView 1)) (let %$2 (load u64 %$3)) (let %$1 (== u64 10 %$2)) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 75))) return-void)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 76))) return-void)) (def @i8.isspace (params (%this i8)) i1 (do (let %$0 (== i8 %this 32)) (if %$0 (do (return true i1))) (let %$1 (== i8 %this 12)) (if %$1 (do (return true i1))) (let %$2 (== i8 %this 10)) (if %$2 (do (return true i1))) (let %$3 (== i8 %this 13)) (if %$3 (do (return true i1))) (let %$4 (== i8 %this 9)) (if %$4 (do (return true i1))) (let %$5 (== i8 %this 11)) (if %$5 (do (return true i1))) (return false i1))) (struct %struct.Parser (%reader %struct.Reader) (%lines %struct.u64-vector) (%cols %struct.u64-vector) (%types %struct.u64-vector) (%filename %struct.StringView)) (def @Parser.make (params (%content %struct.StringView*)) %struct.Parser (do (auto %result %struct.Parser) (let %$0 (index %result %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$0 %content)) (let %$1 (call @u64-vector.make types %struct.u64-vector args)) (let %$2 (index %result %struct.Parser 1)) (store %$1 %struct.u64-vector %$2) (let %$3 (call @u64-vector.make types %struct.u64-vector args)) (let %$4 (index %result %struct.Parser 2)) (store %$3 %struct.u64-vector %$4) (let %$5 (call @u64-vector.make types %struct.u64-vector args)) (let %$6 (index %result %struct.Parser 3)) (store %$5 %struct.u64-vector %$6) (let %$7 (call @StringView.makeEmpty types %struct.StringView args)) (let %$8 (index %result %struct.Parser 4)) (store %$7 %struct.StringView %$8) (let %$9 (load %struct.Parser %result)) (return %$9 %struct.Parser))) (def @Parser$ptr.unmake (params (%this %struct.Parser*)) void (do return-void)) (def @Parser$ptr.add-coord (params (%this %struct.Parser*) (%type u64)) void (do (let %reader (index %this %struct.Parser 0)) (let %$0 (index %reader %struct.Reader 3)) (let %line (load u64 %$0)) (let %$1 (index %reader %struct.Reader 4)) (let %col (load u64 %$1)) (let %$2 (index %this %struct.Parser 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$2 %line)) (let %$3 (index %this %struct.Parser 2)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$3 %col)) (let %$4 (index %this %struct.Parser 3)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$4 %type)) return-void)) (def @Parser$ptr.add-open-coord (params (%this %struct.Parser*)) void (do (call @Parser$ptr.add-coord (types %struct.Parser* u64) void (args %this 0)) return-void)) (def @Parser$ptr.add-close-coord (params (%this %struct.Parser*)) void (do (call @Parser$ptr.add-coord (types %struct.Parser* u64) void (args %this 1)) return-void)) (def @Parser$ptr.add-value-coord (params (%this %struct.Parser*)) void (do (call @Parser$ptr.add-coord (types %struct.Parser* u64) void (args %this 2)) return-void)) (def @Parser$ptr.add-comment-coord (params (%this %struct.Parser*)) void (do (let %reader (index %this %struct.Parser 0)) (let %$0 (index %reader %struct.Reader 3)) (let %line (load u64 %$0)) (let %$1 (index %reader %struct.Reader 4)) (let %col (load u64 %$1)) (let %$2 (index %this %struct.Parser 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$2 %line)) (let %$3 (index %this %struct.Parser 2)) (let %$4 (- u64 %col 1)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$3 %$4)) (let %$5 (index %this %struct.Parser 3)) (call @u64-vector$ptr.push (types %struct.u64-vector* u64) void (args %$5 3)) return-void)) (def @Parser$ptr.whitespace (params (%this %struct.Parser*)) void (do (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (call @i8.isspace (types i8) i1 (args %$1))) (if %$0 (do (let %$3 (index %this %struct.Parser 0)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$3)) (call-tail @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) return-void)) return-void)) (def @Parser$ptr.word_ (params (%this %struct.Parser*) (%acc %struct.String*)) void (do (let %reader (index %this %struct.Parser 0)) (let %$0 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %reader))) (if %$0 (do return-void)) (let %LPAREN (+ i8 40 0)) (let %RPAREN (+ i8 41 0)) (let %c (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %reader))) (let %$1 (== i8 %LPAREN %c)) (if %$1 (do return-void)) (let %$2 (== i8 %RPAREN %c)) (if %$2 (do return-void)) (let %$3 (call @i8.isspace (types i8) i1 (args %c))) (if %$3 (do return-void)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %reader)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %c)) (call-tail @Parser$ptr.word_ (types %struct.Parser* %struct.String*) void (args %this %acc)) return-void)) (def @Parser$ptr.word (params (%this %struct.Parser*)) %struct.String (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (call @Parser$ptr.word_ (types %struct.Parser* %struct.String*) void (args %this %acc)) (let %$1 (load %struct.String %acc)) (return %$1 %struct.String))) (def @Parser$ptr.string_ (params (%this %struct.Parser*) (%acc %struct.String*)) void (do (let %QUOTE (+ i8 34 0)) (let %BACKSLASH (+ i8 92 0)) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (== i8 %QUOTE %$1)) (if %$0 (do (let %$4 (index %this %struct.Parser 0)) (let %$3 (index %$4 %struct.Reader 2)) (let %prev (load i8 %$3)) (let %$5 (!= i8 %BACKSLASH %prev)) (if %$5 (do return-void)))) (let %$6 (index %this %struct.Parser 0)) (let %c (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$6))) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %c)) (call-tail @Parser$ptr.string_ (types %struct.Parser* %struct.String*) void (args %this %acc)) return-void)) (def @Parser$ptr.string (params (%this %struct.Parser*)) %struct.Texp (do (auto %acc %struct.String) (let %$0 (call @String.makeEmpty types %struct.String args)) (store %$0 %struct.String %acc) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$2))) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %$1)) (call @Parser$ptr.string_ (types %struct.Parser* %struct.String*) void (args %this %acc)) (let %$4 (index %this %struct.Parser 0)) (let %$3 (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$4))) (call @String$ptr.pushChar (types %struct.String* i8) void (args %acc %$3)) (auto %texp %struct.Texp) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %acc)) (let %$5 (load %struct.Texp %texp)) (return %$5 %struct.Texp))) (def @Parser$ptr.atom (params (%this %struct.Parser*)) %struct.Texp (do (call @Parser$ptr.add-value-coord (types %struct.Parser*) void (args %this)) (let %QUOTE (+ i8 34 0)) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (== i8 %QUOTE %$1)) (if %$0 (do (let %$3 (call @Parser$ptr.string (types %struct.Parser*) %struct.Texp (args %this))) (return %$3 %struct.Texp))) (auto %texp %struct.Texp) (auto %word %struct.String) (let %$4 (call @Parser$ptr.word (types %struct.Parser*) %struct.String (args %this))) (store %$4 %struct.String %word) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %texp %word)) (let %$5 (load %struct.Texp %texp)) (return %$5 %struct.Texp))) (def @Parser$ptr.list_ (params (%this %struct.Parser*) (%acc %struct.Texp*)) void (do (let %RPAREN (+ i8 41 0)) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (!= i8 %RPAREN %$1)) (if %$0 (do (auto %texp %struct.Texp) (let %$3 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %this))) (store %$3 %struct.Texp %texp) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %acc %texp)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (call @Parser$ptr.list_ (types %struct.Parser* %struct.Texp*) void (args %this %acc)))) return-void)) (def @Parser$ptr.list (params (%this %struct.Parser*)) %struct.Texp (do (call @Parser$ptr.add-open-coord (types %struct.Parser*) void (args %this)) (let %$0 (index %this %struct.Parser 0)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$0)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (call @Parser$ptr.add-value-coord (types %struct.Parser*) void (args %this)) (auto %curr %struct.Texp) (auto %word %struct.String) (let %$1 (call @Parser$ptr.word (types %struct.Parser*) %struct.String (args %this))) (store %$1 %struct.String %word) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %curr %word)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (call @Parser$ptr.list_ (types %struct.Parser* %struct.Texp*) void (args %this %curr)) (call @Parser$ptr.add-close-coord (types %struct.Parser*) void (args %this)) (let %$2 (index %this %struct.Parser 0)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$2)) (let %$3 (load %struct.Texp %curr)) (return %$3 %struct.Texp))) (def @Parser$ptr.texp (params (%this %struct.Parser*)) %struct.Texp (do (let %LPAREN (+ i8 40 0)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (let %$2 (index %this %struct.Parser 0)) (let %$1 (call @Reader$ptr.peek (types %struct.Reader*) i8 (args %$2))) (let %$0 (== i8 %LPAREN %$1)) (if %$0 (do (let %$3 (call @Parser$ptr.list (types %struct.Parser*) %struct.Texp (args %this))) (return %$3 %struct.Texp))) (let %$4 (call @Parser$ptr.atom (types %struct.Parser*) %struct.Texp (args %this))) (return %$4 %struct.Texp))) (def @Parser$ptr.collect (params (%this %struct.Parser*) (%parent %struct.Texp*)) void (do (let %$1 (index %this %struct.Parser 0)) (let %$0 (call @Reader$ptr.done (types %struct.Reader*) i1 (args %$1))) (if %$0 (do return-void)) (auto %child %struct.Texp) (let %$2 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %this))) (store %$2 %struct.Texp %child) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %parent %child)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %this)) (call @Parser$ptr.collect (types %struct.Parser* %struct.Texp*) void (args %this %parent)) return-void)) (def @Parser$ptr.remove-comments_ (params (%this %struct.Parser*) (%state i8)) void (do (let %NEWLINE (+ i8 10 0)) (let %SPACE (+ i8 32 0)) (let %QUOTE (+ i8 34 0)) (let %SEMICOLON (+ i8 59 0)) (let %BACKSLASH (+ i8 92 0)) (let %COMMENT_STATE (- i8 0 1)) (let %START_STATE (+ i8 0 0)) (let %STRING_STATE (+ i8 1 0)) (let %CHAR_STATE (+ i8 2 0)) (let %reader (index %this %struct.Parser 0)) (let %done (call @Reader$ptr.done (types %struct.Reader*) i1 (args %reader))) (if %done (do (call @Reader$ptr.reset (types %struct.Reader*) void (args %reader)) return-void)) (let %c (call @Reader$ptr.get (types %struct.Reader*) i8 (args %reader))) (let %$0 (== i8 %COMMENT_STATE %state)) (if %$0 (do (let %$1 (== i8 %NEWLINE %c)) (if %$1 (do (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %START_STATE)) return-void)) (let %$6 (index %reader %struct.Reader 1)) (let %$5 (load i8* %$6)) (let %$4 (ptrtoint i8* u64 %$5)) (let %$3 (- u64 %$4 1)) (let %$2 (inttoptr u64 i8* %$3)) (store %SPACE i8 %$2) (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %state)) return-void)) (let %$7 (== i8 %START_STATE %state)) (if %$7 (do (let %$8 (== i8 %QUOTE %c)) (if %$8 (do (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %STRING_STATE)) return-void)) (let %$9 (== i8 %SEMICOLON %c)) (if %$9 (do (call @Parser$ptr.add-comment-coord (types %struct.Parser*) void (args %this)) (let %$14 (index %reader %struct.Reader 1)) (let %$13 (load i8* %$14)) (let %$12 (ptrtoint i8* u64 %$13)) (let %$11 (- u64 %$12 1)) (let %$10 (inttoptr u64 i8* %$11)) (store %SPACE i8 %$10) (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %COMMENT_STATE)) return-void)) (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %state)) return-void)) (let %$15 (== i8 %STRING_STATE %state)) (if %$15 (do (let %$16 (== i8 %QUOTE %c)) (if %$16 (do (let %$17 (index %reader %struct.Reader 2)) (let %prev (load i8 %$17)) (let %$18 (!= i8 %BACKSLASH %prev)) (if %$18 (do (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %START_STATE)) return-void)))) (call-tail @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this %state)) return-void)) return-void)) (def @Parser$ptr.remove-comments (params (%this %struct.Parser*)) void (do (call @Parser$ptr.remove-comments_ (types %struct.Parser* i8) void (args %this 0)) return-void)) (def @Parser.parse-file.intro (params (%filename %struct.StringView*) (%file %struct.File*) (%content %struct.StringView*) (%parser %struct.Parser*)) %struct.Texp (do (let %$0 (call @File.openrw (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (let %$1 (call @File$ptr.readwrite (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (let %$2 (call @Parser.make (types %struct.StringView*) %struct.Parser (args %content))) (store %$2 %struct.Parser %parser) (let %$3 (load %struct.StringView %filename)) (let %$4 (index %parser %struct.Parser 4)) (store %$3 %struct.StringView %$4) (call @Parser$ptr.remove-comments (types %struct.Parser*) void (args %parser)) (auto %prog %struct.Texp) (auto %filename-string %struct.String) (let %$5 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %filename))) (store %$5 %struct.String %filename-string) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %prog %filename-string)) (call @Parser$ptr.collect (types %struct.Parser* %struct.Texp*) void (args %parser %prog)) (let %$6 (load %struct.Texp %prog)) (return %$6 %struct.Texp))) (def @Parser.parse-file.outro (params (%file %struct.File*) (%content %struct.StringView*) (%parser %struct.Parser*)) void (do (call @Parser$ptr.unmake (types %struct.Parser*) void (args %parser)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @Parser.parse-file (params (%filename %struct.StringView*)) %struct.Texp (do (auto %file %struct.File) (auto %content %struct.StringView) (auto %parser %struct.Parser) (let %prog (call @Parser.parse-file.intro (types %struct.StringView* %struct.File* %struct.StringView* %struct.Parser*) %struct.Texp (args %filename %file %content %parser))) (call @Parser.parse-file.outro (types %struct.File* %struct.StringView* %struct.Parser*) void (args %file %content %parser)) (return %prog %struct.Texp))) (def @Parser.parse-file-i8$ptr (params (%filename i8*)) %struct.Texp (do (auto %fn-view %struct.StringView) (let %$0 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args %filename))) (store %$0 %struct.StringView %fn-view) (let %$1 (call @Parser.parse-file (types %struct.StringView*) %struct.Texp (args %fn-view))) (return %$1 %struct.Texp))) (def @test.parser-whitespace params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 77))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %parser)) (let %$8 (index %parser %struct.Parser 0)) (let %$7 (index %$8 %struct.Reader 1)) (let %$6 (load i8* %$7)) (call @puts (types i8*) i32 (args %$6)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %parser)) (let %$11 (index %parser %struct.Parser 0)) (let %$10 (index %$11 %struct.Reader 1)) (let %$9 (load i8* %$10)) (call @puts (types i8*) i32 (args %$9)) (let %$12 (index %parser %struct.Parser 0)) (call @Reader$ptr.get (types %struct.Reader*) i8 (args %$12)) (let %$15 (index %parser %struct.Parser 0)) (let %$14 (index %$15 %struct.Reader 1)) (let %$13 (load i8* %$14)) (call @puts (types i8*) i32 (args %$13)) (call @Parser$ptr.whitespace (types %struct.Parser*) void (args %parser)) (let %$18 (index %parser %struct.Parser 0)) (let %$17 (index %$18 %struct.Reader 1)) (let %$16 (load i8* %$17)) (call @puts (types i8*) i32 (args %$16)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-atom params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 78))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (auto %texp %struct.Texp) (let %$6 (call @Parser$ptr.atom (types %struct.Parser*) %struct.Texp (args %parser))) (store %$6 %struct.Texp %texp) (let %$9 (index %parser %struct.Parser 0)) (let %$8 (index %$9 %struct.Reader 1)) (let %$7 (load i8* %$8)) (call @puts (types i8*) i32 (args %$7)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) (auto %texp2 %struct.Texp) (let %$10 (call @Parser$ptr.atom (types %struct.Parser*) %struct.Texp (args %parser))) (store %$10 %struct.Texp %texp2) (let %$13 (index %parser %struct.Parser 0)) (let %$12 (index %$13 %struct.Reader 1)) (let %$11 (load i8* %$12)) (call @puts (types i8*) i32 (args %$11)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp2)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-texp params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 79))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (auto %texp %struct.Texp) (let %$6 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %parser))) (store %$6 %struct.Texp %texp) (let %$9 (index %parser %struct.Parser 0)) (let %$8 (index %$9 %struct.Reader 1)) (let %$7 (load i8* %$8)) (call @puts (types i8*) i32 (args %$7)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-string params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 80))) (auto %file %struct.File) (let %$0 (call @File.open (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.read (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (auto %texp %struct.Texp) (let %$6 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %parser))) (store %$6 %struct.Texp %texp) (let %$9 (index %parser %struct.Parser 0)) (let %$8 (index %$9 %struct.Reader 1)) (let %$7 (load i8* %$8)) (call @puts (types i8*) i32 (args %$7)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) (let %$11 (index %texp %struct.Texp 2)) (let %$10 (load u64 %$11)) (call @u64.print (types u64) void (args %$10)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-comments params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 81))) (auto %file %struct.File) (let %$0 (call @File.openrw (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.readwrite (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (call @Parser$ptr.remove-comments (types %struct.Parser*) void (args %parser)) (let %$5 (index %parser %struct.Parser 0)) (let %$4 (index %$5 %struct.Reader 1)) (let %$3 (load i8* %$4)) (call @puts (types i8*) i32 (args %$3)) (auto %texp %struct.Texp) (let %$6 (call @Parser$ptr.texp (types %struct.Parser*) %struct.Texp (args %parser))) (store %$6 %struct.Texp %texp) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @println types void args) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @test.parser-file params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 82))) (auto %file %struct.File) (let %$0 (call @File.openrw (types %struct.StringView*) %struct.File (args %filename))) (store %$0 %struct.File %file) (auto %content %struct.StringView) (let %$1 (call @File$ptr.readwrite (types %struct.File*) %struct.StringView (args %file))) (store %$1 %struct.StringView %content) (auto %parser %struct.Parser) (let %$2 (index %parser %struct.Parser 0)) (call @Reader$ptr.set (types %struct.Reader* %struct.StringView*) void (args %$2 %content)) (call @Parser$ptr.remove-comments (types %struct.Parser*) void (args %parser)) (auto %prog %struct.Texp) (auto %filename-string %struct.String) (let %$3 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %filename))) (store %$3 %struct.String %filename-string) (call @Texp$ptr.setFromString (types %struct.Texp* %struct.String*) void (args %prog %filename-string)) (call @Parser$ptr.collect (types %struct.Parser* %struct.Texp*) void (args %parser %prog)) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %prog)) (call @File.unread (types %struct.StringView*) void (args %content)) (call @File$ptr.close (types %struct.File*) void (args %file)) return-void)) (def @Texp$ptr.pretty-print$lambda.do (params (%this %struct.Texp*)) void (do return-void)) (def @Texp$ptr.pretty-print$lambda.toplevel (params (%this %struct.Texp*) (%last %struct.Texp*)) void (do (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %this)) (call @println types void args) (let %$0 (!= %struct.Texp* %this %last)) (if %$0 (do (let %$2 (ptrtoint %struct.Texp* u64 %this)) (let %$1 (+ u64 40 %$2)) (let %next (inttoptr u64 %struct.Texp* %$1)) (call @Texp$ptr.pretty-print$lambda.toplevel (types %struct.Texp* %struct.Texp*) void (args %next %last)))) return-void)) (def @Texp$ptr.pretty-print (params (%this %struct.Texp*)) void (do (let %LPAREN (+ i8 40 0)) (let %RPAREN (+ i8 41 0)) (call @i8.print (types i8) void (args %LPAREN)) (let %$0 (index %this %struct.Texp 0)) (call @String$ptr.println (types %struct.String*) void (args %$0)) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %this))) (let %$1 (index %this %struct.Texp 1)) (let %first-child (load %struct.Texp* %$1)) (call @Texp$ptr.pretty-print$lambda.toplevel (types %struct.Texp* %struct.Texp*) void (args %first-child %last)) (call @i8.print (types i8) void (args %RPAREN)) (call @println types void args) return-void)) (def @test.texp-pretty-print params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 83))) (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file (types %struct.StringView*) %struct.Texp (args %filename))) (store %$0 %struct.Texp %prog) (call @Texp$ptr.pretty-print (types %struct.Texp*) void (args %prog)) return-void)) (struct %struct.Grammar (%texp %struct.Texp)) (def @Grammar.make (params (%texp %struct.Texp)) %struct.Grammar (do (auto %grammar %struct.Grammar) (let %$0 (index %grammar %struct.Grammar 0)) (store %texp %struct.Texp %$0) (let %$1 (index %grammar %struct.Grammar 0)) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %$1)) (let %$2 (load %struct.Grammar %grammar)) (return %$2 %struct.Grammar))) (def @Grammar$ptr.getProduction (params (%this %struct.Grammar*) (%type-name %struct.StringView*)) %struct.Texp* (do (let %$0 (index %this %struct.Grammar 0)) (let %maybe-prod (call @Texp$ptr.find (types %struct.Texp* %struct.StringView*) %struct.Texp* (args %$0 %type-name))) (let %$2 (ptrtoint %struct.Texp* u64 %maybe-prod)) (let %$1 (== u64 0 %$2)) (if %$1 (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 84))) (call @StringView$ptr.print (types %struct.StringView*) void (args %type-name)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 85))) (call @exit (types i32) void (args 1)))) (return %maybe-prod %struct.Texp*))) (def @Grammar$ptr.get-keyword (params (%this %struct.Grammar*) (%type-name %struct.StringView*)) %struct.Texp (do (let %prod (call @Grammar$ptr.getProduction (types %struct.Grammar* %struct.StringView*) %struct.Texp* (args %this %type-name))) (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %$1 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 86)))) (if %$1 (do (let %$2 (call @Optional.none types %struct.Texp args)) (return %$2 %struct.Texp))) (let %rule-value (index %rule %struct.Texp 0)) (let %$3 (call @String$ptr.is-empty (types %struct.String*) i1 (args %rule-value))) (if %$3 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 87))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (call @exit (types i32) void (args 1)))) (let %HASH (+ i8 35 0)) (let %$5 (call @String$ptr.char-at-unsafe (types %struct.String* u64) i8 (args %rule-value 0))) (let %$4 (== i8 %HASH %$5)) (if %$4 (do (let %$6 (call @Optional.none types %struct.Texp args)) (return %$6 %struct.Texp))) (let %$7 (call @Texp.makeFromString (types %struct.String*) %struct.Texp (args %rule-value))) (return %$7 %struct.Texp))) (struct %struct.Matcher (%grammar %struct.Grammar)) (def @Matcher$ptr.is (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%type-name %struct.StringView*)) %struct.Texp (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 88))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 89))) (call @StringView$ptr.print (types %struct.StringView*) void (args %type-name)) (let %grammar (index %this %struct.Matcher 0)) (let %prod (call @Grammar$ptr.getProduction (types %struct.Grammar* %struct.StringView*) %struct.Texp* (args %grammar %type-name))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 90))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %prod)) (call @println types void args) (auto %result %struct.Texp) (let %$0 (call @Matcher$ptr.match (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (store %$0 %struct.Texp %result) (let %$1 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %result (str-get 91)))) (if %$1 (do (let %$2 (index %result %struct.Texp 1)) (let %child (load %struct.Texp* %$2)) (let %proof-value (index %child %struct.Texp 0)) (auto %new-proof-value %struct.String) (let %$3 (call @String.makeFromStringView (types %struct.StringView*) %struct.String (args %type-name))) (store %$3 %struct.String %new-proof-value) (let %FORWARD_SLASH (+ i8 47 0)) (call @String$ptr.pushChar (types %struct.String* i8) void (args %new-proof-value %FORWARD_SLASH)) (call @String$ptr.append (types %struct.String* %struct.String*) void (args %new-proof-value %proof-value)) (call @String$ptr.free (types %struct.String*) void (args %proof-value)) (let %$4 (load %struct.String %new-proof-value)) (store %$4 %struct.String %proof-value))) (let %$5 (load %struct.Texp %result)) (return %$5 %struct.Texp))) (def @Matcher$ptr.atom (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 92))) (let %$2 (index %texp %struct.Texp 2)) (let %$1 (load u64 %$2)) (let %$0 (!= u64 0 %$1)) (if %$0 (do (auto %error-result %struct.Texp) (let %$3 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 93)))) (store %$3 %struct.Texp %error-result) (let %$4 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %prod))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %error-result %$4)) (let %$5 (load %struct.Texp %error-result)) (return %$5 %struct.Texp))) (let %$6 (call @Result.success-from-i8$ptr (types i8*) %struct.Texp (args (str-get 94)))) (return %$6 %struct.Texp))) (def @Matcher$ptr.match (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %$1 (index %rule %struct.Texp 2)) (let %rule-length (load u64 %$1)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 95))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (let %$2 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 96)))) (if %$2 (do (call @println types void args) (let %$3 (call @Matcher$ptr.choice (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (return %$3 %struct.Texp))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 97))) (call @u64.print (types u64) void (args %rule-length)) (call @println types void args) (auto %value-result %struct.Texp) (let %$4 (call @Matcher$ptr.value (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (store %$4 %struct.Texp %value-result) (let %$5 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %value-result (str-get 98)))) (if %$5 (do (let %$6 (load %struct.Texp %value-result)) (return %$6 %struct.Texp))) (let %$7 (!= u64 %rule-length 0)) (if %$7 (do (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %rule))) (let %$8 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %last (str-get 99)))) (if %$8 (do (let %$9 (call @Matcher$ptr.kleene (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (return %$9 %struct.Texp))) (let %$10 (call @Matcher$ptr.exact (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (return %$10 %struct.Texp))) (let %$11 (call @Matcher$ptr.atom (types %struct.Matcher* %struct.Texp* %struct.Texp*) %struct.Texp (args %this %texp %prod))) (return %$11 %struct.Texp))) (def @Matcher$ptr.kleene-seq (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*) (%acc %struct.Texp*) (%curr-index u64) (%last-index u64)) void (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 100))) (call @u64.print (types u64) void (args %curr-index)) (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %rule))) (let %texp-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %texp %curr-index))) (let %rule-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %rule %curr-index))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 101))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp-child)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 102))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule-child)) (call @println types void args) (auto %result %struct.Texp) (let %$2 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule-child))) (let %$1 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %this %texp-child %$2))) (store %$1 %struct.Texp %result) (let %$3 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %result (str-get 103)))) (if %$3 (do (call @Texp$ptr.free (types %struct.Texp*) void (args %acc)) (let %$4 (load %struct.Texp %result)) (store %$4 %struct.Texp %acc) return-void)) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %result)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %acc %result)) (let %$5 (== u64 %curr-index %last-index)) (if %$5 (do return-void)) (let %next-index (+ u64 1 %curr-index)) (call @Matcher$ptr.kleene-seq (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %acc %next-index %last-index)) return-void)) (def @Matcher$ptr.kleene-many (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*) (%acc %struct.Texp*) (%curr-index u64) (%last-index u64)) void (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 104))) (call @u64.print (types u64) void (args %curr-index)) (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %rule))) (let %texp-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %texp %curr-index))) (let %rule-child (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %last))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 105))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp-child)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 106))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule-child)) (call @println types void args) (auto %result %struct.Texp) (let %$2 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule-child))) (let %$1 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %this %texp-child %$2))) (store %$1 %struct.Texp %result) (let %$3 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %result (str-get 107)))) (if %$3 (do (call @Texp$ptr.free (types %struct.Texp*) void (args %acc)) (let %$4 (load %struct.Texp %result)) (store %$4 %struct.Texp %acc) return-void)) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %result)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %acc %result)) (let %$5 (== u64 %curr-index %last-index)) (if %$5 (do return-void)) (let %next-index (+ u64 1 %curr-index)) (call @Matcher$ptr.kleene-many (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %acc %next-index %last-index)) return-void)) (def @Matcher$ptr.kleene (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 108))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 109))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (call @println types void args) (let %last (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %rule))) (let %$1 (index %last %struct.Texp 0)) (let %kleene-prod-view (call @String$ptr.view (types %struct.String*) %struct.StringView (args %$1))) (let %$2 (index %rule %struct.Texp 2)) (let %rule-length (load u64 %$2)) (let %$3 (index %texp %struct.Texp 2)) (let %texp-length (load u64 %$3)) (auto %proof %struct.Texp) (let %$4 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 110)))) (store %$4 %struct.Texp %proof) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 111))) (call @u64.print (types u64) void (args %rule-length)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 112))) (call @u64.print (types u64) void (args %texp-length)) (call @println types void args) (let %seq-length (- u64 %rule-length 1)) (let %last-texp-i (- u64 %texp-length 1)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 113))) (call @u64.print (types u64) void (args %seq-length)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 114))) (call @u64.print (types u64) void (args %last-texp-i)) (call @println types void args) (let %$5 (< u64 %texp-length %seq-length)) (if %$5 (do (auto %failure-result %struct.Texp) (let %$6 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 115)))) (store %$6 %struct.Texp %failure-result) (let %$7 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 116)))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %failure-result %$7)) (let %$8 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %rule))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %failure-result %$8)) (let %$9 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %failure-result %$9)) (let %$10 (load %struct.Texp %failure-result)) (return %$10 %struct.Texp))) (let %$11 (!= u64 0 %seq-length)) (if %$11 (do (let %$12 (- u64 %seq-length 1)) (call @Matcher$ptr.kleene-seq (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %proof 0 %$12)) (let %$13 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %proof (str-get 117)))) (if %$13 (do (let %$14 (load %struct.Texp %proof)) (return %$14 %struct.Texp))))) (let %$15 (!= u64 %seq-length %texp-length)) (if %$15 (do (let %$16 (- u64 %texp-length 1)) (call @Matcher$ptr.kleene-many (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %proof %seq-length %$16)) (let %$17 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %proof (str-get 118)))) (if %$17 (do (let %$18 (load %struct.Texp %proof)) (return %$18 %struct.Texp))))) (let %$19 (call @Result.success (types %struct.Texp*) %struct.Texp (args %proof))) (return %$19 %struct.Texp))) (def @Matcher$ptr.exact_ (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*) (%acc %struct.Texp*) (%curr-index u64) (%last-index u64)) void (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %texp-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %texp %curr-index))) (let %rule-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %rule %curr-index))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 119))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp-child)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 120))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule-child)) (call @println types void args) (auto %result %struct.Texp) (let %$2 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule-child))) (let %$1 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %this %texp-child %$2))) (store %$1 %struct.Texp %result) (let %$3 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %result (str-get 121)))) (if %$3 (do (call @Texp$ptr.free (types %struct.Texp*) void (args %acc)) (let %$4 (load %struct.Texp %result)) (store %$4 %struct.Texp %acc) return-void)) (call @Texp$ptr.demote-free (types %struct.Texp*) void (args %result)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %acc %result)) (let %$5 (== u64 %curr-index %last-index)) (if %$5 (do return-void)) (let %next-index (+ u64 1 %curr-index)) (call @Matcher$ptr.exact_ (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %acc %next-index %last-index)) return-void)) (def @Matcher$ptr.exact (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %$3 (index %texp %struct.Texp 2)) (let %$2 (load u64 %$3)) (let %$5 (index %rule %struct.Texp 2)) (let %$4 (load u64 %$5)) (let %$1 (!= u64 %$2 %$4)) (if %$1 (do (auto %len-result %struct.Texp) (let %$6 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 122)))) (store %$6 %struct.Texp %len-result) (let %$7 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %len-result %$7)) (let %$8 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %rule))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %len-result %$8)) (let %$9 (load %struct.Texp %len-result)) (return %$9 %struct.Texp))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 123))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 124))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (call @println types void args) (auto %proof %struct.Texp) (let %$10 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 125)))) (store %$10 %struct.Texp %proof) (let %$12 (index %texp %struct.Texp 2)) (let %$11 (load u64 %$12)) (let %last (- u64 %$11 1)) (call @Matcher$ptr.exact_ (types %struct.Matcher* %struct.Texp* %struct.Texp* %struct.Texp* u64 u64) void (args %this %texp %prod %proof 0 %last)) (auto %proof-success-wrapper %struct.Texp) (let %$13 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 126)))) (store %$13 %struct.Texp %proof-success-wrapper) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %proof-success-wrapper %proof)) (let %$14 (load %struct.Texp %proof-success-wrapper)) (return %$14 %struct.Texp))) (def @Matcher$ptr.choice_ (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*) (%i u64) (%attempts %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %rule-child (call @Texp$ptr.child (types %struct.Texp* u64) %struct.Texp* (args %rule %i))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 127))) (call @u64.print (types u64) void (args %i)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 128))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %texp)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 129))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule-child)) (call @println types void args) (let %rule-child-view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule-child))) (auto %is-result %struct.Texp) (let %$1 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %this %texp %rule-child-view))) (store %$1 %struct.Texp %is-result) (let %$2 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %is-result (str-get 130)))) (if %$2 (do (let %$4 (index %is-result %struct.Texp 1)) (let %$3 (load %struct.Texp* %$4)) (let %proof-value-ref (index %$3 %struct.Texp 0)) (auto %choice-marker %struct.String) (let %$5 (call @String.makeFromi8$ptr (types i8*) %struct.String (args (str-get 131)))) (store %$5 %struct.String %choice-marker) (call @String$ptr.prepend (types %struct.String* %struct.String*) void (args %proof-value-ref %choice-marker)) (let %$6 (load %struct.Texp %is-result)) (return %$6 %struct.Texp))) (auto %keyword-result %struct.Texp) (let %$8 (index %this %struct.Matcher 0)) (let %$7 (call @Grammar$ptr.get-keyword (types %struct.Grammar* %struct.StringView*) %struct.Texp (args %$8 %rule-child-view))) (store %$7 %struct.Texp %keyword-result) (let %$10 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %texp))) (let %$11 (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %keyword-result))) (let %$9 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %$10 %$11))) (if %$9 (do (auto %keyword-error-result %struct.Texp) (let %$12 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 132)))) (store %$12 %struct.Texp %keyword-error-result) (let %$13 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %prod))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-error-result %$13)) (let %$14 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-error-result %$14)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %keyword-error-result %is-result)) (let %$15 (load %struct.Texp %keyword-error-result)) (return %$15 %struct.Texp))) (let %$17 (index %rule %struct.Texp 2)) (let %$16 (load u64 %$17)) (let %last-rule-index (- u64 %$16 1)) (let %$18 (== u64 %i %last-rule-index)) (if %$18 (do (auto %choice-match-error-result %struct.Texp) (let %$19 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 133)))) (store %$19 %struct.Texp %choice-match-error-result) (let %$20 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %prod))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %choice-match-error-result %$20)) (let %$21 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %choice-match-error-result %$21)) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %choice-match-error-result %attempts)) (let %$22 (load %struct.Texp %choice-match-error-result)) (return %$22 %struct.Texp))) (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %attempts %is-result)) (let %$24 (+ u64 1 %i)) (let %$23 (call @Matcher$ptr.choice_ (types %struct.Matcher* %struct.Texp* %struct.Texp* u64 %struct.Texp*) %struct.Texp (args %this %texp %prod %$24 %attempts))) (return %$23 %struct.Texp))) (def @Matcher$ptr.choice (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 134))) (let %$0 (call @Texp$ptr.last (types %struct.Texp*) %struct.Texp* (args %prod))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %$0)) (call @println types void args) (auto %proof %struct.Texp) (let %$1 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 135)))) (store %$1 %struct.Texp %proof) (auto %attempts %struct.Texp) (let %$2 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 136)))) (store %$2 %struct.Texp %attempts) (let %$3 (call @Matcher$ptr.choice_ (types %struct.Matcher* %struct.Texp* %struct.Texp* u64 %struct.Texp*) %struct.Texp (args %this %texp %prod 0 %attempts))) (return %$3 %struct.Texp))) (def @Matcher.regexInt_ (params (%curr i8*) (%len u64)) i1 (do (let %$0 (== u64 0 %len)) (if %$0 (do (return true i1))) (let %ZERO (+ i8 48 0)) (let %$1 (load i8 %curr)) (let %offset (- i8 %$1 %ZERO)) (let %$2 (< i8 %offset 0)) (if %$2 (do (return false i1))) (let %$3 (>= i8 %offset 10)) (if %$3 (do (return false i1))) (let %$7 (ptrtoint i8* u64 %curr)) (let %$6 (+ u64 1 %$7)) (let %$5 (inttoptr u64 i8* %$6)) (let %$8 (- u64 %len 1)) (let %$4 (call @Matcher.regexInt_ (types i8* u64) i1 (args %$5 %$8))) (return %$4 i1))) (def @Matcher.regexInt (params (%texp %struct.Texp*)) i1 (do (let %view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %texp))) (let %$2 (index %view %struct.StringView 0)) (let %$1 (load i8* %$2)) (let %$4 (index %view %struct.StringView 1)) (let %$3 (load u64 %$4)) (let %$0 (call @Matcher.regexInt_ (types i8* u64) i1 (args %$1 %$3))) (return %$0 i1))) (def @Matcher.regexString_ (params (%curr i8*) (%len u64)) i1 (do (return true i1))) (def @Matcher.regexString (params (%texp %struct.Texp*)) i1 (do (let %view (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %texp))) (let %$0 (index %view %struct.StringView 0)) (let %curr (load i8* %$0)) (let %$1 (index %view %struct.StringView 1)) (let %len (load u64 %$1)) (let %$2 (< u64 %len 2)) (if %$2 (do (return false i1))) (let %$4 (- u64 %len 1)) (let %$5 (ptrtoint i8* u64 %curr)) (let %$3 (+ u64 %$4 %$5)) (let %last (inttoptr u64 i8* %$3)) (let %QUOTE (+ i8 34 0)) (let %$7 (load i8 %curr)) (let %$6 (!= i8 %QUOTE %$7)) (if %$6 (do (return false i1))) (let %$9 (load i8 %last)) (let %$8 (!= i8 %QUOTE %$9)) (if %$8 (do (return false i1))) (let %$11 (ptrtoint i8* u64 %curr)) (let %$10 (+ u64 1 %$11)) (let %next (inttoptr u64 i8* %$10)) (let %$13 (- u64 %len 2)) (let %$12 (call @Matcher.regexString_ (types i8* u64) i1 (args %next %$13))) (return %$12 i1))) (def @Matcher.regexBool (params (%texp %struct.Texp*)) i1 (do (let %$0 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %texp (str-get 137)))) (if %$0 (do (return true i1))) (let %$1 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %texp (str-get 138)))) (if %$1 (do (return true i1))) (return false i1))) (def @Matcher$ptr.value (params (%this %struct.Matcher*) (%texp %struct.Texp*) (%prod %struct.Texp*)) %struct.Texp (do (let %$0 (index %prod %struct.Texp 1)) (let %rule (load %struct.Texp* %$0)) (let %texp-value-view-ref (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %texp))) (let %rule-value-view-ref (call @Texp$ptr.value-view (types %struct.Texp*) %struct.StringView* (args %rule))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 139))) (call @StringView$ptr.print (types %struct.StringView*) void (args %texp-value-view-ref)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 140))) (call @StringView$ptr.print (types %struct.StringView*) void (args %rule-value-view-ref)) (call @println types void args) (auto %rule-value-texp %struct.Texp) (let %$1 (call @Texp.makeFromStringView (types %struct.StringView*) %struct.Texp (args %rule-value-view-ref))) (store %$1 %struct.Texp %rule-value-texp) (auto %texp-value-texp %struct.Texp) (let %$2 (call @Texp.makeFromStringView (types %struct.StringView*) %struct.Texp (args %texp-value-view-ref))) (store %$2 %struct.Texp %texp-value-texp) (let %default-success (call @Result.success (types %struct.Texp*) %struct.Texp (args %rule-value-texp))) (let %HASH (+ i8 35 0)) (let %$3 (call @Texp$ptr.value-get (types %struct.Texp* u64) i8 (args %rule 0))) (let %cond (== i8 %HASH %$3)) (auto %error-result %struct.Texp) (let %$4 (call @Texp.makeEmpty types %struct.Texp args)) (store %$4 %struct.Texp %error-result) (if %cond (do (let %$5 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 141)))) (if %$5 (do (let %$6 (call @Matcher.regexInt (types %struct.Texp*) i1 (args %texp))) (if %$6 (do (return %default-success %struct.Texp))) (let %$7 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 142)))) (store %$7 %struct.Texp %error-result))) (let %$8 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 143)))) (if %$8 (do (let %$9 (call @Matcher.regexString (types %struct.Texp*) i1 (args %texp))) (if %$9 (do (return %default-success %struct.Texp))) (let %$10 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 144)))) (store %$10 %struct.Texp %error-result))) (let %$11 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 145)))) (if %$11 (do (let %$12 (call @Matcher.regexBool (types %struct.Texp*) i1 (args %texp))) (if %$12 (do (return %default-success %struct.Texp))) (let %$13 (call @Result.error-from-i8$ptr (types i8*) %struct.Texp (args (str-get 146)))) (store %$13 %struct.Texp %error-result))) (let %$14 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 147)))) (if %$14 (do (return %default-success %struct.Texp))) (let %$15 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %rule (str-get 148)))) (if %$15 (do (return %default-success %struct.Texp))) (let %$16 (call @Texp$ptr.value-check (types %struct.Texp* i8*) i1 (args %error-result (str-get 149)))) (if %$16 (do (call @Texp$ptr.push$ptr (types %struct.Texp* %struct.Texp*) void (args %error-result %texp)) (let %$17 (load %struct.Texp %error-result)) (return %$17 %struct.Texp))) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 150))) (call @StringView$ptr.print (types %struct.StringView*) void (args %rule-value-view-ref)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 151))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %rule)) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 152))) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %error-result)) (call @println types void args) (call @exit (types i32) void (args 1)))) (let %$18 (call @StringView$ptr.eq (types %struct.StringView* %struct.StringView*) i1 (args %rule-value-view-ref %texp-value-view-ref))) (if %$18 (do (return %default-success %struct.Texp))) (auto %keyword-match-error %struct.Texp) (let %$19 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 153)))) (store %$19 %struct.Texp %keyword-match-error) (let %$20 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 154)))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-match-error %$20)) (let %$21 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %rule-value-texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-match-error %$21)) (let %$22 (call @Texp$ptr.clone (types %struct.Texp*) %struct.Texp (args %texp-value-texp))) (call @Texp$ptr.push (types %struct.Texp* %struct.Texp) void (args %keyword-match-error %$22)) (let %$23 (load %struct.Texp %keyword-match-error)) (return %$23 %struct.Texp))) (def @test.matcher-simple params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 155)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 156)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 157)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-choice params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 158)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 159)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 160)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-kleene-seq params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 161)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 162)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 163)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-exact params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 164)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 165)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 166)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-value params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 167)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 168)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 169)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-empty-kleene params void (do (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 170)))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 171)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 172)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-self params void (do (auto %filename %struct.StringView) (call @StringView$ptr.set (types %struct.StringView* i8*) void (args %filename (str-get 173))) (auto %prog %struct.Texp) (let %$0 (call @Parser.parse-file (types %struct.StringView*) %struct.Texp (args %filename))) (store %$0 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$2 (call @Parser.parse-file-i8$ptr (types i8*) %struct.Texp (args (str-get 174)))) (let %$1 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$2))) (let %$3 (index %matcher %struct.Matcher 0)) (store %$1 %struct.Grammar %$3) (auto %start-production %struct.StringView) (let %$4 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 175)))) (store %$4 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$5 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$5 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) return-void)) (def @test.matcher-regexString params void (do (auto %string %struct.Texp) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 176)))) (store %$0 %struct.Texp %string) (let %$1 (call @Matcher.regexString (types %struct.Texp*) i1 (args %string))) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 177))) return-void)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 178))) return-void)) (def @test.matcher-regexInt params void (do (auto %string %struct.Texp) (let %actual (+ u64 1234567890 0)) (let %$0 (call @Texp.makeFromi8$ptr (types i8*) %struct.Texp (args (str-get 179)))) (store %$0 %struct.Texp %string) (let %$1 (call @Matcher.regexInt (types %struct.Texp*) i1 (args %string))) (if %$1 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 180))) return-void)) (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 181))) return-void)) (def @main (params (%argc i32) (%argv i8**)) i32 (do (let %$0 (!= i32 2 %argc)) (if %$0 (do (call @i8$ptr.unsafe-println (types i8*) void (args (str-get 182))) (call @exit (types i32) void (args 1)))) (let %$2 (ptrtoint i8** u64 %argv)) (let %$1 (+ u64 8 %$2)) (let %arg (inttoptr u64 i8** %$1)) (auto %test-case %struct.String) (let %$4 (load i8* %arg)) (let %$3 (call @String.makeFromi8$ptr (types i8*) %struct.String (args %$4))) (store %$3 %struct.String %test-case) (call @i8$ptr.unsafe-print (types i8*) void (args (str-get 183))) (call @String$ptr.println (types %struct.String*) void (args %test-case)) (auto %test-dir %struct.String) (let %$5 (call @String.makeFromi8$ptr (types i8*) %struct.String (args (str-get 184)))) (store %$5 %struct.String %test-dir) (auto %test-case-path %struct.String) (let %$6 (call @String.add (types %struct.String* %struct.String*) %struct.String (args %test-dir %test-case))) (store %$6 %struct.String %test-case-path) (auto %grammar-path %struct.String) (let %$7 (call @String.makeFromi8$ptr (types i8*) %struct.String (args (str-get 185)))) (store %$7 %struct.String %grammar-path) (call @String$ptr.prepend (types %struct.String* %struct.String*) void (args %grammar-path %test-case-path)) (auto %texp-file-path %struct.String) (let %$8 (call @String.makeFromi8$ptr (types i8*) %struct.String (args (str-get 186)))) (store %$8 %struct.String %texp-file-path) (call @String$ptr.prepend (types %struct.String* %struct.String*) void (args %texp-file-path %test-case-path)) (auto %prog %struct.Texp) (let %$10 (bitcast %struct.String* %struct.StringView* %texp-file-path)) (let %$9 (call @Parser.parse-file (types %struct.StringView*) %struct.Texp (args %$10))) (store %$9 %struct.Texp %prog) (auto %matcher %struct.Matcher) (let %$13 (bitcast %struct.String* %struct.StringView* %grammar-path)) (let %$12 (call @Parser.parse-file (types %struct.StringView*) %struct.Texp (args %$13))) (let %$11 (call @Grammar.make (types %struct.Texp) %struct.Grammar (args %$12))) (let %$14 (index %matcher %struct.Matcher 0)) (store %$11 %struct.Grammar %$14) (auto %start-production %struct.StringView) (let %$15 (call @StringView.makeFromi8$ptr (types i8*) %struct.StringView (args (str-get 187)))) (store %$15 %struct.StringView %start-production) (auto %result %struct.Texp) (let %$16 (call @Matcher$ptr.is (types %struct.Matcher* %struct.Texp* %struct.StringView*) %struct.Texp (args %matcher %prog %start-production))) (store %$16 %struct.Texp %result) (call @Texp$ptr.parenPrint (types %struct.Texp*) void (args %result)) (call @println types void args) (return 0 i32))) (str-table (0 "global string example\00") (1 "'%s' has length %lu.\0A\00") (2 "global string example\00") (3 "global string example\00") (4 "global string example\00") (5 "'%s' has length %lu.\0A\00") (6 "basic-string test\00") (7 "'%s' has length %lu.\0A\00") (8 "string-self-append test\00") (9 "hello, \00") (10 "world\00") (11 "this is a comparison string\00") (12 "this is a comparison string\00") (13 "PASSED\00") (14 "FAILED\00") (15 "hello, \00") (16 "world\00") (17 "error opening file at '%s'\0A\00") (18 "backbone-core: mmap\00") (19 "todo.json\00") (20 "lib2/core.bb.type.tall\00") (21 "%ul\0A\00") (22 "lib2/core.bb.type.tall\00") (23 " \00") (24 ",\00") (25 " -> \00") (26 ",\00") (27 "Error: Seeking before cursor column\00") (28 "Error: Seeking past end of column\00") (29 "Error: Seeking past end of file\00") (30 "Error: Seeking before cursor line\00") (31 "Error: Finding character past end of file") (32 "lib2/core.bb.type.tall\00") (33 "todo.json\00") (34 "success\00") (35 "success\00") (36 "error\00") (37 "error\00") (38 "error\00") (39 "some\00") (40 "none\00") (41 "empty\00") (42 "(null texp)\00") (43 "value: '\00") (44 "', length: \00") (45 ", capacity: \00") (46 "(null texp)\00") (47 "    at \00") (48 "hello\00") (49 "child-0\00") (50 "child-1\00") (51 "child-2\00") (52 "hello\00") (53 "child-0\00") (54 "child-1\00") (55 "child-2\00") (56 "atom\00") (57 " \00") (58 " \00") (59 "(kleene (success atom) (success atom))\00") (60 "hello\00") (61 "pass\00") (62 "fail\00") (63 "docs/bb-type-tall-str-include-grammar.texp\00") (64 "Program\00") (65 "PASSED\00") (66 "FAILED\00") (67 "docs/bb-type-tall-str-include-grammar.texp\00") (68 "Program\00") (69 "FAILED: Program not found in grammar\0Agrammar:\00") (70 "PASSED\00") (71 "0123456789\00") (72 "PASSED\00") (73 "FAILED\00") (74 "0123456789\00") (75 "PASSED\00") (76 "FAILED\00") (77 "") (78 "huh\00") (79 "lib2/core.bb.type.tall\00") (80 "../backbone-test/texp-parser/string.texp\00") (81 "lib2/core.bb.type.tall\00") (82 "lib2/core.bb.type.tall\00") (83 "lib/pprint.bb\00") (84 "\0Aproduction \00") (85 " not found\00") (86 "|\00") (87 "rule value should not be empty for rule:\00") (88 " [.is           ]  \00") (89 " -> \00") (90 " @ \00") (91 "success\00") (92 " [.atom         ]\00") (93 "\22texp is not an atom\22\00") (94 "atom\00") (95 " [.match        ]  -> \00") (96 "|\00") (97 ", rule-length: \00") (98 "error\00") (99 "*\00") (100 " [.kleene-seq   ]  i: \00") (101 ", \00") (102 " -> :\00") (103 "error\00") (104 " [.kleene-many  ]  i: \00") (105 ", \00") (106 " -> :\00") (107 "error\00") (108 " [.kleene       ]  texp: \00") (109 ", rule: \00") (110 "kleene\00") (111 " [.kleene       ]  rule-length: \00") (112 ", texp-length: \00") (113 " [.kleene       ]  seq-length: \00") (114 ", last-texp-i: \00") (115 "error\00") (116 "texp length not less than for rule.len - 1\00") (117 "error\00") (118 "error\00") (119 " [.exact_       ]  \00") (120 " -> \00") (121 "error\00") (122 "\22texp has incorrect length for exact sequence\22\00") (123 " [.exact        ]  \00") (124 " -> \00") (125 "exact\00") (126 "success\00") (127 " [.choice_      ]  i: \00") (128 ", \00") (129 " -> :\00") (130 "success\00") (131 "choice->\00") (132 "keyword-choice-match\00") (133 "choice-match\00") (134 " [.choice       ]  -> \00") (135 "choice\00") (136 "choice-attempts\00") (137 "true\00") (138 "false\00") (139 " [.value        ]  \00") (140 " -> \00") (141 "#int\00") (142 "failed to match #int\22\00") (143 "#string\00") (144 "\22failed to match #string\22\00") (145 "#bool\00") (146 "\22failed to match #bool\22\00") (147 "#type\00") (148 "#name\00") (149 "error\00") (150 "unmatched regex check for rule value: \00") (151 ", rule: \00") (152 ", \00") (153 "error\00") (154 "keyword-match\00") (155 "/home/kasra/projects/backbone-test/matcher/program.texp\00") (156 "/home/kasra/projects/backbone-test/matcher/program.grammar\00") (157 "Program\00") (158 "/home/kasra/projects/backbone-test/matcher/choice.texp\00") (159 "/home/kasra/projects/backbone-test/matcher/choice.grammar\00") (160 "Program\00") (161 "/home/kasra/projects/backbone-test/matcher/seq-kleene.texp\00") (162 "/home/kasra/projects/backbone-test/matcher/seq-kleene.grammar\00") (163 "Program\00") (164 "/home/kasra/projects/backbone-test/matcher/exact.texp\00") (165 "/home/kasra/projects/backbone-test/matcher/exact.grammar\00") (166 "Program\00") (167 "/home/kasra/projects/backbone-test/matcher/value.texp\00") (168 "/home/kasra/projects/backbone-test/matcher/value.grammar\00") (169 "Program\00") (170 "/home/kasra/projects/backbone-test/matcher/empty-kleene.texp\00") (171 "/home/kasra/projects/backbone-test/matcher/empty-kleene.grammar\00") (172 "Program\00") (173 "lib2/matcher.bb\00") (174 "docs/bb-type-tall-str-include-grammar.texp\00") (175 "Program\00") (176 "\22hello, world\22\00") (177 "PASSED\00") (178 "FAILED\00") (179 "0123456789\00") (180 "PASSED\00") (181 "FAILED\00") (182 "usage: matcher <test-case> from <test-case> in ../backbone-test/matcher/*\00") (183 "test case: \00") (184 "/home/kasra/projects/backbone-test/matcher/\00") (185 ".grammar\00") (186 ".texp\00") (187 "Program\00")))
declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @realloc(i8*, i64)
declare i8* @calloc(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare i64 @write(i32, i8*, i64)
declare i64 @read(i32, i8*, i64)
declare i32 @fflush(i32)
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

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %$0 = icmp ne i32 2, %argc
  br i1 %$0, label %then0, label %post0
then0:
  call void (i8*) @i8$ptr.unsafe-println(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @str.182, i64 0, i64 0))
  call void (i32) @exit(i32 1)
  br label %post0
post0:
  %$2 = ptrtoint i8** %argv to i64
  %$1 = add i64 8, %$2
  %arg = inttoptr i64 %$1 to i8**
  %test-case = alloca %struct.String
  %$4 = load i8*, i8** %arg
  %$3 = call %struct.String (i8*) @String.makeFromi8$ptr(i8* %$4)
  store %struct.String %$3, %struct.String* %test-case
  call void (i8*) @i8$ptr.unsafe-print(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.183, i64 0, i64 0))
  call void (%struct.String*) @String$ptr.println(%struct.String* %test-case)
  %test-dir = alloca %struct.String
  %$5 = call %struct.String (i8*) @String.makeFromi8$ptr(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @str.184, i64 0, i64 0))
  store %struct.String %$5, %struct.String* %test-dir
  %test-case-path = alloca %struct.String
  %$6 = call %struct.String (%struct.String*, %struct.String*) @String.add(%struct.String* %test-dir, %struct.String* %test-case)
  store %struct.String %$6, %struct.String* %test-case-path
  %grammar-path = alloca %struct.String
  %$7 = call %struct.String (i8*) @String.makeFromi8$ptr(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.185, i64 0, i64 0))
  store %struct.String %$7, %struct.String* %grammar-path
  call void (%struct.String*, %struct.String*) @String$ptr.prepend(%struct.String* %grammar-path, %struct.String* %test-case-path)
  %texp-file-path = alloca %struct.String
  %$8 = call %struct.String (i8*) @String.makeFromi8$ptr(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.186, i64 0, i64 0))
  store %struct.String %$8, %struct.String* %texp-file-path
  call void (%struct.String*, %struct.String*) @String$ptr.prepend(%struct.String* %texp-file-path, %struct.String* %test-case-path)
  %prog = alloca %struct.Texp
  %$10 = bitcast %struct.String* %texp-file-path to %struct.StringView*
  %$9 = call %struct.Texp (%struct.StringView*) @Parser.parse-file(%struct.StringView* %$10)
  store %struct.Texp %$9, %struct.Texp* %prog
  %matcher = alloca %struct.Matcher
  %$13 = bitcast %struct.String* %grammar-path to %struct.StringView*
  %$12 = call %struct.Texp (%struct.StringView*) @Parser.parse-file(%struct.StringView* %$13)
  %$11 = call %struct.Grammar (%struct.Texp) @Grammar.make(%struct.Texp %$12)
  %$14 = getelementptr inbounds %struct.Matcher, %struct.Matcher* %matcher, i32 0, i32 0
  store %struct.Grammar %$11, %struct.Grammar* %$14
  %start-production = alloca %struct.StringView
  %$15 = call %struct.StringView (i8*) @StringView.makeFromi8$ptr(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.187, i64 0, i64 0))
  store %struct.StringView %$15, %struct.StringView* %start-production
  %result = alloca %struct.Texp
  %$16 = call %struct.Texp (%struct.Matcher*, %struct.Texp*, %struct.StringView*) @Matcher$ptr.is(%struct.Matcher* %matcher, %struct.Texp* %prog, %struct.StringView* %start-production)
  store %struct.Texp %$16, %struct.Texp* %result
  call void (%struct.Texp*) @Texp$ptr.parenPrint(%struct.Texp* %result)
  call void () @println()
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
@str.182 = private unnamed_addr constant [74 x i8] c"usage: matcher <test-case> from <test-case> in ../backbone-test/matcher/*\00", align 1
@str.183 = private unnamed_addr constant [12 x i8] c"test case: \00", align 1
@str.184 = private unnamed_addr constant [44 x i8] c"/home/kasra/projects/backbone-test/matcher/\00", align 1
@str.185 = private unnamed_addr constant [9 x i8] c".grammar\00", align 1
@str.186 = private unnamed_addr constant [6 x i8] c".texp\00", align 1
@str.187 = private unnamed_addr constant [8 x i8] c"Program\00", align 1

; (Program/kleene (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Decl/exact Name/atom (Types/kleene Type/atom) Type/atom) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->Sext/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->GE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Value/choice->StrGet/exact IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallVargs/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom) Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->GT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Rem/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->Trunc/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Div/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Mul/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom) (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)))) (Stmt/choice->Call/choice->CallTail/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Struct/kleene Name/atom (Field/exact Type/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom)) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->GE/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->LT/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Sub/exact Type/atom Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->BoolLiteral/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Literal/choice->IntLiteral/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->EQ/exact Type/atom Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Name/atom Type/atom))) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom Params/kleene Type/atom (Do/kleene (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) Stmt/choice->Return/choice->ReturnVoid/atom)) (TopLevel/choice->Def/exact Name/atom (Params/kleene (Param/exact Type/atom) (Param/exact Type/atom)) Type/atom (Do/kleene (Stmt/choice->Let/exact Name/atom (Expr/choice->Icmp/choice->NE/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->If/exact Value/choice->Name/atom (Stmt/choice->Do/kleene (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Literal/choice->IntLiteral/atom)))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->PtrToInt/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->MathBinop/choice->Add/exact Type/atom Value/choice->Literal/choice->IntLiteral/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->IntToPtr/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Load/exact Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom))) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom)) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Cast/choice->BitCast/exact Type/atom Type/atom Value/choice->Name/atom)) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom))) (Stmt/choice->Let/exact Name/atom (Expr/choice->Index/exact Expr/choice->Value/choice->Name/atom Type/atom Value/choice->Literal/choice->IntLiteral/atom)) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene (Value/choice->StrGet/exact IntLiteral/atom)))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Auto/exact Name/atom Type/atom) (Stmt/choice->Let/exact Name/atom (Expr/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom Type/atom Type/atom) Type/atom (Args/kleene Value/choice->Name/atom Value/choice->Name/atom Value/choice->Name/atom))) (Stmt/choice->Store/exact Value/choice->Name/atom Type/atom Value/choice->Name/atom) (Stmt/choice->Call/choice->CallBasic/exact Name/atom (Types/kleene Type/atom) Type/atom (Args/kleene Value/choice->Name/atom)) (Stmt/choice->Call/choice->CallBasic/exact Name/atom Types/kleene Type/atom Args/kleene) (Stmt/choice->Return/choice->ReturnExpr/exact Value/choice->Literal/choice->IntLiteral/atom Type/atom))) (TopLevel/choice->StrTable/kleene (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom) (StrTableEntry/exact String/atom)))
