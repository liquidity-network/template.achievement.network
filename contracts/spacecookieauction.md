# CookieToken Auction

The popularity of SpaceCookie is out of control! To take advantage of this, SpaceCookie has decided to make its very own `CookieToken` (which looks quite similar to the `SpaceCryptFactory` contract you made [earlier](https://achievement.network/4Types/final.html)).

These tokens have been selling like hotcakes (hotcookies?) so SpaceCookie wants to auction them off to its fans to earn as much as possible. In this exercise, we're going to make a `CookieTokenAuction` contract which handles these auctions.

## Auction

While SpaceCookie loves its fans, they can be an untrustworthy bunch sometimes so SpaceCookie wants to make sure that nobody can interfere with how the auction runs.

This means that SpaceCookie wants its fans to pay their bid in ether upfront. Otherwise they could disappear after winning the auction without paying, forcing SpaceCookie to rerun the auction. Bidders then need some way to recollect their ether if they have been outbid.

## CookieToken

While SpaceCookie's fans love SpaceCookie, they don't entirely trust it either. If they're going to buy these `CookieTokens`, they need to be sure that SpaceCookie can't walk away with their ether without sending the tokens.

`CookieToken` is a token which implements the `ERC20` standard. SpaceCookie can transfer these to the `CookieTokenAuction` contract much like regular ether so that `CookieTokenAuction` can automatically send them to the auction winner and the bidders know that SpaceCookie can't walk away without transfering the CookieTokens.

## Writing the contract

{% exercise %}
Fill in the blanks to complete the CookieTokenAuction contract.

{% hints %}
- If you're not sure, check out how a [ERC20 token](https://theethereum.wiki/w/index.php/ERC20_Token_Standard) works. This will be useful when writing methods to start and end the auction.
- Use `require()` and modifiers to ensure the auction behaves correctly.
- If bidders pay upfront they need a way to refund offers which have been outbidded. Be careful keeping track of who has paid what and make sure the highest bidder can't withdraw their bid!
- Make sure that bidders can't make the auction refund the same money multiple times!

{% initial %}
pragma solidity ^0.4.24;

contract CookieTokenAuction {
    // Note: Ideally I would prefer to have a timed length of the auction.
    // This seems to cause some issues with testing even if we gave it a short duration.
    // It probably makes more sense to allow the contract owner to terminate the auction at will.
    uint public auctionDuration = 7 days;

    address public seller = msg.sender;

    // Note: Looks like achievement network doesn't support passing arguments
    // to constructors when the user deploys a contract.
    // This address could be hardcoded.
    address cookieToken;

    address public highestBidder;
    uint public highestBid = 0;
    mapping(address => uint) refunds;

    bool public started = false;

    constructor(address token) public {
        cookieToken = token
    }

    // Make sure only the seller can interact with a method
    modifier sellerOnly() {
    }

    // Check that the auction is open for bidding.
    modifier auctionStarted(){
    }

    // Start the auction
    // We want to make sure that the auction has a token which it can release
    function start() {
    }

    // Make a bid on the CookieToken.
    // Remember we want bidders to pay upfront
    function bid() public {
    }

    // Refund an outbidded bidder's ether
    function refund() public {
    }

    // Send SpaceCookie its earnings and tokens to the highest bidder
    function endAuction() public {
    }

}

{% solution %}
pragma solidity ^0.4.24;

contract CookieTokenAuction {
  uint public auctionDuration = 7 days;
  address public seller = msg.sender;
  address cookieToken;

  address public highestBidder;
  uint public highestBid = 0;
  mapping(address => uint) refunds;

  bool public started = false;

  constructor(address token) public {
      cookieToken = token
  }

  // Start the auction
  // We want to make sure that the auction has a token to be sold
  function start() sellerOnly {
    // Make sure the SpaceCookie has transfered tokens to the auction
    ERC20 token = ERC20(cookieToken);
    require(token.balanceOf(address(this)) > 0);
    auctionEnd = now + auctionDuration;
    started = true;
  }

  // Make sure only the seller can interact with a method
  modifier sellerOnly() {
    require(msg.sender == owner);
    _;
  }

  modifier auctionStarted(){
    require(started);
    _;
  }

  // Make a bid on the item on sale.
  function bid() public payable auctionStarted {
    require(now <= auctionEnd);
    require(msg.value > highestBid);

    // We want to allow the previous highest bidder to withdraw the ether of their bid
    if (highestBid > 0) {
      refunds[highestBidder] += highestBid;
    }

    highestBidder = msg.sender;
    highestBid = msg.value;
  }

  function refund() public {
    uint refundAmount = refunds[msg.sender];
    if (refundAmount > 0){

      // We have to make sure to set the balance to zero before we send any Ether.
      // Otherwise the contract is open to what is known as a "reentrancy attack".
      refunds[msg.sender] = 0
      msg.sender.send(refundAmount);
    }
  }

  // We can allow anyone to trigger the end of the auction after it expires
  // Alternatively we could introduce additional logic
  // and only allow the highest bidder or SpaceCookie to call this method.
  function endAuction() public ended {
    require(now > auctionEnd);

    // Send the CookieToken seller their payment
    seller.send(highestBid);

    // Send CookieTokens to the highest bidder
    ERC20 token = ERC20(cookieToken);
    token.transfer(highestBidder, balanceOf(address(this)));
  }

}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'CookieTokenAuction.sol';
import 'ERC20.sol';

contract TestAuction {

  // For testing I would create a token contract on the Achievement.network blockchain
  // A number of tokens can be automatically transferred to the user much like Ether
  // The address of the token contract can be hardcoded below
  ERC20 token = ERC20("token address")

  // A slight difficulty is in making sure they are transferred
  // to the CookieTokenAuction and this contract automatically as they are deployed.

  CookieTokenAuction auction = CookieTokenAuction(__ADDRESS__);

  function testStart() public {
    token.transfer(__ADDRESS__, 1);
    auction.start()
    Assert.equal(auction.started, true, "Auction couldn't start")
  }

  function testOffer() public {

    uint bid = 1;
    auction.bid().value(1);
    Assert.equal(auction.highestBid, 1, "Auction should track the highest bid");
  }

  function testRefund() public {
    uint myFirstBalance = address(this).balance;
    auction.bid().value(2)
    uint mySecondBalance = address(this).balance;
    auction.bid().value(10)
    uint myThirdBalance = address(this).balance;
    auction.refund()
    uint myFourthBalance = address(this).balance;

    Assert.isAbove(myFirstBalance, mySecondBalance, "Amount should be sent to contract");
    Assert.isAbove(myThirdBalance, mySecondBalance, "Amount should be sent to contract");
    Assert.isAbove(myFourthBalance, myThirdBalance, "Original bid should be refunded");
  }

  function testPayment() public {
    uint beforeBalance = token.balanceOf(address(this))

    // Need to make sure auction has expired before calling this
    auction.endAuction()

    uint afterBalance = token.balanceOf(address(this))

    Assert.isAbove(afterBalance, beforeBalance, "Token should be sent to auction winner")
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

## Going Further

This implementation works pretty well but it isn't perfect.

* There's no reserve on the sale price of a CookieToken which SpaceCookie wants to sell above.
* Everyone can see what bids have been made on the CookieToken by inspecting the blockchain. Maybe SpaceCookie wants everyone to bid blindly.

Try subclassing this contract to implement these!
