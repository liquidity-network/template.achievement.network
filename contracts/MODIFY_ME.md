# Automated employee payments

Now we know the basics of solidity, lets try this fun example!!!

Many employees specially working in unregulated industries get paid on the
hourly basis i.e. they get paid based on the hours they work instead of
a fixed payment. In such cases, the amount they worked for is calculated at
the end of some time period like the end of a week and they get paid accordingly.

A Smart contract could be a great application in such a case with many advantages.
Firstly, the time worked by the employee can be calculated paid automatically at
the end of the day. Further, it will provide a transparent record for accounting
purposes while at the same time ensuring employees receive payment they deserve.  


{% exercise %}
In this exercise, we will try and implement such an automated payment system.
Your first task is go over the Employee data-structure and the provided functions
and function description to understand the example.

The `employees` mapping is important to the example, which can be only modified
by the `admin` (also creator of contract). Employee's should call the
`startWork` and `stopWork` functions to indicate when they start and stop
working on their shift. Finally, note that as soon as employee stopWork we
should calculate the amount due and call the provided `processPayment` function
to transfer the required funds.

> **Pro tip**: Think about who should be calling each function and check it with the `msg.sender` to verify.

Now you should try and implement `addEmployee`, `startWork` and `stopWork` functions.

{% initial %}
pragma solidity >=0.4.22 <0.6.0;
contract EmployeePay {

    struct Employee {
        uint startedWorkSince;
        uint256 amountPending;
        bool atWork;
        bool isValue;
    }

    address private admin;
    mapping(address => Employee) private employees;
    uint private constant wage = 1 wei;

    /// Create a new EmployeePay contract
    constructor() public {
        admin = msg.sender;
    }

    /// Employee starts working, record time
    function startWork() public {
    }

    /// Employee stops working, calculate hours and do payment
    function stopWork() public {
    }

    /// Adding a new employee by admin
    function addEmployee(address employee) public {
    }

    /// Removing a  employee by admin
    function removeEmployee(address employee) public {
        if (msg.sender != admin || !employees[employee].isValue) return;
        delete employees[employee];
    }

    /// Helper functions to process payments
    function processPayment(address payable employee, uint amount) private {
        if(amount >= address(this).balance){
            employee.send(amount);
        } else {
            employees[employee].amountPending += amount;
        }
    }

    function deposit(uint256 amount) payable public {
        require(msg.value == amount);
        // nothing else to do!
    }

    /// Following functions are for testing only

    function employeeExists(address employee) public view returns ( bool result ) {
        result = false;
        if (employees[employee].isValue) result = true;
    }

    function employeeAtWork(address employee) public view returns ( bool result ) {
        result = false;
        if (employees[employee].atWork) result = true;
    }

    function changeAdmin(address newAdmin) public {
        admin = newAdmin;
    }

}

{% solution %}
pragma solidity >=0.4.22 <0.6.0;
contract EmployeePay {

    struct Employee {
        uint startedWorkSince;
        uint256 amountPending;
        bool atWork;
        bool isValue;
    }

    address private admin;
    mapping(address => Employee) private employees;
    uint private constant wage = 1 wei;

    /// Create a new EmployeePay contract
    constructor() public {
        admin = msg.sender;
    }

    /// Employee starts working, record time
    function startWork() public {
        address employee = msg.sender;
        if (!employees[employee].isValue) return;
        employees[employee].atWork = true;
        employees[employee].startedWorkSince = now;
    }

    /// Employee stops working, calculate hours and do payment
    function stopWork() public {
        address payable employee = msg.sender;
        if (!employees[employee].isValue) return;
        uint timeWorked = (now - employees[employee].startedWorkSince);
        uint hoursWorked = timeWorked;
        employees[employee].atWork = false;
        processPayment(employee, hoursWorked*wage);
    }

    /// Adding a new employee by admin
    function addEmployee(address employee) public {
        if (msg.sender != admin || employees[employee].isValue) return;
        employees[employee].isValue = true;
    }

    /// Removing a  employee by admin
    function removeEmployee(address employee) public {
        if (msg.sender != admin || !employees[employee].isValue) return;
        delete employees[employee];
    }

    /// Helper functions to process payments
    function processPayment(address payable employee, uint amount) private {
        if(amount >= address(this).balance){
            employee.send(amount);
        } else {
            employees[employee].amountPending += amount;
        }
    }

    function deposit(uint256 amount) payable public {
        require(msg.value == amount);
        // nothing else to do!
    }

    /// Following functions are for testing only

    function employeeExists(address employee) public view returns ( bool result ) {
        result = false;
        if (employees[employee].isValue) result = true;
    }

    function employeeAtWork(address employee) public view returns ( bool result ) {
        result = false;
        if (employees[employee].atWork) result = true;
    }

    function changeAdmin(address newAdmin) public {
        admin = newAdmin;
    }

}

{% validation %}
pragma solidity >=0.4.0 <0.6.0;
import "./EmployeePay.sol";

contract test {

    EmployeePay employeePay;

    function addEmployeeTest () public {
        employeePay = new EmployeePay();
        Assert.equal(employeePay.employeeExists(address(this)), bool(false), "Employee not added yet");
        employeePay.addEmployee(address(this));
        Assert.equal(employeePay.employeeExists(address(this)), bool(true), "Employee not added");
    }

    function onlyAdminCanAddEmployeeTest () public {
        employeePay = new EmployeePay();
        employeePay.changeAdmin(0xf39c53207A1cec3F8dd2dA15B9aeb8340684AAFF);
        Assert.equal(employeePay.employeeExists(address(this)), bool(false), "Employee not added yet");
        employeePay.addEmployee(address(this));
        Assert.equal(employeePay.employeeExists(address(this)), bool(false), "Only admin can edd employee");
    }

    function employeeAtWorkTest () public {
        employeePay = new EmployeePay();
        employeePay.addEmployee(address(this));
        Assert.equal(employeePay.employeeAtWork(address(this)), bool(false), "Employee atWork after adding");
        employeePay.startWork();
        Assert.equal(employeePay.employeeAtWork(address(this)), bool(true), "Employee not atWork after Starting Work");
        employeePay.stopWork();
        Assert.equal(employeePay.employeeAtWork(address(this)), bool(false), "Employee atWork after Stoping Work");
    }

    function employeeAtWorkNotExistTest () public {
        employeePay = new EmployeePay();
        Assert.equal(employeePay.employeeAtWork(address(this)), bool(false), "Employee atWork after adding");
        employeePay.startWork();
        Assert.equal(employeePay.employeeAtWork(address(this)), bool(false), "Employee not exist");
    }
}

{% endexercise %}

> **HINTS**
> * extract the employee information from msg sender and update the employees struct.
> * Don't forget to call processPayment at the end of stopWork to transfer funds which are calculated by time * wage.
