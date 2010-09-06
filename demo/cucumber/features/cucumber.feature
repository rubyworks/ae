Feature: Cucumber SUpport
  In order to please people who like Cucumber
  As an AE user
  I want to be able to use assert in my step definitions

  Scenario: assert
    Given x = 5
    And y = 5
    Then I can assert that x.assert == y

