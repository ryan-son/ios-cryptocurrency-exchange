# 프로젝트 소개

[Bithumb Public API](https://apidocs.bithumb.com/docs/api_info)를 통해 가상화폐 정보를 제공하는 애플리케이션을 제작합니다.

- 메인 화면을 통해 전체, <<관심 및 인기 코인>> 목록을 확인할 수 있습니다.
- 메인 화면의 코인 목록에서는 현재가와 변동률 정보를 제공합니다.
- 목록에서 코인을 선택하면 <<1분/10분/30분/1시간>>/일 단위 가격 변동 내역과 실시간 가격 변화를 캔들스틱 차트를 통해 표시합니다.
- <<차트에 표시되는 정보는 로컬 DB를 통해 관리합니다.>>
- 호가정보창을 통해 실시간 매수/매도 내역을 제공합니다.
- 체결정보창을 통해 실시간 체결 내역을 제공합니다.
- <<가상 자산의 입출금 가능 현황 정보를 제공합니다.>>

# Tools

## 개발환경 및 타겟 OS

- Swift 5.5
- Xcode 13.2.1
- iOS 14.0

## 기술

본 프로젝트에서는 TCA를 이용한 이벤트 처리, SwiftUI를 이용한 UI 구성 및 내비게이션 처리, Combine을 이용한 반응형 프로그래밍에 집중하기 위해 아래와 같은 라이브러리를 활용하였습니다.

| 구분                      | 기술                                                         | 버전   |
| ------------------------- | ------------------------------------------------------------ | ------ |
| UI / Reactive Programming | SwiftUI / Combine                                            |        |
| 아키텍처 프레임워크       | [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture) | 0.33.1 |
| 네트워크 (REST)           | [Moya](https://github.com/Moya/Moya)                         | 15.0.0 |
| 네트워크 (WebSocket)      | [Starscream](https://github.com/daltoniam/Starscream)        | 4.0.4  |
| 차트                      | [Charts](https://github.com/danielgindi/Charts)              | 3.6.0  |
| Image Fetching / Caching  | [KingFisher](https://github.com/onevcat/Kingfisher)          | 7.2.0  |
| Unit Test                 |                                                              |        |

### 왜 이 기술들에 집중하고자 했나요?

TCA는 사용자와의 상호작용, 데이터 변화와 같은 이벤트를 단방향으로 처리하는 Redux 패턴의 구현체이며, SwiftUI, Combine, UIKit, RxSwift 등의 기술을 범용적으로 적용하여 사용할 수 있기에 기존에 RxSwift, RxCocoa와 함께 사용되던 ReactorKit을 대체하는 기술로 인식되고 있습니다. 따라서 향후 프로덕트 개발에 SwiftUI와 Combine을 활용하는 시점이 다가올수록 커뮤니티가 더욱 강력해질 것이고, 활용 규모가 더욱 넓어질 것이라 판단하였습니다.

SwiftUI는 현재 웹 프론트엔드의 React, 안드로이드의 JetPack Compose와 같이 선언형으로 UI를 작성하는 방식으로, Apple에서 제공하는 UI 개발 프레임워크이므로 향후 UIKit과 병행하여 사용하거나, 대체할 기술로 인식되고 있습니다.

Combine도 SwiftUI와 마찬가지로 Apple이 제공하는 First party 프레임워크이며, 기존에 사용되던 RxSwift, ReactiveSwift를 대체할 기술로 인식되고 있습니다.

# 주요기능 미리보기

| 코인 목록 | 현재가 및 차트 | 체결정보 | 호가정보 |
| --------- | -------------- | -------- | -------- |
| // gif    |                |          |          |



# 애플리케이션 구조

Clean architecture 구조에 따라 Data source, Repository, Domain, Presentation Layer로 나누었습니다. 각 레이어의 역할은 아래와 같습니다.

![image](https://user-images.githubusercontent.com/69730931/158045051-b2ef173b-27ad-431a-a30e-9cecbbb6fc01.png)

| 구분         | 역할                                                         |
| ------------ | ------------------------------------------------------------ |
| Data source  | 네트워크와 로컬 DB에서의 데이터 제공을 담당합니다.           |
| Repository   | Data source에서 제공한 데이터를 Domain 레이어와 이어주는 역할을 수행합니다. 이 과정에서 데이터의 출처를 추상화합니다. |
| Domain       | 앱의 핵심 비즈니스 로직을 수행합니다. 목적 사용 케이스에 따라 비즈니스 로직이 분리되어 있습니다. 이 과정에서 Repository를 통해 전달받은 데이터를 앱이 제공하는 핵심 비즈니스 로직에서 활용하는 엔티티 형태로 변환합니다. |
| Presentation | Domain 레이어에서 목적에 맞게 가공된 데이터를 제공받아 화면에 표시하는 역할을 수행합니다. 화면에 최종적으로 보여줄 내용을 가공하기 위해 상태와 액션, 의존하는 환경을 정의하여 사용하며, 사용자와의 상호작용, 데이터 변화 등의 이벤트를 단방향의 Redux 패턴으로 수행합니다. |

## 이렇게 구조를 구성한 이유는 무엇인가요?

각 레이어를 역할에 따라 분리하여 타입의 인터페이스(수신한 내용과 전달할 내용)에 집중할 수 있는 환경을 조성함으로써 프로토콜 주도 개발

# 화면 구현 상세

## 코인 목록 화면

### 기능



### 구조



### 개선할 수 있는 점





## 현재가 및 차트 화면

### 기능



### 구조



### 개선할 수 있는 점





## 체결 정보 화면

### 기능



### 구조



### 개선할 수 있는 점



## 호가 정보 화면

### 기능



### 구조



### 개선할 수 있는 점





## 팀 구성



