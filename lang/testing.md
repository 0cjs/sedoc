Generic Notes on Software Testing
=================================

Test Object Terminology
-----------------------

The terminology here comes from Gerard Meszaros' _[XUnit Test
Patterns][xunit-pat]_ via Martin Fowler's [Mocks Aren't
Stubs][fowler-mocks].

* __SUT__: "System Under Test" or the thing you're focused on testing.
  (In unit testing, usually a function or perhaps a class.)
* __collaborator__: Something involved in the tests that's not part of
  the _SUT_.
* __test double__: An object used for testing purposes in place of
  the "real" object. Particular types include:
  * __dummy__ objects passed around but never used.
  * __fake__ objects with working implementations but not usable
    in production (due to shortcuts, e.g., an in-memory database)
  * __stubs__ programmed just for the test(s), e.g. providing canned
    answers.
  * __spies__ are _stubs_ that record information about how they were called.
  * __mocks__ are pre-programmed with expectations about the calls they
    should receive.
* __state verification__: Determining correctness by examining the state
  of a _SUT_ and its _collaborators_ after exercising code.
* __behaviour verification__: Determining correctness by tracking what
  the exercising code did during its run.

##### 'Classical' vs. 'Mockist'

[fowler-mocks] discusses in detail the 'classical' vs. 'mockist' TDD
styles. Mainly:

* Classical tends toward using real objects for collaborators where
  possible, maybe stubbing others. The test collaborators can get
  complex, generating [object mother]s ([om-paper]). Tests being
  sometimes mini-integration tests, bugs can cause ripple failures.
* Mockest tends toward generating minimal collaborators on the fly for
  each test.



[fowler-mocks]: https://martinfowler.com/articles/mocksArentStubs.html
[xunit-pat]: http://xunitpatterns.com/
[object mother]: https://martinfowler.com/bliki/ObjectMother.html
[om-paper]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.18.4710&rep=rep1&type=pdf
