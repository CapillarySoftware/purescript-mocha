module Test.Mocha
  ( Describe(..)
  , It(..), Before(..), After(..)
  , itIs, itIsNot, Done(..), DoneToken(..)

  , it, itOnly, itSkip
  , it', itOnly', itSkip'
  , itAsync, itOnlyAsync, itSkipAsync
  , itAsync', itOnlyAsync', itSkipAsync'

  , xit, xitOnly, xitSkip
  , xit', xitOnly', xitSkip'
  , xitAsync, xitOnlyAsync, xitSkipAsync
  , xitAsync', xitOnlyAsync', xitSkipAsync'

  , describe, describeOnly, describeSkip
  , xdescribe, xdescribeOnly, xdescribeSkip

  , before, before', beforeAsync, beforeAsync'
  , beforeEach, beforeEach', beforeEachAsync, beforeEachAsync'

  , after, after', afterAsync, afterAsync'
  , afterEach, afterEach', afterEachAsync, afterEachAsync'
  ) where

import Control.Monad.Eff
import Data.Foreign.OOFFI
import Context
import Data.Function
import Data.String
import Data.Maybe
import Data.Maybe.Unsafe (fromJust)

foreign import data Before :: !
foreign import data Describe :: !
foreign import data It :: !
foreign import data After :: !
foreign import data Done :: !

data DoneToken = DoneToken

-- |
-- Resolve a property recursively
--
_resolveC :: forall eff.
  Maybe Context -> [String] -> Eff (|eff) (Maybe Context)
_resolveC ctx [] = pure ctx
_resolveC Nothing [] =
  getContext >>= pure <<< Just
_resolveC ctx (x:xs) = do
  c <- case ctx of
        Just c  -> pure c
        Nothing -> getContext
  p <- getter x c
  _resolveC (Just p) xs

resolveC :: forall eff. String -> Eff (|eff) Context
resolveC xs = do
  ctx <- _resolveC Nothing $ split "." xs
  return $ fromJust ctx

-- |
-- Apply a context as a function
--
foreign import apply0Impl
  """function apply0Impl (ctx) {
      return function() {
        ctx();
      }
  }""" :: forall eff. Fn1 Context (Eff eff Unit)
apply0 = runFn1 apply0Impl

foreign import apply1Impl
  """function apply1Impl (ctx, a) {
      return function() {
        ctx(a);
      }
  }""" :: forall a eff. Fn2 Context a (Eff eff Unit)
apply1 = runFn2 apply1Impl

foreign import apply2Impl
  """function apply2Impl (ctx, a, b) {
      return function() {
        ctx(a, b);
      }
  }""" :: forall a b eff. Fn3 Context a b (Eff eff Unit)
apply2 = runFn3 apply2Impl

-- |
-- Generate a handler
--
foreign import syncImpl
  """function syncImpl(fn, timeout) {
      return function() {
        if (timeout > 0) {
            this.timeout(timeout);
        }
        fn();
      }
  }""" :: forall a eff. Fn2
            (Eff eff a)
            (Number)
            (Eff eff Unit)
sync = runFn2 syncImpl

foreign import asyncImpl
  """function asyncImpl(fn, timeout) {
      return function(done) {
        if (timeout > 0) {
           this.timeout(timeout);
        }
        fn(done)();
      }
  }""" :: forall a eff. Fn2
            (DoneToken -> Eff (done :: Done | eff) a)
            (Number)
            (Eff eff Unit)
async = runFn2 asyncImpl

-- |
-- Easily register a runners and hooks.
--
run  n t to d fn = resolveC n >>= \c -> apply2 c d $ t fn to
hook n t to fn   = resolveC n >>= \c -> apply1 c $ t fn to

-- |
-- `It`
--

runItSync_ :: forall a eff.
    String ->
    Number ->
    String ->
    Eff eff a ->
    Eff (it :: It | eff) Unit
runItSync_ n = run n sync

runItSync     = runItSync_ "it"
runItOnlySync = runItSync_ "it.only"
runItSkipSync = runItSync_ "it.skip"

it      = runItSync     0
itOnly  = runItOnlySync 0
itSkip  = runItSkipSync 0
it'     = flip runItSync
itOnly' = flip runItOnlySync
itSkip' = flip runItSkipSync

runItAsync_ :: forall a eff.
    String ->
    Number ->
    String ->
    (DoneToken -> Eff (done :: Done | eff) a) ->
    Eff (it :: It | eff) Unit
runItAsync_ n = run n async

runItAsync     = runItAsync_ "it"
runItOnlyAsync = runItAsync_ "it.only"
runItSkipAsync = runItAsync_ "it.skip"

