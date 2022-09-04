// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.9.0;

contract EventOrganizer{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }
    mapping (uint=>Event) public events;
    mapping (address=>mapping (uint=>uint)) public tickets;
    uint public nextID;

    function createEvent(string memory name,uint date,uint price,uint ticketCount)external {
        require(date>block.timestamp,"You can organize event future date");
        require(ticketCount>0,"You can organize event only if you can create more than 0 tickets");
        events[nextID] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextID++;
    }
    function buyTicket(uint id,uint quantity)external  payable  {
        require(events[id].date != 0,"This event does not exist");
        require(block.timestamp<events[id].date,"Event has already occured");
        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity) , "Ether is not enough");
        require(_event.ticketRemaining >=quantity,"Not enough tickets");
        _event.ticketRemaining -= quantity;
        tickets[msg.sender][id] +=quantity;
    }
    function transferTickets(uint id,uint quantity,address to)external {
        require(events[id].date != 0,"This event does not exist");
        require(block.timestamp<events[id].date,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id] -= quantity;
        tickets[to][id]+=quantity;
    }
}