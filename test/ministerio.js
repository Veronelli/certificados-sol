const Ministerio = artifacts.require("Ministerio");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Ministerio", function (/* accounts */) {
  it("should assert true", async function () {
    await Ministerio.deployed();
    return assert.isTrue(true);
  });
});
