{% exercise %}
# QuickSort

## About QuickSort
QuickSort is a recursive sorting algorithm that allows to sort a list in o(nlog(n)), n being the length of the list. The steps of the algorithm are as follow:
* Pick an element of the array that will be the pivot (here we'll just pick the last element of the array);
* *Partition* the array in 3 parts: all elements smaller than the pivot, the pivot itself, and all elements greater than the pivot;
* Recursively apply the QuicSort to both sub arrays.

## The code
Now that you're familiar let's get to coding! We'll be coding 4 functions:
* *sort* makes a call to the QuickSort algorithm;
* *quickSort* recursively sorts the sub arrays;
* *partition* picks the pivot (last element of the array), and swaps it before the pivot if it's smaller than the pivot;
* *swap* which performs the swapping.

{% initial %}
pragma solidity ^0.4.24;

contract QuickSort {

    function sort(uint[] data) public constant returns(uint[]){
        // If array is empty
        if (data.length==0) {return; }
        // Call quickSort with the relevant arguments
        quickSort(data, , );
        return data;
    }

    function quickSort(uint[] memory data, int iLeft, int iRight) private{
        if (iLeft<iRight) {
            // Call partition with the relevant arguments
            int part = partition(data, , );
            // Make two calls to quickSort to sort the two sub-arrays
        }
    }

    function partition(uint[] memory data, int iLeft, int iRight) private returns(int){
        uint pivot = data[uint(iRight)];
        // Initialize the integer integer i
        int i =

        for (int j=iLeft; j<iRight; j++){
            // Fill in the condition
            if (){
                i++;
                swap(data, i, j);
            }
        }
        swap(data, iRight, i+1);

        // Return the index of the new location of the pivot
    }

    function swap(uint[] memory data, int i, int j) private{
        // Complete to swap two elements of an array
    }

}

{% solution %}
pragma solidity ^0.4.24;

contract QuickSort {

    function sort(uint[] data) public constant returns(uint[]){
        if (data.length==0) {return; }
        quickSort(data, int(0), int(data.length-1));
        return data;
    }

    function quickSort(uint[] memory data, int iLeft, int iRight) private{
        if (iLeft<iRight) {
            int part = partition(data, iLeft, iRight);
            quickSort(data, iLeft, part-1);
            quickSort(data, part+1, iRight);
        }
    }

    function partition(uint[] memory data, int iLeft, int iRight) private returns(int){
        uint pivot = data[uint(iRight)];
        int i = iLeft-1;

        for (int j=iLeft; j<iRight; j++){
            if (data[uint(j)]<=pivot){
                i++;
                swap(data, i, j);
            }
        }
        swap(data, iRight, i+1);
        return i+1;
    }

    function swap(uint[] memory data, int i, int j) private{
        uint tmp = data[uint(i)];
        data[uint(i)] = data[uint(j)];
        data[uint(j)] = tmp;
    }

}

{% validation %}
// Tests need proper pragma
pragma solidity ^0.4.24;

// Assert library is available here
import 'Assert.sol';
// Import contracts, filenames should match contract names given in the solution
import 'QuickSort.sol

contract TestQuickSort{
	// Declare variable associated to the contract you want to test
	// __ADDRESS__ specifies the contract is the one provided at runtime by the user
	Contract deployedContract = Contract(__ADDRESS__);

	// test function
	// IMPORTANT: only one assertion per function
	function testPartition() public {
	uint[] data = [3,2,1];
	uint expected = deployedContract.partition(data,0,2);
	Assert.equal(result, expected, "Partition is not properly implemented");
	}

	function testSwap() public {
	uint[] data = [3,2,1];
        deployedContract.swap(data,0,2);
        uint[] expected = [3,2,1];
        Assert.equal(result, expected, "Swap is not properly implemented");
	}

	function testSort1() public {
	uint[] data = [3,2,1];
        deployedContract.quickSort(data,0,2);
        uint[] expected = [1,2,3];
        Assert.equal(result, expected, "QuickSort is not properly implemented");
	}

	function testSort2() public {
        uint[] data = [2,1,3];
        deployedContract.quickSort(data,0,2);
        uint[] expected = [1,2,3];
        Assert.equal(result, expected, "QuickSort is not properly implemented");
        }

	function testSort3() public {
	uint[] data = [1,2,3];
	deployedContract.quickSort(data,0,2);
        uint[] expected = [1,2,3];
        Assert.equal(result, expected, "QuickSort is not properly implemented");
        }

	// event to communicate with the web interface
	event TestEvent(bool indexed result, string message);
}

## Going further
Now that you've implemented the QuickSort algorithm in Solidity, you can go further and implement [other popular sorting algorithms](https://en.wikipedia.org/wiki/Sorting_algorithm)!

{% endexercise %}
