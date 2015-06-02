module Test.Mocha
  ( Describe(..), DoDescribe(..), DoBefore(..), DoAfter(..)
  , It(..), DoIt(..)
  , itIs, itIsNot, Done(..), DoneToken(..)
  , it, itAsync, itSkip, itOnly
  , describe, describeSkip, describeOnly
  , before, beforeEach, beforeAsync, beforeEachAsync, Before(..)
  , after, afterEach, afterAsync, afterEachAsync, After(..)
  ) where

import Control.Monad.Eff
import Data.Foreign.OOFFI
import Context

foreign import data Before :: !
foreign import data Describe :: !
foreign import data It :: !
foreign import data After :: !
foreign import data Done :: !

type DoIt = forall e a.
  String ->
  Eff e a ->
  Eff (it :: It | e) Unit

type DoDescribe = forall e a.
  String ->
  Eff (describe :: Describe | e) a ->
  Eff (describe :: Describe | e) Unit

type DoBefore = forall e a.
  Eff e a ->
  Eff (before :: Before | e) Unit

type DoAfter = forall e a.
  Eff e a ->
  Eff (after :: After | e) Unit

data DoneToken = DoneToken

describe :: DoDescribe
describe = method2EffC "describe"

foreign import describeOnly
  """function describeOnly(description) {
      return function(fn) {
        return function() {
          PS.Context.getContext().describe.only(description, fn);
        }
      }
  }""" :: DoDescribe

foreign import describeSkip
  """function describeSkip(description) {
      return function(fn) {
        return function() {
          PS.Context.getContext().describe.skip(description, fn);
        }
      }
  }""" :: DoDescribe

it :: DoIt
it = method2EffC "it"

foreign import itOnly
  """function itOnly(description) {
      return function(fn) {
        return function() {
          PS.Context.getContext().it.only(description, fn);
        }
      }
  }""" :: DoIt

foreign import itSkip
  """function itSkip(description) {
      return function(fn) {
        return function() {
          PS.Context.getContext().it.skip(description, fn);
        }
      }
  }""" :: DoIt

foreign import itAsync
  """function itAsync(description) {
      return function (fn) {
        return function() {
          return PS.Context.getContext().it(description, function(done) {
            return fn(done)();
          });
        };
      };
  }""" :: forall a eff.
          String ->
          (DoneToken -> Eff (done :: Done | eff) a) ->
          Eff (it :: It | eff) Unit

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
      return function(reason) {
        return function() {
          done(reason);
        };
      };
  }""" :: forall eff a.
          DoneToken ->
          a ->
          Eff (done :: Done | eff) Unit

-- | Before Hooks

before :: DoBefore
before = method1EffC "before"

beforeEach :: DoBefore
beforeEach = method1EffC "beforeEach"

foreign import beforeAsync
  """function beforeAsync(fn) {
      return function() {
        PS.Context.getContext().before(function(done) {
          return fn(done)();
        });
      };
  }""" :: forall a eff.
          (DoneToken -> Eff (done :: Done | eff) a) ->
          Eff (it :: It | eff) Unit

foreign import beforeEachAsync
  """function beforeEachAsync(fn) {
      return function() {
        PS.Context.getContext().beforeEach(function(done) {
          return fn(done)();
        });
      };
  }""" :: forall a eff.
          (DoneToken -> Eff (done :: Done | eff) a) ->
          Eff (it :: It | eff) Unit

-- | After Hooks

after :: DoAfter
after = method1EffC "after"

afterEach :: DoAfter
afterEach = method1EffC "afterEach"

foreign import afterAsync
  """function afterAsync(fn) {
      return function() {
        PS.Context.getContext().after(function(done) {
          return fn(done)();
        });
      };
  }""" :: forall a eff.
          (DoneToken -> Eff (done :: Done | eff) a) ->
          Eff (it :: It | eff) Unit

foreign import afterEachAsync
  """function afterEachAsync(fn) {
      return function() {
        PS.Context.getContext().afterEach(function(done) {
          return fn(done)();
        });
      };
  }""" :: forall a eff.
          (DoneToken -> Eff (done :: Done | eff) a) ->
          Eff (it :: It | eff) Unit
