# Nimble

[![Build Status](https://github.com/Quick/Nimble/actions/workflows/ci-xcode.yml/badge.svg)](https://github.com/Quick/Nimble/actions/workflows/ci-xcode.yml)
[![CocoaPods](https://img.shields.io/cocoapods/v/Nimble.svg)](https://cocoapods.org/pods/Nimble)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platforms](https://img.shields.io/cocoapods/p/Nimble.svg)](https://cocoapods.org/pods/Nimble)

Use Nimble to express the expected outcomes of Swift
or Objective-C expressions. Inspired by
[Cedar](https://github.com/pivotal/cedar).

```swift
// Swift
expect(1 + 1).to(equal(2))
expect(1.2).to(beCloseTo(1.1, within: 0.1))
expect(3) > 2
expect("seahorse").to(contain("sea"))
expect(["Atlantic", "Pacific"]).toNot(contain("Mississippi"))
expect(ocean.isClean).toEventually(beTruthy())
```

# How to Use Nimble

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Some Background: Expressing Outcomes Using Assertions in XCTest](#some-background-expressing-outcomes-using-assertions-in-xctest)
- [Nimble: Expectations Using `expect(...).to`](#nimble-expectations-using-expectto)
  - [Custom Failure Messages](#custom-failure-messages)
  - [Type Safety](#type-safety)
  - [Operator Overloads](#operator-overloads)
  - [Lazily Computed Values](#lazily-computed-values)
  - [C Primitives](#c-primitives)
  - [Async/Await Support](#asyncawait-support)
    - [Async Matchers](#async-matchers)
  - [Polling Expectations](#polling-expectations)
    - [Using Polling Expectations in Async Tests](#using-polling-expectations-in-async-tests)
    - [Verifying a Matcher will Never or Always Match](#verifying-a-matcher-will-never-or-always-match)
    - [Waiting for a Callback to be Called](#waiting-for-a-callback-to-be-called)
    - [Changing the Timeout and Polling Intervals](#changing-the-timeout-and-polling-intervals)
    - [Changing default Timeout and Poll Intervals](#changing-default-timeout-and-poll-intervals)
      - [Quick](#quick)
      - [XCTest](#xctest)
  - [Objective-C Support](#objective-c-support)
  - [Disabling Objective-C Shorthand](#disabling-objective-c-shorthand)
- [Using `require` to demand that a matcher pass before continuing](#using-require-to-demand-that-a-matcher-pass-before-continuing)
  - [Polling with `require`.](#polling-with-require)
  - [Using `require` with Async expressions and Async matchers](#using-require-with-async-expressions-and-async-matchers)
  - [Using `unwrap` to replace `require(...).toNot(beNil())`](#using-unwrap-to-replace-requiretonotbenil)
  - [Throwing a Custom Error from Require](#throwing-a-custom-error-from-require)
- [Built-in Matcher Functions](#built-in-matcher-functions)
  - [Type Checking](#type-checking)
  - [Equivalence](#equivalence)
  - [Identity](#identity)
  - [Comparisons](#comparisons)
  - [Types/Classes](#typesclasses)
  - [Truthiness](#truthiness)
  - [Swift Assertions](#swift-assertions)
  - [Swift Error Handling](#swift-error-handling)
  - [Exceptions](#exceptions)
  - [Collection Membership](#collection-membership)
  - [Strings](#strings)
  - [Collection Elements](#collection-elements)
    - [Swift](#swift)
    - [Objective-C](#objective-c)
  - [Collection Count](#collection-count)
  - [Notifications](#notifications)
  - [Result](#result)
  - [Matching a value to any of a group of matchers](#matching-a-value-to-any-of-a-group-of-matchers)
  - [Custom Validation](#custom-validation)
- [Writing Your Own Matchers](#writing-your-own-matchers)
  - [MatcherResult](#matcherresult)
  - [Lazy Evaluation](#lazy-evaluation)
  - [Type Checking via Swift Generics](#type-checking-via-swift-generics)
  - [Customizing Failure Messages](#customizing-failure-messages)
    - [Basic Customization](#basic-customization)
    - [Full Customization](#full-customization)
  - [Asynchronous Matchers](#asynchronous-matchers)
  - [Supporting Objective-C](#supporting-objective-c)
    - [Properly Handling `nil` in Objective-C Matchers](#properly-handling-nil-in-objective-c-matchers)
- [Installing Nimble](#installing-nimble)
  - [Installing Nimble as a Submodule](#installing-nimble-as-a-submodule)
  - [Installing Nimble via CocoaPods](#installing-nimble-via-cocoapods)
  - [Installing Nimble via Swift Package Manager](#installing-nimble-via-swift-package-manager)
    - [Xcode](#xcode)
    - [Package.Swift](#packageswift)
  - [Using Nimble without XCTest](#using-nimble-without-xctest)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Some Background: Expressing Outcomes Using Assertions in XCTest

Apple's Xcode includes the XCTest framework, which provides
assertion macros to test whether code behaves properly.
For example, to assert that `1 + 1 = 2`, XCTest has you write:

```swift
// Swift

XCTAssertEqual(1 + 1, 2, "expected one plus one to equal two")
```

Or, in Objective-C:

```objc
// Objective-C

XCTAssertEqual(1 + 1, 2, @"expected one plus one to equal two");
```

XCTest assertions have a couple of drawbacks:

1. **Not enough macros.** There's no easy way to assert that a string
   contains a particular substring, or that a number is less than or
   equal to another.
2. **It's hard to write asynchronous tests.** XCTest forces you to write
   a lot of boilerplate code.

Nimble addresses these concerns.

# Nimble: Expectations Using `expect(...).to`

Nimble allows you to express expectations using a natural,
easily understood language:

```swift
// Swift

import Nimble

expect(seagull.squawk).to(equal("Squee!"))
```

```objc
// Objective-C

@import Nimble;

expect(seagull.squawk).to(equal(@"Squee!"));
```

> The `expect` function autocompletes to include `file:` and `line:`,
  but these parameters are optional. Use the default values to have
  Xcode highlight the correct line when an expectation is not met.

To perform the opposite expectation--to assert something is *not*
equal--use `toNot` or `notTo`:

```swift
// Swift

import Nimble

expect(seagull.squawk).toNot(equal("Oh, hello there!"))
expect(seagull.squawk).notTo(equal("Oh, hello there!"))
```

```objc
// Objective-C

@import Nimble;

expect(seagull.squawk).toNot(equal(@"Oh, hello there!"));
expect(seagull.squawk).notTo(equal(@"Oh, hello there!"));
```

## Custom Failure Messages

Would you like to add more information to the test's failure messages? Use the `description` optional argument to add your own text:

```swift
// Swift

expect(1 + 1).to(equal(3))
// failed - expected to equal <3>, got <2>

expect(1 + 1).to(equal(3), description: "Make sure libKindergartenMath is loaded")
// failed - Make sure libKindergartenMath is loaded
// expected to equal <3>, got <2>
```

Or the *WithDescription version in Objective-C:

```objc
// Objective-C

@import Nimble;

expect(@(1+1)).to(equal(@3));
// failed - expected to equal <3.0000>, got <2.0000>

expect(@(1+1)).toWithDescription(equal(@3), @"Make sure libKindergartenMath is loaded");
// failed - Make sure libKindergartenMath is loaded
// expected to equal <3.0000>, got <2.0000>
```

## Type Safety

Nimble makes sure you don't compare two types that don't match:

```swift
// Swift

// Does not compile:
expect(1 + 1).to(equal("Squee!"))
```

> Nimble uses generics--only available in Swift--to ensure
  type correctness. That means type checking is
  not available when using Nimble in Objective-C. :sob:

## Operator Overloads

Tired of so much typing? With Nimble, you can use overloaded operators
like `==` for equivalence, or `>` for comparisons:

```swift
// Swift

// Passes if squawk does not equal "Hi!":
expect(seagull.squawk) != "Hi!"

// Passes if 10 is greater than 2:
expect(10) > 2
```

> Operator overloads are only available in Swift, so you won't be able
  to use this syntax in Objective-C. :broken_heart:

## Lazily Computed Values

The `expect` function doesn't evaluate the value it's given until it's
time to match. So Nimble can test whether an expression raises an
exception once evaluated:

```swift
// Swift

// Note: Swift currently doesn't have exceptions.
//       Only Objective-C code can raise exceptions
//       that Nimble will catch.
//       (see https://github.com/Quick/Nimble/issues/220#issuecomment-172667064)
let exception = NSException(
    name: NSInternalInconsistencyException,
    reason: "Not enough fish in the sea.",
    userInfo: ["something": "is fishy"])
expect { exception.raise() }.to(raiseException())

// Also, you can customize raiseException to be more specific
expect { exception.raise() }.to(raiseException(named: NSInternalInconsistencyException))
expect { exception.raise() }.to(raiseException(
    named: NSInternalInconsistencyException,
    reason: "Not enough fish in the sea"))
expect { exception.raise() }.to(raiseException(
    named: NSInternalInconsistencyException,
    reason: "Not enough fish in the sea",
    userInfo: ["something": "is fishy"]))
```

Objective-C works the same way, but you must use the `expectAction`
macro when making an expectation on an expression that has no return
value:

```objc
// Objective-C

NSException *exception = [NSException exceptionWithName:NSInternalInconsistencyException
                                                 reason:@"Not enough fish in the sea."
                                               userInfo:nil];
expectAction(^{ [exception raise]; }).to(raiseException());

// Use the property-block syntax to be more specific.
expectAction(^{ [exception raise]; }).to(raiseException().named(NSInternalInconsistencyException));
expectAction(^{ [exception raise]; }).to(raiseException().
    named(NSInternalInconsistencyException).
    reason("Not enough fish in the sea"));
expectAction(^{ [exception raise]; }).to(raiseException().
    named(NSInternalInconsistencyException).
    reason("Not enough fish in the sea").
    userInfo(@{@"something": @"is fishy"}));

// You can also pass a block for custom matching of the raised exception
expectAction(exception.raise()).to(raiseException().satisfyingBlock(^(NSException *exception) {
    expect(exception.name).to(beginWith(NSInternalInconsistencyException));
}));
```

## C Primitives

Some testing frameworks make it hard to test primitive C values.
In Nimble, it just works:

```swift
// Swift

let actual: CInt = 1
let expectedValue: CInt = 1
expect(actual).to(equal(expectedValue))
```

In fact, Nimble uses type inference, so you can write the above
without explicitly specifying both types:

```swift
// Swift

expect(1 as CInt).to(equal(1))
```

> In Objective-C, Nimble only supports Objective-C objects. To
  make expectations on primitive C values, wrap then in an object
  literal:

```objc
expect(@(1 + 1)).to(equal(@2));
```

## Async/Await Support

Nimble makes it easy to await for an async function to complete. Simply pass
the async function in to `expect`:

```swift
// Swift
await expect { await aFunctionReturning1() }.to(equal(1))
```

The async function is awaited on first, before passing it to the matcher. This
enables the matcher to run synchronous code like before, without caring about
whether the value it's processing was abtained async or not.

Async support is Swift-only, and it requires that you execute the test in an
async context. For XCTest, this is as simple as marking your test function with
`async`. If you use Quick, all tests in Quick 6 are executed in an async context.
In Quick 7 and later, only tests that are in an `AsyncSpec` subclass will be
executed in an async context.

To avoid a compiler errors when using synchronous `expect` in asynchronous contexts,
`expect` with async expressions does not support autoclosures. However, the `expecta`
(expect async) function is provided as an alternative, which does support autoclosures.

```swift
// Swift
await expecta(await aFunctionReturning1()).to(equal(1)))
```

Similarly, if you're ever in a situation where you want to force the compiler to
produce a `SyncExpectation`, you can use the `expects` (expect sync) function to
produce a `SyncExpectation`. Like so:

```swift
// Swift
expects(someNonAsyncFunction()).to(equal(1)))

expects(await someAsyncFunction()).to(equal(1)) // Compiler error: 'async' call in an autoclosure that does not support concurrency
```

### Async Matchers

In addition to asserting on async functions prior to passing them to a
synchronous matcher, you can also write matchers that directly take in an
async value. These are called `AsyncMatcher`s. This is most obviously useful
when directly asserting against an actor. In addition to writing your own
async matchers, Nimble currently ships with async versions of the following
matchers:

- `allPass`
- `containElementSatisfying`
- `satisfyAllOf` and the `&&` operator overload accept both `AsyncMatcher` and
  synchronous `Matcher`s.
- `satisfyAnyOf` and the `||` operator overload accept both `AsyncMatcher` and
  synchronous `Matcher`s.

Note: Async/Await support is different than the `toEventually`/`toEventuallyNot`
feature described below.

## Polling Expectations

In Nimble, it's easy to make expectations on values that are updated
asynchronously. Just use `toEventually` or `toEventuallyNot`:

```swift
// Swift
DispatchQueue.main.async {
    ocean.add("dolphins")
    ocean.add("whales")
}
expect(ocean).toEventually(contain("dolphins", "whales"))
```


```objc
// Objective-C

dispatch_async(dispatch_get_main_queue(), ^{
    [ocean add:@"dolphins"];
    [ocean add:@"whales"];
});
expect(ocean).toEventually(contain(@"dolphins", @"whales"));
```

Note: toEventually triggers its polls on the main thread. Blocking the main
thread will cause Nimble to stop the run loop. This can cause test pollution
for whatever incomplete code that was running on the main thread.  Blocking the
main thread can be caused by blocking IO, calls to sleep(), deadlocks, and
synchronous IPC.

In the above example, `ocean` is constantly re-evaluated. If it ever
contains dolphins and whales, the expectation passes. If `ocean` still
doesn't contain them, even after being continuously re-evaluated for one
whole second, the expectation fails.

### Using Polling Expectations in Async Tests

You can easily use `toEventually` or `toEventuallyNot` in async contexts as
well. You only need to add an `await` statement to the beginning of the line:

```swift
// Swift
DispatchQueue.main.async {
    ocean.add("dolphins")
    ocean.add("whales")
}
await expect(ocean).toEventually(contain("dolphens", "whiles"))
```

Starting in Nimble 12,  `toEventually` et. al. now also supports async
expectations. For example, the following test is now supported:

```swift
actor MyActor {
    private var counter = 0

    func access() -> Int {
        counter += 1
        return counter
    }
}

let subject = MyActor()
await expect { await subject.access() }.toEventually(equal(2))
```

### Verifying a Matcher will Never or Always Match

You can also test that a value always or never matches throughout the length of the timeout. Use `toNever` and `toAlways` for this:

```swift
// Swift
ocean.add("dolphins")
expect(ocean).toAlways(contain("dolphins"))
expect(ocean).toNever(contain("hares"))
```

```objc
// Objective-C
[ocean add:@"dolphins"]
expect(ocean).toAlways(contain(@"dolphins"))
expect(ocean).toNever(contain(@"hares"))
```

### Waiting for a Callback to be Called

You can also provide a callback by using the `waitUntil` function:

```swift
// Swift

waitUntil { done in
    ocean.goFish { success in
        expect(success).to(beTrue())
        done()
    }
}
```

```objc
// Objective-C

waitUntil(^(void (^done)(void)){
    [ocean goFishWithHandler:^(BOOL success){
        expect(success).to(beTrue());
        done();
    }];
});
```

`waitUntil` also optionally takes a timeout parameter:

```swift
// Swift

waitUntil(timeout: .seconds(10)) { done in
    ocean.goFish { success in
        expect(success).to(beTrue())
        done()
    }
}
```

```objc
// Objective-C

waitUntilTimeout(10, ^(void (^done)(void)){
    [ocean goFishWithHandler:^(BOOL success){
        expect(success).to(beTrue());
        done();
    }];
});
```

Note: `waitUntil` triggers its timeout code on the main thread. Blocking the main
thread will cause Nimble to stop the run loop to continue. This can cause test
pollution for whatever incomplete code that was running on the main thread.
Blocking the main thread can be caused by blocking IO, calls to sleep(),
deadlocks, and synchronous IPC.

### Changing the Timeout and Polling Intervals

Sometimes it takes more than a second for a value to update. In those
cases, use the `timeout` parameter:

```swift
// Swift

// Waits three seconds for ocean to contain "starfish":
expect(ocean).toEventually(contain("starfish"), timeout: .seconds(3))

// Evaluate someValue every 0.2 seconds repeatedly until it equals 100, or fails if it timeouts after 5.5 seconds.
expect(someValue).toEventually(equal(100), timeout: .milliseconds(5500), pollInterval: .milliseconds(200))
```

```objc
// Objective-C

// Waits three seconds for ocean to contain "starfish":
expect(ocean).withTimeout(3).toEventually(contain(@"starfish"));
```

### Changing default Timeout and Poll Intervals

In some cases (e.g. when running on slower machines) it can be useful to modify
the default timeout and poll interval values. This can be done as follows:

```swift
// Swift

// Increase the global timeout to 5 seconds:
Nimble.PollingDefaults.timeout = .seconds(5)

// Slow the polling interval to 0.1 seconds:
Nimble.PollingDefaults.pollInterval = .milliseconds(100)
```

You can set these globally at test startup in two ways:

#### Quick

If you use [Quick](https://github.com/Quick/Quick), add a [`QuickConfiguration` subclass](https://github.com/Quick/Quick/blob/main/Documentation/en-us/ConfiguringQuick.md) which sets your desired `PollingDefaults`.

```swift
import Quick
import Nimble

class PollingConfiguration: QuickConfiguration {
    override class func configure(_ configuration: QCKConfiguration) {
        Nimble.PollingDefaults.timeout = .seconds(5)
        Nimble.PollingDefaults.pollInterval = .milliseconds(100)
    }
}
```

#### XCTest

If you use [XCTest](https://developer.apple.com/documentation/xctest), add an object that conforms to [`XCTestObservation`](https://developer.apple.com/documentation/xctest/xctestobservation) and implement [`testBundleWillStart(_:)`](https://developer.apple.com/documentation/xctest/xctestobservation/1500772-testbundlewillstart).

Additionally, you will need to register this observer with the [`XCTestObservationCenter`](https://developer.apple.com/documentation/xctest/xctestobservationcenter) at test startup. To do this, set the `NSPrincipalClass` key in your test bundle's Info.plist and implement a class with that same name.

For example

```xml
<!-- Info.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- ... -->
	<key>NSPrincipalClass</key>
	<string>MyTests.TestSetup</string>
</dict>
</plist>
```

```swift
// TestSetup.swift
import XCTest
import Nimble

@objc
class TestSetup: NSObject {
	override init() {
		XCTestObservationCenter.shared.register(PollingConfigurationTestObserver())
	}
}

class PollingConfigurationTestObserver: NSObject, XCTestObserver {
    func testBundleWillStart(_ testBundle: Bundle) {
        Nimble.PollingDefaults.timeout = .seconds(5)
        Nimble.PollingDefaults.pollInterval = .milliseconds(100)
    }
}
```

In Linux, you can implement `LinuxMain` to set the PollingDefaults before calling `XCTMain`.

## Objective-C Support

Nimble has full support for Objective-C. However, there are two things
to keep in mind when using Nimble in Objective-C:

1. All parameters passed to the `expect` function, as well as matcher
   functions like `equal`, must be Objective-C objects or can be converted into
   an `NSObject` equivalent:

   ```objc
   // Objective-C

   @import Nimble;

   expect(@(1 + 1)).to(equal(@2));
   expect(@"Hello world").to(contain(@"world"));

   // Boxed as NSNumber *
   expect(2).to(equal(2));
   expect(1.2).to(beLessThan(2.0));
   expect(true).to(beTruthy());

   // Boxed as NSString *
   expect("Hello world").to(equal("Hello world"));

   // Boxed as NSRange
   expect(NSMakeRange(1, 10)).to(equal(NSMakeRange(1, 10)));
   ```

2. To make an expectation on an expression that does not return a value,
   such as `-[NSException raise]`, use `expectAction` instead of
   `expect`:

   ```objc
   // Objective-C

   expectAction(^{ [exception raise]; }).to(raiseException());
   ```

The following types are currently converted to an `NSObject` type:

 - **C Numeric types** are converted to `NSNumber *`
 - `NSRange` is converted to `NSValue *`
 - `char *` is converted to `NSString *`

For the following matchers:

- `equal`
- `beGreaterThan`
- `beGreaterThanOrEqual`
- `beLessThan`
- `beLessThanOrEqual`
- `beCloseTo`
- `beTrue`
- `beFalse`
- `beTruthy`
- `beFalsy`
- `haveCount`


If you would like to see more, [file an issue](https://github.com/Quick/Nimble/issues).

## Disabling Objective-C Shorthand

Nimble provides a shorthand for expressing expectations using the
`expect` function. To disable this shorthand in Objective-C, define the
`NIMBLE_DISABLE_SHORT_SYNTAX` macro somewhere in your code before
importing Nimble:

```objc
#define NIMBLE_DISABLE_SHORT_SYNTAX 1

@import Nimble;

NMB_expect(^{ return seagull.squawk; }, __FILE__, __LINE__).to(NMB_equal(@"Squee!"));
```

> Disabling the shorthand is useful if you're testing functions with
  names that conflict with Nimble functions, such as `expect` or
  `equal`. If that's not the case, there's no point in disabling the
  shorthand.
  
# Using `require` to demand that a matcher pass before continuing

Nimble 13.1 added the `require` dsl to complement `expect`. `require`
looks similar to `expect` and works with matchers just like `expect` does. The
difference is that `require` requires that the matcher passes - if the matcher
doesn't pass, then `require` will throw an error. Additionally, if `require`
does pass, then it'll return the result of running the expression.

For example, in testing a function that returns an array, you might need to
first guarantee that there are exactly 3 items in the array before continuing
to assert on it. Instead of writing code that needlessly duplicates an assertion
and a conditional like so:

```swift
let collection = myFunction()
expect(collection).to(haveCount(3))
guard collection.count == 3 else { return }
// ...
```

You can replace that with:

```swift
let collection = try require(myFunction()).to(haveCount(3))
// ...
```

## Polling with `require`.

Because `require` does everything you can do with `expect`, you can also use
`require` to [poll matchers](#polling-expectations) using `toEventually`,
`eventuallyTo`, `toEventuallyNot`, `toNotEventually`, `toNever`, `neverTo`,
`toAlways`, and `alwaysTo`. These work exactly the same as they do when using
`expect`, except that they throw if they fail, and they return the value of the
expression when they pass.

## Using `require` with Async expressions and Async matchers

`require` also works with both async expressions
(`require { await someExpression() }.to(...)`), and async matchers
(`require().to(someAsyncMatcher())`).

Note that to prevent compiler confusion,
you cannot use `require` with async autoclosures. That is,
`require(await someExpression())` will not compile. You can instead either
make the closure explicit (`require { await someExpression() }`), or use the
`requirea` function, which does accept autoclosures.
Similarly, if you ever wish to use the sync version of `require` when the
compiler is trying to force you to use the async version, you can use the
`requires` function, which only allows synchronous expressions.

## Using `unwrap` to replace `require(...).toNot(beNil())`

It's very common to require that a value not be nil. Instead of writing
`try require(...).toNot(beNil())`, Nimble provides the `unwrap` function. This
expression throws an error if the expression evaluates to nil, or returns the
non-nil result when it passes. For example:

```swift
let value = try unwrap(nil as Int?) // throws
let value = try unwrap(1 as Int?) // returns 1
```

Additionally, there is also the `pollUnwrap` function, which aliases to
`require(...).toEventuallyNot(beNil())`. This is extremely useful for verifying
that a value that is updated on a background thread was eventually set to a
non-nil value.

Note: As with `require`, there are `unwraps`, `unwrapa`, `pollUnwraps`, and
`pollUnwrapa` variants for allowing you to use autoclosures specifically with
synchronous or asynchronous code.

## Throwing a Custom Error from Require

By default, if the matcher fails in a `require`, then a `RequireError` will be
thrown. You can override this behavior and throw a custom error by passing a
non-nil `Error` value to the `customError` parameter:

```swift
try require(1).to(equal(2)) // throws a `RequireError`
try require(customError: MyCustomError(), 1).to(equal(2)) // throws a `MyCustomError`
```

# Built-in Matcher Functions

Nimble includes a wide variety of matcher functions.

## Type Checking

Nimble supports checking the type membership of any kind of object, whether
Objective-C conformant or not:

```swift
// Swift

protocol SomeProtocol{}
class SomeClassConformingToProtocol: SomeProtocol{}
struct SomeStructConformingToProtocol: SomeProtocol{}

// The following tests pass
expect(1).to(beAKindOf(Int.self))
expect("turtle").to(beAKindOf(String.self))

let classObject = SomeClassConformingToProtocol()
expect(classObject).to(beAKindOf(SomeProtocol.self))
expect(classObject).to(beAKindOf(SomeClassConformingToProtocol.self))
expect(classObject).toNot(beAKindOf(SomeStructConformingToProtocol.self))

let structObject = SomeStructConformingToProtocol()
expect(structObject).to(beAKindOf(SomeProtocol.self))
expect(structObject).to(beAKindOf(SomeStructConformingToProtocol.self))
expect(structObject).toNot(beAKindOf(SomeClassConformingToProtocol.self))
```

```objc
// Objective-C

// The following tests pass
NSMutableArray *array = [NSMutableArray array];
expect(array).to(beAKindOf([NSArray class]));
expect(@1).toNot(beAKindOf([NSNull class]));
```

Objects can be tested for their exact types using the `beAnInstanceOf` matcher:

```swift
// Swift

protocol SomeProtocol{}
class SomeClassConformingToProtocol: SomeProtocol{}
struct SomeStructConformingToProtocol: SomeProtocol{}

// Unlike the 'beKindOf' matcher, the 'beAnInstanceOf' matcher only
// passes if the object is the EXACT type requested. The following
// tests pass -- note its behavior when working in an inheritance hierarchy.
expect(1).to(beAnInstanceOf(Int.self))
expect("turtle").to(beAnInstanceOf(String.self))

let classObject = SomeClassConformingToProtocol()
expect(classObject).toNot(beAnInstanceOf(SomeProtocol.self))
expect(classObject).to(beAnInstanceOf(SomeClassConformingToProtocol.self))
expect(classObject).toNot(beAnInstanceOf(SomeStructConformingToProtocol.self))

let structObject = SomeStructConformingToProtocol()
expect(structObject).toNot(beAnInstanceOf(SomeProtocol.self))
expect(structObject).to(beAnInstanceOf(SomeStructConformingToProtocol.self))
expect(structObject).toNot(beAnInstanceOf(SomeClassConformingToProtocol.self))
```

## Equivalence

```swift
// Swift

// Passes if 'actual' is equivalent to 'expected':
expect(actual).to(equal(expected))
expect(actual) == expected

// Passes if 'actual' is not equivalent to 'expected':
expect(actual).toNot(equal(expected))
expect(actual) != expected
```

```objc
// Objective-C

// Passes if 'actual' is equivalent to 'expected':
expect(actual).to(equal(expected))

// Passes if 'actual' is not equivalent to 'expected':
expect(actual).toNot(equal(expected))
```

Values must be `Equatable`, `Comparable`, or subclasses of `NSObject`.
`equal` will always fail when used to compare one or more `nil` values.

## Identity

```swift
// Swift

// Passes if 'actual' has the same pointer address as 'expected':
expect(actual).to(beIdenticalTo(expected))
expect(actual) === expected

// Passes if 'actual' does not have the same pointer address as 'expected':
expect(actual).toNot(beIdenticalTo(expected))
expect(actual) !== expected
```

It is important to remember that `beIdenticalTo` only makes sense when comparing
types with reference semantics, which have a notion of identity. In Swift, 
that means types that are defined as a `class`. 

This matcher will not work when comparing types with value semantics such as
those defined as a `struct` or `enum`. If you need to compare two value types,
consider what it means for instances of your type to be identical. This may mean
comparing individual properties or, if it makes sense to do so, conforming your type 
to `Equatable` and using Nimble's equivalence matchers instead.


```objc
// Objective-C

// Passes if 'actual' has the same pointer address as 'expected':
expect(actual).to(beIdenticalTo(expected));

// Passes if 'actual' does not have the same pointer address as 'expected':
expect(actual).toNot(beIdenticalTo(expected));
```

## Comparisons

```swift
// Swift

expect(actual).to(beLessThan(expected))
expect(actual) < expected

expect(actual).to(beLessThanOrEqualTo(expected))
expect(actual) <= expected

expect(actual).to(beGreaterThan(expected))
expect(actual) > expected

expect(actual).to(beGreaterThanOrEqualTo(expected))
expect(actual) >= expected
```

```objc
// Objective-C

expect(actual).to(beLessThan(expected));
expect(actual).to(beLessThanOrEqualTo(expected));
expect(actual).to(beGreaterThan(expected));
expect(actual).to(beGreaterThanOrEqualTo(expected));
```

> Values given to the comparison matchers above must implement
  `Comparable`.

Because of how computers represent floating point numbers, assertions
that two floating point numbers be equal will sometimes fail. To express
that two numbers should be close to one another within a certain margin
of error, use `beCloseTo`:

```swift
// Swift

expect(actual).to(beCloseTo(expected, within: delta))
```

```objc
// Objective-C

expect(actual).to(beCloseTo(expected).within(delta));
```

For example, to assert that `10.01` is close to `10`, you can write:

```swift
// Swift

expect(10.01).to(beCloseTo(10, within: 0.1))
```

```objc
// Objective-C

expect(@(10.01)).to(beCloseTo(@10).within(0.1));
```

There is also an operator shortcut available in Swift:

```swift
// Swift

expect(actual) ≈ expected
expect(actual) ≈ (expected, delta)

```
(Type <kbd>option</kbd>+<kbd>x</kbd> to get `≈` on a U.S. keyboard)

The former version uses the default delta of 0.0001. Here is yet another way to do this:

```swift
// Swift

expect(actual) ≈ expected ± delta
expect(actual) == expected ± delta

```
(Type <kbd>option</kbd>+<kbd>shift</kbd>+<kbd>=</kbd> to get `±` on a U.S. keyboard)

If you are comparing arrays of floating point numbers, you'll find the following useful:

```swift
// Swift

expect([0.0, 2.0]) ≈ [0.0001, 2.0001]
expect([0.0, 2.0]).to(beCloseTo([0.1, 2.1], within: 0.1))

```

> Values given to the `beCloseTo` matcher must conform to `FloatingPoint`.

## Types/Classes

```swift
// Swift

// Passes if 'instance' is an instance of 'aClass':
expect(instance).to(beAnInstanceOf(aClass))

// Passes if 'instance' is an instance of 'aClass' or any of its subclasses:
expect(instance).to(beAKindOf(aClass))
```

```objc
// Objective-C

// Passes if 'instance' is an instance of 'aClass':
expect(instance).to(beAnInstanceOf(aClass));

// Passes if 'instance' is an instance of 'aClass' or any of its subclasses:
expect(instance).to(beAKindOf(aClass));
```

> Instances must be Objective-C objects: subclasses of `NSObject`,
  or Swift objects bridged to Objective-C with the `@objc` prefix.

For example, to assert that `dolphin` is a kind of `Mammal`:

```swift
// Swift

expect(dolphin).to(beAKindOf(Mammal))
```

```objc
// Objective-C

expect(dolphin).to(beAKindOf([Mammal class]));
```

> `beAnInstanceOf` uses the `-[NSObject isMemberOfClass:]` method to
  test membership. `beAKindOf` uses `-[NSObject isKindOfClass:]`.

## Truthiness

```swift
// Passes if 'actual' is not nil, true, or an object with a boolean value of true:
expect(actual).to(beTruthy())

// Passes if 'actual' is only true (not nil or an object conforming to Boolean true):
expect(actual).to(beTrue())

// Passes if 'actual' is nil, false, or an object with a boolean value of false:
expect(actual).to(beFalsy())

// Passes if 'actual' is only false (not nil or an object conforming to Boolean false):
expect(actual).to(beFalse())

// Passes if 'actual' is nil:
expect(actual).to(beNil())
```

```objc
// Objective-C

// Passes if 'actual' is not nil, true, or an object with a boolean value of true:
expect(actual).to(beTruthy());

// Passes if 'actual' is only true (not nil or an object conforming to Boolean true):
expect(actual).to(beTrue());

// Passes if 'actual' is nil, false, or an object with a boolean value of false:
expect(actual).to(beFalsy());

// Passes if 'actual' is only false (not nil or an object conforming to Boolean false):
expect(actual).to(beFalse());

// Passes if 'actual' is nil:
expect(actual).to(beNil());
```

## Swift Assertions

If you're using Swift, you can use the `throwAssertion` matcher to check if an assertion is thrown (e.g. `fatalError()`). This is made possible by [@mattgallagher](https://github.com/mattgallagher)'s [CwlPreconditionTesting](https://github.com/mattgallagher/CwlPreconditionTesting) library.

```swift
// Swift

// Passes if 'somethingThatThrows()' throws an assertion, 
// such as by calling 'fatalError()' or if a precondition fails:
expect { try somethingThatThrows() }.to(throwAssertion())
expect { () -> Void in fatalError() }.to(throwAssertion())
expect { precondition(false) }.to(throwAssertion())

// Passes if throwing an NSError is not equal to throwing an assertion:
expect { throw NSError(domain: "test", code: 0, userInfo: nil) }.toNot(throwAssertion())

// Passes if the code after the precondition check is not run:
var reachedPoint1 = false
var reachedPoint2 = false
expect {
    reachedPoint1 = true
    precondition(false, "condition message")
    reachedPoint2 = true
}.to(throwAssertion())

expect(reachedPoint1) == true
expect(reachedPoint2) == false
```

Notes:

* This feature is only available in Swift.
* The tvOS simulator is supported, but using a different mechanism, requiring you to turn off the `Debug executable` scheme setting for your tvOS scheme's Test configuration.

## Swift Error Handling

You can use the `throwError` matcher to check if an error is thrown.

```swift
// Swift

// Passes if 'somethingThatThrows()' throws an 'Error':
expect { try somethingThatThrows() }.to(throwError())

// Passes if 'somethingThatThrows()' throws an error within a particular domain:
expect { try somethingThatThrows() }.to(throwError { (error: Error) in
    expect(error._domain).to(equal(NSCocoaErrorDomain))
})

// Passes if 'somethingThatThrows()' throws a particular error enum case:
expect { try somethingThatThrows() }.to(throwError(NSCocoaError.PropertyListReadCorruptError))

// Passes if 'somethingThatThrows()' throws an error of a particular type:
expect { try somethingThatThrows() }.to(throwError(errorType: NimbleError.self))
```

When working directly with `Error` values, using the `matchError` matcher
allows you to perform certain checks on the error itself without having to
explicitly cast the error.

The `matchError` matcher allows you to check whether or not the error:

- is the same _type_ of error you are expecting.
- represents a particular error value that you are expecting.

This can be useful when using `Result` or `Promise` types, for example.

```swift
// Swift

let actual: Error = ...

// Passes if 'actual' represents any error value from the NimbleErrorEnum type:
expect(actual).to(matchError(NimbleErrorEnum.self))

// Passes if 'actual' represents the case 'timeout' from the NimbleErrorEnum type:
expect(actual).to(matchError(NimbleErrorEnum.timeout))

// Passes if 'actual' contains an NSError equal to the one provided:
expect(actual).to(matchError(NSError(domain: "err", code: 123, userInfo: nil)))
```

Note: This feature is only available in Swift.

## Exceptions

```swift
// Swift

// Passes if 'actual', when evaluated, raises an exception:
expect(actual).to(raiseException())

// Passes if 'actual' raises an exception with the given name:
expect(actual).to(raiseException(named: name))

// Passes if 'actual' raises an exception with the given name and reason:
expect(actual).to(raiseException(named: name, reason: reason))

// Passes if 'actual' raises an exception which passes expectations defined in the given closure:
// (in this case, if the exception's name begins with "a r")
expect { exception.raise() }.to(raiseException { (exception: NSException) in
    expect(exception.name).to(beginWith("a r"))
})
```

```objc
// Objective-C

// Passes if 'actual', when evaluated, raises an exception:
expect(actual).to(raiseException())

// Passes if 'actual' raises an exception with the given name
expect(actual).to(raiseException().named(name))

// Passes if 'actual' raises an exception with the given name and reason:
expect(actual).to(raiseException().named(name).reason(reason))

// Passes if 'actual' raises an exception and it passes expectations defined in the given block:
// (in this case, if name begins with "a r")
expect(actual).to(raiseException().satisfyingBlock(^(NSException *exception) {
    expect(exception.name).to(beginWith(@"a r"));
}));
```

Note: Swift currently doesn't have exceptions (see [#220](https://github.com/Quick/Nimble/issues/220#issuecomment-172667064)). 
Only Objective-C code can raise exceptions that Nimble will catch.

## Collection Membership

```swift
// Swift

// Passes if all of the expected values are members of 'actual':
expect(actual).to(contain(expected...))

// Passes if 'actual' is empty (i.e. it contains no elements):
expect(actual).to(beEmpty())
```

```objc
// Objective-C

// Passes if expected is a member of 'actual':
expect(actual).to(contain(expected));

// Passes if 'actual' is empty (i.e. it contains no elements):
expect(actual).to(beEmpty());
```

> In Swift `contain` takes any number of arguments. The expectation
  passes if all of them are members of the collection. In Objective-C,
  `contain` only takes one argument [for now](https://github.com/Quick/Nimble/issues/27).

For example, to assert that a list of sea creature names contains
"dolphin" and "starfish":

```swift
// Swift

expect(["whale", "dolphin", "starfish"]).to(contain("dolphin", "starfish"))
```

```objc
// Objective-C

expect(@[@"whale", @"dolphin", @"starfish"]).to(contain(@"dolphin"));
expect(@[@"whale", @"dolphin", @"starfish"]).to(contain(@"starfish"));
```

> `contain` and `beEmpty` expect collections to be instances of
  `NSArray`, `NSSet`, or a Swift collection composed of `Equatable` elements.

To test whether a set of elements is present at the beginning or end of
an ordered collection, use `beginWith` and `endWith`:

```swift
// Swift

// Passes if the elements in expected appear at the beginning of 'actual':
expect(actual).to(beginWith(expected...))

// Passes if the the elements in expected come at the end of 'actual':
expect(actual).to(endWith(expected...))
```

```objc
// Objective-C

// Passes if the elements in expected appear at the beginning of 'actual':
expect(actual).to(beginWith(expected));

// Passes if the the elements in expected come at the end of 'actual':
expect(actual).to(endWith(expected));
```

> `beginWith` and `endWith` expect collections to be instances of
  `NSArray`, or ordered Swift collections composed of `Equatable`
  elements.

  Like `contain`, in Objective-C `beginWith` and `endWith` only support
  a single argument [for now](https://github.com/Quick/Nimble/issues/27).

For code that returns collections of complex objects without a strict
ordering, there is the `containElementSatisfying` matcher:

```swift
// Swift

struct Turtle {
    let color: String
}

let turtles: [Turtle] = functionThatReturnsSomeTurtlesInAnyOrder()

// This set of matchers passes regardless of whether the array is 
// [{color: "blue"}, {color: "green"}] or [{color: "green"}, {color: "blue"}]:

expect(turtles).to(containElementSatisfying({ turtle in
    return turtle.color == "green"
}))
expect(turtles).to(containElementSatisfying({ turtle in
    return turtle.color == "blue"
}, "that is a turtle with color 'blue'"))

// The second matcher will incorporate the provided string in the error message
// should it fail
```

Note: in Swift, `containElementSatisfying` also has a variant that takes in an
async function.

```objc
// Objective-C

@interface Turtle : NSObject
@property (nonatomic, readonly, nonnull) NSString *color;
@end

@implementation Turtle 
@end

NSArray<Turtle *> * __nonnull turtles = functionThatReturnsSomeTurtlesInAnyOrder();

// This set of matchers passes regardless of whether the array is 
// [{color: "blue"}, {color: "green"}] or [{color: "green"}, {color: "blue"}]:

expect(turtles).to(containElementSatisfying(^BOOL(id __nonnull object) {
    return [[turtle color] isEqualToString:@"green"];
}));
expect(turtles).to(containElementSatisfying(^BOOL(id __nonnull object) {
    return [[turtle color] isEqualToString:@"blue"];
}));
```

For asserting on if the given `Comparable` value is inside of a `Range`, use the `beWithin` matcher.

```swift
// Swift

// Passes if 5 is within the range 1 through 10, inclusive
expect(5).to(beWithin(1...10))

// Passes if 5 is not within the range 2 through 4.
expect(5).toNot(beWithin(2..<5))
```

## Strings

```swift
// Swift

// Passes if 'actual' contains 'substring':
expect(actual).to(contain(substring))

// Passes if 'actual' begins with 'prefix':
expect(actual).to(beginWith(prefix))

// Passes if 'actual' ends with 'suffix':
expect(actual).to(endWith(suffix))

// Passes if 'actual' represents the empty string, "":
expect(actual).to(beEmpty())

// Passes if 'actual' matches the regular expression defined in 'expected':
expect(actual).to(match(expected))
```

```objc
// Objective-C

// Passes if 'actual' contains 'substring':
expect(actual).to(contain(expected));

// Passes if 'actual' begins with 'prefix':
expect(actual).to(beginWith(prefix));

// Passes if 'actual' ends with 'suffix':
expect(actual).to(endWith(suffix));

// Passes if 'actual' represents the empty string, "":
expect(actual).to(beEmpty());

// Passes if 'actual' matches the regular expression defined in 'expected':
expect(actual).to(match(expected))
```

## Collection Elements

Nimble provides a means to check that all elements of a collection pass a given expectation.

### Swift

In Swift, the collection must be an instance of a type conforming to
`Sequence`.

```swift
// Swift

// Providing a custom function:
expect([1, 2, 3, 4]).to(allPass { $0 < 5 })

// Composing the expectation with another matcher:
expect([1, 2, 3, 4]).to(allPass(beLessThan(5)))
```

There are also variants of `allPass` that check against async matchers, and
that take in async functions:

```swift
// Swift

// Providing a custom function:
expect([1, 2, 3, 4]).to(allPass { await asyncFunctionReturningBool($0) })

// Composing the expectation with another matcher:
expect([1, 2, 3, 4]).to(allPass(someAsyncMatcher()))
```

### Objective-C

In Objective-C, the collection must be an instance of a type which implements
the `NSFastEnumeration` protocol, and whose elements are instances of a type
which subclasses `NSObject`.

Additionally, unlike in Swift, there is no override to specify a custom
matcher function.

```objc
// Objective-C

expect(@[@1, @2, @3, @4]).to(allPass(beLessThan(@5)));
```

## Collection Count

```swift
// Swift

// Passes if 'actual' contains the 'expected' number of elements:
expect(actual).to(haveCount(expected))

// Passes if 'actual' does _not_ contain the 'expected' number of elements:
expect(actual).notTo(haveCount(expected))
```

```objc
// Objective-C

// Passes if 'actual' contains the 'expected' number of elements:
expect(actual).to(haveCount(expected))

// Passes if 'actual' does _not_ contain the 'expected' number of elements:
expect(actual).notTo(haveCount(expected))
```

For Swift, the actual value must be an instance of a type conforming to `Collection`.
For example, instances of `Array`, `Dictionary`, or `Set`.

For Objective-C, the actual value must be one of the following classes, or their subclasses:

 - `NSArray`,
 - `NSDictionary`,
 - `NSSet`, or
 - `NSHashTable`.

## Notifications

```swift
// Swift
let testNotification = Notification(name: Notification.Name("Foo"), object: nil)

// Passes if the closure in expect { ... } posts a notification to the default
// notification center.
expect {
    NotificationCenter.default.post(testNotification)
}.to(postNotifications(equal([testNotification])))

// Passes if the closure in expect { ... } posts a notification to a given
// notification center
let notificationCenter = NotificationCenter()
expect {
    notificationCenter.post(testNotification)
}.to(postNotifications(equal([testNotification]), from: notificationCenter))

// Passes if the closure in expect { ... } posts a notification with the provided names to a given
// notification center. Make sure to use this when running tests on Catalina, 
// using DistributedNotificationCenter as there is currently no way 
// of observing notifications without providing specific names.
let distributedNotificationCenter = DistributedNotificationCenter()
expect {
    distributedNotificationCenter.post(testNotification)
}.toEventually(postDistributedNotifications(equal([testNotification]),
                                  from: distributedNotificationCenter,
                                  names: [testNotification.name]))
```

> This matcher is only available in Swift.

## Result

```swift
// Swift
let aResult: Result<String, Error> = .success("Hooray") 

// passes if result is .success
expect(aResult).to(beSuccess()) 

// passes if result value is .success and validates Success value
expect(aResult).to(beSuccess { value in
    expect(value).to(equal("Hooray"))
})


enum AnError: Error {
    case somethingHappened
}
let otherResult: Result<String, AnError> = .failure(.somethingHappened) 

// passes if result is .failure
expect(otherResult).to(beFailure()) 

// passes if result value is .failure and validates error
expect(otherResult).to(beFailure { error in
    expect(error).to(matchError(AnError.somethingHappened))
}) 
```

> This matcher is only available in Swift.

## Matching a value to any of a group of matchers

```swift
// Swift

// passes if actual is either less than 10 or greater than 20
expect(actual).to(satisfyAnyOf(beLessThan(10), beGreaterThan(20)))

// can include any number of matchers -- the following will pass
// **be careful** -- too many matchers can be the sign of an unfocused test
expect(6).to(satisfyAnyOf(equal(2), equal(3), equal(4), equal(5), equal(6), equal(7)))

// in Swift you also have the option to use the || operator to achieve a similar function
expect(82).to(beLessThan(50) || beGreaterThan(80))
```

Note: In swift, you can mix and match synchronous and asynchronous matchers
using by `satisfyAnyOf`/`||`.

```objc
// Objective-C

// passes if actual is either less than 10 or greater than 20
expect(actual).to(satisfyAnyOf(beLessThan(@10), beGreaterThan(@20)))

// can include any number of matchers -- the following will pass
// **be careful** -- too many matchers can be the sign of an unfocused test
expect(@6).to(satisfyAnyOf(equal(@2), equal(@3), equal(@4), equal(@5), equal(@6), equal(@7)))
```

Note: This matcher allows you to chain any number of matchers together. This provides flexibility,
      but if you find yourself chaining many matchers together in one test, consider whether you
      could instead refactor that single test into multiple, more precisely focused tests for
      better coverage.

## Custom Validation

```swift
// Swift

// passes if .succeeded is returned from the closure
expect {
    guard case .enumCaseWithAssociatedValueThatIDontCareAbout = actual else {
        return .failed(reason: "wrong enum case")
    }

    return .succeeded
}.to(succeed())

// passes if .failed is returned from the closure
expect {
    guard case .enumCaseWithAssociatedValueThatIDontCareAbout = actual else {
        return .failed(reason: "wrong enum case")
    }

    return .succeeded
}.notTo(succeed())
```

The `String` provided with `.failed()` is shown when the test fails.

When using `toEventually()` be careful not to make state changes or run process intensive code since this closure will be ran many times.

# Writing Your Own Matchers

In Nimble, matchers are Swift functions that take an expected
value and return a `Matcher` closure. Take `equal`, for example:

```swift
// Swift

public func equal<T: Equatable>(expectedValue: T?) -> Matcher<T> {
    // Can be shortened to:
    //   Matcher { actual in  ... }
    //
    // But shown with types here for clarity.
    return Matcher { (actualExpression: Expression<T>) throws -> MatcherResult in
        let msg = ExpectationMessage.expectedActualValueTo("equal <\(expectedValue)>")
        if let actualValue = try actualExpression.evaluate() {
            return MatcherResult(
                bool: actualValue == expectedValue!,
                message: msg
            )
        } else {
            return MatcherResult(
                status: .fail,
                message: msg.appendedBeNilHint()
            )
        }
    }
}
```

The return value of a `Matcher` closure is a `MatcherResult` that indicates
whether the actual value matches the expectation and what error message to
display on failure.

> The actual `equal` matcher function does not match when
  `expected` are nil; the example above has been edited for brevity.

Since matchers are just Swift functions, you can define them anywhere:
at the top of your test file, in a file shared by all of your tests, or
in an Xcode project you distribute to others.

> If you write a matcher you think everyone can use, consider adding it
  to Nimble's built-in set of matchers by sending a pull request! Or
  distribute it yourself via GitHub.

For examples of how to write your own matchers, just check out the
[`Matchers` directory](https://github.com/Quick/Nimble/tree/main/Sources/Nimble/Matchers)
to see how Nimble's built-in set of matchers are implemented. You can
also check out the tips below.

## MatcherResult

`MatcherResult` is the return struct that `Matcher` return to indicate
success and failure. A `MatcherResult` is made up of two values:
`MatcherStatus` and `ExpectationMessage`.

Instead of a boolean, `MatcherStatus` captures a trinary set of values:

```swift
// Swift

public enum MatcherStatus {
// The matcher "passes" with the given expression
// eg - expect(1).to(equal(1))
case matches

// The matcher "fails" with the given expression
// eg - expect(1).toNot(equal(1))
case doesNotMatch

// The matcher never "passes" with the given expression, even if negated
// eg - expect(nil as Int?).toNot(equal(1))
case fail

// ...
}
```

Meanwhile, `ExpectationMessage` provides messaging semantics for error reporting.

```swift
// Swift

public indirect enum ExpectationMessage {
// Emits standard error message:
// eg - "expected to <string>, got <actual>"
case expectedActualValueTo(/* message: */ String)

// Allows any free-form message
// eg - "<string>"
case fail(/* message: */ String)

// ...
}
```

Matchers should usually depend on either `.expectedActualValueTo(..)` or
`.fail(..)` when reporting errors. Special cases can be used for the other enum
cases.

Finally, if your Matcher utilizes other Matchers, you can utilize
`.appended(details:)` and `.appended(message:)` methods to annotate an existing
error with more details.

A common message to append is failing on nils. For that, `.appendedBeNilHint()`
can be used.

## Lazy Evaluation

`actualExpression` is a lazy, memoized closure around the value provided to the
`expect` function. The expression can either be a closure or a value directly
passed to `expect(...)`. In order to determine whether that value matches,
custom matchers should call `actualExpression.evaluate()`:

```swift
// Swift

public func beNil<T>() -> Matcher<T> {
    // Matcher.simpleNilable(..) automatically generates ExpectationMessage for
    // us based on the string we provide to it. Also, the 'Nilable' postfix indicates
    // that this Matcher supports matching against nil actualExpressions, instead of
    // always resulting in a MatcherStatus.fail result -- which is true for
    // Matcher.simple(..)
    return Matcher.simpleNilable("be nil") { actualExpression in
        let actualValue = try actualExpression.evaluate()
        return MatcherStatus(bool: actualValue == nil)
    }
}
```

In the above example, `actualExpression` is not `nil` -- it is a closure
that returns a value. The value it returns, which is accessed via the
`evaluate()` method, may be `nil`. If that value is `nil`, the `beNil`
matcher function returns `true`, indicating that the expectation passed.

## Type Checking via Swift Generics

Using Swift's generics, matchers can constrain the type of the actual value
passed to the `expect` function by modifying the return type.

For example, the following matcher, `haveDescription`, only accepts actual
values that implement the `Printable` protocol. It checks their `description`
against the one provided to the matcher function, and passes if they are the same:

```swift
// Swift

public func haveDescription(description: String) -> Matcher<Printable?> {
    return Matcher.simple("have description") { actual in
        return MatcherStatus(bool: actual.evaluate().description == description)
    }
}
```

## Customizing Failure Messages

When using `Matcher.simple(..)` or `Matcher.simpleNilable(..)`, Nimble
outputs the following failure message when an expectation fails:

```swift
// where `message` is the first string argument and
// `actual` is the actual value received in `expect(..)`
"expected to \(message), got <\(actual)>"
```

You can customize this message by modifying the way you create a `Matcher`.

### Basic Customization

For slightly more complex error messaging, receive the created failure message
with `Matcher.define(..)`:

```swift
// Swift

public func equal<T: Equatable>(_ expectedValue: T?) -> Matcher<T> {
    return Matcher.define("equal <\(stringify(expectedValue))>") { actualExpression, msg in
        let actualValue = try actualExpression.evaluate()
        let matches = actualValue == expectedValue && expectedValue != nil
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil && actualValue != nil {
                return MatcherResult(
                    status: .fail,
                    message: msg.appendedBeNilHint()
                )
            }
            return MatcherResult(status: .fail, message: msg)
        }
        return MatcherResult(bool: matches, message: msg)
    }
}
```

In the example above, `msg` is defined based on the string given to
`Matcher.define`. The code looks akin to:

```swift
// Swift

let msg = ExpectationMessage.expectedActualValueTo("equal <\(stringify(expectedValue))>")
```

### Full Customization

To fully customize the behavior of the Matcher, use the overload that expects
a `MatcherResult` to be returned.

Along with `MatcherResult`, there are other `ExpectationMessage` enum values you can use:

```swift
public indirect enum ExpectationMessage {
// Emits standard error message:
// eg - "expected to <message>, got <actual>"
case expectedActualValueTo(/* message: */ String)

// Allows any free-form message
// eg - "<message>"
case fail(/* message: */ String)

// Emits standard error message with a custom actual value instead of the default.
// eg - "expected to <message>, got <actual>"
case expectedCustomValueTo(/* message: */ String, /* actual: */ String)

// Emits standard error message without mentioning the actual value
// eg - "expected to <message>"
case expectedTo(/* message: */ String)

// ...
}
```

For matchers that compose other matchers, there are a handful of helper
functions to annotate messages.

`appended(message: String)` is used to append to the original failure message:

```swift
// produces "expected to be true, got <actual> (use beFalse() for inverse)"
// appended message do show up inline in Xcode.
.expectedActualValueTo("be true").appended(message: " (use beFalse() for inverse)")
```

For a more comprehensive message that spans multiple lines, use
`appended(details: String)` instead:

```swift
// produces "expected to be true, got <actual>\n\nuse beFalse() for inverse\nor use beNil()"
// details do not show inline in Xcode, but do show up in test logs.
.expectedActualValueTo("be true").appended(details: "use beFalse() for inverse\nor use beNil()")
```

## Asynchronous Matchers

To write matchers against async expressions, return an instance of
`AsyncMatcher`. The closure passed to `AsyncMatcher` is async, and the
expression you evaluate is also asynchronous and needs to be awaited on.

```swift
// Swift

actor CallRecorder<Arguments> {
    private(set) var calls: [Arguments] = []
    
    func record(call: Arguments) {
        calls.append(call)
    }
}

func beCalled<Argument: Equatable>(with arguments: Argument) -> AsyncMatcher<CallRecorder<Argument>> {
    AsyncMatcher { (expression: AsyncExpression<CallRecorder<Argument>>) in
        let message = ExpectationMessage.expectedActualValueTo("be called with \(arguments)")
        guard let calls = try await expression.evaluate()?.calls else {
            return MatcherResult(status: .fail, message: message.appendedBeNilHint())
        }
        
        return MatcherResult(bool: calls.contains(args), message: message.appended(details: "called with \(calls)"))
    }
}
```

In this example, we created an actor to act as an object to record calls to an
async function. Then, we created the `beCalled(with:)` matcher to check if the
actor has received a call with the given arguments.

## Supporting Objective-C

To use a custom matcher written in Swift from Objective-C, you'll have
to extend the `NMBMatcher` class, adding a new class method for your
custom matcher. The example below defines the class method
`+[NMBMatcher beNilMatcher]`:

```swift
// Swift

extension NMBMatcher {
    @objc public class func beNilMatcher() -> NMBMatcher {
        return NMBMatcher { actualExpression in
            return try beNil().satisfies(actualExpression).toObjectiveC()
        }
    }
}
```

The above allows you to use the matcher from Objective-C:

```objc
// Objective-C

expect(actual).to([NMBMatcher beNilMatcher]());
```

To make the syntax easier to use, define a C function that calls the
class method:

```objc
// Objective-C

FOUNDATION_EXPORT NMBMatcher *beNil() {
    return [NMBMatcher beNilMatcher];
}
```

### Properly Handling `nil` in Objective-C Matchers

When supporting Objective-C, make sure you handle `nil` appropriately.
Like [Cedar](https://github.com/pivotal/cedar/issues/100),
**most matchers do not match with nil**. This is to bring prevent test
writers from being surprised by `nil` values where they did not expect
them.

Nimble provides the `beNil` matcher function for test writer that want
to make expectations on `nil` objects:

```objc
// Objective-C

expect(nil).to(equal(nil)); // fails
expect(nil).to(beNil());    // passes
```

If your matcher does not want to match with nil, you use `Matcher.define` or `Matcher.simple`. 
Using those factory methods will automatically generate expected value failure messages when they're nil.

```swift
public func beginWith<S: Sequence>(_ startingElement: S.Element) -> Matcher<S> where S.Element: Equatable {
    return Matcher.simple("begin with <\(startingElement)>") { actualExpression in
        guard let actualValue = try actualExpression.evaluate() else { return .fail }

        var actualGenerator = actualValue.makeIterator()
        return MatcherStatus(bool: actualGenerator.next() == startingElement)
    }
}

extension NMBMatcher {
    @objc public class func beginWithMatcher(_ expected: Any) -> NMBMatcher {
        return NMBMatcher { actualExpression in
            let actual = try actualExpression.evaluate()
            let expr = actualExpression.cast { $0 as? NMBOrderedCollection }
            return try beginWith(expected).satisfies(expr).toObjectiveC()
        }
    }
}
```

# Installing Nimble

> Nimble can be used on its own, or in conjunction with its sister
  project, [Quick](https://github.com/Quick/Quick). To install both
  Quick and Nimble, follow [the installation instructions in the Quick
  Documentation](https://github.com/Quick/Quick/blob/main/Documentation/en-us/InstallingQuick.md).

Nimble can currently be installed in one of two ways: using CocoaPods, or with
git submodules.

## Installing Nimble as a Submodule

To use Nimble as a submodule to test your macOS, iOS or tvOS applications, follow
these 4 easy steps:

1. Clone the Nimble repository
2. Add Nimble.xcodeproj to the Xcode workspace for your project
3. Link Nimble.framework to your test target
4. Start writing expectations!

For more detailed instructions on each of these steps,
read [How to Install Quick](https://github.com/Quick/Quick#how-to-install-quick).
Ignore the steps involving adding Quick to your project in order to
install just Nimble.

## Installing Nimble via CocoaPods

To use Nimble in CocoaPods to test your macOS, iOS, tvOS or watchOS applications, add
Nimble to your podfile and add the ```use_frameworks!``` line to enable Swift
support for CocoaPods.

```ruby
platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'

# Whatever pods you need for your app go here

target 'YOUR_APP_NAME_HERE_Tests', :exclusive => true do
  use_frameworks!
  pod 'Nimble'
end
```

Finally run `pod install`.

## Installing Nimble via Swift Package Manager

### Xcode

To install Nimble via Xcode's Swift Package Manager Integration:
Select your project configuration, then the project tab, then the Package
Dependencies tab. Click on the "plus" button at the bottom of the list,
then follow the wizard to add Quick to your project. Specify
`https://github.com/Quick/Nimble.git` as the url, and be sure to add
Nimble as a dependency of your unit test target, not your app target.

### Package.Swift

To use Nimble with Swift Package Manager to test your applications, add Nimble
to your `Package.Swift` and link it with your test target:

```swift
// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MyAwesomeLibrary",
    products: [
        // ...
    ],
    dependencies: [
        // ...
        .package(url:  "https://github.com/Quick/Nimble.git", from: "12.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyAwesomeLibrary",
            dependencies: ...),
        .testTarget(
            name: "MyAwesomeLibraryTests",
            dependencies: ["MyAwesomeLibrary", "Nimble"]),
    ]
)
```

Please note that if you install Nimble using Swift Package Manager, then `raiseException` is not available.

## Using Nimble without XCTest

Nimble is integrated with XCTest to allow it work well when used in Xcode test
bundles, however it can also be used in a standalone app. After installing
Nimble using one of the above methods, there are two additional steps required
to make this work.

1. Create a custom assertion handler and assign an instance of it to the
   global `NimbleAssertionHandler` variable. For example:

```swift
class MyAssertionHandler : AssertionHandler {
    func assert(assertion: Bool, message: FailureMessage, location: SourceLocation) {
        if (!assertion) {
            print("Expectation failed: \(message.stringValue)")
        }
    }
}
```
```swift
// Somewhere before you use any assertions
NimbleAssertionHandler = MyAssertionHandler()
```

2. Add a post-build action to fix an issue with the Swift XCTest support
   library being unnecessarily copied into your app
  * Edit your scheme in Xcode, and navigate to Build -> Post-actions
  * Click the "+" icon and select "New Run Script Action"
  * Open the "Provide build settings from" dropdown and select your target
  * Enter the following script contents:
```
rm "${SWIFT_STDLIB_TOOL_DESTINATION_DIR}/libswiftXCTest.dylib"
```

You can now use Nimble assertions in your code and handle failures as you see
fit.
