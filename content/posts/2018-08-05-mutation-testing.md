---
date: "2018-08-05T00:00:00Z"
summary:  Your test coverage might be very high, but it's possible that your tests
  wouldn't notice if you deleted some code. Let's check for that automatically!
title: Mutation testing in Go
---

Now that we're done [yak shaving](/2018/08/04/ioutil-yakshave/), we can start talking about mutation testing. As an engineer at Google, I often use the Go programming language (which I really enjoy), so that is my choice for these examples; however, mutation testing is available for other languages.

### Constructing Bolson people

Let's start with an example; we have a `people` package, where a person has an age and a name. For these people to be [appropriate for our quest][from-the-ground-up], they need to be over 18, have names with at least two whitespace-separated words in them, and have those names end with *-son*. You can claim those are the strangest software project requirements you've ever had all you want, I know better.

```go
package people

import (
	"strings"
)

type person struct {
	name string
	age  int
}

func checkAge(p person) bool {
	return p.age > 18
}

func checkValidName(p person) bool {
	return len(strings.Fields(p.name)) > 1
}

func checkBolsonPolicy(p person) bool {
	return strings.HasSuffix(p.name, "son")
}

func validatePerson(p person) bool {
	return checkAge(p) && checkValidName(p) && checkBolsonPolicy(p)
}
```

Now, `validatePerson` performs the overall validation, but we've split it into smaller `check*` functions to make them simple to test independently, in case the requirements get more complicated in the future. Here are the tests:

```go
package people

import "testing"

type testSet []struct {
	person person
	want   bool
}

func runTestSet(t *testing.T, check func(person) bool, tests testSet) {
	t.Helper()
	for _, tc := range tests {
		got := check(tc.person)
		if tc.want != got {
			t.Errorf("check(%#v) = %t; want %t", tc.person, got, tc.want)
		}
	}
}

func TestCheckAge(t *testing.T) {
	runTestSet(t, checkAge, testSet{
		{person{age: 5}, false},
		{person{age: 17}, false},
		{person{age: 19}, true},
	})
}

func TestCheckValidName(t *testing.T) {
	runTestSet(t, checkValidName, testSet{
		{person{name: ""}, false},
		{person{name: "Ohad Lutzky"}, true},
		{person{name: "John J.J. Schmidt"}, true},
	})
}

func TestCheckBolsonPolicy(t *testing.T) {
	runTestSet(t, checkBolsonPolicy, testSet{
		{person{name: "Hudson"}, true},
		{person{name: "Rhondson"}, true},
		{person{name: "Eriksen"}, false},
	})
}

func TestValidPerson(t *testing.T) {
	runTestSet(t, validatePerson, testSet{
		{person{"Rito Fryson", 19}, true},
		{person{"Greyson", 20}, false},
		{person{"Zora Kapson", 15}, false},
	})
}
```

Running `go test -cover` will show us that we have 100% test coverage! Hurray! However, danger lurks. In a couple of months, a newcomer to the team will refactor `validatePerson` to add logging indicating *why* a person is considered invalid, all the tests will pass... and suddenly one "Christian Eriksen" is counted by the system as valid. How can this be? All the tests still pass, and we had 100% coverage!

### Using mutation testing

Let's see if mutation testing can help us out. I put my code in `$GOPATH/src/github.com/lutzky/people`, so I install and run `zimmski/go-mutesting`:

```shell-session
$ go get -v github.com/zimmski/go-mutesting
$ go-mutesting github.com/lutzky/people/...
PASS "/tmp/go-mutesting-036340603//home/lutzky/gopath/src/github.com/lutzky/people/people.go.0" with checksum 252162809c884e5616872b71196c90df
```

```diff
--- /home/lutzky/gopath/src/github.com/lutzky/people/people.go  2018-08-05 00:13:44.333319200 +0100
+++ /tmp/go-mutesting-036340603//home/lutzky/gopath/src/github.com/lutzky/people/people.go.1    2018-08-05 10:15:30.013388991 +0100
@@ -22,5 +22,5 @@
 }

 func validatePerson(p person) bool {
-       return checkAge(p) && checkValidName(p) && checkBolsonPolicy(p)
+       return checkAge(p) && checkValidName(p) && true
 }

```

```no-highlight
FAIL "/tmp/go-mutesting-036340603//home/lutzky/gopath/src/github.com/lutzky/people/people.go.1" with checksum 996748ab09eeca8feb3f87ecf23b8319
PASS "/tmp/go-mutesting-036340603//home/lutzky/gopath/src/github.com/lutzky/people/people.go.2" with checksum 7be514fe57e53f4d02ce1e128641333f
PASS "/tmp/go-mutesting-036340603//home/lutzky/gopath/src/github.com/lutzky/people/people.go.3" with checksum 88a83b2731fda42ae4f3ac9350191c9f
The mutation score is 0.750000 (3 passed, 1 failed, 0 duplicated, 0 skipped, total is 4)
```

What the mutation testing package does is take the test-covered code (all of `people.go`, in our case) and attempt to modify it at random, so that it will still build, but the logic will change; things like removing statements, changing conditions in `if` statements, or in this case - changing an arbitrary boolean value to `true`. If the code is correct and tested properly, any such mutated version of the code ("mutant") should not pass the tests (the tests should "kill the mutant").

In this case, it appears that modifying `checkBolsonPolicy(p)` to `true` (which is the same as just removing it and the preceding `&&`) does not cause any tests to fail. Indeed, in `TestValidPerson`, none of the test cases violate the Bolson policy! If we try adding a test case `person{"Bob Rasmussen", 15}` this mutant would still survive, as `checkAge(p)` would return false; so we have to make sure `checkBolsonPolicy` on its own is sufficient to identify this test case as invalid. Indeed, adding `person{"Bob Rasmussen", 19}` to the test cases for `TestValidPerson` gets a mutation score of 1.0, fixing our problem.

### Drawbacks

Mutation testing can sometimes be noisy. For example, if we write `validatePerson` like so:

```go
func validatePerson(p person) bool {
	result := true
	result = result && checkAge(p)
	result = result && checkValidName(p)
	result = result && checkBolsonPolicy(p)
	return result
}
```

...then the following mutant would survive:

```diff
--- bla  2021-05-09 15:57:12.242530400 +0100
+++ bla  2021-05-09 15:57:12.242530400 +0100
@@ -23,7 +23,7 @@
 func validatePerson(p person) bool {
         result := true
-        result = result && checkAge(p)
+        result = true && checkAge(p)
         result = result && checkValidName(p)
         result = result && checkBolsonPolicy(p)
```

I would treat this mutant possibility as very "meh". So much like you shouldn't necessarily fail your build if coverage is less than 100%, you probably shouldn't fail your build if the mutation score is less than 1.0, and quite likely not based on the mutation score at all. It would help if there were a way to annotate lines as "do not mutate". While zimmski/go-mutesting does support blacklisting of specific mutants, these blacklists are based on the checksum of the mutated code, which would have to be updated every time the tested code changes.

Happy testing!



[from-the-ground-up]: https://polygon.com/zelda-breath-of-the-wild-guide-walkthrough/2017/3/30/15127770/from-the-ground-up-side-quest-locations-son-characters-find-help-grante-secret-shop-merchant-hidden
