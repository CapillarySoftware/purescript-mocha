# This is project is dead with no active maintainer. If you want to maintain this, let me know.

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


#### `DoneToken`

``` purescript
data DoneToken
  = DoneToken 
```


#### `DoItSync`

``` purescript
type DoItSync = forall a eff. String -> Eff eff a -> Eff (it :: It | eff) Unit
```


#### `it`

``` purescript
it :: DoItSync
```


#### `itOnly`

``` purescript
itOnly :: DoItSync
```


#### `itSkip`

``` purescript
itSkip :: DoItSync
```


#### `DoItSyncTimeout`

``` purescript
type DoItSyncTimeout = forall a eff. String -> Number -> Eff eff a -> Eff (it :: It | eff) Unit
```


#### `it'`

``` purescript
it' :: DoItSyncTimeout
```


#### `itOnly'`

``` purescript
itOnly' :: DoItSyncTimeout
```


#### `itSkip'`

``` purescript
itSkip' :: DoItSyncTimeout
```


#### `DoItAsync`

``` purescript
type DoItAsync = forall a eff. String -> (DoneToken -> Eff (done :: Done | eff) a) -> Eff (it :: It | eff) Unit
```


#### `itAsync`

``` purescript
itAsync :: DoItAsync
```


#### `itOnlyAsync`

``` purescript
itOnlyAsync :: DoItAsync
```


#### `itSkipAsync`

``` purescript
itSkipAsync :: DoItAsync
```


#### `DoItAsyncTimeout`

``` purescript
type DoItAsyncTimeout = forall a eff. String -> Number -> (DoneToken -> Eff (done :: Done | eff) a) -> Eff (it :: It | eff) Unit
```


#### `itAsync'`

``` purescript
itAsync' :: DoItAsyncTimeout
```


#### `itOnlyAsync'`

``` purescript
itOnlyAsync' :: DoItAsyncTimeout
```


#### `itSkipAsync'`

``` purescript
itSkipAsync' :: DoItAsyncTimeout
```


#### `xit`

``` purescript
xit :: forall eff. String -> Eff eff Unit
```

#### `DoDescribe`

``` purescript
type DoDescribe = forall eff a. String -> Eff (describe :: Describe | eff) a -> Eff (describe :: Describe | eff) Unit
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


#### `xdescribe`

``` purescript
xdescribe :: DoDescribe
```

#### `xdescribe'`

``` purescript
xdescribe' :: forall eff. String -> Eff eff Unit
```


#### `DoBefore`

``` purescript
type DoBefore = forall eff a. Eff eff a -> Eff (before :: Before | eff) Unit
```


#### `before`

``` purescript
before :: DoBefore
```


#### `beforeEach`

``` purescript
beforeEach :: DoBefore
```


#### `DoBeforeTimeout`

``` purescript
type DoBeforeTimeout = forall eff a. Number -> Eff eff a -> Eff (before :: Before | eff) Unit
```


#### `before'`

``` purescript
before' :: DoBeforeTimeout
```


#### `beforeEach'`

``` purescript
beforeEach' :: DoBeforeTimeout
```


#### `DoBeforeAsync`

``` purescript
type DoBeforeAsync = forall eff a. (DoneToken -> Eff (done :: Done | eff) a) -> Eff (before :: Before | eff) Unit
```


#### `beforeAsync`

``` purescript
beforeAsync :: DoBeforeAsync
```


#### `beforeEachAsync`

``` purescript
beforeEachAsync :: DoBeforeAsync
```


#### `DoBeforeAsyncTimeout`

``` purescript
type DoBeforeAsyncTimeout = forall eff a. Number -> (DoneToken -> Eff (done :: Done | eff) a) -> Eff (before :: Before | eff) Unit
```


#### `beforeAsync'`

``` purescript
beforeAsync' :: DoBeforeAsyncTimeout
```


#### `beforeEachAsync'`

``` purescript
beforeEachAsync' :: DoBeforeAsyncTimeout
```


#### `DoAfter`

``` purescript
type DoAfter = forall eff a. Eff eff a -> Eff (after :: After | eff) Unit
```


#### `after`

``` purescript
after :: DoAfter
```


#### `afterEach`

``` purescript
afterEach :: DoAfter
```


#### `DoAfterTimeout`

``` purescript
type DoAfterTimeout = forall eff a. Number -> Eff eff a -> Eff (after :: After | eff) Unit
```


#### `after'`

``` purescript
after' :: DoAfterTimeout
```


#### `afterEach'`

``` purescript
afterEach' :: DoAfterTimeout
```


#### `DoAfterAsync`

``` purescript
type DoAfterAsync = forall eff a. (DoneToken -> Eff (done :: Done | eff) a) -> Eff (after :: After | eff) Unit
```


#### `afterAsync`

``` purescript
afterAsync :: DoAfterAsync
```


#### `afterEachAsync`

``` purescript
afterEachAsync :: DoAfterAsync
```


#### `DoAfterAsyncTimeout`

``` purescript
type DoAfterAsyncTimeout = forall eff a. Number -> (DoneToken -> Eff (done :: Done | eff) a) -> Eff (after :: After | eff) Unit
```


#### `afterAsync'`

``` purescript
afterAsync' :: DoAfterAsyncTimeout
```


#### `afterEachAsync'`

``` purescript
afterEachAsync' :: DoAfterAsyncTimeout
```


#### `itIs`

``` purescript
itIs :: forall eff. DoneToken -> Eff (done :: Done | eff) Unit
```

#### `itIsNot`

``` purescript
itIsNot :: forall eff a. DoneToken -> Eff (done :: Done | eff) Unit
```
