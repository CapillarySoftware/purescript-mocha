module Test.Mocha
  ( Describe(..), DoDescribe(..)
  , It(..), DoIt(..)
  , itIs, itIsNot, Done(..), DoneToken(..)
  , it, itAsync, itSkip, itOnly
  , describe, describeSkip, describeOnly
  , before, beforeEach, Before(..)
  , after, afterEach, After(..)) where

import Control.Monad.Eff

foreign import globalEnv
  "var globalEnv = typeof window === 'undefined' ? global : window"
  :: forall a. a

foreign import data Describe :: !
type DoDescribe = forall e a.
  String -> Eff e a -> Eff (describe :: Describe | e) Unit

foreign import describe
  """function(description) {
    return function(fn) {
      return function() {
        globalEnv.describe(description, fn);
      }
    }
  }""" :: DoDescribe

foreign import describeOnly
  """function(description) {
    return function(fn) {
      return function() {
        globalEnv.describe.only(description, fn);
      }
    }
  }""" :: DoDescribe

foreign import describeSkip
  """function(description) {
    return function(fn) {
      return function() {
        globalEnv.describe.skip(description, fn);
      }
    }
  }""" :: DoDescribe

foreign import data It :: !
type DoIt = forall e a. String -> Eff e a -> Eff (it :: It | e) Unit

foreign import it
  """function it(description) {
    return function(fn) {
      return function() {
        globalEnv.it(description, fn);
      }
    }
  }""" :: DoIt

foreign import itOnly
  """function itOnly(description) {
    return function(fn) {
      return function() {
        globalEnv.it.only(description, fn);
      }
    }
  }""" :: DoIt

foreign import itSkip
  """function itSkip(description) {
    return function(fn) {
      return function() {
        globalEnv.it.skip(description, fn);
      }
    }
  }""" :: DoIt

foreign import data Done :: !
data DoneToken = DoneToken

foreign import itAsync
  """function itAsync(d) {
      return function (fn) {
         return function(){
           return globalEnv.it(d, function(done){
             return fn(done)();
           });
         };
      };
  }""" :: forall a eff.
         String ->
         (DoneToken -> Eff (done :: Done | eff) a) ->
         Eff (it :: It | eff) Unit

foreign import itIs
  "function itIs(d){ return function(){d();} }" :: forall eff.
                                       DoneToken ->
                                       Eff (done :: Done | eff) Unit

foreign import itIsNot
  "function itIsNot(d){ return function(){}; }" :: forall eff.
                                       DoneToken ->
                                       Eff (done :: Done | eff) Unit


    --- HOOKS


foreign import data Before :: !

foreign import before
  """function before(fn) {
    return function() {
      globalEnv.before(fn);
    }
  }
  """ :: forall e a. Eff e a -> Eff (before :: Before | e) Unit

foreign import beforeEach
  """function beforeEach(fn) {
    return function() {
      globalEnv.beforeEach(fn);
    }
  }
  """ :: forall e a. Eff e a -> Eff (before :: Before | e) Unit

foreign import data After :: !

foreign import after
  """function after(fn) {
    return function() {
      globalEnv.after(fn);
    }
  }
  """ :: forall e a. Eff e a -> Eff (after :: After | e) Unit

foreign import afterEach
  """function afterEach(fn) {
    return function() {
      globalEnv.afterEach(fn);
    }
  }
  """ :: forall e a. Eff e a -> Eff (after :: After | e) Unit

