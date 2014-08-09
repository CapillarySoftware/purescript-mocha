# Module Documentation
[![Build Status](https://travis-ci.org/CapillarySoftware/purescript-mocha.svg?branch=master)](https://travis-ci.org/CapillarySoftware/purescript-mocha)

## Module Test.Mocha

### Types

    data After :: !

    data Before :: !

    data Describe :: !

    type DoDescribe  = forall e a. String -> Eff e a -> Eff (describe :: Describe | e) Unit

    type DoIt  = forall e a. String -> Eff e a -> Eff (it :: It | e) Unit

    data Done :: !

    data DoneToken where
      DoneToken :: DoneToken

    data It :: !


### Values

    after :: forall e a. Eff e a -> Eff (after :: After | e) Unit

    afterEach :: forall e a. Eff e a -> Eff (after :: After | e) Unit

    before :: forall e a. Eff e a -> Eff (before :: Before | e) Unit

    beforeEach :: forall e a. Eff e a -> Eff (before :: Before | e) Unit

    describe :: DoDescribe

    describeOnly :: DoDescribe

    describeSkip :: DoDescribe

    it :: DoIt

    itAsync :: forall a eff. String -> (DoneToken -> Eff (done :: Done | eff) a) -> Eff (it :: It | eff) Unit

    itIs :: forall eff. DoneToken -> Eff (done :: Done | eff) Unit

    itIsNot :: forall eff. DoneToken -> Eff (done :: Done | eff) Unit

    itOnly :: DoIt

    itSkip :: DoIt