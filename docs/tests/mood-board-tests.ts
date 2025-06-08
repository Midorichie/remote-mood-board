import { Clarinet, Tx, Chain, Account } from "@hirosystems/clarinet";

describe("mood-board contract tests", () => {
  Clarinet.test("add and get moods", async (chain: Chain, accounts: Map<string, Account>) => {
    const deployer = accounts.get("deployer")!;
    let block = chain.mineBlock([
      Tx.contractCall("remote-mood-board", "add-mood", [
        types.ascii("Happy coding!"), types.some(types.ascii("bafy...") )
      ], deployer.address)
    ]);
    block.receipts[0].result.expectOk().expectBool(true);

    block = chain.mineBlock([
      Tx.contractCall("remote-mood-board", "get-moods", [], deployer.address)
    ]);
    block.receipts[0].result.expectOk().expectListLength(1);
  });
});
