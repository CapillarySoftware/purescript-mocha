# Module Documentation

[![Build Status](https://travis-ci.org/CapillarySoftware/purescript-mocha.svg?branch=master)](https://travis-ci.org/CapillarySoftware/purescript-mocha)
[![Bower version](https://badge.fury.io/bo/purescript-mocha.svg)](http://badge.fury.io/bo/purescript-mocha)
[![Dependency Status](https://www.versioneye.com/user/projects/54702b8e8101067e1d00060f/badge.svg?style=flat)](https://www.versioneye.com/user/projects/54702b8e8101067e1d00060f)

## Module Test.Mocha

#### `Before`

``` purescript
data Before :: !
```


#### `Describe`

``` purescript
data Describe :: !
```


#### `It`

``` purescript
data It :: !
```


#### `After`

``` purescript
data After :: !
```


#### `Done`

``` purescript
data Done :: !
```


#### `DoIt`

``` purescript
type DoIt = forall e a. String -> Eff e a -> Eff (it :: It | e) Unit
```


#### `DoDescribe`

``` purescript
type DoDescribe = forall e a. String -> Eff (describe :: Describe | e) a -> Eff (describe :: Describe | e) Unit
```


#### `DoBefore`

``` purescript
type DoBefore = forall e a. Eff e a -> Eff (before :: Before | e) Unit
```


#### `DoAfter`

``` purescript
type DoAfter = forall e a. Eff e a -> Eff (after :: After | e) Unit
```


#### `DoneToken`

``` purescript
data DoneToken
  = DoneToken 
```


#### `describe`

``` purescript
describe :: DoDescribe
```


#### `describeOnly`

``` purescript
describeOnly :: DoDescribe
```


#### `describeSkip`

``` purescript
describeSkip :: DoDescribe
```


#### `it`

``` purescript
it :: DoIt
```


#### `itOnly`

``` purescript
itOnly :: DoIt
```


#### `itSkip`

``` purescript
itSkip :: DoIt
```


#### `itAsync`

``` purescript
itAsync :: forall a eff. String -> (DoneToken -> Eff (done :: Done | eff) a) -> Eff (it :: It | eff) Unit
```


#### `itIs`

``` purescript
itIs :: forall eff. DoneToken -> Eff (done :: Done | eff) Unit
```


#### `itIsNot`

``` purescript
itIsNot :: forall eff a. DoneToken -> Eff (done :: Done | eff) Unit
```


#### `before`

``` purescript
before :: DoBefore
```

Before Hooks

#### `beforeEach`

``` purescript
beforeEach :: DoBefore
```


#### `beforeAsync`

``` purescript
beforeAsync :: forall a eff. (DoneToken -> Eff (done :: Done | eff) a) -> Eff (it :: It | eff) Unit
```


#### `beforeEachAsync`

``` purescript
beforeEachAsync :: forall a eff. (DoneToken -> Eff (done :: Done | eff) a) -> Eff (it :: It | eff) Unit
```


#### `after`

``` purescript
after :: DoAfter
```

After Hooks

#### `afterEach`

``` purescript
afterEach :: DoAfter
```


#### `afterAsync`

``` purescript
afterAsync :: forall a eff. (DoneToken -> Eff (done :: Done | eff) a) -> Eff (it :: It | eff) Unit
```


#### `afterEachAsync`

``` purescript
afterEachAsync :: forall a eff. (DoneToken -> Eff (done :: Done | eff) a) -> Eff (it :: It | eff) Unit
```
