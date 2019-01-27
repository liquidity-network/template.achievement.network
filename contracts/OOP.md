# Contract Composition

Contract composition refers to the the process of combining multiple contracts to create complex data structures.

Solidity supports composition, and it allows for contracts to be created using object-oriented techniques.

## Encapsulation
Encapsulation refers to varying how exposed a contract's fields are.

In solidity there are 4 visibility/access modifiers:

``external``:  Accessible from anywhere, can only be called internally using ``this``

``public``:  Accessible from inside and outside the contract

``internal``: Only accessible from within the contract without ``this``

``private``: As internal but cannot be accessed by derived contracts 

Note that the ``this`` keyword is used to reference the current contract

### Exercise
```solidity
contract Square {
    uint public size = 2;
    
    function area() public returns (uint) {
        return size * size;
    }
}
```

{% exercise %}
We have seen how to declare variables and functions. Modify the ``size`` field so that it is only accessible within the contract. Then add a publc getter method called ``getSize`` to return this field.

{% initial %}
contract Square {
    // Modify the visibility
    uint public size = 2;
    
    // Implement a getter method here

    function area() public returns (uint) {
        return size * size;
    }
}

{% solution %}
contract Square {
    // Modify the visibility
    uint private size = 2;
    
    // Implement a getter method here
    function getSize() public returns (uint) {
        return size;
    }

    function area() public returns (uint) {
        return size * size;
    }
}
{% endexercise %}

## Abstract Contracts
Abstract constracts are contracts that contain function definitions without any implementation. They are most commonly used to construct interfaces, which contain only definitions. 

### Exercise
```solidity
pragma solidity ^0.4.24;
// Abstract class for a shape
contract Shape {
    function area() public returns (uint);
    function perimeter() public returns (uint);
}

// The 'is' keyword is used to inherit from an Abstract Class
contract Square is Shape {
    uint private size = 2;

    function area() public returns (uint) {
        return size * size;
    }

    function perimeter() public returns (uint) {
        return size * 4;
    }
}


{% exercise %}
Define a new contract, ``Rectangle`` that inherits from shape as the ``Square`` contract does above and implement the necessary functions.

{% initial %}
// Abstract class for a shape
contract Shape {
    function area() public returns (uint);
    function perimeter() public returns (uint);
}

// The 'is' keyword is used to inherit from an Abstract Class
contract Square is Shape {
    uint private size = 2;

    function area() public returns (uint) {
        return size * size;
    }

    function perimeter() public returns (uint) {
        return size * 4;
    }
}

// Implement the Rectangle contract, use shortLen and longLen for side lengths.

{% solution %}
// Abstract class for a shape
contract Shape {
    function area() public returns (uint);
    function perimeter() public returns (uint);
}

// The 'is' keyword is used to inherit from an Abstract Class
contract Square is Shape {
    uint private size = 2;

    function area() public returns (uint) {
        return size * size;
    }

    function perimeter() public returns (uint) {
        return size * 4;
    }
}

// Implement the Rectangle contract, use shortLen=2 and longLen=4 for side lengths.
contract Rectangle is Shape {
    uint private shortLen = 2;
    uint private longLen = 4;

    function area() public returns (uint) {
        return shortLen * longLen;
    }

    function perimeter() public returns (uint) {
        return (2 * shortLen) + (2 * longLen);
    }
}
{% endexercise %}

## Function Polymorphism
Function polymorphism allows for the declaration of multiple functions using the same name. This allows the function to be evaluated differently.


### Exercise
```solidity
pragma solidity ^0.4.24;
// Abstract class for a shape
contract Shape {
    function area() public returns (uint);
    function area(uint scale) public returns (uint); // Returns area * scale
}

contract Square is Shape {
    uint private size = 2;

}


{% exercise %}
Implement the contract Square given the definitions in the Interface.

{% initial %}
// Abstract class for a shape
contract Shape {
    function area() public returns (uint);
    function area(uint scale) public returns (uint); // Returns area * scale
}

contract Square is Shape {
    uint private size = 2;

    // Implement functions here
}


{% solution %}
// Abstract class for a shape
contract Shape {
    function area() public returns (uint);
    function area(uint scale) public returns (uint); // Returns area * scale
}

contract Square is Shape {
    uint private size = 2;

    // Implement functions here
    function area() public returns (uint) {
        return size * size;
    }

    function area(uint scale) public returns (uint) {
        return size * size * scale
    }
}
{% endexercise %}

You now have the building blocks for programming in solidity using an object-oriented approach.
