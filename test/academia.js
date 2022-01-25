const Academia = artifacts.require("Academia");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Academia", function (/* accounts */) {
  it("should assert true", async function () {
    await Academia.deployed();
    return assert.isTrue(true);
  });
});
