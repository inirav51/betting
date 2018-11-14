pragma solidity ^0.4.11;

interface account {
    function transfer(address receiver, uint amount) external;
}

contract Betting {

	address[] private addresses;
	uint[] private amount;
	uint private pot;
	uint[] private numbers;
	uint[] private winningAmount;
	address[] private winningAddress;
	uint betNumberRange;
	address [] private invitedPlayers;
	address dealer;
	uint winnerNumber;
	address[] private loserAddress;

	event betAccpeted(address gambler, uint amount);
	event rollAccpeted(address gambler, uint _number);
	
	function Betting (uint _numberRange) public {
	    dealer = msg.sender;
	    betNumberRange = _numberRange;
	}
	
    function inviteToBetting(address toPlay) public {
	   require(msg.sender==dealer);
        invitedPlayers.push(toPlay);
    }
    
	function Bet (uint _number) payable public{
	    for (uint j=0; j<invitedPlayers.length;j++) {
	        if (invitedPlayers[j] == msg.sender && msg.sender != dealer) {
	            require(_number <=betNumberRange);
    	       	pot += msg.value;
    			addresses.push(msg.sender);
                numbers.push(_number);
                amount.push(msg.value);
                
                dealer.transfer(msg.value);
    	       	
    	       emit betAccpeted(msg.sender, msg.value);
    	       emit rollAccpeted(msg.sender, _number);
	        }
	    }
	        
	    
	}

    function getRandom() private view returns (uint) {
         return uint(uint256(keccak256(block.timestamp, block.difficulty))%betNumberRange);
    }
    
	function checkingWinner () public {
	    require (msg.sender == dealer);
	    winnerNumber = getRandom();
	    for (uint i = 0; i< numbers.length; i++) {
	        if (numbers[i] == winnerNumber) {
	            winningAmount.push(amount[i]);
	            winningAddress.push(addresses[i]);
	            
	        } else (loserAddress.push (addresses[i]));
	    }
	}
	
	function distributeMoney() public {
	    require (msg.sender == dealer);
	    
	    account contract_account = account(address(this));
	    
	    
	    uint totalWinningBets;
	    for (uint i=0; i< winningAmount.length; i++) {
	        totalWinningBets += winningAmount[i];
	    }
	    for (uint j=0; j<winningAddress.length; j++) {
	        //contract_account.transfer(winningAddress[j], (winningAmount[j]/totalWinningBets)*pot);
	        winningAddress[j].transfer((winningAmount[j]/totalWinningBets)*pot);
	    }
	}
	
	
	function biggestLoser() public  returns (address){
	    require(msg.sender == dealer);
	    uint loser = amount[0];
	    uint loserPerson = 0;
	    for (uint i =1; i<amount.length;i++) {
	        if(loser < amount[i]) {
	            loser = amount[i];
	            loserPerson = i;
	        }
	        return addresses[i];
	        
	    }
	    
	    
	    
	}
	
	function winnerPlayer() public returns( address) {
	    for(uint i = 0; i<winningAddress.length ; i++) {
	         return winningAddress[i];
	    }
	   
	}
	
	function loserPlayers() public returns (address) {
	    for (uint i = 0; i<loserAddress.length; i++) {
	        return loserAddress[i];
	    }
	}
	
	
	function resetBetting () public{
	   pot = 0;
	   for (uint i = 0; i< numbers.length; i++){
	       delete numbers[i];
	       delete amount[i];
	       delete addresses[i];
	   }
	   
	   for (uint j = 0; j <winningAmount.length; j++) {
	       delete winningAmount[i];
	       delete winningAddress[i];
	   }
	   
	}
	
	function calledOffGame() public {
	    require (msg.sender == dealer);
	    for(uint i = 0; i< addresses.length; i++) {
	        addresses[i].transfer(amount[i]);
	    }
	}
	
	function killBetting()	public	{	
		if(msg.sender ==	dealer)	selfdestruct(dealer);	
}	
	
	
	
}