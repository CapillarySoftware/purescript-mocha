module Test.Mocha
  ( Describe(..)
  , It(..), Before(..), After(..)
  , itIs, itIsNot, Done(..), DoneToken(..)

  , DoItSync(..), DoItSyncTimeout(..)
  , DoItAsync(..), DoItAsyncTimeout(..)
  , it, itOnly, itSkip
  , it', itOnly', itSkip'
  , itAsync, itOnlyAsync, itSkipAsync
  , itAsync', itOnlyAsync', itSkipAsync'

  , xit, xitOnly, xitSkip
  , xit', xitOnly', xitSkip'
  , xitAsync, xitOnlyAsync, xitSkipAsync
  , xitAsync', xitOnlyAsync', xitSkipAsync'

  , DoDescribe(..)
  , describe, describeOnly, describeSkip
  , xdescribe, xdescribeOnly, xdescribeSkip

  , DoBefore(..), DoBeforeTimeout(..)
  , DoBeforeAsync(..), DoBeforeAsyncTimeout(..)
  , before, before', beforeAsync, beforeAsync'
  , beforeEach, beforeEach', beforeEachAsync, beforeEachAsync'

  , DoAfter(..), DoAfterTimeout(..)
  , DoAfterAsync(..), DoAfterAsyncTimeout(..)
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

runItSync_ n  = run n sync
runItSync     = runItSync_ "it"
runItOnlySync = runItSync_ "it.only"
runItSkipSync = runItSync_ "it.skip"

type DoItSync = forall a eff.
  String ->
  Eff eff a ->
  Eff (it :: It | eff) Unit

it     :: DoItSync
it     = runItSync     0
itOnly :: DoItSync
itOnly = runItOnlySync 0
itSkip :: DoItSync
itSkip = runItSkipSync 0

type DoItSyncTimeout = forall a eff.
  String ->
  Number ->
  Eff eff a ->
  Eff (it :: It | eff) Unit

it'     :: DoItSyncTimeout
it'     = flip runItSync
itOnly' :: DoItSyncTimeout
itOnly' = flip runItOnlySync
itSkip' :: DoItSyncTimeout
itSkip' = flip runItSkipSync

runItAsync_ n  = run n async
runItAsync     = runItAsync_ "it"
runItOnlyAsync = runItAsync_ "it.only"
runItSkipAsync = runItAsync_ "it.skip"

type DoItAsync = forall a eff.
  String ->
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (it :: It | eff) Unit

itAsync      :: DoItAsync
itAsync      = runItAsync     0
itOnlyAsync  :: DoItAsync
itOnlyAsync  = runItOnlyAsync 0
itSkipAsync  :: DoItAsync
itSkipAsync  = runItSkipAsync 0

type DoItAsyncTimeout = forall a eff.
  String ->
  Number ->
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (it :: It | eff) Unit

itAsync'     :: DoItAsyncTimeout
itAsync'     = flip runItAsync
itOnlyAsync' :: DoItAsyncTimeout
itOnlyAsync' = flip runItOnlyAsync
itSkipAsync' :: DoItAsyncTimeout
itSkipAsync' = flip runItSkipAsync

-- |
-- `Xit`
--

runXitSync     = runItSync_ "xit"
runXitOnlySync = runItSync_ "xit.only"
runXitSkipSync = runItSync_ "xit.skip"

xit      :: DoItSync
xit      = runXitSync     0
xitOnly  :: DoItSync
xitOnly  = runXitOnlySync 0
xitSkip  :: DoItSync
xitSkip  = runXitSkipSync 0

xit'     :: DoItSyncTimeout
xit'     = flip runXitSync
xitOnly' :: DoItSyncTimeout
xitOnly' = flip runXitOnlySync
xitSkip' :: DoItSyncTimeout
xitSkip' = flip runXitSkipSync

runXitAsync     = runItAsync_ "xit"
runXitOnlyAsync = runItAsync_ "xit.only"
runXitSkipAsync = runItAsync_ "xit.skip"

xitAsync      :: DoItAsync
xitAsync      = runXitAsync     0
xitOnlyAsync  :: DoItAsync
xitOnlyAsync  = runXitOnlyAsync 0
xitSkipAsync  :: DoItAsync
xitSkipAsync  = runXitSkipAsync 0

xitAsync'     :: DoItAsyncTimeout
xitAsync'     = flip runXitAsync
xitOnlyAsync' :: DoItAsyncTimeout
xitOnlyAsync' = flip runXitOnlyAsync
xitSkipAsync' :: DoItAsyncTimeout
xitSkipAsync' = flip runXitSkipAsync

-- |
-- `Describe`
--
runDesc_ n  = run n sync 0

type DoDescribe = forall eff a.
  String ->
  Eff (describe :: Describe | eff) a ->
  Eff (describe :: Describe | eff) Unit

describe     :: DoDescribe
describe     = runDesc_ "describe"
describeOnly :: DoDescribe
describeOnly = runDesc_ "describe.only"
describeSkip :: DoDescribe
describeSkip = runDesc_ "describe.skip"

-- |
-- `Xdescribe`
--
xdescribe     :: DoDescribe
xdescribe     = runDesc_ "xdescribe"
xdescribeOnly :: DoDescribe
xdescribeOnly = runDesc_ "xdescribe.only"
xdescribeSkip :: DoDescribe
xdescribeSkip = runDesc_ "xdescribe.skip"

-- |
-- Before / BeforeEach Hook
--

runBeforeSync_ n  = hook n sync
runBeforeSync     = runBeforeSync_ "before"
runBeforeEachSync = runBeforeSync_ "beforeEach"

type DoBefore = forall eff a.
  Eff eff a ->
  Eff (before :: Before | eff) Unit

before     :: DoBefore
before     = runBeforeSync 0
beforeEach :: DoBefore
beforeEach = runBeforeEachSync 0

type DoBeforeTimeout = forall eff a.
  Number ->
  Eff eff a ->
  Eff (before :: Before | eff) Unit

before'     :: DoBeforeTimeout
before'     = runBeforeSync
beforeEach' :: DoBeforeTimeout
beforeEach' = runBeforeEachSync

runBeforeAsync_ n  = hook n async
runBeforeAsync     = runBeforeAsync_ "before"
runBeforeEachAsync = runBeforeAsync_ "beforeEach"

type DoBeforeAsync = forall eff a.
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (before :: Before | eff) Unit

beforeAsync     :: DoBeforeAsync
beforeAsync     = runBeforeAsync 0
beforeEachAsync :: DoBeforeAsync
beforeEachAsync = runBeforeEachAsync 0

type DoBeforeAsyncTimeout = forall eff a.
  Number ->
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (before :: Before | eff) Unit

beforeAsync'     :: DoBeforeAsyncTimeout
beforeAsync'     = runBeforeAsync
beforeEachAsync' :: DoBeforeAsyncTimeout
beforeEachAsync' = runBeforeEachAsync

-- |
-- After / AfterEach Hook
--

runAfterSync_ n  = hook n sync
runAfterSync     = runAfterSync_ "after"
runAfterEachSync = runAfterSync_ "afterEach"

type DoAfter = forall eff a.
  Eff eff a ->
  Eff (after :: After | eff) Unit

after      :: DoAfter
after      = runAfterSync 0
afterEach  :: DoAfter
afterEach  = runAfterEachSync 0

type DoAfterTimeout = forall eff a.
  Number ->
  Eff eff a ->
  Eff (after :: After | eff) Unit

after'     :: DoAfterTimeout
after'     = runAfterSync
afterEach' :: DoAfterTimeout
afterEach' = runAfterEachSync

runAfterAsync_ :: forall eff a.
  String ->
  Number ->
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (after :: After | eff) Unit
runAfterAsync_ n = hook n async

runAfterAsync     = runAfterAsync_ "after"
runAfterEachAsync = runAfterAsync_ "afterEach"

type DoAfterAsync = forall eff a.
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (after :: After | eff) Unit

afterAsync     :: DoAfterAsync
afterAsync     = runAfterAsync 0
afterEachAsync :: DoAfterAsync
afterEachAsync = runAfterEachAsync 0

type DoAfterAsyncTimeout = forall eff a.
  Number ->
  (DoneToken -> Eff (done :: Done | eff) a) ->
  Eff (after :: After | eff) Unit

afterAsync'     :: DoAfterAsyncTimeout
afterAsync'     = runAfterAsync
afterEachAsync' :: DoAfterAsyncTimeout
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
