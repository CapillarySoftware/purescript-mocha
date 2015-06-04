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


#### `DoneToken`

``` purescript
data DoneToken
  = DoneToken 
```


#### `itIs`

``` purescript
itIs :: forall eff. DoneToken -> Eff (done :: Done | eff) Unit
```

#### `itIsNot`

``` purescript
itIsNot :: forall eff a. DoneToken -> Eff (done :: Done | eff) Unit
```
