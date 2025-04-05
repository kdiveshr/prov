# divesh-api Test Module

The `test` project exists solely for the purpose
of creating the aggregate code coverage report. It may
be extended to use for integration tests as well in the future.

## Execute tests

To execute all tests in the multi-module project run `mvn clean test`. 
To run all tests with code coverage, run 
`mvn clean verify`
from the root of the project. 

### Code Coverage
The build will fail if coverage drops below 80%. 
The coverage report can be found at `<root>/test/target/site/jacoco-aggregate/index.html`

When the GitLab pipeline has been configured, [additional steps](https://cylab.be/blog/94/compute-the-code-coverage-of-your-tests-with-java-and-maven) will be required
to report on code coverage through the GitLab badges.
