import UIKit
import Foundation

func SearchingChallenge(_ str: String) -> String {
  let array = str.lowercased().split(separator:" ")
    print(array)
  var couunt = 0
  var word = "No words"

  for item in array.enumerated(){
    print(item.element)
    for j in 0..<item.element.count{
        var newCount = 0
        for b in j+1..<item.element.count{
            if(Array(String(item.element))[j] == Array(String(item.element))[b]) {
                newCount += 1
            }
        }
        if(newCount > couunt) {
            couunt = newCount
            word = String(item.element)
        }
        return word
    }

  }
return ""
}

// keep this function call here
print(SearchingChallenge("Hello apple pie"))