itAsync      = runItAsync     0
itOnlyAsync  = runItOnlyAsync 0
itSkipAsync  = runItSkipAsync 0
itAsync'     = flip runItAsync
itOnlyAsync' = flip runItOnlyAsync
itSkipAsync' = flip runItSkipAsync

-- |
-- `Xit`
--

runXitSync_ :: forall a eff.
    String ->
    Number ->
    String ->
    Eff eff a ->
    Eff (it :: It | eff) Unit
runXitSync_ n = run n sync

runXitSync     = runXitSync_ "xit"
runXitOnlySync = runXitSync_ "xit.only"
runXitSkipSync = runXitSync_ "xit.skip"

xit      = runXitSync     0
xitOnly  = runXitOnlySync 0
xitSkip  = runXitSkipSync 0
xit'     = flip runXitSync
xitOnly' = flip runXitOnlySync
xitSkip' = flip runXitSkipSync

runXitAsync_ :: forall a eff.
    String ->
    Number ->
    String ->
    (DoneToken -> Eff (done :: Done | eff) a) ->
    Eff (it :: It | eff) Unit
runXitAsync_ n = run n async

runXitAsync     = runXitAsync_ "xit"
runXitOnlyAsync = runXitAsync_ "xit.only"
runXitSkipAsync = runXitAsync_ "xit.skip"

xitAsync      = runXitAsync     0
xitOnlyAsync  = runXitOnlyAsync 0
xitSkipAsync  = runXitSkipAsync 0
xitAsync'     = flip runXitAsync
xitOnlyAsync' = flip runXitOnlyAsync
xitSkipAsync' = flip runXitSkipAsync

-- |
-- `Describe`
--
runDesc_ :: forall eff a.
  String ->
  String ->
  Eff (describe :: Describe | eff) a ->
  Eff (describe :: Describe | eff) Unit
runDesc_ n  = run n sync 0

describe     = runDesc_ "describe"
describeOnly = runDesc_ "describe.only"
describeSkip = runDesc_ "describe.skip"

-- |
-- `Xdescribe`
--
runXdesc_ :: forall eff a.
  String ->
  String ->
  Eff (describe :: Describe | eff) a ->
  Eff (describe :: Describe | eff) Unit
runXdesc_ n  = run n sync 0

xdescribe     = runXdesc_ "xdescribe"
xdescribeOnly = runXdesc_ "xdescribe.only"
xdescribeSkip = runXdesc_ "xdescribe.skip"

-- |
-- Before / BeforeEach Hook
--

runBeforeSync_ :: forall eff a.
  String ->
  Number ->
  Eff eff a ->
  Eff (before :: Before | eff) Unit
runBeforeSync_ n = hook n sync

runBeforeSync     = runBeforeSync_ "before"
runBeforeEachSync = runBeforeSync_ "beforeEach"

before      = runBeforeSync 0
before'     = runBeforeSync
beforeEach  = runBeforeEachSync 0
beforeEach' = runBeforeEachSync

runBeforeAsync_ :: forall eff a.
  String ->
  Number ->
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (before :: Before | eff) Unit
runBeforeAsync_ n = hook n async

runBeforeAsync     = runBeforeAsync_ "before"
runBeforeEachAsync = runBeforeAsync_ "beforeEach"

beforeAsync      = runBeforeAsync 0
beforeAsync'     = runBeforeAsync
beforeEachAsync  = runBeforeEachAsync 0
beforeEachAsync' = runBeforeEachAsync

-- |
-- After / AfterEach Hook
--

runAfterSync_ :: forall eff a.
  String ->
  Number ->
  Eff eff a ->
  Eff (after :: After | eff) Unit
runAfterSync_ n = hook n sync

runAfterSync     = runAfterSync_ "after"
runAfterEachSync = runAfterSync_ "afterEach"

after      = runAfterSync 0
after'     = runAfterSync
afterEach  = runAfterEachSync 0
afterEach' = runAfterEachSync

runAfterAsync_ :: forall eff a.
  String ->
  Number ->
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (after :: After | eff) Unit
runAfterAsync_ n = hook n async

runAfterAsync     = runAfterAsync_ "after"
runAfterEachAsync = runAfterAsync_ "afterEach"

afterAsync      = runAfterAsync 0
afterAsync'     = runAfterAsync
afterEachAsync  = runAfterEachAsync 0
afterEachAsync' = runAfterEachAsync

-- |
-- Async completion triggers
--
foreign import itIs
  """function itIs(done) {
      return function() {
        done();
      };
  }""" :: forall eff.
          DoneToken ->
          Eff (done :: Done | eff) Unit

foreign import itIsNot
  """function itIsNot(done) {
      return function() {
      };
  }""" :: forall eff a.
          DoneToken ->
          Eff (done :: Done | eff) Unit
