/* Practice how to use closure
 * Coder: Shawn
 *
 * Follow the channel: lets build that app
 */

import UIKit

func filterGreaterThanValue(value:Int,numbers:[Int])->[Int]
{
    var filteredList = [Int]()
    
    for num in numbers
    {
        if num > value
        {
            filteredList.append(num)
        }
    }
    
    return filteredList
}

//better way to modify the function name is to introduce a conditional phrase
func filterWithPradicateColusre(colusre:(Int)->Bool,numbers:[Int])->[Int]
{
    var filteredList = [Int]()
    
    for num in numbers
    {
        if colusre(num)
        {
            filteredList.append(num)
        }
    }
    
    return filteredList
}

//Beside, colusre also chould pass in a function
func greaterThanThree(num:Int)->Bool
{
    return num > 3
}

let fileredList = filterWithPradicateColusre(colusre: greaterThanThree(num:), numbers: [1,2,3,4,5,6,7,8,9,10])

//let fileredList = filterWithPradicateColusre(colusre: { (num) -> Bool in
//    return num < 5
//}, numbers: [1,2,3,4,5,6,7,8,9,10])

//let filteredList = filterGreaterThanValue(value: 5, numbers: [1,2,3,4,5,6,7,8,9,10])
//print(filteredList)

