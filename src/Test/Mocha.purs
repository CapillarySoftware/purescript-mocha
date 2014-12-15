module Test.Mocha
  ( Describe(..), DoDescribe(..)
  , It(..), DoIt(..)
  , itIs, itIsNot, Done(..), DoneToken(..)
  , it, itAsync, itSkip, itOnly
  , describe, describeSkip, describeOnly
  , before, beforeEach, Before(..)
  , after, afterEach, After(..)) where

import Control.Monad.Eff
import Context

foreign import data Describe :: !
type DoDescribe = forall e a.
  String -> Eff e a -> Eff (describe :: Describe | e) Unit

describe :: DoDescribe
describe = getContext >>= method2Eff "describe"

foreign import describeOnly
  """function describeOnly(description) {
    return function(fn) {
      return function() {
        getContext().describe.only(description, fn);
      }
    }
  }""" :: DoDescribe

foreign import describeSkip
  """function describeSkip(description) {
    return function(fn) {
      return function() {
        getContext().describe.skip(description, fn);
      }
    }
  }""" :: DoDescribe

foreign import data It :: !
type DoIt = forall e a. String -> Eff e a -> Eff (it :: It | e) Unit

it :: DoIt
it = getContext >>= method2Eff "it"

foreign import itOnly
  """function itOnly(description) {
    return function(fn) {
      return function() {
        getContext().it.only(description, fn);
      }
    }
  }""" :: DoIt

foreign import itSkip
  """function itSkip(description) {
    return function(fn) {
      return function() {
        getContext().it.skip(description, fn);
      }
    }
  }""" :: DoIt

foreign import data Done :: !
data DoneToken = DoneToken

foreign import itAsync
  """function itAsync(d) {
      return function (fn) {
         return function(){
           return getContext().it(d, function(done){
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

before :: forall e a. Eff e a -> Eff (before :: Before | e) Unit
before = getContext >>= method1Eff "before"

beforeEach :: forall e a. Eff e a -> Eff (before :: Before | e) Unit
beforeEach = getContext >>= method1Eff "beforeEach"



foreign import data After :: !

after :: forall e a. Eff e a -> Eff (after :: After | e) Unit
after = getContext >>= method1Eff "after"

afterEach :: forall e a. Eff e a -> Eff (after :: After | e) Unit
afterEach = getContext >>= method1Eff "afterEach"

