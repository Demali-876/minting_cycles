module {
  public type Account = { owner : Principal; subaccount : ?Blob };
  public type Tokens = { e8s : Nat64 };
  public type TimeStamp = { timestamp_nanos : Nat64 };
  public type TransferError = {
    #GenericError : { message : Text; error_code : Nat };
    #TemporarilyUnavailable;
    #BadBurn : { min_burn_amount : Nat };
    #Duplicate : { duplicate_of : Nat };
    #BadFee : { expected_fee : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
    #InsufficientFunds : { balance : Nat };
  };
  public type Result = { #Ok : Nat; #Err : TransferError };
  public type TransferArgs = {
    from_subaccount : ?Blob;
    to : Account;
    amount : Nat;
    fee : ?Nat;
    memo : ?Blob;
    created_at_time : ?TimeStamp;
  };
  public type Ledger = actor {
    account_identifier : shared query Account -> async Blob;
    icrc1_transfer : shared TransferArgs -> async Result;
  };
  public type Cycles = Nat;
  public type BlockIndex = Nat64;
  public type NotifyTopUpArg = {
    block_index : BlockIndex;
    canister_id : Principal;
  };
  public type NotifyError = {
    #Refunded : { block_index : ?BlockIndex; reason : Text };
    #InvalidTransaction : Text;
    #Other : { error_message : Text; error_code : Nat64 };
    #Processing;
    #TransactionTooOld : BlockIndex;
  };
  public type NotifyTopUpResult = { #Ok : Cycles; #Err : NotifyError };
  public type CMC = actor {
    notify_top_up : shared NotifyTopUpArg -> async NotifyTopUpResult;
  };
  public type MintCyclesErrorr = {
    #TransferError : TransferError;
    #NotifyError : NotifyError;
  };
  public type MintCyclesResult = { #Ok : Cycles; #Err : MintCyclesErrorr };

};
