import IC "utils/types";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Error "mo:base/Error";

actor {
  let ledger : IC.Ledger = actor "ryjl3-tyaaa-aaaaa-aaaba-cai";
  let cmc : IC.CMC = actor "rkp4c-7iaaa-aaaaa-aaaca-cai";

  public shared func mint_cycles(canisterid : Text, amount : Nat) : async IC.MintCyclesResult {
    try {
      let cmc_transfer = await ledger.icrc1_transfer({
        memo = null;
        amount = amount * 100_000_000;
        fee = null;
        from_subaccount = null;
        to = { owner = Principal.fromActor(cmc); subaccount = null };
        created_at_time = null;
      });
      switch (cmc_transfer) {
        case (#Ok(block_index)) {
          let notify_topup_result = await cmc.notify_top_up({
            block_index = Nat64.fromNat(block_index);
            canister_id = Principal.fromText(canisterid);
          });
          switch (notify_topup_result) {
            case (#Ok(cycles)) {
              return #Ok(cycles);
            };
            case (#Err(err)) {
              return #Err(#NotifyError(err));
            };
          };
        };
        case (#Err(err)) {
          return #Err(#TransferError(err));
        };
      };
    } catch (err) {
      return #Err(#NotifyError(#Other({ error_message = "Error in minting cycles" # Error.message(err); error_code = 0 })));
    };
  };
};
