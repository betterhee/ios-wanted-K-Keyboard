# K-Keyboard





# Screenshot

| 테마 정보 페이지 | 한글 쿼티 키보드 |
| ---------------- | ---------------- |
|![](https://user-images.githubusercontent.com/73588175/194691790-20405a2b-9c02-4ed5-a7b0-746c0c2a54f8.gif)|![](https://user-images.githubusercontent.com/73588175/194692226-4552713b-4df8-4c39-8ede-4afff2f3889d.gif)|
<br>
<br>


# Feature
### 테마 정보 페이지
다양한 사이즈의 화면에서 레이아웃이 깨지지 않게 표시  
다양한 기기에서  
<img width="200" alt="스크린샷 2022-10-08 오후 2 38 17" src="https://user-images.githubusercontent.com/73588175/194692327-6d530fd7-919b-48c6-85f6-f2c348fbae88.png">
<img width="200" alt="스크린샷 2022-10-08 오후 2 38 26" src="https://user-images.githubusercontent.com/73588175/194692329-d22705ee-567e-4c12-806a-22951cafa4b8.png">
<img width="200" alt="스크린샷 2022-10-08 오후 2 38 39" src="https://user-images.githubusercontent.com/73588175/194692331-d99370b8-e6a9-41c0-ac3d-d10f685bc9c1.png">
<br>

다양한 글씨크기   
<img width="200" alt="스크린샷 2022-10-08 오후 2 46 40" src="https://user-images.githubusercontent.com/73588175/194692814-fabcc65b-d1ba-4de5-8875-b148a6c996a4.png">
<img width="200" alt="스크린샷 2022-10-08 오후 2 47 52" src="https://user-images.githubusercontent.com/73588175/194692818-b4638645-da99-4787-a7f3-362a26895ad1.png">
<img width="200" alt="스크린샷 2022-10-08 오후 2 47 37" src="https://user-images.githubusercontent.com/73588175/194692821-f72dc3d8-2954-4557-a588-03bc0892cfc6.png">
<br>
<br>
<br>

### 한글 쿼티 키보드
한글 입력 시 낱자의 결합, 이동, 음절 분리 같은 동작을 수행하기위해 조합 중인 텍스트(inputTextBuffer)와 조합이 완료된 텍스트(inputText)를 별도로 저장하고, 조합 중인 텍스트의 상태를 세분화

```swift
/// 조합이 완료된 입력 텍스트
private var inputText: String
/// 입력 텍스트 중 현재 조합 중인 텍스트를 처리하기 위한 임시 저장 공간
private var inputTextBuffer: HangulComponents
/// 현재 조합 중인 텍스트의 상태
private var state: State
/// 현재 조합 중인 텍스트와 조합이 완료된 텍스트
private var outputText: String {
  inputText + inputTextBuffer.toSyllabel
}

enum State: String {
  /// 버퍼가 비워진 상태
  case none
  /// 버퍼에 초성이 있는 상태
  case leadingConsonant
  /// 버퍼에 초성과 홑모음 중성이 있는 상태
  case leadingConsonantAndSingleVowel
  /// 버퍼에 초성과 겹모음 중성이 있는 상태
  case leadingConsonantAndDoubleVowel
  /// 버퍼에 초성, 중성과 홑받침이 있는 상태
  case leadingConsonantAndVowelAndSingleTrailingConsonant
  /// 버퍼에 초성, 중성, 겹받침이 있는 상태
  case leadingConsonantAndVowelAndDoubleTrailingConsonant
  /// 버퍼에 홑모음 중성이 있는 상태
  case singleVowel
  /// 버퍼에 겹모음 중성이 있는 상태
  case doubleVowel
}    
```
<br>


조합 단계에서 낱자의 결합이 유효한지 판단

```swift
// 버퍼에 초성과 홑모음 중성이 있는 상태
case .leadingConsonantAndSingleVowel:
    if !value.isVowel {
        inputTextBuffer.addComponent(value, for: .trailingConsonant)
        state = .leadingConsonantAndVowelAndSingleTrailingConsonant
    } else {
          // 버퍼의 홑모음 중성과 입력한 홑모음 중성을 결합하여 유효한 겹모음을 만들 수 있는지 확인
        if (inputTextBuffer.vowel.firstCharacterAsString + value).isVowel {
              // 유효한 겹모음일 경우 조합 중인 글자에 추가
            inputTextBuffer.addComponent(value, for: .vowel)
            state = .leadingConsonantAndDoubleVowel
        } else {
              // 유효하지 않은 겹모음인 경우 조합을 끝내고 새로운 조합을 시작
            flush()
            inputTextBuffer.addComponent(value, for: .vowel)
            state = .singleVowel
        }
    }
```
<br>
<br>

# Development Tool

-   Frameworks: UIKit, Custom Keyboard Extension
-   Tools: Xcode 16
-   Language: Swift 5
<br>
<br>


# Contributors

| dahee (홍다희)                                               | Sole (진연서)                                  |
| :----------------------------------------------------------- | :--------------------------------------------- |
| [![betterhee](https://github.com/betterhee.png?size=100)](https://github.com/betterhee) |<img width="100" alt="스크린샷_2022-10-08_오후_3 35 44-removebg-preview" src="https://user-images.githubusercontent.com/73588175/194693573-247786a2-9893-447f-af4a-0bdb512b0c30.png">|
| - 키보드 기능구현                                                | - UI 구현                                           |

